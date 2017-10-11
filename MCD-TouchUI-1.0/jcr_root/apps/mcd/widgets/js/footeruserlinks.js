/* 
 Author : 
 */

/**
 * @class CQ.wcm.FilterRuleField
 * @extends CQ.form.CompositeField
 * The filter rule field lets the user select "include" or "exclude" and enter a regexp
 * @constructor
 * Creates a new FilterRuleField.
 * @param {Object} config The config object
 */
 
FooterUserLinksEntry = {}; 
 
FooterUserLinksEntry.FooterUserLinks = CQ.Ext.extend(CQ.form.CompositeField, {

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    hiddenField: null, 

    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    linkTextLabel: null,
    
    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    linkText: null,

    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    linkURLLabel: null,

    /**
     * @private
     * @type CQ.form.PathField
     */
    linkURL: null,

    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": false,
            "stateful": false,
            "style": "padding:5px 0 0 5px;"
        };
        config = CQ.Util.applyDefaults(config, defaults);
        FooterUserLinksEntry.FooterUserLinks.superclass.constructor.call(this, config);
    },

    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        FooterUserLinksEntry.FooterUserLinks.superclass.initComponent.call(this);
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false
        });
        this.add(this.hiddenField);

        this.linkTextLabel = new CQ.Ext.form.Label({
            html: "Link Text",
            style:'width:90px;float:left;'
        });
        this.add(this.linkTextLabel);
        
        this.linkText = new CQ.Ext.form.TextField({ 
            width: '300px',
            "stateful": false,
            "border":true,
            "hideLabel":true,
            style:'float:left;'
        });
        this.add(this.linkText);

        this.linkURLLabel = new CQ.Ext.form.Label({
            html: "Link URL",
            style:'width:90px;float:left;'
        });
        this.add(this.linkURLLabel);
        
        this.linkURL = new CQ.form.PathField({
            style:'width:284px;', 
            width:'100%',
            "hideLabel":true
        });
        this.add(this.linkURL);
    },
   
    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        if (!value) {
            return null;
        }
        
        var linkText = '';
        var linkURL = '';
        
        if (value) {
            var linksValue = value.split("^");
            if(linksValue.length>0) {
                linkText = linksValue[0];
                linkURL = linksValue[1];
            }
        }
        this.linkText.setValue(linkText);
        this.linkURL.setValue(linkURL);
    },

    // overriding CQ.form.CompositeField#getValue
    getValue: function() {
        return this.getRawValue();
    },

    // overriding CQ.form.CompositeField#getRawValue
    getRawValue: function() {
        var value = "";
        var linkText = this.linkText.getValue() || "";
        var linkURL = this.linkURL.getValue() || "";
        
        var value = linkText + "^" + linkURL ;
        this.hiddenField.setValue(value);
        return value;
    },
 
    // to make the the field mandatory
    markInvalid : function(msg){

    },

    clearInvalid : function(){

    } 

});
// register xtype
CQ.Ext.reg('footeruserlinks', FooterUserLinksEntry.FooterUserLinks); 