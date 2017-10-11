/**
 * @class CQ.form.PCIEntries.PCISlidesPanel
 * @extends CQ.Ext.Panel
 * @private
 * The PCISlidesPanel provides the UI to add, remove and select slides.
 * @constructor
 * Creates a new SlidePanel.
 * @param {Object} config The config object
 * Created by Wei Wu
 */

CQ.form.PCIEntries.PCISlidesPanel = CQ.Ext.extend(CQ.Ext.Panel, {

    constructor: function(config) {

        var parentScope = this;

        // lazy initialization does not work on Firefox for these buttons, so instantiating
        // them the old way ...
        var addButton = new CQ.Ext.Button({
            "itemId": "addButton",
            "xtype": "button",
            "text": "Add",
            "afterRender": function() {
                CQ.Ext.Button.prototype.afterRender.call(this);
                if (parentScope._width) {
                    parentScope.adjustSelectorWidth(parentScope._width)
                }
            },
            "handler": function() {
                if (parentScope.onAddButton) {
                    parentScope.onAddButton();
                }
            }
        });
        var removeButton = new CQ.Ext.Button({
            "itemId": "removeButton",
            "xtype": "button",
            "text": "Remove",
            "afterRender": function() {
                CQ.Ext.Button.prototype.afterRender.call(this);
                if (parentScope._width) {
                    parentScope.adjustSelectorWidth(parentScope._width)
                }
            },
            "handler": function() {
                if (parentScope.onRemoveButton) {
                    parentScope.onRemoveButton();
                }
            }
        });

        config = config || { };
        var defaults = {
            "layout": "table",
            "layoutConfig": {
                "columns": 3
            },
            "defaults": {
                "style": "padding: 3px;"
            },
            "minSize": 30,
            "maxSize": 30,
            "height": 30,
            "items": [{
                    "itemId": "slideSelector",
                    "xtype": "panel",
                    "layout": "fit",
                    "border": false,
                    "height": 30,
                    "hideBorders": true,
                    "items": [{
                            "itemId": "selector",
                            "xtype": "selection",
                            "type": "select",
                            "listeners": {
                               
                                "selectionchanged": {
                                    "fn": function(comp, value) {
                                        if (this.onSlideChanged) {
                                            this.onSlideChanged(value);
                                        }
                                    },
                                    "scope": this
                                }
                                
                            }
                        }]
                },
                addButton,
                removeButton
            ],
            "listeners": {
                "bodyresize": {
                    "fn": function(comp, w, h) {
                        this.adjustSelectorWidth(w);
                    },
                    "scope": this
                }
            }
        };

        CQ.Util.applyDefaults(config, defaults);
        CQ.form.PCIEntries.PCISlidesPanel.superclass.constructor.call(this, config);
    },

    initComponent: function() {

        CQ.form.PCIEntries.PCISlidesPanel.superclass.initComponent.call(this);
    },

    afterRender: function() {
        CQ.form.PCIEntries.PCISlidesPanel.superclass.afterRender.call(this);
        this.el.setVisibilityMode(CQ.Ext.Element.DISPLAY);
        this.body.setVisibilityMode(CQ.Ext.Element.DISPLAY);
    },

    adjustSelectorWidth: function(width) {
        if (width) {
            var selectorPanel = this.items.get("slideSelector");
            var addButton = this.items.get("addButton");
            var removeButton = this.items.get("removeButton");
            if (addButton.rendered && removeButton.rendered) {
                var selWidth = width
                    - addButton.getEl().getWidth() - removeButton.getEl().getWidth();
                selectorPanel.setSize(selWidth, 30);
                var selector = selectorPanel.items.get("selector");
                selector.setSize(selWidth, addButton.getEl().getHeight());
            } else {
                this._width = width;
            }
        }
    },

    setInitialComboBoxContent: function(data) {

        var selector = this.items.get("slideSelector").items.get("selector");
        selector.setOptions(data);
    },
    
    select: function(slide) {
        var selector = this.items.get("slideSelector").items.get("selector");
        selector.suspendEvents();
        if (slide) {
            selector.setValue(slide);
        } else {
            selector.setValue(null);
        }
        selector.resumeEvents();
    },

    updateSlide: function(slide, deleteFlag) {
        var duplicateFlag;
        var duplicateFlag1;
        var slideViews;
             
        if (slide) {
            
            var selector = this.items.get("slideSelector").items.get("selector");
            var store = selector.comboBox.store;
            var rowCnt = store.getTotalCount();

           
                //check category is null or not            
                if (slide.createDisplayText() == 'New Entry') {
                    duplicateFlag = "noDuplicates";
                    
                } else {    
                    for (var row = 0; row < rowCnt; row++) {
                        var rowData = store.getAt(row);
                        
                     
                        //if there is a duplicate...        
                        if (rowData.get("text").indexOf(slide.createDisplayText())!= -1){
                           
                            //if it has the same view
                            if (slide.view.indexOf(",") != -1) {
                                 slideViews = slide.view.split("\,");
                                 
                                 for (var i=0; i<slideViews.length; i++)  {
                                     if (rowData.get("value").view.indexOf(slideViews[i]) != -1) {
                                     
                                          duplicateFlag1 = duplicateFlag1 + "," + slide.createDisplayText() + ":" + slideViews[i];
                                         
                                          if (deleteFlag == 1)                                               
                                              rowData.get("value").isDeleted = true;

                                                                                     
                                          duplicateFlag = duplicateFlag + "," + duplicateFlag1;
           
                                     } else {
                                        duplicateFlag = duplicateFlag + "," + slide.createDisplayText() + "allowed";
                                     }
                                 }
                                 
                            } else {

                                if (rowData.get("value").view.indexOf(slide.view) != -1) {
                                    
                                    duplicateFlag1 = duplicateFlag1 + "," + slide.createDisplayText() + ":" + slide.view;
                                    //when doing add
                                    if (deleteFlag == 1)
                                        rowData.get("value").isDeleted = true;

                                       
                                    duplicateFlag = duplicateFlag + "," + duplicateFlag1;

                                } else  {   
                                    duplicateFlag = duplicateFlag + "," + slide.createDisplayText() + "allowed";

                                }
                            }
                        } 
                        
                        if (rowData.get("text").indexOf("...") != -1) {
                       
                            var categoryStr = rowData.get("text").split("|");
                            duplicateFlag = duplicateFlag + "," + categoryStr[0] + "allowed";
                        }
                                   
                        if (rowData.get("value") == slide) {

                            if (rowData.get("text").indexOf("...") != -1) {
                                rowData.set("text", rowData.get("text"));
                            }
                            else {
                                rowData.set("text", slide.createDisplayText());
                            }
                        }
                        store.commitChanges();
                   
                   }
             }
        }
                                                   
        return duplicateFlag;
    },
    
    
     updateSlideForRemove: function() {
        var duplicateFlag;
               
        var selector = this.items.get("slideSelector").items.get("selector");
        var store = selector.comboBox.store;
        var rowCnt = store.getTotalCount();
        var temp;
                        
        for (var row = 0; row < rowCnt; row++) {
            var rowData = store.getAt(row);
                 
            if (rowData.get("text").indexOf("...") != -1) {
                 var categoryStr = rowData.get("text").split("|");
                 duplicateFlag = duplicateFlag + "," + categoryStr[0];
            }
                             
                      
            rowData.set("text", rowData.get("text"));
            store.commitChanges();
         }
         return duplicateFlag;
    },


    disableFormElements: function() {
        var selector = this.items.get("slideSelector").items.get("selector");
        selector.disable();
    },

    enableFormElements: function() {
        var selector = this.items.get("slideSelector").items.get("selector");
        selector.enable();
    }

});


 