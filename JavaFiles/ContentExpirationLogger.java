//Judy Zhang , 08/22/2010
//log for content expiration scheduler

package com.mcd.accessmcd.ace.scheduler;
 
import java.util.logging.Logger;
import java.util.logging.FileHandler;
import java.io.IOException;
import java.util.logging.SimpleFormatter;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.HashMap;

//import com.mcd.accessmcd.ace.manager.ACEManager;

public class ContentExpirationLogger {
    private static FileHandler handler = null;
    private static Logger logger = null;
    private static HashMap<String, ContentExpirationLogger> map = new HashMap<String, ContentExpirationLogger>();
    private static String className = "";
 
    private static String logFile = "/app/mcd/cms/wcm1_auth_stg/crx-quickstart/server/files/defult_contentExp";

    private static void setMap(String key, ContentExpirationLogger obj){
          map.put(key,obj);       
    }
    
    private static ContentExpirationLogger getMap(String key){
      ContentExpirationLogger obj = (ContentExpirationLogger)map.get(key);
      return obj;
    }     

    public static ContentExpirationLogger getInstance(String className){
          ContentExpirationLogger obj = getMap(className);
          if(obj==null){                  
              obj = new ContentExpirationLogger(className);           
              setMap(className,obj); 
          }       
          return obj;
    }


   
    private ContentExpirationLogger(String cName){
          className = cName;
    }
 
    private static void getLogger(String className){
      logger = getLogger(className,logFile);      
    }

    private static Logger getLogger(String className,String file){
      logger = Logger.getLogger(className);
      try {
          handler = new FileHandler(file,10485760,5,true);
          handler.setFormatter(new SimpleFormatter());
          logger.addHandler(handler);      
        } catch (IOException ioe) {
          ioe.printStackTrace();
        }
       return logger;
     }

    private static void logMessage(Level level,String msg) {
        LogRecord record = new LogRecord(level, msg);       
        try {           
            logger.log(record);         
            if(handler!=null){
                handler.flush();
                handler.close();                
                handler = null;
            }                       
        }
        catch(Exception e){
                e.printStackTrace();
        }       
    }

    public static void setFile(String t){
          logFile = t;  
//System.out.println("logfile......."+logFile );          
    } 

    public static synchronized void severe(String msg){         
       getLogger(className);
       logMessage(Level.SEVERE,msg);
    }

    public static synchronized void warning(String msg){    
       getLogger(className);
       logMessage(Level.WARNING,msg);       
    }

    public static synchronized void info(String msg){   
       getLogger(className);        
       logMessage(Level.INFO,msg);     
    }   

}