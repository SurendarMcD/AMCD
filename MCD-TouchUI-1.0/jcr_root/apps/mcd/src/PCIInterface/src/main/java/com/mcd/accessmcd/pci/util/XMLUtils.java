package com.mcd.accessmcd.pci.util;

import java.io.File;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.CDATASection;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.Text;

/**
XML Helper class. <br>

Erik Wannebo 12/30/08
 */ 
public class XMLUtils {
    
    /**
    Returns an XML document from a textfile. <br>
    Used for testing/development only

    Erik Wannebo 12/30/08
     */ 
    static public Document getXMLFromFile(String fileloc){
        Document doc=null;
        
        try {
          File file = new File(fileloc);
          DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
          DocumentBuilder db = dbf.newDocumentBuilder();
          doc = db.parse(file);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doc;
    }
    
    /**
    Returns an XML document from an Input Stream. <br>

    Erik Wannebo 12/31/08
     */ 
    static public Document getXMLFromInputStream(InputStream is){
        Document doc=null;
        
        try {
          DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
          DocumentBuilder db = dbf.newDocumentBuilder();
          doc = db.parse(is);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doc;
    }
    
    /**
    Returns an XML document as a String. <br>

    Erik Wannebo 1/2/09
    */
    static public String convertXMLDocToString(Document doc){
        String xmlString="";
        try{
            Transformer transformer = TransformerFactory.newInstance().newTransformer();
            transformer.setOutputProperty(OutputKeys.METHOD, "XML");
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            StreamResult result = new StreamResult(new StringWriter());
            DOMSource source = new DOMSource(doc);
            transformer.transform(source, result);

            xmlString = result.getWriter().toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return xmlString;

    }
    
    /**
    Adds a new &lt;entryvalue name="x"&gt;&lt;text&gt;[CDATA] node to the XML Document. <br>

    Erik Wannebo 1/2/09
    */
    static public void addCDATANodeToXMLDoc(Document doc,Node parentnode,String nodename,String nodevalue){
        if(nodevalue==null)nodevalue="";
        Element newentrydata = doc.createElement("entrydata");
        newentrydata.setAttribute("name",nodename);
        Element newtextnode = doc.createElement("text");
        CDATASection cdata = doc.createCDATASection(nodevalue);
        newtextnode.appendChild(cdata);
        newentrydata.appendChild(newtextnode);
        parentnode.appendChild(newentrydata);
        return;

    }

    /**
    Adds a new &lt;entryvalue name="x"&gt;&lt;text&gt;node to the XML Document. <br>

    Erik Wannebo 1/2/09
    */
    static public void addTextNodeToXMLDoc(Document doc,Node parentnode,String nodename,String nodevalue){
        if(nodevalue==null)nodevalue="";
        Element newentrydata = doc.createElement("entrydata");
        newentrydata.setAttribute("name",nodename);
        Element newtextnode = doc.createElement("text");
        Text textnode=doc.createTextNode(nodevalue);
        newtextnode.appendChild(textnode);
        newentrydata.appendChild(newtextnode);
        parentnode.appendChild(newentrydata);
        return;

    }
    
    static public void writeXMLDocToFile(Document doc, String filename){
        try{
            //System.setProperty("file.encoding","UTF8");
            //OutputStream stm = new FileOutputStream(filename);
            //PrintWriter xmlfile= new PrintWriter(new OutputStreamWriter(stm));
            PrintStream out = 
                new PrintStream(filename, "UTF-8");
            out.println(XMLUtils.convertXMLDocToString(doc));
            out.close();
        }catch(Exception e){
            
        }
    }

    
    
    
}
