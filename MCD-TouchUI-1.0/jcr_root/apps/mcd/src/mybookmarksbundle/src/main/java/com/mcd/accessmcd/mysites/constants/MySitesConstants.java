/*
 * Project: AccessMCD
 *
 * @(#)MySitesConstants.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Class contains the Constant
 *                                      Variables Used in Application.
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

package com.mcd.accessmcd.mysites.constants;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public class MySitesConstants 
{
    public static String DEFAULT_DSN = "mySitesDSN";
    
    public static String DEFAULT_ENTITY_TYPE = "corp";
    public static String DEFAULT_AUDIENCE_TYPE = "CorpEmployees";
    
    public static String US_PAGE_HEADER_TEXT = "/us/";
    public static String AU_PAGE_HEADER_TEXT = "/au/";
    public static String JAPAN_PAGE_HEADER_TEXT = "/japan/";
    public static String GLOBAL_PAGE_HEADER_TEXT = "/global/";
    
    public static String US_ENTITY_TYPE = "US";
    public static String AU_ENTITY_TYPE = "AU";
    public static String JAPAN_ENTITY_TYPE = "JAPAN";
    public static String GLOBAL_ENTITY_TYPE = "CORP";
    
    public static int MAX_SITES = 30;
    
    public static String USER_ADDED_SUCCESSFULLY = "MB_USER_ADDED_SUCCESSFULLY";
    public static String USER_ALREADY_EXISTS = "MB_USER_ALREADY_EXISTS";
    public static String USER_UPDATED_SUCCESSFULLY = "MB_USER_UPDATED_SUCCESSFULLY";
    public static String USER_DELETED_SUCCESSFULLY = "MB_USER_DELETED_SUCCESSFULLY";
    public static String SITE_ALREADY_EXISTS = "MB_SITE_ALREADY_EXISTS";
    public static String NO_AUD_TYPE_SELECTED = "MB_NO_AUD_TYPE_SELECTED";
    public static String SITE_ADDED_SUCCESSFULLY = "MB_SITE_ADDED_SUCCESSFULLY";
    public static String SITE_UPDATED_SUCCESSFULLY = "MB_SITE_UPDATED_SUCCESSFULLY";
    public static String SITE_DELETED_SUCCESSFULLY = "MB_SITE_DELETED_SUCCESSFULLY";
    
    public static String BOOKMARK_ALREADY_EXISTS_OVERRIDE = "MB_BOOKMARK_ALREADY_EXISTS_OVERRIDE";
    public static String BOOKMARK_ADDED_SUCCESSFULLY = "MB_BOOKMARK_ADDED_SUCCESSFULLY";
    public static String BOOKMARK_UPDATED_SUCCESSFULLY = "MB_BOOKMARK_UPDATED_SUCCESSFULLY";
    public static String FAV_BOOKMARK_SITE_LIMIT_EXEEDED = "MB_FAV_BOOKMARK_SITE_LIMIT_EXEEDED";
}