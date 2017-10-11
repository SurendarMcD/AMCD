package com.mcd.cq.auth.impl;
/*
* Custom Authenticator to handle ADFS (SAML) Authentication
* 7/18/2011 Erik Wannebo
*
* Added Logout handling and Page Freezer IDs
* 7/12/13 ECW
*
* Updated for 6.1
* 12/14/2015 ECW
*
*/
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Dictionary;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.jcr.SimpleCredentials;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.StringUtils;


import org.apache.jackrabbit.api.security.user.Authorizable;
import org.apache.jackrabbit.api.security.user.Group;
import org.apache.jackrabbit.api.security.user.UserManager;
import org.apache.jackrabbit.api.JackrabbitSession;

import com.adobe.granite.crypto.CryptoException;
import com.adobe.granite.crypto.CryptoSupport;

import org.apache.sling.auth.core.spi.AuthenticationHandler;
import org.apache.sling.auth.core.spi.AuthenticationInfo;
import org.apache.sling.commons.osgi.OsgiUtil;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Enumeration;
import com.day.crx.security.token.TokenUtil;
import org.apache.sling.jcr.api.SlingRepository;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.ValueFactory;
import javax.jcr.AccessDeniedException;

import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ResourceResolverFactory;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.PrintWriter;

import java.util.zip.Deflater;
import org.apache.commons.codec.binary.Base64;
import org.jdom.Element;
import org.jdom.Namespace;
import javax.servlet.http.Cookie;

import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.ConfigurationPolicy;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.sling.SlingServlet;
import org.apache.sling.auth.core.spi.AuthenticationFeedbackHandler;
import org.apache.sling.auth.core.spi.DefaultAuthenticationFeedbackHandler;
import javax.jcr.RepositoryException;

import com.mcd.accessmcd.util.ADMapper;
import com.mcd.accessmcd.util.McdLdapLoadRules;

@Component(metatype=true, label="MCD SAML SSO Authenticator", description="MCD SAML SSO Authenticator", policy=ConfigurationPolicy.OPTIONAL, configurationFactory=true)

@Service(value = {org.apache.sling.auth.core.spi.AuthenticationHandler.class} , serviceFactory=true)

@Properties({
    @Property(name = "service.description", value = "MCD SSO Authentication Handler", propertyPrivate=true),
    @Property(name = "service.pid", value = "com.mcd.cq.auth.impl.MCDSsoAuthenticationHandler", propertyPrivate=true),
    @Property(name = "service.vendor", value = "MCD", propertyPrivate=true),
    @Property(name = "path", value = "/", propertyPrivate=false),
    @Property(name = "idpEndPoint", label="IDP EndPoint", description="", propertyPrivate=false),
    @Property(name = "samlConsumerURL", label="SAML Consumer URL", description="", propertyPrivate=false),
    @Property(name = "publicKeyFilePath", label="Public Key File Path", description="", propertyPrivate=false),
    @Property(name = "protectedDomains", label="Protected Domains", description="", propertyPrivate=false),
    @Property(name = "renderId", label="Render Id", description="", propertyPrivate=false)
})
 
public class MCDSsoAuthenticationHandler
  extends AbstractHTTPAuthHandler implements AuthenticationFeedbackHandler
{
  private static final String NO_LOGIN_FORM = "auth.http.nologin";
  private static final boolean DEFAULT_NO_LOGIN_FORM = false;
  private final Logger log; 
  private boolean noLoginForm;
  private String realm;
  private String defaultLoginPage;
  private String[] formSupportingUserAgents;
  private String[] utf8EncodingUserAgents;
  private String trustedCredentialsAttribute;
  private String renderid;


  @Reference
  private SlingRepository repository;

  @Reference
  private CryptoSupport cryptoSupport;

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
 

    //these are the Domains which will use this authenticator, can be pipe-delimited
    private String protectedDomains;
    private List protectedDomainsList;
    
  public MCDSsoAuthenticationHandler()
  {
    this.log = LoggerFactory.getLogger(super.getClass());
  }

  public AuthenticationInfo extractCredentials(HttpServletRequest request, HttpServletResponse response)
  {
     String remoteAddr=request.getRemoteAddr();
    
          boolean protectedURL=false;

          if(this.protectedDomainsList.size()==0){
              protectedURL=true;
          }else{
              Iterator iterurls=this.protectedDomainsList.iterator();
              while(iterurls.hasNext()){
                  String proturl=(String)iterurls.next();
                  if(request.getRequestURL().indexOf(proturl)>0){
                      protectedURL=true;
                      break;
                  }
              }
          }
          if(protectedURL)
          {
              //is user already authenticated?
              AuthenticationInfo existinginfo = super.extractCredentials(request, response);
              if(existinginfo!=null)return existinginfo;

            
              //has SSO cookie been set?
              SAMLUserSession usersession = SAMLSessionManager.getInstance().getUserSession(request);
              response.setHeader("P3P","CP=\"CAO PSA OUR\"");
              if(usersession!=null){
                  //log.error("session is null");

                  return createAuthenticationInfo(request,response,usersession.getSamlUser().getUserid());

              }
              
              AuthenticationInfo ainfo=checkSsoAdfs(request,response);
              if(ainfo!=null){
                  return ainfo;
              }else{
                  return AuthenticationInfo.DOING_AUTH;
              }
                
          }

    return null;
  }
  
  public boolean requestCredentials(HttpServletRequest request, HttpServletResponse response)
    throws IOException
  {

      this.log.debug("requestAuthentication: Not authenticating here because login form is disabled and cq.authhandler.dologin request attribute is not set");
      return false;
  }

  public void dropCredentials(HttpServletRequest request, HttpServletResponse response)
    throws IOException
  {
  }

  @Activate
  protected void activate(ComponentContext componentContext)
  {
    configure(componentContext.getProperties());
  }

  protected void configure(Dictionary<?, ?> properties) {

    this.idpEndPoint = OsgiUtil.toString(properties.get("idpEndPoint"), "");
    this.samlConsumerURL = OsgiUtil.toString(properties.get("samlConsumerURL"), "");
    this.protectedDomains = OsgiUtil.toString(properties.get("protectedDomains"), "");
    this.protectedDomainsList=new ArrayList();
    StringTokenizer strToken = new StringTokenizer(this.protectedDomains, "|");
    while (strToken.hasMoreElements()) {
      this.protectedDomainsList.add((String) strToken.nextElement());
    }
    
    this.publicKeyFilePath = OsgiUtil.toString(properties.get("publicKeyFilePath"), "");
    this.trustedCredentialsAttribute="TrustedInfo";
    this.renderid= OsgiUtil.toString(properties.get("renderId"), "");
  }

  protected AuthenticationInfo createAuthenticationInfoOLD(String userid)
  {
        
        SimpleCredentials credentials = new SimpleCredentials(userid, "no_password_needed".toCharArray());
        credentials.setAttribute(this.trustedCredentialsAttribute, "true");// per documentation, CRX checks only the presence of attribute. Value is not important.
        AuthenticationInfo info = new AuthenticationInfo("SSO");
        info.put("user.jcr.credentials", credentials);
        return info;
  }

  protected AuthenticationInfo createAuthenticationInfo(HttpServletRequest request, HttpServletResponse response,String userid)
  {


        try {
          return TokenUtil.createCredentials(request, response, this.repository, userid, true);
        }catch (RepositoryException e) {
          this.log.error("Unable to create token credentials for user ID {}", userid, e);
        }
      return null;
  }
  
  /*
   * Here is where the actual ADFS/SAML checking is done.
   */
  private AuthenticationInfo checkSsoAdfs(HttpServletRequest request, HttpServletResponse response){
    // get the saml response parameter from the request.
     
    //debugHeaders(request);
    String userid="";

    Authorizable authorizable = null;

    Session adminSession = null;
    
    String samlResponse = request.getParameter("SAMLResponse");
        //log.error("SAML Response: " + samlResponse);
        
        // check if the SAML response parameter is not present in the request
        if(samlResponse == null) {
            sendForAuthentication(request,response,false);
            return null;
        }

        // validate the token and retrieve the user ID.
        StatusResponse SAMLResponse = null;

        try {
            //return null;
            SAMLResponse = (new SAMLResponseProcessor()).getStatusResponse(samlResponse, this.publicKeyFilePath);

            if(SAMLResponse.getUserId().equals("LOGOUT")){
                sendForAuthentication(request,response,true);
                return null;
            }
            
            userid=SAMLResponse.getUserId().toLowerCase();
            //Triggerable debug
            if(request.getParameter("RelayState")!=null && request.getParameter("RelayState").contains("gasdebug")){
               
               log.info("SAML ID:"+userid);
               HashMap attrs=SAMLResponse.getAttributeData();
               Iterator iterAttrs=attrs.keySet().iterator();
               while(iterAttrs.hasNext()){
                    String key=(String)iterAttrs.next();
                    log.info(userid+":SAML attr:"+key+":"+(String)attrs.get(key));
               }
            }

        } catch (Exception e){

            log.error("Error in getting authenticated User id from SAML token. " + e.getMessage());
            e.printStackTrace();

            // return null so that CQ prompts the user with basic auth
            return null;
        } 

        // create the Credentials Object
        
        //set SSO cookie
        response.reset();
        //log.error("adding user session");
        //added Page Freezer IDs (pf00..) 7-12-13 ECW

          if((userid.startsWith("e") && (userid.length()==8 || userid.length()==7)) || userid.contains("netcool") ||  userid.startsWith("pf00")){
            try{

            SAMLUserSession usersession=SAMLSessionManager.getInstance().addUserSession(response, SAMLResponse, renderid);
			adminSession = this.repository.loginService("", null);
            //adminSession = this.repository.loginService(null);
			authorizable = createOrUpdateCRXUser(adminSession, usersession, "");

            if(usersession!=null){        
                userid=usersession.getSamlUser().getUserid();
                log.debug("authenticated user ID: " + userid);
                AuthenticationInfo authinfo=createAuthenticationInfo(request,response,userid);
                return authinfo;
            }

            }catch(RepositoryException e){
                this.log.error("User synchronization failed: Could not access repository.", e);
                return AuthenticationInfo.FAIL_AUTH;
            }finally{
              if (null != adminSession)
              adminSession.logout();
            }


        }

        
        log.error("Invalid user id:"+userid);
        try{
            response.setContentType("text/html");
            PrintWriter out=response.getWriter();
            //out.println("To access this application you must login with a valid McDonald's eID.<br><br>");
            //out.println("Please close your browser and login again.");
            
            out.println("To access this application you must login with a valid McDonald's eID.<br><br>");
            out.println("<b>Please close your browser and login again.</b>");
            if(SAMLResponse!=null){
                out.println("<br><br>");
                out.println("ID:"+SAMLResponse.getUserId()+"<br>");
                HashMap attrs=SAMLResponse.getAttributeData();
                Iterator iterAttrs=attrs.keySet().iterator();
                while(iterAttrs.hasNext()){
                  String key=(String)iterAttrs.next();
                  out.println(key+":"+(String)attrs.get(key)+"<br>");
                }
            }
            return null;
        }catch(Exception e){
            return null;
        }
            
      
  }


  private Authorizable createOrUpdateCRXUser(Session adminSession, SAMLUserSession usersession,  String SAMLResponse)
  {
    UserManager um;
    try
    {
      um = ((JackrabbitSession)adminSession).getUserManager();
      SAMLUser user=usersession.getSamlUser();
      String username=user.getUserid();
      Authorizable authorizable = um.getAuthorizable(username);
	  boolean bUpdated=false;
      if ((authorizable == null)) {
        byte[] key = new byte[16];
        try {
          this.cryptoSupport.nextRandomBytes(key);
        }
        catch (CryptoException e) {
          this.log.error("cryptoSupport.nextRandomBytes failed", e);
          new Random().nextBytes(key);
        }
        authorizable = um.createUser(username, org.apache.commons.codec.binary.StringUtils.newStringUtf8(org.apache.commons.codec.binary.Base64.encodeBase64(key)));
		bUpdated=true;

      }
      //update User attributes


      ValueFactory vf = adminSession.getValueFactory();

        if(!authorizable.hasProperty("rep:location") || !(authorizable.getProperty("rep:location")[0]).getString().equals(user.getLocation())){
            authorizable.setProperty("rep:location", vf.createValue(user.getLocation()));
            bUpdated=true;
        }
        if(!authorizable.hasProperty("rep:e-mail") || !(authorizable.getProperty("rep:e-mail")[0]).getString().equals(user.getMail())){
            authorizable.setProperty("rep:e-mail", vf.createValue(user.getMail()));
            bUpdated=true;
        }
        if(!authorizable.hasProperty("rep:role") || !(authorizable.getProperty("rep:role")[0]).getString().equals(user.getRole())){
            authorizable.setProperty("rep:role", vf.createValue(user.getRole()));
            bUpdated=true;
        }
        if(!authorizable.hasProperty("givenName") || !(authorizable.getProperty("givenName")[0]).getString().equals(user.getFirstname())){
            authorizable.setProperty("givenName", vf.createValue(user.getFirstname()));
            bUpdated=true;
        }
        if(!authorizable.hasProperty("familyName") || !(authorizable.getProperty("familyName")[0]).getString().equals(user.getLastname())){
            authorizable.setProperty("familyName", vf.createValue(user.getLastname()));
            bUpdated=true;
        }
        if(!authorizable.hasProperty("CompanyType") || !(authorizable.getProperty("CompanyType")[0]).getString().equals(user.getCompanytype())){
            authorizable.setProperty("CompanyType", vf.createValue(user.getCompanytype()));
            bUpdated=true;
        }
        if(!authorizable.hasProperty("rep:fullname") || !(authorizable.getProperty("rep:fullname")[0]).getString().equals(user.getFullname())){
            authorizable.setProperty("rep:fullname", vf.createValue(user.getFullname()));
            bUpdated=true;
        }
        String mcdAudience=(new ADMapper()).getInstance().getMcdAudience(user.getCompanytype(), user.getRole());
        if(!authorizable.hasProperty("rep:mcdAudience") || bUpdated){
            authorizable.setProperty("rep:mcdAudience", vf.createValue(mcdAudience));
            bUpdated=true;
        }


        if(bUpdated){

            log.error("assigning user to default group");
            McdLdapLoadRules.assignUserToDefaultGroup(um, authorizable, mcdAudience);
            adminSession.save();
        }


        return authorizable;
    } catch (AccessDeniedException e) {
      this.log.error("User synchronization failed: Could not get user manager.", e);
    } catch (RepositoryException e) {
      this.log.error("User synchronization failed: Could not access repository.", e);
    }
    return null;
  }


  private void sendForAuthentication(HttpServletRequest request, HttpServletResponse response,boolean bUseRequestDomain){
      try{
        // create the SAML 2.0 sign-in request 
        
        String requestURI=request.getRequestURI();
        String qs=request.getQueryString();
        if(qs!=null && !qs.equals(""))requestURI+="?"+qs; 
        
        String requestDomain=request.getRequestURL().toString();
        if(requestDomain.startsWith("https://")){
           requestDomain=requestDomain.substring(8);
        }else{ //http
           requestDomain=requestDomain.substring(7);
        }
        requestDomain=requestDomain.substring(0,requestDomain.indexOf("/"));                 
        if(bUseRequestDomain)requestURI="/accessmcd.html";  
        String samlSignInReq = this.createSAMLRequest(this.idpEndPoint, "https://"+requestDomain+this.samlConsumerURL , "https://"+requestDomain, requestURI);
    
        // redirect the user to Secure Token Service (ADFS 2.0)
        response.sendRedirect(samlSignInReq);
       
        
    }catch(Exception e){
        this.log.error("checkSsoAdfs ERROR: "+e.getMessage());
    }
  }

  private String createSAMLRequest(String idpEndpoint, String consumerUrl, String issuer, String relayState) throws ParseException, UnsupportedEncodingException
  {
    String uniqueID= UUID.randomUUID().toString();

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    Date dateNow = dateFormat.parse(SAMLUtil.getDateAndTime());
    String dateNowStr = dateFormat.format(dateNow);

    String samlRequest = "<?xml version=\"1.0\" encoding=\"utf-8\"?><samlp:AuthnRequest ID=\"_" + uniqueID+ "\" Version=\"2.0\" IssueInstant=\"" + dateNowStr + "\" Destination=\"" + idpEndpoint + "\" ForceAuthn=\"false\" IsPassive=\"false\" ProtocolBinding=\"urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST\" AssertionConsumerServiceURL=\"" + consumerUrl + "?binding=urn%3aoasis%3anames%3atc%3aSAML%3a2.0%3abindings%3aHTTP-POST\" xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\">  <saml:Issuer xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\">" + issuer + "</saml:Issuer><samlp:NameIDPolicy AllowCreate=\"true\" /></samlp:AuthnRequest>";
    //log.info("samlRequest:"+samlRequest);
    byte[] xmlBytes = samlRequest.getBytes("UTF-8");
    Deflater deflater = new Deflater(9, true);
    deflater.setInput(xmlBytes);
    deflater.finish();
    byte[] output = new byte[xmlBytes.length];
    int length = deflater.deflate(output);

    byte[] finalOutput = new byte[length];
    System.arraycopy(output, 0, finalOutput, 0, length);

    byte[] base64encodedByteArray = Base64.encodeBase64(finalOutput);
    String base64encoded = new String(base64encodedByteArray);

    String urlEncoded = URLEncoder.encode(base64encoded, "UTF-8");
    
    String relayStateEncoded = URLEncoder.encode(relayState, "UTF-8");

    String request = idpEndpoint + "?binding=urn%3aoasis%3anames%3atc%3aSAML%3a2.0%3abindings%3aHTTP-Redirect&SAMLRequest=" + urlEncoded + "&RelayState=" + relayStateEncoded;

    return request;
  }


 private String[] getConfigValues(Dictionary<?, ?> properties, String propName) {
    String[] values = OsgiUtil.toStringArray(properties.get(propName));
    if ((values != null) && (values.length == 1) && (values[0].trim().length() == 0))
      values = null;

    return values;
  }
  
   protected String getLoginPage(HttpServletRequest request)
  {
    return null;
  }

  protected String getRealm(HttpServletRequest request)
  {
    return null;
  }

  public String toString()
  {
    return "MCD ADFS Authentication Handler";
  }
  
  private void debugHeaders(HttpServletRequest request){
    log.error("parameters");
    Enumeration en = request.getParameterNames();
    
    while (en.hasMoreElements()) {
            
            String paramName = (String) en.nextElement();
            log.error(paramName + " = " + request.getParameter(paramName) + "<br/>");
            
        }
    
    log.error("headers");
    Enumeration headerNames = request.getHeaderNames();
    while(headerNames.hasMoreElements()) {
      String headerName = (String)headerNames.nextElement();
      log.error(""+headerName+":" + request.getHeader(headerName));
    }
  }
 
  public String getPublicKeyFilePath(){
     return this.publicKeyFilePath;
  }

    protected void bindRepository(SlingRepository paramSlingRepository)
  {
    this.repository = paramSlingRepository;
  }

  protected void unbindRepository(SlingRepository paramSlingRepository)
  {
    if (this.repository == paramSlingRepository)
      this.repository = null;
  }

  public void authenticationFailed(HttpServletRequest request, HttpServletResponse response, AuthenticationInfo authInfo)
  {
    //clearRequestPathCookie(request, response);
  }

  public boolean authenticationSucceeded(HttpServletRequest request, HttpServletResponse response, AuthenticationInfo authInfo)
  {
    if (request.getPathInfo().endsWith("/samlredirect")) {
      try {

		  log.info("authenticationSucceeded");	
          String relayState=request.getParameter("RelayState");
          
          if(relayState==null)relayState="/";

        response.sendRedirect(relayState);
      } catch (IOException e) {
        this.log.error("Could not read request.", e);
        return false;
      }
      return true;
    }
    return DefaultAuthenticationFeedbackHandler.handleRedirect(request, response);
  }

  protected void bindCryptoSupport(CryptoSupport paramCryptoSupport)
  {
    this.cryptoSupport = paramCryptoSupport;
  }

  protected void unbindCryptoSupport(CryptoSupport paramCryptoSupport)
  {
    if (this.cryptoSupport == paramCryptoSupport)
      this.cryptoSupport = null;
  }


}  