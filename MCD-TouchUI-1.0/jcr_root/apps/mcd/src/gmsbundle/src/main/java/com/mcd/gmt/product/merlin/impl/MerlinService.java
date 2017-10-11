package com.mcd.gmt.product.merlin.impl;


import com.mcd.gmt.product.cq.impl.ProductService;
import com.mcd.gmt.product.merlin.IMerlinService;
/*
import com.mcd.gmt.dummyws.DummyService;
import com.mcd.gmt.dummyws.DummyServiceServiceLocator;
*/

import org.slf4j.Logger;
import org.slf4j.LoggerFactory; 
//import pri.corp.mcdeagpweb153.ServiceLocator;
//import pri.corp.mcdeagpweb153.ServiceSoap;



public class MerlinService implements IMerlinService {  
    
    private static final Logger log = LoggerFactory.getLogger(MerlinService.class);
     
    public String getProductNutritionInfo (String productId,boolean flag){
        String nutritionInfoXML="";
        try {
        
    
        
        //ServiceSoap service = new ServiceLocator().getServiceSoap(); 
        //nutritionInfoXML=service.getNutrientComposition(productId, flag);   
            
        }catch (Exception exception) {
            log.error("Exception in Webservice method getProductNutritionInfo"+ exception);
        } 
        
        return nutritionInfoXML;           
    }
    public String getProductBuildInfo(String productId, boolean flag){
        String buildInfoXML="";
        try 
        {
    
        //ServiceSoap service = new ServiceLocator().getServiceSoap(); 
        //buildInfoXML=service.getSpecBuildInformation(productId, flag); 
        }catch(Exception exception)
        {
            log.error("Exception in Webservice method getProductBuildInfo"+ exception);
        }
        return buildInfoXML;
    }
}
  