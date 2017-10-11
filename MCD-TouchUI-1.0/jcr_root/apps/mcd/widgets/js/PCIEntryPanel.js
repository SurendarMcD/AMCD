/**
 * @class CQ.form.PCIEntries.PCIEntryPanel
 * @extends CQ.Ext.Panel
 * @private
 * The PCIEntryPanel provides the UI to edit the pci entry of each slide.
 * @constructor
 * Creates a new PCIEntryPanel.
 * @param {Object} config The config object
 * Created by Wei Wu
 */
CQ.form.PCIEntries.PCIEntryPanel = CQ.Ext.extend(CQ.Ext.Panel, {
   
     /**
     * @private
     * @type CQ.Ext.form.Combox
     */
     categoryLabelField: null,
     categoryField: null,
     
     /**
     * @private
     * @type CQ.Ext.form.Checkbox
     */
     viewLabelField: null,
     viewField:null,
     
     /**
     * @private
     * @type CQ.Ext.form.TextField
     */
     titleLabelField: null,
     titleField: null,
     titleLabelFieldDescription: null, 
     
     /**
     * @private
     * @type CQ.Ext.form.TextArea
     */
     descriptionLabelField: null,
     descriptionField: null,
     descriptionLabelFieldDescription: null, 
        
     /**
     * @private
     * @type CQ.form.DateTime
     */
     publishDateLabelField:null,
     publishDateField:null,
     publishDateLabelFieldDescription: null, 
     
     /**
     * @private
     * @type CQ.Ext.form.Checkbox
     */
     displayTypeLabelField: null,
     displayTypeField: null,
            
     constructor: function(config) {
              
        config = config || { };
        
        var defaults = {
            "stateful": true,
            "height": "400",
            "layout" : "form"
        };
       
        CQ.Util.applyDefaults(config, defaults);
        CQ.form.PCIEntries.PCIEntryPanel.superclass.constructor.call(this, config);

    },

    initComponent: function() {
      
       CQ.form.PCIEntries.PCIEntryPanel.superclass.initComponent.call(this);

       /*category field
      */

      //tell the store how to process the data for category field
        var reader = new CQ.Ext.data.ArrayReader({}, [
           {name: 'categoryid'},
           {name: 'category'},
           {name: 'view'}
       
        ]);
    
       //dynamic getting drop down list
       var pageHandle;
       var sidekick = CQ.utils.WCM.getSidekick();
  
       if (sidekick) {
            pageHandle=location.toString();
            pageHandle=pageHandle.replace('.html','.pcicategories.html');
       }else {
            pageHandle = CQ.Ext.getCmp(window.CQ_SiteAdmin_id).getSelectedPages()[0].id;
            pageHandle = pageHandle + ".pcicategories.html";
   
       }

        // get the data
        var proxy = new CQ.Ext.data.HttpProxy({
                //where to retrieve data
                // url: '/apps/mcd/classes/pcicategories.html', //url to data object (server side script)
                url: pageHandle,
                method: 'GET'
            });
       
        // create the data store.
        var store = new CQ.Ext.data.Store({
            reader: reader,
            proxy: proxy
        });
      
        
        this.categoryField = new CQ.Ext.form.ComboBox({
            fieldLabel: CQ.I18n.getMessage('Category'),
            labelStyle: 'font-size:12px;color:black;',
            name: 'Category',
            //xtype: 'pcicategories',
            typeAhead: true,
            triggerAction: 'all',
            mode: 'local',
            store: store,
            valueField: 'categoryid',
            displayField: 'category',  
            emptyText:'',
            selectOnFocus:true,
            width: 300,
            listWidth: 300,
            minListWidth: 200,
            listeners: {
                'select': this.categorySelectionChanged,
                 scope: this
            }
         });
         store.load();
         this.add(this.categoryField);
  
        /*views*/

        this.viewField = new CQ.Ext.form.CheckboxGroup({
            fieldLabel: CQ.I18n.getMessage('Views'),
            //xtype: 'pciviews',
            width: 300,
            columns: 1,
            autoHeight: true,
            items: [
                {boxLabel: '<font color=black>AU</font>', name: 'View', inputValue: 'AU'},
                {boxLabel: '<font color=black>US</font>', name: 'View', inputValue: 'US'},
                {boxLabel: '<font color=black>ENT</font>', name: 'View', inputValue: 'ENT'},
                {boxLabel: '<font color=black>NZ</font>', name: 'View', inputValue: 'NZ'}
            ]
        });
        
        this.add(this.viewField);
        
       
        /*title field */
            
        this.titleField = new CQ.Ext.form.TextField({
            fieldLabel: CQ.I18n.getMessage('Title'),
            fieldDescription: CQ.I18n.getMessage('Defaults to Page Title'),
            name: 'Title',
            width: 300
        });
        this.add(this.titleField);
              
         /*description field */

/* commented line# 171 and added line# 172 for defect ID# AMCD00003414 */
        //this.descriptionField = new CQ.Ext.form.TextArea({
          this.descriptionField = new CQ.Ext.form.Hidden({
            fieldLabel: 'Description',
            fieldDescription: 'Defaults to Page Description',
            name: 'Description',
          //  rows: 1,
            width: 300
        });
        this.add(this.descriptionField);
         
        this.descriptionLabelFieldDescription = new CQ.Ext.form.Label({
            html: "<div style='font-size:10px;color:black;'>*Defaults to Page Description</div>", 
            width: 300, 
            xtype: "label"
         
        });        
          
       /*display type*/  
        this.displayTypeLabelField = new CQ.Ext.form.Label({
            html: "<div style='font-size:12px;color:black;'>Display</div>", 
            xtype: "label"
        });  

        this.displayTypeField = new CQ.Ext.form.CheckboxGroup({
            fieldLabel: CQ.I18n.getMessage('Display'),
            xtype: 'selection',
            columns: 1,
            width: 300,
            autoHeight: true,
            items: [
                {boxLabel: '<font color=black>'+CQ.I18n.getMessage("Show site header and navigation")+'</font>', name: 'DisplayType', inputValue: 'shownav', checked: true},
                {boxLabel: '<font color=black>' + CQ.I18n.getMessage("Open in new window") + '</font>', name: 'DisplayType', inputValue: 'newwin'}
            ]  
        });   
        this.add(this.displayTypeField);  
        
       /*publish date field */

        
        this.publishDateField = new CQ.form.DateTime({
            timeWidth:200,
            dateWidth:200,
            defaultValue: "now",
            xtype: 'datetime',
            fieldLabel: CQ.I18n.getMessage("Publish Date"),
            dateFormat: 'm/d/Y',
            fieldDescription: CQ.I18n.getMessage("Used by date-sorted categories, such as Inside McDonald's. Defaults to initial page activation date."),
            timePosition: 'below',
            width: 200,
            autoHeight: true,
            valueAsString: false
        });
        this.add(this.publishDateField);
             
    },
    
    //functions
    categorySelectionChanged: function() {
        var selectedCategory = this.categoryField.getRawValue();

        this.doAjax(selectedCategory);
    },
    
    /* for testing purpose */
    testajax: function(categoryList) {
        var test = categoryList;
    },
    
    // added ajax call
    doAjax: function(selectedCategory) {
         var ajaxViewField=this.viewField;
         CQ.Ext.Ajax.request({
            url : '/apps/mcd/classes/pcicategories.html',
            method: 'GET',
            async: 'false',
            success: function ( result, request ) {
                 var allowedView = "All";
                 var categoryList = result.responseText;
                         
                 var categoryEntries = categoryList.split("\,");
                 for (var i=0; i<categoryEntries.length; i++) {
                       var categoryEntry = categoryEntries[i].split("\|");
                       var category = categoryEntry[1];
                       
                       if (category == selectedCategory) {
                           var allowedView = categoryEntry[2];
                           break;
                       }
                  } 
                   var viewItems = ajaxViewField.items;
                                        
                   for (var i=0; i<viewItems.length; i++) {
                       var item = viewItems.get(i);
                       
                       if (allowedView == 'ALL') {
                           item.setVisible(true);
                           item.setValue(false);
                       } else {
                           item.setVisible(true);
                           if (item.inputValue.toString() == allowedView) {
                               item.setValue(true);
                          } else {
                              item.setVisible(false);
                              item.setValue(false);
                          }
                      }
                   }
               }, 
              failure: function ( result, request ) {
                  var categoryList = result.responseText;
                  alert("Not getting category list:" + categoryList);
              } 
         });
    },
    
    //if i use the data array file directly...
    updateViews: function(selectedCategory) {

        CQ.Ext.Ajax.request({
            url : '/apps/mcd/classes/pcicategories.html',
            method: 'GET',
            async: 'false',
            success: function ( result, request ) {
                 var allowedView = "All";
                 var categoryList = result.responseText;
                 
                 this.testajax(categoryList);
                 var categoryId;
                 var data = [];
                 
                 data = eval(categoryList);
 
                 
                 for (var i=0; i<data.length; i++) {
                     categoryId = data[i][0];
                     

                     if (categoryId == selectedCategory) {
                           allowedView = data[i][2];
                           break;
                       }
                  }
                  
 
                   var viewItems = this.viewField.items;
                                          
                   for (var i=0; i<viewItems.length; i++) {
                       var item = viewItems.get(i);
                       
                       if (allowedView == 'ALL') {
                           item.setVisible(true);
                           item.setValue(false);
                       } else {
                           item.setVisible(true);
                           if (item.inputValue.toString() == allowedView) {
                               item.setValue(true);
                          } else {
                              item.setVisible(false);
                              item.setValue(false);
                          }
                      }
                   }
               }, 
               failure: function ( result, request ) {
                  var categoryList = result.responseText;
                  alert("Not getting category list:" + categoryList);
               }
         });
        
    },
    
    /* for testing */
    getCategory: function() {
       
         CQ.Ext.Ajax.request({
            url : '/apps/mcd/classes/pcicategory.html',
            method: 'GET',
            async: 'false',
            success: function ( result, request ) {
                 var categoryList = result.responseText;
                
                 var categoryEntries = categoryList.split("\,");
                 for (var i=0; i<categoryEntries.length; i++) {
                       var categoryEntry = categoryEntries[i].split("\|");
                       var category = categoryEntry[1];
                                          
                       dataArr.push([categoryEntry[0], categoryEntry[1]]);    
                  } 
                 
                  for (var j=0; j<dataArr.length; j++) {
                      break;
                      
                  }
                  return dataArr;
             }, 
             failure: function ( result, request ) {
                  var categoryList = result.responseText;
                  alert("Not getting category list:" + categoryList);
                  // return categoryList;
              }
         });
    }, 
   

    afterRender: function() {
        CQ.form.PCIEntries.PCIEntryPanel.superclass.afterRender.call(this);
        this.el.setVisibilityMode(CQ.Ext.Element.DISPLAY);
        this.body.setVisibilityMode(CQ.Ext.Element.DISPLAY);
    },
    
    adjustTitleWidth: function(width) {
        if (width) {
            var PCIEntryPanel = this.items.get("titlePanel");
            // var selector = titlePanel.items.get("selector");
            var titleLabel = this.items.get("titleLabel");
            if (titleLabel.rendered) {
                var titleWidth = width - titleLabel.getEl().getWidth();
                PCIEntryPanel.setSize(titleWidth, 30);
            } else {
                this._width = width;
            }
        }
    },
    
    // set title 
    setTitle: function(title) {
         this.categoryField.setValue(title ? title : "");
    },

    // get title 
    getTitle: function() {
        var title = this.categoryField.getRawValue();
        return title;
    },
   
    // set category
    setCategory: function(category) {
        this.categoryField.setValue(category ? category : "");
    },
        
    // get category
    getCategory: function() {
        var category = this.categoryField.getValue();
        // var category = this.categoryField.getRawValue();
        return category;
    },
    
    // set view 
    setView: function(view) {
     
     var viewItems = this.viewField.items;
     var item;
       
     if (view == null) {
         for (var i=0; i<viewItems.length; i++) {
           item = viewItems.get(i);
                                   
           item.setVisible(true);
           item.setValue(false);
         }
     
     } else {
            
        for (var j=0; j<viewItems.length; j++) {
           item = viewItems.get(j);
          // alert("item value=" + item.inputValue.toString());   
                               
           if (view.indexOf(item.inputValue.toString()) != -1) {
               item.setVisible(true);
               item.setValue(true);
           } else {
               item.setVisible(false);
               item.setValue(false);         
           }
        }    
      }
    },

    // get view 
    getView: function() {
        var view = "";
        var viewItems = this.viewField.items;
               
        for (var i=0; i<viewItems.length; i++) {
                   
            var item = viewItems.get(i);
                       
            if (item.getValue()) {
                view = view + item.inputValue.toString() + ",";
            }
        }
        //replace last comma
        view = view.replace(/\,$/, "");
        return view;
    },
    
    // set category title
    setCTitle: function(title) {
        this.titleField.setValue(title ? title : "");
    },

    // get view 
    getCTitle: function() {
        var title = this.titleField.getRawValue();
        return title;
    },
    
    // set description 
    setDescription: function(description) {
        this.descriptionField.setValue(description ? description : "");
    },

    // get description 
    getDescription: function() {
        var description = this.descriptionField.getRawValue();
        return description;
    },
    
    // set display type 
    setDisplayType: function(displayType) {
           
      var displayTypeItems = this.displayTypeField.items;
      var item;
      var item1;
        
      if (displayType == null) {
               //set first item selected
               item = displayTypeItems.get(0);
               item.setVisible(true);
               item.setValue(true);
               
                //set second item unselected         
               item1 = displayTypeItems.get(1);
               item1.setVisible(true);
               item1.setValue(false);
      } else {
                         
           for (var j=0; j<displayTypeItems.length; j++) {
               item = displayTypeItems.get(j);
              // alert("item value=" + item.inputValue.toString());  
            
               item.setVisible(true);                   
               if (displayType.indexOf(item.inputValue.toString()) != -1) {
                   item.setValue(true);
               } else {
                   item.setValue(false);
               }
           }  
      }  
    },
    
    // get display type 
    getDisplayType: function() {
    
        var displayType = "";
        var item = "";
        
        var displayTypeItems = this.displayTypeField.items;
         
        for (var i=0; i<displayTypeItems.length; i++) {
            item = displayTypeItems.get(i);
                       
            if (item.getValue()) {
                displayType = displayType + item.inputValue.toString() + ",";
            }
        }
        //replace last comma
        displayType = displayType.replace(/\,$/, "");
        
        return displayType;    
    },
    
   
    // set publish date
    setPublishDate: function(publishDate) {
     
       if (publishDate) {
           this.publishDateField.setValue(publishDate);
       }else {
           var dv = new Date();
           this.publishDateField.setValue(dv); 
       } 
    },
    
    // get publish date 
    getPublishDate: function() {
         var publishDate = this.publishDateField.getValue();
         
         //format it to a string
         var publishDateString=publishDate.toUTCString();
         return publishDateString;
    }
    

}); 