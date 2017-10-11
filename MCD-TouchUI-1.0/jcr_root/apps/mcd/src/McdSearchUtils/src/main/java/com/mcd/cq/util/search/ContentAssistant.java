package com.mcd.cq.util.search;

/*
 * The Ultraseek Content Assistant to retrieve security information, title and description
 * for DAM Assets.
 *
 * Jan 24, 2014 Erik Wannebo
 */

import java.io.DataOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.Date;

import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.mcd.cq.util.search.SearchGroup;

import org.apache.sling.api.SlingHttpServletRequest;

import org.apache.sling.api.SlingHttpServletResponse;

import org.apache.sling.api.servlets.SlingAllMethodsServlet;


import org.apache.sling.jcr.base.util.AccessControlUtil;

import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.auth.*;
import org.apache.commons.httpclient.methods.*;

import javax.jcr.*;
import com.day.cq.security.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.Servlet;
import com.mcd.cq.util.UserAdmin;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="Content Assistant"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/cq/util/search/ContentAssistant"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})


@SuppressWarnings("serial")

/* ContentAssistant
* Servlet to DAM information to Ultraseek Content Assistant Service
* This servlet will 
*
* Erik Wannebo 12-19-2013
*/ 

public class ContentAssistant extends SlingAllMethodsServlet {

    
    @Reference
    private org.apache.sling.jcr.api.SlingRepository repository;
    
   
    private static final Logger log = LoggerFactory.getLogger(ContentAssistant.class);

    @Override

    protected void doGet(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
           

            processContent(request, response);


    }



    @Override

    protected void doPost(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            this.doGet(request,response);

    }
     
      /*
    * Method returns SOAP response for Ultraseek Content Assistant Service
    */  
   protected void processContent(HttpServletRequest req, HttpServletResponse resp){
     //parse XML document
        logMsg("processContent");
        try{
            InputStream in = req.getInputStream();
        StringBuffer sb = new StringBuffer();
        Reader reader = new InputStreamReader(in, "UTF-8");
        int c;
        while ((c = in.read()) != -1) sb.append((char) c);
        
        String document = sb.toString();

        logMsg("document:"+document);
        resp.setContentType("text/xml; charset=utf-8");
       //resp.setHeader("SOAPAction",")
        resp.getOutputStream().println(getSoapResponse(document));
        }catch(Exception e){
            System.err.println("Error parsing request");
            e.printStackTrace();
        }
    }
    
    protected void logMsg(String msg){
        try{
            FileOutputStream outFile = new FileOutputStream("/tmp/MCDContentAssistant.log", true);
            DataOutputStream out   = new DataOutputStream(outFile);
            out.writeBytes(new Date() + ": " +msg+ '\n');
            out.close();
            outFile.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    
    /*
    protected String getSoapResponse1(String document){
        StringBuffer SOAPMsg=new StringBuffer();
        String newTitle="";
        String oldTitle=getTitle(document);
        String url=getUrl(document);
        String pagepath=getPath(url);
        newTitle="NEW TITLE:"+oldTitle;
        SOAPMsg.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        SOAPMsg.append("<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd3=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\">");
        SOAPMsg.append("<SOAP-ENV:Body>");
        SOAPMsg.append("<ns1:GetHdrDescResp xmlns:ns1=\"http://ultraseek.com/contentassist.wsdl\" SOAP-ENC:root=\"1\">");
        SOAPMsg.append("<HdrDescResp>");
        SOAPMsg.append("<title xsi:type=\"xsd:string\">");
        SOAPMsg.append(newTitle);
        SOAPMsg.append("</title>");
        SOAPMsg.append("<url xsi:type=\"xsd:anyURI\">");
        SOAPMsg.append(pagepath);
        SOAPMsg.append("</url>");        
        SOAPMsg.append("</HdrDescResp>");
        SOAPMsg.append("</ns1:GetHdrDescResp>");
        SOAPMsg.append("</SOAP-ENV:Body>");
        SOAPMsg.append("</SOAP-ENV:Envelope>");
        return SOAPMsg.toString();
    }*/
    
        protected String getSoapResponse(String document){
        StringBuffer SOAPMsg=new StringBuffer();
        String newTitle="";
        String newDescription="";
        

        String url=getUrl(document);
        String pagepath=getPath(url);
        
        String abbrevCUGGroup="";
        Session session = null;
        try{
            
            session = repository.loginAdministrative(null);
            String cugGroups=getCUGGroups(pagepath,session); 
            abbrevCUGGroup=SearchGroup.searchGroup(cugGroups);
            if(pagepath.startsWith("/content/dam/")){
                newTitle=getDAMField(pagepath,session,"dc:title");
                newDescription=getDAMField(pagepath,session,"dc:description");
                //newTitle="DAM File";
            }
            
           newTitle = StringEscapeUtils.escapeXml(newTitle);  
           newDescription = StringEscapeUtils.escapeXml(newDescription);
             
        }catch(Exception e){
        }finally{
                  session.logout();
                }

        SOAPMsg.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        SOAPMsg.append("<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd3=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\">");
        SOAPMsg.append("<SOAP-ENV:Body>");
        SOAPMsg.append("<ns1:GetHdrDescResp xmlns:ns1=\"http://ultraseek.com/contentassist.wsdl\" SOAP-ENC:root=\"1\">");
        
        SOAPMsg.append("<IndexAsstDesc>");
        
        //SOAPMsg.append("<ArrayOfDocItem SOAP-ENC:arrayType=\"xsd:SOAPStruct[1]\" xsi:type=\"SOAP-ENC:Array\">");
        
        if(!newTitle.equals("")){
            SOAPMsg.append("<title xsi:type=\"xsd:string\">"+newTitle+"</title>");
            SOAPMsg.append("<description xsi:type=\"xsd:string\">"+newDescription+"</description>");
            SOAPMsg.append("<ArrayOfDocItem SOAP-ENC:arrayType=\"xsd:SOAPStruct[3]\" xsi:type=\"SOAP-ENC:Array\">");
            SOAPMsg.append("<xsd:item>");
            SOAPMsg.append("<field xsi:type=\"xsd:string\">title</field>"); 
            SOAPMsg.append("<text xsi:type=\"xsd:string\">"+newTitle+"</text>");  
            SOAPMsg.append("</xsd:item>");
            SOAPMsg.append("<xsd:item>");
            SOAPMsg.append("<field xsi:type=\"xsd:string\">description</field>"); 
            SOAPMsg.append("<text xsi:type=\"xsd:string\">"+newDescription+"</text>");  
            SOAPMsg.append("</xsd:item>");

        }else{
            SOAPMsg.append("<ArrayOfDocItem SOAP-ENC:arrayType=\"xsd:SOAPStruct[1]\" xsi:type=\"SOAP-ENC:Array\">");
        }
        SOAPMsg.append("<xsd:item>");
        SOAPMsg.append("<field xsi:type=\"xsd:string\">groupsType</field>"); 
        SOAPMsg.append("<text xsi:type=\"xsd:string\">"+abbrevCUGGroup+"</text>");  
        SOAPMsg.append("</xsd:item>");
        
        SOAPMsg.append("</ArrayOfDocItem>");
        SOAPMsg.append("</IndexAsstDesc>");
        SOAPMsg.append("</ns1:GetHdrDescResp>");
        SOAPMsg.append("</SOAP-ENV:Body>");
        SOAPMsg.append("</SOAP-ENV:Envelope>");
        return SOAPMsg.toString();
    }
    
    
    
    
    protected String getPath(String url){
        String path="";
        int start=url.indexOf("/accessmcd/");
        if(url.indexOf("/dam/accessmcd")>-1)
            start=url.indexOf("/dam/accessmcd/");
        if(start>-1){
            path="/content"+url.substring(start);
            if(path.indexOf(".html")>-1){
                path=path.substring(0,path.indexOf(".html"));
            }
        }
        return path;
    }
    
    protected String getTitle(String document){
        String startTag = "<title xsi:type=\"xsd:string\">";
        String endTag = "</title>";
        int start = document.indexOf(startTag) + startTag.length();
        int end = document.indexOf(endTag);
        String result = document.substring(start, end);
        return result;
    }
    
    
    protected String getUrl(String document){
        String startTag = "<url xsi:type=\"xsd3:anyURI\">";
        String endTag = "</url>";
        int start = document.indexOf(startTag) + startTag.length();
        int end = document.indexOf(endTag);
        String result = document.substring(start, end);
        return result;
    }
    
    
    
    
    private String getCUGGroups(String pagepath, Session session){
        Node temp;
        String cug = "";
        
        try{            
            Node currPage= session.getNode(pagepath);
            int depth=currPage.getDepth();
            //cug="depth:"+depth+" ";
            Value[] grpdata;
            
            for(int i =depth-2  ; i > 0; i--)
            {
             //cug+="i:"+i+" ";
             temp = currPage.getParent();
             Node jcrContent=currPage.getNode("jcr:content");
             if(jcrContent!=null){
                 
                 if(jcrContent.hasProperty("cq:cugEnabled") && jcrContent.getProperty("cq:cugEnabled").getValue().getString().equals("true")){
                     if(jcrContent.hasProperty("cq:cugPrincipals") )
                     {
                         try {
                                Value[] multi=jcrContent.getProperty("cq:cugPrincipals").getValues();
                                for (int j=0; j<multi.length; j++) {
                                    cug+= "["+(multi[j]).getString() +"]";         
                                }
                                
                            }catch (ValueFormatException e){
                        
                              cug= "["+ jcrContent.getProperty("cq:cugPrincipals").getValue().getString() +"]"; 
                              
                           }
                           
                     
                     }
                   break;
                  }
                 
              }
              
             currPage=temp;
             }
         }catch(Exception e){
         }
         
         return cug;
 
    }
    
    private String getDAMField(String pagepath, Session session, String field){
        Node temp;
        String ret= "";
        Value[] grpdata;
        try{            
            Node metadata= session.getNode(pagepath+"/jcr:content/metadata");

             if(metadata!=null){
                 if(metadata.hasProperty(field) )
                 {
                 try {
                        Value[] multi=metadata.getProperty(field).getValues();
                        for (int i=0; i<multi.length; i++) {
                            ret+= multi[i].getString();         
                        }
                        
                    }catch (ValueFormatException e){
                
                      ret= metadata.getProperty(field).getValue().getString();
                      
                   }
                 }
              }

         }catch(Exception e){
         }
         
         return ret;
 
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