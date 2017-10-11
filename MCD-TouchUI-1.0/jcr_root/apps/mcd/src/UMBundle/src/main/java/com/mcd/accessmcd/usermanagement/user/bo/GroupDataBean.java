package com.mcd.accessmcd.usermanagement.user.bo;

public class GroupDataBean
{
    private String adminUsers = "";
    private String groupDescription = "";
    private String groupHandle = "";
    private String groupName = "";
    private String groupID = "";
    private String siteURL = "";

    /**
     * Method to get admin users.
     * 
     * @return adminUsers
     */
    public String getAdminUsers()
    {
        return adminUsers;
    }

    /**
     * Method to set admin users.
     * 
     * @param adminUsers
     */
    public void setAdminUsers(String adminUsers)
    {
        this.adminUsers = adminUsers;
    }

    /**
     * Method to get group description.
     * 
     * @return groupDescription
     */
    public String getGroupDescription()
    {
        return groupDescription;
    }

    /**
     * Method to set group description.
     * 
     * @param groupDescription
     */
    public void setGroupDescription(String groupDescription)
    {
        this.groupDescription = groupDescription;
    }

    /**
     * Method to get group handle.
     * 
     * @return groupHandle
     */
    public String getGroupHandle()
    {
        return groupHandle;
    }

    /**
     * Method to set group handle.
     * 
     * @param groupHandle
     */
    public void setGroupHandle(String groupHandle)
    {
        this.groupHandle = groupHandle;
    }

    /**
     * Method to get group name.
     * 
     * @return groupName
     */
    public String getGroupName()
    {
        return groupName;
    }

    /**
     * Method to set group name.
     * 
     * @param groupName
     */
    public void setGroupName(String groupName)
    {
        this.groupName = groupName;
    }

    /**
     * Method to get group ID.
     * 
     * @return groupID
     */
    public String getGroupID()
    {
        return groupID;
    }

    /**
     * Method to set group ID.
     * 
     * @param groupID
     */
    public void setGroupID(String groupID)
    {
        this.groupID = groupID;
    }

    public String getSiteURL()
    {
        return siteURL;
    }

    public void setSiteURL(String siteURL)
    {
        this.siteURL = siteURL;
    }
}