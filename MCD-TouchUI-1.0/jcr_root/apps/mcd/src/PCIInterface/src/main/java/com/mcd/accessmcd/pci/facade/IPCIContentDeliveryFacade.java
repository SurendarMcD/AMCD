package com.mcd.accessmcd.pci.facade;

import org.w3c.dom.Document;

import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;
/**
Interface used to query and return PCI data. <br>

Erik Wannebo 11/24/08
 */ 
public interface IPCIContentDeliveryFacade {

    
    /**
     * Returns an array of PCI Results
     *  
     */
    public abstract PCIResult[] getPCIContent(PCIQuery query);
    
    /**
     * Returns an XML document of PCI Results
     *  
     */
    public abstract String getPCIContentAsXMLString(PCIQuery query);
    
    /**
     * Returns PCI Results as an XML document object
     *  
     */
    public abstract Document getPCIContentAsXMLDocument(PCIQuery query);
    
    /**
     * Returns a String (HTML ?) of PCI Results
     *  
     */
    public abstract String getPCIContentAsString(PCIQuery query);
    
    /**
     * Utility function to flush the OSCache for the PCIInterface Layer
     *  
     */
    public abstract boolean flushPCICache();
    

}
