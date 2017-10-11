/*
* Wei - 10/29/2010 for multiple pci entries
*
*/

CQ.form.PCIEntries =  CQ.Ext.extend(CQ.form.SmartImage, {
//CQ.form.PCIEntries =  CQ.Ext.extend(CQ.form.CompositeField, {
       /**
     * @cfg {String} fileReferencePrefix
     * Prefix to be used to address a single slide; use the '$' placeholder to integrate the
     * internal slide number (defaults to "./entry$")
     */
    fileReferencePrefix: null,

    /**
     * Head panel with slideshow specific functionality
     * @type CQ.form.Slideshow.SlidesPanel
     * @private
     */
    headPanel: null,

    /**
     * Array that contains all currently defined slides
     * @type CQ.form.Slideshow.Slide[]
     * @private
     */
    slides: null,

    /**
     * The currently edited slide
     * @type CQ.form.Slideshow.Slide
     * @private
     */
    editedSlide: null,

    /**
     * Panel to preselect. This is part of a workaround for an Ext bug regarding IE.
     * @type CQ.Ext.Container
     * @private
     */
    activeTabToPreselect: null,
    
    /**
     * Name field. See bug# 25253.
     * @private
     */
    name: "",
    
    footPanel: null,
      
    constructor: function(config) {

        config = config || { };
        
        var defaults = {
           
           
           "headPanel": new CQ.form.PCIEntries.PCISlidesPanel({ 
                "onSlideChanged": this.onSlideChanged.createDelegate(this),
                "onAddButton": this.onAddButton.createDelegate(this),
                "onRemoveButton": this.onRemoveButton.createDelegate(this)
            }),
            
            "footPanel": new CQ.form.PCIEntries.PCIEntryPanel({ }),  
            "fileReferencePrefix": "./pci/entry$"
        };

        CQ.Util.applyDefaults(config, defaults);
     
        CQ.form.PCIEntries.superclass.constructor.call(this, config);

        this.slides = [ ];
    },

    /**
     * Initializes the component.
     * @private
     */
    initComponent: function() {
    
        CQ.form.PCIEntries.superclass.initComponent.call(this);
    },

     /**
     * Handles workarounds for some browser issues after the component has been rendered.
     * @private
     */
    afterRender: function() {
      
        CQ.form.PCIEntries.superclass.afterRender.call(this);
        if (this.fixedHeight == null) {
            if (CQ.Ext.isIE) {
                // This is a workaround for another nasty 0-height layout bug that occurs
                // when using a border layout on a tab and the dialog is hidden/reshown
                // again with the active tab not being not the one containing the one
                // with the border layout. The problem is IE-only.
                var dialog = this.findParentByType("dialog");
                dialog.on("beforehide", function() {
                    var compToCheck = this.ownerCt;
                    var tabToSelect = this;
                    while (compToCheck && !compToCheck.isXType("tabpanel")) {
                        tabToSelect = compToCheck;
                        compToCheck = compToCheck.ownerCt;
                    }
                    if (compToCheck) {
                        this.activeTabToPreselect = compToCheck.getActiveTab();
                        compToCheck.setActiveTab(tabToSelect);
                    }
                }, this);
            }
        }
    },
    
    // Handler -----------------------------------------------------------------------------

    /**
     * Handler that reacts on changes in the slide selector component.
     * @param {CQ.form.Slideshow.Slide} slide The newly selected slide
     * @private
     */
    
    onSlideChanged: function(slide) {
       var duplicateFlag = this.saveChanges();
        
       this.editedSlide = slide;
       if (this.editedSlide) {
         this.showSlide(this.editedSlide);
       }
        
       this.buildComboBoxContent(duplicateFlag, "change");
    },

    /**
     * Handler that reacts on clicking the "Add" button.
     * @private
     */
    
    onAddButton: function() {
        var duplicateFlag = this.addNewSlide(1);
        this.buildComboBoxContent(duplicateFlag, "add");
    },
    
     /**
     * Adds a new slide and makes it the one that is currently edited.
     */
    addNewSlide: function(addNewSlideFlag) {
       //addNewSlideFlag - 1 for checking if there is no category selected
       //0 - don't checking when process init
        
       //wei - build combobox - auto set to New Entry before Add
       var data = [ ];
       
       for (var i = 0; i < this.slides.length; i++) {
            var slide = this.slides[i];
            if (!slide.title) {
                this.editedSlide = slide;  
            }        
            if (!slide.isDeleted) {
                data.push({
                    "value": slide,
                    "text": slide.createDisplayText()
                });
            }
        }
       this.headPanel.setInitialComboBoxContent(data);
       this.headPanel.select(this.editedSlide);
       this.doLayout();
          
       var duplicateFlag = this.saveChanges(1);
       
       if (duplicateFlag == "noDuplicates" && addNewSlideFlag == 1) {
           alert("Please select a Category");
       } else if (duplicateFlag == "noDuplicates" && addNewSlideFlag == 0) {
           ;
       } else {
           var slideIndex = this.createSlideIndex();
           var slideCreated = this.createSlide(null, slideIndex, this.dataPath);
           this.showSlide(slideCreated);
           this.editedSlide = slideCreated;
       }
       return duplicateFlag;
    },
    
     /**
     * Removes the currently edited slide. If no more slides are defined after the
     * removal, a new empty slide is added.
     */
    removeSlide: function(flag) {
        if (this.editedSlide) {
            if (this.editedSlide.title) {
                this.editedSlide.isDeleted = true;
                var firstSlide = this.getFirstSlide();
             
                if (!firstSlide) {
                    this.addNewSlide(1);
                } else {
                    this.editedSlide = firstSlide;
                    this.showSlide(this.editedSlide);
                }
            } else if (this.editedSlide.displayType || this.editedSlide.publishDate) {
                this.editedSlide.isDeleted = true;
               
               //add new slide
                this.savechanges();
                var slideIndex = this.createSlideIndex();
                var slideCreated = this.createSlide(null, slideIndex, this.dataPath);
                this.showSlide(slideCreated);
                this.editedSlide = slideCreated;
            } else {
                if (flag != 0) 
                    alert("You can't delete the New Entry");
            }
        }
    },
    
    /**
     * Saves changes made in the UI to the underlying data model.
     * @private
     */
    saveChanges: function(deleteFlag) {
        var duplicateFlag;
        
        if (this.editedSlide) {
                  
           var title = this.footPanel.getTitle();
           this.editedSlide.title = (title ? title : null);
           
           // more pci entry fields 
           var category = this.footPanel.getCategory();
           this.editedSlide.category = (category ? category : null);
         
           var view = this.footPanel.getView();
           this.editedSlide.view = (view ? view : null);
           
           var ctitle = this.footPanel.getCTitle();
           this.editedSlide.ctitle = (ctitle ? ctitle : null);
                 
           var description = this.footPanel.getDescription();
           this.editedSlide.description = (description ? description : null);
               
           var displayType = this.footPanel.getDisplayType();
           this.editedSlide.displayType = (displayType ? displayType : null);
           
           var publishDate = this.footPanel.getPublishDate();
           this.editedSlide.publishDate = (publishDate ? publishDate : null);
          
           duplicateFlag = this.headPanel.updateSlide(this.editedSlide, deleteFlag);
        }
                
        return duplicateFlag;
    },
    
     /**
     * Build the selector's entries.
     * @private
     */
    buildComboBoxContent: function(duplicateFlag, actionFlag) {

      
       var data = [ ];
       var temp; 
       var titleView;
       var removeFlag='';
       var slideViews;
                                

       for (var i = 0; i < this.slides.length; i++) {
            var slide = this.slides[i];
           
            if (!slide.isDeleted) {
                //wei - check duplicates
              
               if (slide.view) {
               
                    if (slide.view.indexOf(",") != -1) {
                      
                        slideViews = slide.view.split("\,");
                        
                        for (var j=0; j<slideViews.length; j++)  {
                            if (slide.createDisplayText().indexOf("...") != -1) {
                                 var categoryStr = slide.createDisplayText().split("|");
                                 titleView = categoryStr[0] + ":" + slideViews[j];
                            } else 
                                titleView =  slide.createDisplayText() + ":" + slideViews[j];
                                
                            if (duplicateFlag && duplicateFlag.indexOf(titleView) != -1) {
                                if (removeFlag.indexOf(titleView) == -1) 
                                    removeFlag = removeFlag + "," + titleView;    
                            }
                        }
                    } else {   
                        if (slide.createDisplayText().indexOf("...") != -1) {
                            var categoryStr = slide.createDisplayText().split("|");
                            titleView = categoryStr[0] + ":" + slide.view;
                        } else 
                            titleView = slide.createDisplayText() + ":" + slide.view;
                        
                        if (duplicateFlag && duplicateFlag.indexOf(titleView) != -1)
                            removeFlag = titleView;
                    }
                } 
                
                var allowedFlag = slide.createDisplayText() + "allowed";
                
                if (duplicateFlag && duplicateFlag.indexOf(allowedFlag) != -1){
               


                  
                   //need to parse back to Date to fix the PM issue
                    var newDate = new Date(slide.publishDate);
                    var dateStr = newDate.getDate();
                    var monthStr = newDate.getMonth() + 1;
                    var yearStr = newDate.getFullYear();
                      
                    var formatedDateStr=monthStr + "/" + dateStr + "/" + yearStr;
                    
                    var titleHolder = "notitle";
                    if (slide.ctitle) 
                        titleHolder = slide.ctitle;
                        
                    temp = slide.createDisplayText() + "|" + formatedDateStr + "|" + titleHolder.substring(0,7) + "...";
                   
                    //reset slide title
                    slide.title=temp;
               
                } else {
                    temp = slide.createDisplayText();
                }   
               
                data.push({
                    "value": slide,
                    "text": temp

                });
              
            }
        }
            
        if (removeFlag && (actionFlag == "add")) {
            removeFlag = removeFlag.replace(/^\,/, "");
            alert("You can't add multiple " + removeFlag + ". Your old entry with " + removeFlag + " has been deleted.");
        }
           
        if (actionFlag != "change"){
            this.headPanel.setInitialComboBoxContent(data);
            this.headPanel.select(this.editedSlide);
        }
    },
    
    
    /**
     * Shows the specified slide.
     * @param {CQ.form.Slideshow.Slide} slide The slide to be shown
     * @private
     */
    showSlide: function(slide) {
      this.footPanel.setTitle(slide.title);
           
      //more pci entry fields
      this.footPanel.setCategory(slide.category);
     
      this.footPanel.setView(slide.view);
      
      this.footPanel.setCTitle(slide.ctitle);
      
      this.footPanel.setDescription(slide.description);
      
      this.footPanel.setDisplayType(slide.displayType);
      
      this.footPanel.setPublishDate(slide.publishDate);
      
      this.doLayout();
     
     },
    
     /**
     * Creates a suitable slide index for a new pci entry.
     * @private
     * @return {Number} The slide index
     */
    createSlideIndex: function() {
    
        var slide;
        var slideCnt = this.slides.length;
        var maxSlideIndex = 0;
        for (var index = 0; index < slideCnt; index++) {
            slide = this.slides[index];
            if (!slide.isDeleted && (slide.slideIndex > maxSlideIndex)) {
                maxSlideIndex = this.slides[index].slideIndex;
            }
        }
        for (var slideIndex = 1; slideIndex <= maxSlideIndex; slideIndex++) {
            var hasIndex = false;
            for (var checkIndex = 0; checkIndex < slideCnt; checkIndex++) {
                slide = this.slides[checkIndex];
                if (!slide.isDeleted && (slide.slideIndex == slideIndex)) {
                    hasIndex = true;
                    break;
                }
            }
            if (!hasIndex) {
                return slideIndex;
            }
        }
        return maxSlideIndex + 1;
    },
    
    
     /**
     * Gets the first slide.
     * @private
     * @return CQ.form.Slideshow.Slide
     */
    getFirstSlide: function() {
       
        var slideCnt = this.slides.length;
        for (var slideIndex = 0; slideIndex < slideCnt; slideIndex++) {
            var slide = this.slides[slideIndex];
            
            if (!slide.isDeleted) {
                return slide;
            }
        }
        return null;
    },
    
     /**
     * Creates a new slide. The view is not updated.
     * @private
     * @return {CQ.form.Slideshow.Slide The slide
     */
    createSlide: function(data, slideIndex, basePath) {
        // todo parameter names should not be hardcoded (but the SWF currently requires it)
              
        var title = (data ? data["EntryTitle"] : null);
        var category = (data ? data["Category"] : null);
        var view = (data ? data["View"] : null);
        var ctitle = (data ? data["Title"] : null);
        var description = (data ? data["Description"] : null);
        var displayType = (data ? data["DisplayType"] : null);
        var publishDate = (data ? data["PublishDate"] : null);
       
        var slide;
  
        if (data) {
            // add existing slide
            
            slide = new CQ.form.PCIEntries.PCISlide({
                    "title": title,
                    "category": category,
                    "view": view,
                    "ctitle": ctitle,
                    "description": description,
                    "displayType": displayType,
                    "publishDate": publishDate,
                    "slideIndex": slideIndex,
                    "isPersistent": true,
                    "isDeleted": false
                });
         } else {
       
            // create new slide
            slide = new CQ.form.PCIEntries.PCISlide({
                "title": null,
                "category": category,
                "view": view,
                "ctitle": ctitle,
                "description": description,
                "displayType": displayType,
                "publishDate": publishDate,
                "slideIndex": slideIndex,
                "isPersistent": false,
                "isDeleted": false
            });
        }
        
        this.slides.push(slide);
        return slide;
    },
    
    /**
     * Inits 
     ing the record
     * @param {String} path The content path of the slideshow instance being edited
     * @private
     */
    
    //this method name was changed from processInit in 5.4
    
   processPath: function(path) {
        this.dataPath = path;
        this.slides.length = 0;
        CQ.form.PCIEntries.superclass.processPath.call(this, path);

        // create default slide
        this.slides.length = 0;
        this.addNewSlide(0);
        this.showSlide(this.editedSlide);

        this.buildComboBoxContent(null, null);
    },
    
     
     /**
     * Sets the value of the field using the given record. If no according value
     * exists the default value is set. This method is usually called by
     * {@link CQ.Dialog#processRecords}.
     * @param {CQ.Ext.data.Record} record The record
     * @param {String} path The content path the record was created from (used for resolving
     *        relative file paths)
     */
     processRecord: function(record, path) {
       var key;
       var firstSlide;
       
        if (this.fireEvent('beforeloadcontent', this, record, path) !== false) {
                      
            this.dataPath = path;
            this.slides.length = 0;

            // initialize only, as record processing for this dynamic widget is handled
            // completely different
            CQ.form.PCIEntries.superclass.processPath.call(this, path);
         
            // parse all slides from record
            // todo use a better implementation after slideshow.swf has been updated
            var prefix = this.fileReferencePrefix.replace("./pci/", "");
            
            var placeholderPos = prefix.indexOf("$");
                       
            var prefixLen = prefix.length;
            var part1 = prefix;
            var part2 = null;
            var hasPlaceholder = (placeholderPos >= 0);
            if (placeholderPos == 0) {
                part1 = null;
                part2 = prefix.substring(1, prefixLen);
            } else if (placeholderPos > 0) {
                
                if (placeholderPos < (prefixLen - 1)) {
                    part1 = prefix.substring(0, placeholderPos);
                    part2 = prefix.substring(placeholderPos + 1, prefixLen);
                } else {
                    part1 = prefix.substring(0, placeholderPos);
                    part2 = null;
                }
            }
            var pcisubrec= record.get('pci');
            if(pcisubrec){
                var data=pcisubrec;
                var count = 0;
                         
                for (key in data) { 
                    if (key.indexOf("entry") != -1) {
                        count++; 
                    }                  
                    if (hasPlaceholder) {
                        var isMatching = true;
                        var indexPos;
                        var part2Pos = key.length;
                        
                        if (part1 != null) {
                            if (key.indexOf(part1) == 0) {
                                indexPos = part1.length;
                            } else {
                                isMatching = false;
                            }
                        }
                        
                        if ((part2 != null) && isMatching) {
                            part2Pos = key.indexOf(part2, indexPos);
                         
                            if (part2Pos > indexPos) {
                                if ((part2Pos + part2.length) < key.length) {
                                    isMatching = false;
                                }
                            } else {
                                isMatching = false;
                            }
                        }
                        
                        if (isMatching) {
                            this.createSlide(
                                    data[key], key.substring(indexPos, part2Pos), path);                       
                        }
                    } else if (key == part1) {
                         this.createSlide(data[key], 1, path);
                    }
                }
            }//has pci data

            // select slide to edit
            this.editedSlide = this.getFirstSlide();
            if (!this.editedSlide) {
                this.addNewSlide(0);
            }
            this.showSlide(this.editedSlide);
            
            // initialize combobox
            this.buildComboBoxContent(null, null);
            
            //following code is for deal with the existing data, like AU existing data which doesn't have a New Entry
            this.doLayout();
            
            // wei - following is for the existing data       
           if (count == 1 && key == 'entry1') {
           
                //if there is a first slide with entry data
                firstSlide = this.getFirstSlide();
                if (firstSlide.category) {
                                     
                    //generate New Entry
                    this.addNewSlide(0);
                
                    this.editedSlide = this.getFirstSlide();
                    this.showSlide(this.editedSlide);
                    this.buildComboBoxContent(null, null);
                  
                    //again - for copying the existing entry (this is because the data has different types, like PublishData...
                    this.doLayout();
                    this.addNewSlide(0);
                
                    this.editedSlide = this.getFirstSlide();
                    this.showSlide(this.editedSlide);
                    this.buildComboBoxContent(null, null);
                   
                    //remove the first one - remove the entry with the old types
                    //get first slide
                    this.doLayout();
                    this.editedSlide = firstSlide;
                    if (this.editedSlide) {
                        this.removeSlide(0);
                    }
                    this.buildComboBoxContent(null, null);
                } else {
                    this.editedSlide = firstSlide;
                    if (this.editedSlide) {
                        this.removeSlide(0);
                    }
                    this.buildComboBoxContent(null, null);
                }
            }
            //end for existing data            
              
            this.fireEvent('loadcontent', this, record, path);
            
        }
       
    },
    
      /**
     * @private
     */
    createHiddenInterfaceFields: function() {
        // prevent SmartFile from creating any form interface, as Slideshow will have
        // to implement its own, dynamic version
        
        // create some of the hidden fields anyway from SmartFile
        // see bug# 25253 for details
        this.lastModifiedParameter = new CQ.Ext.form.Hidden( {
            "disabled": true,
            "value": ""
        });
        this.containerPanel.add(this.lastModifiedParameter);
        this.lastModifiedByParameter = new CQ.Ext.form.Hidden( {
            "disabled": true,
            "value": ""
        });
        this.containerPanel.add(this.lastModifiedByParameter);
    },
    
    /**
     * Creates all interface form fields that are required to transfer the entire
     * slideshow to the server.
     * @param {CQ.Ext.Element} ct The container element the form fields must be created to
     * @private
     */
    createInterface: function(ct) {
        
        if (!this.interfaceFields) {
            this.interfaceFields = [ ];
        } else {
            this.interfaceFields.length = 0;
        }
        var slideCnt = this.slides.length;
        
        var count = 0;        
        for (var slideIndex = 0; slideIndex < slideCnt; slideIndex++) {
            var slide = this.slides[slideIndex];
                      
            var fields = slide.createTransferFields(this.fileReferencePrefix);
            var fieldCnt = fields.length;
            for (var fieldIndex = 0; fieldIndex < fieldCnt; fieldIndex++) {
                 // alert("fieldIndex=" + fieldIndex);
                 var field = fields[fieldIndex];
                 field.render(ct);
                 this.interfaceFields.push(field);
            }
         }
      },


     /**
     * Removes all existing interface form fields.
     * @private
     */
    removeOldInterface: function() {
        if (this.interfaceFields) {
            var fieldCnt = this.interfaceFields.length;
            for (var fieldIndex = 0; fieldIndex < fieldCnt; fieldIndex++) {
                var field = this.interfaceFields[fieldIndex];
                field.getEl().remove();
            }
            this.interfaceFields.length = 0;
        }
    },
    
    
 /**
     * See {@link CQ.form.SmartFile#onBeforeSubmit}.
     * @private
     */
    onBeforeSubmit: function() {

        this.removeOldInterface();
        this.createInterface(this.el);
      
        return true;
    },
    
    /**
     * Handler that reacts on clicking the "Remove" button.
     * @private
     */
    
    onRemoveButton: function() {
        if (this.editedSlide) {
            this.removeSlide();
        }
        
        var duplicateFlag = this.headPanel.updateSlideForRemove();
        this.buildComboBoxContent(duplicateFlag, null);
    }

});

// register xtype

    CQ.Ext.reg('pcientries', CQ.form.PCIEntries);

CQ.form.PCIPublish = CQ.Ext.extend(CQ.form.Selection, {
        
    constructor : function(config){
        CQ.form.PCIPublish.superclass.constructor.call(this, config);
    }
}
);
CQ.Ext.reg("pcipublish", CQ.form.PCIPublish); 