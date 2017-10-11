<%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Breadcrumb component
  Draws the breadcrumb
--%>

<%@include file="/libs/wcm/global.jsp"%>
<%@ page import="java.util.Iterator,
        com.day.text.Text,
        com.day.cq.wcm.api.PageFilter,
        com.day.cq.wcm.api.NameConstants,
        org.apache.commons.lang.StringEscapeUtils,
        com.day.cq.wcm.api.Page,
        com.mcd.accessmcd.calendar.util.DesEncrypter,
        com.day.cq.security.Authorizable,
        com.day.cq.security.User,
        com.day.cq.security.UserManager,
        com.day.cq.security.UserManagerFactory,
        org.apache.sling.jcr.api.SlingRepository,
        org.apache.sling.api.scripting.SlingScriptHelper,
        org.osgi.framework.BundleActivator"%>

<%
    // get starting point of trail
    String docroot = currentDesign.getPath();    
    long level = properties.get("absParent", 2L);
    String fieldSeparator = properties.get("fieldSeparator", ">>");   
    int currentLevel = currentPage.getDepth();
    String delim = "";
    
    
    // Added section for retrieving the user audience type
     String loggedUserAudType="";
     DesEncrypter encrypter = new DesEncrypter();
     String encryptedAudType="";
     String trailPath = "";
     String path = "";    
     int lastIndex = 0; 
     String suffixPath = "";
     
   
     final User user = slingRequest.getResourceResolver().adaptTo(User.class);
     // ****** Block to find out logged-in user audience type ***** //
     SlingRepository repos= sling.getService(SlingRepository.class);  
     UserManagerFactory fact =sling.getService(UserManagerFactory.class);
      
        if (!(repos==null || fact==null)) {
            Session session = null;
            try {
                session = repos.loginAdministrative(null);
                final UserManager umgr = fact.createUserManager(session);
                if(umgr.hasAuthorizable(user.getID())){
                    Authorizable auth = umgr.get(user.getID());
                   
                    // code to retrieve the audience type of the logged in user
                    Node userProfileNode = (Node) session.getItem(user.getHomePath() + "/profile");
                    if(userProfileNode.hasProperty("mcdAudience"))
                     { 
                         loggedUserAudType=userProfileNode.getProperty("mcdAudience").getValue().getString();
                        //code to encrypt the Audience type of the logged in user
                        encryptedAudType = encrypter.encrypt(loggedUserAudType).replace("/","");
                        
                     }else
                     {
                        if(null!=user.getProperty("./rep:mcdAudience")){
                         loggedUserAudType=user.getProperty("./rep:mcdAudience");
                         encryptedAudType = encrypter.encrypt(loggedUserAudType).replace("/","");
                         }
                     }
                 }
                 session.logout();
                 session = null;
            } catch (RepositoryException e) {
            } finally {
                if (session!=null) {
                    session.logout();
                }
            }
        }
        
    // End of edition
    %>
    <div class="breadCrumbBg">
        <div class="breadCrumb" id="divBreadCrumb">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
                <td valign="middle" class="breadCrumbBg">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td width="1" class="breadCrumbImg"><img src="<%=currentDesign.getPath() %>/images/0.gif" alt="spacer" ></td>
                
                        <!-- BREAD CRUMBS  -->
                        <td class="breadCrumb"> 
                            <%    
                                while (level <= currentLevel) {
                                    Page trail = currentPage.getAbsoluteParent((int) level);
                                    if (trail == null) {
                                        break;
                                    }
                                    String title = trail.getNavigationTitle();
                                    if (title == null || title.equals("")) {
                                        title = trail.getPageTitle();
                                    }
                                    if (title == null || title.equals("")) {
                                        title = trail.getTitle();
                                    }
                                    if (title == null || title.equals("")) {
                                        title = trail.getName();
                                    } 
                                    %><%= delim %><%        
                                    if((level+1)==currentLevel){
                                        %>
                                        <%= StringEscapeUtils.escapeHtml(title) %>
                                        <%
                                    } else {                                       
                                        trailPath = trail.getPath();
                                        lastIndex = trailPath.lastIndexOf("/");
                                        if(lastIndex!=-1){
                                            path = trailPath.substring(lastIndex+1,trailPath.length()); 
                                            if(path.equals("au")) {
                                                %>
                                                <a href="<%= Text.escape(trail.getPath(), '%', true) %>.<%=encryptedAudType%>.html">
                                                <%    
                                            } else {
                                                %>
                                                <a href="<%= Text.escape(trail.getPath(), '%', true) %>.html">
                                                <%
                                            }                                                                                    
                                         } 
                                    %>                                       
                                        <%= StringEscapeUtils.escapeHtml(title) %></a>
                                        <%}
                                    delim = "<span class='breadCrumbSeperator'>"+fieldSeparator+"</span>";
                                    level++;
                                }
                           %>
                           </td>
                      <!-- /BREAD CRUMBS -->                     
                    </tr>
                </table>
              </td>
        </tr>
        </table>
      </div>    
   </div>