<%--
  ==============================================================================
  Draws the HTML body with content:
  - includes header
  - includes topbar
  - includes bottombar
  ==============================================================================
--%>
<%@ page import="java.util.*, 
        java.io.*,
        javax.servlet.*,
        javax.servlet.http.*,
        com.mcd.accessmcd.util.CommonUtil,com.day.cq.security.*,
        org.apache.sling.jcr.api.SlingRepository,
        com.day.cq.security.User,  
        com.day.cq.wcm.api.WCMMode" %><%
%>
<%@include file="/apps/mcd/global/global.jsp"%> 
<%
    User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
//debugging Digvijay 10/1/2014
String sessionUserId = "";
Session adminSession = null;
try{
if(user == null){
    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
    sessionUserId = jcrSession.getUserID();
    SlingRepository repository = sling.getService(SlingRepository.class);
    adminSession = repository.loginAdministrative(null);
    UserManager mgr= userManagerFactory.createUserManager(adminSession); 
    user = (User)mgr.get(sessionUserId);
    System.out.println("********* Have User From AdminSession ********* ");
}
}
catch(Exception e){
    System.out.println("***** Exception in getting User Node Object ****** "+e.getMessage());
    System.out.println(e);
}finally{
    if(adminSession!=null)adminSession.logout();
}


    CommonUtil commonUtil = new CommonUtil();
    boolean foundCookie = false;
    String view = "corp";
    String path = "";
    String views=prop.getProperty("views"); 
    String allViews =prop.getProperty("allview");  
    String [] cview = null;
    if(allViews.contains(",")){
        cview= allViews.split(",");
    }
    String viewPagePath = currentPage.getPath();
    path = commonUtil.getDefaultHomePage(user);   
    view = prop.getProperty(currentPage.getPath()); 
    Cookie[] cookies = request.getCookies(); 
    if(cookies != null){ 
        for(int i = 0; i < cookies.length; i++) { 
            Cookie cookie1 = cookies[i];
            if (cookie1.getName().equals("userview")){
                view = cookie1.getValue();
                if(view == null || view.trim().equals("")){
                    view = "corp"; 
                }
            }
        }
    }    
    if(view == null ) { 
        String [] pageViews = views.split(",");
        String [] pView=new String[2];  
        for(int k=0;k<pageViews.length;k++){ 
            pView=pageViews[k].split("\\|");
            if(viewPagePath.toLowerCase().startsWith(pView[0].toLowerCase())){
                view = pView[1];
                break;
            }
        }  
    }
    String otherPath="";
    if(view == null){
        view = "corp";
    }
    String currentPagePath = currentPage.getPath();
    //out.println("Current Page Path :: " + currentPagePath + "<br>");
    String [] pageViewsRes = views.split(",");
    String [] pViewRes = new String[2];
    String currentPageView = view;  
    for(int k=0;k<pageViewsRes.length;k++){ 
        pViewRes=pageViewsRes[k].split("\\|");
        if(currentPagePath.toLowerCase().startsWith(pViewRes[0].toLowerCase())){
            currentPageView = pViewRes[1];
            break;
        }
    } 
    //out.println("Current Page View :: " + currentPageView + "<br>");
    String viewHomePage = prop.getProperty(currentPageView);
    Page homePage = pageManager.getPage(viewHomePage);
    //out.println("View Home Page :: " + viewHomePage + "<br>");
    String awesomeBarType = homePage.getProperties().get("awesomeBarType","normal");
    //out.println("Awesomebar Type :: " + awesomeBarType + "<br>");
    String gaCode=prop.getProperty("gaCode","");
%>

 
<%
    if("responsive".equals(awesomeBarType)){
%>
        <cq:include script="responsivebody.jsp"/>
<%
    }
    else{
%>
    <cq:include script="normalbody.jsp"/>
<%
    }
%>



      