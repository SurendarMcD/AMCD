package com.mcd.accessmcd.ace.bo;

/**
 * This class is used generating the getter & setter 
 * for the value objects 
 *
 * @author Shubhra Gupta
 * @version 1.0
 *
 */

public class ACEConfigDataBean {
    
    private String siteURL; //for storing site URL//
    private String groupName; //for storing group name//
    private String authDomainAdd; // for storing site author domain address//
    private String pubDomainAdd; // for storing site publish domain address//
    private String expirePeriod; // for storing default expire period (in months)//
    private String dateFormat; // for storing date format ()//
    private String language; // for storing site language //
    private String adminNames; //for storing admin names //
    private String nonAdminNames; //for storing non-admin names //
    private String adminMailIds; // for storing admin email addresses //
    private String nonAdminMailIds; // for storing non-admin email addresses //
    
    /**
     * @return the siteURL
     */
    public String getSiteURL() {
        return siteURL;
    }
    /**
     * @param siteURL the siteURL to set
     */
    public void setSiteURL(String siteURL) {
        this.siteURL = siteURL;
    }
    /**
     * @return the groupName
     */
    public String getGroupName() {
        return groupName;
    }
    /**
     * @param groupName the groupName to set
     */
    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
    /**
     * @return the authDomainAdd
     */
    public String getAuthDomainAdd() {
        return authDomainAdd;
    }
    /**
     * @param authDomainAdd the authDomainAdd to set
     */
    public void setAuthDomainAdd(String authDomainAdd) {
        this.authDomainAdd = authDomainAdd;
    }
    /**
     * @return the pubDomainAdd
     */
    public String getPubDomainAdd() {
        return pubDomainAdd;
    }
    /**
     * @param pubDomainAdd the pubDomainAdd to set
     */
    public void setPubDomainAdd(String pubDomainAdd) {
        this.pubDomainAdd = pubDomainAdd;
    }
    /**
     * @return the expirePeriod
     */
    public String getExpirePeriod() {
        return expirePeriod;
    }
    /**
     * @param expirePeriod the expirePeriod to set
     */
    public void setExpirePeriod(String expirePeriod) {
        this.expirePeriod = expirePeriod;
    }
    /**
     * @return the dateFormat
     */
    public String getDateFormat() {
        return dateFormat;
    }
    /**
     * @param dateFormat the dateFormat to set
     */
    public void setDateFormat(String dateFormat) {
        this.dateFormat = dateFormat;
    }
    /**
     * @return the language
     */
    public String getLanguage() {
        return language;
    }
    /**
     * @param language the language to set
     */
    public void setLanguage(String language) {
        this.language = language;
    }
    /**
     * @return the adminNames
     */
    public String getAdminNames() {
        return adminNames;
    }
    /**
     * @param adminNames the adminNames to set
     */
    public void setAdminNames(String adminNames) {
        this.adminNames = adminNames;
    }
    /**
     * @return the nonAdminNames
     */
    public String getNonAdminNames() {
        return nonAdminNames;
    }
    /**
     * @param nonAdminNames the nonAdminNames to set
     */
    public void setNonAdminNames(String nonAdminNames) {
        this.nonAdminNames = nonAdminNames;
    }
    /**
     * @return the adminMailIds
     */
    public String getAdminMailIds() {
        return adminMailIds;
    }
    /**
     * @param adminMailIds the adminMailIds to set
     */
    public void setAdminMailIds(String adminMailIds) {
        this.adminMailIds = adminMailIds;
    }
    /**
     * @return the nonAdminMailIds
     */
    public String getNonAdminMailIds() {
        return nonAdminMailIds;
    }
    /**
     * @param nonAdminMailIds the nonAdminMailIds to set
     */
    public void setNonAdminMailIds(String nonAdminMailIds) {
        this.nonAdminMailIds = nonAdminMailIds;
    }
}