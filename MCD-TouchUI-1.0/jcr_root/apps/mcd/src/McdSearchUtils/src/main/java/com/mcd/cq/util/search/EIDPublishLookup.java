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
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.auth.*;
import org.apache.commons.httpclient.methods.*;
import java.io.*;
import javax.servlet.Servlet;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="EID User Publish Lookup"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/cq/util/search/EIDPublishLookup"),
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

public class EIDPublishLookup extends SlingAllMethodsServlet {

    @Reference
    private org.apache.sling.jcr.api.SlingRepository repository;   
   
    private static final Logger log = LoggerFactory.getLogger(EIDPublishLookup .class);

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
        try {
          
            while(names.hasMoreTokens()){
                String name=names.nextToken();
                msg+=lookupUser(name);
                //msg+=getPublishEIDs(name);
                //msg+="<tr><td>"+name+"</td><td>"+mcid+"</td></tr>";           
            }
             
        }catch(Exception e){
               log.error("lookupUsers: exception occured:" + e.getMessage());
        }finally{
        }
        return msg;
  }
  
  public String lookupUser( String eid){

        
        String msg="";
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
        
        try
        {
            DirContext ctx = new InitialDirContext(env);
            String searchFilter = "(samAccountName=" + eid.trim() + "*)";
           
            SearchControls scon = new SearchControls();
           
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);
            
            int count=0;
            while (answer.hasMore() && count<100)
            {
                SearchResult sr = (SearchResult) answer.next();

                if (sr == null)
                {
                    log.error("SearchResult is null...continuing ");
                    continue;
                }
                Attributes attrs = sr.getAttributes();
                if (attrs == null)
                {
                    log.error("SR attributes is null...continuing");
                    continue;
                }
                String displayname="";
                String dn="";
                String location="";
                String personalTitle="";
                String primaryTelexNumber="";
                String email="";
                Attribute attr = attrs.get("displayName");
                if (attr != null)
                {
                    displayname= (String) attr.get(0);
                    
                    
                }
                attr = attrs.get("distinguishedName");
                if (attr != null)
                {
                    dn= (String) attr.get(0);
                    
                    
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
                
                attr = attrs.get("mail");
                if (attr != null)
                {
                    email= (String) attr.get(0);
                }
                
                msg+="<tr><td>"+eid+"</td><td>"+dn+"</td><td>"+displayname+"</td><td>"+email+"</td><td>"+location+"</td><td>"+personalTitle+"</td><td>"+primaryTelexNumber+"</td></tr>";
                count++;
            }

        }
        catch (Exception ex)
        {
            log.error(" exception occured" + ex.getMessage());
        }
        
        
        return msg;
        
  }
  
   private String getPublishEIDs(String eid){
        StringBuffer sb=new StringBuffer();
        String strComma="";
        
        String[] serverlist={
         "mcdeagsun113b.mcd.com:4212",
         "mcdeagsun113b.mcd.com:4216",
         "mcdeagsun115.mcd.com:4212",         
         "mcdeagsun115.mcd.com:4214"
        };

        
        for(int ix=0;ix<serverlist.length;ix++){
            String publishuser=new String(getCQ5Content("http://"+serverlist[ix]+"/content/utility/utility.userinfo.html?eid="+eid));
            sb.append("<b>Server:"+serverlist[ix]+"</b><br>");
            if(!publishuser.equals("")){
                sb.append(publishuser);
                strComma=",";
            }
        }
            return sb.toString();
    
    }
    
 
 
   public static byte[] getCQ5Content(String url){
             
            byte[] retbytes="".getBytes();
            GetMethod getPageMeth=null; 
            org.apache.commons.httpclient.HttpClient client = new HttpClient();
            HostConfiguration host = client.getHostConfiguration();
            
            try {

                host.setHost(new org.apache.commons.httpclient.URI(url));
                org.apache.commons.httpclient.Credentials credentials = new UsernamePasswordCredentials("admin", "H@rs!615D");
                client.getState().setCredentials(AuthScope.ANY, credentials);
                
                getPageMeth= new GetMethod(url);
                
                getPageMeth.setDoAuthentication( true );       
                getPageMeth.getParams().setParameter("http.socket.timeout", new Integer(10000));        
                client.getParams().setAuthenticationPreemptive( true );

                int status = client.executeMethod(getPageMeth);
                              
                if(status==200){
                    //retbytes= getPageMeth.getResponseBody(); 
                    byte[] byteArray=new byte[1024];
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream() ;
                    int count = 0 ;
                    while((count = getPageMeth.getResponseBodyAsStream().read(byteArray, 0, byteArray.length)) > 0)
                    { 
                     outputStream.write(byteArray, 0, count) ;
                    }                 
                    retbytes=outputStream.toByteArray();             
                 }      
            } catch(Exception e){
            }
            finally {
                getPageMeth.releaseConnection();
                client=null;
            }
            return retbytes;
     }

   public void processForm(SlingHttpServletRequest request, SlingHttpServletResponse response){
    

        try{
           PrintWriter out=response.getWriter(); 
            if(!request.getRemoteUser().equals("admin")){
                out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
                return;
                
             }
          
          String userlist=request.getParameter("userlist");
 
         out.println("<form action=\"\" method=\"POST\">");
          out.println("Enter user eid here:");
          
          out.println("<input name=\"userlist\" id=\"userlist\">");
            out.println("<input type=submit><br>");
          out.println("</form>");
 
          if(userlist!=null && !userlist.equals("")){
                //log.error("usergrouplist:" + usergrouplist);
                out.write("<h3>Results:</h3<br>");
                out.write("<h4>LDAP Record:</h4<br>");
                out.write("<table border=3>");
               out.write("<thead><tr><th><b>eid</b></th><th><b>DN</b></th><th><b>displayname</b></th><th><b>email</b></th><th><b>location</b></th><th><b>role</b></th><th><b>company</b></th></tr></thead>");
               out.write("<tbody>");
                out.write(lookupUser(userlist));  
                out.write("</tbody></table>");
                out.write(getPublishEIDs(userlist));
                //out.write(lookupUsers(userlist,true));
                
                out.write("</br>");        
          }
         
         
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