/**
 * @class Mcdonalds.Accordion
 * @extends CQ.form.CompositeField
 * The accordion field lets the user to enter a question, answer and select a folder path from DAM.
 * @constructor
 * Creates a new AccordionField.
 * @param {Object} config The config object
 */ 

 
Mcdonald = {}; //creating namespace
 
Mcdonald.USAccordion = CQ.Ext.extend(CQ.form.CompositeField, {

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    hiddenField: null,

    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    quesField: null,

    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    quesLabel: null,

    /**
     * @private
     * @type CQ.Ext.form.TextArea
     */
    answerField: null,

    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    answerLabel: null,
    
    tip : null,
    
   
    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": true,
            "stateful": false,
            "style": "padding:5px 0 0 5px;"
        };
        config = CQ.Util.applyDefaults(config, defaults);
        Mcdonald.USAccordion.superclass.constructor.call(this, config);
    },
  
    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        Mcdonald.USAccordion.superclass.initComponent.call(this);
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false     
        });
        this.add(this.hiddenField);
        var msg = 'a';
        this.tip= new CQ.Ext.form.Label({
        html : msg,
        style:'margin-left:2px;font-size:10px;font-family:Verdana;color:#999999;font-weight:bold;'  ,
        listeners: {
           render: function(a) {
               var a =this.findParentByType('dialog');
               var b = a.getField('./accordiandata');
               var len = 0; var ele = b.getValue();
               for(var i = 0; i < ele.length ; i++)
               {
                len = len + ele[i].length;
               }
                             
               len = 8001 - len;
               var nq = 11 - ele.length;
               var msg;
               if(nq > 0 && len > 0)
               {
                 msg = CQ.I18n.getMessage('Note : More than ') + len + CQ.I18n.getMessage(' characters or ') + nq + CQ.I18n.getMessage(' Questions might result in an unresponsive dialog') ;
               }
               else  
               {
                 msg = CQ.I18n.getMessage('Note : This dialog might get unresponsive') ;
               }
               this.setText(msg);
             }    
        } 
           });
        this.add(this.tip);
    

          this.quesLabel = new CQ.Ext.form.Label({
            html: '<br> '+  CQ.I18n.getMessage('Question') + ':'
             });  
        
            this.add(this.quesLabel );   
            
      
        this.quesField = new CQ.Ext.form.TextField({
            width: '95%',
            "border":true
          });
        this.add(this.quesField);
 
          
        this.answerLabel = new CQ.Ext.form.Label({
            html: CQ.I18n.getMessage('Answer') + ':',
            width: '100%'
        });
        this.add(this.answerLabel);
        
        //Object to disable the indent and outdent features
        richPlugins = ({
            lists: ({features:['ordered','unordered']})
        });
        this.answerField = new CQ.form.RichText({
            hideLabel: true,
            rtePlugins: richPlugins, 
            //width: '95%',
            //updated - Hemant HCL - 11/18/2010
            //Configure the accepted protocols for links in RichText Editor text
           
            linkbrowseConfig: ({"protocols":["https://","http://","ftp://","mailto:"]})   
        });
        this.add(this.answerField);
    }, 

    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        if (!this.quesField) {
            return null;
        }
        var ques = '';
        var ans = '';
        if (value) {
            var accValue = value.split('|');            
            if(accValue.length>0) {
                ques = accValue[0];
                ques=ques.replace(/\(pipeseparator\)/g,'|');
                ans = accValue[1];
                ans=ans.replace(/\(pipeseparator\)/g,'|');
            }
        }
        this.quesField.setValue(ques);
        this.answerField.setValue(ans);
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
        question=question.replace(/\|/g,"(pipeseparator)");
        var answer = this.answerField.getValue() || "";
        answer=answer.replace(/\|/g,"(pipeseparator)");
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
        }
    },

    // overriding CQ.form.CompositeField#markInvalid
    clearInvalid : function(){
        if (this.quesField) {
            this.quesField.clearInvalid();
            this.answerField.clearInvalid();
        }
    }

});

// register xtype
CQ.Ext.reg('usaccordionitem', Mcdonald.USAccordion); 
      
