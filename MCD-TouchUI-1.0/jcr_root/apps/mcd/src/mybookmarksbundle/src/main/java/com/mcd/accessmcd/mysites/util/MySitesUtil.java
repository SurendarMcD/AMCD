/*
 * Project: AccessMCD
 *
 * @(#)MySitesUtil.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Utility Class is used for
 *                                      getting Audience Type and Entity 
 *                                      type.
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

package com.mcd.accessmcd.mysites.util;

import javax.jcr.Session;

import org.apache.sling.api.scripting.SlingScriptHelper;

import com.day.cq.security.NoSuchAuthorizableException;
import com.day.cq.security.User;
import com.day.cq.security.UserManager;
import com.day.cq.security.UserManagerFactory;
import com.day.cq.wcm.api.Page;
import com.mcd.accessmcd.mysites.constants.MySitesConstants;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public class MySitesUtil
{
    SlingScriptHelper sling = null;
    Session jcrSession = null;
    
    /**
     * Parameterized Constructor.
     * @param sling
     * @param jcrSession
     */
    public MySitesUtil(SlingScriptHelper sling, Session jcrSession)
    {
        this.sling = sling;
        this.jcrSession = jcrSession;
    }
    
    /**
     * This method returns the Entity Name based on the Page's handle.
     * @param currPage
     * @return String Entity Name.
     * @throws Exception
     */
    public String getEntityType(Page currPage) throws Exception
    {
        String pagePath = currPage.getPath();
        String entityType = "";
        
        if(pagePath.indexOf(MySitesConstants.US_PAGE_HEADER_TEXT) != -1)
            entityType = MySitesConstants.US_ENTITY_TYPE;
        else if(pagePath.indexOf(MySitesConstants.AU_PAGE_HEADER_TEXT) != -1)
            entityType = MySitesConstants.AU_ENTITY_TYPE;
        else if(pagePath.indexOf(MySitesConstants.JAPAN_PAGE_HEADER_TEXT) != -1)
            entityType = MySitesConstants.JAPAN_ENTITY_TYPE;
        else if(pagePath.indexOf(MySitesConstants.GLOBAL_PAGE_HEADER_TEXT) != -1)
            entityType = MySitesConstants.GLOBAL_ENTITY_TYPE;
        
        return entityType;
    }

    /**
     * This method gets the user audience type of a user.
     * @param userId
     * @return String Audience Type.
     * @throws Exception
     */
    public String getUserAudienceType(String userId) throws Exception
    {
        UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
        UserManager cqMgr = userManagerFactory.createUserManager(jcrSession);
        User user=null;
        String audienceType = "";
        try
        {
            user=(User)cqMgr.get(userId);
            if(user!=null)
            {
                audienceType = checkNull(user.getProperty("rep:mcdAudience"));
            }            
        }
        catch(NoSuchAuthorizableException e)
        {
            e.printStackTrace();
        }
        return audienceType;
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
}