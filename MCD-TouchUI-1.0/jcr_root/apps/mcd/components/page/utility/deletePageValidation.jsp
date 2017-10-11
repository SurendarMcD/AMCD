 <%-- ########################################### 
# DESCRIPTION: Check for page delete and deactivate 
# Author: Sumit Singhal 
# 
# 
# UPDATE HISTORY       
# 1.0  Sumit Singhal, 08/04/2014,Initial version 
# 
##############################################--%>     

<%@page import="org.osgi.service.cm.ConfigurationAdmin"%>
<%@page import="org.osgi.service.cm.Configuration"%>
<%@include file="/apps/mcd/global/global.jsp"%> 
<%
    String selectPath ="";
	// Retrieving  the configuration from felix 
    Configuration conf = sling.getService(org.osgi.service.cm.ConfigurationAdmin.class).getConfiguration("com.mcd.accessmcd.DeactivateDeleteValidation");
    String[] myProp = (String[]) conf.getProperties().get("paths");

	boolean homePage=false;
	// Retrieving the selected path from the request 
    if(null != request.getParameter("path"))
    {
        selectPath = request.getParameter("path");

    }
	// Check for delete and deactivate page
    if(myProp != null)
    {
        for(int i =0 ; i < myProp.length ; i++) 
        {
            if( selectPath.trim().equalsIgnoreCase(myProp[i]) )
            {
                homePage = true;
                break;
            }
            
        }
    }  
%>
{"homePage":"<%=homePage%>"}
