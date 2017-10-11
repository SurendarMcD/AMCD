package com.tv.servlets;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;



import java.util.*;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;
import org.apache.sling.api.scripting.SlingBindings;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.osgi.service.cm.Configuration;
import org.osgi.service.cm.ConfigurationAdmin;
import java.util.*;
import javax.servlet.http.Cookie;

@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="MOL Login Servlet"),
    @Property( name="service.vendor",value="Truevalue"),
    @Property(name = "sling.servlet.paths", value="/bin/TV/MOLLogin")
})

@SuppressWarnings("serial")


public class MOLLogin extends SlingAllMethodsServlet {

	private static final Logger log = LoggerFactory.getLogger(MOLLogin.class);


	public void doHead(SlingHttpServletRequest request, SlingHttpServletResponse response) throws ServletException,IOException {        
       PrintWriter out = response.getWriter();
		System.out.println("********* MOL Login Servlet Inside DoHead Method ***********");
        log.error("Test MOL Login Do Head");
		String storeGuid = getCookieByName("StoreGuid",request);
        String userGuid = getCookieByName("UserGuid",request);
        if("".equals(userGuid) && "".equals(storeGuid)){
            response.setStatus(SlingHttpServletResponse.SC_UNAUTHORIZED);
        }
        else{
      		response.setStatus(SlingHttpServletResponse.SC_OK);
        }
    }

    protected void doGet(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
        

    }
    
    
    protected void doPost(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
        
        this.doGet(request,response);
        
    }

    private String getCookieByName(String cookieName,SlingHttpServletRequest request){
        Cookie[] cookies = request.getCookies();
        String cookieValue = "";
        if(null != cookies){
            for(int i = 0; i < cookies.length; i++) { 
                Cookie cookie1 = cookies[i];
                if (cookie1.getName().equals(cookieName)) {
                    cookieValue = cookie1.getValue();
                }
            } 
        }
        return cookieValue;
    }

}