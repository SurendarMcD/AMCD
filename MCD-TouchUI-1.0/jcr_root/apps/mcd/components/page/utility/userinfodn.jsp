<%/*
Lists recently updated files
Erik Wannebo 11/22/2010
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
        java.util.regex.*;
"%>
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

 public String viewUser(UserManager uMgr, String userid) throws Exception {
            String BR="<br>";
            String msg="";
            User user=null;
            try{
                user=(User)uMgr.get(userid);
            }catch(NoSuchAuthorizableException e){
                msg+="User "+userid+" not found."+BR;
            }
            if(user!=null){
                //msg+=bold("EID:")+userid+BR;
                String name=user.getProperty("rep:fullname");
                if(name==null)name=user.getName();
                //msg+=bold("Name:")+name+BR;

                //msg+=bold("Principal:")+"<font color=red>"+user.getPrincipal().getName()+"</font>"+BR;
                //msg+=bold("Last Synched:")+user.getProperty("rep:lastsynced")+BR;
                //msg+=bold("mcdaudience:")+user.getProperty("rep:mcdAudience")+BR;
                //msg+="<tr><td>"+userid+"</td><td>"+user.getPrincipal().getName()+"</td><td>"+name+"</td><td>"+user.getProperty("rep:mcdAudience")+"</td><td>"+user.getProperty("rep:lastsynced")+"</td>";
                msg = user.getPrincipal().getName();
                //msg+="<td>";
                /*Iterator usergroups=user.memberOf();
                while(usergroups.hasNext()){
                    Group grp=(Group)usergroups.next();
                    msg+=grp.getName()+BR;
                }*/
                //msg+="</td></tr>";
            } 
            //return msg+BR;
              return msg;
        }

%>
 
 <%
final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
UserManager uMgr = userManagerFactory.createUserManager(jcrSession);

HttpServletRequest cqReq = request;
boolean isAdmin=false;
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    isAdmin=false;
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    return;
}


String eid=request.getParameter("eid");
if(eid!=null){
//out.write("<table border=3>");
//out.write("<thead><tr><th><b>eid</b></th><th><b>DN</b></th><th><b>displayname</b></th><th><b>mcdAudience</b></th><th><b>Last Synced</b></th><th><b>Groups</b></th></tr></thead>");
//out.write("<tbody>");
out.write(viewUser(uMgr,eid));
//out.write("</tbody></table>");
//out.write("</br>");        


//out.println(viewUser(uMgr,eid));

}
%>