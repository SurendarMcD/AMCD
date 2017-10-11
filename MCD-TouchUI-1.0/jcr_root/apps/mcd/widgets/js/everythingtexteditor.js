/* Custom version of In Place Text Editor 
* 6/14/2011 Erik Wannebo
*/ 
console.log("everything text editor start");
CQ.ipe.mcdEverythingTextEditor = CQ.Ext.extend(CQ.ipe.TextEditor, {

getTextDiv: function(compElement) {
//CUSTOM_MCD changed selector to focus only on text area of Everything component
        var textDiv = CQ.Ext.DomQuery.selectNode("div.everythingText", compElement.dom);
//END CUSTOM_MCD
        if (!textDiv) {
            //create a new div in place of img placeholder
            var imgplaceholder=CQ.Ext.DomQuery.selectNode(".cq-text-placeholder", compElement.dom);
            if(imgplaceholder){
                CQ.Ext.DomHelper.insertBefore(imgplaceholder,"<div class='everythingText'></div>",false);
                textDiv = CQ.Ext.DomQuery.selectNode("div.everythingText", compElement.dom);
                CQ.Ext.get(imgplaceholder).remove();
             }else{
                alert('not found');
                }
            if(!textDiv){
                throw new Error("No text div found; probably you are using an invalid "
                    + "InplaceEditor for your component.");
            }
        }
        return textDiv;
      }

});

CQ.ipe.InplaceEditing.register("everythingtext", CQ.ipe.mcdEverythingTextEditor); 