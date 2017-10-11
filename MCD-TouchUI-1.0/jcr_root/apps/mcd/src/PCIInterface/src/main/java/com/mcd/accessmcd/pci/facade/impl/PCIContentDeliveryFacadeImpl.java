package com.mcd.accessmcd.pci.facade.impl;

import org.apache.sling.api.scripting.SlingScriptHelper;
import org.w3c.dom.Document;

import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;
import com.mcd.accessmcd.pci.facade.IPCIContentDeliveryFacade;
import com.mcd.accessmcd.pci.manager.PCIContentManager;
/**
Implementation class of interface with PCI Java Interface <br>

Erik Wannebo 11/24/08
 */ 
public class PCIContentDeliveryFacadeImpl implements IPCIContentDeliveryFacade {
    private PCIContentManager mgr=null;
    public PCIContentDeliveryFacadeImpl(){
        mgr=new PCIContentManager();
    }

    //For CQ5
    public PCIContentDeliveryFacadeImpl(SlingScriptHelper sling){
        mgr=new PCIContentManager(sling);
    }
    /**
    }
    Returns PCI content as array of @link(PCIResult) objects. <br>
     */     
    public PCIResult[] getPCIContent(PCIQuery query) {
        return mgr.getPCIContent(query);
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
        return mgr.getPCIContentAsXMLString(query);
    }

    /**
    Returns PCI content as a valid XML document object. <br>
     */ 
    public Document getPCIContentAsXMLDocument(PCIQuery query) {
        return mgr.getPCIContentAsXMLDocument(query);
    }

    /**
     * Utility function to flush the OSCache for the PCIInterface Layer<br>
     * 
     * (Added 10/16/2009)
     *  
     */
    public  boolean flushPCICache(){
        return mgr.flushPCICache();
    }
    
}
