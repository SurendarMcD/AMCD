// Create the namespace
columnselection = {};

// Create a new class based on existing CompositeField
columnselection.Selection = CQ.Ext.extend(CQ.form.Selection, {
      
      text: "default text",
      fireComboboxSelectionChanged:function() {
            var color = this.hiddenField.getValue();
            if(color != null)
            {
                  if((this.Text.value=="" || this.Text.value==undefined))
                  {
                        this.Text.setValue(color);
                  }
                  else
                  {
                        this.Text.setValue(this.Text.value+","+color);
                  }
            }
      },
    constructor : function(config){
        if (config.text != null) this.text = config.text;
        
        var defaults = {
                height: "auto",
                border: false,
                style: "padding:0;margin-bottom:0;",
                layoutConfig: {
                    labelSeparator: CQ.themes.Dialog.LABEL_SEPARATOR
                },
                defaults: {
                    msgTarget: CQ.themes.Dialog.MSG_TARGET
                }
        };

        CQ.Util.applyDefaults(config, defaults);
        columnselection.Selection.superclass.constructor.call(this, config);
        
        var parent=this;
        
        this.Button = new CQ.Ext.Button({
            text: "Clear",
            hideLabel: true,
            tooltip: "Clear",
            handler:function() {
            parent.Text.setValue("");
        }
        });
        
        this.Text = new CQ.Ext.form.TextField({
            hideLabel: true,
            name: this.name+"Value",
            readOnly:true
        });
        
        this.add(this.Text);
        this.add(this.Button);
        
    },
    
    processRecord: function(record, path){
      var colorValue = this.name.replace("./","")+"Value";
      this.Text.setValue(record.get(colorValue));
      this.setValue("");
      this.Button.setValue(record.get(this.title));
      
    }
});

CQ.Ext.reg("columnselection", columnselection.Selection);


