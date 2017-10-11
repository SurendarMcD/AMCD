/*
 * Project: AccessMCD
 *
 * @(#)EntityType.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Bean Class contains the
 *                                      data for a single Entity Type.
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
public class EntityType implements Serializable
{
    private String entityTypeId = null;
    private String entityType = null;
    
    /**
     * The Constructor used to initialise the EntityType Object
     */
    public EntityType()
    {
    }
    
    /**
     * The Parameterised Constructor.
     * @param entityTypeId
     * @param entityType
     */
    public EntityType(String entityTypeId, String entityType)
    {
        this.entityTypeId = entityTypeId;
        this.entityType = entityType;
    }
    
    /**
     * method to get entityTypeId.
     * @return Returns the entityTypeId.
     */
    public String getEntityTypeId()
    {
        return entityTypeId;
    }

    /**
     * method to set entityTypeId.
     * @param entityTypeId.
     */
    public void setEntityTypeId(String entityTypeId)
    {
        this.entityTypeId = entityTypeId;
    }
    
    /**
     * method to get entityType.
     * @return Returns the entityType.
     */
    public String getEntityType()
    {
        return entityType;
    }
    
    /**
     * method to set entityType.
     * @param entityType.
     */
    public void setEntityType(String entityType)
    {
        this.entityType = entityType;
    }
}