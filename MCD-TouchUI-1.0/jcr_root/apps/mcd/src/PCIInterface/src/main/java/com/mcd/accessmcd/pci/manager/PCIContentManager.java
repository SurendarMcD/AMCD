package com.mcd.accessmcd.pci.manager;

import java.util.ArrayList;
import java.util.List;

import org.apache.sling.api.scripting.SlingScriptHelper;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;
import com.mcd.accessmcd.pci.dao.IPCIContentDao;
import com.mcd.accessmcd.pci.dao.impl.PCIContentDBDao;
import com.mcd.accessmcd.pci.dao.impl.PCIContentFileDao;
import com.mcd.accessmcd.pci.util.CacheUtil;
import com.mcd.accessmcd.pci.util.PCIProperties;
import com.mcd.accessmcd.pci.util.XMLUtils;
import com.opensymphony.oscache.general.GeneralCacheAdministrator;

/**
Manager class to return PCI content to the Facade layer from the DAO layer <br>

Erik Wannebo 12/30/08
 */ 
public class PCIContentManager {
    private IPCIContentDao dao=null;
    private static GeneralCacheAdministrator cacheadmin = null;
    private String datasource="";
    public PCIContentManager(){
        //TODO: use singleton?
        
        //HTTP Servlet PCI 1.0
        //dao=new PCIContentHTTPDao(); 

        // DB PCI 2.0
        dao=new PCIContentDBDao(); 
    }
    
    public PCIContentManager(SlingScriptHelper sling){

        dao=new PCIContentDBDao(sling); 
    }
    
    /*********
     *  Only for testing and comparing versions.
     * 
     * @param source
     */
    public PCIContentManager(String source){
        //TODO: use singleton?
        
        //HTTP Servlet PCI 1.0
        if(source.equals("http")){
            //dao=new PCIContentHTTPDao(); 
            //datasource="http";
        }else{
            // DB PCI 2.0
            dao=new PCIContentDBDao();
        }
    }
    
    /**
    Returns PCI content as array of @link(PCIResult) objects. <br>
    Currently only defined for "content" view type.
     */     
    public PCIResult[] getPCIContent(PCIQuery query) {
        String cachekey=query.getOSCacheKey()+"PCIRESULT";
        try {
            cacheadmin = CacheUtil.getInstance();
            PCIResult[] results = (PCIResult[]) cacheadmin.getFromCache(cachekey, query.getCacheRefresh());
            return results;
            //System.out.println("getPCIContent in cache");
        } catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            //System.out.println("getPCIContent NOT in cache");
            PCIResult[] results=dao.getPCIContent(query);//System.out.println("putting in cache:"+results.length+":key:"+cachekey);
            cacheadmin.putInCache(cachekey, results);
            return results;
        }
         
    }

    /**
    Returns PCI content as a String (HTML?). <br>
     */ 
    public String getPCIContentAsString(PCIQuery query) {
        // TODO Auto-generated method stub
        return null;
    }

    /**
    Returns PCI content as a String containing a valid XML file. <br>
     */ 
    public String getPCIContentAsXMLString(PCIQuery query) {
        String strXML="";
        String cachekey=query.getOSCacheKey()+"XMLSTRING";
        try {
            cacheadmin = CacheUtil.getInstance();
            strXML = (String) cacheadmin.getFromCache(cachekey, query.getCacheRefresh());
        } catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            //if(query.getViewType().equals("content")){
                Document doc=this.getPCIContentAsXMLDocument(query);
                strXML=XMLUtils.convertXMLDocToString(doc);
            //}else{
            //  strXML=dao.getPCIContentAsString(query);
            //}
            cacheadmin.putInCache(cachekey, strXML);
        }
        return strXML;
    }

    /**
    Returns PCI content as a valid XML document object. <br>
     */ 
    public Document getPCIContentAsXMLDocument(PCIQuery query) {
        Document doc=null;
        String cachekey=query.getOSCacheKey()+"XMLDOC";
        try {
            cacheadmin = CacheUtil.getInstance();
            doc = (Document) cacheadmin.getFromCache(cachekey, query.getCacheRefresh());
        } catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            System.out.println("getting new PCI XML doc");
            doc=dao.getPCIContentAsXMLDocument(query);
            
            cacheadmin.putInCache(cachekey, doc);
        }
        return doc;
    }

    /**
    Flush OSCache of all PCI Content. <br>
     */ 
    public boolean flushPCICache() {
        boolean retValue=true;
        cacheadmin = CacheUtil.getInstance();
        cacheadmin.flushAll();
        return retValue;
    }
    

}
