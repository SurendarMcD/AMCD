/* 
 * CacheUtil.java                                                                               
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep Jain                                                  
 * Date        :- December 09, 2008                                                     
 * Description :-  This class is the wrapper around the OS Cache Class to implement
 * Caching related functionalities.. 
 * 
 */

package com.mcd.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.opensymphony.oscache.general.GeneralCacheAdministrator;
import java.util.*;
import java.io.*; 

/*************************************************************************
 * This class is the wrapper around OS Cache GeneralCacheAdministrator Class 
 * to perform Cache related activities like putting and getting data to and
 * from the  GeneralCacheAdministrator class
 *
 * @version 1.0 &nbsp; December 09, 2008
 * @author Sandeep jain
 *
 *************************************************************************/



public class CacheUtil{
        
    private static GeneralCacheAdministrator cacheUtil=null;
    private static boolean firstThread=true;
    
    protected static final  Logger log = LoggerFactory.getLogger(CacheUtil.class); 
    
    
    protected CacheUtil() 
    {
            // Exists only to defete instantiation.
    }
    
    
    /**
     * This method gets  the single instance of the GeneralCacheAdministrator class 
     * @return GeneralCacheAdministrator instance
     
     */
         
     public static GeneralCacheAdministrator getInstance()
     {   
            if(cacheUtil==null){
                simulateRandonActivity();
                synchronized(CacheUtil.class){
                try{    
                     /*java.util.Properties props = new java.util.Properties();
                     File myFile = new File("oscache");
                     props.load( (InputStream) (new FileInputStream(myFile)) );
                     cacheUtil=new GeneralCacheAdministrator(props);
                     */
					/* After Upgrade Change Start */

                    //cacheUtil=new GeneralCacheAdministrator(loadProperties("oscache.properties"));

                    cacheUtil = new GeneralCacheAdministrator(loadProperties("com/mcd/util/oscache.properties"));

                    /* After Upgrade Change End */
                }
                catch(Exception e){
                    log.error("Exception in cache util : "+e);
                }
                }
              } 
        
        log.debug("CacheUtil: getInstance():Created SingleTon CacheUtil:" + cacheUtil); 
        return cacheUtil;
     }
     
       public static Properties loadProperties(String propsFileName) throws IOException
       {
          Properties props = new Properties();
          InputStream is = null;
          ClassLoader loader = CacheUtil.class.getClassLoader();
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
     
     
     
     /**
     * This method tries to sleep the current thread and protect the singleton 
     
     */
     
     private static void simulateRandonActivity()
     {
        try{
            if(firstThread){
                firstThread=false;
                Thread.currentThread().sleep(50);
            }
        }catch(InterruptedException ex){
            log.warn("CacheUtil: simulateRandonActivity():sleep interrupted" + ex);
        }
     }
}
