<%--
  ==============================================================================
  Renders the dynamic site color classes, as defined by the site color palette
  settings in the current design's Site Level Properties
  
  This file should be included by the template's head.jsp
  
  Erik Wannebo 8-11-2010
  
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp" %>
<style>
    <%
      String siteColorList="000000:FFFFFF";
    String siteColorArray="";
    String comma="";
    
    if(currentDesign!=null){
        //add black and white as default site colors
        
        Node sitelevelproperties =getSiteLevelPropertiesNode(slingRequest, pageProperties, currentDesign);
      
        if(sitelevelproperties!=null) {
            if(sitelevelproperties.hasProperty("siteColors"))
                siteColorList+=":"+sitelevelproperties.getProperty("siteColors").getString();
        }
        String[] siteColors=siteColorList.split(":");
    
        for(int i=0;i<siteColors.length;i++){
            out.println(".sitecolor"+(i+1)+", #CQ .sitecolor"+(i+1)+", #CQ .x-form-text.sitecolor"+(i+1)+" {background:#"+siteColors[i]+";}");
            out.println(".sitecolor"+(i+1)+"text {color:#"+siteColors[i]+";}");
            out.println(".sitecolor"+(i+1)+"border {border-color:#"+siteColors[i]+";}");
            out.println(".crnrsitecolor"+(i+1)+" {border-left:1px solid #"+siteColors[i]+";border-right:1px solid #"+siteColors[i]+";}");  
            out.println(".rndcrnrsitecolor"+(i+1)+" {display:block;height:5px;}");  
            out.println(".rndcrnrsitecolor"+(i+1)+" * {display:block;height:1px;overflow:hidden;font-size:.01em;background:#"+siteColors[i]+";}");  
            siteColorArray+=comma+"\"sitecolor"+(i+1)+"\"";
            comma=","; 
        }
     }
    
    %>
</style> 

    <%
    //this variable is referenced by the mcdsitecolorclassfield widget (mcdSiteColorClassPalette) in the Author environment
    if (editContext != null) {
    %>
    <script language="Javascript">var  mcdSiteColorClassPaletteColors =[<%=siteColorArray%>];</script>
    <%
    }
    %> 