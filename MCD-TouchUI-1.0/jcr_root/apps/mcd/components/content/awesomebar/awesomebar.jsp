<%-- ########################################### 
 # DESCRIPTION: Awesome Bar Component
 #  
 # Environment: 
 # 
 # UPDATE HISTORY       
 # 1.0  Deepali Goyal Initial Version
 #
 ##############################################--%> 
      
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="com.mcd.accessmcd.util.CommonUtil,
                java.util.Iterator,
                java.util.Map,
                java.util.TreeMap,
                java.util.Set,
                java.util.Date,
                com.day.cq.wcm.api.PageFilter,
                java.text.ParseException,
                java.text.SimpleDateFormat,
                java.text.DateFormat,
                com.day.cq.security.*,
                org.apache.sling.jcr.api.SlingRepository"%>

<%

String type="slim navigation design";
String path1= currentPage.getPath();
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
    String allViews1 =prop.getProperty("allview");  
    String [] cview1 = null;
    if(allViews1.contains(",")){
        cview1 = allViews1.split(",");
    }
    String viewPagePath1 = currentPage.getPath();
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
            if(viewPagePath1.toLowerCase().startsWith(pView[0].toLowerCase())){
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
    String viewHomePage = prop.getProperty(currentPageView);
    Page homePage = pageManager.getPage(viewHomePage);
    String awesomeBarType = homePage.getProperties().get("awesomeBarType","normal");
%>

<script>

var displayType="<%=type%>";
if(displayType=="slim navigation design"){

        $("#headerwrap").css("background-color","#FFFFFF");
    }
</script>


<input type="hidden" name="awesomedesign" id="awesomedesign"  value="<%=type%>" />
<input type="hidden" name="path" id="path"  value="<%=path1%>" />
<div id="topheader"> </div> 
<div id="responsiveheader"> </div>   
<div style="clear:left;"></div> 
<div style="clear:both;"></div>   


<script>
    var templatePath = "<%=currentPage.getTemplate().getPath()%>";
    var awesomeBarType = "<%=awesomeBarType%>";
    if((awesomeBarType == "normal" || awesomeBarType == "responsive") && templatePath.indexOf("g2g-responsive") > 0){
        getResponsiveAwesomeHeader('<%=currentPage.getPath()%>','<%=currentDesign.getPath()%>');
    }
    else if(awesomeBarType == "responsive" && templatePath.indexOf("g2g") > 0){
        getResponsiveAwesomeHeader('<%=currentPage.getPath()%>','<%=currentDesign.getPath()%>');
    }
    else{
        getAwesomeHeader('<%=currentPage.getPath()%>','<%=currentDesign.getPath()%>');
    } 
    
</script>  