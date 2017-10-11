<%-- ########################################### 
 # DESCRIPTION: This is the View US Building component which will display the list of US Buildings.
 # Author: Sandeep Jain
 # Environment: 
 # 
 # INTERFACE 
 # Controller: 
 # Targets: 
 # Inputs:   
 # Outputs:      
 # 
 # UPDATE HISTORY       
 # 1.0  Sandeep Jain, 22-01-09, Initial Version 
 # 
 # Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
 ##############################################--%>
  

<%@ page session="false" contentType="text/html" %>
<%@ include file="/apps/mcd/global/global.jsp" %>      
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*,com.day.cq.security.User,com.day.cq.security.UserManagerFactory,com.day.cq.security.UserManager" %>
<%@ page import="com.mcd.accessmcd.usermanagement.user.manager.*,com.mcd.accessmcd.usermanagement.user.bo.*" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.GCDConstants" %> 
<%@ page import="com.mcd.accessmcd.common.helper.PropertyHelper,com.mcd.util.PropertiesLoader,java.util.Properties,com.mcd.accessmcd.util.CommonUtil"%>
<%@ page import="com.day.cq.i18n.I18n"%>
<%
       
    //Declaring the common variables
    ArrayList allBuildingDetails=null;
    ArrayList groupList = null;
    ArrayList groupPaths = new ArrayList();
    boolean adminFlag = false; 
    IGCDFacade iGCDFacade=null;
    HttpSession session=null;
    CommonUtil commonUtil = new CommonUtil(); 
    String cancelLinkURL=null;
         
  
    try{   
                // get GCDFacadeImpl Object
                iGCDFacade= new GCDFacadeImpl();
                allBuildingDetails=iGCDFacade.getUSBuildings(sling);
                Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
                final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
                UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
                User loggedInUser = slingRequest.getResourceResolver().adaptTo(User.class);
                ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());
                UserMaintenanceManager umManager = new UserMaintenanceManager(sling, bundle, jcrSession, uMgr, resourceResolver);
                String loggedInUserID = loggedInUser.getID();
                groupList = umManager.getUserGroupsDetails(loggedInUserID);
                GroupDataBean grpBean = null; 
                if(groupList.size() > 0){
                    for(int i=0; i<groupList.size(); i++){
                        grpBean = (GroupDataBean)groupList.get(i);
                        groupPaths.add(grpBean.getGroupHandle());
                    }
                }   
                if(groupPaths !=null && groupPaths.size() > 0){
                    String[] gcdAdminGroup = GCDConstants.GCD_ADMIN_GROUP.split(",");
                    if(gcdAdminGroup.length > 0){
                        for(int g=0; g<gcdAdminGroup.length; g++){
                            if(groupPaths.contains(gcdAdminGroup[g])){
                                adminFlag = true;
                                break;
                            }
                        }
                    }
                }
                
      }
       catch(Exception e)
       {
       }             
               
%>
        
{"allow" : "<%= adminFlag  %>"}       