/* 
 Author : Nitin Sharma
 */

/**
 * @class CQ.wcm.FilterRuleField
 * @extends CQ.form.CompositeField
 * The filter rule field lets the user select "include" or "exclude" and enter a regexp
 * @constructor
 * Creates a new FilterRuleField.
 * @param {Object} config The config object
 */
 
McdonaldsFollow = {}; 
 
McdonaldsFollow.Follow = CQ.Ext.extend(CQ.form.CompositeField, {

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    hiddenField: null, 
    
    
    imageLabel: null,
    
    linkLabel: null,

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    imagePath: null,

    /**
     * @private
     * @type CQ.Ext.form.TextArea
     */
    linkPath: null,

    /**
     * @private
     * @type CQ.Ext.form.BrowseField
     */
    pathField: null,
    
    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": true,
            "stateful": false,
            "style": "padding:5px 0 0 5px;"
         
        };
        config = CQ.Util.applyDefaults(config, defaults);
        McdonaldsFollow.Follow.superclass.constructor.call(this, config);
    },

    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        McdonaldsFollow.Follow.superclass.initComponent.call(this);
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false
        });
        this.add(this.hiddenField);
        
        this.imageLabel = new CQ.Ext.form.Label({
            html: CQ.I18n.getMessage('Image') + ':',
            style:'float:left;margin-right:15px;'          
        });        
        this.add(this.imageLabel);

        this.imagePath = new CQ.form.BrowseField({
           style:'width:220px;margin-top:0px;', 
             width:'100%',
            allowBlank: false 
        }); 
        this.add(this.imagePath); 

        this.linkLabel = new CQ.Ext.form.Label({ 
            html: CQ.I18n.getMessage('Link') + ':',
            style:'float:left;margin-right:28px;' 
                       
        });        
        this.add(this.linkLabel);

        this.linkPath = new CQ.form.BrowseField({
            style:'width:220px;margin-top:0px;', 
            width:'100%',
            allowBlank: false
        });
        this.add(this.linkPath);
      
          },

    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        if (!this.imagePath) {
            return null;
        }
        var img = '';
        var link = '';
        if (value)
         {
            var accValue = value.split('|');
            if(accValue.length>0)
             {
                img = accValue[0];
                link = accValue[1];
             }
         }
        this.imagePath.setValue(img);
        this.linkPath.setValue(link);
        //this.pathField.setValue(path);
    },

    // overriding CQ.form.CompositeField#getValue
    getValue: function() {
        return this.getRawValue();
    },

    // overriding CQ.form.CompositeField#getRawValue
    getRawValue: function() {
        if (!this.imagePath) {
            return null;
        }
        var img= this.imagePath.getValue() || "";
        var link= this.linkPath.getValue() || "";
        var value = img + "|" + link;                 // returning the "|" separated value of the widget
        this.hiddenField.setValue(value);
        return value;
    },
 
    // Validation --------------------------------------------------------------------------

    // overriding CQ.form.CompositeField#markInvalid
    
    // to make the the field mandatory
    
    markInvalid : function(msg){
        if (this.imagePath) {
            this.imagePath.markInvalid(msg);
            this.linkPath.markInvalid(msg);
          }
    },

    // overriding CQ.form.CompositeField#markInvalid
    clearInvalid : function(){
        if (this.imagePath) {
            this.imagePath.clearInvalid();
            this.linkPath.clearInvalid();
        }
    }

});
    
// register xtype
CQ.Ext.reg('followus', McdonaldsFollow.Follow); 

   