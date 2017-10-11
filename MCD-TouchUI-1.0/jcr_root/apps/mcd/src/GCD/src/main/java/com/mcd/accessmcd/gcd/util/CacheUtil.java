/* 
 * CacheUtil.java                                                                               
 * Developed by HCL Technologies.                                                       
 * Author      :- Mansi                                                  
 * Date        :- December 22, 2008                                                     
 * Description :-  This class is the wrapper around the OS Cache Class to implement
 * Caching related functionalities.. 
 * 
 */

package com.mcd.accessmcd.gcd.util;



import com.opensymphony.oscache.general.GeneralCacheAdministrator;


/*************************************************************************
 * This class is the wrapper around OS Cache GeneralCacheAdministrator Class 
 * to perform Cache related activities like putting and getting data to and
 * from the  GeneralCacheAdministrator class
 *
 * @version 1.0 &nbsp; December 22, 2008
 * @author Mansi
 *
 *************************************************************************/
 


public class CacheUtil{
        
    private static GeneralCacheAdministrator cacheUtil=null;
    private static boolean firstThread=true;
    

    
    protected CacheUtil()
    {
            // Exists only to defete instantiation.
    }
    
    
    /**
     * This method gets the single instance of the GeneralCacheAdministrator class 
     * @return GeneralCacheAdministrator instance
     
     */
         
     public static GeneralCacheAdministrator getInstance()
     {   
        if(cacheUtil==null){
            simulateRandomActivity();
            synchronized(CacheUtil.class)
            {
            cacheUtil=new GeneralCacheAdministrator();
            }
        }
        return cacheUtil;
     }     


     /**
     * This method tries to sleep the current thread and protect the singleton 
     
     */
     
     private static void simulateRandomActivity()
     {
        try{
            if(firstThread){
                firstThread=false;
                Thread.currentThread().sleep(50);
            }
        }catch(InterruptedException ex){
            System.out.println("CacheUtil: simulateRandomActivity():sleep interrupted" + ex);
        }
     }
    
    
 
}  
