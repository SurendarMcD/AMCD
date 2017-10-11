/*
 * This wizard is created for creating and handling dmc button functionality.
 */
/*
 * @class
 * @extends CQ.form.CompositeField
 */
CQ.form.searchdmcbutton = CQ.Ext.extend(CQ.form.CompositeField, {
    
    constructor: function(config) {     
        var list = this;        
        this.valueField = new CQ.Ext.form.Hidden({ name:config.name });
        config = CQ.Util.applyDefaults(config, {
            items:[
                    {
                          xtype:"panel", 
                          border:false,
                          items:{ 
                              xtype:"button", 
                              text: CQ.I18n.getMessage('Search DMC') + ':',     
                              handler:function() {     
                                    // Handler code execute on the click of search dmc button
                                    // form object from parent dialog
                                    var fr = this.findParentByType("form").getForm();                                       
                                    // current location of the page
                                    var hoststr=location.toString();
                                    hoststr = hoststr.substring(0,hoststr.indexOf(".html"));
                                    // adding globbing pattern in the file
                                    hoststr = hoststr +".doclink.html"; 
                                    // updating the return url with component id
                                    hoststr = hoststr +"&parName="+fr.getEl().id;
                                    
                                    // opening the dmc window with the return url in the new browser
                                    window.open('https://dmc.accessmcd.com/mcmac/controller.html?srcpgid=home&tgtpgid=search&hidAction=reset&themeid=doclink&returnUrl='+hoststr+'', '', 'location=no,menubar=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes');
                                    
                              }   
                          } 
                      }
            ]
        });
        CQ.form.searchdmcbutton.superclass.constructor.call(this,config);
    }}
);
CQ.Ext.reg("searchdmcbutton", CQ.form.searchdmcbutton);

