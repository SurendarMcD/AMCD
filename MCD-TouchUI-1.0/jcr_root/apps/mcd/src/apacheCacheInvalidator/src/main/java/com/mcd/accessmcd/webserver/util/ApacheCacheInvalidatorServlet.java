package com.mcd.accessmcd.webserver.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.*;


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

@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="Apache Cache Invalidator Servlet"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/cq/util/ApacheCacheInvalidatorServlet"),
    @Property(name = "sling.servlet.methods", value = "GET")
})

@SuppressWarnings("serial")

/*
  ==============================================================================
  Apache Cache Invalidator Servlet
  
  Erik Wannebo 5/31/2012
  ==============================================================================
*/

public class ApacheCacheInvalidatorServlet extends SlingAllMethodsServlet {

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

 private String flushPages(String selectedServer,String[] pagelist){

    String msg="";
    //msg+="pagelist.length:"+pagelist.length;
    String pageToFlush="";  
    ApacheCacheInvalidator cacheInvalidator=new ApacheCacheInvalidator();
    String[] serverlist=new String[2];
    if(selectedServer.equals("www1")){
                serverlist[0]="66.111.151.240:19017";
                serverlist[1]="66.111.151.212:19017";
            }
            if(selectedServer.equals("accessmcd")){
                serverlist[0]="66.111.151.240:19023";
                serverlist[1]="66.111.151.212:19023";
            }
            if(selectedServer.equals("mcsource")){
                serverlist[0]="66.111.151.240:19018";
                serverlist[1]="66.111.151.212:19018";
            }
            if(selectedServer.equals("author")){
                serverlist[0]="66.111.151.240:19016";
                serverlist[1]="66.111.151.212:19016";
            }
            if(selectedServer.equals("stgpublish")){
                serverlist[0]="66.111.147.69:19013";
            }
    for(int ix=0;ix<pagelist.length;ix++){
        pageToFlush="";
        if(pagelist[ix]!=null){
            pageToFlush=pagelist[ix].trim();
            
            msg+="Flushing "+pageToFlush+" on "+selectedServer+"<br>";

            for(int servix=0;servix<serverlist.length;servix++){
                    String server=serverlist[servix];
                    msg+="apachecacheinvalidator:";
                    if(server!=null && !server.equals("")){
                        if(!cacheInvalidator.invalidatePage(server, pageToFlush)){
                            msg+="Couldn't invalidate page in webserver cache. Server: "+server+" Page:" + pageToFlush;
                        }else{
                            msg+="Flushed: "+server+" Page:" + pageToFlush+"<br>";
                        }
                    }           
            }
        }
    }
    return msg;
 }

 public void processForm(SlingHttpServletRequest request, SlingHttpServletResponse response){
    

        try{
            PrintWriter out=response.getWriter(); 
            if(!request.getRemoteUser().equals("admin")){
                out.println("<b><font color=red>You need to login to use this page.</font></b><br>");
                return;
                
             }
         
            String pageFlush=request.getParameter("page");
            String pagesFlush=request.getParameter("pagelist");
            //out.println("pagesFlush:"+pagesFlush);
            String[] pagelist=new String[1];
            String selectedServer=request.getParameter("server");
            if(selectedServer==null)selectedServer="";
            if(pageFlush!=null && !pageFlush.equals("")){
                pagelist[0]=pageFlush.trim();
            }else{
                if(pagesFlush!=null){
                    pagelist=pagesFlush.split("\n");
                    
                }
            }
            
            out.println(flushPages(selectedServer,pagelist));
           
          
            out.println("<h1>Apache Cache Invalidator</h1><br>");
            out.println("This form will flush a page (and any associated elements) from the Apache /htdocs.<br>");
            out.println("<b>It does not remove child pages.</b> However, all pages in a single directory can be removed with a /*<br><br>");
            out.println("<FORM action=\"\" method=\"POST\">");
            out.println("<b>Server:</b>");
            out.println("<select name=\"server\">");
            //STAGING
            //out.println("<option value=\"stgpublish\">www1-int.accessmcd.com</option>");
            
            out.println("<option value=\"author\">author.accessmcd.com</option>");
            out.println("<option value=\"accessmcd\" selected>www.accessmcd.com</option>");
            out.println("<option value=\"mcsource\" selected>mcsource.mcdonalds.com.au</option>");
            out.println("</select>");
            out.println("<br><br>");
            out.println("<b>Page:</b><INPUT size=60 name=\"page\" value=\"/accessmcd/corp\"><br>");
            out.println("<b>Page List:</b><br><TEXTAREA rows=10 cols=80 name=\"pagelist\" value=\"\"></TEXTAREA><br><br>");
            out.println("<INPUT type=submit value=\"FLUSH!\">");
            out.println("</FORM> ");
          
         }catch(Exception e){
         }
      }
 
 }