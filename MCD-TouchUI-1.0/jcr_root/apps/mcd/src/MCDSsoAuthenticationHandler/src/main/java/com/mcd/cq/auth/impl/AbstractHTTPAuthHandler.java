package com.mcd.cq.auth.impl;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Dictionary;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.codec.binary.Base64;
import org.apache.sling.auth.core.spi.AuthenticationHandler;
import org.apache.sling.auth.core.spi.AuthenticationInfo;
import org.apache.sling.commons.osgi.OsgiUtil;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory; 

abstract class AbstractHTTPAuthHandler
  implements AuthenticationHandler
{
  private static final String NO_LOGIN_FORM = "auth.http.nologin";
  private static final boolean DEFAULT_NO_LOGIN_FORM = false;
  protected static final String REALM = "auth.http.realm";
  protected static final String DEFAULT_REALM = "Day Communique 5";
  static final String REQUEST_LOGIN_PARAMETER = "sling:authRequestLogin";
  private static final String HEADER_WWW_AUTHENTICATE = "WWW-Authenticate";
  private static final String HEADER_AUTHORIZATION = "Authorization";
  private static final String AUTHENTICATION_SCHEME_BASIC = "Basic";
  private static final String DEFAULT_DEFAULT_LOGIN_PAGE = "/libs/cq/core/content/login.html";
  private static final String PROP_DEFAULT_LOGIN_PAGE = "auth.default.loginpage";
  private static final String PROP_FORM_LOGIN = "auth.cred.form";
  private static final String[] DEFAULT_FORM_LOGIN = { "Firefox", "Shiretoko", "MSIE 7", "MSIE 6" };
  private static final String PROP_UTF8_CREDENTIALS = "auth.cred.utf8";
  private static final String[] DEFAULT_UTF8_CREDENTIALS = { "Firefox", "Shiretoko", "Chrome", "Opera", "curl", "Wget" };
  static final String LOGIN_FORCED_FLAG = "cq.authhandler.dologin";
  private final Logger log;
  private boolean noLoginForm;
  private String realm;
  private String defaultLoginPage;
  private String[] formSupportingUserAgents;
  private String[] utf8EncodingUserAgents;

  AbstractHTTPAuthHandler()
  {
    this.log = LoggerFactory.getLogger(super.getClass());
  }

  public AuthenticationInfo extractCredentials(HttpServletRequest request, HttpServletResponse response)
  {
    AuthenticationInfo info = extractAuthentication(request);
    if (info != null) {
      return info;
    }

    if (forceAuthentication(request, response)) {
      return AuthenticationInfo.DOING_AUTH;
    }

    return null;
  }

  public boolean requestCredentials(HttpServletRequest request, HttpServletResponse response)
    throws IOException
  {
    if (!(response.isCommitted()))
    {
      response.reset();

      if (request.getParameter("sling:authRequestLogin") != null)
      {
        response.sendError(403);
        response.flushBuffer();
        return true;
      }
      if (doLoginForm(request))
      {
        if (isLoginFormClient(request))
        {
          String lpMessage;
          String loginPage = getLoginPage(request);
          if (loginPage == null) {
            loginPage = getDefaultLoginPage();
            lpMessage = "requestAuthentication: Using default login page ({})";
          } else {
            lpMessage = "requestAuthentication: Using login page: {}";
          }

          if (isLoginFormLoop(request, loginPage))
          {
            this.log.warn("requestAuthentication: Authentication loop detected, sending 401/UNAUTHENICATED to force browser based authentication");
            this.log.warn("requestAuthentication: Authentication loop reason: Wrong login page configuration or credentials not accepted for login");
            sendUnauthorized(request, response);
          }
          else
          {
            String rMessage;
            if ((request.getContextPath() != null) && (!(loginPage.startsWith(request.getContextPath()))))
            {
              loginPage = request.getContextPath() + loginPage;
            }

            String resource = request.getParameter("resource");
            if (resource == null) {
              resource = request.getRequestURI();
              rMessage = "requestAuthentication: Using current request as post-login target: {}";
            } else {
              rMessage = "requestAuthentication: Reusing post-login target from request parameter: {}";
            }

            if (this.log.isDebugEnabled()) {
              this.log.debug(lpMessage, loginPage);
              this.log.debug(rMessage, resource);
            }

            response.setContentType("text/html");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-control", "no-cache");
            response.addHeader("Cache-control", "no-store");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            Writer w = response.getWriter();
            w.write("<html><head><script type=\"text/javascript\">");
            w.write("var u=\"");
            w.write(loginPage);
            w.write("?resource=");
            w.write(resource);
            w.write("\"; if ( window.location.hash) {");
            w.write("u = u + window.location.hash;");
            w.write("} document.location = u;");
            w.write("</script></head><body>");
            w.write("<!-- QUICKSTART_HOMEPAGE - (string used for readyness detection, do not remove) -->");
            w.write("</body></html>");

            response.flushBuffer();
          }

          return true;
        }
        sendUnauthorized(request, response);
        return true;
      }

      this.log.debug("requestAuthentication: Not authenticating here because login form is disabled and cq.authhandler.dologin request attribute is not set");

      return false;
    }

    this.log.error("requestAuthentication: Response is committed, cannot request authentication");

    return true;
  }

  public void dropCredentials(HttpServletRequest request, HttpServletResponse response)
    throws IOException
  {
  }

  protected final String getDefaultLoginPage()
  {
    return this.defaultLoginPage;
  }

  protected abstract String getLoginPage(HttpServletRequest paramHttpServletRequest);

  protected abstract String getRealm(HttpServletRequest paramHttpServletRequest);

  protected void activate(ComponentContext componentContext)
  {
    configure(componentContext.getProperties());
  }

  protected void configure(Dictionary<?, ?> properties) {
    this.noLoginForm = OsgiUtil.toBoolean(properties.get("auth.http.nologin"), false);

    this.realm = OsgiUtil.toString(properties.get("auth.http.realm"), "Day Communique 5");
    this.defaultLoginPage = OsgiUtil.toString(properties.get("auth.default.loginpage"), "/libs/cq/core/content/login.html");

    this.formSupportingUserAgents = OsgiUtil.toStringArray(properties.get("auth.cred.form"), DEFAULT_FORM_LOGIN);

    this.utf8EncodingUserAgents = OsgiUtil.toStringArray(properties.get("auth.cred.utf8"), DEFAULT_UTF8_CREDENTIALS);

    this.log.debug("configure: realm='{}', loginPage='{}'", this.realm, this.defaultLoginPage);
  }

  protected AuthenticationInfo extractAuthentication(HttpServletRequest request)
  {
    String decoded;
    String user;
    char[] password;
    String authHeader = request.getHeader("Authorization");
    if ((((authHeader == null) || (authHeader.length() == 0))) && ((
      (authHeader == null) || (authHeader.length() == 0)))) {
      return null;
    }

    authHeader = authHeader.trim();
    int blank = authHeader.indexOf(32);
    if (blank <= 0)
      return null;

    String authType = authHeader.substring(0, blank);
    String authInfo = authHeader.substring(blank).trim();

    if (!(authType.equalsIgnoreCase("Basic"))) {
      return null;
    }

    try
    {
      byte[] encoded = authInfo.getBytes("ISO-8859-1");
      byte[] bytes = Base64.decodeBase64(encoded);
      decoded = new String(bytes, getCredentialsEncoding(request));
    }
    catch (UnsupportedEncodingException uee) {
      this.log.error("extractAuthentication: Cannot en/decode authentication info", uee);

      return null;
    }

    int colIdx = decoded.indexOf(58);
    if (colIdx < 0) {
      user = decoded;
      password = new char[0];
    } else {
      user = decoded.substring(0, colIdx);
      password = decoded.substring(colIdx + 1).toCharArray();
    }

    return new AuthenticationInfo("BASIC", user, password);
  }

  private boolean forceAuthentication(HttpServletRequest request, HttpServletResponse response)
  {
    boolean authenticationForced = false;

    if (request.getParameter("sling:authRequestLogin") != null)
    {
      if (!(response.isCommitted()))
      {
        authenticationForced = sendUnauthorized(request, response);
      }
      else
      {
        this.log.error("forceAuthentication: Response is committed, cannot request authentication");
      }

    }
    else
    {
      this.log.debug("forceAuthentication: Not forcing authentication because request parameter {} is not set", "sling:authRequestLogin");
    }

    return authenticationForced;
  }

  private boolean sendUnauthorized(HttpServletRequest request, HttpServletResponse response)
  {
    if (response.isCommitted()) {
      this.log.debug("sendUnauthorized: Response committed, cannot send 401/UNAUTHORIZED");
      return false;
    }

    String realm = getRealm(request);
    if (realm == null) {
      realm = this.realm;
    }

    response.reset();

    response.setStatus(401);
    response.setHeader("WWW-Authenticate", "Basic realm=\"" + realm + "\"");
    try
    {
      response.flushBuffer();
      return true;
    } catch (IOException ioe) {
      this.log.error("sendUnauthorized: Failed requesting authentication", ioe);
    }

    return false;
  }

  protected boolean doLoginForm(HttpServletRequest request)
  {
    if (request.getAttribute("cq.authhandler.dologin") != null) {
      return true;
    }

    return (!(this.noLoginForm));
  }

  protected boolean isLoginFormClient(HttpServletRequest request)
  {
    String userAgent = request.getHeader("User-Agent");
    if (userAgentMatch(userAgent, this.formSupportingUserAgents)) {
      this.log.debug("isLoginFormClient: Client ({}) assumed to support form based authentication", userAgent);

      return true;
    }

    this.log.debug("isLoginFormClient: Client ({}) assumed to not support form based authentication, sending 401/UNAUTHORIZED", userAgent);

    return false;
  }

  private boolean isLoginFormLoop(HttpServletRequest request, String loginPage)
  {
    String ctxPath = request.getContextPath();
    String loginUri = ((ctxPath == null) || (ctxPath.length() == 0)) ? loginPage : ctxPath.concat(loginPage);

    if (request.getRequestURI().equals(loginUri)) {
      return true;
    }

    String referer = request.getHeader("Referer");
    if (referer != null)
      try {
        URI refererUri = new URI(referer);
        return loginUri.equals(refererUri.getPath());
      }
      catch (URISyntaxException e)
      {
      }


    return false;
  }

  private String getCredentialsEncoding(HttpServletRequest request)
  {
    String userAgent = request.getHeader("User-Agent");
    if (userAgentMatch(userAgent, this.utf8EncodingUserAgents)) {
      this.log.debug("getCredentialsEncoding: User-Agent ({}) indicates UTF-8 encoding browser, using UTF-8", userAgent);

      return "UTF-8";
    }

    this.log.debug("getCredentialsEncoding: User-Agent ({}) indicates non-UTF-8 encoding browser, using ISO-8859-1", userAgent);

    return "ISO-8859-1";
  }

  private boolean userAgentMatch(String userAgent, String[] options) {
    String[] arr$;
    int i$;
    if ((userAgent != null) && (options.length > 0)) {
      arr$ = options; int len$ = arr$.length; for (i$ = 0; i$ < len$; ++i$) { String option = arr$[i$];
        if (userAgent.contains(option))
          return true;
      }

    }

    return false;
  }
}