package com.mcd.accessmcd.common.helper;

import java.io.*;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.jcr.Session;
import org.w3c.dom.Document;
import org.slf4j.Logger; 
import org.slf4j.LoggerFactory;
import org.apache.sling.jcr.api.SlingRepository;
import java.util.*;
import com.day.cq.wcm.api.Page;
import com.mcd.util.PropertiesLoader;   
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.jcr.api.SlingRepository;
import javax.jcr.Session;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;

import  javax.jcr.Binary; 
import  javax.jcr.Node;
import  javax.jcr.Session;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.api.scripting.SlingScriptHelper;

/**
 * This class is used for tranforming XML & XSLT
 *
 * @author HCL
 * @version 1.0
 *
 */
public class XMLHelper {
    private static final Logger log;
    
    static  
    {
        log = LoggerFactory.getLogger(XMLHelper.class);
    }
    private SlingRepository repository;
     private JcrResourceResolverFactory resolverFactory;
     private static Session session = null;
    // code to declare the variables // 
    private Transformer transformer = null;
    private HashMap parameters = new HashMap();

    /**
    * Method set the value values on xslt form dialog.
    *   
    * @return void
    * @param Transformer object
    * 
    */
    private void setParameters(Transformer transformer){
        for (Iterator iter = parameters.entrySet().iterator();iter.hasNext();){
            Map.Entry entry = (Map.Entry) iter.next();
            String key = (String) entry.getKey();
            Object value = entry.getValue();
            if (value != null)
            transformer.setParameter(key, value);
        }
    }
    
    
    /**
     * Method to generate the HTML string from the xml & from the xslt.
     *  
     * @return string
     * @param Document xmlcontent,xslt path,ticket object,Page object,qualident,sort type,theme name  
     * 
     */        
    public String generateHTMLString(Document xmlContent,String XSLSource, Page page, ValueMap properties,String sortType,String themeName,SlingScriptHelper sling)
    { 
    
        String transformedXML="";
        Document xmlData;
        String viewAllBtn="";
        String viewAllURL="";
        String resultCount="";
        String helpLink="";
        String helpHeight="";
        String helpWidth="";
        String helpIframeBorder="";
        String helpIframeScroll="";
        String returnBtnName="";
        String returnBtnUrl="";
        String alphaBtnName="";
        String chronoBtnName="";
        String pageTitle="";
        String alphaBtnUrl = page.getPath()+".html?sort=alpha";

        
        String chrornoBtnUrl = page.getPath()+".html?sort=chrono";

         
        String pageName = page.getPath();
        String themeVal=themeName;
        String sortTypeVal=sortType; 
         
         
        // retriving the values from the Page Atoms //
         
        try
        {
                
        // calling the getXMLDocument method to convert the string data into document object //
        
        xmlData=xmlContent;
        
       
        //  setting the values on xslt //       
        
        if(viewAllBtn!="")
        {
        setXSLParameter("viewAllBtnName",viewAllBtn);
        }
        if(viewAllURL!="")
        {
        setXSLParameter("viewAllUrl",viewAllURL);
        }
        if(resultCount!="")
        {
        setXSLParameter("resultCount",resultCount);
        }
        if(helpLink!="")
        {
        setXSLParameter("helpLink",helpLink);
        }
        if(helpHeight!="")
        {
        setXSLParameter("helpHeight",helpHeight);
        }
        if(helpWidth!="")
        {
        setXSLParameter("helpWidth",helpWidth);
        }
        if(helpIframeBorder!="")
        {
        setXSLParameter("helpIframeBorder",helpIframeBorder);
        }
        if(helpIframeScroll!="")
        {
        setXSLParameter("helpIframeScroll",helpIframeScroll);
        }
        if(returnBtnName!="")
        {
        setXSLParameter("returnBtnName",returnBtnName);
        }
        if(returnBtnUrl!="")
        {
        setXSLParameter("returnBtnUrl",returnBtnUrl);
        }
        if(alphaBtnName!="")
        {
        setXSLParameter("alphaBtnName",alphaBtnName); 
        }
        if(pageTitle!="")
        {
        setXSLParameter("pageTitle",pageTitle);
        }
        if(chronoBtnName!="")
        {
        setXSLParameter("chronoBtnName",chronoBtnName);
        }
        if(null==sortTypeVal)
        {
            sortTypeVal="";
            setXSLParameter("sortTypeVal",sortTypeVal);
        }else{
        setXSLParameter("sortTypeVal",sortTypeVal);
        }
            
        setXSLParameter("alphaBtnUrl",alphaBtnUrl);
        setXSLParameter("chrornoBtnUrl",chrornoBtnUrl);
        setXSLParameter("pageName",pageName);
        setXSLParameter("themeVal",themeVal);
      
        //calling the method to transfiorm the xml with xslt // 
        transformedXML=transformedXML(xmlData,XSLSource,sling);
      
        }
        catch(Exception e) 
        {
            log.error("Exception XMLHelper:"+ e.getMessage());
            
        }
        return transformedXML; 
        
    } 
    
public String transformedXML(Document xmlDoc, String XSLSource,SlingScriptHelper sling)
        {
        String transformedXML = "";     
        java.io.Writer writer = new StringWriter();   
        String xsltFilePath =XSLSource; 


        final ClassLoader oldLoader =   Thread.currentThread().getContextClassLoader();
        try{
        
       
            Thread.currentThread().setContextClassLoader(javax.xml.transform.TransformerFactory.class.getClassLoader());
            StreamResult result = new StreamResult(writer);         
            DOMSource xml = new DOMSource(xmlDoc);
        
        
    
    
            TransformerFactory factory = TransformerFactory.newInstance();
    
            
  
               
              Session session=null;
             
              SlingRepository repos=null;

              repos= sling.getService(SlingRepository.class); 
 
              session=repos.loginAdministrative(null); 

              Binary b = null;

              InputStream is = null;
                     
              Node node = session.getNode(xsltFilePath);
              Node contentNode = node.getNode("jcr:content/renditions/original/jcr:content");
                
               

              b = contentNode.getProperty("jcr:data").getBinary();

             is = b.getStream();

            
            StreamSource strSource = new StreamSource(is);
            //

            Templates template = factory.newTemplates(strSource); 
    
           
            transformer = template.newTransformer();
            
            //setParameters(transformer);

         
            transformer.transform(xml, result);

           
           transformedXML = result.getWriter().toString(); 
         
        session.logout();
        }
        catch(Exception e){
            log.error("[com.mcd.mcdexchange.rss.utility.XMLUtil().TransformedXMLCommand()] Exception:"+e.getMessage());
        }  
        finally {
            
            Thread.currentThread().setContextClassLoader(oldLoader);
            
            }
      
        return transformedXML;  
    }
 
            
            public String transformXML(String xmlString,String xslPath)
            {
            String result="";
            try {  
                StringReader reader = new StringReader(xmlString);
                StringWriter writer = new StringWriter();
                TransformerFactory tFactory = TransformerFactory.newInstance();
                Transformer transformer = tFactory.newTransformer( new javax.xml.transform.stream.StreamSource(xslPath));
                transformer.transform( new javax.xml.transform.stream.StreamSource(reader), new javax.xml.transform.stream.StreamResult(writer));
                result = writer.toString(); 
                
                }
                catch (Exception e)
                { 
                  log.error("Error transforming XML"); 
                  log.error(e.getMessage()); 
                } 
                return result;
                }
    /**
    * Sets XSL Parameter as Object.
    * @param key Key 
    * @param value Object value
    */
    public final void setXSLParameter(String key, Object value){
        parameters.put(key, value);
    } 
    
} 