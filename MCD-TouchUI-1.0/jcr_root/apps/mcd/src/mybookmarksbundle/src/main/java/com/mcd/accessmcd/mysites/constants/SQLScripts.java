/*
 * Project: AccessMCD
 *
 * @(#)SQLScripts.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Class contains the SQL Scripts
 *                                      Used in Application.
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
public class SQLScripts
{
    public static String GET_GLOBAL_SITE_LIST_SQL = "SELECT MSE.SITE_ID, MS.SITE_NA AS GLOBAL_TITLE, " +
                    "MSUI.SITE_NA AS UPDATED_TITLE, MS.URL_TX, MSUI.ORD FROM MYMCD_ENTY_TYP MET " +
                    "INNER JOIN MYMCD_SITE_ENTY MSE ON MSE.ENTY_TYP_ID = MET.ENTY_TYP_ID " +
                    "INNER JOIN ( " +
                    "  SELECT MSA.AUD_TYP_ID, MSA.SITE_ID FROM MYMCD_AUD_TYP MAT " +
                    "  INNER JOIN MYMCD_SITE_AUD MSA ON MAT.AUD_TYP_ID = MSA.AUD_TYP_ID " +
                    "  WHERE UPPER(MAT.AUD_TYP_DS) = UPPER(?) " +
                    ") AUDSITES ON MSE.SITE_ID = AUDSITES.SITE_ID " +
                    "LEFT JOIN MYMCD_SITE_USER_ID MSUI ON MSE.SITE_ID = MSUI.SITE_ID AND MSUI.UID_ID = ? " +
                    "INNER JOIN MYMCD_SITE MS ON MSE.SITE_ID = MS.SITE_ID " +
                    "WHERE UPPER(MET.ENTY_TYP_DS) = UPPER(?) AND (MSUI.ACT_IND <> ? OR MSUI.ACT_IND IS NULL) " +
                    "UNION " +
                    "SELECT 0 AS SITE_ID, MPB.SITE_NA AS GLOBAL_TITLE, MPB.SITE_NA AS UPDATED_TITLE, MPB.URL_TX, " +
                    "MPB.ORD " +
                    "FROM MYMCD_PER_BKMARK MPB WHERE MPB.UID_ID = ? AND MPB.ACT_IND <> ? " +
                    "ORDER BY GLOBAL_TITLE, ORD ";
    public static String GET_FAVORITE_SITE_LIST_SQL = "SELECT MSUI.SITE_ID, MS.SITE_NA AS GLOBAL_TITLE, " +  
                    "MSUI.SITE_NA AS UPDATED_TITLE, MS.URL_TX, MSUI.ORD FROM MYMCD_SITE_USER_ID MSUI " +
                    "INNER JOIN MYMCD_SITE MS ON MSUI.SITE_ID = MS.SITE_ID " +
                    "WHERE (MSUI.ACT_IND = ? OR MSUI.ACT_IND IS NULL) AND MSUI.UID_ID = ? " +
                    "UNION " +
                    "SELECT 0 AS SITE_ID, MPB.SITE_NA AS GLOBAL_TITLE, MPB.SITE_NA AS UPDATED_TITLE, MPB.URL_TX, " +
                    "MPB.ORD " +
                    "FROM MYMCD_PER_BKMARK MPB WHERE MPB.UID_ID = ? AND MPB.ACT_IND = ? " +
                    "ORDER BY ORD";
    public static String DELETE_FAVORITE_GLOBAL_SITE_LIST_SQL = "DELETE FROM MYMCD_SITE_USER_ID WHERE UID_ID = ?";
    public static String DELETE_FAVORITE_PERSONAL_SITE_LIST_SQL = "DELETE FROM MYMCD_PER_BKMARK WHERE UID_ID = ?";
    public static String INSERT_PERSONAL_BOOKMARK_FOR_USER_SQL = "INSERT INTO MYMCD_PER_BKMARK " +
                    "(UID_ID, SITE_NA, URL_TX, ORD, ACT_IND) " +
                    "VALUES(?, ?, ?, ?, ?)";
    public static String INSERT_GLOBAL_BOOKMARK_FOR_USER_SQL = "INSERT INTO MYMCD_SITE_USER_ID " +
                    "(UID_ID, SITE_ID, ORD, SITE_NA, ACT_IND) " +
                    "VALUES(?, ?, ?, ?, ?)";
    public static String CHECK_ISADMINISTRATOR_SQL = "SELECT count(*) FROM MYMCD_SECURITY WHERE UID_ID  = ? " +
                    "AND UPPER(VIRTUAL_PORTAL) = UPPER(?)";
    public static String CHECK_ISSUPERUSER_SQL = "SELECT count(*) FROM MYMCD_SECURITY WHERE UID_ID  = ? " +
                    "AND UPPER(VIRTUAL_PORTAL) = UPPER(?) AND MANAGE_USER_FLAG = ?";
    public static String OVERRIDE_PERSONAL_BOOKMARK_SQL = "UPDATE MYMCD_PER_BKMARK SET URL_TX = ? " +
                    "WHERE UID_ID = ? AND SITE_NA = ?";
    public static String CHECK_PERSONAL_BOOKMARK_SQL = "SELECT COUNT(*) AS COUNT FROM MYMCD_PER_BKMARK WHERE UID_ID = ? " +
                    "AND SITE_NA = ?";
    public static String GET_MAX_ORDER_FOR_FAVORITE_BOOKMARK_SQL = "SELECT (CASE WHEN MAX(ORD) IS NULL THEN 1 ELSE " +
                    "MAX(ORD) END) AS ORD FROM " +
                    "(" +
                    "SELECT ORD FROM MYMCD_SITE_USER_ID WHERE UID_ID = ? AND (ACT_IND = ? OR ACT_IND IS NULL) " +
                    "UNION " +
                    "SELECT ORD FROM MYMCD_PER_BKMARK WHERE UID_ID = ? AND (ACT_IND = ? OR ACT_IND IS NULL) " +
                    ")";    
    public static String GET_FAVORITE_SITE_LIST_COUNT_SQL = "SELECT COUNT(*) AS COUNT FROM " +
                    "(SELECT MSUI.SITE_ID, MS.SITE_NA AS GLOBAL_TITLE, " +  
                    "MSUI.SITE_NA AS UPDATED_TITLE, MS.URL_TX, MSUI.ORD FROM MYMCD_SITE_USER_ID MSUI " +
                    "INNER JOIN MYMCD_SITE MS ON MSUI.SITE_ID = MS.SITE_ID " +
                    "WHERE (MSUI.ACT_IND = ? OR MSUI.ACT_IND IS NULL) AND MSUI.UID_ID = ? " +
                    "UNION " +
                    "SELECT 0 AS SITE_ID, MPB.SITE_NA AS GLOBAL_TITLE, MPB.SITE_NA AS UPDATED_TITLE, MPB.URL_TX, " +
                    "MPB.ORD " +
                    "FROM MYMCD_PER_BKMARK MPB WHERE MPB.UID_ID = ? AND MPB.ACT_IND = ? " +
                    "ORDER BY ORD)";
    public static String GET_SITES_SQL = "SELECT SITE_NA, URL_TX FROM MYMCD_SITE WHERE SITE_NA = ?";
    public static String CHECK_SITES_SQL = "SELECT DISTINCT MS.SITE_NA, MS.URL_TX FROM MYMCD_SITE MS " +
                    "INNER JOIN MYMCD_SITE_ENTY MSE ON MS.SITE_ID = MSE.SITE_ID " +
                    "INNER JOIN MYMCD_ENTY_TYP MET ON MSE.ENTY_TYP_ID = MET.ENTY_TYP_ID " +
                    "WHERE MS.SITE_NA = ?";
    public static String GET_SEQUENCE_SQL = "SELECT SEQ_SITE_ID.NEXTVAL FROM DUAL";
    public static String INSERT_SITE_SQL = "INSERT INTO MYMCD_SITE (SITE_ID, URL_TX, SITE_NA) VALUES (?, ?, ?)";
    public static String INSERT_SITE_ENTITY_SQL = "INSERT INTO MYMCD_SITE_ENTY (SITE_ID, ENTY_TYP_ID) VALUES (?, ?)";
    public static String INSERT_SITE_AUDIENCE_TYPE_SQL = "INSERT INTO MYMCD_SITE_AUD (SITE_ID, AUD_TYP_ID) VALUES (?, ?)";
    public static String UPDATE_SITE_SQL = "UPDATE MYMCD_SITE SET URL_TX = ?, SITE_NA = ? WHERE SITE_NA = ?";
    public static String GET_SITE_ID_SQL = "SELECT DISTINCT MS.SITE_ID FROM MYMCD_SITE MS " +
                    "INNER JOIN MYMCD_SITE_ENTY MSE ON MS.SITE_ID = MSE.SITE_ID " +
                    "INNER JOIN MYMCD_ENTY_TYP MET ON MSE.ENTY_TYP_ID = MET.ENTY_TYP_ID " +
                    "WHERE MS.SITE_NA = ? AND UPPER(MET.ENTY_TYP_DS) = UPPER(?)";
    public static String DELETE_SITE_AUDIENCE_TYPE_SQL = "DELETE FROM MYMCD_SITE_AUD WHERE SITE_ID = ?";
    public static String DELETE_SITE_SQL = "DELETE FROM MYMCD_SITE WHERE SITE_ID = ?";
    public static String DELETE_SITE_ENTITY_SQL = "DELETE FROM MYMCD_SITE_ENTY WHERE SITE_ID = ?";
    public static String GET_ALL_AUDIENCE_TYPE_SQL = "SELECT * FROM MYMCD_AUD_TYP ORDER BY AUD_TYP_ID";
    public static String GET_ADMIN_USER_LIST_SQL = "SELECT * FROM MYMCD_SECURITY WHERE UPPER(VIRTUAL_PORTAL) = UPPER(?)";
    public static String GET_ADMIN_USER_SQL = "SELECT * FROM MYMCD_SECURITY WHERE UID_ID = ? AND UPPER(VIRTUAL_PORTAL) = UPPER(?)";
    public static String CHECK_DUPLICATE_ADMIN_USER_SQL = "SELECT count(*) FROM MYMCD_SECURITY WHERE uid_id = ? AND UPPER(virtual_portal) = UPPER(?)";
    public static String INSERT_ADMIN_USER_SQL = "INSERT INTO MYMCD_SECURITY (uid_id, virtual_portal, manage_user_flag) VALUES (?, ?, ?)";
    public static String UPDATE_ADMIN_USER_SQL = "UPDATE MYMCD_SECURITY SET manage_user_flag = ? WHERE uid_id = ? AND UPPER(virtual_portal) = UPPER(?)";
    public static String DELETE_ADMIN_USER_SQL = "DELETE FROM MYMCD_SECURITY WHERE UID_ID = ? AND UPPER(VIRTUAL_PORTAL) = UPPER(?)";
    public static String GET_SITE_ENTITY_TYPE_SQL = "SELECT MET.ENTY_TYP_ID, MET.ENTY_TYP_DS FROM MYMCD_SECURITY MSEC " +
                    "INNER JOIN MYMCD_ENTY_TYP MET ON UPPER(MSEC.VIRTUAL_PORTAL) = UPPER(MET.ENTY_TYP_DS) " +
                    "INNER JOIN MYMCD_SITE_ENTY MSE ON MET.ENTY_TYP_ID = MSE.ENTY_TYP_ID " +
                    "INNER JOIN MYMCD_SITE MS ON MSE.SITE_ID = MS.SITE_ID " +
                    "WHERE MSEC.UID_ID = ? AND MS.SITE_NA = ? ";
    public static String GET_SITE_AUDIENCE_TYPE_SQL = "SELECT DISTINCT MSA.SITE_ID, ENTYS.ENTY_TYP_ID, ENTYS.ENTY_TYP_DS, MAT.AUD_TYP_ID, MAT.AUD_TYP_DS " +
                    "FROM MYMCD_AUD_TYP MAT " +
                    "INNER JOIN MYMCD_SITE_AUD MSA ON MAT.AUD_TYP_ID = MSA.AUD_TYP_ID " +
                    "INNER JOIN MYMCD_SITE MS ON MSA.SITE_ID = MS.SITE_ID " +
                    "INNER JOIN (" +
                    "  SELECT MSE.SITE_ID, MET.ENTY_TYP_ID, MET.ENTY_TYP_DS FROM MYMCD_SITE_ENTY MSE" +
                    "  INNER JOIN MYMCD_ENTY_TYP MET ON MSE.ENTY_TYP_ID = MET.ENTY_TYP_ID" +
                    "  INNER JOIN MYMCD_SITE MS ON MSE.SITE_ID = MS.SITE_ID" +
                    "  WHERE MS.SITE_NA = ? AND UPPER(MET.ENTY_TYP_DS) = UPPER(?) " +
                    ") ENTYS ON MSA.SITE_ID = ENTYS.SITE_ID " +
                    "WHERE MS.SITE_NA = ? " +
                    "ORDER BY ENTYS.ENTY_TYP_DS, MAT.AUD_TYP_DS";
    public static String GET_ENTITY_TYPE_ID_SQL = "SELECT enty_typ_id FROM MYMCD_ENTY_TYP WHERE UPPER(enty_typ_ds) = UPPER(?)";
    public static String DELETE_USER_SITE_ID_RECORD_SQL = "DELETE FROM MYMCD_SITE_USER_ID WHERE SITE_ID = ?";
    public static String GET_ENTITY_TYPES_SQL = "SELECT MENC.ENTY_TYP_ID, MENC.ENTY_TYP_DS FROM MYMCD_SECURITY MSEC " +
                    "INNER JOIN MYMCD_ENTY_TYP MENC ON UPPER(MSEC.VIRTUAL_PORTAL) = UPPER(MENC.ENTY_TYP_DS) " +
                    "WHERE MSEC.UID_ID = ?";
}