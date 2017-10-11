package com.mcd.cq.auth.impl;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

import java.util.*;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;

import org.apache.sling.api.SlingHttpServletRequest;

import org.apache.sling.api.SlingHttpServletResponse;

import javax.servlet.http.Cookie;

import org.apache.sling.api.servlets.SlingAllMethodsServlet;

import com.mcd.cq.util.search.SearchGroup;

import org.apache.sling.jcr.base.util.AccessControlUtil;

import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.auth.*;
import org.apache.commons.httpclient.methods.*;

import org.apache.sling.commons.osgi.OsgiUtil;
import org.osgi.service.component.ComponentContext;

import javax.jcr.Session;
import com.day.cq.security.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.sling.SlingServlet;



@SlingServlet(
    paths = {"/mcd/cq/util/logout"},
    methods = {"GET","POST"}
)

@Properties({
    @Property(name = "service.description", value = "SAML Logout Servlet"),
    @Property(name = "service.vendor", value = "MCD"),
    @Property(name = "service.pid", value = "com.mcd.cq.auth.impl.MCDSamlLogoutServlet"),
    @Property(name = "idpEndPoint", label="IDP EndPoint", description=""),
    @Property(name = "samlConsumerURL", label="SAML Consumer URL", description=""),
    @Property(name = "publicKeyFilePath", label="Public Key File Path Logout", description="")
})

/* SAML Logout Servlet
* Servlet to logout the user
*
* Erik Wannebo 6-17-2013
*/ 

public class MCDSamlLogoutServlet extends SlingAllMethodsServlet {

    // declare idpEndPoint. this is the ADFS URL. CQ redirects the user to this URL for authentication
    private String idpEndPoint = ""; //"https://nafs.mcd.com/adfs/ls";
    
    // declare the samlConsumerURL. this is same as cq instance base url. the expectation is the this authenticator is called
    // when a request comes to access the content but user is not authenticated yet.
    // need to check this.
    private String samlConsumerURL = ""; // "https://www.accessmcd.com"; 
    
    // declare the issuer. this is the issuer URL set up in ADFS 2.0
    // now defaults to the current domain - no longer configurable
    
    // declare the public key file path. this can be anywhere in the file system.
    private String publicKeyFilePath = ""; //"/app/mcd/cms/keys";
 

    private static final String SSO_COOKIE_NAME="CQADFS";
    
    private static final Logger log = LoggerFactory.getLogger(MCDSamlRedirectServlet.class);
    

    @Override

    protected void doGet(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
           
            String logoutURL="https://www.accessmcd.com/"; //default
            
            SAMLUserSession usersession = SAMLSessionManager.getInstance().getUserSession(request);
            if(usersession==null){
                log.error("User session not found");
                return;
            }
            String sessionIndex=usersession.getSamlUser().getSessionIndex();
            String userid=usersession.getSamlUser().getUserid();
            
            String signOutKeyStorePath="";
            
            this.idpEndPoint = "https://gafsstg.mcd.com/adfs/ls/";
            
            this.publicKeyFilePath = "/app/mcd/cms/keys/stg_gafs.cer";
            
            
            String requestDomain=request.getRequestURL().toString();
            if(requestDomain.startsWith("https://")){
               requestDomain=requestDomain.substring(8);
            }else{ //http
               requestDomain=requestDomain.substring(7);
            }
            requestDomain=requestDomain.substring(0,requestDomain.indexOf("/")); 
            String issuer = "https://"+requestDomain;               
          
            
            if(this.publicKeyFilePath.lastIndexOf("/")>-1){
                signOutKeyStorePath=this.publicKeyFilePath.substring(0,this.publicKeyFilePath.lastIndexOf("/")+1)+requestDomain+".keystore.ImportKey";
            }
            log.error("signOutKeyStorePath:"+signOutKeyStorePath);
            log.error("this.publicKeyFilePath:"+this.publicKeyFilePath);
            log.error("issuer :"+issuer );
            log.error("sessionIndex:"+sessionIndex);
            log.error("userid:"+userid);
            
            removeCQAuthCookies(response);
            
            
            try{
                logoutURL=SAMLUtil.createSAMLSignOutRequest(this.idpEndPoint, issuer , sessionIndex, userid, signOutKeyStorePath, this.publicKeyFilePath);
            }catch(Exception e){
            
            }
            
            response.sendRedirect(logoutURL);


    }

    @Override

    protected void doPost(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            this.doGet(request,response);

    }
    
  protected void activate(ComponentContext componentContext)
  {
    configure(componentContext.getProperties());
  }

  protected void configure(Dictionary<?, ?> properties) {

    this.idpEndPoint = OsgiUtil.toString(properties.get("idpEndPoint"), "https://gafsstg.mcd.com/adfs/ls/");
    this.samlConsumerURL = OsgiUtil.toString(properties.get("samlConsumerURL"), "");
    this.publicKeyFilePath = OsgiUtil.toString(properties.get("publicKeyFilePath"), "/app/mcd/cms/keys/stg_gafs.cer");

  }
  
  protected void removeCQAuthCookies(SlingHttpServletResponse response){
    //CQ Session (?)
    Cookie cqsessioncookie=new Cookie("JSESSIONID",null);
    cqsessioncookie.setMaxAge(0);
    cqsessioncookie.setPath("/");
    response.addCookie(cqsessioncookie); 
       
    //MCD ADFS Session
    Cookie sessioncookie=new Cookie(SSO_COOKIE_NAME,null);
    sessioncookie.setMaxAge(0);
    sessioncookie.setPath("/");
    response.addCookie(sessioncookie);
  }
    
    
}