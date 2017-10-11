package com.mcd.gmt.product.batch;

import java.io.IOException;
import java.util.Properties;

import java.io.FileInputStream;
import java.io.File;

import org.slf4j.Logger; 
import org.slf4j.LoggerFactory;

/**
 * A simple utility for creating and loading up a Properties object from a specified file.
 */
public class PropertiesLoader
{

  private static final Logger log = LoggerFactory.getLogger(PropertiesLoader.class); 
   /**
   * Creates a Properties object loaded from a specified properties file.
   * @param propsFileName The name of the properties file to load the properties from
   * @return A Properties object containing the loaded proeprties.
   * @throws IOException If any thing goes wrong with loading the properties from the requested file.
   */
   public static Properties loadProperties(String propsFileName, String propsFilePath) throws IOException
   {
      String fileName = propsFilePath + propsFileName;
      log.error("11111111111111111111111111111"+fileName); 
      Properties props = new Properties();
      FileInputStream is = null;
      try
      {
          is = new FileInputStream(new File(fileName));
          log.error("22222222222222222222222222");
          props.load(is);
          log.error("3333333333333333333333333333333333333");    
      } 
      catch(Exception e)
      {
      log.error("Exception while loading property file"+e); 
      } 
       finally
       {
         try
         {
           log.error("*************closing inputstream***************");
           if (is != null)
             is.close();
         }
        catch (Exception ei)
        {
         log.error("Problem occured ModificationNotificationManager. Cannot close reader " + ei.getMessage());
        }
       }
      log.error("*******************props object"+props); 
      return props;
      
   } 
}   