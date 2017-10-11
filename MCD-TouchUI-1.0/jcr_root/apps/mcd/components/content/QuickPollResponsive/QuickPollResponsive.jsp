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
        #pollDiv<%=id%> table{
            width:100%;
        }
        .pollContent<%=id%> td{
            padding-left: 0px;
        }
    </style>
<%    
    if(!"".equals(text.trim())){
%>    
        <h4><%=text%></h4>
<%
    }
%>    
    <div id="<%=currentNode.getName()%>"><script src='<%=quickPollJsUrl%>?s=<%= id %>' type="text/javascript"></script></div>
<%
} else {
    if(WCMMode.fromRequest(request) == WCMMode.EDIT){
        out.println(langText.get("CONFIGURE_COMPONENT_MSG","",langText.get("Quick Poll")));
    }
}
%>

<script type="text/javascript">
    $("#pole :radio").each( function(){
        $(this).parent().append("<label></label>");
    })
    $('#<%=currentNode.getName()%> STYLE').eq(0).remove();
if (JSinclude == 0) {
    document.write('<script type="text/javascript" src="<%= quickPollUrl %>"></scr' + 'ipt>'); 
    JSinclude ++; 
}
</script>