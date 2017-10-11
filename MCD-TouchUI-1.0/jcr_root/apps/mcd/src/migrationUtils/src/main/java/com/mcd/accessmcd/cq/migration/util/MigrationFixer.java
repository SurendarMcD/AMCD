package com.mcd.accessmcd.cq.migration.util;

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


import javax.jcr.Session;
import com.day.cq.security.*;
import javax.jcr.Node;
import com.day.cq.commons.jcr.*;   

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
    @Property( name="service.description",value="Migration Fixer"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/cq/util/migration/MigrationFixer"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")


/*
*  Utility servlet for fixing migrations
*  11/3/11 Erik Wannebo
*/

public class MigrationFixer extends SlingAllMethodsServlet {

    @Reference
    private org.apache.sling.jcr.api.SlingRepository repository;  
    
    private static final Logger log = LoggerFactory.getLogger(MigrationFixer.class);

    @Override

    protected void doGet(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            response.setContentType("text/html");

            PrintWriter out = response.getWriter();

            out.println("<h1>Migration Fixer</h1><br><br>");
            Session session = null;
               try {
                   
                   //String loc="/content/accessmcd/na/us/natl/restaurant_ops/rt/pricandpurch/r2d2_2/jcr:content";
                   String loc=request.getParameter("loc");
                   if(loc==null)loc="";
                   out.println("<form  action='' method='POST'>");
                   out.println("<input name='loc' size=100 value='"+loc+"'><br><input type=submit></form>");

                   if(!loc.equals("")){
                   
                       session = repository.loginAdministrative(null);
                       javax.jcr.Node destPage=session.getNode(loc+"/jcr:content");
                       MigrationInfo mi=new MigrationInfo();
                       Util.addInheritedSections(destPage,mi);
                       if(destPage.hasNode("maincontentpara")){
                           javax.jcr.Node mcp=destPage.getNode("maincontentpara");
                           JcrUtil.setProperty(mcp,"sling:resourceType","/apps/mcd/components/content/parsys");
                       }
                       session.save();
                       out.println("Fixed:"+loc);
                   }else{
                       out.println("Enter a page to fix.");
                   }
                   session.logout();
                   session = null;
                }catch(Exception e){
                       out.println("Error:"+e.getMessage());
                }finally{
                  if(session!=null)session.logout();
                }
           
            out.close();

    }



    @Override

    protected void doPost(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            this.doGet(request,response);

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