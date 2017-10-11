package com.mcd.accessmcd.pci.dao;

import org.w3c.dom.Document;

import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;

/**
Interface to retrieve PCI Content data <br>

Erik Wannebo 12/30/08
 */ 
public interface IPCIContentDao {
    
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

}

