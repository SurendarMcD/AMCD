<%
/* *************************
* content fix - for quick find/replaces in content
*
* Erik Wannebo 5/18/2011
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
<TITLE>Content Fix</TITLE>
<head>
</head>
<body>
<%!
public static Iterator<Resource> searchNodes(ResourceResolver resourceResolver, String contentPath, String searchTerm){

try{
    
    String query = "/jcr:root"+contentPath+"//*[jcr:contains(., '"+searchTerm+"')] order by jcr:path"; 
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    return result;
    }catch(Exception e){
    }
    return null;
}

%>
<%
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);

Iterator<Resource> nodeIterator=searchNodes(resourceResolver,"/content/accessmcd/na/us/natl/business_resources","Home_Page");
while(nodeIterator.hasNext()) {
    Resource r=(Resource)nodeIterator.next();
    javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
    if (n != null) {
        String path = n.getPath();
        out.println("<hr>");
        out.println("<b>"+path+"</b><br>");
        if(n.hasProperty("text")){
            out.println(n.getProperty("text").getValue().getString()+"<br>"); 
        }
        out.println("<hr>");
    }
}
 %>
 </body>