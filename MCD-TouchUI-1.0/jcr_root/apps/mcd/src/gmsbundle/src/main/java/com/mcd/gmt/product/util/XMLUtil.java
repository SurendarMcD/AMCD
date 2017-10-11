/****************************************************
 * Copyright (C) 2010 McDoanld's, Corp. All Rights Reserved.
 *
 * XMLUtil.java - for xml transformations
 *
 * Change Log: 
 * ----------------------------------------------
 *    Date        Name                  Description
 * ----------------------------------------------
 *    14/06/10     Sandeep Maheshwari   Created
 ****************************************************/
package com.mcd.gmt.product.util;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.day.cq.contentbus.Ticket;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory; 
import com.mcd.gmt.product.cq.impl.ProductService;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Templates;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;


public class XMLUtil {
    
    private static final Logger log = LoggerFactory.getLogger(XMLUtil.class);

    
    
    
    private Transformer transformer = null;
    private HashMap parameters = new HashMap();
    
    /**
     * Method convert xml document to xml string 
     * 
     * @param doc
     * @return xml string
     */     
    public String convertXMLToString(Document doc)
    {
        String xmlString = "";
        try {
         Transformer transformer = TransformerFactory.newInstance().newTransformer();
         transformer.setOutputProperty(OutputKeys.INDENT, "yes");
         StreamResult result = new StreamResult(new StringWriter());
         DOMSource source = new DOMSource(doc);
         transformer.transform(source, result);
         xmlString = result.getWriter().toString();
        } catch (TransformerConfigurationException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (TransformerFactoryConfigurationError e) {
            e.printStackTrace();
        } catch (TransformerException e) {
            e.printStackTrace();
        }
        return xmlString;
    }
    
    
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
    * Sets XSL Parameter as Object.
    * @param key Key
    * @param value Object value
    */
    public  final void setXSLParameter(String key, Object value){
        parameters.put(key, value);
    }
    
    
    
    /**
    * Method to transform the XML from the document object to the string 
    * @param document, xslt path, ticket object 
    * @retun String 
    */
    
    public String transformedXML(Document xmlDoc, String XSLSource, Ticket ticket)
        {
        String transformedXML = "";     
        java.io.Writer writer = new StringWriter();   
        String xsltFile =XSLSource;

        try{

            DocumentBuilder docBldr = DocumentBuilderFactory.newInstance().newDocumentBuilder();            
            DocumentBuilderFactory docfactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = docfactory.newDocumentBuilder();
            StreamResult result = new StreamResult(writer);         
            DOMSource xml = new DOMSource(xmlDoc);

            TransformerFactory factory = TransformerFactory.newInstance();
            Templates template = factory.newTemplates(new StreamSource(ticket.createInputStream(xsltFile), "UTF-8") );                                  
            transformer = template.newTransformer();
            setParameters(transformer);
            transformer.transform(xml, result);                       
            transformedXML = result.getWriter().toString();         

        }
        catch(Exception e){
            log.error("[XMLUtily.class )] Exception:"+e.getMessage());
        }       
        return transformedXML;
    }
    
    
    /**
    * Method to convert the string object as document object 
    * @param String 
    * @retun Document object
    */
    
    
    public Document getXMLDocument(String xmlContent)
    {
        Document xmlDoc = null;
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        try
        {
            DocumentBuilder builder = factory.newDocumentBuilder();
            String xmlString = xmlContent;          
            xmlDoc = builder.parse(new InputSource(new StringReader(xmlString)));
        }
        catch(SAXException spe)
        {
            
            log.error("GETTING XML DOCUMENT SAX PARSE ERROR!!!!!!!!!!!!!!!!");
            spe.printStackTrace();
            return null;
        }
        catch(ParserConfigurationException pce)
        {
            pce.printStackTrace();
            xmlDoc = null;
        }
        catch(Exception ioe)
        {
            
            ioe.printStackTrace();
            xmlDoc = null;
        }
        return xmlDoc;
    }
    
    
    
    
    /**
     * New Method to generate the HTML string from the xml & from the xslt with Audientype.
     *  
     * @return string
     * @param String xmlcontent,xslt path,ticket object,Page object,qualident,sort type,theme name, audiencetype  
     * 
     */
    
    
    public  String generateHTMLString(Document xmlContent,String XSLSource,Ticket ticket)
    {
        // Declaring all the variables //
    
    String transformedXML="";
    Document xmlData;
            
    // calling the getXMLDocument method to convert the string data into document object //
    xmlData=xmlContent;
    //calling the method to transfiorm the xml with xslt // 
    transformedXML=transformedXML(xmlData,XSLSource,ticket);
            
    
    return transformedXML;
    }
    
} 
     
    
    
    

