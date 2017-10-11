package com.mcd.cq.auth.impl;


import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

import java.util.Date;
import java.util.Iterator;
import java.util.*;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;

import org.apache.sling.api.SlingHttpServletRequest;

import org.apache.sling.api.SlingHttpServletResponse;

import org.apache.sling.api.servlets.SlingAllMethodsServlet;

import com.mcd.cq.util.search.SearchGroup;

import org.apache.sling.jcr.base.util.AccessControlUtil;

import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.auth.*;
import org.apache.commons.httpclient.methods.*;

import javax.jcr.*;
import com.day.cq.security.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mcd.cq.util.UserAdmin;
import com.mcd.cq.util.CRXInfoService;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import org.apache.sling.api.resource.*; 
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.sling.SlingServlet;



@SlingServlet(
    paths = {"/mcd/cq/auth/GASUserMaint"},
    methods = {"GET","POST"}
)

@Properties({
    @Property(name = "service.description", value = "User Creator"),
    @Property(name = "service.vendor", value = "MCD"),
    @Property(name = "service.pid", value = "com.mcd.cq.auth.impl.GASUserMaint")
})
 
@SuppressWarnings("serial")

/*
  ==============================================================================
  User Maintenance
  for Global AS Implementation
  
  Erik Wannebo 12/3/2011
  ==============================================================================
*/

public class GASUserMaint extends SlingAllMethodsServlet {

    /** @scr.reference */
    private UserManagerFactory umf;
    
    /** @scr.reference */
    private org.apache.sling.jcr.api.SlingRepository repository;   
   

    
    private static final Logger log = LoggerFactory.getLogger(GASUserMaint.class);

    @Override

    protected void doGet(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
           
            response.setContentType("text/html");
            processForm(request,response);
}


 protected void doPost(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            this.doGet(request,response);

    }


  public String createUsersAndGroups(String usergrouplist,boolean bUpdateUserOnly){
        String msg="";
        //log.error("usergrouplist="+usergrouplist);
        StringTokenizer eids= new StringTokenizer(usergrouplist);
        Session session = null;
        try {
           session = repository.loginAdministrative(null);
           UserManager uMgr= umf.createUserManager(session); 
        
            while(eids.hasMoreTokens()){
                String eidgroup=eids.nextToken();
                //log.error("eidgroup="+eidgroup); 
                String userid=eidgroup.split("\\|")[0];
                //log.error("userid="+userid); 
                //String principalname=eidgroup.split("|")[1];
                String groupid="";
                if(!bUpdateUserOnly)groupid=eidgroup.split("\\|")[1];
                User user=null;
                try{
                       user = (User)uMgr.get(userid);
                    }catch(com.day.cq.security.NoSuchAuthorizableException e){
                        user=createUser(uMgr, userid);
                    }
                if(bUpdateUserOnly){
                    updateUser(uMgr,userid);
                }else{
                    if(user!=null){
                        msg+=addUserToGroup(uMgr, user, groupid);
                    }else{
                        log.error("user is null:" + userid);
                    }
                }
               
            }
             try{
                    session.save();
                    }catch(Exception e){
                    log.error("error saving session:" + e.getMessage());
                    }
        }catch(Exception e){
               log.error("createUsersGroups: exception occured:" + e.getMessage());
        }finally{
               session.logout();
        }
        return msg;
  }
  
  public User createUser(UserManager uMgr, String userid){

        log.error("createUser:"+userid);
        User retUser=null;
        Hashtable<String, String> env = new Hashtable<String, String>();
        /* //PROD
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://66.111.144.237:3268/DC=pri");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,CN=Users,DC=narest,DC=pri"); 
        env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
         */
        
        // STG
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://66.111.145.9:3268/DC=pri");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,OU=Service Accounts,OU=US,DC=labnarestmgmt,DC=pri");
        env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
       
        String principalname="";
        
        try
        {
            DirContext ctx = new InitialDirContext(env);
            String searchFilter = "(samAccountName=" + userid.trim() + "*)";
           
            SearchControls scon = new SearchControls();
           
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);
            
            while (answer.hasMore())
            {
                SearchResult sr = (SearchResult) answer.next();

                if (sr == null)
                {
                    log.error("SearchResult is null...continuing");
                    continue;
                }
                Attributes attrs = sr.getAttributes();
                if (attrs == null)
                {
                    log.error("SR attributes is null...continuing");
                    continue;
                }
                
                Attribute attr = attrs.get("distinguishedName");
                if (attr != null)
                {
                    principalname= (String) attr.get(0);
                    
                }
            }

        }
        catch (Exception ex)
        {
            log.error(" exception occured" + ex.getMessage());
        }
        
        if(!principalname.equals("")){
             try{
                String password=Double.toString(Math.random());
                String path="/home/users/"+userid.substring(0,6)+"xx/";
                retUser=(User)uMgr.createUser(userid,password,principalname,path);
            }catch(Exception e){
                log.error("createUser: exception occured" + e.getMessage());
                return retUser;
            }
            
        }
        return retUser;
        
  }
  
  public User updateUser(UserManager uMgr, String userid){

        log.error("updateUser:"+userid);
        User retUser=null;
        Hashtable<String, String> env = new Hashtable<String, String>();
         //PROD
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://66.111.144.237:3268/DC=pri");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,CN=Users,DC=narest,DC=pri"); 
        env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
        
        /*
        // STG
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://66.111.145.9:3268/DC=pri");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,OU=Service Accounts,OU=US,DC=labnarestmgmt,DC=pri");
        env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
        */
        String principalname="";
        String fullname="";
        String mail="";
        try
        {
            DirContext ctx = new InitialDirContext(env);
            String searchFilter = "(samAccountName=" + userid.trim() + "*)";
           
            SearchControls scon = new SearchControls();
           
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);
            
            while (answer.hasMore())
            {
                SearchResult sr = (SearchResult) answer.next();

                if (sr == null)
                {
                    log.error("SearchResult is null...continuing");
                    continue;
                }
                Attributes attrs = sr.getAttributes();
                if (attrs == null)
                {
                    log.error("SR attributes is null...continuing");
                    continue;
                }
                
                Attribute attr = attrs.get("distinguishedName");
                if (attr != null)
                {
                    principalname= (String) attr.get(0);
                    
                }
                attr = attrs.get("displayName");
                if (attr != null)
                {
                    fullname= (String) attr.get(0);
                    
                }
                attr = attrs.get("mail");
                if (attr != null)
                {
                    mail=(String) attr.get(0);
                    
                }
            }

        }
        catch (Exception ex)
        {
            log.error(" exception occured" + ex.getMessage());
        }
        
        if(!principalname.equals("")){
             try{
                //String password=Double.toString(Math.random());
                //String path="/home/users/"+userid.substring(0,6)+"xx/";
                retUser=(User)uMgr.get(userid);
                retUser.setProperty("rep:fullname",fullname);
                retUser.setProperty("rep:e-mail",mail);
            }catch(Exception e){
                log.error("updateUser: exception occured" + e.getMessage());
                return retUser;
            }
            
        }
        return retUser;
        
  }
  
   public User createTAMUser(UserManager uMgr, String userid){

        User retUser=null;
        log.error("createTAMUser:"+userid);
        String principalname = "uid=" + userid + ",ou=People,o=accessmcd.com,o=mcd.com";
        
        if(!principalname.equals("")){
             try{
                String password=Double.toString(Math.random());
                String path="/home/users/"+userid.substring(0,6)+"xx/";
                retUser=(User)uMgr.createUser(userid,password,principalname,path);
            }catch(Exception e){
                log.error("createTAMUser: exception occured:" + e.getMessage());
                return retUser;
            }
            
        }
        return retUser;
        
  }

 
   public String addUserToGroup(UserManager uMgr, User user,String groupid){
   log.error("addUserToGroup:"+user.getID());
       String msg="";
       try{
         Group group=(Group)uMgr.get(groupid);
          if(group==null){
            return msg;
          }
          try{
            group.addMember(user);
          }catch(Exception e){
          }
          }catch(Exception e){
          log.error("error getting group "+ groupid+" "+ e.getMessage());
          }
        return msg;
    } 
    
   public void deleteUsers(Session session, ResourceResolver resourceResolver, PrintWriter out){
       try{ 
            String query="/jcr:root/home//*[ @jcr:primaryType='rep:User' ]";
            Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
            long start=System.currentTimeMillis();
            int count=0;
            while(result.hasNext() && count<20000) { 
                //if(count>100)break;
                //count++;
                Resource r=(Resource)result.next();
                javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
                if (n != null && n.getPath().toLowerCase().startsWith("/home/users/e")) {
                    //out.println(n.getPath()+"<br>");
                    session.removeItem(n.getPath());
                    count++;
                }
           }
           out.println(count+" users removed.");
           out.println((System.currentTimeMillis()-start)+" ms.");
       }catch(Exception e){
          try{
              out.println(e.getMessage());
          }catch(Exception ex){
      }
  }

    } 

    public void listUserGroups(Session session, PrintWriter out){
    int count=0;
    int multigroupusers=0;

    try {
       
       UserManager uMgr= umf.createUserManager(session); 

        out.println("<table>");
        Iterator<User> result=uMgr.getUsers();
        while(result.hasNext()) { 
                if(count>1000000)break; 
                count++;
    
                User a=(User)result.next();
                
                if (a != null) {
                    Iterator memof=a.memberOf();
                    int groupcount=0;
                    java.util.List groups=new ArrayList();
                    while(memof.hasNext()){
                        groupcount++;
                        Group grp = (Group)memof.next();
                        if(!grp.getName().startsWith("DEFAULT")){
                            //out.println("<tr><td>"+a.getID()+"</td>");
                            //out.println("<td>"+grp.getName()+"</td></tr>");
                            out.println("<tr><td>"+a.getID()+"|"+grp.getID()+"</td></tr>");
                            }
                    }
                    if(groupcount>1){
                        multigroupusers++;
                    }
                }
        }
         out.println("</table>");
         out.println("User Count: "+count+"<br>");
         out.println("Users in >1 group: "+multigroupusers);
      }catch(Exception e){
          try{
              out.println(e.getMessage());    
          }catch(Exception ex){
          }
      }
     
        
    }

   public void processForm(SlingHttpServletRequest request, SlingHttpServletResponse response){
 
        Session session = null;
        try{
            PrintWriter out=response.getWriter();
            if(!request.getRemoteUser().equals("admin")){
                out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
                return;
                
             }
          String usergrouplist=request.getParameter("usergrouplist");
          if(usergrouplist!=null && !usergrouplist.equals("")){
                //log.error("usergrouplist:" + usergrouplist);
                out.write(createUsersAndGroups(usergrouplist,true));
            }
            
          String listUserGroups=request.getParameter("listUserGroups");
          if(listUserGroups!=null && !listUserGroups.equals("")){
              session = repository.loginAdministrative(null);
              listUserGroups(session,out); 
              session.save();
              session.logout();
          }          
          
          String deleteUsers=request.getParameter("deleteUsers");
          //change this to allow user deletion
          boolean bEnableDelete=false;
          if(deleteUsers!=null && !deleteUsers.equals("")){
                if(bEnableDelete){
                    ResourceResolver resResolver=request.getResourceResolver();
                    session = repository.loginAdministrative(null);
                    deleteUsers(session,resResolver,out);
                    session.save();
                    session.logout();
                }else{
                    out.println("<font color=red>bEnableDelete is false.</font>");
                }
            }

          out.println("<br>Enter users/groups here:<br>");
          out.println("<form action=\"\" method=\"POST\">");
          out.println("<textarea name=\"usergrouplist\" id=\"usergrouplist\" rows=20 cols=150 ></textarea><br>");
          out.println("<b>List Users/Groups</b><INPUT type=checkbox name=\"listUserGroups\" ><br>");
          out.println("<b>DELETE USERS</b><INPUT type=checkbox name=\"deleteUsers\" ><br>");
          out.println("<input type=submit>");
          out.println("</form>");
         }catch(Exception e){
         }
         }
}