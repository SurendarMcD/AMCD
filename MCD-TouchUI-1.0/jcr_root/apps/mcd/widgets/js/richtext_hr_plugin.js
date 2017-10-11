/* Plugin for Rich Text Editor to display toolbar button for Horizontal Rule (HR)
   modeled after misctools plugin
   Erik Wannebo 7/14/2010
   
   */
   
   CQ.form.rte.plugins.HRPlugin = CQ.Ext.extend(CQ.form.rte.plugins.Plugin, {

    
     /**
     * @private
     */
    hrUI: null,


    /**
     * @private
     */
    hrDialog: null,

    constructor: function(editorKernel) {
        CQ.form.rte.plugins.HRPlugin.superclass.constructor.call(this, editorKernel);
    },

    getFeatures: function() {
        return [ "hrplugin" ];
    },

    initializeUI: function(tbGenerator) {
        var plg = CQ.form.rte.plugins;
        var ui = CQ.form.rte.ui;
        if (this.isFeatureEnabled("hrplugin")) {
            this.hrUI = new ui.TbElement("hrplugin", this, false,
                    this.getTooltip("hrplugin"));
            tbGenerator.addElement("hr", plg.Plugin.SORT_MISC, this.hrUI, 100);
        }
        
    },

    /**
     * Inserts an HR tag
     * @private
     */

    insertHR: function(context) {
        
        /*
        var frm = this.hrWindow.getComponent('insert-hr').getForm();
        if (frm.isValid()) {
            var hrwidth = frm.findField('hrwidth').getValue();
            if (hrwidth) {
                this.cmp.insertAtCursor('<hr width="'+hrwidth+'">');
            }else{
                this.cmp.insertAtCursor('<hr width="100%">');
            }
            this.hrWindow.close();
        }
        
        if (CQ.Ext.isIE) {
            this.savedRange.select();
        }
        */
        this.editorKernel.relayCmd("InsertHTML", '<hr width="100%">');
    },

    notifyPluginConfig: function(pluginConfig) {
        // configuring "hrplugin" dialog
        pluginConfig = pluginConfig || { };
        var defaults = {
            "hrConfig": {
                
            },
            "tooltips": {
                "hrplugin": {
                    "title": CQ.I18n.getMessage("Horizontal Rule"),
                    "text": CQ.I18n.getMessage("Insert Horizontal Rule")
                }
            }
        };

        CQ.Util.applyDefaults(pluginConfig, defaults);
        this.config = pluginConfig;
    },

    execute: function(id, value, options) {
        var context = options.editContext;
        if (id == "hrplugin") {
            this.insertHR(context);
        } 
    },

    updateState: function(selDef) {
        var context = selDef.editContext;
        if (this.hrUI != null) {
            var cells = selDef.nodeList.getTags(context, [{
                    "tagName": [ "hr" ]
                }
            ], false);
            var disable = (cells.length > 0);
            this.hrUI.getExtUI().setDisabled(disable);
        }
    }

});


// register plugin
CQ.form.rte.plugins.PluginRegistry.register("hrplugin",
        CQ.form.rte.plugins.HRPlugin);/*
        
        
   
  /* 
   
   Ext.ux.form.HtmlEditor.HR = CQ.Ext.extend(CQ.Ext.util.Observable, {
    init: function(cmp){
        this.cmp = cmp;
        this.cmp.on('render', this.onRender, this);
    },
    onRender: function() {
        var cmp = this.cmp;
        var btn = this.cmp.getToolbar().addButton({
          iconCls: 'x-edit-hr',
          handler: function() {
            this.hrWindow = new CQ.Ext.Window({
                title: 'Insert Rule',
                items: [{
                    itemId: 'insert-hr',
                    xtype: 'form',
                    border: false,
                    plain: true,
                    bodyStyle: 'padding: 10px;',
                    labelWidth: 60,
                    labelAlign: 'right',
                    items: [{
                        xtype: 'label',
                        html: 'Enter the width of the Rule in percentage<br/> followed by the % sign at the end, or to<br/> set a fixed width ommit the % symbol.<br/>&nbsp;'
                    },{
                        xtype: 'textfield',
                        maskRe: /[0-9]|%/,
                        regex: /^[1-9][0-9%]{1,3}/,
                        fieldLabel: 'Width',
                        name: 'hrwidth',
                        width: 60,
                        listeners: {
                            specialkey: function(f, e){
                                if (e.getKey() == e.ENTER || e.getKey() == e.RETURN){
                                    this.insertHR();
                                }
                            },
                            scope: this
                        }
                    }]
                }],
                buttons: [{
                    text: 'Insert',
                    handler: this.insertHR,
                    scope: this
                }, {
                    text: 'Cancel',
                    handler: function() {
                      this.hrWindow.close();
                    },
                                        scope: this
                }]
            }).show();
          },
          scope: this,
          tooltip: 'Insert Horizontal Rule'
        });
    },
    insertHR: function() {
        var frm = this.hrWindow.getComponent('insert-hr').getForm();
        if (frm.isValid()) {
            var hrwidth = frm.findField('hrwidth').getValue();
            if (hrwidth) {
                this.cmp.insertAtCursor('<hr width="'+hrwidth+'">');
            }else{
                this.cmp.insertAtCursor('<hr width="100%">');
            }
            this.hrWindow.close();
        }
    }
});

CQ.form.rte.plugins.PluginRegistry.register("hrplugin",
        Ext.ux.form.HtmlEditor.HR);
*/