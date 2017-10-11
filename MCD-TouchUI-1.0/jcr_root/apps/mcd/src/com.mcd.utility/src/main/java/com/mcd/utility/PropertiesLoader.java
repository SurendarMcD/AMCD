package com.mcd.utility;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * A simple utility for creating and loading up a Properties object from a specified file.
 */
public class PropertiesLoader
{
   /**
   * Creates a Properties object loaded from a specified properties file.
   * @param propsFileName The name of the properties file to load the properties from
   * @return A Properties object containing the loaded proeprties.
   * @throws IOException If any thing goes wrong with loading the properties from the requested file.
   */
   public static Properties loadProperties(String propsFileName) throws IOException
   {
      Properties props = new Properties();
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
      return props;
   }
}
 