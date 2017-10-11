/**
 * 
 */
  
package com.mcd.accessmcd.ace.manager;

import java.util.Properties;
import java.util.Enumeration;
import com.mcd.accessmcd.ace.bo.ACEConfigDataBean;
import java.util.Calendar;
import javax.jcr.Node;
import com.mcd.accessmcd.usermanagement.user.manager.UserMaintenanceManager;
import com.mcd.accessmcd.usermanagement.user.bo.UserDataBean;
import com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.*;
import org.apache.sling.scripting.core.ScriptHelper;
import org.apache.sling.api.scripting.SlingScriptHelper;
import javax.jcr.Session;
import com.mcd.accessmcd.ace.util.PropertiesLoader; 
import com.mcd.accessmcd.ace.exceptions.NoMembersInGroup;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author mc23284  
 *
 */
public class ACEManager {
    
    private Properties aceProperties;   
    private static final Logger log = LoggerFactory.getLogger(ACEManager.class);
    
    /**
     * constructor for reading the properties file from server files
     */                       
    public ACEManager() {
        super();
        java.io.FileInputStream fis = null;
        try{            
            fis = new java.io.FileInputStream(new java.io.File(getServerFilesPath()+ getAcePropFile()));
            java.util.Properties props = new java.util.Properties();
            props.load(fis);
            fis.close();
            this.aceProperties = props;
            //System.out.println("[ACEManager] Constructor-- aceProperties :"+ aceProperties);
            
        } catch(Exception e) {
            log.error("[ACEManager] Constructor-- Exception :"+e.getMessage());
            e.printStackTrace();
        }finally {
           try {
               //need to check for null 
               if ( fis != null ) 
                    fis .close();
               }catch(Exception ei){
                      log.error("ACEManager Problem occured. Cannot close reader "+ei.getMessage());
               }
       }

    }
    
   public String getAcePropFile(){
        String acePropFile = PropertiesLoader.getProperty("acePropFile"); 
        return acePropFile;
   }
   public String getAceRootSite(){
        String aceRootSite = PropertiesLoader.getProperty("aceRootSite");
        return aceRootSite;
   }
   public String getDefaultACESiteKey(){
        String defaultACESiteKey = PropertiesLoader.getProperty("defaultACESiteKey");
        return defaultACESiteKey;
   }
   public String getServerFilesPath(){
        String serverFilesPath = PropertiesLoader.getProperty("serverFilesPath");
        return serverFilesPath;
   }
   public String[] getSkipNodes(){
       String skipNodesTemp = PropertiesLoader.getProperty("skipNodes");
       String[] skipNodes = skipNodesTemp.split(",");
       return skipNodes;
   }
   public String[] getExcludeSites(){
       String excludeSitesTemp = PropertiesLoader.getProperty("excludeSites");
       String[] excludeSites = excludeSitesTemp.split(",");
       return excludeSites;
   }
    /**
     * @param properties
     */
    public ACEManager(Properties properties) {
        super();
        this.aceProperties = properties;
    }   
    
    // returns defaultACESiteKey if no relevant key is found
    public String getACESitePageKey(String pageURL,Boolean checkForParent){
        String sitePageURL = pageURL;
        Boolean keyExists = false;
        
        try {       
            if (sitePageURL.startsWith(getAceRootSite())){
//                System.out.println("[ACEManager] getACESitePageKey()-- key:"+sitePageURL);
                    
                // check sitePageURL in properties file
                keyExists = aceProperties.containsKey(sitePageURL);
                
                if(!(keyExists) && checkForParent){
                    // code to look for parent site nodes
                    // int i=0;
                    while (!(keyExists) && !(sitePageURL.equals(getAceRootSite()))){                     
//                        System.out.println("[ACEManager] getACESitePageKey()-- Key not found. Looking for Parent nodes....");                     
                        // get 1 level up parent node
                        if(sitePageURL.lastIndexOf("/")!=-1){
                            sitePageURL = sitePageURL.substring(0, sitePageURL.lastIndexOf("/"));       
//                            System.out.println("[ACEManager] getACESitePageKey()-- "+i++ + " Key:"+sitePageURL);
                            
                            // check sitePageURL in properties file
                            keyExists = aceProperties.containsKey(sitePageURL); 
                        }else {
                            keyExists = false;
                            break;
                        }               
                    }
                }   
            } else {
                log.error("[ACEManager] getACESitePageKey()-- Invalid Key");
            }
        } catch (Exception e){
            log.error("[ACEManager] getACESitePageKey()-- Exception:"+e.getMessage());
            e.printStackTrace();
        }
        
        if(keyExists)
            return sitePageURL;
        else 
            return getDefaultACESiteKey();                
    }

    public ACEConfigDataBean getACEConfigBean (String sitePageKey){
        //System.out.println("[ACEManager] getACEConfigBean()-- key:"+sitePageKey); 
        ACEConfigDataBean  siteACEBean = new ACEConfigDataBean();
        try {
            if(aceProperties.containsKey(getDefaultACESiteKey())){
                // get default ace values 
                String defaultKeyValue = aceProperties.getProperty(getDefaultACESiteKey(), ""); 
                String[] defaultAceValues = defaultKeyValue.split(",");
                
                String sitePageKeyValue = defaultKeyValue;
                
                if( (sitePageKey.startsWith(getAceRootSite())) && (aceProperties.containsKey(sitePageKey))){
                    sitePageKeyValue = aceProperties.getProperty(sitePageKey, "");       
                      //System.out.println("[ACEManager] getACEConfigBean()-- sitePageKeyValue : "+sitePageKeyValue);                 
                } else {
                    sitePageKey = getDefaultACESiteKey();
                      //System.out.println("[ACEManager] getACEConfigBean()-- sitePageKeyValue [Else]: "+sitePageKeyValue);
                }
                
                String[] aceValues = sitePageKeyValue.split(",");
                
                //populate bean
                siteACEBean.setSiteURL(sitePageKey);                
                siteACEBean.setGroupName( ((aceValues.length>0)?aceValues[0]:defaultAceValues[0]) );
                siteACEBean.setAuthDomainAdd( ((aceValues.length>1)?aceValues[1]:defaultAceValues[1]) );
                siteACEBean.setPubDomainAdd( ((aceValues.length>2)?aceValues[2]:defaultAceValues[2]) );
                siteACEBean.setExpirePeriod( ((aceValues.length>3)?aceValues[3]:defaultAceValues[3]) );
                siteACEBean.setDateFormat( ((aceValues.length>4)?aceValues[4]:defaultAceValues[4]) );
                siteACEBean.setLanguage( ((aceValues.length>5)?aceValues[5]:defaultAceValues[5]) );
                                
                // populate in bean with Empty values
                String adminNames = "Judy";
                String nonAdminNames = "Judy";
                String adminMailIds = "judy.zhang@us.mcd.com";
                String nonAdminMailIds = "judy.zhang@us.mcd.com";
                                                
                siteACEBean.setAdminNames(adminNames);
                siteACEBean.setNonAdminNames(nonAdminNames);
                siteACEBean.setAdminMailIds(adminMailIds);
                siteACEBean.setNonAdminMailIds(nonAdminMailIds);
            }else{
                // error message --- root entry missing in config file
                log.error("[ACEManager] getACEConfigBean()-- Error: Root entry missing in config file");
            }
            
        } catch (Exception e){
            log.error("[ACEManager] getACEConfigBean()-- Exception:"+e.getMessage());
            e.printStackTrace();
        } 
        return siteACEBean;
    }
    
    public ACEConfigDataBean getACEConfigBean (String sitePageKey,ScriptHelper sling,Session session) throws Exception{
        //System.out.println("[ACEManager] getACEConfigBean()-- key:"+sitePageKey); 
        ACEConfigDataBean  siteACEBean = new ACEConfigDataBean();
        //try {
            if(aceProperties.containsKey(getDefaultACESiteKey())){
                // get default ace values 
                String defaultKeyValue = aceProperties.getProperty(getDefaultACESiteKey(), ""); 
                String[] defaultAceValues = defaultKeyValue.split(",");
                
                String sitePageKeyValue = defaultKeyValue;
                
                if( (sitePageKey.startsWith(getAceRootSite())) && (aceProperties.containsKey(sitePageKey))){
                    sitePageKeyValue = aceProperties.getProperty(sitePageKey, "");       
                      //System.out.println("[ACEManager] getACEConfigBean()-- sitePageKeyValue : "+sitePageKeyValue);                 
                } else {
                    sitePageKey = getDefaultACESiteKey();
                      //System.out.println("[ACEManager] getACEConfigBean()-- sitePageKeyValue [Else]: "+sitePageKeyValue);
                }
                
                String[] aceValues = sitePageKeyValue.split(",");
                
                //populate bean
                siteACEBean.setSiteURL(sitePageKey);                
                siteACEBean.setGroupName( ((aceValues.length>0)?aceValues[0]:defaultAceValues[0]) );
                siteACEBean.setAuthDomainAdd( ((aceValues.length>1)?aceValues[1]:defaultAceValues[1]) );
                siteACEBean.setPubDomainAdd( ((aceValues.length>2)?aceValues[2]:defaultAceValues[2]) );
                siteACEBean.setExpirePeriod( ((aceValues.length>3)?aceValues[3]:defaultAceValues[3]) );
                siteACEBean.setDateFormat( ((aceValues.length>4)?aceValues[4]:defaultAceValues[4]) );
                //System.out.println("****** Language In ACE Manager ******" + aceValues[5]);
                siteACEBean.setLanguage( ((aceValues.length>5)?aceValues[5]:defaultAceValues[5]) );
                
                String adminNames = ""; //"Judy,Shubhra";
                String nonAdminNames = ""; //"Shubhra";
                String adminMailIds = "" ; //"judy.zhang@us.mcd.com,shubhra.agarwal@us.mcd.com";
                String nonAdminMailIds = ""; //"shubhra.agarwal@us.mcd.com";
                String seperator = "";
                                
                    //System.out.println("[ACEManager] getACEConfigBean(a,b,c)-- sling:"+sling);         
                    //System.out.println("[ACEManager] getACEConfigBean(a,b,c)-- session:"+session);
                                    
                /*UserMaintenanceManager usrMgr = new UserMaintenanceManager((SlingScriptHelper)sling,session);
                   // System.out.println("[ACEManager] getACEConfigBean(a,b,c)-- usrMgr: "+usrMgr);
                    
                //check if group id is valid
                GroupDataBean grpData = usrMgr.getGroupDetails(siteACEBean.getGroupName());
                // check if group has any members                                                
                int grpMembersSize = usrMgr.getGroupMembersSize(siteACEBean.getGroupName());
                if(grpMembersSize == 0){
                  throw new NoMembersInGroup(siteACEBean.getGroupName());
                }                                                
                    //System.out.println("[ACEManager] getACEConfigBean(a,b,c)-- 2");
                // Get Admin members
                seperator = "";
                ArrayList<UserDataBean> adminsArrList = usrMgr.getAdminUsersForGroup(siteACEBean.getGroupName());
                Iterator i = adminsArrList.iterator();
                UserDataBean adminDataBean = null;                                                            
                while (i.hasNext()) {
                    adminDataBean = (UserDataBean)i.next();
                    adminNames = adminNames + seperator + adminDataBean.getFullName();
                    adminMailIds = adminMailIds + seperator + adminDataBean.getEmailId();
                    seperator = ",";
                }
                         //System.out.println("[ACEManager] getACEConfigBean(a,b,c)-- 3");                                      
                //Get Non Admin members
                seperator = "";
                ArrayList<UserDataBean> nonAdminsArrList = usrMgr.getNormalUsersForGroup(siteACEBean.getGroupName());
                Iterator j = nonAdminsArrList.iterator();
                UserDataBean nonAdminDataBean = null;                                                            
                while (j.hasNext()) {
                    nonAdminDataBean = (UserDataBean)j.next();
                    nonAdminNames = nonAdminNames + seperator + nonAdminDataBean.getFullName();
                    nonAdminMailIds = nonAdminMailIds + seperator + nonAdminDataBean.getEmailId();
                    seperator = ",";
                }
                        //System.out.println("[ACEManager] getACEConfigBean(a,b,c)-- 4");
                siteACEBean.setAdminNames(adminNames);
                siteACEBean.setNonAdminNames(nonAdminNames);
                siteACEBean.setAdminMailIds(adminMailIds);
                siteACEBean.setNonAdminMailIds(nonAdminMailIds);*/
                
            }else{
                // error message --- root entry missing in config file
                log.error("[ACEManager] getACEConfigBean(a,b,c)-- Error: Root entry missing in config file");
            } 
        /*                          
        } catch (Exception e){
            System.out.println("[ACEManager] getACEConfigBean(a,b,c)-- Exception: "+e.getMessage());
            e.printStackTrace();
        } 
        */
        //System.out.println("[ACEManager] getACEConfigBean(a,b,c)-- 5");
        return siteACEBean;
    }

     
    public Enumeration getAllSiteKeys(){
        return aceProperties.keys();
    } 
    public ArrayList getAOWList(ScriptHelper sling,Session session) throws Exception{
        UserMaintenanceManager usrMgr = new UserMaintenanceManager((SlingScriptHelper)sling,session);
        int grpMembersSize = usrMgr.getGroupMembersSize("AOW-A-Admin");
        if(grpMembersSize == 0){
          throw new NoMembersInGroup("AOW-A-Admin");
        }
        
        //Get Admin members
        ArrayList<UserDataBean> adminsArrList = usrMgr.getAdminUsersForGroup("AOW-A-Admin");
        Iterator i = adminsArrList.iterator();
        UserDataBean adminDataBean = null; 
        ArrayList adminList = new ArrayList();                                                           
        while (i.hasNext()) {
            adminDataBean = (UserDataBean)i.next();
            adminList.add(adminDataBean.getEmailId().toLowerCase());
        }
        
        //Get Non Admin members
        ArrayList<UserDataBean> nonAdminsArrList = usrMgr.getNormalUsersForGroup("AOW-A-Admin");
        Iterator j = nonAdminsArrList.iterator();
        UserDataBean nonAdminDataBean = null;  
        ArrayList memberList = new ArrayList();                                                          
        while (j.hasNext()) {
            nonAdminDataBean = (UserDataBean)j.next();
            memberList.add(nonAdminDataBean.getEmailId().toLowerCase());
        }
        if(memberList.size() > 0 ){
            for(int a=0; a<memberList.size(); a++){
                adminList.add(memberList.get(a).toString());
            }
        }
        if(adminList.size() > 0){
            HashSet authorHS = new HashSet();
            authorHS.addAll(adminList);
            adminList.clear();
            adminList.addAll(authorHS); 
        }
        return adminList; 
    }

    //judy, 08/06, get AOW member list based on group name
    public ArrayList getAOWList(ScriptHelper sling,Session session,String groupName) throws Exception{
        UserMaintenanceManager usrMgr = new UserMaintenanceManager((SlingScriptHelper)sling,session);
        int grpMembersSize = usrMgr.getGroupMembersSize(groupName);
        if(grpMembersSize == 0){
          throw new NoMembersInGroup(groupName);
        }

        
        //Get Admin members
        ArrayList<UserDataBean> adminsArrList = usrMgr.getAdminUsersForGroup(groupName);
        Iterator i = adminsArrList.iterator();
        UserDataBean adminDataBean = null; 
        ArrayList adminList = new ArrayList();                                                           
        while (i.hasNext()) {
            adminDataBean = (UserDataBean)i.next();
            adminList.add(adminDataBean.getEmailId().toLowerCase());
        }

        
        //Get Non Admin members
        ArrayList<UserDataBean> nonAdminsArrList = usrMgr.getNormalUsersForGroup(groupName);
        Iterator j = nonAdminsArrList.iterator();
        UserDataBean nonAdminDataBean = null;  
        ArrayList memberList = new ArrayList();                                                          
        while (j.hasNext()) {
            nonAdminDataBean = (UserDataBean)j.next();
            memberList.add(nonAdminDataBean.getEmailId().toLowerCase());
        }


        if(memberList.size() > 0 ){
            for(int a=0; a<memberList.size(); a++){
                adminList.add(memberList.get(a).toString());
            }
        }
        if(adminList.size() > 0){
            HashSet authorHS = new HashSet();
            authorHS.addAll(adminList);
            adminList.clear();
            adminList.addAll(authorHS); 
        }
        
        return adminList; 
    }

/*    
    public boolean checkSkipNode(String curPage){
        boolean rt = false;
        for (int i = 0; i < skipNodes.length; i++) 
        {                           
             if(skipNodes[i].equals(curPage)){                                                        
                rt=true;
             }
         }  
         return rt;
    }
*/
    public boolean checkSkipNode(String curPage){
        boolean rt = false;

        if (getSkipNodes()!=null){
            for (int i = 0; i < getSkipNodes().length; i++) 
            {                           
                 if(getSkipNodes()[i].equals(curPage)){                                                        
                    rt=true;
                 }
            }  
         }
          
         if(getExcludeSites()!=null){
            for (int j = 0; j < getExcludeSites().length; j++) 
            {                           
                 if(curPage.indexOf(getExcludeSites()[j])>-1){                                                        
                    rt=true;
                 }
             }  
         }
         return rt;
    }
    
    
   /**
   * Sets offtime of the page.
   * @param pagePath - path of the page for which the offtime is to be set
   * @param aceNode - jcr:Content node of the page
   * @return boolean
   */
   
public static boolean setACEDate(String pagePath,Node aceNode){
   
        boolean result = true;
        try {
            if (aceNode != null)
            {
            
                Calendar offTime = null;
                
                String expPeriod ="6";
                ACEManager aceManager = new ACEManager(); 
                
                if (aceManager.checkSkipNode(pagePath)){
                
                // added to remove the offtime
                 
                  String a = null;
                  if(aceNode.hasProperty("offTime"))
                  {
                   aceNode.setProperty("offTime",a);
                   aceNode.save();
                   aceNode.refresh(true); 
                  }
                  return true;   
                }
                
                String sitePageKey = aceManager.getACESitePageKey(pagePath,true); 
                ACEConfigDataBean aceBean = aceManager.getACEConfigBean(sitePageKey);
                if( aceBean.getExpirePeriod() !=null && !aceBean.getExpirePeriod().equals(""))
                    expPeriod = aceBean.getExpirePeriod();
                
                //get current time
                offTime = Calendar.getInstance(); 
                
                // add exp period (default:six months) to the current time
                offTime.add(Calendar.MONTH,Integer.parseInt(expPeriod));
                offTime.set(Calendar.SECOND,0);
                
                aceNode.setProperty("offTime", offTime);
                aceNode.save();
                aceNode.refresh(true);                
            }
            else{
                result = false;
            }
        }catch(Exception e){
            result = false;
        } 
        
        return result;
   }     
}