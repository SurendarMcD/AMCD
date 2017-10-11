package com.mcd.cq.auth.impl;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

import java.util.Date;
import java.util.Iterator;
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
    paths = {"/mcd/cq/util/samlredirect"},
    methods = {"GET","POST"}
)

@Properties({
    @Property(name = "service.description", value = "SAML Redirect Servlet"),
    @Property(name = "service.vendor", value = "MCD"),
    @Property(name = "service.pid", value = "com.mcd.cq.auth.impl.MCDSamlRedirectServlet")
})



@SuppressWarnings("serial")

/* SAML Redirect Servlet
* Servlet to redirect user to originally requested resource
* after SAML authentication.  Orginal destination is passed in 
* RelayState parameter
*
* Erik Wannebo 7-29-2011
*/ 

public class MCDSamlRedirectServlet extends SlingAllMethodsServlet {

    
    private static final Logger log = LoggerFactory.getLogger(MCDSamlRedirectServlet.class);

    @Override

    protected void doGet(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
           
            String relayState=request.getParameter("RelayState");
            
            if(relayState==null)relayState="/";

            //log.error("SAML Redirect Servlet relaystate:"+relayState);

            //response.reset();
            if(relayState.equals("/"))relayState="/libs/cq/core/content/welcome.html";
            response.sendRedirect(relayState);
            //PrintWriter out=response.getWriter();
            //out.println("relayState:"+relayState);
            
            //if (!(response.isCommitted()))
           //  {
             /* response.reset();
              response.setStatus(301);
              response.setHeader( "Location", relayState );
              response.setHeader( "Connection", "close" );
              response.flushBuffer();
            */  
            /*
            response.setContentType("text/html");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-control", "no-cache");
            response.addHeader("Cache-control", "no-store");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            Writer w = response.getWriter();
            w.write("<html><head><script type=\"text/javascript\">");
            w.write("var u=\"");
            w.write(test);
            w.write("?relayState=");
            w.write(relayState );
            w.write("\"; if ( window.location.hash) {");
            w.write("u = u + window.location.hash;");
            w.write("} document.location = u;");
            w.write("</script></head><body>");
            w.write("<!-- QUICKSTART_HOMEPAGE - (string used for readyness detection, do not remove) -->");
            w.write("</body></html>");

            response.flushBuffer();
            */
           // }
      


    }

    @Override

    protected void doPost(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            this.doGet(request,response);

    }
     
     
    
    
}