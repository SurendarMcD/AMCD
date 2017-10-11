/* Modification of CQ.form.ColorList to allow entry of hex values 
  Provides greater flexibility in color selection than default ColorList
  */

/**
 * @class CQ.form.ColorList
 * @extends CQ.form.CompositeField
 * The ColorList lets the user choose a color from an editable list.
 * @constructor
 * Creates a new ColorList.
 * @param {Object} config The config object
 */
CQ.form.mcdColorList = CQ.Ext.extend(CQ.form.CompositeField, {
    constructor: function(config) {
        var list = this;
        this.valueField = new CQ.Ext.form.Hidden({ name:config.name });
        config = CQ.Util.applyDefaults(config, {
            items:[
                { 
                    xtype:"panel", border:false, bodyStyle:"padding:4px",
                    items:[
                        { 
                            xtype:"button", 
                            text:CQ.I18n.getMessage("Add"),
                            handler:function() {
                                list.addItem();
                            }
                        },
                        this.valueField 
                    ]
                }
            ],
            listeners: {
                render: function(comp) {
                    var parentDialog = comp.findParentByType("dialog");
                    if (parentDialog) {
                        parentDialog.on("beforesubmit", function(e) {
                            var value = list.getValue();
                            list.valueField.setValue(value);
                        });
                    }
                }
            }
        });
        CQ.form.mcdColorList.superclass.constructor.call(this,config);
    },

    /**
     * Adds a color to the list.
     * @param {String} value The hexadecimal color value to add
     */
    addItem: function(value) {
        var item = this.insert(this.items.getCount() - 1, { xtype:"mcdcolorlistitem" });
        this.doLayout();
        
        if (value) {
            item.setValue(value);
        }
    },
    
    getValue: function() {
        var value = "";
        var separator = "";
        this.items.each(function(item, index, length) {
            if (item instanceof CQ.form.mcdColorListItem) {
                value += separator + item.getValue();
                separator = ":";
            }
        }, this);
        //alert('getValue:'+value);
        return value;
    },
    
    setValue: function(value) {
        if (this.items.getCount()==1 && (value != null) && (value != "")) {
            var values = value.split(":");
            for (var i=0; i<values.length; i++) {
                this.addItem(values[i]);
            }
            this.doLayout();
        }
    }
});
CQ.Ext.reg("mcdcolorlist", CQ.form.mcdColorList);

CQ.form.mcdColorListItem = CQ.Ext.extend(CQ.Ext.Panel, {
    constructor: function(config) {
        var cfmenu = 
        
        this.field = new CQ.form.mcdColorField({width:60, name:"",showHexValue:true });
        this.field.isFormField = false;
        
        var item = this;
        config = CQ.Util.applyDefaults(config, {
            layout:"table", border:false,
            layoutConfig:{ columns:4 },
            defaults:{ bodyStyle:"padding:4px" },
            items:[
                {
                    xtype:"panel", border:false, width:90,
                    items: this.field
                },{
                    xtype:"panel", border:false,
                    items:{ 
                        xtype:"button", 
                        text:CQ.I18n.getMessage("Up"),
                        handler:function() {
                            var parent = item.ownerCt;
                            var index = parent.items.indexOf(item) - 1;
                            
                            if (index >= 0) {
                                item.reorder(item, parent, index);
                            }
                        }
                    }
                },{
                    xtype:"panel", border:false,
                    items:{ 
                        xtype:"button", 
                        text:CQ.I18n.getMessage("Down"),
                        handler:function() {
                            var parent = item.ownerCt;
                            var index = parent.items.indexOf(item) + 1;
                            
                            if (index < parent.items.getCount() - 1) {
                                item.reorder(item, parent, index);
                            }
                        }
                    }
                },{
                    xtype:"panel", border:false,
                    items:{ 
                        xtype:"button", 
                        text:CQ.I18n.getMessage("Remove"),
                        handler:function() {
                            item.ownerCt.remove(item);
                        }
                    }
                }
            ]
        });
        CQ.form.mcdColorListItem.superclass.constructor.call(this, config);
        
        if (config.value) {
            this.field.setValue(config.value);
        }
    },
    reorder: function(item, parent, index) {
        var value = item.field.getValue();
        parent.remove(item);
                                        
        var comp = parent.insert(index, { 
            xtype:"mcdcolorlistitem"
        });
        parent.doLayout();
        comp.setValue(value);
    }
    ,
    
    getValue: function() {
        return this.field.getValue();
    },
    
    setValue: function(value) {
        this.field.setValue(value);
    }
});
CQ.Ext.reg("mcdcolorlistitem", CQ.form.mcdColorListItem);

/**
 * @class CQ.form.ColorField
 * @extends CQ.Ext.form.TriggerField
 * The ColorField lets the user enter a color hex value either
 * directly or using a {@link CQ.Ext.ColorMenu}.
 * @constructor
 * Creates a new ColorField.
 * @param {Object} config The config object
 */
CQ.form.mcdColorField = CQ.Ext.extend(CQ.Ext.form.TriggerField, {
    constructor: function(config) {
        config = CQ.Util.applyDefaults(config, {
            showHexValue:false,
            triggerClass:"x-form-color-trigger",

            defaultAutoCreate: {
                tag:"input",
                type:"text",
                size:"10",
                autocomplete:"off",
                maxlength:"6"
            },

            lengthText:CQ.I18n.getMessage("Hexadecimal color values must have either 3 or 6 characters."),
            blankText:CQ.I18n.getMessage("Must have a hexidecimal value of the format ABCDEF."),

            defaultColor:"FFFFFF",
            curColor:"ffffff",
            maskRe:/[a-f0-9]/i,
            regex:/[a-f0-9]/i,
            colors:[]
        });
        CQ.form.mcdColorField.superclass.constructor.call(this, config);
        this.on("render", this.setDefaultColor);
    },

    validateValue: function(value) {
        if (!this.showHexValue) {
            return true;
        }
        if (value.length < 1) {
            this.el.setStyle( {
                "background-color":"#" + this.defaultColor
            });
            if (!this.allowBlank) {
                this.markInvalid(String.format(this.blankText, value));
                return false
            }
            return true;
        }
        if (value.length != 3 && value.length != 6) {
            this.markInvalid(String.format(this.lengthText, value));
            return false;
        }
        this.setColor(value);
        return true;
    },

    validateBlur: function() {
        return !this.menu || !this.menu.isVisible();
    },

    getValue: function() {
        return this.curColor || this.defaultColor;
    },

    setValue: function(hex) {
        CQ.form.mcdColorField.superclass.setValue.call(this, hex);
        this.setColor(hex);
    },

    setColor: function(hex) {
        this.curColor = hex;

        this.el.setStyle( {
            "background-color":"#" + hex,
            "background-image":"none"
        });
        if (!this.showHexValue) {
            this.el.setStyle( {
                "text-indent":"-100px"
            });
            if (CQ.Ext.isIE) {
                this.el.setStyle( {
                    "margin-left":"100px"
                });
            }
        }
    },

    setDefaultColor: function() {
        this.setValue(this.defaultColor);
    },

    menuListeners: {
        select: function(m, d) {
            this.setValue(d);
        },
        show: function() { // retain focus styling
            this.onFocus();
        },
        hide: function() {
            this.focus();
            var ml = this.menuListeners;
            this.menu.un("select", ml.select, this);
            this.menu.un("show", ml.show, this);
            this.menu.un("hide", ml.hide, this);
        }
    },

    handleSelect: function(palette, selColor) {
        this.setValue(selColor);
    },

    onTriggerClick: function() {
        if (this.disabled) {
            return;
        }
        if (this.menu == null) {
            if(this.colors.length>0)
                this.menu = new CQ.Ext.menu.ColorMenu({colors:this.colors});
            else
                this.menu = new CQ.Ext.menu.ColorMenu(); 
        }
        this.menu.on(CQ.Ext.apply( {}, this.menuListeners, {
            scope:this
        }));
        this.menu.show(this.el, "tl-bl?");
    }
});
CQ.Ext.reg("mcdcolorfield", CQ.form.mcdColorField);