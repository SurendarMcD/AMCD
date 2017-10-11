package com.mcd.cq.util.search;


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
import javax.servlet.Servlet;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="User Creator"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/cq/util/search/EIDLookup"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})


@SuppressWarnings("serial")


/*
  ==============================================================================
  EID Lookup
  AD Lookup utility
  
  Erik Wannebo 1/30/2011
  ==============================================================================
*/

public class EIDLookup extends SlingAllMethodsServlet {

	@Reference
    private org.apache.sling.jcr.api.SlingRepository repository;   
   
    private static final Logger log = LoggerFactory.getLogger(EIDLookup.class);

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


  public String lookupUsers(String userlist,boolean bUpdateUserOnly){
        
        String msg="";
         StringTokenizer names= new StringTokenizer(userlist,"\n");
        Session session = null;
       
        Hashtable<String, String> env = new Hashtable<String, String>();
         //PROD
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://66.111.144.237:3268/DC=pri");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,CN=Users,DC=narest,DC=pri"); 
        env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
        try {
            DirContext ctx = new InitialDirContext(env);log.error("ctx----->"+ctx);
            while(names.hasMoreTokens()){
                String name=names.nextToken();log.error("name----->"+name);
                msg+=lookupUser(ctx,name);log.error("msg----->"+msg);
                //msg+="<tr><td>"+name+"</td><td>"+mcid+"</td></tr>";           
            }
             
        }catch(Exception e){
               log.error("lookupUsers: exception occured:" + e.getMessage());
        }finally{
        }
        return msg;
  }
  
  public String lookupUser( DirContext ctx, String eid){

        
        String msg="";

        
        /*
        // STG
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://66.111.145.9:3268/DC=pri");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,OU=Service Accounts,OU=US,DC=labnarestmgmt,DC=pri");
        env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
        */
        String principalname="";
        
        try
        {
            
            String searchFilter = "(samAccountName=" + eid.trim() + "*)";
           
            SearchControls scon = new SearchControls();
           
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);
            log.error("NamingEnumeration------>"+answer);
            int count=0;
            while (answer.hasMore() && count<100)
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
                String displayname="";
                String location="";
                String storeno="";
                String personalTitle="";
                String primaryTelexNumber="";
                Attribute attr = attrs.get("displayName");
                if (attr != null)
                {
                    displayname= (String) attr.get(0);
                    
                    
                }
                attr = attrs.get("l");
                if (attr != null)
                {
                    location= (String) attr.get(0);
                }
                attr = attrs.get("personalTitle");
                if (attr != null)
                {
                    personalTitle= (String) attr.get(0);
                }
                 attr = attrs.get("primaryTelexNumber");
                if (attr != null)
                {
                    primaryTelexNumber= (String) attr.get(0);
                }
                 attr = attrs.get("l");
                if (attr != null)
                {
                    location= (String) attr.get(0);
                }
                attr = attrs.get("st");
                if (attr != null)
                {
                    storeno= (String) attr.get(0);
                }
                msg+="<tr><td>"+eid+"</td><td>"+displayname+"</td><td>"+storeno+"</td><td>"+location+"</td><td>"+personalTitle+"</td><td>"+primaryTelexNumber+"</td></tr>";
                count++;
            }

        }
        catch (Exception ex)
        {
            log.error(" exception occured" + ex.getMessage());
        }
        
        
        return msg;
        
  }
  
 

   public void processForm(SlingHttpServletRequest request, SlingHttpServletResponse response){
    

        try{
           PrintWriter out=response.getWriter(); 
            if(!request.getRemoteUser().equals("admin")){
                out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
                return;
                
             }
          
          String userlist=request.getParameter("userlist");
          if(userlist!=null && !userlist.equals("")){
                //log.error("usergrouplist:" + usergrouplist);
                out.write("<h3>Results:</h3<br>");
                out.write("<table border=3>");
               out.write("<thead><tr><th><b>eid</b></th><th><b>displayname</b></th><th><b>location</b></th><th><b>role</b></th><th><b>company</b></th></tr></thead>");
               out.write("<tbody>");
               out.write(lookupUsers(userlist,true));
                out.write("</tbody></table>");
                out.write("</br>");        
          }
         
          out.println("<form action=\"\" method=\"POST\">");
          out.println("Enter user eids here:");
          out.println("<input type=submit><br>");
          out.println("<textarea name=\"userlist\" id=\"userlist\" rows=20 cols=150 ></textarea><br>");

          out.println("</form>");
         }catch(Exception e){
         }
	}
    protected void bindRepository(org.apache.sling.jcr.api.SlingRepository repository)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.repository = repository;
            
    }   
    protected void unbindRepository(org.apache.sling.jcr.api.SlingRepository repository)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        repository = null;
    }
}