<%@page session="false" %>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="org.apache.sling.jcr.api.SlingRepository" %>
<%@ page import="org.apache.jackrabbit.api.security.user.UserManager" %>
<%@ page import="org.apache.jackrabbit.api.JackrabbitSession" %>
<%@ page import="org.apache.jackrabbit.api.security.user.User" %>
<%@ page import="org.apache.jackrabbit.api.security.user.Group" %>
<%@ page import="org.apache.jackrabbit.api.security.user.Authorizable" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.*" %>

 <%!

    
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
    %>                 
       
 <%
    String userName="";
    String name = (request.getParameter("name")!= null) ? request.getParameter("name").toString().trim() : "";
    String eidlist = (request.getParameter("eidlist")!= null) ? request.getParameter("eidlist").toString().trim() : "";
    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
    UserManager uMgr =  getUserManager(jcrSession); 
    
    if(name!=null && name!=""){ out.print("None Zerooooooooooo");
    Group group=(Group)uMgr.getAuthorizable(name);
    
    if(group!=null)
        {
        Iterator members= group.getMembers();
        ArrayList idList=new ArrayList();
        while(members.hasNext())
            {
         Authorizable member=(Authorizable)members.next();
         if(!member.isGroup())
                {
               userName = member.getID();
               out.print(userName);
               uMgr= getUserManager(jcrSession);
                Authorizable authorizable = uMgr.getAuthorizable(userName); out.print("---"+authorizable+"--->");
                //authorizable.remove();
                }
         
         }
        
        }
    }
         else 
                {
                  
                    String[] arrEID = eidlist.split(",");
                    String eidValue="";
                    for(int i=0 ; i<arrEID.length ; i++)
                    {
                                                
                        eidValue=arrEID[i].trim();
                        if(!eidValue.equalsIgnoreCase(""))
                        {   
                         uMgr = getUserManager(jcrSession);out.print("11111"+uMgr);
                         Authorizable authorizable = uMgr.getAuthorizable(eidValue); out.print("222222");
                        // authorizable.remove();
                            
                        }
                    }
                 } 
 
                    
%>
