package com.mcd.accessmcd.common.helper;

import java.util.ResourceBundle;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 * This class is used to read the properties file
 *
 *
 * @author Shubhra
 * @version 1.0
 *
 */
public class PropertyHelper {   
    

  private static final Logger log =  LoggerFactory.getLogger(PropertyHelper.class);
    /**
     * @param propertiesFileName
     * @param propertyKey
     * 
     * @return Returns the value of the property from the given 
     * property file
     */
    public static String getPropValue(String propertiesFileName, String propertyKey) {
    
        String propertyValue = null;
        
        try {
            
            ResourceBundle rb = null;
            
            rb = ResourceBundle.getBundle(propertiesFileName);
            
            propertyValue = rb.getString(propertyKey);
            
         log.error("propertyValue : " + propertyValue);
                
        } catch (Exception e) {
                log.error("error message =" + e.getMessage());          
        }

        return propertyValue;   
    }
}