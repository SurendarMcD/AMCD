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
    @Property(name = "sling.servlet.paths", value="/mcd/cq/util/search/NameLookup"),
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

public class NameLookup extends SlingAllMethodsServlet {

	@Reference
    private org.apache.sling.jcr.api.SlingRepository repository;   
   
    private static final Logger log = LoggerFactory.getLogger(NameLookup.class);

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


  public String lookupUsers(String userlist,int limit,boolean bUpdateUserOnly){
        String msg="";
         StringTokenizer names= new StringTokenizer(userlist,"\n");
        Session session = null;
        try {
          
            while(names.hasMoreTokens()){
                String name=names.nextToken();
                msg+=lookupUser(name,limit);
                //msg+="<tr><td>"+name+"</td><td>"+mcid+"</td></tr>";           
            }
             
        }catch(Exception e){
               log.error("lookupUsers: exception occured:" + e.getMessage());
        }finally{
        }
        return msg;
  }
  
  public String lookupUser( String lastname,int limit){

        
        String msg="";
        Hashtable<String, String> env = new Hashtable<String, String>();
        TreeMap results=new TreeMap();
        
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
            String searchFilter = "(sn=" + lastname.trim() + "*)";
           
            SearchControls scon = new SearchControls();
           
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);
            
            int count=0;
            while (answer.hasMore() && count<limit)
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
                String eid="";
                String sn="";
                String fn="";
                String personalTitle="";
                String primaryTelexNumber="";
                
                Attribute attr = attrs.get("displayName");
                if (attr != null)
                    displayname= (String) attr.get(0);
                attr = attrs.get("samAccountName");
                if (attr != null)
                    eid= (String) attr.get(0);
                attr = attrs.get("sn");
                if (attr != null)
                    sn= (String) attr.get(0);
                attr = attrs.get("givenName");
                if (attr != null)
                    fn= (String) attr.get(0);
                //attr = attrs.get("displayName");
                //if (attr != null)
                //    displayname= (String) attr.get(0);
                attr = attrs.get("l");
                if (attr != null)
                    location= (String) attr.get(0);
                attr = attrs.get("personalTitle");
                if (attr != null)
                    personalTitle= (String) attr.get(0);
                 attr = attrs.get("primaryTelexNumber");
                if (attr != null)
                    primaryTelexNumber= (String) attr.get(0);
                attr = attrs.get("l");
                if (attr != null)
                    location= (String) attr.get(0);

                msg="<tr><td>"+eid+"</td>";
                msg+="<td>"+sn+"</td>";
                msg+="<td>"+fn+"</td>";
                //msg+="<td>"+displayname+"</td>";
                msg+="<td>"+location+"</td>";
                msg+="<td>"+personalTitle+"</td>";
                msg+="<td>"+primaryTelexNumber+"</td>";
                msg+="</tr>";
                results.put(sn+fn+displayname,msg);
                count++;
            }
            if(count>(limit-1)){
                msg="<tr><td><font color=red>Limited to "+limit+" results</font></tr>";
            }else{
                msg="";
                }
            Iterator iterkeys=results.keySet().iterator();
            while(iterkeys.hasNext()){
                String key=(String)iterkeys.next();
                msg+=(String)
                results.get(key);
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
          
          int limit=100;
          String strlimit=request.getParameter("limit");
          if(strlimit!=null && !strlimit.equals("")){
              try{
                  limit=Integer.parseInt(strlimit);
              }catch(Exception e){}
          }
          String userlist=request.getParameter("userlist");
          
          if(userlist!=null && !userlist.equals("")){
                //log.error("usergrouplist:" + usergrouplist);
                out.write("<h3>Results:</h3<br>");
                out.write("<table>");
                out.write(lookupUsers(userlist,limit,true));
                out.write("</table>");
                out.write("</br>");        
          }
         
          out.println("Enter user last names here:<br>");
          out.println("<form action=\"\" method=\"POST\">");
          out.println("<textarea name=\"userlist\" id=\"userlist\" rows=10 cols=150 ></textarea><br>");
          out.println("<b>Limit:</b>");
          out.println("<select name=\"limit\" id=\"limit\">");
          out.println("<option value=100>100</option>");
          out.println("<option value=250>250</option>");
          out.println("<option value=500>500</option>");
          out.println("<option value=1000>1000</option>");
          out.println("</select>");
          out.println("<input type=submit>");
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