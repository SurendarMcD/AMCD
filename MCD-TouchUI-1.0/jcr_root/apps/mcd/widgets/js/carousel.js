/**
* @class CQ.form.offersWidget
* @extends CQ.form.CompositeField
* @param {Object} config The config object
*/

CQ.form.carouselmultifield = CQ.Ext.extend(CQ.form.CompositeField, {
    
    hiddenField: null,    
    image_path: null,    
    show_widget: null,
    widget_alignment: null,
    widget_heading: null,
    widget_subheading: null,
    widget_text: null,
    button_text: null,
    button_url: null,
    
    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": true,
            "stateful": false,
            "style": "padding:2px 0 0 2px;"
        };
        config = CQ.Util.applyDefaults(config, defaults);
        CQ.form.carouselmultifield.superclass.constructor.call(this, config);
    },
    
    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        CQ.form.carouselmultifield.superclass.initComponent.call(this);
        
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false
        });
        this.add(this.hiddenField); 

        this.image_path = new CQ.form.PathField({
            fieldLabel:"Image",
            fieldDescription : "Select an image to be displayed.",
            width : 325,
            rootPath : "/content/dam",
            type:"select",
            allowBlank:false,
        });
        this.add(this.image_path);

        this.show_widget = new CQ.form.Selection({
            fieldLabel:"Show Widget",
            fieldDescription : "Need widget on the images ?",
            type:"select",
            width : 325,
            allowBlank:false,
            defaultType:"String[]",
            options: [{
                text:"Yes",
                value:"y"
            },{
                text:"No",
                value:"n"
            }],
        });
        this.add(this.show_widget);

        this.widget_alignment = new CQ.form.Selection({
            fieldLabel:"Widget Alignment",
            fieldDescription : "Select alignment for the widget.",
            type:"select",
            width : 325,
            defaultType:"String[]",
            options: [{
                text:"Left",
                value:"left"
            },{
                text:"Right",
                value:"right"
            }],
        });
        this.add(this.widget_alignment);

        this.widget_heading = new CQ.Ext.form.TextField({
            fieldLabel:"Widget Heading",
            fieldDescription : "Enter heading for the widget.",
			width : 325
        });
        this.add(this.widget_heading);
        this.widget_subheading = new CQ.Ext.form.TextField({
            fieldLabel:"Widget Sub Heading",
            fieldDescription : "Enter sub heading for the widget.",
			width : 325
        });
        this.add(this.widget_subheading);
        this.widget_text = new CQ.Ext.form.TextField({
            fieldLabel:"Widget Text",
            fieldDescription : "Enter text for the widget.",
			width : 325
        });
        this.add(this.widget_text);
        this.button_text = new CQ.Ext.form.TextField({
            fieldLabel:"Button Text",
            fieldDescription : "Enter button test for the widget.",
			width : 325
        });
        this.add(this.button_text);
		this.button_url = new CQ.form.PathField({
            fieldLabel:"Button URL",
            fieldDescription : "Browse the button target",
            rootPath : "/content",
            width : 325,
            type:"select",
        });
        this.add(this.button_url);

    },    

    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
		if (!this.image_path) {
            return;
        }

        var imagePath = '';
        var showWidget = '';
        var widgetAlignment = '';
        var widgetHeading = '';
        var widgetSubheading = '';
        var widgetText = '';
        var buttonText = '';
        var buttonUrl = '';

        if (value) {
            var accValue = value.split('|');
            if(accValue.length > 0) {
                imagePath = accValue[0];
                showWidget = accValue[1];
                widgetAlignment = accValue[2];
        		widgetHeading = accValue[3];
        		widgetSubheading = accValue[4];
        		widgetText = accValue[5];
        		buttonText = accValue[6];
        		buttonUrl = accValue[7];
			}
        }
        this.image_path.setValue(imagePath);
        this.show_widget.setValue(showWidget);
        this.widget_alignment.setValue(widgetAlignment);
        this.widget_heading.setValue(widgetHeading);
        this.widget_subheading.setValue(widgetSubheading);
        this.widget_text.setValue(widgetText);
        this.button_text.setValue(buttonText);
        this.button_url.setValue(buttonUrl);
    },    
    
    // overriding CQ.form.CompositeField#getValue
    getValue: function() {
        return this.getRawValue();
    },
    
    // overriding CQ.form.CompositeField#getRawValue
    getRawValue: function() {
        if (!this.image_path) {
            return "";
        }
        var imagePath = this.image_path.getValue() || "";
        var showWidget = this.show_widget.getValue() || "";
        var widgetAlignment = this.widget_alignment.getValue() || "";
        var widgetHeading = this.widget_heading.getValue() || "";
        var widgetSubheading =  this.widget_subheading.getValue() || "";
        var widgetText = this.widget_text.getValue() || "";
        var buttonText = this.button_text.getValue() || "";
        var buttonUrl = this.button_url.getValue() || "";

        var value = imagePath + "|" + showWidget + "|" + widgetAlignment + "|" + widgetHeading + "|" + widgetSubheading + "|" + widgetText + "|" + buttonText+ "|" + buttonUrl;
        this.hiddenField.setValue(value);
        return value;
    },
});

// register xtype
CQ.Ext.reg('carouselmultifield', CQ.form.carouselmultifield);