<%-- ########################################### 
     # DESCRIPTION: records page load timing, based on CQ.Timing function
     # 
     # Author: Erik Wannebo
     # 
     # 
     # UPDATE HISTORY       
     # 1.0  Erik Wannebo, 07/27/2010,Initial version 
     # 
     ##############################################--%>
<%@ page language = "java" %>
<%@page session="false" import="org.slf4j.Logger,
org.slf4j.LoggerFactory,
java.util.Date,
java.text.SimpleDateFormat"
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %>
<cq:defineObjects /><%
String stamps=request.getParameter("stamps");

String userid=request.getHeader("sm_user");
String l_attr=request.getHeader("l");
if(l_attr!=null)l_attr=l_attr.replaceAll("%20","_");
String source=request.getParameter("source");

/*
Enumeration headers=request.getHeaderNames();
while(headers.hasMoreElements()){
    String headername=(String)headers.nextElement();
    log.error(headername+":"+request.getHeader(headername));
}
*/
SimpleDateFormat sdf=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
String logline="\n"+sdf.format(new Date())+"CQTiming: "+source+" "+l_attr+" "+userid+" "+stamps+"";
log.error(logline);
%>