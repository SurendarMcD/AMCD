/* 
 Author : Digvijay Singh Tomar
 */

/**
 * @class CQ.wcm.FilterRuleField
 * @extends CQ.form.CompositeField
 * The filter rule field lets the user select "include" or "exclude" and enter a regexp
 * @constructor
 * Creates a new FilterRuleField.
 * @param {Object} config The config object
 */
 
McDonaldsWOGCategory = {}; 
 
McDonaldsWOGCategory.WOGCategory = CQ.Ext.extend(CQ.form.CompositeField, {

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    hiddenField: null, 
    
    /**
     * @private
     * @type CQ.Ext.form.rte.Selection
     */
    funcField: null,
    
    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": true,
            "stateful": false,
            "style": "padding:5px 0 0 5px;"
        };
        config = CQ.Util.applyDefaults(config, defaults);
        McDonaldsWOGCategory.WOGCategory.superclass.constructor.call(this, config);
    },

    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        McDonaldsWOGCategory.WOGCategory.superclass.initComponent.call(this);
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false
        });
        this.add(this.hiddenField);
        
        var funcOpt = eval(wogCategories);
        this.funcField = new CQ.form.Selection ({
            style:'width:261px;float:left;margin-top:2px;', 
            hideLabel: true,
            xtype : "selection" ,
            type: 'select',
            options: funcOpt
        });
        this.add(this.funcField);
    },
   
    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        if (!value) {
            return null;
        }
        
        var categoryName = '';
        if (value) {
            var categoryValue = value;
            if(categoryValue.length>0) {
                categoryName = categoryValue;
            }
        }
        
        this.funcField.setValue(categoryName);
    },

    // overriding CQ.form.CompositeField#getValue
    getValue: function() {
        return this.getRawValue();
    },

    // overriding CQ.form.CompositeField#getRawValue
    getRawValue: function() {
        if(!this.funcField) {
            return null;
        }
        //var value = this.funcField.getValue();
        var value = "";
        var categoryName = this.funcField.getValue() || "";
        var value = categoryName
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
CQ.Ext.reg('wogcategory', McDonaldsWOGCategory.WOGCategory); 

       