<html>
 <head> 
    <title>CQ Benchmark Page</title>
<script id="source1" language="javascript" >
var perfdata=[];
var starttime=new Date();
</script>

<script type="text/javascript" src="/etc/clientlibs/foundation/librarymanager.js"></script>
<script type="text/javascript"> 
CQClientLibraryManager.write([{"p":"/libs/cq/ui/widgets/themes/default.css","c":["!touch"]},{"p":"/libs/cq/touch/widgets/themes/default.css","c":["touch"]},{"p":"/libs/cq/analytics/widgets/themes/default.css","c":["!touch"]},{"p":"/libs/cq/security/widgets/themes/default.css","c":["!touch"]},{"p":"/libs/cq/tagging/widgets/themes/default.css","c":["!touch"]}],false);
</script>
<script type="text/javascript"> 
CQClientLibraryManager.write([{"p":"/etc/clientlibs/foundation/jquery.js","c":[]},{"p":"/etc/clientlibs/foundation/shared.js","c":[]},{"p":"/libs/cq/ui/widgets.js","c":["!touch"]},{"p":"/libs/cq/touch/widgets.js","c":["touch"]},{"p":"/libs/cq/analytics/widgets.js","c":["!touch"]},{"p":"/libs/cq/security/widgets.js","c":["!touch"]},{"p":"/libs/cq/tagging/widgets.js","c":["!touch"]},{"p":"/apps/mcd/widgets.js","c":[]},{"p":"/libs/cq/ui/widgets/themes/default.js","c":["!touch"]},{"p":"/libs/cq/security/widgets/themes/default.js","c":["!touch"]},{"p":"/libs/cq/tagging/widgets/themes/default.js","c":["!touch"]}],false);
</script>

 </head>
    <body style="font-family:Arial,Helvetica,sans-serif;" onload="bodyload();">
<h2>Benchmark Page</h2>

  <script type="text/javascript">
          function fct() {
            if((typeof (CQ) != 'undefined') 
                && (typeof (CQ.WCM) != 'undefined') )
                CQ.WCM.launchSidekick("/content/accessmcd/test", {
                propsDialog: "/apps/mcd/components/page/g2g/dialog",
                locked: false
            })
            else
              setTimeout(fct,5);
        };
        
    </script>
<script>
var elapsed=(new Date())-starttime;
document.write("<b>Elapsed:</b> "+elapsed+"ms.");

CQ.Ext.QuickTips.init();  // enable tooltips
/*
var htmled = new CQ.Ext.form.HtmlEditor({
    renderTo: CQ.Ext.getBody(),
    width: 800,
    height: 300,
    
});
*/

new CQ.Ext.form.HtmlEditor({
    renderTo: CQ.Ext.getBody(),
    width: 800,
    height: 300,
    afterRender: (function(){var elapsed=(new Date())-starttime;
document.write("<b>Editor rendered:</b> "+elapsed+"ms.")})
});
</script>
<div id=stamps>Wait....</div> 
<script>
//setTimeout(function(){CQ.Ext.get("stamps").dom.innerHTML=CQ.Timing.stamps},10000)

function waitForSidekick(){
    
    if((typeof (CQ) != 'undefined') 
    && (typeof (CQ.WCM) != 'undefined') 
    && (typeof (CQ.WCM.getTopWindow()) != 'undefined') 
    && (typeof (CQ.WCM.getTopWindow().CQ_Sidekick) != 'undefined')){
        if(CQ.WCM.getTopWindow().CQ_Sidekick.rendered){
            var stamps=""+CQ.Timing.stamps;
            stamps=stamps.replace(/&ndash;/g,"");
            stamps=stamps.replace(/&nbsp;/g,"");
            var timingurl="/content/accessmcd/corp.timing.html?extra="+stamps;
            CQ.Ext.Ajax.request({url:timingurl});    
            CQ.Ext.get("stamps").dom.innerHTML=CQ.Timing.stamps;
            return;
        }
    }
   setTimeout(waitForSidekick,1000);
   
}

function bodyload(){
fct();
waitForSidekick();
}
</script>
<br>

</body>
</html>