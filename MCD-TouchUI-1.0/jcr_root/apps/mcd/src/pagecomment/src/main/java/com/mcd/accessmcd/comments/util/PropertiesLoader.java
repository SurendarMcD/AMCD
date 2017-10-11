package com.mcd.accessmcd.comments.util; 

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mcd.accessmcd.comments.constants.CommentsConstants;

/**
 * A simple utility for creating and loading up a Properties object from a specified file.
 */
public class PropertiesLoader
{
    private static final Logger log = LoggerFactory.getLogger(PropertiesLoader.class);
    static Properties props = null;
    
   /**
   * Creates a Properties object loaded from a specified properties file.
   * @throws IOException If any thing goes wrong with loading the properties from the requested file.
   */
   public static void loadProperties() throws IOException
   {
      String propsFileName = CommentsConstants.PROPERTY_FILE_NAME;
      InputStream is = null;
      ClassLoader loader = PropertiesLoader.class.getClassLoader();
      if (loader != null)
      {
         is = loader.getResourceAsStream(propsFileName);
      }
      if (is == null)
      {
         is = ClassLoader.getSystemResourceAsStream(propsFileName);
      }
      if (is == null)
      {
         throw new IOException("Could not find resource: " + propsFileName);
      }
      props.load(is);
      is.close();
   } 
   
   /**
    * Returns the value of the input variable from the properties file 
    * @param propsName The name of the variable whose value needs to be fetched
    * @return Value of the input variable
    * @throws 
    */
   public static String getProperty(String propName) 
   {
      String propValue = null;
      
        try
        {
            if (props == null)
            {
               props = new Properties();
               loadProperties();
           }
          propValue = props.getProperty(propName);
          
        }
        catch (IOException ioe)
        {
          log.error("[getProperty()] Unable to get property value for: " + propName, ioe);
      }
      return propValue; 
   }
}
