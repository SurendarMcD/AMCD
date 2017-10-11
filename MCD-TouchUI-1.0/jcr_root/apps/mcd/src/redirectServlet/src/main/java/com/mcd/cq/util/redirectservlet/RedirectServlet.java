package com.mcd.cq.util.redirectservlet;

import java.io.IOException;

import javax.servlet.ServletException;

import org.apache.sling.api.SlingHttpServletRequest;

import org.apache.sling.api.SlingHttpServletResponse;

import org.apache.sling.api.servlets.SlingAllMethodsServlet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.Servlet;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="Redirect Servlet"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/cq/util/redirect"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")


/* Redirect Servlet
* Servlet to handle custom redirects
*
* Erik Wannebo 4-15-2011
*/ 

public class RedirectServlet extends SlingAllMethodsServlet {
    
    //private static final Logger log = LoggerFactory.getLogger(UserSearchSecurity.class);

    @Override

    protected void doGet(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {

            String redirectUrl=request.getParameter("frameTarget");
            if(redirectUrl==null)redirectUrl="/";

            response.setStatus(301);
            response.setHeader( "Location", redirectUrl);
            response.setHeader( "Connection", "close" );

    }
    
    @Override

    protected void doPost(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            this.doGet(request,response);

    }
     
    
}