/**
 * @class CQ.form.MultiField.Item
 * @extends CQ.form.CompositeField
 * Allows authors to provide a link title, url, image and date per news item.
 * @constructor
 * Customization of the MultiField widget's item fields.
 * @param {Object} config The config object
 */
 
McdonaldsNews = {}; //creating namespace
 
McdonaldsNews.NewsItem = CQ.Ext.extend(CQ.form.CompositeField, {

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    hiddenField: null,

    /**
     * @private
     * @type CQ.Ext.form.DateField
     */
    dateField: null,

    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    dateLabel: null,

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    titleField: null,

    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    titleLabel: null,
    
    /**
     * @private
     * @type CQ.form.PathField
     */
    pathField: null,
    
    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    pathLabel: null,
    
    /**
     * @private
     * @type CQ.form.PathField
     */
    imageField: null,
    
    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    imageLabel: null,
   
    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": true,
            "stateful": false,
            "style": "padding:5px 0 0 5px;"
        };
        config = CQ.Util.applyDefaults(config, defaults);
        McdonaldsNews.NewsItem.superclass.constructor.call(this, config);
    },
  
    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        McdonaldsNews.NewsItem.superclass.initComponent.call(this);
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false
        });
        this.add(this.hiddenField);

        this.dateLabel = new CQ.Ext.form.Label({
            width: '100%',
            html:CQ.I18n.getMessage('Date:')
        });
        this.add(this.dateLabel);
        
        this.dateField = new CQ.Ext.form.DateField({
            width: '100%',
            format: 'm-d-Y'
        });
        this.add(this.dateField);

        this.titleLabel = new CQ.Ext.form.Label({
            width: '100%',
            html: CQ.I18n.getMessage('Link Text:')
        });
        this.add(this.titleLabel);
        
        this.titleField = new CQ.Ext.form.TextField({
            width: '98%'
        });
        this.add(this.titleField);
        
        this.pathLabel = new CQ.Ext.form.Label({
            width: '100%',
            html:CQ.I18n.getMessage('Link URL:')
        });
        this.add(this.pathLabel);
        
        this.pathField = new CQ.form.PathField({
            width: '100%',
            rootPath: '/content'
        });
        this.add(this.pathField);
        
        this.imageLabel = new CQ.Ext.form.Label({
            width: '100%',
            html:CQ.I18n.getMessage('Image Location:')
        });
        this.add(this.imageLabel);
        
        this.imageField = new CQ.form.PathField({
            width: '100%',
            rootPath: '/content/dam',
            rootTitle: 'DAM location...'
        });
        this.add(this.imageField);
    }, 

    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        if (!this.pathField) {
            return null;
        }
        var dateVal = '';
        var titleVal = '';
        var pathVal = '';
        var imageVal = '';
        
        if (value) {
            var newsValue = value.split('|');
            if(newsValue.length>0) {
                dateVal = newsValue[0];
                titleVal = newsValue[1];
                pathVal = newsValue[2];
                imageVal = newsValue[3];
            }
        }
        this.dateField.setValue(dateVal);
        this.titleField.setValue(titleVal);
        this.pathField.setValue(pathVal);
        this.imageField.setValue(imageVal);
    },

    // overriding CQ.form.CompositeField#getValue
    getValue: function() {
        return this.getRawValue();
    },

    // overriding CQ.form.CompositeField#getRawValue
    getRawValue: function() {
        if (!this.pathField) {
            return null;
        }
        
        var dateString = this.dateField.getRawValue() || "";
        var titleString = this.titleField.getValue() || "";
        var pathString = this.pathField.getValue() || "";
        var imageString = this.imageField.getValue() || "";
        var value = dateString + "|" + titleString + "|" + pathString + "|" + imageString;

        this.hiddenField.setValue(value);
        return value;
    },
 
    // Validation --------------------------------------------------------------------------

    // overriding CQ.form.CompositeField#markInvalid
    markInvalid : function(msg){
        if (this.pathField) {
            this.titleField.markInvalid(msg);
            this.pathField.markInvalid(msg);
            this.imageField.markInvalid(msg);
        }
    },

    // overriding CQ.form.CompositeField#markInvalid
    clearInvalid : function(){
        if (this.pathField) {
            this.titleField.clearInvalid();
            this.pathField.clearInvalid();
            this.imageField.clearInvalid();
        }
    }

});   
 
// register xtype
CQ.Ext.reg('newsitem', McdonaldsNews.NewsItem);