/*
 * Project: AccessMCD
 *
 * @(#)AdminUser.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Bean Class contains
 *                                      the data for a single admin User.
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

import java.io.Serializable;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public class AdminUser implements Serializable
{
    private String userId = null;
    private String entityType = null;
    private String manageUserFlag = "N";

    /**
     * method to get the userID.
     * @return Returns the userId.
     */
    public String getUserId()
    {
        return userId;
    }

    /**
     * method to set the userID.
     * @param userId The userId to set.
     */
    public void setUserId(String userId)
    {
        this.userId = userId;
    }
    
    /**
     * method to get the entityType.
     * @return Returns the entityType.
     */
    public String getEntityType()
    {
        return entityType;
    }
    
    /**
     * method to set the entityType.
     * @param entityType The entityType to set.
     */
    public void setEntityType(String entityType)
    {
        this.entityType = entityType;
    }
    
    /**
     * method to get the manageUserFlag.
     * @return Returns the manageUserFlag.
     */
    public String getManageUserFlag()
    {
        return manageUserFlag;
    }
    
    /**
     * method to set the manageUserFlag.
     * @param manageUserFlag The manageUserFlag to set.
     */
    public void setManageUserFlag(String manageUserFlag)
    {
        this.manageUserFlag = manageUserFlag;
    }
}