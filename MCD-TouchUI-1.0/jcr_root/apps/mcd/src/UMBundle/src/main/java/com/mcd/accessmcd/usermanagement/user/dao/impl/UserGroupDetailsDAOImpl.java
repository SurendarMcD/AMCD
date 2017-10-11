package com.mcd.accessmcd.usermanagement.user.dao.impl;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.TreeMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Collections;
import java.util.Set;

import javax.jcr.Session;
import javax.jcr.Value;
import javax.jcr.ValueFactory;

import org.apache.jackrabbit.api.JackrabbitSession;
import org.apache.jackrabbit.api.security.user.Authorizable;
import org.apache.jackrabbit.api.security.user.Group;
import org.apache.jackrabbit.api.security.user.User;
import org.apache.jackrabbit.api.security.user.UserManager;
import org.apache.jackrabbit.util.Text;
import org.apache.jackrabbit.value.ValueFactoryImpl;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.security.NoSuchAuthorizableException;
import com.day.cq.security.UserManagerFactory;
import com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean;
import com.mcd.accessmcd.usermanagement.user.bo.UserDataBean;
import com.mcd.accessmcd.usermanagement.user.dao.IUserGroupDetailsDAO;
import com.mcd.accessmcd.usermanagement.replication.services.ILdapSynchService;
import com.mcd.accessmcd.usermanagement.replication.services.impl.LdapSynchServiceImpl;


public class UserGroupDetailsDAOImpl implements IUserGroupDetailsDAO
{
    private static final Logger log = LoggerFactory.getLogger(UserGroupDetailsDAOImpl.class);


    Session jcrSession = null;
    UserManager uMgr = null; 
    com.day.cq.security.UserManager cqMgr = null;
    ResourceResolver resourceResolver = null;
    Map<String, String> siteURLMap = new HashMap<String, String>();
         
    private Properties aceProperties;   
    private Properties formProperties; 
    public static String acePropFile = "aceConfigValues.properties";
    public static String formPropFile = "UserMaintenanceConfig.properties";
    public static String aceRootSite = "/content/accessmcd";
    public static String defaultACESiteKey = "/content/accessmcd";
    ILdapSynchService iLdapSynchService = null;
    public static String serverFilesPath = "/app/mcd/cms/wcm1_auth_stg/crx-quickstart/server/files/";
    public static String[] skipNodes = {"/content","/content/accessmcd","/content/accessmcd/ampea",
                                        "/content/accessmcd/ampea/au","/content/accessmcd/jtest"};
       
    private static String[] skipGroups = {"DEFAULT-Employee", "DEFAULT-Owner_Operator", 
           "DEFAULT-Franchisee_Restaurant_Manager", "DEFAULT-McOpCo_Restaurant_Manager", 
           "DEFAULT-Suppliers_Vendors", "DEFAULT-Crew","DEFAULT-Agency","DEFAULT-Franchisee_Office_Staff", "all_authors", "all_deny", 
           "tag-administrators_521", "Surfer_53","projects-media-designers","projects-media-editor","projects-media-owner","projects-media-copywriters",
			"projects-media","projects-media-photographers","projects-outdoors-editor","projects-outdoors","projects-outdoors-owner",
			"mac-default-lightbox-owner","mac-default-lightbox","mac-default-lightbox-editor","everyone","projects-administrators","projects-users"};
       
    private static String[] privilageGroups;


    public UserGroupDetailsDAOImpl(SlingScriptHelper sling, Session jcrSession, com.day.cq.security.UserManager uMgr, ResourceResolver resourceResolver) throws Exception
    {
        this.jcrSession = jcrSession;
        //this.uMgr = uMgr;
        this.uMgr = getUserManager(jcrSession);
        this.resourceResolver = resourceResolver;



        UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
        cqMgr = userManagerFactory.createUserManager(jcrSession);
        
        java.io.FileInputStream fis = null;
        iLdapSynchService = new LdapSynchServiceImpl(sling, jcrSession, uMgr);
        try
        {
            System.out.println("Server File Path :: " + serverFilesPath );
            fis = new java.io.FileInputStream(new java.io.File(serverFilesPath + acePropFile));
            java.util.Properties props = new java.util.Properties();
            props.load(fis);
            fis.close();
            this.aceProperties = props;
        }
        catch (Exception e)
        {
            log.error("[UserGroupDetailsDAOImpl] Constructor-- Exception :" + e.getMessage());
            e.printStackTrace();
        }
        finally
        {
            try
            {
                if (fis != null)
                    fis.close();
            }
            catch (Exception ei)
            {
                log.error("UserGroupDetailsDAOImpl Problem occured. Cannot close reader " + ei.getMessage());
            }
        }
        
        Enumeration siteURLEnum = aceProperties.keys();
        String key = "";
        String pageKey = "";
        GroupDataBean grpBean = null;
        
        while(siteURLEnum.hasMoreElements())
        {
            key = siteURLEnum.nextElement().toString();
            pageKey = getSitePageKey(key, true);
            grpBean = getConfigBean(pageKey);
            siteURLMap.put(grpBean.getGroupName(), grpBean.getSiteURL());
        }
        
        java.io.FileInputStream formFIS = null;
        try
        {
            formFIS = new java.io.FileInputStream(new java.io.File(serverFilesPath + formPropFile));
            java.util.Properties props = new java.util.Properties();
            props.load(formFIS);
            formFIS.close();
            this.formProperties = props;
        }
        catch (Exception e)
        {
            log.error("[UserGroupDetailsDAOImpl] Constructor-- Exception :" + e.getMessage());
            e.printStackTrace();
        }
        finally
        {
            try
            {
                if (formFIS != null)
                    formFIS.close();
            }
            catch (Exception ei)
            {
                log.error("UserGroupDetailsDAOImpl Problem occured. Cannot close reader " + ei.getMessage());
            }
        }
        
        if (formProperties.containsKey("privilageGroups"))
        {
                privilageGroups = formProperties.getProperty("privilageGroups", "").split(",");   
        }  
    }
        
    //Shubhra added new constructor
    public UserGroupDetailsDAOImpl(SlingScriptHelper sling, Session jcrSession, com.day.cq.security.UserManager uMgr) throws Exception
    {
        this.jcrSession = jcrSession;
        //this.uMgr = uMgr;
        this.uMgr = getUserManager(jcrSession);
        iLdapSynchService = new LdapSynchServiceImpl(sling, jcrSession, uMgr);
        UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
        cqMgr = userManagerFactory.createUserManager(jcrSession);
        
        java.io.FileInputStream fis = null;
        try
        {
            fis = new java.io.FileInputStream(new java.io.File(serverFilesPath + acePropFile));
            java.util.Properties props = new java.util.Properties();
            props.load(fis);
            fis.close();
            this.aceProperties = props;
        }
        catch (Exception e)
        {
            log.error("[UserGroupDetailsDAOImpl] Constructor-- Exception :" + e.getMessage());
            e.printStackTrace();
        }
        finally
        {
            try
            {
                if (fis != null)
                    fis.close();
            }
            catch (Exception ei)
            {
                log.error("UserGroupDetailsDAOImpl Problem occured. Cannot close reader " + ei.getMessage());
            }
        }
        
        Enumeration siteURLEnum = aceProperties.keys();
        String key = "";
        String pageKey = "";
        GroupDataBean grpBean = null;
        
        while(siteURLEnum.hasMoreElements())
        {
            key = siteURLEnum.nextElement().toString();
            pageKey = getSitePageKey(key, true);
            grpBean = getConfigBean(pageKey);
            siteURLMap.put(grpBean.getGroupName(), grpBean.getSiteURL());
        }
    }
      

    private UserManager getUserManager(Session jcrSession) throws Exception
    {
        if (jcrSession instanceof JackrabbitSession)
        {
            return ((JackrabbitSession) jcrSession).getUserManager();
        }
        else
        {
            throw new Exception("Session is not of type JackrabbitSession");
        }

    }

    private String getPropertyString(Value[] values)
    {
        if (values != null)
        {
            if (values.length > 0)
            {
                try
                {
                    return values[0].getString();
                }
                catch (Exception e)
                {
                    log.error("[UserGroupDetailsDAO] [getPropertyString] method: "+e.getMessage());
                }
            }
        }
        return null;
    }
    
    public String getSitePageKey(String pageURL, Boolean checkForParent)
    {
        String sitePageURL = pageURL;
        Boolean keyExists = false;

        try
        {
            if (sitePageURL.startsWith(aceRootSite))
            {
                keyExists = aceProperties.containsKey(sitePageURL);
                if (!(keyExists) && checkForParent)
                {
                    while (!(keyExists) && !(sitePageURL.equals(aceRootSite)))
                    {
                        if (sitePageURL.lastIndexOf("/") != -1)
                        {
                            sitePageURL = sitePageURL.substring(0, sitePageURL.lastIndexOf("/"));
                            keyExists = aceProperties.containsKey(sitePageURL);
                        }
                        else
                        {
                            keyExists = false;
                            break;
                        }
                    }
                }
            }
            else
            {
                log.error("[UserGroupDetailsDAOImpl] getSitePageKey()-- Invalid Key");
            }
        }
        catch (Exception e)
        {
            log.error("[UserGroupDetailsDAOImpl] getSitePageKey()-- Exception:" + e.getMessage());
            e.printStackTrace();
        }

        if (keyExists)
            return sitePageURL;
        else
            return defaultACESiteKey;
    }

    public GroupDataBean getConfigBean(String sitePageKey)
    {
        GroupDataBean groupDataBean = new GroupDataBean();
        try
        {
            if (aceProperties.containsKey(defaultACESiteKey))
            {
                String defaultKeyValue = aceProperties.getProperty(defaultACESiteKey, "");
                String[] defaultAceValues = defaultKeyValue.split(",");

                String sitePageKeyValue = defaultKeyValue;

                if ((sitePageKey.startsWith(aceRootSite)) && (aceProperties.containsKey(sitePageKey)))
                {
                    sitePageKeyValue = aceProperties.getProperty(sitePageKey, "");
                }
                else
                {
                    sitePageKey = defaultACESiteKey;
                }

                String[] aceValues = sitePageKeyValue.split(",");

                groupDataBean.setSiteURL(sitePageKey);
                groupDataBean.setGroupName(((aceValues.length > 0) ? aceValues[0] : defaultAceValues[0]));
            }
            else
            {
                log.error("[UserGroupDetailsDAOImpl] getConfigBean() -- Error: Root entry missing in config file");
            }
        }
        catch (Exception e)
        {
            log.error("[UserGroupDetailsDAOImpl] getConfigBean() -- Exception:" + e.getMessage());
            e.printStackTrace();
        }
        return groupDataBean;
    }
    
    /**
     * Method is used to validate the EID is member of priviledge Group. 
     * @param EID
     * @return boolean (True->Admin & False->Not Admin)
     */
    public boolean checkForAdminDropDown(String EID) throws Exception
    {
        boolean optionFlag = false;
        
        if(EID.trim().equalsIgnoreCase("admin"))
        {
            optionFlag = true;
        }
        else if(checkIsAdmin(EID))
        {
            optionFlag = true;
        }
        else
        {
            com.day.cq.security.User user = (com.day.cq.security.User)cqMgr.get(EID);
            Iterator grpItr = user.memberOf();
            com.day.cq.security.Group group = null;
            while(grpItr.hasNext())
            {
                group = (com.day.cq.security.Group)grpItr.next();
                if(checkGroup(group.getName()))
                {
                    optionFlag = true;
                    break;
                }
            }
        }
        
        return optionFlag;
    }
    
    public boolean checkGroup(String groupName)
    {
        boolean isExists = false;
        for(int i = 0 ; i < privilageGroups.length ; i++)
        {
            if(privilageGroups[i].trim().equalsIgnoreCase(groupName.trim()))
            {
                isExists = true;
                break;
            }
        }
        return isExists;
    }
    
    /**
     * Method is used to validate the EID is administrator of any group or not.
     * 
     * @param EID
     * @return boolean (True->Admin & False->Not Admin)
     */
    public boolean checkIsAdmin(String EID) throws Exception
    {
        com.day.cq.security.User user=null;
        boolean isAdmin = false;
        
        EID = EID.trim();
        try
        {
            user=(com.day.cq.security.User)cqMgr.get(EID);
            if(user!=null)
            {
                Iterator usergroups=user.memberOf();
                String adminUsers = "";
                while(usergroups.hasNext())
                {
                    com.day.cq.security.Group grp = (com.day.cq.security.Group)usergroups.next();
                    adminUsers = grp.getProperty("AdminUsers");
                    if((adminUsers != null) && adminUsers.indexOf(EID) != -1)
                    {
                        isAdmin = true;
                        break;
                    }                    
                }
            }            
        }
        catch(NoSuchAuthorizableException e)
        {
            log.error("[UserGroupDetailsDAOImpl] checkIsAdmin() -- Exception:" + e.getMessage());
            e.printStackTrace();
        }
        return isAdmin;
    }
    /**
     * Method is used to validate the EID is administrator of "stakeholder-a-corp-us-nz-au-eu-wwc-apmea-mcd" or not.
     * 
     * @param EID
     * @return boolean (True->Admin of that group & False->Not Admin)
     */
    
     public boolean checkIsMemberOfStakeholder(String EID)
     {
        User user=null;
        boolean isMemberOfStakeholder = false;
        EID = EID.trim();       
        try
        {
            user=(User)uMgr.getAuthorizable(EID);
            if(user!=null)
            {
                Iterator usergroups=user.memberOf();
                while(usergroups.hasNext())
                {                                    
                    Group grp = (Group)usergroups.next();                    
                    GroupDataBean grpBean = null;
                    grpBean = this.getGroupDetails(grp.getID());
                    if((grpBean.getGroupName()).equals("stakeholder-a-corp-us-nz-au-eu-wwc-apmea-mcd")){
                        isMemberOfStakeholder=true;     
                        break;                   
                    }
                    else{
                        isMemberOfStakeholder=false;
                    }
                }                                                                
            }
            else 
            {
                isMemberOfStakeholder=false;

            }       
        }catch(Exception e)
        {
            e.printStackTrace();
        }
        return isMemberOfStakeholder; 
    }


    /**
     * Method to get arraylist of GroupDataBean objects in which the role of
     * user is admin.
     * 
     * @param EID
     * @return ArrayList<GroupDataBean>
     */
    public ArrayList<GroupDataBean> getGroupsAdminForUser(String EID) throws Exception
    {
        User user=null;
        ArrayList<GroupDataBean> retGrpArrList = new ArrayList<GroupDataBean>();
        ArrayList<GroupDataBean> allGrpArrList = new ArrayList<GroupDataBean>();
        EID = EID.trim();
        try
        {
			if(EID.equalsIgnoreCase("admin")||checkIsMemberOfStakeholder(EID))
            {
                //Iterator usergroups = uMgr.getGroups();
                Iterator<Resource> usergroups = resourceResolver.findResources("//element(*,rep:Group)", "xpath");
                GroupDataBean grpBean = null;
                while(usergroups.hasNext())
                {
                    Resource groupRes = usergroups.next();
                    //Group grp = (Group)uMgr.getAuthorizable(Text.getName(groupRes.getPath()));
                    Group grp = groupRes.adaptTo(Group.class);
                    try{
                        grpBean = this.getGroupDetails(grp.getID());
                        if(!this.isToBeSkipped(grpBean.getGroupName()))
                            retGrpArrList.add(grpBean);
                    }
                    catch(Exception ex){
                        log.error("Exception occured to groups for admin id and admin user :: " + groupRes.getPath() );
                        log.error("Exception for tede group :: ",ex);
                    }
                }               
            }
            else
            {
                user=(User)uMgr.getAuthorizable(EID);
                if(user!=null)
                {
                    Iterator usergroups = user.memberOf();
                    GroupDataBean grpBean = null;
                    String adminUsers = "";
                    while(usergroups.hasNext())
                    {
                        Group grp = (Group)usergroups.next();
                        try{
                        adminUsers = getPropertyString(grp.getProperty("AdminUsers"));
                        if((adminUsers != null) && adminUsers.indexOf(EID) != -1)
                        {
                            grpBean = this.getGroupDetails(grp.getID());
                            if(!this.isToBeSkipped(grpBean.getGroupName()))
                                retGrpArrList.add(grpBean);
                        }   
                        }
                        catch(Exception ex){
							log.error("Exception occured to groups for non admin users :: " + grp);
                        }
                    }
                }
                
                Iterator<Resource> allusergroups = resourceResolver.findResources("//element(*,rep:Group)", "xpath");
                GroupDataBean grpBean = null;
                while(allusergroups.hasNext())
                {
                    Resource groupRes = allusergroups.next();
                    //Group grp = (Group)uMgr.getAuthorizable(Text.getName(groupRes.getPath()));
					Group grp = groupRes.adaptTo(Group.class);
                    grpBean = this.getGroupDetails(grp.getID());
                    if(!this.isToBeSkipped(grpBean.getGroupName()))
                        allGrpArrList.add(grpBean);
                }
                
                com.day.cq.security.User cqUser = (com.day.cq.security.User)cqMgr.get(EID);
                Iterator grpItr = cqUser.memberOf();
                com.day.cq.security.Group group = null;
                String grpName = "";
                String privGrpName = "";
                while(grpItr.hasNext())
                {
                    group = (com.day.cq.security.Group)grpItr.next();
                    if(checkGroup(group.getName()))
                    {
                        for(int j = 0 ; j < allGrpArrList.size() ; j++)
                        {
                            grpName = group.getName();
                            grpName = grpName.substring(0,grpName.indexOf("-"));
                            
                            privGrpName = ((GroupDataBean)allGrpArrList.get(j)).getGroupName();
                            
                            if(privGrpName.indexOf(grpName+"-") != -1)
                            {
                                retGrpArrList.add(allGrpArrList.get(j));
                            }
                        }
                    }
                }                
            }
            retGrpArrList = getUniqueGroupList(retGrpArrList);
        }
        catch(Exception e)
        {
            log.error("[UserGroupDetailsDAOImpl] getGroupsAdminForUser() -- Exception:" + e.getMessage());
            e.printStackTrace();
        }
        return retGrpArrList;
    }

    /**
     * Method to get arraylist of GroupDataBean objects in which user belongs to.
     * 
     * @param EID
     * @return ArrayList<GroupDataBean>
     */
    public ArrayList<GroupDataBean> getUserGroupsDetails(String EID) throws Exception
    {
        User user=null;
        ArrayList<GroupDataBean> retGrpArrList = new ArrayList<GroupDataBean>();
        EID = EID.trim();
        user = (User) uMgr.getAuthorizable(EID);
        if (user != null)
        {
            Iterator usergroups = user.memberOf();
            GroupDataBean grpBean = null;
            while (usergroups.hasNext())
            {
                Group grp = (Group) usergroups.next();
                grpBean = this.getGroupDetails(grp.getID());

                if (!this.isToBeSkipped(grpBean.getGroupName()))
                    retGrpArrList.add(grpBean);
            }
        }
        return retGrpArrList;
    }
    
    public ArrayList<GroupDataBean> getUniqueGroupList(ArrayList<GroupDataBean> groupList)
    {
        ArrayList<GroupDataBean> returnList = new ArrayList<GroupDataBean>();
        GroupDataBean grpDataBean = null;
        boolean addFlag = true;
        String groupName = "";
        for(int i = 0 ; i < groupList.size() ; i++)
        {
            grpDataBean = (GroupDataBean)groupList.get(i);
            groupName = grpDataBean.getGroupName();
            for(int j = 0 ; j < returnList.size() ; j++)
            {
                if(groupName.equalsIgnoreCase(((GroupDataBean)returnList.get(j)).getGroupName()))
                {
                    addFlag = false;
                    break;
                }
                else
                {
                    addFlag = true;
                }
            }
            if(addFlag)
                returnList.add(grpDataBean);
        }
        return returnList;
    }

    /**
     * Method to get arraylist of GroupDataBean objects in which user group
     * access details.
     * 
     * @param groupID
     * @param EID
     * @return ArrayList<GroupDataBean>
     */
    public ArrayList<GroupDataBean> getUserGroupAccessDetails(String groupID, String EID) throws Exception
    {
        return null;
    }

    /**
     * Method to get size of members in a Group.
     * 
     * @param groupID
     * @return int
     */
    public int getGroupMembersSize(String groupID) throws Exception
    {
        Group group=(Group)uMgr.getAuthorizable(groupID);
        int count=0;
        if(group!=null)
        {
            Iterator members= group.getMembers();
            while(members.hasNext())
            {
                Authorizable member=(Authorizable)members.next();
                if(!member.isGroup())
                {
                    count++;
                }
            }
        }
        return count;
    }

    /**
     * Method to get arraylist of UserDataBean objects for a group members.
     * 
     * @param groupID
     * @param maxLimit (Max User to be returned, "" for All Users).
     * @return ArrayList<UserDataBean>
     */
    public ArrayList<UserDataBean> getGroupMembersDetails(String groupID, String maxLimit) throws Exception
    {
        
        Group group=(Group)uMgr.getAuthorizable(groupID);
        ArrayList<UserDataBean> retGroupMembersList = new ArrayList<UserDataBean>();
        int intMaxLimit = 0;
        if(!maxLimit.equalsIgnoreCase(""))
        {
            intMaxLimit = Integer.parseInt(maxLimit);
        }
        if(group!=null)
        {
            Iterator members= group.getMembers();
            int cnt=0;
            UserDataBean userDataBean = null;
            UserDataBean sortedUserDataBean = null;
            Map<String, UserDataBean> userNameMap= new HashMap<String, UserDataBean> ();
            Map<String, UserDataBean> userIDMap= new HashMap<String, UserDataBean> ();            
            ArrayList namesList=new ArrayList();
            ArrayList idList=new ArrayList();
            while(members.hasNext())
            {
                if(!maxLimit.equalsIgnoreCase(""))
                {
                    cnt++;
                    if(cnt > intMaxLimit)
                        break;
                }
                Authorizable member=(Authorizable)members.next();
                if(!member.isGroup())
                {
                    userDataBean = this.getUserDetails(member.getID());
                    String fullName=userDataBean.getFullName();
                    if((fullName.trim()).indexOf(" ")>0){
                        //String editedFullName=fullName.substring(fullName.lastIndexOf(" "),fullName.length()) + ", "+ fullName.substring(0,fullName.lastIndexOf(" "));
                        userNameMap.put(fullName.toLowerCase(), userDataBean);
                        namesList.add(fullName.toLowerCase());
                        //userDataBean.setFullName(fullName); 
                    }
                    else{
                        userIDMap.put(fullName.toLowerCase(), userDataBean);
                        idList.add(fullName.toLowerCase()); 
                        //userDataBean.setFullName(fullName);
                    }
                    
                }                                                
            }
            Collections.sort(namesList);
            Collections.sort(idList);
            
            if(namesList.size()>0){
                for(int i=0;i<namesList.size();i++){
                    retGroupMembersList.add(userNameMap.get(namesList.get(i)));                
                }
            }
            if(idList.size()>0){
                for(int i=0;i<idList.size();i++){
                    retGroupMembersList.add(userIDMap.get(idList.get(i)));                
                }            
            }
        }
        return retGroupMembersList;
    }

    /**
     * Method to get UserDataBean object for user information.
     * 
     * @param EID
     * @return UserDataBean Object
     */
    public UserDataBean getUserDetails(String EID) throws Exception
    {
        Map propertyMap=null;
        String givenName="";
        String familyName="";
        boolean userInLDAPFlag = this.checkUserInLDAP(EID);
                if(userInLDAPFlag) //User exists in LDAP
                {
                    propertyMap = this.getUserPropertiesFromLDAP(EID);
                    /*Set mapSet=propertyMap.keySet();
                    Iterator itr=mapSet.iterator();
                    while(itr.hasNext())
                        log.error("************** "+itr.next());*/
                }
        if(propertyMap!=null){
            givenName = propertyMap.get("givenName").toString();
            familyName = propertyMap.get("familyName").toString();        
        }        
        User user = null;
        UserDataBean userDataBean = new UserDataBean();
        user = (User) uMgr.getAuthorizable(EID);

        if (user != null)
        {
            userDataBean.setEid(EID);
         //if (user.getProperty("rep:fullname") == null){ 
           
            if((user.getProperty("familyName")!=null) || (user.getProperty("givenName")!=null)){
                String nameOfUser=checkNull(getPropertyString(user.getProperty("familyName")))+", "+checkNull(getPropertyString(user.getProperty("givenName")));
                userDataBean.setFullName(nameOfUser);
                //log.error("CQ property "+nameOfUser);
            }
            else if((!givenName.equals(""))&&(!familyName.equals(""))){            
                String nameOfUser=familyName +", "+ givenName;
                //log.error("$$$$$$$$$$$$$$$$$$$$$$$$$$ familyName givenName: "+nameOfUser);
                userDataBean.setFullName(nameOfUser);             
            }
            else{
                //log.error("############### eid "+user.getID());
                userDataBean.setFullName(checkNull(user.getID())); 
            }
            /*}else{
                userDataBean.setFullName(checkNull(getPropertyString(user.getProperty("rep:fullname"))));           
            } */   
            userDataBean.setMcaudience(checkNull(getPropertyString(user.getProperty("rep:mcdAudience"))));
            userDataBean.setEmailId(checkNull(getPropertyString(user.getProperty("rep:e-mail"))));
        }

        return userDataBean;
    }

    /**
     * Method to get the List of Admin Users for a group.
     * 
     * @param groupID
     * @return ArrayList<UserDataBean>
     */
    public ArrayList<UserDataBean> getAdminUsersForGroup(String groupID) throws Exception
    {
        ArrayList<UserDataBean> returnArrList = new ArrayList<UserDataBean>();
        Group group=(Group)uMgr.getAuthorizable(groupID);
        String adminProperty = getPropertyString(group.getProperty("AdminUsers")); 
        if(adminProperty != null && !adminProperty.equalsIgnoreCase(""))
        {
            String[] arrGroupUsers = adminProperty.split(",");
            String EID = "";
            UserDataBean userBean = null;
            for(int i = 0 ; i < arrGroupUsers.length ; i++)
            {
                EID = arrGroupUsers[i].trim();
                if(!EID.equalsIgnoreCase(""))
                {
                    userBean = this.getUserDetails(EID);
                    returnArrList.add(userBean);
                }
            }
        }

        return returnArrList;
    }
    
    /**
     * Method to get the List of only Normal Users for a group.
     * 
     * @param groupID
     * @return ArrayList<UserDataBean>
     */
    public ArrayList<UserDataBean> getNormalUsersForGroup(String groupID) throws Exception
    {
        ArrayList<UserDataBean> allMembersList = this.getGroupMembersDetails(groupID, "");
        ArrayList<UserDataBean> adminMembersList = this.getAdminUsersForGroup(groupID);
        ArrayList<UserDataBean> normalMembersList = new ArrayList<UserDataBean>();
        
        UserDataBean userBeanAll = null;
        String EIDAll = "";
        UserDataBean userBeanAdmin = null;
        String EIDAdmin = "";
        
        boolean matched = false;
        
        for(int i = 0 ; i<allMembersList.size() ; i++)
        {
            userBeanAll = (UserDataBean)allMembersList.get(i);
            EIDAll = userBeanAll.getEid().trim();
            for(int j = 0 ; j < adminMembersList.size() ; j++)
            {
                userBeanAdmin = (UserDataBean)adminMembersList.get(j);
                EIDAdmin = userBeanAdmin.getEid().trim();
                if(EIDAll.equalsIgnoreCase(EIDAdmin))
                {
                    matched = true;
                }
            }
            if(!matched)
            {
                normalMembersList.add(userBeanAll);
            }
            else
            {
                matched = false;
            }
        }

        return normalMembersList;
    }

    /**
     * Method to get group details
     * 
     * @param groupID
     * @return GroupDataBean Object
     */
    public GroupDataBean getGroupDetails(String groupID) throws Exception
    {
		GroupDataBean grpBean = new GroupDataBean();

        com.day.cq.security.Group cqGroup = (com.day.cq.security.Group)cqMgr.get(groupID);
        Group group=(Group)uMgr.getAuthorizable(groupID);
        
        
        grpBean.setGroupName(checkNull(cqGroup.getName()));
        grpBean.setGroupID(checkNull(cqGroup.getID()));
        
        String adminUsers = getPropertyString(group.getProperty("AdminUsers"));
        if(adminUsers != null && !adminUsers.equalsIgnoreCase(""))
        {
            grpBean.setAdminUsers(adminUsers.substring(0, adminUsers.length()-1).trim());
        }
        grpBean.setGroupDescription(checkNull(cqGroup.getProfile().getDescription()));
        grpBean.setGroupHandle(checkNull(cqGroup.getHomePath()));
        
        String siteURL = siteURLMap.get(group.getID().trim());
        grpBean.setSiteURL(checkNull(siteURL));

        return grpBean;
    }
    
    /**
     * Method used to Add/Update or Delete the Users from group.
     * @param EID
     * @param groupID
     * @param action
     * @param isAdmin
     * @return boolean (true --> if action is successful false --> if action is unsuccessful).
     */
    public boolean updateUserGroup(String EID, String groupID, String action, boolean isAdmin) throws Exception
    {
        log.error("****************** Inside updateUserGroup for action:  " + action + " on group: " + groupID + " for EID(s) " + EID );
        final ValueFactory vf = ValueFactoryImpl.getInstance();
        if(this.jcrSession.isLive()) 
        {
            log.info("Session is live");
        }
        boolean updateFlag = false;
        User user= (User)uMgr.getAuthorizable(EID);
        Group group=(Group)uMgr.getAuthorizable(groupID);
        boolean hasAdminProperty = false;
        String adminProperty = getPropertyString(group.getProperty("AdminUsers")); 
        if(adminProperty == null || adminProperty.equalsIgnoreCase(""))
            hasAdminProperty = false;
        else
            hasAdminProperty = true;

        if(action.equalsIgnoreCase("Add"))
        {
            boolean isMemberAdded = false;

            try
            {
				log.error("***** Before Adding User Auth *****" + group + " :: " + uMgr.getAuthorizable(EID));
                group.addMember(uMgr.getAuthorizable(EID));
                this.jcrSession.save();

                if (isAdmin)
                {
                    if (hasAdminProperty)
                    {
                        if (adminProperty.indexOf(EID) == -1)
                            adminProperty += EID + ",";
                        group.setProperty("AdminUsers", vf.createValue(adminProperty));
                    }
                    else
                    {
                        group.setProperty("AdminUsers", vf.createValue(EID + ","));
                    }
                    this.jcrSession.save();
                }  
                isMemberAdded = true;
                log.error("***** isMemberAdded *****" + group + " :: " +isMemberAdded);
            }
            catch (Exception e)
            {
                isMemberAdded = false;
                log.error("[UserGroupDetailsDAOImpl] updateUserGroup() -- Exception:" + e.getMessage());
                //System.out.println("[UserGroupDetailsDAOImpl] updateUserGroup() -- Exception:" + e.getMessage());
                e.printStackTrace();
            }
            updateFlag = isMemberAdded;
        }
        else if(action.equalsIgnoreCase("Delete"))
        {
            boolean isMemberDeleted = false;

            try
            {
                log.error("****************** Inside updateUserGroup for Delete action: on group: " + groupID + " for EID(s) " + EID );
                group.removeMember(user);
                this.jcrSession.save();
                if (hasAdminProperty)
                {
                    adminProperty = adminProperty.replaceAll(EID + ",", "");
                    /*if(adminProperty.trim().equalsIgnoreCase(""))
                    {
                    group.removeProperty("AdminUsers");
                    }
                    else
                    {*/
                    group.setProperty("AdminUsers", vf.createValue(adminProperty));
                    this.jcrSession.save();
                    //}
                }               
                isMemberDeleted = true;
            }
            catch (Exception e)
            {
                isMemberDeleted = false;
                log.error("[UserGroupDetailsDAOImpl] updateUserGroup() -- Exception:" + e.getMessage());
                e.printStackTrace();
            }
            updateFlag = isMemberDeleted;
        }
        return updateFlag;
    }

    /**
     * Method to create user in CQ.
     * 
     * @param EID
     * @param propertyMap
     * @return boolean(True->If created successfully, False->If not created).
     */
    public boolean createUserInCQ(String EID, Map propertyMap) throws Exception
    {
        final ValueFactory vf = ValueFactoryImpl.getInstance();

        EID = EID.trim();
        boolean returnFlag = false;
        try
        {
            //String userID = propertyMap.get("userId").toString();
            String mail = propertyMap.get("mail").toString();
            String mcdAudience = propertyMap.get("mcdAudience").toString();
            String amcdRole = propertyMap.get("amcdRole").toString();
            String givenName = propertyMap.get("givenName").toString();
            String familyName = propertyMap.get("familyName").toString();
            String fullName = propertyMap.get("fullName").toString();
            String location = propertyMap.get("location").toString();

            String password = String.valueOf(Math.random());

//judy, ADFS , get from propertyMap 
            //final String principalname = "uid=" + EID + ",ou=People,o=accessmcd.com,o=mcd.com";
            final String principalname = propertyMap.get("distinguishedName").toString();
//end, ADFS 

            String path = "/home/users/" + EID.substring(0, 6) + "xx/";
            java.security.Principal userPrincipal = new Principal()
            {
                public String getName()
                {
                    return principalname;
                }
            };
            User user = (User) uMgr.createUser(EID, password, userPrincipal , path);
            this.jcrSession.save();

            user.setProperty("rep:e-mail", vf.createValue(mail));
            user.setProperty("rep:mcdAudience", vf.createValue(mcdAudience));
            user.setProperty("rep:amcdRole", vf.createValue(amcdRole));
            user.setProperty("givenName", vf.createValue(givenName));
            user.setProperty("familyName", vf.createValue(familyName));
            user.setProperty("rep:fullname", vf.createValue(fullName));
            user.setProperty("rep:location", vf.createValue(location));
            this.jcrSession.save();

            returnFlag = true;
        }
        catch (Exception e)
        {
            returnFlag = false;
            log.error("[UserGroupDetailsDAOImpl] createUserInCQ() -- Exception:" + e.getMessage());
            e.printStackTrace();
        }

        return returnFlag;
    }

    /**
     * Method to check NULL Values. returns blank String when NULL else return the String which is passed.
     * @param strString
     * @return String
     */
     public String checkNull(String strString)
    {
        if(strString == null || strString.equalsIgnoreCase("NULL") || strString.indexOf("NULL") != -1)
            return "";
        else
            return strString.trim();
    }

    /**
     * method to check whether the group is to be shown in Groups Dropdown or not.
     * @param groupName
     * @return boolean
     */
    public boolean isToBeSkipped(String groupName)
    {
        boolean isToBeSkipped = false;
        for(int i = 0 ; i < skipGroups.length ; i++)
        {
            if(skipGroups[i].trim().equalsIgnoreCase(groupName.trim()))
            {
                isToBeSkipped = true;
                break;
            }
        }
        return isToBeSkipped;
    }
    /**
     * Method is used to check user in LDAP
     * 
     * @param EID
     * @return boolean (True-> If exists, False-> If not exists)
     */
    public boolean checkUserInLDAP(String EID) throws Exception
    {
        return iLdapSynchService.checkUserInLDAP(EID);
    }

    /**
     * Method to get user properties from LDAP
     * 
     * @param EID
     * @return Map Containing User Properties from LDAP
     */
    public Map getUserPropertiesFromLDAP(String EID) throws Exception
    {
        return iLdapSynchService.getUserPropertiesFromLDAP(EID);
    }
}