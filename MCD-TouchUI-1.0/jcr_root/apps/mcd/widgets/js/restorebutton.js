/*
 * This wizard is created for creating and handling restore to default button functionality.
 * Changed to simply clear out fields, which are then re-populated from Site settings by parsys.jsp
 * 5-27-2010 Erik Wannebo
 */
/*
 * @class
 * @extends CQ.form.CompositeField
 */
CQ.form.restorebutton = CQ.Ext.extend(CQ.form.CompositeField, {
    constructor: function(config) {     
        var list = this;        
        this.valueField = new CQ.Ext.form.Hidden({ name:config.name });
        this.sitelevelproperties=null;
        config = CQ.Util.applyDefaults(config, {
            items:[
                    {
                          xtype:"panel", 
                          border:false,
                          items:{ 
                              xtype:"button", 
                              text: CQ.I18n.getMessage('Restore Default') + ':',    
                              handler:function() {     
                                    // Handler code execute on the click of Restore Default button
                                    // form object from parent dialog
                                    var index = 0;
                                    var fr = this.findParentByType("form").getForm();
                                    var rb=this.findParentByType("restorebutton")
                                    rb.getSiteLevelProperties();

                                    fr.findField("./paddingBottom").setValue(rb.sitelevelproperties.paddingBottom);
                                    fr.findField("./paddingTop").setValue(rb.sitelevelproperties.paddingTop);
                                    fr.findField("./paddingRight").setValue(rb.sitelevelproperties.paddingRight);
                                    fr.findField("./paddingLeft").setValue(rb.sitelevelproperties.paddingLeft);
                                    fr.findField("./marginBottom").setValue(rb.sitelevelproperties.marginBottom);
                                    fr.findField("./marginTop").setValue(rb.sitelevelproperties.marginTop);
                                    fr.findField("./marginRight").setValue(rb.sitelevelproperties.marginRight);
                                    fr.findField("./marginLeft").setValue(rb.sitelevelproperties.marginLeft);                        
                                    
                                    var colorfield=CQ.Ext.getCmp('mcdsitecolorclasslist');
                                    CQ.Ext.each(colorfield.findByType('mcdsitecolorclasslistitem'),function(item){
                                        colorfield.remove(item);
                                    });
                            
                                    colorfield.setValue(rb.sitelevelproperties.backgroundColumnctrl);
                                    fr.findField("./useSiteLevel").setValue("y");        
                                    colorfield.doLayout();
                                    fr.findField("./checkColumnctrl").setValue((rb.sitelevelproperties.checkColumnctrl=="check"));

                              }   
                          } 
                      }
            ],
            /* checks useSiteLevel field */
            listeners: {
                render: function(comp) {
                    var parentDialog = comp.findParentByType("dialog");
                    if (parentDialog) {
                        parentDialog.on("beforesubmit", function(e) {
                            var restorebuttons=this.findByType('restorebutton');
                            restorebuttons[0].compareToSiteLevel();
                        });
                    }
                }
            }
        });
        CQ.form.restorebutton.superclass.constructor.call(this,config);
    },
    compareToSiteLevel: function(){
        var fr = this.findParentByType("form").getForm();
        this.getSiteLevelProperties();
        var bUsingSiteLevelProperties=true;
        var slp=this.sitelevelproperties;
        if(slp!=null){
          if(
          slp.backgroundColumnctrl!=fr.findField("./backgroundColumnctrl").getValue()
          || ((typeof slp.paddingBottom != 'undefined') && slp.paddingBottom!=fr.findField("./paddingBottom").getValue())
          || ((typeof slp.paddingTop != 'undefined') && slp.paddingTop!=fr.findField("./paddingTop").getValue())
          || ((typeof slp.paddingRight != 'undefined') && slp.paddingRight!=fr.findField("./paddingRight").getValue())
          || ((typeof slp.paddingLeft != 'undefined') && slp.paddingLeft!=fr.findField("./paddingLeft").getValue())
          || ((typeof slp.marginBottom != 'undefined') && slp.marginBottom!=fr.findField("./marginBottom").getValue())
          || ((typeof slp.marginTop != 'undefined') && slp.marginTop!=fr.findField("./marginTop").getValue())
          || ((typeof slp.marginRight != 'undefined') && slp.marginRight!=fr.findField("./marginRight").getValue())
          || ((typeof slp.marginLeft != 'undefined') && slp.marginLeft!=fr.findField("./marginLeft").getValue())
          || (slp.checkColumnctrl=="check")!=fr.findField("./checkColumnctrl").getValue()
          )bUsingSiteLevelProperties=false;
          //alert(bUsingSiteLevelProperties);
          fr.findField("./useSiteLevel").setValue((bUsingSiteLevelProperties)?"y":"");
        }
        
    },
    getSiteLevelProperties: function(){
           if(this.sitelevelproperties!=null)return;
           /* retrieve site-level values from siteLevelProperties */
            var pageHandle=location.toString();
            pageHandle=pageHandle.replace('.html','/jcr:content.style.json');
            var json= CQ.Util.eval(CQ.HTTP.get(pageHandle));
            if(json && json.sitelevelproperties)this.sitelevelproperties=json.sitelevelproperties;  
    }  
    }
);
CQ.Ext.reg("restorebutton", CQ.form.restorebutton);

