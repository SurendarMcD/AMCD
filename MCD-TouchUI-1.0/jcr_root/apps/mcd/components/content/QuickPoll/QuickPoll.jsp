<%--
Opinion component.
Author : Nitin Sharma
Updated by: Stephen Pfaff (May 10, 2012)
Updates:
5/10/2012 -- 
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@page session="false" %>
<%@ page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat,
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService,
    org.apache.commons.lang.StringEscapeUtils,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.WCMMode,
    org.apache.sling.api.resource.ResourceUtil,
    org.apache.sling.api.resource.ValueMap,
    com.day.cq.security.User,
    com.mcd.util.PropertiesLoader,
    java.util.Properties" %>

<%
String id =  properties.get("pid","");
String text = properties.get("headline","");
String rc = properties.get("corners", "false");
String quickPollJsUrl = prop.getProperty("quick_poll_js_url");
String quickPollUrl = prop.getProperty("quick_poll_url");
String quickPollTable = "pollTable" + id;
String quickPollBottomLeft = "pollBottomLeftCorner" + id;
String quickPollBottom = "pollBottom" + id;
String quickPollBottomRight = "pollBottomRightCorner" + id;
String pollButton = "pollButton" + id;
if(!id.equals("")){
%>

<style>
.<%=quickPollTable%> table {
    width: 100%;
    *min-width: 100%;
    margin: 0 auto;
}

.<%=quickPollBottomLeft%> {
     display: block;
}

.<%=quickPollBottom%> {

}

.<%=quickPollBottomRight%> {
  display: block; 
}

.quickPollContent{
    text-align:left;
    margin-left:5px;
}
.<%=pollButton%> {
  text-align:center; 
}
</style>
  
    <div class="quickPollBox <%if(rc.equals("true")){%>qpRounded<%}%>">
        <div class="quickPollTitle"><div class="quickPollTitlePadding"><%= text %></div></div>
        <div class="quickPollContent">
            <script src='<%=quickPollJsUrl%>?s=<%= id %>' type="text/javascript"></script>
            <div class="quickPollImage">
                <% String ddClassN = DropTarget.CSS_CLASS_PREFIX + "image";
                Image image1 = new Image(resource,"image"); 
                if(image1.hasContent()){   
                    image1.addCssClass(ddClassN); 
                    image1.loadStyleData(currentStyle); 
                    image1.setSelector(".img"); // use image script
                    
                    if (!currentDesign.equals(resourceDesign)){
                        image1.setSuffix(currentDesign.getId());
                    } %>
                    <% image1.draw(out);%>  
                <%} %>
            </div>
        </div>
    </div>

<%
} else {
    if(WCMMode.fromRequest(request) == WCMMode.EDIT){
        out.println(langText.get("CONFIGURE_COMPONENT_MSG","",langText.get("Quick Poll")));
    }
}
%>

<script type="text/javascript">
if (JSinclude == 0) {
    document.write('<script type="text/javascript" src="<%= quickPollUrl %>"></scr' + 'ipt>'); 
    JSinclude ++; 
}
</script>