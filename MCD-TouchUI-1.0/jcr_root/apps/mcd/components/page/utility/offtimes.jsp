<%
/*
Lists recently updated files
Erik Wannebo 11/22/2010
*/
%>
<%@ page import="java.util.Calendar,
        java.text.SimpleDateFormat,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        java.util.regex.*,
        javax.servlet.jsp.JspWriter,    
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        com.day.cq.security.* "%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects /> 
<%
HttpServletRequest cqReq = request;
boolean isAdmin=false;
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    isAdmin=false;
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    out.write("<a href='/libs/cq/core/content/login.html?resource=/content/utility/utility.timings.html'>LOGIN HERE</a>");
    return;
}
%>  
<%!                                

public static void getOfftimes(javax.servlet.jsp.JspWriter out, QueryBuilder builder,ResourceResolver resourceResolver,String rootPath, int days){
long daysecs=24*60*60*1000;
SimpleDateFormat xpathdate =new SimpleDateFormat("yyyy-MM-dd");
 
String startdate=xpathdate.format((new Date()).getTime()-(30L*1000*3600*24))+"T00:00:00.000Z";
String enddate=xpathdate.format((new Date()).getTime()+(days*1000L*3600*24))+"T00:00:00.000Z";


try{ 
    String query="/jcr:root"+rootPath+"//*[@offTime > xs:dateTime('"+startdate+"') and @offTime < xs:dateTime('"+enddate+"')]";
    query+=" order by @offTime ascending";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    SimpleDateFormat sfModified=new SimpleDateFormat("MM-dd-yyyy hh:mm a");
    int count=0; 
    String strComma="";
    while(result.hasNext()) { 
            if(count>100000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            
            if (n != null) {
                String path = n.getPath();
                path=path.substring(0,path.indexOf("/jcr:content"));
                Calendar calOffTime=n.getProperty("offTime").getDate();
                String offTime=sfModified.format(calOffTime.getTime());
                out.write(strComma+path+"|"+offTime+"\n");
                strComma=",";
             }   
    }
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}   


%>
<%
QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
//out.write("hello");
//doSearchNew(out,"/apps","","jcr:created",builder,resourceResolver);
//UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
//UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
//getUserCount(out,uMgr);

//findComponents(out,builder,resourceResolver);
//getComponentsPerPage(out,builder,resourceResolver);
//doSearch(out,"/content","cq:Page","cq:lastModified",builder,jcrSession);
int days=1;
if(request.getParameter("days")!=null && request.getParameter("days").trim()!=""){
   days=Integer.parseInt(request.getParameter("days"));
}
String rootPath="/content/accessmcd";
if(request.getParameter("rootPath")!=null && request.getParameter("rootPath").trim()!=""){
   rootPath=request.getParameter("rootPath");
}

getOfftimes(out,builder,resourceResolver,rootPath,days);
 

%>
</body>
</html>