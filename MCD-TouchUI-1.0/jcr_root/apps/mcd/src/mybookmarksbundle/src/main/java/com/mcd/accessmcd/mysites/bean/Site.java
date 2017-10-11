/*
 * Project: AccessMCD
 *
 * @(#)Site.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Bean Class contains the data
 *                                      of a single Site.
 * -----------------------------------------------------------------------                                             
 * Description:
 * This software is the confidential and proprietary information of
 * McDonald's Corp. ("Confidential Information").
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with McDonald's.
 *
 * Copyright (c) 2010 McDonalds Corp.
 * All Rights Reserved.
 * www.mcdonalds.com
 */

package com.mcd.accessmcd.mysites.bean;

import java.util.*;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public class Site
{
    private String siteID = "";
    private String siteURI = "";
    private String newSiteName = "";
    private String siteName = "";
    private String isLinkUpdated = "";
    private String order = "";
    private String ActiveIndicator = "";
    private Vector<EntityType> entityType = new Vector<EntityType>();
    private Map<String, List<AudienceType>> audienceType = new HashMap<String, List<AudienceType>>();

    /**
     * method to get siteID.
     * @return String siteID
     */
    public String getSiteID()
    {
        return siteID;
    }

    /**
     * method to set siteID.
     * @param siteID
     */
    public void setSiteID(String siteID)
    {
        this.siteID = siteID;
    }

    /**
     * method to get siteName
     * @return String siteName.
     */
    public String getSiteName()
    {
        return siteName;
    }

    /**
     * method to set siteName.
     * @param siteName
     */
    public void setSiteName(String siteName)
    {
        this.siteName = siteName;
    }

    /**
     * method to get the flag whether the Site is updated.
     * @return String updated flag.
     */
    public String getIsLinkUpdated()
    {
        return isLinkUpdated;
    }

    /**
     * method to set the flag whether the Site is updated.
     * @param isLinkUpdated
     */
    public void setIsLinkUpdated(String isLinkUpdated)
    {
        this.isLinkUpdated = isLinkUpdated;
    }

    /**
     * method to get the Active Indicator Flag.
     * @return String ActiveIndicator
     */
    public String getActiveIndicator()
    {
        return ActiveIndicator;
    }

    /**
     * method to set the Active Indicator Flag.
     * @param activeIndicator
     */
    public void setActiveIndicator(String activeIndicator)
    {
        ActiveIndicator = activeIndicator;
    }

    /**
     * method to get the order of site.
     * @return String Order
     */
    public String getOrder()
    {
        return order;
    }

    /**
     * method to set the order of site.
     * @param order
     */
    public void setOrder(String order)
    {
        this.order = order;
    }

    /**
     * method to get siteURI
     * @return String siteURI
     */
    public String getSiteURI()
    {
        return siteURI;
    }

    /**
     * method to set siteURI
     * @param siteURI
     */
    public void setSiteURI(String siteURI)
    {
        this.siteURI = siteURI;
    }

    /**
     * method to get new Site Name.
     * @return new Site Name.
     */
    public String getNewSiteName()
    {
        return newSiteName;
    }

    /**
     * method to set new Site Name.
     * @param newSiteName
     */
    public void setNewSiteName(String newSiteName)
    {
        this.newSiteName = newSiteName;
    }

    /**
     * method to get the Entity Types.
     * @return Vector EntityType
     */
    public Vector<EntityType> getEntityType()
    {
        return entityType;
    }

    /**
     * method to set the Entity Types.
     * @param entityType
     */
    public void setEntityType(Vector<EntityType> entityType)
    {
        this.entityType = entityType;
    }

    /**
     * method to get the Audience Type Map against each entity.
     * @return Map AudienceType
     */
    public Map<String, List<AudienceType>> getAudienceType()
    {
        return audienceType;
    }

    /**
     * method to set the Audience Type Map against each entity.
     * @param audienceType
     */
    public void setAudienceType(Map<String, List<AudienceType>> audienceType)
    {
        this.audienceType = audienceType;
    }
}