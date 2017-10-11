package com.mcd.accessmcd.usermanagement.user.dao;

import java.util.ArrayList;
import java.util.Map;

import com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean;
import com.mcd.accessmcd.usermanagement.user.bo.UserDataBean;

public interface IUserGroupDetailsDAO
{

    /**
     * Method is used to validate the EID is administrator of any group or not.
     * 
     * @param EID
     * @return boolean (True->Admin & False->Not Admin)
     */
    public boolean checkIsAdmin(String EID) throws Exception;
    
    /**
     * Method is used to validate the EID is member of priviledge Group. 
     * @param EID
     * @return boolean (True->Admin & False->Not Admin)
     */
    public boolean checkForAdminDropDown(String EID) throws Exception;

    /**
     * Method to get arraylist of GroupDataBean objects in which the role of
     * user is admin.
     * 
     * @param EID
     * @return ArrayList<GroupDataBean>
     */
    ArrayList<GroupDataBean> getGroupsAdminForUser(String EID) throws Exception;

    /**
     * Method to get arraylist of GroupDataBean objects in which user belongs
     * to.
     * 
     * @param EID
     * @return ArrayList<GroupDataBean>
     */
    ArrayList<GroupDataBean> getUserGroupsDetails(String EID) throws Exception;

    /**
     * Method to get arraylist of GroupDataBean objects in which user group
     * access details.
     * 
     * @param groupID
     * @param EID
     * @return ArrayList<GroupDataBean>
     */
    ArrayList<GroupDataBean> getUserGroupAccessDetails(String groupID, String EID) throws Exception;

    /**
     * Method to get size of members in a Group.
     * 
     * @param groupID
     * @return int
     */
    int getGroupMembersSize(String groupID) throws Exception;
    
    /**
     * Method to get arraylist of UserDataBean objects for a group members.
     * 
     * @param groupID
     * @param maxLimit
     * @return ArrayList<UserDataBean>
     */
    ArrayList<UserDataBean> getGroupMembersDetails(String groupID, String maxLimit) throws Exception;

    /**
     * Method to get UserDataBean object for user information.
     * 
     * @param EID
     * @return UserDataBean Object
     */
    public UserDataBean getUserDetails(String EID) throws Exception;

    /**
     * Method to get the List of Admin Users for a group.
     * 
     * @param groupID
     * @return ArrayList<UserDataBean>
     */
    public ArrayList<UserDataBean> getAdminUsersForGroup(String groupID) throws Exception;
    
    /**
     * Method to get the List of only Normal Users for a group.
     * 
     * @param groupID
     * @return ArrayList<UserDataBean>
     */
    public ArrayList<UserDataBean> getNormalUsersForGroup(String groupID) throws Exception;

    /**
     * Method to get group details
     * 
     * @param groupID
     * @return GroupDataBean Object
     */
    public GroupDataBean getGroupDetails(String groupID) throws Exception;
    
    /**
     * Method used to Add/Update or Delete the Users from group.
     * @param EID
     * @param groupID
     * @param action
     * @param isAdmin
     * @return boolean (true --> if action is successful false --> if action is unsuccessful).
     */
    public boolean updateUserGroup(String EID, String groupID, String action, boolean isAdmin) throws Exception;

    /**
     * Method to create user in CQ.
     * 
     * @param EID
     * @param propertyMap
     * @return boolean(True->If created successfully, False->If not created).
     */
    public boolean createUserInCQ(String EID, Map propertyMap) throws Exception;
    
     /**
     * Method is used to check user in LDAP
     * 
     * @param EID
     * @return boolean (True-> If exists, False-> If not exists)
     */
    public boolean checkUserInLDAP(String EID) throws Exception;    

    /**
     * Method to get user properties from LDAP
     * 
     * @param EID
     * @return Map Containing User Properties from LDAP
     */
    public Map getUserPropertiesFromLDAP(String EID) throws Exception;
}