 <%@include file="/apps/mcd/global/global.jsp"%>  
 <%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList,
        java.util.Iterator, com.day.cq.security.privileges.*,
        javax.jcr.Node,javax.jcr.Session,org.apache.sling.jcr.api.SlingRepository,
        org.apache.sling.api.scripting.SlingScriptHelper,
        com.day.cq.security.User,org.apache.sling.api.resource.ResourceResolver,
        org.apache.sling.api.resource.Resource,
        java.util.ListIterator"%>                      

<%
       
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");

%> 

<%
final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
String userId = user.getID();
String path= (request.getParameter("path")!= null) ? request.getParameter("path").toString().trim() : "";


boolean value = false;
String pauth = "";

Node pageNode = resourceResolver.getResource(path).adaptTo(Node.class); 
if(pageNode.hasNode("like"))
    {
        String likePath = pageNode.getPath()+"/like";
        Node nodeLike = resourceResolver.getResource(likePath).adaptTo(Node.class);
        if(nodeLike.hasProperty("likeIdentifier"))
    {
        pauth = nodeLike.getProperty("likeIdentifier").getString();    
        if(pauth.contains(userId))
        {
          value = true;
        }  else {
            value = false;
           }      
    }
    else
    {
        value = false;
    }
       
    }



   
%>


{"results":{"value":"<%=value%>"}}  