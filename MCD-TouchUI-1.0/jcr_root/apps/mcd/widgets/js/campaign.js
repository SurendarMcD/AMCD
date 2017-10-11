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
 
McdonaldsCamp = {};
 
McdonaldsCamp.Campaign = CQ.Ext.extend(CQ.form.CompositeField, {

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */


    hiddenField: null,
    
    
    imageLabel: null,
    
    linkLabel: null,
    
    adLabel:null,
    

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
   
    globalTextLabel : null,
    
    globalText : null,
    
    audienceLabel : null , 
    
    chk : null,
    
    ontimeLabel : null,
    
    ontimeDate : null,
    
     offtimeLabel : null,
    
    offtimeDate : null , 
    
    cug : null,
    
    path1 : null,
    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": true,
            "stateful": false,
            "style": "padding:5px 0 0 5px;"
          };
        config = CQ.Util.applyDefaults(config, defaults);
        McdonaldsCamp.Campaign.superclass.constructor.call(this, config);
    },

    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        McdonaldsCamp.Campaign.superclass.initComponent.call(this);
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false 
        });
        this.add(this.hiddenField);
        
        this.imageLabel = new CQ.Ext.form.Label({
           html: CQ.I18n.getMessage('Image') + ':',    
           style:'float:left;width:163px;',    
            labelStyle: 'float:left;margin-right:125px;'
        });        
        this.add(this.imageLabel);            

        this.imagePath = new CQ.form.BrowseField({
             style:'width:220px;margin-top:0px;', 
             width:'100%'  
        }); 
        this.add(this.imagePath); 

        this.globalTextLabel = new CQ.Ext.form.Label({   
           html : CQ.I18n.getMessage('Global Ad Text') + ':', 
           style:'float:left;width:163px;' ,            
         labelStyle: 'float:left;margin-right:24px;'  
        });     
        this.add(this.globalTextLabel);
 
        this.globalText = new CQ.Ext.form.TextField({
             width: '237px',
             labelStyle :'',
             //fieldDescription : '<span style="margin-left:-105px;padding-left:0px;#margin-left:-105px;">To be displayed in Navigation bar</span>',
             "stateful": false,
             "border":true,
             "hideLabel":true     
        });     
        this.add(this.globalText);
        
        this.adLabel = new CQ.Ext.form.Label({
            html: CQ.I18n.getMessage('To be displayed in Navigation bar'),
            style:'margin-left:2px;font-size:10px;font-family:Verdana;color:#999999;'           
        });
           
        this.add(this.adLabel);
        
        this.linkLabel = new CQ.Ext.form.Label({
            html: CQ.I18n.getMessage('Links') + ':',
            style:'float:left;margin-right:133px;margin-top:18px;' ,          
         labelStyle: 'float:left;margin-right:106px;'
        });     
        
        this.add(this.linkLabel);
        
     
        this.linkPath = new CQ.form.BrowseField({
            style:'width:220px;margin-top:0px;', 
            width:'100%',
            allowBlank: false  
        });
        this.add(this.linkPath); 
        
         this.audienceLabel = new CQ.Ext.form.Label({
           html : CQ.I18n.getMessage('Audience Group') + ':',
          style:'float:left;width:163px;'      ,      
             labelStyle: 'float:left;'        
        });     
        this.add(this.audienceLabel);

        var pageHandle=location.toString();

        var url2 = pageHandle.substring(pageHandle.lastIndexOf('/') + 1);
        var url1 = pageHandle.substring(0,pageHandle.lastIndexOf('/'));
        var temp = new Array();
        temp = url2.split('.');
        pageHandle = url1 + '/' +  temp[0] + '.AudienceType.html';
    //    var pageHandle = location.toString();
     //   pageHandle = pageHandle.replace(".html",".AudienceType.html");
        var nsOptions = CQ.Util.eval(CQ.HTTP.get(pageHandle));    
        this.chk = new CQ.form.MultiField({
        fieldConfig : 
         {  
             xtype : "selection" , 
             type : "select" ,  
             options : nsOptions,
             boxMaxWidth:255,
             padding:"5px 0px 0px 0px"
         }
        });
        this.add(this.chk);
        
       this.ontimeLabel = new CQ.Ext.form.Label({
           html : CQ.I18n.getMessage('On Time') + ':',
          style:'float:left;width:163px;' ,           
         labelStyle: 'float:left;margin-right:71px;'
        });        
        this.add(this.ontimeLabel);
        
         this.ontimeDate = new CQ.Ext.form.DateField({
             format : 'm-d-y',
             style : 'margin-top:0px;',  
              allowBlank: false           
        });     
        this.add(this.ontimeDate);
        
        this.offtimeLabel = new CQ.Ext.form.Label({
           html : CQ.I18n.getMessage('Off Time') + ':',
          style:'float:left;width:163px;' ,           
          labelStyle: 'float:left;margin-right:74px;'
        });     
        this.add(this.offtimeLabel);     
        
         this.offtimeDate = new CQ.Ext.form.DateField({
               format : 'm-d-y',
               style : 'margin-top:0px;' ,   
                allowBlank: false ,
                   listeners: {
           select: function(aa,b) {
               var a =this.findParentByType('campaign');
             if(a.ontimeDate.getValue() > b)
             {
                alert(CQ.I18n.getMessage('On Date cannot be greater than Off Date'));
                a.offtimeDate.setValue('');  
             }  
             
              
        }    
        }
        });     
        this.add(this.offtimeDate);
   },

    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        if (!this.imagePath) {
            return null;
        }
        var img = '';
        var link = '';
        var path = '';
        var txt = '';
        var ontime ='';
        var offtime ='';
        var  chek =new Array();
        if (value) {
            var accValue = value.split('|');
            if(accValue.length>0) {
                img = accValue[0];
                link = accValue[1]; 
                txt  = accValue[2]; 
                chek = accValue[3].split(',');
                ontime = accValue[4]; 
                offtime  = accValue[5];
                
            }
        }
        this.imagePath.setValue(img);
        this.linkPath.setValue(link);
        this.globalText.setValue(txt);
        this.chk.setValue(chek);
        if(ontime =='')
        {
         this.ontimeDate.setValue('');
        } 
        else
        {
         this.ontimeDate.setValue(new Date(ontime));
        }
        if(offtime =='')
        {
         this.offtimeDate.setValue('');
        } 
        else
        {
         this.offtimeDate.setValue(new Date(offtime));
        } 
        
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
        var txt = this.globalText.getValue() || "";
        var aud= new Array();
        var ontime = this.ontimeDate.getValue() || "";
        var offtime = this.offtimeDate.getValue() || "";
        aud= this.chk.getValue();
        var opt = "" 
        if(aud.length > 0) 
        {
          opt = aud[0];
          for(var i =1 ; i< aud.length ; i++)
          {
            opt = aud[i] + "," + opt;
          }
        }
        var value = img + "|" + link + "|" + txt + "|" + opt + "|" + ontime + "|" + offtime ;
        this.hiddenField.setValue(value);
        return value;
    },
 
    // Validation --------------------------------------------------------------------------

    // overriding CQ.form.CompositeField#markInvalid
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
CQ.Ext.reg('campaign', McdonaldsCamp.Campaign); 
  