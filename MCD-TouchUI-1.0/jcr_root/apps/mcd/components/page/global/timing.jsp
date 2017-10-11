<%-- ########################################### 
     # DESCRIPTION: records page load timing
     # 
     # Author: Erik Wannebo
     # 
     # 
     # UPDATE HISTORY       
     # 1.0  Erik Wannebo, 04/12/2010,Initial version 
     # 
     ##############################################--%>
<%@ page language = "java" %>
<%@page session="false" import="org.slf4j.Logger,
org.slf4j.LoggerFactory,
java.util.Date,
java.text.SimpleDateFormat,
javax.jcr.*,
com.day.cq.security.*"
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %>
<cq:defineObjects />
<%! public String getUserAgent(String useragent){
if(useragent==null)return "";
if(useragent.indexOf("MSIE ")>-1){
    if(useragent.indexOf("MSIE 7")>-1)return "IE7";
    if(useragent.indexOf("MSIE 8")>-1)return "IE8";
    if(useragent.indexOf("MSIE 6")>-1)return "IE6";
    if(useragent.indexOf("MSIE 9")>-1)return "IE9";
    if(useragent.indexOf("MSIE 10")>-1)return "IE10";
    
}
if(useragent.indexOf("rv:11")>-1)return "IE11";
if(useragent.indexOf("Firefox")>-1)return "FF";
if(useragent.indexOf("Chrome")>-1)return "Chrome";
if(useragent.indexOf("iPad")>-1)return "iPad";
if(useragent.indexOf("iPhone")>-1)return "iPhone";
if(useragent.indexOf("Android")>-1)return "Android";
if(useragent.indexOf("Blackberry")>-1)return "Blackberry";
if(useragent.indexOf(" ")>-1)
    return useragent.substring(0,useragent.indexOf(" "));
return "";
}
%>
<%
String timing=request.getParameter("timing");

if(timing==null)timing="";
if(timing.indexOf('?')>-1)timing=timing.substring(0,timing.indexOf('?'));

//String userid=request.getHeader("sm_user");
User loggedInUser = slingRequest.getResourceResolver().adaptTo(User.class);
String userid=loggedInUser.getID();
//String userid=loggedInUser.getID();
String l_attr=request.getHeader("l");
if(l_attr!=null)l_attr=l_attr.replaceAll("%20","_");
String source=request.getParameter("source");
String extra=request.getParameter("extra");
String useragent=getUserAgent(request.getHeader("User-Agent"));


/*
Enumeration headers=request.getHeaderNames();
while(headers.hasMoreElements()){
    String headername=(String)headers.nextElement();
    log.error(headername+":"+request.getHeader(headername));
}
*/
SimpleDateFormat sdf=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

String logline="\n"+sdf.format(new Date())+" Timing: "+source+" "+l_attr+" "+userid+"_"+useragent+" "+timing+" ms";
if(extra!=null){
   logline="\n"+sdf.format(new Date())+" Extra: "+extra+" "+l_attr+" "+userid+"_"+useragent;
}
log = LoggerFactory.getLogger("timing.log");

log.error(logline);
%> 