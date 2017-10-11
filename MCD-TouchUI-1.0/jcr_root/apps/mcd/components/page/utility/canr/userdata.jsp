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
    Session session = null;
    try{ 
        response.setContentType("application/json");
        response.setCharacterEncoding("utf-8");
        ResourceResolver resolver = slingRequest.getResourceResolver();
        session = resolver.adaptTo(Session.class);
        UserManagerFactory usrMgrFactory = sling.getService(UserManagerFactory.class);
        UserManager usrMgr = usrMgrFactory.createUserManager(session);
        TidyJSONWriter writer = new TidyJSONWriter(response.getWriter());
        writer.setTidy(true);
        writer.object();
        writer.key("authorizables").array();
        long results = 1;
        String authTypeParam = request.getParameter("authType");
        if ((authTypeParam != null) && (!authTypeParam.equals(""))) {
            writer.object();
            writer.key("email").value("");
            List<Authorizable> auths;
            if (authTypeParam.equals("user")) {
                //writer.key("name").value("Any User");
                writer.endObject();
                Iterator<User> users = usrMgr.getUsers();
                while (users.hasNext()) 
                {
                    User user = users.next();
                    String homePath=user.getHomePath();
                    String propValue="";
                    if(slingRequest.getResourceResolver().getResource(homePath+"/profile")!=null){
                       Node pageNode = slingRequest.getResourceResolver().getResource(homePath+"/profile").adaptTo(Node.class);
                          if(pageNode.hasProperty("email")){
                           propValue=pageNode.getProperty("email").getString();
                          }
                    }  
                    writer.object();
                    writer.key("name").value(user.getName());
                    writer.key("email").value(propValue);                
                    writer.endObject(); 
                    results++;
                }  
            } 
        }
        writer.endArray();
        writer.key("results").value(results);
        writer.endObject();
    }
    catch(Exception ex){}
    finally{
        if(session!=null)
                    session.logout();
    } 

%>
