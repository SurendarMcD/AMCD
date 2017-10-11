package com.mcd.accessmcd.pci.dao.impl;
/**
DAO Implementation class to return PCI content from the PCI Servlet application <br>
The Servlet application returns HTML/XML.

Erik Wannebo 12/31/08
 */
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;
import com.mcd.accessmcd.pci.dao.IPCIContentDao;
import com.mcd.accessmcd.pci.util.PCIProperties;
import com.mcd.accessmcd.pci.util.XMLUtils;

public class PCIContentHTTPDao implements IPCIContentDao {

    //client timeout session for Http connections
    private final int CLIENT_TIMEOUT=5000; //5 secs    
    
    //socket timeout param
    private final String SOCKET_TIMEOUT_ARG = "http.socket.timeout";
    
    //connection timeout param
    private final String CONN_TIMEOUT_ARG   = "http.connection.timeout";
    
    //TODO: Make this configurable
    private String PCI_SERVLET;
    
    public PCIContentHTTPDao(){
        PCI_SERVLET=PCIProperties.PCI_SERVLET;
    }
    
    public PCIResult[] getPCIContent(PCIQuery query) {
        PCIResult[] results=null;
        //get the data first as an XML document
        Document doc=getPCIContentAsXMLDocument(query);
        if(query.getViewType().equals("content")){
            results=parseDocToPCIResults(doc);
        }
        //do another query to get total result count
        query.setViewType("category");
        doc=getPCIContentAsXMLDocument(query);
        int totalresultcount=parseDocForTotalResultCount(doc);
        if(totalresultcount>0){
            for(int ix=0;ix<results.length;ix++){
                results[ix].setTotalResultCount(totalresultcount);
            }
        }
        return results;
    }

    public String getPCIContentAsString(PCIQuery query) {

        return this.getPCIContentAsXMLString(query);
    }

    public Document getPCIContentAsXMLDocument(PCIQuery query) {

        String pciURL=PCI_SERVLET+query.toQueryString(false);
        //for testing
        //pciURL="http://mcdeagsun007:8004/pci/PCIServer?action=read&viewtype=content&sorting=rchrono&catid=20052&count=10&sm_user=test&mcdaudience=CorpEmployees&mcdentity=ENT";
        //System.out.println(pciURL);
        Document doc=this.getXMLDocFromURL(pciURL);
        if(query.getTopStoryCategoryID()!=null && !query.getTopStoryCategoryID().equals("")){
            pciURL=PCI_SERVLET+query.toQueryString(true);
            Document topstorydoc=this.getXMLDocFromURL(pciURL);
            if(topstorydoc!=null){
                NodeList topstorynodes=topstorydoc.getElementsByTagName("viewentry");
                if(topstorynodes.getLength()==1){
                    //combine the XML
                    Element topstoryviewentry=(Element)topstorynodes.item(0);
                    topstoryviewentry.setAttribute("position","0");
                    Element viewentryroot=(Element)doc.getElementsByTagName("viewentries").item(0);
                    NodeList origviewentries=doc.getElementsByTagName("viewentry");
                    int origviewentrycount=origviewentries.getLength();
                    if(viewentryroot!=null){
                        viewentryroot.setAttribute("toplevelentries",""+(origviewentrycount+1));
                        Node copiednode=doc.importNode(topstoryviewentry, true);
                        if(origviewentrycount>0){
                            viewentryroot.insertBefore(copiednode, origviewentries.item(0));
                        }else{
                            viewentryroot.appendChild(copiednode);
                        }
                    }
                }
            }

        }
        
        if(query.getViewType().equals("content")){
            //add new content fields to XML
            parseDocToPCIResults(doc);
        }else{
            addServerHostDomainElement(doc);
        }
        
        return doc;
    }

    public String getPCIContentAsXMLString(PCIQuery query) {
        String strXML="";
        //TODO: remove this once added to PCIServlet
        if(query.getTopStoryCategoryID()!=null && !query.getTopStoryCategoryID().equals("")){
            Document doc=this.getPCIContentAsXMLDocument(query);
            if(doc!=null)strXML=XMLUtils.convertXMLDocToString(doc);
        }else{
            String pciURL=PCI_SERVLET+query.toQueryString(false);
            strXML=this.getXMLStringFromURL(pciURL);
        }
        return strXML;
    }
    /**
     * Call to the URL to get a the XML Document from the provider.<br>
     * 
     * @return XML Document object
     */
    
    public Document getXMLDocFromURL(String strURL){         
        Document retDoc=null;
        
        int respCode = 0;
        InputStream in = null;      
        HttpClient httpClient  = new HttpClient();        
        GetMethod method = new GetMethod(strURL);       
        try {               
          //socket timeout - 
          //1. thread hanging 2. data not received within 5 secs
          httpClient.getParams().setParameter(SOCKET_TIMEOUT_ARG, new Integer(CLIENT_TIMEOUT));
          
          //connection timeout - httpconnection could not be established
          httpClient.getParams().setParameter(CONN_TIMEOUT_ARG, new Integer(CLIENT_TIMEOUT));
            
          // retry handler - default retry is 3, changed it to 1
          method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler(1, false));                   
           
          //execute
          int statusCode = httpClient.executeMethod(method); 
        
          //read the response as a input stram
          in = method.getResponseBodyAsStream();
            
          retDoc=XMLUtils.getXMLFromInputStream(in);
          
        }catch (IOException e2) {               
            System.out.println("-->>>ERROR retrieving HTTP content " +
                                "|[PCIContentHTTPDao.getXMLStringFromURL()]|"+strURL+ "|"+ e2+ "<<<--");
            System.out.println("-->>>Response code:"+respCode+"<<<--");     
            
        }catch(Exception e1){
            System.out.println("-->>>ERROR retrieving HTTP content " +
                    "|[PCIContentHTTPDao.getXMLStringFromURL()]|"+strURL+ "|"+ "<<<--");
            System.out.println("-->>>Response code:"+respCode+"<<<--");     
        }
        finally{                   
            if(in!=null){ 
                try { in.close(); } 
                catch (IOException e) {e.printStackTrace();} 
            }   
            
            //release the http connection
            if(method!=null) { method.releaseConnection();   }  
            if(httpClient!=null) {httpClient =null; }
        }
        return retDoc;
    }
    
    /**
     * Call to the URL to get a the XML string from the provider.<br>
     * 
     * @return String
     */
    private String getXMLStringFromURL(String strURL){
            int respCode = 0;
            String retStr = null;
            HttpClient httpClient  = new HttpClient();  
            
            GetMethod method = new GetMethod(strURL);       
            try {               
              //socket timeout - 
              //1. thread hanging 2. data not received within 5 secs
              httpClient.getParams().setParameter(SOCKET_TIMEOUT_ARG, new Integer(CLIENT_TIMEOUT));
              
              //connection timeout - httpconnection could not be established
              httpClient.getParams().setParameter(CONN_TIMEOUT_ARG, new Integer(CLIENT_TIMEOUT));
                
              // retry handler - default retry is 3, changed it to 1
              method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler(1, false));                   
               
              //execute
              int statusCode = httpClient.executeMethod(method); 
              //System.out.println("response char set:"+method.getResponseCharSet());
              //read the response
              InputStreamReader in2 = new InputStreamReader(method.getResponseBodyAsStream(), "UTF-8");
              StringWriter sw = new StringWriter();
              int x;
              while((x = in2.read()) != -1){
                  sw.write(x);
              }
              in2.close();
              retStr = sw.toString(); 
              //System.out.println(TextUtils.byteArrayToHexString(retStr.getBytes("UTF-8")));
            }catch (IOException e2) {               
                System.out.println("-->>>ERROR retrieving HTTP content " +
                                    "|[PCIContentHTTPDao.getXMLStringFromURL()]|"+strURL+ "|"+ e2+ "<<<--");
                System.out.println("-->>>Response code:"+respCode+"<<<--");     
                
            }catch(Exception e1){
                System.out.println("-->>>ERROR retrieving HTTP content " +
                        "|[PCIContentHTTPDao.getXMLStringFromURL()]|"+strURL+ "|"+ "<<<--");
                System.out.println("-->>>Response code:"+respCode+"<<<--");     
            }
            finally{                   
                
                //release the http connection
                if(method!=null) { method.releaseConnection();   }  
                if(httpClient!=null) {httpClient =null; }
            }
            return retStr;
              
    }
    
    /**
      Helper to populate the PCIResult objects from the XML Document. <br>
      Also adds new fields to the XML Document. <br>
     */ 
    private PCIResult[] parseDocToPCIResults(Document doc){
        if(doc==null)return new PCIResult[0];
        NodeList nodes=doc.getElementsByTagName("viewentry");
        PCIResult[] results=new PCIResult[nodes.getLength()];
        //System.out.println("nodes.getLength():"+nodes.getLength());
        for(int i=0;i<nodes.getLength();i++){
            Node viewentry=nodes.item(i);
            NodeList entries=viewentry.getChildNodes();
            PCIResult pciresult=new PCIResult();
            String resourcepath="";
            String uri="";
            String viewentryposition=viewentry.getAttributes().getNamedItem("position").getTextContent();
            for(int j=0;j<entries.getLength();j++){
                Node entry=entries.item(j);
                if(entry.getNodeName().equals("entrydata")){
                    //each entrydata node has only one attribute: name
                    String nodename=entry.getAttributes().item(0).getNodeValue();
                    String nodevalue=entry.getTextContent().trim();
                    //.println(nodename+":"+nodevalue);
                    boolean bsearch=true;
                    if(nodename.equals("DocTitle")){
                        pciresult.setDocumentTitle(nodevalue);
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("TypeCode")){
                        pciresult.setTypeCode(nodevalue);
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("LaunchType")){
                        pciresult.setLaunchType(nodevalue);
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("ServerID")){
                        pciresult.setServerID(nodevalue);
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("CategoryID")){
                        pciresult.setCategoryID(nodevalue);
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("URI")){
                        uri=nodevalue;
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("PublishDate")){
                        pciresult.setPublishDate(nodevalue);
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("PublishDayNonUS")){
                        pciresult.setPublishDateNonUS(nodevalue);
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("PublishDateJapan")){
                        pciresult.setPublishDateJapan(nodevalue);
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("ResourcePath")){
                        resourcepath=nodevalue;
                        bsearch=false;
                    }
                    if(bsearch && nodename.equals("Description")){
                        pciresult.setDescription(nodevalue);
                        bsearch=false;
                    }   
                    if(bsearch && nodename.equals("AudienceType")){
                        pciresult.setAudienceType(nodevalue);
                        bsearch=false;
                    }           
                }
            }
            //update additional properties
            //decode Server IDs
            pciresult.setServerHostDomain((String)PCIProperties.serverDomainMap.get(pciresult.getServerID()));
            pciresult.setPageURI(uri);
            String basePage=uri.substring(uri.lastIndexOf('/'));
            String mediafile="";
            if(resourcepath!="" && !resourcepath.equals("null") && !resourcepath.equals("|")){
                //feature stories may put an alternate URL into resourcepath
                int pipeloc=resourcepath.indexOf("|");
                if(pipeloc>-1){
                        mediafile=resourcepath.substring(0,pipeloc);
                        if(pipeloc<resourcepath.length()-1){
                            String alternateurl=resourcepath.substring(resourcepath.indexOf("|")+1);
                            pciresult.setPageURI(alternateurl);
                            pciresult.setServerHostDomain("");
                        }
                }else{
                    mediafile=resourcepath;
                }
                //FOR TESTING ONLY
                if(mediafile.equals(""))mediafile="testdata.flv";
                pciresult.setMediaURI(PCIProperties.AMCD_MEDIA_LOCATION+"/featuredstories"+basePage.replaceAll("\\.accessmcd\\.",".featuremedia.")+"/"+mediafile);
                //update XML Document with new fields
            }//end viewentry
            
            if(viewentryposition.equals("0")){
                pciresult.setImageURI(PCIProperties.AMCD_MEDIA_LOCATION+"/topstories"+basePage.replaceAll("\\.accessmcd\\.html",".AMCDImage.gif"));
                pciresult.setThumbnailURI(PCIProperties.AMCD_MEDIA_LOCATION+"/topstories"+basePage.replaceAll("\\.accessmcd\\.html",".AMCDImage.gif"));         
            }else{
                pciresult.setImageURI(PCIProperties.AMCD_MEDIA_LOCATION+"/featuredstories"+basePage.replaceAll("\\.accessmcd\\.html",".featureimage.gif"));
                pciresult.setThumbnailURI(PCIProperties.AMCD_MEDIA_LOCATION+"/featuredstories"+basePage.replaceAll("\\.accessmcd\\.html",".featurethumbnail.gif"));         
            }

            //update XML Document with new fields
            if(pciresult.getImageURI()!=null)XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"imageURI",pciresult.getImageURI());
            if(pciresult.getThumbnailURI()!=null)XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"thumbnailURI",pciresult.getThumbnailURI());
            if(pciresult.getMediaURI()!=null)XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"mediaURI",pciresult.getMediaURI());
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"ServerHostDomain",pciresult.getServerHostDomain());

            results[i]=pciresult;
            
        }//end viewentries
        
        return results;
    }
    
    /**
    Helper to get Total Result Count in a category from XML Document. <br>
     */ 
    private int parseDocForTotalResultCount(Document doc){
        int totalResultCount=0;
        if(doc!=null){
            NodeList nodes=doc.getElementsByTagName("childelementcount");
            if(nodes.getLength()>0){
                String nodevalue=nodes.item(0).getTextContent().trim();
                if(nodevalue!=null && nodevalue!=""){
                    totalResultCount=Integer.parseInt(nodevalue);
                }
            }
        }
        return totalResultCount;
    }
    
    /**
      Helper to add the ServerHostDomain elements to the XML document
      This was added to be a lighter weight method for Content Index combo 
      and SiteFinder types
     */ 
    
    private void addServerHostDomainElement(Document doc){
        if(doc==null)return;
        NodeList nodes=doc.getElementsByTagName("viewentry");
        
        for(int i=0;i<nodes.getLength();i++){
            String serverID="";
            Node viewentry=nodes.item(i);
            NodeList entries=viewentry.getChildNodes();
            for(int j=0;j<entries.getLength();j++){
                Node entry=entries.item(j);
                if(entry.getNodeName().equals("entrydata")){
                    String nodename=entry.getAttributes().item(0).getNodeValue();
                    String nodevalue=entry.getTextContent().trim();
                    boolean bsearch=true;
                    if(bsearch && nodename.equals("ServerID")){
                        serverID=nodevalue;
                        bsearch=false;
                    }
                }
            }
            XMLUtils.addCDATANodeToXMLDoc(doc,viewentry,"ServerHostDomain",(String)PCIProperties.serverDomainMap.get(serverID));
        }
    }


}
