<%/*
Lists recently updated files
Sumit 11/22/2014
*/
%>
<%@ page import="java.util.Calendar,  
        java.text.SimpleDateFormat,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
        javax.naming.Context,
        javax.naming.NamingEnumeration,
        javax.naming.directory.Attribute,
        javax.naming.directory.Attributes,
        javax.naming.directory.DirContext,
        javax.naming.directory.InitialDirContext,
        javax.naming.directory.SearchControls,
        javax.naming.directory.SearchResult,
        com.day.cq.security.*,
        java.util.regex.*
"%>
<%@ page import="org.apache.jackrabbit.api.security.user.UserManager" %>
<%@ page import="org.apache.jackrabbit.api.JackrabbitSession" %>
<%@ page import="org.apache.jackrabbit.api.security.user.User" %>
<%@ page import="org.apache.jackrabbit.api.security.user.Group" %>
<%@ page import="org.apache.jackrabbit.api.security.user.Authorizable" %>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<%!

 public String bold(String str){
     return "<b>"+str+"</b>";
 }
 
 public String tr(String str){
     return "<tr>"+str+"</tr>";
 }
 
 public String td(String str){
     return "<td>"+str+"</td>";
 }
  public String checkNull(String strString)
    {
        if(strString == null || strString.equalsIgnoreCase("NULL") || strString.indexOf("NULL") != -1)
            return "";
        else
            return strString.trim();
    }
    private String getPropertyString(Value[] values)
    {
        if (values != null)
        {
            if (values.length > 0)
            {
                try
                {
                    return values[0].getString();
                }
                catch (Exception e)
                {
                    System.out.print("[getPropertyString] method: "+e.getMessage());
                }
            }
        }
        return null;
    }
    
 private UserManager getUserManager(Session jcrSession) throws Exception
    {
        if (jcrSession instanceof JackrabbitSession)
        {
            return ((JackrabbitSession) jcrSession).getUserManager();
        }
        else
        {
            throw new Exception("Session is not of type JackrabbitSession");
        }

    }
 public String viewUser(UserManager uMgr, String userid) throws Exception {
            String BR="<br>";
            String deleted="User Deleted";
            String msg="";
            User user=(User)uMgr.getAuthorizable(userid);
            if(user!=null)
            {

               msg+="<tr><td>"+userid+"</td><td>"+checkNull(getPropertyString(user.getProperty("rep:principalName")))+"</td><td>"+(checkNull(getPropertyString(user.getProperty("rep:fullname"))))+"</td><td>"+(checkNull(getPropertyString(user.getProperty("rep:mcdAudience"))))+"</td><td>"+(checkNull(getPropertyString(user.getProperty("rep:lastsynced"))))+"</td>";
                msg+="<td>";
                Iterator usergroups=user.memberOf();
                while(usergroups.hasNext()){
                    Group grp=(Group)usergroups.next();
                    msg+=grp.getID()+BR;
                }
                msg+="</td></tr>";
                Authorizable authorizable = uMgr.getAuthorizable(userid); 
                authorizable.remove();
            }
            return msg+BR+deleted;
          
        }

%>
 
 <%
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
UserManager uMgr =  getUserManager(jcrSession); 

HttpServletRequest cqReq = request;
boolean isAdmin=false;
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    isAdmin=false;
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    return;
}


String eid=request.getParameter("eid");
if(eid!=null){
out.write("<table border=3>");
out.write("<thead><tr><th><b>eid</b></th><th><b>DN</b></th><th><b>displayname</b></th><th><b>mcdAudience</b></th><th><b>Last Synced</b></th><th><b>Groups</b></th></tr></thead>");
out.write("<tbody>");
out.write(viewUser(uMgr,eid));
out.write("</tbody></table>");
out.write("</br>");        


//out.println(viewUser(uMgr,eid));

}
%>