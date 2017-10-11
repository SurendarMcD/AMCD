package com.mcd.accessmcd.usermanagement.user.bo;

public class UserDataBean
{
    private String eid = "";
    private String emailId = "";
    private String fullName = "";
    private String mcaudience = "";

    /**
     * Method to get eid.
     * 
     * @return eid
     */
    public String getEid()
    {
        return eid;
    }

    /**
     * Method to set eid.
     * 
     * @param eid
     */
    public void setEid(String eid)
    {
        this.eid = eid;
    }

    /**
     * Method to get email id.
     * 
     * @return emailId
     */
    public String getEmailId()
    {
        return emailId;
    }

    /**
     * Method to set email id.
     * 
     * @param emailId
     */
    public void setEmailId(String emailId)
    {
        this.emailId = emailId;
    }

    /**
     * Method to get full name.
     * 
     * @return fullName
     */
    public String getFullName()
    {
        return fullName;
    }

    /**
     * Method to set full name.
     * 
     * @param fullName
     */
    public void setFullName(String fullName)
    {
        this.fullName = fullName;
    }

    /**
     * Method to get audience.
     * 
     * @return mcaudience
     */
    public String getMcaudience()
    {
        return mcaudience;
    }

    /**
     * Method to set audience.
     * 
     * @param mcaudience
     */
    public void setMcaudience(String mcaudience)
    {
        this.mcaudience = mcaudience;
    }
}