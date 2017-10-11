package com.mcd.accessmcd.pci.dao.impl;

import org.w3c.dom.Document;

import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;
import com.mcd.accessmcd.pci.dao.IPCIContentDao;
import com.mcd.accessmcd.pci.util.XMLUtils;

public class PCIContentFileDao implements IPCIContentDao {
    private String testfile;
    
    public PCIContentFileDao(){
        //testfile="c:\\newpci.xml";
        testfile="c:\\PCIServer.xml";
    }
    public PCIResult[] getPCIContent(PCIQuery query) {
        // TODO Auto-generated method stub
        return null;
    }

    public String getPCIContentAsString(PCIQuery query) {
        // TODO Auto-generated method stub
        return null;
    }

    public Document getPCIContentAsXMLDocument(PCIQuery query) {
        return XMLUtils.getXMLFromFile(testfile);
    }

    public String getPCIContentAsXMLString(PCIQuery query) {
        // TODO Auto-generated method stub
        return null;
    }


}
