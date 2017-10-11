<%-- ################################################################################ 
 # DESCRIPTION: set off time 
 #  
 # Environment: 
 # 
 # UPDATE HISTORY       
 # 1.0  Deepali Goyal Initial Version 21/07/2011
 #
 #####################################################################################--%>  
 
<%@ page import="com.mcd.accessmcd.ace.manager.ACEManager" %><%    
%><%@include file="/apps/mcd/global/global.jsp"%><%
%>
 
<%
    String pagePath = currentPage.getPath();
    Node aceNode = slingRequest.getResourceResolver().getResource(pagePath+"/jcr:content").adaptTo(Node.class);
    ACEManager aceManager = new ACEManager();
    boolean success = aceManager.setACEDate(pagePath,aceNode ); 
%>  