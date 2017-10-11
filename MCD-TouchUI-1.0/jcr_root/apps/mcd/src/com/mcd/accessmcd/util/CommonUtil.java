package com.mcd.accessmcd.util;

/**
 * This is a Common Utility Class
 *
 * @author 
 * @version 1.0
 *
 */  
 
 
import com.mcd.accessmcd.common.Constants;
import java.util.StringTokenizer;
import com.mcd.util.PropertiesLoader;
import java.util.Properties; 
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.day.cq.security.User; 
import com.day.cq.wcm.api.Page; 
import java.util.*;
import com.opensymphony.oscache.base.NeedsRefreshException;
import com.opensymphony.oscache.general.GeneralCacheAdministrator;
import com.mcd.util.CacheUtil;
import javax.servlet.http.HttpSession;
import java.net.URL;
import javax.servlet.http.HttpServletRequest;
import com.day.cq.i18n.I18n;
import org.apache.sling.api.SlingHttpServletRequest;

import com.mcd.accessmcd.common.helper.PropertyHelper;
import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;
import org.apache.sling.api.resource.ResourceResolver;
import javax.jcr.Node;
public class CommonUtil {
    
    private static final Logger log;
    private static final HashMap audienceTypeMap;
    private static final HashMap entityNameMap;
    private static String entityHandle = "";
    private static String entityName = "";
    private final static String REGION_PROPERTY_FILE_NAME="regioninfo.properties";
    private static GeneralCacheAdministrator admin = null;
    
    static {
        log = LoggerFactory.getLogger(CommonUtil.class);
        
        entityNameMap = new HashMap();
        entityNameMap.put(Constants.ENTITY_NAME_GLOBAL, "Global");
        entityNameMap.put(Constants.ENTITY_NAME_UNITEDSTATES, "U.S.");
        entityNameMap.put(Constants.ENTITY_NAME_AUSTRALIA, "AUSTRALIA");        
        entityNameMap.put(Constants.ENTITY_NAME_JAPAN, "JAPAN");
        entityNameMap.put(Constants.ENTITY_NAME_NEWZEALAND, "NEW ZEALAND");
                        
        audienceTypeMap = new HashMap();
        audienceTypeMap.put(Constants.AUDIENCE_TYPE_LIST[0], "DEFAULT-Employee");
        audienceTypeMap.put(Constants.AUDIENCE_TYPE_LIST[1], "DEFAULT-McOpCo_Restaurant_Mgr");
        audienceTypeMap.put(Constants.AUDIENCE_TYPE_LIST[2], "DEFAULT-Franchisee");
        audienceTypeMap.put(Constants.AUDIENCE_TYPE_LIST[3], "DEFAULT-Franchisee_Restaurant_Mgr");
        audienceTypeMap.put(Constants.AUDIENCE_TYPE_LIST[4], "DEFAULT-Crew");
        audienceTypeMap.put(Constants.AUDIENCE_TYPE_LIST[5], "DEFAULT-Supplier_Vendor");
        audienceTypeMap.put(Constants.AUDIENCE_TYPE_LIST[6], "DEFAULT-Support_Partners");
        audienceTypeMap.put(Constants.AUDIENCE_TYPE_LIST[7], "DEFAULT-Agency");
        audienceTypeMap.put(Constants.AUDIENCE_TYPE_LIST[8], "DEFAULT-Franchisee_Office_Staff");
    } 
     
    /**
    * getDefaultLocation
    * @param DeliveryHttpServletRequest cqReq
    * @return url
    **/
    public String getDefaultHomePage(User user) throws Exception {
                
        String MCDUSA = "McDonald's USA, LLC";
        String url = "";
        String error_url = "";
        String globalPath = "";
        String usPath = "";
        String japanPath = "";
        String australiaPath = "";  
        String nzPath = "";    
        String audienceType="";   
        String mcwebPath =  "";
        
        try {
			/* After Upgrade Change Start */

            //Properties properties = PropertiesLoader.loadProperties("common.properties");

            Properties properties = PropertiesLoader.loadProperties("com/mcd/util/common.properties");

            /* After Upgrade Change End */

            error_url = properties.getProperty("errorPath");
            globalPath = properties.getProperty("corp");
            usPath = properties.getProperty("us");
            japanPath = properties.getProperty("japan");
            australiaPath = properties.getProperty("au");
            nzPath = properties.getProperty("nz");
            mcwebPath = properties.getProperty("mcweb");

            
        } catch(Exception e) {
        }
        try {                     
                //get the location value
                String locality = user.getProperty("rep:location");
                   audienceType = user.getProperty("rep:mcdAudience");  
                //country code added 4/22/17 ECW
                String countrycode = "";
                countrycode=user.getProperty("rep:country");
                if (countrycode==null) countrycode="";
                //if can't get the value
                if (locality == null || "".equals(locality)) {
                    url = error_url;
                } else {             

                    //get company type 
                    String companyType = user.getProperty("CompanyType");

                    if (companyType==null) companyType="";
                                    
                    // split it into 2 parts delimited by :
                    // first part is country and second part is region
                    StringTokenizer strTokens = new StringTokenizer(locality, ":");
                    String country, region;
                    country = region = "";
                    if(strTokens.hasMoreTokens())
                        country = strTokens.nextToken();
                    if(strTokens.hasMoreTokens()) 
                        region = strTokens.nextToken();
                    if(countrycode.equals("CA"))country="Canada";    
                    //remove leading space
                    region = region.replaceAll("^\\s", ""); 

    				log.info("Landing page: Country.." + country.trim()+",Region.." + region.trim());

                    // if locality is United States : oakbrook then corp vp otherwise us vp
                    // if country part in locality is Japan then japan vp
                    // if country part in locality is australia then au vp
                    // else corp ... this is the default virtual portal
                    if("United States".equalsIgnoreCase(country.trim())) { 
                        if(("oak brook".equalsIgnoreCase(region.trim()))&&(!MCDUSA.equalsIgnoreCase(companyType))){
                            url = globalPath;
                            //log.info("[$$$ Region.." + region.trim());
                            //log.error("[$$$ Company.." + companyType.trim());
                            }
                        else
                           { 

                            url = usPath;
                            //log.info("[$$$ US PATH.." + url);
                           }
                    }
                   else if("Japan".equalsIgnoreCase(country.trim())) 
                            url = japanPath;
                   else if("Canada".equalsIgnoreCase(country.trim())) 
                            url = mcwebPath;
                    else if("Australia".equalsIgnoreCase(country.trim())) {
                        //get mcdAudiendeType
                        audienceType = user.getProperty("rep:mcdAudience"); 
                                                
                        if (("CorpEmployees".equalsIgnoreCase(audienceType.trim())) || ("Franchisees".equalsIgnoreCase(audienceType.trim())))
                            url = australiaPath;
                        else                    
                            url = globalPath; 
                    } else if("New Zealand".equalsIgnoreCase(country.trim())) {
                        //get mcdAudiendeType
                       audienceType = user.getProperty("rep:mcdAudience"); 
                                                
                        if (("CorpEmployees".equalsIgnoreCase(audienceType.trim())) || ("Franchisees".equalsIgnoreCase(audienceType.trim())))
                            url = nzPath;
                        else                    
                            url = globalPath; 
                    } else { 
                            url = globalPath;  
                            log.info("[$$$ Default Path.." + url);
                            }
                }//end of else
                    
        } catch (Exception e) {
            log.error("[CommonUtil.getDefaultHomePage]:Exception in getDefaultHomePage: " + e);
            throw new Exception("[CommonUtil.getDefaultHomePage]:Exception in getDefaultHomePage: " + e);
        }
         
     // Changed for appending the audience type in url    
        audienceType = getAlias(audienceType);
      
        return (url + "." + audienceType);
        
        // return url;
    }       
    
    /**
    * getTitle
    * @param Page page
    * @return title
    **/
    
    public String getTitle(Page page) throws Exception {
         
        String title = "";        
        title = page.getNavigationTitle();
        if (title == null || title.equals("")) {
           title = page.getPageTitle();
        }
        if (title == null || title.equals("")) {
           title = page.getTitle();
        }
        if (title == null || title.equals("")) {
           title = page.getName(); 
        }
          
        return title;
    } 
    
    public static HashMap getAudienceType()
    {
      return audienceTypeMap;
    }     
    
        public String getValidURL(String url)
     {
       
       if(!checkInternalLink(url.trim())){
          return url;
       }
       
       String validURL = "";
       String tempurl="";
       String queryStr="";
       if(url.contains("?")){
                             queryStr=url.substring(url.lastIndexOf("?"));
                            url=url.substring(0, url.lastIndexOf("?"));
                               
                             }
       if(url.contains("#")){
                 url=url.replaceAll("#","");
              }
              if((url==null)||(url.trim().equals(""))){
                  return url;
              }

       
       while(url.lastIndexOf("/")+1==(url.length())){
                     url=url.substring(0,(url.length()-1));
       }
       
       
       
       
       
       try{     
           if(url.startsWith("http://")){
                URL url_1 = new URL(url);
                String starturl = "http://"+url_1.getHost();
                 tempurl= url.substring(starturl.length());
                 System.out.println();
              System.out.println(url.length());
                 if( url.lastIndexOf(".html") <0 && url_1.getHost().length()+7!=url.length()) {
                   url=url+".html";
                }
                 
            }else if(url.startsWith("https://")){
                URL url_1 = new URL(url);
                String starturl = "https://"+url_1.getHost();
                 tempurl= url.substring(starturl.length());

              if( url.lastIndexOf(".html") <0 && url_1.getHost().length()+8 !=url.length()) {
                 url=url+".html";
              }
 
           } else if(url.contains("/")){
                                             String uArr[]=url.split("/");
                       if(uArr.length>1){
                         if( url.lastIndexOf(".html") <0 ) {
                            url=url+".html";
                         }
                       }
                   }
         }catch (Exception e){
         System.out.println("Exception caught ="+e.getMessage());
         }
      
       validURL =url+queryStr;
       return validURL;
     }
    public String getValidURL(String url,String aud)
  {
   if(url.contains("#")){
          url=url.replaceAll("#","");
   }
   String validURL = "";
   String alias = getAlias(aud);
   if(url.indexOf(".html") < 0 ) {
    validURL = url +"." +alias + ".html";
   } else
   { 
     url =  url.replace(".html","");
     validURL = url +"." +alias + ".html";
   } 
   return validURL;  
 } 
    
    
  public boolean checkInternalLink(String url)
  {
     boolean internal=false;
     if((url.trim()).equals("#") || url.startsWith("/") )
        return true;
     else
        { try{
              /* After Upgrade Change Start */

              //Properties properties = PropertiesLoader.loadProperties("common.properties");

              Properties properties = PropertiesLoader.loadProperties("com/mcd/util/common.properties");

              /* After Upgrade Change End */

              String internalDomains= properties.getProperty("domainNames");
              String[] domainNames =  internalDomains.split(",");                              
              if(url.startsWith("http://") || url.startsWith("https://")){
                    URL url_1 = new URL(url);
                    String hostname = url_1.getHost();
                     for(int i = 0 ; i < domainNames.length ; i++){                        
                        if(hostname.startsWith(domainNames[i].trim())){ 
                         internal=true;break;}
                      }
          
                }
            }catch(Exception e){}
        }
        return internal;

     
   }  


  public boolean isInternalLink(String url)
  {

     if(url.startsWith("/content") || url.startsWith("\\content") || url.startsWith("content/") || url.startsWith("content\\") )
        return true;
     else
      return false;

     
   }  
    public static boolean isInternalLink(String url,HttpServletRequest request)

    {
    
        StringBuffer hosturl=request.getRequestURL();
        String u=hosturl.toString();

        boolean internal = false;
        if (url.indexOf("\\") >= 0)
            u = url.replaceAll("\\\\", "/");
        


       if (!url.startsWith("http://") && !url.startsWith("https://")) {
      
           if(url.startsWith("/content") || url.startsWith("\\content") || url.startsWith("content/") || url.startsWith("content\\") )
              return true;
      
       }



        if (u.indexOf("\\") >= 0)
            u = u.replaceAll("\\\\", "/");
        String host = "";
        String hostStr = "";

        if (u.startsWith("http://") || u.startsWith("https://")) {
            String p = "";
            if (u.indexOf("http://") == 0) {
                p = "http://";
                u = u.substring(7);
            }
            if (u.indexOf("https://") == 0) {
                p = "https://";
                u = u.substring(7);
            }

            int index = u.indexOf("/");
            if (index >= 0) {
                host = u.substring(0, index);
            }
            hostStr = p + host;
            if (url.toLowerCase().trim().startsWith(hostStr.toLowerCase().trim()))
                internal = true;
        } 
       

        return internal;
    }
    
    public HashMap getRegions() throws Exception
    {
        log.debug("Entered into the CommonUtil--> getRegions() method");
        
        HashMap regionMap = new LinkedHashMap();
        String key=null;
        String value=null;
        String[] arrValue= new String[2];
        
        try{
        
            admin = CacheUtil.getInstance();
            regionMap = (HashMap) admin.getFromCache("REGION_CACHE_KEY");
            log.debug("Regions data is available in Cache:::::::::: ");
            
        } 
        catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
                 
            //ResourceBundle rb = ResourceBundle.getBundle(CommonUtil.REGION_PROPERTY_FILE_NAME);

            /* After Upgrade Change Start */

            //Properties rb = PropertiesLoader.loadProperties(CommonUtil.REGION_PROPERTY_FILE_NAME);

            Properties rb = PropertiesLoader.loadProperties("com/mcd/util/"+CommonUtil.REGION_PROPERTY_FILE_NAME);

			/* After Upgrade Change End */

            for (Enumeration e = rb.keys();e.hasMoreElements();){
                key=(String)e.nextElement();
                value=rb.getProperty(key);
                arrValue=value.split(",");
                regionMap.put(arrValue[1],arrValue[0]);
            }
            
            List mapKeys = new ArrayList(regionMap.keySet());
            List mapValues = new ArrayList(regionMap.values());
            regionMap.clear();          
            TreeSet sortedSet = new TreeSet(mapValues);         
            Object[] sortedArray = sortedSet.toArray();
            int size = sortedArray.length;
            for (int i=0; i<size; i++)
            {             
              regionMap.put(mapKeys.get(mapValues.indexOf(sortedArray[i])), sortedArray[i]);
            }           
            
            admin.putInCache("REGION_CACHE_KEY", regionMap);
            log.debug("after putting Regions Data in cache:::::::::: ");            
        }
        catch (Exception e) {

            log.error(" Error while Fatching data  " + e.getMessage());
            throw new Exception(" Error while Fatching data " + e.getMessage());
        }   
        
        log.debug("Exiting from the CommonUtil--> getRegions() method");
        return regionMap;
    }
    /**
     * This method reads Entity Handle of current entity from properties file 
     *
     * @param session
     *
     * @return Returns the entityHandle
     */ 
    public String getEntityHandle(HttpSession session) {
    
        String currentEntityHandle = null;
        String currentEntityName = getEntityName(session);
        
        currentEntityHandle = PropertyHelper.getPropValue(Constants.GLOBAL_PROPERTIES_FILE,(currentEntityName.replaceAll(" ","")));
    
    
        return currentEntityHandle;     
    }
    
    
    /**
     * This method reads Entity attribute from session. In case it is not set up,
     * it returns default entity name.
     *
     * @param session
     *
     * @return Returns the entityName
     */
    public String getEntityName(HttpSession session) {
    
        String currentEntityName = null;
        
        if((session.getAttribute(Constants.ENTITY_SESSION_ATTRIBUTE)!=null)) {
            currentEntityName = (String)session.getAttribute(Constants.ENTITY_SESSION_ATTRIBUTE);
        } else {        
            currentEntityName = Constants.DEFAULT_ENTITY_NAME;
        }
        
        return currentEntityName;       
    }
        
        
     /* Method return the Alias of the Audience Type Provided */
     
     public String getAlias(String audType)
     {
       String alias = "";
        try {
            /* After Upgrade Change Start */

            //Properties properties = PropertiesLoader.loadProperties("common.properties");
        
            Properties properties = PropertiesLoader.loadProperties("com/mcd/util/common.properties");
        
            /* After Upgrade Change End */

            alias = properties.getProperty(audType);
            if(alias != null)
            {
              return alias;
            }
            else
            {
              alias="";
            }
            }
         catch(Exception e) {
        }
       return alias;
     }
     
     
     
         
     /* Method return the Audience Type of the Alias Provided */
     
     public String getAudienceFromAlias(String alias)
     {
       String audType = "";
        try {
            /* After Upgrade Change Start */

            //Properties properties = PropertiesLoader.loadProperties("common.properties");
        
            Properties properties = PropertiesLoader.loadProperties("com/mcd/util/common.properties");
        
            /* After Upgrade Change End */

            audType = properties.getProperty(alias);
            if(audType != null)
            {
              return audType ; 
            }
            else
            {
              audType ="";
            }
            }
         catch(Exception e) {
        }
       return audType ;
     }
     
        
    public String checkI18Message(String key, String defaultMessage,I18n langText){
        if (key.equals(langText.get(key))){
            return defaultMessage;
        }
        else{        
            return langText.get(key);
        }
    }
    public String checkI18Message(String key, String comments, Object args, String defaultMessage,I18n langText){    
        if (key.equals(langText.get(key,comments,args))){
            return defaultMessage;
        }
        else{        
            return langText.get(key,comments,args);
        }
    }
        

 
  /* GCD Print*/
 
public StringBuffer getQueryParameter(HttpServletRequest request,Enumeration requestParameters)
{
 StringBuffer queryParameter=new StringBuffer("?");
             
             while (requestParameters.hasMoreElements()) {
                String element = (String) requestParameters.nextElement();
                String value = request.getParameter(element);
                if (queryParameter.length()==1){
                    queryParameter.append(element+"="+value);
                    
                }
                else{
                    queryParameter.append("&"+element+"="+value);
                    
                }
                
             }
             if(queryParameter.length()==1){
                 queryParameter=new StringBuffer("");
             } 
             return queryParameter;
            
}



public ArrayList getSiteOwner(String path,ResourceResolver resourceResolver)
{
 
     ArrayList siteOwnerData=new ArrayList();
     String siteOwnerName = ""; 
     String siteOwnerEmail = "";  
     String parentPath=path;
     String filepath="";
     if(resourceResolver.getResource(parentPath) != null ){

                 Node    page1 = resourceResolver.getResource(parentPath).adaptTo(Node.class);
                 Node    temppage1 = resourceResolver.getResource(parentPath+"/jcr:content").adaptTo(Node.class);

                 try{
                          do {
           
                               if(temppage1.hasProperty("siteOwnerName") && temppage1.hasProperty("siteOwnerEmail"))
                                {
                     
                                    siteOwnerName= temppage1.getProperty("siteOwnerName").getString(); 
                                    siteOwnerEmail= temppage1.getProperty("siteOwnerEmail").getString(); 
                                    filepath=parentPath;  
                                    if(!siteOwnerName.trim().equalsIgnoreCase("")){
                                                     break;
                                     }      
                                 } 
                                  
                                  try{
                                          parentPath = page1.getParent().getPath();
                                          page1 = resourceResolver.getResource(parentPath).adaptTo(Node.class);
                                          temppage1 = resourceResolver.getResource(parentPath+"/jcr:content").adaptTo(Node.class);
                                      }catch(Exception e){break;}


                           }while(parentPath!=null); 

              
                }catch(Exception e){
                    log.error(e.getMessage());
                }

     siteOwnerData.add(siteOwnerName);
     siteOwnerData.add(siteOwnerEmail);
     siteOwnerData.add(filepath);

   }else{ siteOwnerData=null; }

 return siteOwnerData; 
 
}



public void setSiteOwner(String path,  String prevSiteOwnerName, String newSiteOwnerName, String newSiteOwnerEmail, ResourceResolver resourceResolver)
{
     String siteOwnerName = ""; 
     String siteOwnerEmail = "";  
     
     ArrayList siteOwnerData =  this.getSiteOwner(path,resourceResolver); 
     
  
    if(siteOwnerData  != null ){
    
                try{

                         Node    temppage1 = resourceResolver.getResource(siteOwnerData.get(2)+"/jcr:content").adaptTo(Node.class);
                                                   
                           if(temppage1.hasProperty("siteOwnerName") ){
                                 siteOwnerName= temppage1.getProperty("siteOwnerName").getString(); 
                                 siteOwnerEmail= temppage1.getProperty("siteOwnerEmail").getString(); 
                
                                 if(siteOwnerName.toLowerCase().trim().equals(prevSiteOwnerName.toLowerCase().trim())){
                                        temppage1.setProperty("siteOwnerName",newSiteOwnerName);
                                        temppage1.setProperty("siteOwnerEmail",newSiteOwnerEmail);
                                        temppage1.save();
                                  }
                            } 
            
                                               
                }catch(Exception e){log.error(e.getMessage());}

           }

}


public int getPageStatus(String alternatePath,SlingHttpServletRequest slingRequest ){
      
      int PATH_DOESNT_EXIST=0; 
      int PATH_EXIST=1;
      int PAGE_ACTIVE=2;
      int status=-2;  
                   
         try{           
              if(slingRequest.getResourceResolver().getResource(alternatePath+"/jcr:content")!=null){                   
                     Node pageNode = slingRequest.getResourceResolver().getResource(alternatePath+"/jcr:content").adaptTo(Node.class);
                           if(pageNode.hasProperty("cq:lastReplicationAction")){
                                String propValue = pageNode.getProperty("cq:lastReplicationAction").getString();
                                      if(propValue.equalsIgnoreCase("activate")){
                                               status=PAGE_ACTIVE;
                                      }
                                      else{
                                               status=PATH_EXIST;
                                      }
                            } 
                           
                } else{status=PATH_DOESNT_EXIST;}                       
             }catch(Exception e){}                                  
      return status;         
}


}




