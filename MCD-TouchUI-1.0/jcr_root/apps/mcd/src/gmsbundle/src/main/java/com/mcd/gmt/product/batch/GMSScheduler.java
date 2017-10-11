package com.mcd.gmt.product.batch;

import com.mcd.gmt.product.Activator;  
import org.apache.sling.commons.scheduler.Scheduler;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;

import org.osgi.framework.BundleActivator;
import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;

import org.apache.sling.api.resource.ResourceResolver;
import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;
import com.day.cq.wcm.api.designer.Design;
import com.day.cq.wcm.api.designer.Designer;
import com.day.cq.wcm.api.designer.Style;
import org.apache.commons.mail.HtmlEmail;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;


import org.apache.sling.scripting.core.ScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.*;
import com.mcd.gmt.product.cq.IProductService;
import com.mcd.gmt.product.constant.ProductConstant;
import com.mcd.gmt.product.cq.impl.ProductService; 
import com.day.cq.jcrclustersupport.ClusterAware;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;

@Component(immediate=true,metatype=false)
@Service(value = Runnable.class)
@Properties({
    @Property( name="service.description",value="GMSScheduler"),
    @Property( name="service.vendor",value="MCD"),
    @Property( name="scheduler.period",longValue = 900),
    @Property( name="scheduler.expression",value="0 0 23 L * ?",label="Expression",description="see unix cron format"),
    @Property(name="scheduler.concurrent", boolValue=false)
})

public class GMSScheduler implements Runnable,ClusterAware{ 
      

        private static final Logger log = LoggerFactory.getLogger(GMSScheduler.class);
        
         /** @scr.reference */
         SlingRepository repository;
         
         
        /** @scr.reference */
        JcrResourceResolverFactory resolverFactory;  
   
        /** @scr.reference */ 
        private com.day.cq.replication.Replicator rep;

        Session session;
        PageManager pageManager = null; 
        ResourceResolver resourceResolver;
        
        BundleContext bc = Activator.getBundleContext();
        ScriptHelper sling = new ScriptHelper(bc,null);   
           
      
        URL url = null;
        URLConnection connection = null; 
        InputStream in = null;
        BufferedReader res = null;
 
        IProductService ipd = null;
        boolean isMaster = false;
        
       public GMSScheduler(){
       new GMSScheduler(this.repository, this.resolverFactory, this.sling);
       }
        
       public GMSScheduler(SlingRepository repository, JcrResourceResolverFactory resolverFactory, ScriptHelper sling){
            
            if(null == repository) {
                log.error("GMSScheduledJob Constructor: Repository reference not obtained"+repository);
            }
            else{
                log.error("GMSScheduledJob Constructor: Repository reference has been obtained");
                this.repository = repository;
            }
            if(null == resolverFactory){ 
                log.error("GMSScheduledJob Constructor: resolverFactory reference not obtained"+resolverFactory);
            }
            else{
                log.error("##########GMSScheduledJob  Constructor: resolverFactory reference has been obtained");
                this.resolverFactory = resolverFactory;
            }
            if(null==sling){
                log.error("##########GMSScheduledJob Constructor: sling reference not obtained"+sling);
            }
            else{
                log.error("##########GMSScheduledJob Constructor: sling reference has been obtained");
                this.sling = sling;
            }
        }

        public void run() {
            log.error("[GMSScheduler.run] scheduler starting");
             try{
                     if(isMaster){
                     //task specific code here
                         log.error("**********************Inside the run method of GMSScheduledJob **********************");
                         if(null == this.repository){
                            log.error("REPOSITORY ISNT YET INTITIALIZED");
                         }
                         if(null == repository){
                             log.error("REPOSITORY ISNT YET INTITIALIZED");
                         } 
                         session = this.repository.loginAdministrative(null);
    
                         if(null == session) {
                            log.error("Session not obtained*************************************");
                         }
    
                         if(null == resolverFactory){
                             log.error("JcrResourceResolverFactory not obtained");
                         }
                         
                         log.error("Obtained repository session----------- ");
                         resourceResolver = resolverFactory.getResourceResolver(session);
                         if(null != resourceResolver ){
                            log.error("Obtained resourceResolver----------- ");
                         }
                         pageManager = resourceResolver.adaptTo(PageManager.class);
                         if(null != pageManager){
                           log.error("Obtained pageManager----------- ");
                         }
                         scanPages();
                         log.error("[GMSScheduler .run] scheduler finishing");     
                     }
                    else{
                        log.info("********** This is slave instance GMS schedular will not start from here *********");
                    }
                } // end outermost try  
                catch(Exception exception){
                    log.error("General Exception: " + exception);
                }
             } // end run method
       
              
             /**
              *  This method will be used to retrieve and update the page informations
              */
         public void scanPages(){ 
   
             log.error("Inside scanPages method************************************************");
             Page rootPage = (null != pageManager.getPage("/content/accessmcd/corp/services_support/gms/products"))? pageManager.getPage("/content/accessmcd/corp/services_support/gms/products"):null;
             Page currentProductPage = null;
             Node currentProductPageNode = null;
             String menuId=""; 
             String nutritionInfoFromMerlin = "";
             String buildInfoFromMerlin = "";
             String nutritionInfoPropertyValue="";
             String buildInfoInfoPropertyValue="";
             String nutritionHTMLString="";
             String buildInfoHTMLString="";
             String merlinResponse="";

             ipd = new ProductService(sling, session, resourceResolver);

             String lastReplicationAction = ""; 
             String pageStatus = "";
             Boolean pageIsActivated = false;
             Calendar lastReplicatedDate=null;
             Calendar lastModifiedDate=null;
             long lastReplicatedTime = 0L;  
             long lastModifiedTime = 0L;
             String merlinWarURL = null;
             Map <String, String> pageMap = new HashMap <String, String>(); 
             
             if((null==rootPage)){
                 log.error("************************************************ rootPage not found");
             }
             else{
                 log.error("*************************rootPage exists, and has title: " + rootPage.getTitle());
                 Iterator<Page> productPageIterator = rootPage.listChildren();
                 while(productPageIterator.hasNext()){
                     currentProductPage = productPageIterator.next();
                     currentProductPageNode = resourceResolver.getResource(currentProductPage.getPath() + "/jcr:content").adaptTo(Node.class);
                     log.error("The currrent Page is *********************** : " + currentProductPage .getTitle());
                     menuId = currentProductPage.getProperties().get(ProductConstant.Atom_MERLINMenuItemID, "").trim();
                     try{
                         if(!menuId.equals("")){
                             log.error("****************************" + currentProductPage.getTitle() + " has the menuId :  " + menuId);
                             
                             nutritionInfoPropertyValue = currentProductPage.getProperties().get(ProductConstant.Atom_MERLINNutritionInfoXML, "");
                             log.error("the length of Nutrition Info XML from the " + currentProductPage.getTitle() + " is: " + nutritionInfoPropertyValue.length());
                             buildInfoInfoPropertyValue = currentProductPage.getProperties().get(ProductConstant.Atom_MERLINProductBuildXML, "");
                             log.error("the length of Build Info XML from the " + currentProductPage.getTitle() + " is: " + buildInfoInfoPropertyValue.length());
                             java.util.Properties mailConfigProp = PropertiesLoader.loadProperties("mailgmt.properties","/app/mcd/cms/fs05/wcm1_auth_prod/crx-quickstart/server/files/");  
                             log.error("!!!!!!!!!!!!!!!mailConfig Property object" + mailConfigProp );  
                              merlinWarURL=mailConfigProp.getProperty("merlinWarInstanceURL");
                              merlinWarURL = merlinWarURL+"?requestType=getAllProductMerlinDetails&productID="+menuId+"&isApproved=false";
                             log.error("**********************************************************The url to access merlinservicewar is: " + merlinWarURL);       
                          
                             merlinResponse = callURL(merlinWarURL);
                             log.error("******** Merlin Response ********" + merlinResponse ); 
                             if(!merlinResponse.contains("Please provide a valid Menu Item ID")){
                                    //log.error("************************************************************** the length of merlin response is: " + merlinResponse.length());
                                     int nutritionXmlStartIndex = merlinResponse.indexOf("<!--NUTRITION_XMLSTART-->");
                                     int nutritionXmlEndIndex = merlinResponse.indexOf("<!--NUTRITION_XMLEND-->");
                                     int nutritionHTMLStartIndex = merlinResponse.indexOf("<!--NUTRITION_HTMLSTART-->");
                                     int nutritionHTMLEndIndex = merlinResponse.indexOf("<!--NUTRITION_HTMLEND-->");
                                      
                                     int buildXmlStartIndex = merlinResponse.indexOf("<!--BUILD_XMLSTART-->");
                                     int buildXmlEndIndex = merlinResponse.indexOf("<!--BUILD_XMLEND-->");
                                     int buildHTMLstartIndex = merlinResponse.indexOf("<!--BUILD_HTMLSTART-->");
                                     int buildHTMLEndIndex = merlinResponse.indexOf("<!--BUILD_HTMLEND-->");
                              
                                     nutritionInfoFromMerlin = merlinResponse.substring(nutritionXmlStartIndex + "<!--NUTRITION_XMLSTART-->".length(), nutritionXmlEndIndex);
                                     log.error("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
                                     log.error("********************************************************************************* nutritionInfoFromMerlin (XML) " + nutritionInfoFromMerlin);
                                     buildInfoFromMerlin = merlinResponse.substring(buildXmlStartIndex + "<!--BUILD_XMLSTART-->".length(), buildXmlEndIndex);
                                     log.error("********************************************************************************* buildInfoFromMerlin (XML) " + buildInfoFromMerlin);
                                     lastReplicationAction = currentProductPage.getProperties().get("cq:lastReplicationAction","");
                                     if((nutritionInfoFromMerlin.contains(menuId)|| buildInfoFromMerlin.contains(menuId))){
                                         if(!"".equals(lastReplicationAction)){
                                             lastModifiedDate = currentProductPage.getProperties().get("cq:lastModified",Calendar.class);
                                             lastReplicatedDate = currentProductPage.getProperties().get("cq:lastReplicated",Calendar.class);   
                                             lastReplicatedTime = lastReplicatedDate!=null ? lastReplicatedDate.getTimeInMillis() : 0L;
                                             lastModifiedTime = lastModifiedDate!= null ? lastModifiedDate.getTimeInMillis() : 0L;
                                             if((lastReplicatedTime != 0L) && (lastModifiedTime != 0L)) {  
                                                 if((lastModifiedTime < lastReplicatedTime)) {                                                
                                                     pageIsActivated = true;
                                                    log.error("***************************************** The pageStatus was activated after modifying: " + pageIsActivated);
                                                   
                                                 }
                                             }                                                    
                                         } 
                                         if(!nutritionInfoPropertyValue.equals(nutritionInfoFromMerlin)){
                                             ipd.setPageProperty(currentProductPage, ProductConstant.Atom_MERLINNutritionInfoXML, nutritionInfoFromMerlin);
                                             nutritionHTMLString = merlinResponse.substring(nutritionHTMLStartIndex + "<!--NUTRITION_HTMLSTART-->".length(), nutritionHTMLEndIndex);
                                             log.error("********************************************************************************* nutritionHTMLString (HTML) " + nutritionInfoFromMerlin);
                                             ipd.setPageProperty(currentProductPage, ProductConstant.Atom_MERLINNutritionInfoXSLT, nutritionHTMLString);
                                             currentProductPageNode.setProperty("cq:lastModified", Calendar.getInstance());
                                         }
                                         if(!buildInfoInfoPropertyValue.equals(buildInfoFromMerlin)){
                                             ipd.setPageProperty(currentProductPage, ProductConstant.Atom_MERLINProductBuildXML, buildInfoFromMerlin);
                                             buildInfoHTMLString = merlinResponse.substring(buildHTMLstartIndex + "<!--BUILD_HTMLSTART-->".length(), buildHTMLEndIndex);
                                             log.error("********************************************************************************* buildInfoHTMLString (XML) " + buildInfoHTMLString);
                                             ipd.setPageProperty(currentProductPage, ProductConstant.Atom_MERLINProductBuildXSLT, buildInfoHTMLString);
                                             ipd.setPageProperty(currentProductPage, ProductConstant.Atom_MERLINNutritionInfoXSLT, nutritionHTMLString);
                                             currentProductPageNode.setProperty("cq:lastModified", Calendar.getInstance());
                                         }
                                         if(pageIsActivated){
                                            log.error("***************************************** The page is being activated");
                                            ipd.activatePage(currentProductPage);
                                         }
                                     }
                                 } else {
                                /*
                                 * The menu ITEM ID did not match with the one contained in 
                                 * Nutrition or Build Info returned by MERLIN web-service
                                 */
                                log.error("Exception in scanpages() method >>> Either could not connect to merlin webservice or the menu Item ID did not match: " + currentProductPage.getTitle());
                                pageMap.put(currentProductPage.getPath(),currentProductPage.getTitle());
                                log.error("Page path and title added to the hashmap ************************ " + currentProductPage.getTitle() );
                                
                              }
                         }
                     } catch(Exception exception){
                         log.error("Error in scanPages() method !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" + exception.getMessage());
                         if(isMaster){
                             sendExceptionMail(exception);
                         }    
                     }
                 }
                 if(!pageMap.isEmpty()){
                     log.error("*********** Sending right mail for merlin exception *************");
                     if(isMaster){
                         sendMerlinExceptionMail(pageMap);
                         log.error(" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1 Mail Send for merlin web-service connection");
                     }    
                 }
                 
             }
  
         }
             
         public String callURL(String strUrl)  throws IOException
         { 
             StringBuffer sBuffer = new StringBuffer();
             try
             {                    
                 url = new URL(strUrl);
                 log.error("*******************************The final url being used to connect to merlin is: " + url );
                 connection = url.openConnection();
                 
                 in = connection.getInputStream();
                 res = new BufferedReader(new InputStreamReader(in, "UTF-8"));
                 
                 String inputLine;
                 while ((inputLine = res.readLine()) != null)
                 {
                     sBuffer.append(inputLine);
                 }
             }
             catch(Exception ex)
             {
                ex.printStackTrace();
             }
             finally
             {
                if(res != null)
                    res.close();
                if(in != null)
                    in.close();
                connection = null;
             }       
             
             return sBuffer.toString();
         }
         
        /*
         * Method for sending mail if any exception has occurred. 
         */
        
        
        public void sendExceptionMail(Exception exception)
        {
            try
            {
                java.util.Properties mailConfigProp = PropertiesLoader.loadProperties("mailgmt.properties", "/app/mcd/cms/fs05/wcm1_auth_prod/crx-quickstart/server/files/"); 
                MailNotification mailNotification = new MailNotification();
                StringWriter sw = new StringWriter();
                exception.printStackTrace(new PrintWriter(sw));
                mailNotification.sendExceptionEmail(mailConfigProp.getProperty("toExceptionAddress"), mailConfigProp.getProperty("exceptionSubject"), sw.toString(), mailConfigProp.getProperty("mailServer"), mailConfigProp.getProperty("fromAddress"), mailConfigProp.getProperty("fromAddressPersonal"));
            }
            catch(Exception ex)
            {
                log.error(ex.getMessage());
            }
        }
         /*
          * Method for sending mail if merlin webservice couldn't get connected
          *  
          */   
        
        public void sendMerlinExceptionMail(Map <String, String> pageHashMap)
        {
            try 
            {
                log.error("************************************************* Inside sendMerlinExceptionMail of GMSScheduledJob class ");
                java.util.Properties mailConfigProp = PropertiesLoader.loadProperties("mailgmt.properties","/app/mcd/cms/fs05/wcm1_auth_prod/crx-quickstart/server/files/"); 
                MailNotification mailNotification = new MailNotification();
                String mailBody="Error occured in connecting the Merlin webservice for the follwoing pages : <br>";
                log.error("******* Mail Body ***********" + mailBody);
                Set set= pageHashMap.keySet(); 
                Iterator iter = set.iterator (); 
                int errorPageCount=1;
                log.error("*********** Before Going into Loop ***********");
                while(iter.hasNext()){  
                    String key=(String)iter.next();  
                    log.error("************* Page Hash Map ******************"+pageHashMap.get(key));   
                    mailBody+=errorPageCount+". <B>"+pageHashMap.get(key)+"</B> with path <B>"+key+ " </B><BR>";
                    errorPageCount++;
                }  
               mailNotification.sendExceptionEmail(mailConfigProp.getProperty("toExceptionAddress"), mailConfigProp.getProperty("exceptionMerlinSubject"),mailBody, mailConfigProp.getProperty("mailServer"), mailConfigProp.getProperty("fromAddress"), mailConfigProp.getProperty("fromAddressPersonal"));
            }
            catch(Exception ex)
            { 
                log.error(ex.getMessage());
            } 
        }
        
        
         public void bindRepository(String repositoryId, String clusterId, boolean isMaster) {
        //log.error("Bound to Repository {} Node {} (Cluster: {})",new Object[] { (isMaster ? "Master" : "Slave"), repositoryId, clusterId });
        //log.error("******* Is Master Value ********" + isMaster);
            this.isMaster = isMaster;
        }
         
        public void unbindRepository() {
            log.info("No Repository is bound or Repository is unbound in ClusterService");
        }
}   
// end class 
 