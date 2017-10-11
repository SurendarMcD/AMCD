/** 
 * @class McDUserAction.UserActions 
 * @extends CQ.form.CompositeField
 * The accordion field lets the user to enter a question, answer and select a folder path from DAM.
 * @constructor
 * Creates a new AccordionField.
 * @param {Object} config The config object 
 */ 
 
 
McDUserAction = {}; //creating namespace
 
McDUserAction.UserActions = CQ.Ext.extend(CQ.form.CompositeField, {

    /**
     * @private
     * @type CQ.Ext.form.TextField    
     */
    hiddenField: null,

    /**
     * @private
     * @type CQ.form.Selection
     */
    linkType: null,

    /**
     * @private
     * @type CQ.form.Selection
     */

    linkPosition:null,

    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    linkTypeLabel: null,


    /**
     * @private
     * @type CQ.Ext.form.Label
     */

    linkPositionLabel:null,
    
    /**
     * @private
     * @type CQ.Ext.form.TextField
     */
    linkText: null,

    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    linkTextLabel: null,

    /**
     * @private
     * @type CQ.form.BrowseField
     */
    linkField: null,

    /**
     * @private
     * @type CQ.Ext.form.Label
     */
    linkLabel: null,
    
    chkbox : null,
    

    constructor: function(config) {
        config = config || { };
        var defaults = {
            "border": true,
            "stateful": false,
            "style": "padding:5px 0 0 5px;"
        };
        config = CQ.Util.applyDefaults(config, defaults);
        McDUserAction.UserActions.superclass.constructor.call(this, config);
    },

    // overriding CQ.Ext.Component#initComponent
    initComponent: function() {
        McDUserAction.UserActions.superclass.initComponent.call(this);
        this.hiddenField = new CQ.Ext.form.Hidden({
            name: this.name,
            "stateful": false
        });
        this.add(this.hiddenField);

        this.linkTypeLabel = new CQ.Ext.form.Label({
            html:  CQ.I18n.getMessage('Link Type') + ' :'  
        });  
        this.add(this.linkTypeLabel);




         this.chkbox = new CQ.Ext.form.Checkbox({
         hidden : true ,
         boxLabel: CQ.I18n.getMessage('New Window'), 
         value : '1'
         });
        
        
        this.linkType = new CQ.form.Selection ({
            width: '95%',
            options: [{"text":CQ.I18n.getMessage("Help"),"value":"help"},{"text":CQ.I18n.getMessage("Share"),"value":"share"},{"text":CQ.I18n.getMessage("Feedback"),"value":"feedback"}, {"text":CQ.I18n.getMessage("Print"),"value":"print"},{"text":CQ.I18n.getMessage("Advanced Search"),"value":"search"},{"text":CQ.I18n.getMessage("My Bookmarks Link"),"value":"bookmark"},{"text":CQ.I18n.getMessage("My Account"),"value":"account"},{"text":CQ.I18n.getMessage("Others"),"value":"other"}],
            type: 'select',
            hideLabel: true ,
            listeners: {
           selectionchanged: function(value) {
            if(value.getValue() == 'other')
            {
             var a =this.findParentByType('userActionLinks');
            
             a.chkbox.setVisible(true);
             var b = a.getElementByType('Checkbox');
            }
            else
            {
             var a =this.findParentByType('userActionLinks');
              a.chkbox.setVisible(false);
            }

        }
        }

        });
        this.add(this.linkType);

        this.linkPositionLabel = new CQ.Ext.form.Label({
            html:  CQ.I18n.getMessage('Link Position') + ' :'  
        }); 
         this.add(this.linkPositionLabel);

         this.linkPosition = new CQ.form.Selection ({
            width: '95%',
            options: [{"text":CQ.I18n.getMessage("UpperLeft"),"value":"UpperLeft"},{"text":CQ.I18n.getMessage("UpperRight"),"value":"UpperRight"},{"text":CQ.I18n.getMessage("BottomRight"),"value":"BottomRight"}],
            type: 'select',
            hideLabel: true,
            allowBlank:false
            

        });
        this.add(this.linkPosition);

        this.linkTextLabel = new CQ.Ext.form.Label({
            html: CQ.I18n.getMessage('Link Text') + ' :'
        });
        this.add(this.linkTextLabel);


        
        this.linkText = new CQ.Ext.form.TextField({
            width: '95%',
            "border": true            
        });
        this.add(this.linkText);
        
        this.linkLabel = new CQ.Ext.form.Label({
            html: CQ.I18n.getMessage('Link URL') + ':'
        });
        this.add(this.linkLabel);
        
        this.linkField = new CQ.form.BrowseField({
            hideLabel: true, 
            width: '180px' 
        });
        this.add(this.linkField);
       
        this.add(this.chkbox);
      
      
    }, 

    // overriding CQ.form.CompositeField#setValue
    setValue: function(value) {
        if (!this.linkText) {
            return null;
        }
        var type = '';
        var position = '';
        var linkTxt = '';
        var linkValue = '';
        var chk ;
        if (value) {
            var accValue = value.split('|');
            if(accValue.length>0) {
                type = accValue[0];

                linkTxt = accValue[1];
                linkValue = accValue[2];
                chk = accValue[3];
                 position= accValue[4];
            }
        }
        this.linkType.setValue(type);

        this.linkText.setValue(linkTxt);
        this.linkField.setValue(linkValue);
        this.chkbox.setValue(chk);
        this.linkPosition.setValue(position);
    },

    // overriding CQ.form.CompositeField#getValue
    getValue: function() {
        return this.getRawValue();
    }, 
    
 
    // overriding CQ.form.CompositeField#getRawValue
    getRawValue: function() {
        if (!this.linkText) {
            return null;
        }
        
        var type = this.linkType.getValue() || "";
        var position = this.linkPosition.getValue() || "";
        var txt = this.linkText.getValue() || "";
        var url = this.linkField.getValue() || "";
        var chek ;
        chek =  this.chkbox.getValue();
        if(this.linkType.getValue() == 'other')
        {
           this.chkbox.setVisible(true);
        } 
        var value = type +"|"+txt + "|" + url +  "|" + chek+ "|" + position;
        this.hiddenField.setValue(value);
        return value;
    },
 
    // Validation --------------------------------------------------------------------------

    // overriding CQ.form.CompositeField#markInvalid
    markInvalid : function(msg){
        if (this.linkText) {
            this.linkText.markInvalid(msg);
            this.linkField.markInvalid(msg);
        }
    },

    // overriding CQ.form.CompositeField#markInvalid
    clearInvalid : function(){
        if (this.linkText) {
            this.linkText.clearInvalid();
            this.linkField.clearInvalid();
        }
    }

});

// register xtype
CQ.Ext.reg('userActionLinks', McDUserAction.UserActions );  

 