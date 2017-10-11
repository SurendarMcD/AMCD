package com.mcd.accessmcd.pci.manager;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;

import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;
import com.mcd.accessmcd.pci.util.XMLUtils;
/**
Class to format PCI content returned from the DAO layer as PCIResult[] as XML documents <br>

Erik Wannebo 10/30/09
 */ 
public class PCIResultsToXMLDoc {

    /**
     * The XML document for a "content" query.<br>
     * 
     */
    public static Document getContentXmlDocumentFromResults(PCIResult[] results,PCIQuery query){
        Document doc = null;
        try{
            DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            doc = builder.newDocument();
        }catch(Exception e){
            System.out.println("Exception creating XML Document:"+e.getLocalizedMessage());
            return null;
        }
        if(doc==null)return null;

        doc.setXmlVersion("1.0");
        Element viewentries = doc.createElement("viewentries");
        viewentries.setAttribute("toplevelentries",""+results.length);
        doc.appendChild(viewentries);
        int viewentryposition=1;
        
        //if the first result is from the Top Story category, it gets a position of "0"
        if(query.getTopStoryCategoryID()!=null && !query.getTopStoryCategoryID().equals("")){
            if(results.length>0 && results[0].getCategoryID().equals(query.getTopStoryCategoryID())){
                viewentryposition=0;
            }
        }
        for (int ix=0;ix<results.length;ix++) {
            PCIResult result=results[ix];
            Element viewentry=doc.createElement("viewentry");
            viewentry.setAttribute("position",""+viewentryposition);
            viewentryposition++;
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"DocTitle",result.getDocumentTitle());
            XMLUtils.addTextNodeToXMLDoc(doc,viewentry,"TypeCode",result.getTypeCode());
            XMLUtils.addTextNodeToXMLDoc(doc,viewentry,"LaunchType",result.getLaunchType());
            XMLUtils.addTextNodeToXMLDoc(doc,viewentry,"ServerID",result.getServerID());
            XMLUtils.addTextNodeToXMLDoc(doc,viewentry,"CategoryID",result.getCategoryID());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"URI",result.getPageURI());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"PublishDate",result.getPublishDate());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"PublishDayNonUS",result.getPublishDateNonUS());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"PublishDateJapan",result.getPublishDateJapan());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"ResourcePath","");
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"Description",result.getDescription());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"AudienceType",result.getAudienceType());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"imageURI",result.getImageURI());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"thumbnailURI",result.getThumbnailURI());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"ServerHostDomain",result.getServerHostDomain());
            viewentries.appendChild(viewentry);
        }
        return doc;
    }
    
    /**
     * The XML document for a "category" query.<br>
     * 
     */
    public static Document getCategoryXmlDocumentFromResults(PCIResult[] results,PCIQuery query){
        Document doc = null;
        try{
            DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            doc = builder.newDocument();
        }catch(Exception e){
            System.out.println("Exception creating XML Document:"+e.getLocalizedMessage());
            return null;
        }
        if(doc==null)return null;

        doc.setXmlVersion("1.0");
        Element viewentries = doc.createElement("viewentries");
        viewentries.setAttribute("toplevelentries",""+results.length);
        doc.appendChild(viewentries);
        
        for (int ix=0;ix<results.length;ix++) {
            PCIResult result=results[ix];

            Element newnode = doc.createElement("categoryid");
            Element newtextnode = doc.createElement("text");
            Text textnode=doc.createCDATASection(result.getCategoryID());
            newtextnode.appendChild(textnode);
            newnode.appendChild(newtextnode);
            viewentries.appendChild(newnode);

            newnode = doc.createElement("categorytitle");
            newtextnode = doc.createElement("text");
            textnode=doc.createCDATASection(result.getCategoryTitle());
            newtextnode.appendChild(textnode);
            newnode.appendChild(newtextnode);
            viewentries.appendChild(newnode);

            newnode = doc.createElement("categoryuri");
            newtextnode = doc.createElement("text");
            textnode=doc.createCDATASection(result.getPageURI());
            newtextnode.appendChild(textnode);
            newnode.appendChild(newtextnode);
            viewentries.appendChild(newnode);

            newnode = doc.createElement("categoryabstract");
            newtextnode = doc.createElement("text");
            textnode=doc.createCDATASection(result.getCategoryAbstract());
            newtextnode.appendChild(textnode);
            newnode.appendChild(newtextnode);
            viewentries.appendChild(newnode);

            newnode = doc.createElement("childelementcount");
            newtextnode = doc.createElement("text");
            textnode=doc.createTextNode(String.valueOf(result.getTotalResultCount()));
            newtextnode.appendChild(textnode);
            newnode.appendChild(newtextnode);
            viewentries.appendChild(newnode);

        }
        return doc;
    }
    
    /**
     * The XML document for a "combo" query.<br>
     * 
     */
    public static Document getComboXmlDocumentFromResults(PCIResult[] results,PCIQuery query){
        Document doc = null;
        try{
            DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            doc = builder.newDocument();
        }catch(Exception e){
            System.out.println("Exception creating XML Document:"+e.getLocalizedMessage());
            return null;
        }
        if(doc==null)return null;

        doc.setXmlVersion("1.0");
        Element viewentries = doc.createElement("viewentries");
        viewentries.setAttribute("toplevelentries",""+results.length);
        doc.appendChild(viewentries);
        int viewentryposition=1;
        
        for (int ix=0;ix<results.length;ix++) {
            PCIResult result=results[ix];
            Element viewentry=doc.createElement("viewentry");
            viewentry.setAttribute("position",""+viewentryposition);
            viewentryposition++;
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"DocTitle",result.getDocumentTitle());
            XMLUtils.addTextNodeToXMLDoc(doc,viewentry,"TypeCode",result.getTypeCode());
            XMLUtils.addTextNodeToXMLDoc(doc,viewentry,"LaunchType",result.getLaunchType());
            XMLUtils.addTextNodeToXMLDoc(doc,viewentry,"ServerID",result.getServerID());
            XMLUtils.addTextNodeToXMLDoc(doc,viewentry,"CategoryID",result.getCategoryID());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"URI",result.getPageURI());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"PublishDate",result.getPublishDate());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"PublishDayNonUS",result.getPublishDateNonUS());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"PublishDateJapan",result.getPublishDateJapan());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"ResourcePath","");
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"Description",result.getDescription());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"imageURI",result.getImageURI());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"thumbnailURI",result.getThumbnailURI());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"AudienceType",result.getAudienceType());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"ServerHostDomain",result.getServerHostDomain());
            viewentries.appendChild(viewentry);
        }
        return doc;
    }
    
    /**
     * The XML document for a "sf" (sitefinder) query.<br>
     * 
     */
    public static Document getSFXmlDocumentFromResults(PCIResult[] results,PCIQuery query){
        Document doc = null;
        try{
            DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            doc = builder.newDocument();
        }catch(Exception e){
            System.out.println("Exception creating XML Document:"+e.getLocalizedMessage());
            return null;
        }
        if(doc==null)return null;

        doc.setXmlVersion("1.0");
        Element viewentries = doc.createElement("viewentries");
        viewentries.setAttribute("toplevelentries",""+results.length);
        doc.appendChild(viewentries);
        int viewentryposition=1;
            
        for (int ix=0;ix<results.length;ix++) {
            PCIResult result=results[ix];
            Element viewentry=doc.createElement("viewentry");
            viewentry.setAttribute("position",""+viewentryposition);
            viewentryposition++;
            String firstchar="";
            String sitename=result.getDocumentTitle();
            if(sitename!=null && sitename.length() >0 ){
                firstchar=sitename.substring(0,1).toUpperCase();
            }
            XMLUtils.addTextNodeToXMLDoc(doc,viewentry,"Alphabet",firstchar);
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"SiteName",sitename);
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"ServerID",result.getServerID());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"URI",result.getPageURI());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"ServerHostDomain",result.getServerHostDomain());
            viewentries.appendChild(viewentry);
        }
        return doc;
    }
    
    
}
