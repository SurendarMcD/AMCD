package com.mcd.accessmcd.webserver.util;
/**
* A class for sending a cache invalidattion message to 
* an Apache webserver.
* Modified from CQ4 version for CQ5
*
* Change Log:
* Date                  Name                      Reason
* 4/8/2009          Erik Wannebo               Original Version
* 3/28/2011         Erik Wannebo               CQ5 port
*
*/
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.util.ArrayList;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.*;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;



@Component(immediate=true,metatype=false)
@Service(value = Runnable.class)
@Properties({
    @Property( name="service.description",value="Apache Cache Invalidator"),
    @Property( name="service.vendor",value="MCD"),
    @Property( name="scheduler.period",longValue = 900),
    @Property( name="scheduler.expression",value="* 0,6,12,18 * * * ?",label="Expression",description="see unix cron format"),
    @Property(name="scheduler.concurrent", boolValue=false)
})

public class ApacheCacheInvalidator implements  Runnable {

private static final Logger log = LoggerFactory.getLogger(ApacheCacheInvalidator.class);

private static HttpClient client;
 
    public ApacheCacheInvalidator () {
     client = new HttpClient();
     log.info("***************** Inside ApacheCacheInvalidator *************************");  
     }   
    
    public void run() {
        log.info("[ApacheCacheInvalidator .run] scheduler start");
        //TODO: code
        ArrayList<String> pagesToInvalidate=new ArrayList<String>();
        
        /* STAG*/
         //accessmcd homepages  
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/*");
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/mcd/*"); 
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/na/*");     
        
        //landing pages 
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/na/us/*");
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/na/us/natl/*");
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/corp/*");
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/corp");
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/utility/*");
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/corp/gcd/*");
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/corp/gcd_31dec/*");
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/na/mcweb/*");
        pagesToInvalidate.add("mcdeagsun107b.mcd.com:19013|/accessmcd/na/apmea/*");
        
        
        
        
        /* PRODUCTION */
        /*
        //mcsource
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19018|/accessmcd/apmea/au");
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19018|/accessmcd/apmea/au/noticeboard");
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19018|/accessmcd/apmea/nz");
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19018|/accessmcd/apmea/nz/noticeboard");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19018|/accessmcd/apmea/au");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19018|/accessmcd/apmea/au/noticeboard");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19018|/accessmcd/apmea/nz");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19018|/accessmcd/apmea/nz/noticeboard");
        
         //accessmcd homepages  
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19023|/accessmcd/*");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19023|/accessmcd/*");
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19023|/accessmcd/na/*");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19023|/accessmcd/na/*");        
        
        //landing pages 
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19023|/accessmcd/na/us/*");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19023|/accessmcd/na/us/*");  
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19023|/accessmcd/na/us/natl/*");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19023|/accessmcd/na/us/natl/*"); 
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19023|/accessmcd/corp/*");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19023|/accessmcd/corp/*"); 
        pagesToInvalidate.add("mcdeagsun117.mcd.com:19023|/utility/*");
        pagesToInvalidate.add("mcdeagsun118.mcd.com:19023|/utility/*"); 
        */
        
        for(String page:pagesToInvalidate){
            String[] fields=page.split("\\|");
            if(fields.length>1){
               log.info("[ApacheCacheInvalidator invalidating] "+fields[0]+","+fields[1]);
               invalidatePage(fields[0],fields[1]);
            }
        }
        
        /*
        
        invalidatePage("mcdeagsun117.mcd.com:19018","/accessmcd/apmea/au");
        invalidatePage("mcdeagsun117.mcd.com:19018","/accessmcd/apmea/au/noticeboard");
        invalidatePage("mcdeagsun117.mcd.com:19018","/accessmcd/apmea/nz");
        invalidatePage("mcdeagsun117.mcd.com:19018","/accessmcd/apmea/nz/noticeboard");
        invalidatePage("mcdeagsun118.mcd.com:19018","/accessmcd/apmea/au");
        invalidatePage("mcdeagsun118.mcd.com:19018","/accessmcd/apmea/au/noticeboard");
        invalidatePage("mcdeagsun118.mcd.com:19018","/accessmcd/apmea/nz");
        invalidatePage("mcdeagsun118.mcd.com:19018","/accessmcd/apmea/nz/noticeboard");
        
       
        */
        
        log.info("[ApacheCacheInvalidator .run] scheduler finish");
    }   
    
/** invalidatePage(server, pageurl)
* server - Apache webserver host and port
* pageurl - CQ page handle
*
*/    
    public static boolean invalidatePage(String server, String pageurl)
    {
        boolean retFlag=false;
        PostMethod method=null;
    
        if(server==null || pageurl==null)return false;
        String url="http://"+server+"/dispatcher/invalidate.cache";
    
    try{
        method = new PostMethod(url);
        method.addRequestHeader("CQ-Action", "Activate");
        method.addRequestHeader("CQ-Handle", pageurl);
        int statusCode = client.executeMethod(method);

        if (statusCode != HttpStatus.SC_OK) {
            log.error("ApacheCacheInvalidator Exception:"+statusCode+" "+method.getStatusLine());
            return false;
        }
        BufferedReader sbr = new BufferedReader(new InputStreamReader(method.getResponseBodyAsStream()));
        String curLine = null;
        StringBuffer retStr = new StringBuffer();
        while ((curLine = sbr.readLine()) != null) {
            retStr.append(curLine);
        }
        retFlag=true;
    }catch(Exception e){
        log.error("ApacheCacheInvalidator Exception:"+e.getMessage());
        retFlag=false;
    } finally {
            method.releaseConnection();
        }  


    return retFlag;
        
    }
    

} 