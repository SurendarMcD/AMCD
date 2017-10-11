package com.mcd.accessmcd.gcd.util;

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
      Properties props = new Properties();
      FileInputStream is = null;
      try
      {
          is = new FileInputStream(new File(fileName));
          props.load(is);
      } 
      catch(Exception e)
      {
      log.error("Exception while loading property file"+e); 
      } 
       finally
       {
         try
         {
           if (is != null)
             is.close();
         }
        catch (Exception ei)
        {
         log.error("Cannot close reader " + ei.getMessage());
        }
       }
      log.error("*******************props object"+props); 
      return props;
     
   }
} 