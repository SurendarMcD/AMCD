<%--
  ==============================================================================
  ACE Values from Config File
  
  Shubhra Gupta 9/2/2010 
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>

<%@ page import="com.mcd.accessmcd.ace.manager.ACEManager"%>
<%@ page import="com.mcd.accessmcd.ace.bo.ACEConfigDataBean"%>
<%@ page import="org.apache.sling.scripting.core.ScriptHelper"%>
<%@ page import="com.day.cq.security.*"%>
                
<html>
    <head>
        <title>ACE Values from TEST Config File</title>
    </head>
    <body>
        <style>
        .aceConfigTable td{
            border:1px dotted;
        }
        .aceConfigHeader{
            font-weight:bold;
        }
                        
        </style>        
        <%                          
            try {
                                                                                                            
               Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
                                                                               
               ACEManager aceManager = new ACEManager();                
               String sitePageKey = aceManager.getACESitePageKey("/content/accessmcd/jtest",true);
               System.out.println("[TESTaceconfigfile] beanFromNewManager()-- sitePageKey :"+sitePageKey );               
               ACEConfigDataBean aceBean = aceManager.getACEConfigBean(sitePageKey,(ScriptHelper)sling,jcrSession);    
               
     %>
                <table class="aceConfigTable" cellspacing="0" border="2">
                <tr>
                    <td class="aceConfigHeader">
                        Site URL
                    </td>
                    <td>
                       <%= aceBean.getSiteURL()%>
                    </td>
                </tr>
                 <tr>
                    <td class="aceConfigHeader">
                        Associated Author Group
                    </td>
                    <td>
                       <%= aceBean.getGroupName()%>
                    </td>
                </tr>
                <tr>
                    <td class="aceConfigHeader">
                        Author Domain Address of Site
                    </td>
                    <td>
                       <%= aceBean.getAuthDomainAdd()%>
                    </td>
                </tr>
                <tr>
                    <td class="aceConfigHeader">
                        Publish Domain Address of Site
                    </td>
                    <td>
                       <%= aceBean.getPubDomainAdd()%>
                    </td>
                </tr>
                <tr>
                    <td class="aceConfigHeader">
                        Months until Expiration (After Activation)
                    </td>
                    <td>
                       <%= aceBean.getExpirePeriod()%> Months
                    </td>
                </tr>
                <tr>
                    <td class="aceConfigHeader">
                        Date Format
                    </td>
                    <td>
                       <%= aceBean.getDateFormat()%>
                    </td>
                </tr>
                <tr>
                     <td class="aceConfigHeader">
                        Language
                    </td>
                    <td>
                       <%= aceBean.getLanguage()%>
                    </td>
                </tr>
                <tr>
                     <td class="aceConfigHeader">
                        Admin Names
                    </td>
                    <td>
                       <%= aceBean.getAdminNames()%>
                    </td>
                </tr>
                <tr>
                     <td class="aceConfigHeader">
                        Admin Mail Ids
                    </td>
                    <td>
                       <%= aceBean.getAdminMailIds()%>
                    </td>
                </tr>
                <tr>
                     <td class="aceConfigHeader">
                        Non-Admin Names
                    </td>
                    <td>
                       <%= aceBean.getNonAdminNames()%>
                    </td>
                </tr>
                <tr>
                     <td class="aceConfigHeader">
                        Non-Admin Mail Ids
                    </td>
                    <td>
                       <%= aceBean.getNonAdminMailIds()%>
                    </td>
                </tr>
                </table>
       <%   
            } catch (java.io.IOException e){
                log.info("Exception in reading properties file :: " + e);
            } catch (Exception e){
                out.println("Exception  :: " + e);
            }
                        
        %>
    </body>
</html>