package com.mcd.test;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;

import org.apache.sling.api.SlingHttpServletRequest;

import org.apache.sling.api.SlingHttpServletResponse;

import org.apache.sling.api.servlets.SlingAllMethodsServlet;

import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.sling.SlingServlet;



/** * @scr.service interface="javax.servlet.Servlet"

 * @scr.component immediate="true" metatype="no"

 * @scr.property name="service.description" value="test bundle building"

 * @scr.property name="service.vendor" value="MCD"
 
 * @scr.property name="sling.servlet.methods" values.0="GET" values.1="POST"
 
 * @scr.property name="sling.servlet.paths" value="/mcd/cq/util/testBuildBundle"


 */
 
 




@SuppressWarnings("serial")


public class mcdTestBuildBundle extends SlingAllMethodsServlet {
    


    @Override

    protected void doGet(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            response.setContentType("text/html");  
            PrintWriter out = response.getWriter();
            out.write("<HTML><BODY><FORM>testbuildbundle</FORM></BODY></HTML>");

    }
    
    @Override

    protected void doPost(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            this.doGet(request,response);

    }
     
    
}