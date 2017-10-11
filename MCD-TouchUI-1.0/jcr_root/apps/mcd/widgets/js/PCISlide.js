/**
 * @class CQ.form.PCIEntries.PCISlide
 * @private
 * Slide represents a single slide of a slideshow (see {@link CQ.form.Slideshow}).
 * @constructor
 * 
 s a new Slide.
 * @param {Object} config The config object
 * Created by Wei Wu
 */
CQ.form.PCIEntries.PCISlide = CQ.Ext.extend(CQ.Ext.emptyFn,  {

    category: null,
    view: null,
    ctitle: null,
    description: null,
    displayType: null,
    publishDate: null,
      
    /**
     * @cfg {Number} slideIndex
     * "Index" of the slide; is used to create unique slide names. Newly created slides
     * will have -1, which will be resolved to a correct value before submitting the
     * form. Defaults to -1.
     */
    slideIndex: 0,

    /**
     * @cfg {Boolean} isPersistent
     * True if the slide is already persisted, false if it has been added in the current
     * user transaction (defaults to false)
     */
    isPersistent: false,

    /**
     * @cfg {Boolean} isDeleted
     * True if the slide has been deleted by the user (defaults to false)
     */
    isDeleted: false,

    constructor: function(config) {
        //console.log("PCISlide construct");
        var defaults = {
            "category": null,
            "view": null,
            "ctitle": null,
            "description": null,
            "displayType": null,
            "publishDate": null,
            "isPersistent": false,
            "isDeleted": false,
            "slideIndex": -1
        };
        CQ.Ext.apply(this, config, defaults)
    },

    createDisplayText: function() {
         //alert("in create display text - title=" + this.title);
        if (this.title) {
            return this.title;
        } else {
            return CQ.I18n.getMessage("New Entry");
        }
    },

    createTransferFields: function(prefix) {
        var fields = [ ];
        var basicName = "./" + prefix.replace("$", this.slideIndex);
        if (!this.isDeleted) {
            var title = basicName + "/EntryTitle";
            
            if (this.title) {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": title,
                    "value": this.title
                }));
            } else {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": title,
                    "value": ""
                }));
            }
            
            var category = basicName + "/Category";
            if (this.category) {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": category,
                    "value": this.category
                }));
            } else {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": category,
                    "value": ""
                }));
            }
           
            var view = basicName + "/View";
            if (this.view) {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": view,
                    "value": this.view
                }));
            } else {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": view,
                    "value": ""
                }));
            }
           
            var ctitle = basicName + "/Title";
            if (this.ctitle) {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": ctitle,
                    "value": this.ctitle
                }));
            } else {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": ctitle,
                    "value": ""
                }));
            }
            
            var description = basicName + "/Description";
            if (this.description) {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": description,
                    "value": this.description
                }));
            } else {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": description,
                    "value": ""
                }));
            }
            
            var displayType = basicName + "/DisplayType";
            if (this.displayType) {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": displayType,
                    "value": this.displayType
                }));
            } else {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": displayType,
                    "value": ""
                }));
            }
            
            var publishDate = basicName + "/PublishDate";
            if (this.publishDate) {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": publishDate,
                    "value": this.publishDate
                }));
            } else {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": publishDate,
                    "value": ""
                }));
            }
        } else if (this.isPersistent) {
            var deletePrm = basicName + CQ.Sling.DELETE_SUFFIX;
            
            
             if (this.title) {
                fields.push(new CQ.Ext.form.Hidden({
                    "name": deletePrm,
                    "value": true
                }));
            } 
        
        }
        return fields;
    }

});
 