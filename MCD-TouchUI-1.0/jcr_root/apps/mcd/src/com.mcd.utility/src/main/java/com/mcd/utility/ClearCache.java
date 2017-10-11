/**
 * Version: 1.0
 * Date: 27 May 2010
 * Purpose: A  Listener class which listen the pagemodification events.
 * Project: MCD US Redesign
 *
 */
 
package com.mcd.utility;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.File;

public class ClearCache
{   //Class starts here
    private static final Logger log = LoggerFactory.getLogger(ActivationNotificationManager.class);
        
        
    public boolean deleteCacheFolder(String filePath)
    {
        boolean cacheDelete = false;
        try
        {
            log.error("Cache Path ::::::"+filePath);
            File cacheFile = new File(filePath);
            cacheDelete = clearCache(cacheFile);                            
                
        } 
        catch(Exception ex)
        {
            log.error("Exception caught in getting cache folder path : " + ex);
        }
        return cacheDelete;
    }
     
    public static boolean clearCache(File cacheFile) 
    {
        try
        {
            if(cacheFile.exists()) 
            {
                File[] files = cacheFile.listFiles();
                for(int i=0; i<files.length; i++)
                {
                    if(files[i].isDirectory()) 
                    {
                        clearCache(files[i]);
                    }
                    else 
                    {
                        Runtime.getRuntime().exec("sudo chmod 777 " + files[i]);
                        files[i].delete();
                        log.error("Deleting File : " + files[i]);
                    }
                }
                files = null;
            }
        }
        catch(Exception ex)
        {
            log.error("Exceptino Caught In Clearing Cache : " + ex);
        }
        try
        {
            Runtime.getRuntime().exec("sudo chmod 777 " + cacheFile);
        }
        catch(Exception ep)
        {
            log.error("Exception caught in setting permission : " + ep);
        }
        
        log.error("Deleting Folder : " + cacheFile);
        return(cacheFile.delete());
    }
}