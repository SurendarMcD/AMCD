package com.mcd.accessmcd.ace.manager;

import com.mcd.accessmcd.ace.util.PropertiesLoader;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author mc23284
 *
 */
public class ACEMailManager {
    
    private Properties aceMailProperties;   
    public static String defaultMailPropFile = "mailconfiguration_en.properties";
    private static final Logger log = LoggerFactory.getLogger(ACEMailManager.class);
      
    ACEManager aceManager = new ACEManager();
    /**
     * constructor for reading the DEFAULT properties file from server files
     */         
    public ACEMailManager() {
        super();
        try{            
            java.io.FileInputStream fis = new java.io.FileInputStream(new java.io.File(aceManager.getServerFilesPath()+ defaultMailPropFile));
            java.util.Properties props = new java.util.Properties();
            props.load(fis);
            fis.close();
            this.aceMailProperties = props;
            //System.out.println("[ACEMailManager] Constructor-- aceMailProperties :"+ aceMailProperties);
            
        } catch(Exception e) {
            log.error("[ACEMailManager] Constructor-- Exception :"+e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * constructor for reading the Lang properties file from server files
     * Fall backs to DEFAULT file
     */         
    public ACEMailManager(String Language) {
        super();
        try{    
            String langMailPropFile = "mailconfiguration_" + Language +".properties";
            java.io.FileInputStream fis;
            try{
                 fis = new java.io.FileInputStream(new java.io.File(aceManager.getServerFilesPath()+ langMailPropFile));
            }catch(java.io.FileNotFoundException e){
                log.error("[ACEMailManager] Constructor(lang)-- Exception :"+e.getMessage());
                 fis = new java.io.FileInputStream(new java.io.File(aceManager.getServerFilesPath()+ defaultMailPropFile));
            }
            java.util.Properties props = new java.util.Properties();
            props.load(fis);
            fis.close();
            this.aceMailProperties = props;
            //System.out.println("[ACEMailManager] Constructor(lang)-- aceMailProperties :"+ aceMailProperties);
            
        } catch(Exception e) {
            log.error("[ACEMailManager] Constructor(lang)-- Exception :"+e.getMessage());
            e.printStackTrace();
        } 
    }
    
    // returns Value for the passed key. Default to ""
    public String getValueForKey(String key){
//        System.out.println("key:"+key); 
        String mailPropKeyValue = "";
        try {           
            // read props file
            if( (aceMailProperties.containsKey(key))){
                mailPropKeyValue = aceMailProperties.getProperty(key, "");
            }
        } catch (Exception e){
            log.error("[ACEMailManager] getValueForKey-- Exception:"+e.getMessage());
            e.printStackTrace();
        } 
            return mailPropKeyValue;
    }
}