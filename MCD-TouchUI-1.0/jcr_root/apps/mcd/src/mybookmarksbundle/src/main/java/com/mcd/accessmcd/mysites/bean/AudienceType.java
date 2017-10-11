/*
 * Project: AccessMCD
 *
 * @(#)AudienceType.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Bean Class contains the
 *                                      data for a single Audience Type.
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
public class AudienceType implements Serializable
{
    private String audienceTypeId = null;
    private String audienceType = null;
    
    /**
     * The Constructor used to initialise the AudienceType Object
     */
    public AudienceType()
    {
    }
    
    /**
     * The Parameterised Constructor.
     * @param audienceTypeId
     * @param audienceType
     */
    public AudienceType(String audienceTypeId, String audienceType)
    {
        this.audienceTypeId = audienceTypeId;
        this.audienceType = audienceType;
    }
    
    /**
     * method to get the audienceTypeId.
     * @return  Returns the audienceTypeId.
     */
    public String getAudienceTypeId()
    {
        return audienceTypeId;
    }
    
    /**
     * method to set the audienceTypeId.
     * @param audienceTypeId.
     */
    public void setAudienceTypeId(String audienceTypeId)
    {
        this.audienceTypeId = audienceTypeId;
    }
    
    /**
     * method to get the audienceType.
     * @return  Returns the audienceType.
     */
    public String getAudienceType()
    {
        return audienceType;
    }
    
    /**
     * method to set the audienceType.
     * @param audienceType.
     */
    public void setAudienceType(String audienceType)
    {
        this.audienceType = audienceType;
    }
}