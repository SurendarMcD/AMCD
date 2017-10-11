/* 
 * Copyright 1997-2008 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */

/**
 * @class CQ.wcm.FilterRuleField
 * @extends CQ.form.CompositeField
 * The filter rule field lets the user select "include" or "exclude" and enter a regexp
 * @constructor
 * Creates a new FilterRuleField.
 * @param {Object} config The config object
 */
 
Mcdonalds = {};
 
Mcdonalds.Accordion = CQ.Ext.extend(CQ.form.CompositeField, {

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    hiddenField: null,
    
    
    labelField1: null,
    
    labelField2: null,

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    quesField: null,

    /**
     * @private
     * @type CQ.Ext.form.TextArea
     */
    answerField: null,

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
        Mcdonalds.Accordion.superclass.constructor.call(this, config);
    },

    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        Mcdonalds.Accordion.superclass.initComponent.call(this);
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false
        });
        this.add(this.hiddenField);
        
        this.labelField1 = new CQ.Ext.form.Label({
            "html": "<div style='font-size:9px;white-space:normal;'>"+CQ.I18n.getMessage("Option Text (eg:300 X 400 One Column)")+"</div>"           
        });        
        this.add(this.labelField1);

        this.quesField = new CQ.Ext.form.TextField({
            fieldLabel: 'Size Option Text',
            width: '95%',
            allowBlank: false
        });
        this.add(this.quesField);

        this.labelField2 = new CQ.Ext.form.Label({
            "html": "<div style='font-size:9px;white-space:normal;'>"+CQ.I18n.getMessage("Option Value (eg:300x400)")+"</div>"           
                      
        });        
        this.add(this.labelField2);

        this.answerField = new CQ.Ext.form.TextField({
            fieldLabel: 'Size Option Value',
            width: '95%',
            allowBlank: false
        });
        this.add(this.answerField);
        
        this.pathField = new CQ.form.BrowseField ({
            fieldLabel: ' Folder Path',
            width: '95%',
            rootPath: '/content/dam'
        });
        //this.add(this.pathField);
    },

    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        if (!this.quesField) {
            return null;
        }
        var ques = '';
        var ans = '';
        var path = '';
        if (value) {
            var accValue = value.split('|');
            if(accValue.length>0) {
                ques = accValue[0];
                ans = accValue[1];
                //path = accValue[2];
            }
        }
        this.quesField.setValue(ques);
        this.answerField.setValue(ans);
        //this.pathField.setValue(path);
    },

    // overriding CQ.form.CompositeField#getValue
    getValue: function() {
        return this.getRawValue();
    },

    // overriding CQ.form.CompositeField#getRawValue
    getRawValue: function() {
        if (!this.quesField) {
            return null;
        }
        var question = this.quesField.getValue() || "";
        var answer = this.answerField.getValue() || "";
        //var folderPath = this.pathField.getValue() || "";
        //var value = question + "|" + answer + "|" + folderPath;
        var value = question + "|" + answer;
        this.hiddenField.setValue(value);
        return value;
    },
 
    // Validation --------------------------------------------------------------------------

    // overriding CQ.form.CompositeField#markInvalid
    markInvalid : function(msg){
        if (this.quesField) {
            this.quesField.markInvalid(msg);
            this.answerField.markInvalid(msg);
            //this.pathField.markInvalid(msg);
        }
    },

    // overriding CQ.form.CompositeField#markInvalid
    clearInvalid : function(){
        if (this.quesField) {
            this.quesField.clearInvalid();
            this.answerField.clearInvalid();
            //this.pathField.clearInvalid();
        }
    }

});

// register xtype
CQ.Ext.reg('accordionfield', Mcdonalds.Accordion);  