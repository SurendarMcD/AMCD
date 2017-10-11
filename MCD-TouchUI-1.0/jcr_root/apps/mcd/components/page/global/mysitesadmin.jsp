<%@page import="java.net.*"%>  
<%@ page import="com.mcd.accessmcd.mysites.bean.*"%>
<%@ page import="com.mcd.accessmcd.mysites.dao.*"%>
<%@ page import="com.mcd.accessmcd.mysites.manager.MySitesManager"%>
<%@ page import="com.mcd.accessmcd.mysites.util.*"%>
<%@ page import="com.mcd.accessmcd.mysites.constants.MySitesConstants"%>
<%@ page import="com.mcd.accessmcd.mysites.util.DBTool"%>
<%@ page import="javax.servlet.http.HttpSession"%> 
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                javax.jcr.*,
                com.day.cq.security.*"%>
<%@ include file="/apps/mcd/global/global.jsp"%>

<script language=Javascript src="/scripts/mysites.js" type=text/javascript></script>
<script>
    var allEntityTypesArr=new Array();
</script>
 
<link rel="stylesheet" type="text/css" media="screen" href="/css/mysitestyles.css" />

<% 
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
     
    final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
    ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());
    String userID = request.getParameter("userID");
    String view = request.getParameter("view");
    request.setAttribute("userID", userID); 
    request.setAttribute("view", view); 
    MySitesManager mySitesManager = new MySitesManager(sling, jcrSession);
    boolean isAdministrator = false;
    boolean isSuperuser = false;
    String pageHandle = currentPage.getPath();
        
    isAdministrator = mySitesManager.isAdministrator(userID, view);
    isSuperuser = mySitesManager.isSuperUser(userID, view);
    // Set the path for images
    String imgPath = "";
    String action = request.getParameter("action");
%> 

<table width="100%" cellspacing="0" cellpadding="0" bgcolor="#ffffff">
    <tbody>
    <input type="hidden" name="userID" value="<%= userID %>"/>
    <input type="hidden" name="view" value="<%= view %>"/>
        <tr>
            <td colspan="3">

<%    
        List asl = new ArrayList();
        List aul = new ArrayList();
        
        String returnMsg = "";

        if (action == null || action.equalsIgnoreCase("viewAdminSites")) 
        {
            asl = mySitesManager.getAdminSiteList("", userID, view);
            request.setAttribute("adminSiteList", asl);  
%>
            <%@include file="/apps/mcd/components/content/mysites/viewadminsites.jsp" %>
<%      }
        else 
        {
            if (action.equals("addSite") || action.equals("editSite")) 
            {               
%>
                <%@include file="/apps/mcd/components/content/mysites/addeditadminsite.jsp" %>
<%
            } 
            if (action.equals("deleteSite"))   
            {
%>
                <%@include file="/apps/mcd/components/content/mysites/deleteadminsites.jsp" %>
<%
            } 
            else if (action.equals("addUser") || action.equals("editUser")) 
            {
%>
                <%@include file="/apps/mcd/components/content/mysites/addeditadminuser.jsp" %>
<% 
            } 
            else if (action.equals("viewAdminUsers") || action.equals("confirmAddUser") || action.equals("confirmEditUser") || action.equals("confirmDeleteUser") || action.equals("confirmEditAllUser")) 
            {
                if (action.equals("confirmAddUser") || action.equals("confirmEditUser")) 
                {
                    AdminUser au = new AdminUser();
                    String reqUserID = request.getParameter("userId");
                    String manageUserFlag = request.getParameter("manageUserFlag");
                    if (manageUserFlag == null || manageUserFlag.equals("")) 
                    {
                        manageUserFlag = "N";
                    }
                    au.setUserId(reqUserID);
                    au.setEntityType(view);
                    au.setManageUserFlag(manageUserFlag);
                    if (action.equals("confirmAddUser")) 
                    {
                        returnMsg = mySitesManager.addAdminUser(au);
                        out.println("<font class=\"resultMsg\">"+bundle.getString(returnMsg)+"</font>");
                    } 
                    else if (action.equals("confirmEditUser")) 
                    {
                        returnMsg = mySitesManager.editAdminUser(au);
                        out.println("<font class=\"resultMsg\">"+bundle.getString(returnMsg)+"</font>");
                    } 
                } 
                else if (action.equals("confirmDeleteUser")) 
                {
                    String[] adminUserIds = request.getParameterValues("adminUserId");
                    returnMsg = mySitesManager.deleteAdminUser(adminUserIds);
                    out.println("<font class=\"resultMsg\">"+bundle.getString(returnMsg)+"</font>");
                }
                else if (action.equals("confirmEditAllUser")) 
                {
                    String strAllAdminUsers = request.getParameter("AdminUsers");
                    
                    List<AdminUser> adminUsersList = new ArrayList<AdminUser>();
                    String[] arrAllAdminUsers = strAllAdminUsers.split("#");
                    AdminUser au = null;
                    String reqUserID = "";
                    String reqView = "";
                    String reqManageUserFlag = "";
                    for(String strAdminUser : arrAllAdminUsers)
                    {
                        au = new AdminUser();
                        
                        reqUserID = strAdminUser.split("\\|")[0];
                        reqView = strAdminUser.split("\\|")[1];
                        au.setUserId(reqUserID);
                        au.setEntityType(reqView);
                        reqManageUserFlag = request.getParameter(reqUserID+"ManageFlag");
                        if (reqManageUserFlag == null || reqManageUserFlag.equals("")) 
                        {
                            reqManageUserFlag = "N";
                        }
                        au.setManageUserFlag(reqManageUserFlag);
                        
                        adminUsersList.add(au);
                    }
                    returnMsg = mySitesManager.updateAllAdminUsers(adminUsersList);
                    out.println("<font class=\"resultMsg\">"+bundle.getString(returnMsg).replaceAll("User", "Users")+"</font>");
                }
                aul = mySitesManager.getAdminUserList(view);
                request.setAttribute("adminUserList", aul);     
%>
                <%@include file="/apps/mcd/components/content/mysites/viewadminusers.jsp" %>
<%          } 
            else if (action.equals("search") || action.equals("confirmAddSite") || action.equals("confirmEditSite") || action.equals("confirmDeleteSite")) 
            {
                if (action.equals("search")) 
                {
                    String searchKeywords = request.getParameter("searchKeywords");
                    searchKeywords = searchKeywords.replaceAll("'","''");
                    asl = mySitesManager.getAdminSiteList(searchKeywords, userID, view);
                    request.setAttribute("adminSiteList", asl);  
                } 
                else if (action.equals("confirmAddSite") || action.equals("confirmEditSite")) 
                {
                    Site site = new Site();
  
                    String siteID = request.getParameter("siteId");
                    String oldSiteName = URLDecoder.decode(request.getParameter("siteNameOld"),"UTF-8");
                    //out.println("OLD Site Name :: " + oldSiteName + "<br>");
                    String newSiteName = URLDecoder.decode(request.getParameter("siteName"),"UTF-8");
                    //String newSiteName = request.getParameter("siteName");
                    //out.println("New Site Name :: " +  newSiteName + "<br>");  
                    String siteURI = request.getParameter("siteURI");
                    Vector<EntityType> allEntityTypes = mySitesManager.getEntityTypes(userID);
                    
                    Map<String, List<AudienceType>> audienceTypesMap = new HashMap<String, List<AudienceType>>();
                    List<AudienceType> audienceTypeList = null;
                    for(EntityType entity : allEntityTypes)
                    {
                        audienceTypeList = new ArrayList<AudienceType>();
                        String[] siteAudienceTypesArr = request.getParameterValues(entity.getEntityType()+"AudType");
                        if(siteAudienceTypesArr != null)
                        {
                            for (int i=0; i<siteAudienceTypesArr.length; i++) 
                            {
                                AudienceType audType = new AudienceType();
                                audType.setAudienceTypeId(siteAudienceTypesArr[i]);
                                audienceTypeList.add(audType);
                            }
                            audienceTypesMap.put(entity.getEntityType(), audienceTypeList);
                        }                       
                    }
                    
                    site.setSiteID(siteID);
                    site.setSiteName(oldSiteName);
                    site.setNewSiteName(newSiteName);
                    site.setSiteURI(siteURI); 
                    site.setAudienceType(audienceTypesMap);
                    site.setEntityType(allEntityTypes);
                    
                    if (action.equals("confirmAddSite")) 
                    {
                        returnMsg = mySitesManager.addAdminSite(site);
                        out.println("<font class=\"resultMsg\">"+bundle.getString(returnMsg)+"</font>");
                    } 
                    else if (action.equals("confirmEditSite")) 
                    {
                        returnMsg = mySitesManager.editAdminSite(site);
                        out.println("<font class=\"resultMsg\">"+bundle.getString(returnMsg)+"</font>");
                    }
                    asl = mySitesManager.getAdminSiteList("", userID, view);
                    request.setAttribute("adminSiteList", asl); 
                } 
                else if (action.equals("confirmDeleteSite")) 
                {
                    String[] siteIDs = request.getParameterValues("siteId");
                    returnMsg = mySitesManager.deleteAdminSite(siteIDs);
                    out.println("<font class=\"resultMsg\">"+bundle.getString(returnMsg)+"</font>");
                    asl = mySitesManager.getAdminSiteList("", userID, view);
                    request.setAttribute("adminSiteList", asl); 
                } 
%>
                <%@include file="/apps/mcd/components/content/mysites/viewadminsites.jsp" %>
<%
            }       
        }
%> 