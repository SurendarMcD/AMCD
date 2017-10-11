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
<h2>ACLs</h2>
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
    boolean bRead=false;
    boolean bModify=false;  
    boolean bCreate=false;  
    boolean bDelete=false;  
    boolean bReadACL=false;  
    boolean bEditACL=false;  
    boolean bReplicate=false; 
    boolean bAll=false;


    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    //out.write(query+"test");
    out.write("<table>");
    int count=0; 
    out.write("<tr><td><b>Count</b></td><td><b>Path</b></td><td><b>Group</b></td><td><b>Rights</b></td>");
    out.write("<td><b>Read</b></td>");
    out.write("<td><b>Modify</b></td>");
    out.write("<td><b>Create</b></td>");
    out.write("<td><b>Delete</b></td>");
    out.write("<td><b>Read ACL</b></td>");
    out.write("<td><b>Edit ACL</b></td>");
    out.write("<td><b>Replicate</b></td>");
    out.write("</tr>");
    while(result.hasNext()) {
             bRead=false;
             bModify=false;  
             bCreate=false;  
             bDelete=false;  
             bReadACL=false;  
             bEditACL=false;  
             bReplicate=false;
             bAll=false;
            if(count>100000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String path= n.getPath();
                path=path.substring(0,path.indexOf("/rep:policy/"));
                // group=group.substring(group.lastIndexOf("/")+1);
                out.write("<tr>");
                out.write("<td>"+count+"</td><td>"+path+"</td>");
                String group = n.getProperty("rep:principalName").getString();
                out.write("<td>"+group+"</td>");


                String rights="";
                Value[] arrrights = n.getProperty("rep:privileges").getValues();
                for(int i=0;i<arrrights.length;i++){
                    String right=arrrights[i].getString();

                    if(right.equals("jcr:read"))bRead=true;
                    if(right.equals("rep:write"))bModify=true;
                    if(right.equals("jcr:addChildNodes"))bCreate=true;
                    if(right.equals("jcr:removeChildNodes"))bDelete=true;
                    if(right.equals("jcr:readAccessControl"))bReadACL=true;
                    if(right.equals("jcr:modifyAccessControl"))bEditACL=true;
                    if(right.equals("crx:replicate"))bReplicate=true;
                    if(right.equals("jcr:all"))bAll=true;

                    rights+=(i>0?",":"")+right;
                }
                out.write("<td>"+rights+"</td>");
                out.write("<td>"+((bAll || bRead)?"X":"")+"</td>");
                out.write("<td>"+((bAll || bModify)?"X":"")+"</td>");
                out.write("<td>"+((bAll || bCreate)?"X":"")+"</td>");
                out.write("<td>"+((bAll || bDelete)?"X":"")+"</td>");
                out.write("<td>"+((bAll || bReadACL)?"X":"")+"</td>");
                out.write("<td>"+((bAll || bEditACL)?"X":"")+"</td>");
                out.write("<td>"+((bAll || bReplicate)?"X":"")+"</td>");
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

String query="/jcr:root/content//*[ @jcr:primaryType='rep:GrantACE']";
//query="/jcr:root/home//*[ @jcr:primaryType='cq:PrivilegeAce'] order by @path";
genericQuery(out,resourceResolver,query);


%>
</body>
</html>