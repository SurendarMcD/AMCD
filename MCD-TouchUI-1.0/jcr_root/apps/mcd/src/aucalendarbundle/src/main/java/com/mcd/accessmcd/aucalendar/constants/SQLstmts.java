/*
 * Project: AccessMCD
 *
 * @(#)SQLstmts.java
 * Revisions:
 * Date            Author           Description
 * -----------------------------------------------------------------------
 * 01/18/2011     Judy Zhang    This Class contains the SQL Scripts
 *                              Used in AU calendar / Notice board Application.
 * -----------------------------------------------------------------------                                             
 * Description:
 * This software is the confidential and proprietary information of
 * McDonald's Corp. ("Confidential Information").
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with McDonald's.
 *
 * Copyright (c) 2011 McDonalds Corp.
 * All Rights Reserved.
 * www.accessmcd.com
 */

package com.mcd.accessmcd.aucalendar.constants;


/**
 * @author Judy Zhang
 * @version 1.0
 * @since 1.0
 */
 
public class SQLstmts
{
/*
    public static String SELECT_POST_SQL = "SELECT * from PCI_CTNT c1 INNER JOIN PCI_CTNT_DTL d1 ON c1.ID = d1.CTNT_ID where d1.CAT_ID = ? and d1.ACTV_FL = '1'";
    public static String SELECT_CTNT_SQL = "SELECT * from PCI_CTNT c1 INNER JOIN PCI_CTNT_DTL d1 ON c1.ID = d1.CTNT_ID where c1.ID = ? and d1.ACTV_FL = '1'";

    public static String DELETE_POST_SQL = "UPDATE PCI_CTNT_DTL SET ACTV_FL = '0' where CTNT_ID = ?";

    public static String GET_CTNT_SEQUENCE_SQL = "SELECT SEQ_PCI_CTNT.CURRVAL FROM DUAL";
    public static String GET_CTNT_DTL_SEQUENCE_SQL = "SELECT SEQ_PCI_CTNT_DTL.CURRVAL FROM DUAL";

    public static String INSERT_CTNT_SQL = "INSERT INTO PCI_CTNT " +
                    "(ID, DOC_URI,ISRT_DT,ISRT_USER,AUD_IDS) " +
                    "VALUES(SEQ_PCI_CTNT.NEXTVAL, ?, SYSDATE, ?, ?)";
    public static String INSERT_CTNT_DTL_SQL = "INSERT INTO PCI_CTNT_DTL " +
                    "(ID, CTNT_ID,CAT_ID,VIEW_ID,TITLE,DS,LNCH_TYP,ACTV_FL,PUBL_DT,ISRT_DT) " +
                    "VALUES(SEQ_PCI_CTNT_DTL.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, TO_DATE(?, 'yyyy-MM-dd HH24:MI:SS'), SYSDATE)";
    public static String INSERT_CTNT_AUD_SQL = "INSERT INTO PCI_CTNT_AUD " +
                    "(CTNT_ID,AUD_ID) " +
                    "VALUES(?, ?)";

    public static String UPDATE_CTNT_SQL = "UPDATE PCI_CTNT SET "+ 
                    "DOC_URI=?,MOD_DT=SYSDATE,MOD_USER=?,AUD_IDS=? where ID=?";
    public static String DELETE_CTNT_SQL = "DELETE from PCI_CTNT_AUD where CTNT_ID=?";                    


    public static String DELETE_CTNT_DTL_SQL = "DELETE from PCI_CTNT_DTL where CTNT_ID=?";                    
    public static String UPDATE_CTNT_DTL_SQL = "INSERT INTO PCI_CTNT_DTL " +
                    "(ID, CTNT_ID,CAT_ID,VIEW_ID,TITLE,DS,LNCH_TYP,ACTV_FL,PUBL_DT) " +
                    "VALUES(SEQ_PCI_CTNT_DTL.NEXTVAL, ?, ?, ?, ?, ?, ?, ?,TO_DATE(?, 'yyyy-MM-dd HH24:MI:SS'))";

    public static String DELETE_CTNT_AUD_SQL = "DELETE from PCI_CTNT_AUD where CTNT_ID=?";                    
    public static String UPDATE_CTNT_AUD_SQL = "UPDATE PCI_CTNT_AUD SET AUD_ID =? where CTNT_ID=?"; 
*/

    public static String SELECT_POST_SQL = "SELECT * from PCI_CTNT c1 INNER JOIN PCI_CTNT_DTL d1 ON c1.ID = d1.CTNT_ID where d1.CAT_ID = ? and d1.ACTV_FL = '1'";

//select content based on content id
    public static String SELECT_CTNT_SQL = "SELECT * from PCI_CTNT c1 INNER JOIN PCI_CTNT_DTL d1 ON c1.ID = d1.CTNT_ID where c1.ID = ? and d1.ACTV_FL = '1'";
//select content based on uuid
    public static String SELECT_UUID_SQL = "SELECT * from PCI_CTNT c1 INNER JOIN PCI_CTNT_DTL d1 ON c1.ID = d1.CTNT_ID where c1.UUID = ? and d1.ACTV_FL = '1'";

    public static String DELETE_POST_SQL = "UPDATE PCI_CTNT_DTL SET ACTV_FL = '0' where CTNT_ID = ?";

    public static String GET_CTNT_SEQUENCE_SQL = "SELECT SEQ_PCI_CTNT.CURRVAL FROM DUAL";
    public static String GET_CTNT_DTL_SEQUENCE_SQL = "SELECT SEQ_PCI_CTNT_DTL.CURRVAL FROM DUAL";
    public static String GET_CTNTID_SQL = "SELECT ID FROM PCI_CTNT where UUID=?";


    public static String INSERT_CTNT_SQL = "INSERT INTO PCI_CTNT " +
                    "(ID, DOC_URI,ISRT_DT,ISRT_USER,AUD_IDS,UUID) " +
                    "VALUES(SEQ_PCI_CTNT.NEXTVAL, ?, SYSDATE, ?, ?,?)";
    public static String INSERT_CTNT_DTL_SQL = "INSERT INTO PCI_CTNT_DTL " +
                    "(ID, CTNT_ID,CAT_ID,VIEW_ID,TITLE,DS,LNCH_TYP,ACTV_FL,PUBL_DT,ISRT_DT) " +
                    "VALUES(SEQ_PCI_CTNT_DTL.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, TO_DATE(?, 'yyyy-MM-dd HH24:MI:SS'), SYSDATE)";
    public static String INSERT_CTNT_AUD_SQL = "INSERT INTO PCI_CTNT_AUD " +
                    "(CTNT_ID,AUD_ID) " +
                    "VALUES(?, ?)";

    public static String UPDATE_CTNT_SQL = "UPDATE PCI_CTNT SET "+ 
                    "DOC_URI=?,MOD_DT=SYSDATE,MOD_USER=?,AUD_IDS=? where ID=?";
    public static String DELETE_CTNT_SQL = "DELETE from PCI_CTNT where CTNT_ID=?";                    

    public static String DELETE_CTNT_DTL_SQL = "DELETE from PCI_CTNT_DTL where CTNT_ID=?";                    
    public static String UPDATE_CTNT_DTL_SQL = "INSERT INTO PCI_CTNT_DTL " +
                    "(ID, CTNT_ID,CAT_ID,VIEW_ID,TITLE,DS,LNCH_TYP,ACTV_FL,PUBL_DT) " +
                    "VALUES(SEQ_PCI_CTNT_DTL.NEXTVAL, ?, ?, ?, ?, ?, ?, ?,TO_DATE(?, 'yyyy-MM-dd HH24:MI:SS'))";

    public static String DELETE_CTNT_AUD_SQL = "DELETE from PCI_CTNT_AUD where CTNT_ID=?";                    
    public static String UPDATE_CTNT_AUD_SQL = "UPDATE PCI_CTNT_AUD SET AUD_ID =? where CTNT_ID=?"; 

    


/* ref:PCIQuery    
    private static String PCI_CONTENT_QUERY_FIELDS=""+
            "CTNT.AUD_IDS AUDIENCES, "+
            "CTNT.DOC_URI, " +
            "CTNT.IMG_URL, " +
            "CTNT.MEDIA_URL, " +
            "CTNT.ALT_URL, " +
            "DTL.TITLE,  " +
            "DTL.DS,  " +
            "DTL.LNCH_TYP,  " +
            "DTL.PUBL_DT, " +
            "DTL.CTNT_ID, " +
            "DTL.ID ";
*/                   
}
    