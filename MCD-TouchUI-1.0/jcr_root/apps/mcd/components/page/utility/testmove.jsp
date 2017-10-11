 <%
/* *************************
* test node move
*
* Erik Wannebo 11/4/2011
*********************************/
%>
<%@ page import="java.util.Calendar,
        java.text.SimpleDateFormat,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean"%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<HTML>
<TITLE>Test Move</TITLE>
<head>
</head>
<body>
<%
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
//jcrSession.move("/home/users/ecuser2/ecuser2","/tmp/ecuser2");
jcrSession.move("/tmp/ecuser2","/home/users/ecuser2/ecuser2");
jcrSession.save();
 %>
 </body>