package com.mcd.accessmcd.usermanagement.user.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

import javax.jcr.Session;

import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.scripting.SlingScriptHelper;

import com.day.cq.security.UserManager;
import com.day.cq.security.UserManagerFactory;
import com.mcd.accessmcd.usermanagement.replication.services.ILdapSynchService;
import com.mcd.accessmcd.usermanagement.replication.services.IReplicationService;
import com.mcd.accessmcd.usermanagement.replication.services.impl.LdapSynchServiceImpl;
import com.mcd.accessmcd.usermanagement.replication.services.impl.ReplicationServiceImpl;
import com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean;
import com.mcd.accessmcd.usermanagement.user.bo.UserDataBean;
import com.mcd.accessmcd.usermanagement.user.dao.IUserGroupDetailsDAO;
import com.mcd.accessmcd.usermanagement.user.dao.impl.UserGroupDetailsDAOImpl;

public class UserMaintenanceManager
{
    IUserGroupDetailsDAO iUserGroupDetailsDAO = null;
    IReplicationService iReplicationService = null;
    ILdapSynchService iLdapSynchService = null;
    ResourceBundle bundle = null;
    Session jcrSession = null;
    UserManager uMgr = null;
    private boolean closeSession = true;
    
    public UserMaintenanceManager(SlingScriptHelper sling, ResourceBundle bundle, Session jcrSession, UserManager uMgr, ResourceResolver resourceResolver) throws Exception
    {
        iUserGroupDetailsDAO = new UserGroupDetailsDAOImpl(sling, jcrSession, uMgr, resourceResolver);
        iReplicationService = new ReplicationServiceImpl(sling, jcrSession, uMgr);
        iLdapSynchService = new LdapSynchServiceImpl(sling, jcrSession, uMgr);
        this.bundle = bundle;
        this.jcrSession = jcrSession;
        this.uMgr = uMgr;
    }
        
    public UserMaintenanceManager(SlingScriptHelper sling, Session jcrSession) throws Exception
    {
        UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
        UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
        //ResourceResolver resourceResolver = sling.getRequest().getResourceResolver();                
        iUserGroupDetailsDAO = new UserGroupDetailsDAOImpl(sling, jcrSession, uMgr);
        iReplicationService = new ReplicationServiceImpl(sling, jcrSession, uMgr);
        iLdapSynchService = new LdapSynchServiceImpl(sling, jcrSession, uMgr);
        this.jcrSession = jcrSession;
        this.uMgr = uMgr;
    }

    /**
     * Method is used to validate the EID is administrator of any group or not.
     * 
     * @param EID
     * @return boolean (True->Admin & False->Not Admin)
     */
    public boolean checkIsAdmin(String EID) throws Exception
    {
        return iUserGroupDetailsDAO.checkIsAdmin(EID);
    }
    
    /**
     * Method is used to validate the EID is member of priviledge Group. 
     * @param EID
     * @return boolean (True->Admin & False->Not Admin)
     */
    public boolean checkForAdminDropDown(String EID) throws Exception
    {
        return iUserGroupDetailsDAO.checkForAdminDropDown(EID);
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
        return iUserGroupDetailsDAO.getGroupsAdminForUser(EID);
    }

    /**
     * Method to get arraylist of GroupDataBean objects in which user belongs
     * to.
     * 
     * @param EID
     * @return ArrayList<GroupDataBean>
     */
    public ArrayList<GroupDataBean> getUserGroupsDetails(String EID) throws Exception
    {
        return iUserGroupDetailsDAO.getUserGroupsDetails(EID);
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
        return iUserGroupDetailsDAO.getUserGroupAccessDetails(groupID, EID);
    }
    
    /**
     * Method to get size of members in a Group.
     * 
     * @param groupID
     * @return int
     */
    public int getGroupMembersSize(String groupID) throws Exception
    {
        return iUserGroupDetailsDAO.getGroupMembersSize(groupID);
    }

    /**
     * Method to get arraylist of UserDataBean objects for a group members.
     * 
     * @param groupID
     * @param maxLimit
     * @return ArrayList<UserDataBean>
     */
    public ArrayList<UserDataBean> getGroupMembersDetails(String groupID, String maxLimit) throws Exception
    {
        return iUserGroupDetailsDAO.getGroupMembersDetails(groupID, maxLimit);
    }

    /**
     * Method to get UserDataBean object for user information.
     * 
     * @param EID
     * @return UserDataBean Object
     */
    public UserDataBean getUserDetails(String EID) throws Exception
    {
        return iUserGroupDetailsDAO.getUserDetails(EID);
    }

    /**
     * Method to get the List of Admin Users for a group.
     * 
     * @param groupID
     * @return ArrayList<UserDataBean>
     */
    public ArrayList<UserDataBean> getAdminUsersForGroup(String groupID) throws Exception
    {
        return iUserGroupDetailsDAO.getAdminUsersForGroup(groupID);
    }
    
    /**
     * Method to get the List of only Normal Users for a group.
     * 
     * @param groupID
     * @return ArrayList<UserDataBean>
     */
    public ArrayList<UserDataBean> getNormalUsersForGroup(String groupID) throws Exception
    {
        return iUserGroupDetailsDAO.getNormalUsersForGroup(groupID);
    }

    /**
     * Method to get group details
     * 
     * @param groupID
     * @return GroupDataBean Object
     */
    public GroupDataBean getGroupDetails(String groupID) throws Exception
    {
        return iUserGroupDetailsDAO.getGroupDetails(groupID);
    }
    
    /*public Map updateTemp(String pmEID, String pmGroup, String pmAction, String pmEIDList) throws Exception
    {
        System.out.println("pmEIDList : ---------- >"+pmEIDList);
        Map resultMap = null;
        if(!pmEIDList.equals(""))
        {
            String[] arrEID = pmEIDList.split(",");
            String eidValue="";
            for(int i=0 ; i<arrEID.length ; i++)
            {
                eidValue=arrEID[i].trim();
                
                if(pmAction.equals("addM"))
                    resultMap = updateUserGroup(eidValue, pmGroup, "Add", false);
                else if(pmAction.equals("addA"))
                    resultMap = updateUserGroup(eidValue, pmGroup, "Add", true);
                else if(pmAction.equals("delete"))
                    resultMap = updateUserGroup(eidValue, pmGroup, "Delete", false);
                
                jcrSession.save();
            }
        }
        else
        {
            if(pmAction.equals("addM"))
                resultMap = updateUserGroup(pmEID, pmGroup, "Add", false);
            else if(pmAction.equals("addA"))
                resultMap = updateUserGroup(pmEID, pmGroup, "Add", true);
            else if(pmAction.equals("delete"))
                resultMap = updateUserGroup(pmEID, pmGroup, "Delete", false);
            
            jcrSession.save();
        }
        return resultMap;
    }*/

    /**
     * Method used to Add/Update or Delete the Users from group.
     * @param EID
     * @param groupID
     * @param action
     * @param isAdmin
     * @return String Success/Failure Message.
     */
    public synchronized Map updateUserGroup(String EID, String groupID, String action, boolean isAdmin) throws Exception
    {
        EID = EID.trim();
        UserDataBean userDataBean = this.getUserDetails(EID);
        GroupDataBean grpDataBean = this.getGroupDetails(groupID);
        Map<Object, Object> returnMap = new HashMap<Object, Object>();

        returnMap.put("errorFlag","false");
        returnMap.put("errorMessage","");
        try{
        if(action.equalsIgnoreCase("Add"))
        {
            if(userDataBean.getEid().equalsIgnoreCase("")) //User Data not exists.
            {
                boolean userInLDAPFlag = this.checkUserInLDAP(EID);
                if(userInLDAPFlag) //User exists in LDAP
                {
                    Map propertiesMap = this.getUserPropertiesFromLDAP(EID);
                    boolean userCreationFlag = this.createUserInCQ(EID, propertiesMap);
                    if(userCreationFlag)
                    {
                        boolean isUserReplicated = this.replicateUserOnPublish(EID);
                        if(isUserReplicated)
                        {
                            boolean isUserGrpUpdated = iUserGroupDetailsDAO.updateUserGroup(EID, groupID, action, isAdmin);
                            if(isUserGrpUpdated)
                            {
                                boolean isGroupReplicated = this.replicateGroupOnPublish(groupID);
                                if(isGroupReplicated)
                                {
                                    returnMap.put("errorFlag","false");
                                    returnMap.put("errorMessage",bundle.getString("UAF_USER_SUCCESS").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
                                }
                                else
                                {
                                    returnMap.put("errorFlag","true");
                                    returnMap.put("errorMessage",bundle.getString("UAF_GROUP_NOT_REPLICATED").replaceAll("groupid", "<B>"+groupID+"</B>").replaceAll("groupname", "<B>"+grpDataBean.getGroupName()+"</B>"));
                                }
                            }
                            else
                            {
                                returnMap.put("errorFlag","true");
                                returnMap.put("errorMessage",bundle.getString("UAF_USER_NOT_UPDT_IN_GRP").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
                            }
                        }
                        else
                        {
                            returnMap.put("errorFlag","true");
                            returnMap.put("errorMessage",bundle.getString("UAF_USER_NOT_REPLICATED").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
                        }

                    }
                    else
                    {
                        returnMap.put("errorFlag","true");
                        returnMap.put("errorMessage",bundle.getString("UAF_USER_NOT_CREATED").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
                    }
                }
                else //User does not exist in LDAP
                {
                    returnMap.put("errorFlag","true");
                    returnMap.put("errorMessage",bundle.getString("UAF_USER_NOT_EXIST_LDAP").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
                }
            }
            else //User Data exists.
            {

                boolean isUserGrpUpdated = iUserGroupDetailsDAO.updateUserGroup(EID, groupID, action, isAdmin);
                if(isUserGrpUpdated)
                {
                    boolean isGroupReplicated = this.replicateGroupOnPublish(groupID);
                    if(isGroupReplicated)
                    {
                        returnMap.put("errorFlag","false");
                        returnMap.put("errorMessage",bundle.getString("UAF_USER_SUCCESS").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
                    }
                    else
                    {
                        returnMap.put("errorFlag","true");
                        returnMap.put("errorMessage",bundle.getString("UAF_GROUP_NOT_REPLICATED").replaceAll("groupid", "<B>"+groupID+"</B>").replaceAll("groupname", "<B>"+grpDataBean.getGroupName()+"</B>"));
                    }
                }
                else
                {
                    returnMap.put("errorFlag","true");
                    returnMap.put("errorMessage",bundle.getString("UAF_USER_NOT_UPDT_IN_GRP").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
                }
            }
        }
        else if(action.equalsIgnoreCase("Delete"))
        {
            if(userDataBean.getEid().equalsIgnoreCase("")) //User Data not exists.
            {
                returnMap.put("errorFlag","true");
                returnMap.put("errorMessage",bundle.getString("UAF_USER_NOT_EXIST_CQ").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
            }
            else
            {
                com.day.cq.security.Group group=(com.day.cq.security.Group)uMgr.get(groupID);
                com.day.cq.security.User user=(com.day.cq.security.User)uMgr.get(EID);
                if(group.isMember(user))
                {
                    boolean isDeleted = iUserGroupDetailsDAO.updateUserGroup(EID, groupID, action, isAdmin);
                    if(isDeleted)
                    {
                        boolean isGroupReplicated = this.replicateGroupOnPublish(groupID);
                        if(isGroupReplicated)
                        {
                            returnMap.put("errorFlag","false");
                            returnMap.put("errorMessage",bundle.getString("UAF_USER_DELETED").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
                        }
                        else
                        {
                            returnMap.put("errorFlag","true");
                            returnMap.put("errorMessage",bundle.getString("UAF_GROUP_NOT_REPLICATED").replaceAll("groupid", "<B>"+groupID+"</B>").replaceAll("groupname", "<B>"+grpDataBean.getGroupName()+"</B>"));
                        }
                    }
                    else
                    {
                        returnMap.put("errorFlag","true");
                        returnMap.put("errorMessage",bundle.getString("UAF_USER_NOT_UPDT_IN_GRP").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>"));
                    }
                }
                else
                {
                    returnMap.put("errorFlag","true");
                    returnMap.put("errorMessage",bundle.getString("UAF_USER_NOT_MEMBER_OF_GRP").replaceAll("eid", "<B>"+EID+"</B>").replaceAll("fullname", "<B>"+userDataBean.getFullName()+"</B>").replaceAll("groupid", "<B>"+groupID+"</B>").replaceAll("groupname", "<B>"+grpDataBean.getGroupName()+"</B>").replaceAll("grouphandle", "<B>"+grpDataBean.getGroupHandle()+"</B>"));
                }
            }
        }
        }
        catch(Exception ex){
            System.out.println(ex);
        }
        finally
        {    
            if ((jcrSession!=null) && closeSession)
                        jcrSession.logout();       
            jcrSession=null;
        }  

        return returnMap;
    }

    /**
     * Method to create user in CQ.
     * 
     * @param EID
     * @param propertyMap
     * @return boolean(True->If created successfully, False->If not created).
     */
    public synchronized boolean createUserInCQ(String EID, Map propertyMap) throws Exception
    {
        return iUserGroupDetailsDAO.createUserInCQ(EID, propertyMap);
    }

    /**
     * Method to replicate group on publish instances.
     * 
     * @param groupID
     * @return boolean
     */
    public boolean replicateGroupOnPublish(String groupID) throws Exception
    {
        return iReplicationService.replicateGroupOnPublish(groupID);
    }

    /**
     * Method to replicate user on publish instances.
     * 
     * @param EID
     * @return boolean
     */
    public boolean replicateUserOnPublish(String EID) throws Exception
    {
        return iReplicationService.replicateUserOnPublish(EID);
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
    
    public void setCloseSession(boolean closeSession){
        this.closeSession=closeSession;
    }
      
}