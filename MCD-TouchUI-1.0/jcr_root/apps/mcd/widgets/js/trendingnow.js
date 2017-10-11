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
 
McdonaldsTrendingNow = {};
 
McdonaldsTrendingNow.TrendingNow = CQ.Ext.extend(CQ.form.CompositeField, {
    
    hiddenField: null,    
    
    keyword: null,   
    
    keywordField: null,
    
    fontSize: null,
    
    fontField: null,
    
    linkLabel: null,
    
    linkField: null,
    
    linkType: null,     
    
    groupsLabel: null,  
    
    groupsList: null,  
    
    
    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": true,
            "stateful": false,
            "style": "padding:5px 0 0 5px;"
          };
        config = CQ.Util.applyDefaults(config, defaults);
        McdonaldsTrendingNow.TrendingNow.superclass.constructor.call(this, config);
    },
    
    initComponent: function(){
        McdonaldsTrendingNow.TrendingNow.superclass.initComponent.call(this);
       
        
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false 
        });
        this.add(this.hiddenField);
        
        this.keyword = new CQ.Ext.form.Label({
            html: CQ.I18n.getMessage('Keyword')+'*',    
            style:'float:left;width:163px;',    
            labelStyle: 'float:left;margin-right:125px;'
        });        
        this.add(this.keyword); 
        
        this.keywordField = new CQ.Ext.form.TextField({
            width: '95%',
            hideLabel: true,
            name: 'keyword',
            allowBlank: false
        });
        
        this.add(this.keywordField);
        
        this.fontSize = new CQ.Ext.form.Label({
            html: CQ.I18n.getMessage('Font Size')+' (9-24pts.)*',    
            style:'float:left;width:163px;',    
            labelStyle: 'float:left;margin-right:125px;'
        });        
        this.add(this.fontSize); 
        
        
        this.fontField = new CQ.Ext.form.TextField({
            width: '95%',
            vtype: 'checkNumber',            
            hideLabel: true
        });
        this.add(this.fontField); 
        
        this.linkLabel = new CQ.Ext.form.Label({
            html: CQ.I18n.getMessage('Link')+'*',    
            style:'float:left;width:163px;',    
            labelStyle: 'float:left;margin-right:125px;'
        });        
        this.add(this.linkLabel); 
        
        
        this.linkField = new CQ.form.PathField({
            style:'width:340px;', 
            rootPath: "/content/accessmcd",
            hideLabel: true,
            width:'100%',
            allowBlank: false,
            name: 'linkURL'
        });
        this.add(this.linkField);  
        
        this.groupsLabel = new CQ.Ext.form.Label({
            html : CQ.I18n.getMessage('Allowed Access')+':',
            style:'float:left;width:163px;'      ,      
            labelStyle: 'float:left;'        
        });     
        this.add(this.groupsLabel); 
        
        
        var pageHandle=location.toString();        
        var url2 = pageHandle.substring(pageHandle.lastIndexOf('/') + 1);        
        var url1 = pageHandle.substring(0,pageHandle.lastIndexOf('/'));

        var temp = new Array();
        temp = url2.split('.');
        pageHandle = url1 + '/' +  temp[0] + '.AudienceType.html';

        var nsOptions = CQ.Util.eval(CQ.HTTP.get(pageHandle));         
        
        this.groupsList = new CQ.form.MultiField({
        
        hideLabel: true,  
        
        fieldConfig : 
        {  
             xtype : 'selection',
             type: 'select',
             options : nsOptions,
             padding:"5px 0px 0px 0px"
        },
        unstyled:true,
            width:650


        });
        this.add(this.groupsList);
  
        this.chkType = new CQ.Ext.form.Checkbox({
            boxLabel: CQ.I18n.getMessage('Open link in New Window')
            //style:'margin-left:125px;'
        });
          
        this.add(this.chkType);

        var reqExp = /^([0-9])/;  

        this.checkFontSize = new CQ.Ext.apply(CQ.Ext.form.VTypes, {
              
            checkNumber: function(val, field) {
            return reqExp.test(val);
            },
            // vtype Text property: The error text to display when the validation function returns false
            checkNumberText: 'Not a valid value.  Must be a number between 9 & 24'                      
        });

        this.add(this.checkFontSize);

      },  
            
  
    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        //alert("IN SET METHOD");
        if (!this.keywordField) {
            return null;
        }
        var key = '';
        var fontsize = '';
        var link = '';
        var group = new Array();
        var box = '';        
        
        if (value) {
            var accValue = value.split('|');
            if(accValue.length>0) {
                key = accValue[0]; 
                fontsize = accValue[1]; 
                link = accValue[2];  
                group = accValue[3].split(',');
                box = accValue[4];
                                 
            }
        }
        this.keywordField.setValue(key);
        this.fontField.setValue(fontsize);
        this.linkField.setValue(link);
        this.groupsList.setValue(group);
        this.chkType.setValue(box);
    },
    
    // overriding CQ.form.CompositeField#getValue
    getValue: function() {
        return this.getRawValue();
    },
    
    // overriding CQ.form.CompositeField#getRawValue
    getRawValue: function() {
        //alert("IN GET RAW VALUE");
        if (!this.keywordField) {
            return null;
        }
        
        var key = this.keywordField.getValue() || "";
        var fontsize = this.fontField.getValue() || "";
        var link = this.linkField.getValue() || "";
        var group = new Array();
        group = this.groupsList.getValue();
        //alert("Group"+group);  
        var groups = '';
        if(group.length > 0) 
        {
          groups = group[0];
          for(var i =1 ; i< group.length ; i++)
          {
            groups = group[i] + "," + groups;
          }
        } 
        
        var box =  this.chkType.getValue();
        var value = key + "|" + fontsize + "|" + link + "|" + group + "|" + box;
       
        this.hiddenField.setValue(value);
        return value;
    }
    



});


// register xtype
CQ.Ext.reg('trendingnow', McdonaldsTrendingNow.TrendingNow);    