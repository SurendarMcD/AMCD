/* Modification of CQ.form.ColorList to allow entry of site-defined color class values 
  */

/**
 * @class CQ.form.ColorList
 * @extends CQ.form.CompositeField
 * The ColorList lets the user choose a color from an editable list.
 * @constructor
 * Creates a new ColorList.
 * @param {Object} config The config object
 */
CQ.form.mcdSiteColorClassList = CQ.Ext.extend(CQ.form.CompositeField, {
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
        CQ.form.mcdSiteColorClassList.superclass.constructor.call(this,config);
    },

    /**
     * Adds a color to the list.
     * @param {String} value The hexadecimal color value to add
     */
    addItem: function(value) {
        var item = this.insert(this.items.getCount() - 1, { xtype:"mcdsitecolorclasslistitem" });
        this.doLayout();

        if (value) {
            item.setValue(value);
        }
    },

    getValue: function() {
        var value = "";
        var separator = "";
        this.items.each(function(item, index, length) {
            if (item instanceof CQ.form.mcdSiteColorClassListItem) {
                value += separator + item.getValue();
                separator = ":";
            }
        }, this);
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
CQ.Ext.reg("mcdsitecolorclasslist", CQ.form.mcdSiteColorClassList);

CQ.form.mcdSiteColorClassListItem = CQ.Ext.extend(CQ.Ext.Panel, {
    constructor: function(config) {

        this.field = new CQ.form.mcdSiteColorClassField({width:60, name:"",showHexValue:false, style: 'display: block'});
        this.field.isFormField = false;

        var item = this;
        config = CQ.Util.applyDefaults(config, {
            layout:"table", border:false,
            layoutConfig:{ columns:4 },
            defaults:{ bodyStyle:"padding:4px" },
            items:[
                {
                    xtype:"panel", border:false, width:90, style:'display:block;',
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
                        xtype:"button", text:CQ.I18n.getMessage("Remove"),
                        handler:function() {
                            item.ownerCt.remove(item);
                        }
                    }
                }
            ] 
        });
        CQ.form.mcdSiteColorClassListItem.superclass.constructor.call(this, config);

        if (config.value) {
            this.field.setValue(config.value);
        }
    },
    reorder: function(item, parent, index) {
        var value = item.field.getValue();
        parent.remove(item);

        var comp = parent.insert(index, { 
            xtype:"mcdsitecolorclasslistitem"
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
CQ.Ext.reg("mcdsitecolorclasslistitem", CQ.form.mcdSiteColorClassListItem);

/**
 * Changed to work with color classes instead of colors
 */
CQ.form.mcdSiteColorClassField = CQ.Ext.extend(CQ.Ext.form.TriggerField, {
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

            defaultColor:"",
            curColor:"",
            maskRe:/[a-f0-9]/i,
            regex:/[a-f0-9]/i,
            colors:[]
        });
        CQ.form.mcdSiteColorClassField.superclass.constructor.call(this, config);

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
        if (value.length != 3 && value.length != 10) {
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
        CQ.form.mcdSiteColorClassField.superclass.setValue.call(this, hex);
        this.setColor(hex);
    },

    setColor: function(hex) {
        this.curColor = hex;

        this.el.setStyle( {
            //"background-color":"#" + hex,
            "background-image":"none"
        });
        if (!this.showHexValue) {
            this.el.setStyle( {
                "text-indent":"-60px"
            });  

            if($.browser.msie && $.browser.version == "7.0") {
                this.el.setStyle( {
                    "margin-left":"60px"
                }); 
            }        
        }
        //remove any existing sitecolor classes
        var classnames=this.el.dom.className.split(" ");
        for(var i=0;i<classnames.length;i++){
            if(classnames[i].indexOf("sitecolor")==0)
               this.el.removeClass(classnames[i]);
        } 
        if(hex!=""){
            this.el.addClass(hex);            
            //if(this.menu)this.menu.palette.el.child("a.color-"+hex).addClass("x-color-palette-sel");
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

            if(this.colors.length>0){

                this.menu = new CQ.Ext.menu.mcdColorClassMenu({parentField:this,value:this.curColor, colors:this.colors});
            }else{
                this.menu = new CQ.Ext.menu.mcdColorClassMenu({parentField:this}); 
            }
        }
        this.menu.on(CQ.Ext.apply( {}, this.menuListeners, {
            scope:this
        }));
        this.menu.show(this.el, "tl-bl?");
    }
});
CQ.Ext.reg("mcdsitecolorclassfield", CQ.form.mcdSiteColorClassField);

/**
 * @class CQ.Ext.menu.ColorMenu
 * @extends CQ.Ext.menu.Menu
 * A menu containing a {@link CQ.Ext.menu.ColorItem} component (which provides a basic color picker).
 * @constructor
 * Creates a new ColorMenu
 * @param {Object} config Configuration options
 */
CQ.Ext.menu.mcdColorClassMenu = function(config){
    CQ.Ext.menu.mcdColorClassMenu.superclass.constructor.call(this, config);
    this.plain = true;
    //var ci = new CQ.Ext.menu.mcdColorClassItem(config); different for 5.4
    var ci = new CQ.Ext.mcdSiteColorClassPalette(config);
    this.add(ci);
    /**
     * The {@link CQ.Ext.ColorPalette} instance for this ColorMenu
     * @type ColorPalette
     */
    this.palette = ci.palette;
    /**
     * @event select
     * @param {ColorPalette} palette
     * @param {String} color
     */
    this.relayEvents(ci, ["select"]);
};
CQ.Ext.extend(CQ.Ext.menu.mcdColorClassMenu, CQ.Ext.menu.Menu);

/**
 * @class CQ.Ext.menu.ColorItem
 * @extends CQ.Ext.menu.Adapter
 * A menu item that wraps the {@link CQ.Ext.ColorPalette} component.
 * @constructor
 * Creates a new ColorItem
 * @param {Object} config Configuration options
 */
CQ.Ext.menu.mcdColorClassItem = function(config){ 

    CQ.Ext.menu.mcdColorClassItem.superclass.constructor.call(this, new CQ.Ext.mcdSiteColorClassPalette(config), config);
    /** The CQ.Ext.ColorPalette object @type CQ.Ext.ColorPalette */
    this.palette = this.component;
    this.relayEvents(this.palette, ["select"]);
    if(this.selectHandler){
        this.on('select', this.selectHandler, this.scope);
    }
};

//Adapter no longer needed in cq5.4
//CQ.Ext.extend(CQ.Ext.menu.mcdColorClassItem, CQ.Ext.menu.Adapter);


CQ.Ext.mcdSiteColorClassPalette = function(config){
    CQ.Ext.mcdSiteColorClassPalette.superclass.constructor.call(this, config);
    if(config.parentField){
        this.parentField=config.parentField;
        }
    this.addEvents(
        /**
         * @event select
         * Fires when a color is selected
         * @param {ColorPalette} this
         * @param {String} color The 6-digit color hex code (without the # symbol)
         */
        'select'
    );

    if(this.handler){
        this.on("select", this.handler, this.scope, true);
    }
};
/* colors serve the role as classes for MCD color class version */
CQ.Ext.extend(CQ.Ext.mcdSiteColorClassPalette, CQ.Ext.Component, {
    parentField : null, 
    /**
     * @cfg {String} tpl An existing XTemplate instance to be used in place of the default template for rendering the component.
     */
    /**
     * @cfg {String} itemCls
     * The CSS class to apply to the containing element (defaults to "x-color-palette")
     */
    itemCls : "x-color-palette",
    /**
     * @cfg {String} value
     * The initial color to highlight (should be a valid 6-digit color hex code without the # symbol).  Note that
     * the hex codes are case-sensitive.
     */
    value : null,
    clickEvent:'click',
    // private
    ctype: "CQ.Ext.mcdSiteColorClassPalette",

    /**
     * @cfg {Boolean} allowReselect If set to true then reselecting a color that is already selected fires the {@link #select} event
     * (changed to allow unselecting 8-17-10 ECW)
     */
    allowReselect : true,

    /**
     * This will pull from variable mcdSiteColorClassPaletteColors if defined
     * @type Array
     */
    colors : [
        "sitecolor1","sitecolor2","sitecolor3","sitecolor4","sitecolor5"
    ],

    // private

    onRender : function(container, position){

        if(typeof(mcdSiteColorClassPaletteColors) != 'undefined')this.colors=mcdSiteColorClassPaletteColors;

        var t = this.tpl || new CQ.Ext.XTemplate(
            '<tpl for="."><a href="#" class="color-{.}" hidefocus="on"><em><span class="{.}" unselectable="on">&#160;</span></em></a></tpl>'
        );
        var el = document.createElement("div");
        el.className = this.itemCls;
        t.overwrite(el, this.colors);
        container.dom.insertBefore(el, position);
        this.el = CQ.Ext.get(el);
        this.el.on(this.clickEvent, this.handleClick,  this, {delegate: "a"});
        if(this.clickEvent != 'click'){
            this.el.on('click', CQ.Ext.emptyFn,  this, {delegate: "a", preventDefault:true});
        }
        //to select the color in the menu
        if(this.parentField!=null){
            this.value=this.parentField.getValue();
            if(this.value!=""){
                this.el.child("a.color-"+this.value).addClass("x-color-palette-sel");
               }
        }
    },

    // private
    afterRender : function(){
        CQ.Ext.mcdSiteColorClassPalette.superclass.afterRender.call(this);
        if(this.value){
            var s = this.value;
            this.value = null;
            this.select(s);
        }
    },

    // private
    handleClick : function(e, t){
        e.preventDefault();
        if(!this.disabled){
            //var c = t.className.match(/(?:^|\s)color-(.{6})(?:\s|$)/)[1];
            var c = t.className.match(/(?:^|\s)color-(sitecolor\d+)(?:\s|$)/)[1];
            //var c = t.className;
            this.select(c.toLowerCase());
        }
    },

    /**
     * Selects the specified color in the palette (fires the {@link #select} event)
     * @param {String} color A valid 6-digit color hex code (# will be stripped if included)
     */
    select : function(color){
        color = color.replace("#", "");
        if(color != this.value || this.allowReselect){
            var el = this.el;
            if(this.value){
                el.child("a.color-"+this.value).removeClass("x-color-palette-sel");
            }
            if(color!=this.value){
                el.child("a.color-"+color).addClass("x-color-palette-sel");
            }else{
                color="";
            }
            this.value = color;
            this.fireEvent("select", this, color); 
        }
    }

    /**
     * @cfg {String} autoEl @hide 
     */
});
CQ.Ext.reg('mcdsitecolorclasspalette', CQ.Ext.mcdSiteColorClassPalette);  