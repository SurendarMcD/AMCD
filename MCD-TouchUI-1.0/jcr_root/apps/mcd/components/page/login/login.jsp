<%--

  

  

--%><%
%><%@ page import="com.mcd.accessmcd.util.CommonUtil, 
                   com.day.cq.security.*,org.apache.sling.jcr.api.SlingRepository,javax.jcr.*"%><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" %><%
%><%
  User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
  final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
  Session adminSession = null;
  try{ 
    if(user == null){
        Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
        String sessionUserId = jcrSession.getUserID();
        SlingRepository repository = sling.getService(SlingRepository.class);
        adminSession = repository.loginAdministrative(null);
        UserManager mgr= userManagerFactory.createUserManager(adminSession); 
        user = (User)mgr.get(sessionUserId);
        System.out.println("********* Have User From AdminSession in login.jsp ********* ");
    }
    
      CommonUtil commonUtil = new CommonUtil(); 
      String redirectPath = commonUtil.getDefaultHomePage(user);
      if(redirectPath.indexOf("/content/") > -1) redirectPath = redirectPath + ".html"; 
      redirectPath = redirectPath.replaceAll("/content/","/");
      String frameTarget = "";
      if(null != request.getParameter("frameTarget")){
          redirectPath += "?frameTarget=" + request.getParameter("frameTarget");  
      } 
      response.sendRedirect(redirectPath);
  }
  catch(Exception e){
    System.out.println("***** Exception in getting User Node Object in login.jsp ****** "+e.getMessage());
    System.out.println(e);
  }
  finally{
    if(adminSession!=null)adminSession.logout();
  }  
%>  
 