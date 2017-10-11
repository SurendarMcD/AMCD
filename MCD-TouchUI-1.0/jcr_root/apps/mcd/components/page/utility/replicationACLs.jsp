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
<HTML>
<head>
<script language='javascript'>
function openInCRXDE(path){
window.open("/crxde/#/crx.default/jcr%3aroot"+path);
} 
</script>
</head>
<body style="font-family:arial">
<h2>CQ 5.4 Replication Rights</h2>
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



public static void genericQuery(JspWriter out, ResourceResolver resourceResolver,String query){

try{ 
    HashMap pageMap=new HashMap();
   
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    //out.write(query+"test");
    out.write("<table>");
    int count=0; 
    out.write("<tr><td><b>Count</b></td><td><b>Group</b></td><td><b>Path</b></td><td><b>Deny</b></td></tr>");
    while(result.hasNext()) { 
            if(count>100000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String group= n.getPath();
                group=group.substring(0,group.indexOf("/privileges/"));
                group=group.substring(group.lastIndexOf("/")+1);
                out.write("<tr>");
                out.write("<td>"+count+"</td><td>"+group+"</td>");
                String ACLpath = n.getProperty("path").getString();
                out.write("<td>"+ACLpath+"</td>");
                String deny = "";
                if(n.hasProperty("deny"))deny=n.getProperty("deny").getString();
                out.write("<td>"+deny+"</td>");
                out.write("</tr>");
            }
    }
    
    out.write("</table>");
    /*
    output results
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>page</b></td><td><b>count</b></td></thead>");
    Iterator iterMimes=pageMap.keySet().iterator();
    while(iterMimes.hasNext()){
        String key=(String)iterMimes.next();
        String cellstyle="";
        out.write("<tr>");
        out.write("<td"+cellstyle+">"+key+"</td>");
        out.write("<td"+cellstyle+">"+pageMap.get(key)+"</td>");
        out.write("</tr>");
    }
    out.write("</table>");
   */
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

String query="/jcr:root/home/groups//*[ @jcr:primaryType='cq:PrivilegeAce'] order by @path";
//query="/jcr:root/home//*[ @jcr:primaryType='cq:PrivilegeAce'] order by @path";
genericQuery(out,resourceResolver,query);


%>
</body>
</html>