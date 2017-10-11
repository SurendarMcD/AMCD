<%--
    Copyright 1997-2007 Day Management AG
    Barfuesserplatz 6, 4001 Basel, Switzerland
    All Rights Reserved.
    This software is the confidential and proprietary information of
    Day Management AG, ("Confidential Information"). You shall not
    disclose such Confidential Information and shall use it only in
    accordance with the terms of the license agreement you entered into
    with Day.
--%><%
%><%@page session="false" %><%
%>
<%@include file="/libs/foundation/global.jsp"%>
<%@page import="java.util.Iterator,
                    java.util.List,
                    javax.jcr.Session,
                    com.day.cq.commons.TidyJSONWriter,
                    org.apache.sling.api.resource.Resource,
                    org.apache.sling.api.resource.ResourceResolver,
                    com.day.cq.security.Authorizable,
                    com.day.cq.security.User,
                    com.day.cq.security.Group,
                    com.day.cq.security.UserManager,
                    com.day.cq.security.UserManagerFactory,
                    javax.jcr.Node"%>
                    
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"%><%
%><sling:defineObjects/><%
%><% 
    response.setContentType("application/json");
    response.setCharacterEncoding("utf-8");
    ResourceResolver resolver = slingRequest.getResourceResolver();
     if(slingRequest.getResourceResolver().getResource("/apps/mcd/components/content")!=null){
            Node pageNode = slingRequest.getResourceResolver().getResource("/apps/mcd/components/content").adaptTo(Node.class);
     NodeIterator child = pageNode.getNodes();
     int i =0;
     String title = "";
     String path = "";
     Node comp;
     
   %>
   {"components": [
   
   
    <%  
   while(child.hasNext())
     {
      comp = child.nextNode();
      title = comp.getProperty("jcr:title").getString();
      path = comp.getPath();
      %>
       {"component":"<%= title %>","path":"<%= path %>"}
      <% 
      if(child.hasNext())
      {
       out.println(",");
      }
     }
      %>
      
   
    
    ],"results":"<%= child.getSize() %>"
    
    }
      <%
    
    
    }
    
    %>
  
   
  
    