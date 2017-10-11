/*
 * Project: AccessMCD
 *
 * @(#)OracleMySitesDAO.java
 * Revisions:
 * Date            Programmer           Description
 * ----------------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Class contains the Implementations
 *                                      of IMySitesDAO Interface.
 * ----------------------------------------------------------------------------
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

package com.mcd.accessmcd.mysites.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.jcr.Session;

import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mcd.accessmcd.mysites.bean.AdminUser;
import com.mcd.accessmcd.mysites.bean.AudienceType;
import com.mcd.accessmcd.mysites.bean.EntityType;
import com.mcd.accessmcd.mysites.bean.Site;
import com.mcd.accessmcd.mysites.bean.SiteList;
import com.mcd.accessmcd.mysites.constants.MySitesConstants;
import com.mcd.accessmcd.mysites.constants.SQLScripts;
import com.mcd.accessmcd.mysites.util.DBTool;
import com.mcd.accessmcd.mysites.util.MySitesUtil;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public class OracleMySitesDAO implements IMySitesDAO
{
    private static final Logger log = LoggerFactory.getLogger(OracleMySitesDAO.class);
    DBTool dbTool = null;
    SlingScriptHelper sling = null;
    Session jcrSession = null;

    /**
     * Parameterized Constructor
     * @param sling
     * @param jcrSession
     */
    public OracleMySitesDAO(SlingScriptHelper sling, Session jcrSession)
    {
        this.sling = sling;
        this.jcrSession = jcrSession;
        dbTool = new DBTool(sling, jcrSession);
    }

    /**
     * This method provides the SiteList Object which contains the Global and Favorite Site Lists.
     * @param userId
     * @param view
     * @return SiteList Object
     * @throws SQLException
     * @throws Exception
     */
    public SiteList getSiteList(String userId, String view) throws SQLException, Exception
    {
        ArrayList<Site> globalSiteList = new ArrayList<Site>();
        ArrayList<Site> favoriteSiteList = new ArrayList<Site>();

        Connection conn = null;
        PreparedStatement pstmtGetGlobalSiteList = null;
        PreparedStatement pstmtGetFavoriteSiteList = null;
        ResultSet rs = null;

        MySitesUtil msu = new MySitesUtil(sling, jcrSession);
        //String entyTyp = msu.getEntityType(currPage);
        String entyTyp = view;
        String userAudTyp = msu.getUserAudienceType(userId);

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            pstmtGetGlobalSiteList = conn.prepareStatement(SQLScripts.GET_GLOBAL_SITE_LIST_SQL);
            pstmtGetGlobalSiteList.setString(1, userAudTyp);
            pstmtGetGlobalSiteList.setString(2, userId);
            pstmtGetGlobalSiteList.setString(3, entyTyp);
            pstmtGetGlobalSiteList.setString(4, "Y");
            pstmtGetGlobalSiteList.setString(5, userId);
            pstmtGetGlobalSiteList.setString(6, "Y");

            rs = pstmtGetGlobalSiteList.executeQuery();

            while (rs.next())
            {
                Site globalSite = new Site();

                globalSite.setSiteID(rs.getString("SITE_ID"));
                globalSite.setSiteName(rs.getString("GLOBAL_TITLE"));
                globalSite.setNewSiteName(rs.getString("UPDATED_TITLE"));
                globalSite.setSiteURI(rs.getString("URL_TX"));

                globalSiteList.add(globalSite);
            }

            pstmtGetFavoriteSiteList = conn.prepareStatement(SQLScripts.GET_FAVORITE_SITE_LIST_SQL);

            pstmtGetFavoriteSiteList.setString(1, "Y");
            pstmtGetFavoriteSiteList.setString(2, userId);
            pstmtGetFavoriteSiteList.setString(3, userId);
            pstmtGetFavoriteSiteList.setString(4, "Y");

            rs = pstmtGetFavoriteSiteList.executeQuery();

            while (rs.next())
            {
                Site favoriteSite = new Site();

                favoriteSite.setSiteID(rs.getString("SITE_ID"));
                favoriteSite.setSiteName(rs.getString("GLOBAL_TITLE"));
                favoriteSite.setNewSiteName(rs.getString("UPDATED_TITLE"));
                favoriteSite.setSiteURI(rs.getString("URL_TX"));
                favoriteSiteList.add(favoriteSite);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getSiteList]:SQLException in getting site list: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getSiteList]:SQLException in getting site list: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getSiteList]:Exception in getting site list: " + e);
            throw new Exception("[OracleMySitesDAO.getSiteList]:Exception in getting site list: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmtGetGlobalSiteList, pstmtGetFavoriteSiteList);
            DBTool.closeConnection(conn);
        }

        SiteList sl = new SiteList(globalSiteList, favoriteSiteList);

        return sl;
    }

    /**
     * This method updates a user's site lists.
     * @param userId
     * @param bookmarkList
     * @return boolean
     * @throws SQLException
     * @throws Exception
     */
    public boolean updateSiteList(String userId, SiteList bookmarkList)
    {
        ArrayList<Site> globalList = bookmarkList.getGlobalSiteList();
        ArrayList<Site> favoriteList = bookmarkList.getFavoriteSiteList();

        boolean isUpdated = false;
        Connection con = null;

        int globalOrder = 1;
        int favOrder = 1;
        String siteID = "";
        String siteName = "";
        String oldSiteName = "";
        String siteURL = "";
        String isLinkUpdated = "";

        PreparedStatement pstmtDeleteGlobal = null;
        PreparedStatement pstmtDeletePersonal = null;
        PreparedStatement pstmtInsertPersonal = null;
        PreparedStatement pstmtInsertGlobal = null;

        try
        {
            // Update Global SiteList.
            con = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            con.setAutoCommit(false);

            pstmtDeleteGlobal = con.prepareStatement(SQLScripts.DELETE_FAVORITE_GLOBAL_SITE_LIST_SQL);
            pstmtDeleteGlobal.setString(1, userId);
            pstmtDeleteGlobal.executeUpdate();

            pstmtDeletePersonal = con.prepareStatement(SQLScripts.DELETE_FAVORITE_PERSONAL_SITE_LIST_SQL);
            pstmtDeletePersonal.setString(1, userId);
            pstmtDeletePersonal.executeUpdate();

            pstmtInsertPersonal = con.prepareStatement(SQLScripts.INSERT_PERSONAL_BOOKMARK_FOR_USER_SQL);

            pstmtInsertGlobal = con.prepareStatement(SQLScripts.INSERT_GLOBAL_BOOKMARK_FOR_USER_SQL);

            for (int i = 0; i < globalList.size(); i++)
            {
                siteID = ((Site) globalList.get(i)).getSiteID();
                siteName = ((Site) globalList.get(i)).getNewSiteName();
                oldSiteName = ((Site) globalList.get(i)).getSiteName();
                siteURL = ((Site) globalList.get(i)).getSiteURI();
                isLinkUpdated = ((Site) globalList.get(i)).getIsLinkUpdated();

                if (siteID.equalsIgnoreCase("0"))
                {
                    pstmtInsertPersonal.setString(1, userId);
                    pstmtInsertPersonal.setString(2, siteName);
                    pstmtInsertPersonal.setString(3, siteURL);
                    pstmtInsertPersonal.setInt(4, globalOrder);
                    pstmtInsertPersonal.setString(5, "N");

                    pstmtInsertPersonal.executeUpdate();
                    globalOrder++;
                }
                else
                {
                    if (isLinkUpdated.equalsIgnoreCase("Y"))
                    {
                        pstmtInsertGlobal.setString(1, userId);
                        pstmtInsertGlobal.setString(2, siteID);
                        pstmtInsertGlobal.setInt(3, globalOrder);
                        pstmtInsertGlobal.setString(4, siteName);
                        pstmtInsertGlobal.setString(5, "N");

                        pstmtInsertGlobal.executeUpdate();
                        globalOrder++;
                    }
                }
            }

            //Update Favorite SiteList.
            siteID = "";
            siteName = "";
            oldSiteName = "";
            siteURL = "";
            for (int i = 0; i < favoriteList.size(); i++)
            {
                siteID = ((Site) favoriteList.get(i)).getSiteID();
                siteName = ((Site) favoriteList.get(i)).getNewSiteName();
                oldSiteName = ((Site) favoriteList.get(i)).getSiteName();
                siteURL = ((Site) favoriteList.get(i)).getSiteURI();
                isLinkUpdated = ((Site) favoriteList.get(i)).getIsLinkUpdated();

                if (siteID.equalsIgnoreCase("0"))
                {
                    pstmtInsertPersonal.setString(1, userId);
                    pstmtInsertPersonal.setString(2, siteName);
                    pstmtInsertPersonal.setString(3, siteURL);
                    pstmtInsertPersonal.setInt(4, favOrder);
                    pstmtInsertPersonal.setString(5, "Y");

                    pstmtInsertPersonal.executeUpdate();
                    favOrder++;
                }
                else
                {
                    if (isLinkUpdated.equalsIgnoreCase("Y"))
                    {
                        pstmtInsertGlobal.setString(1, userId);
                        pstmtInsertGlobal.setString(2, siteID);
                        pstmtInsertGlobal.setInt(3, favOrder);
                        pstmtInsertGlobal.setString(4, siteName);
                        pstmtInsertGlobal.setString(5, "Y");

                        pstmtInsertGlobal.executeUpdate();
                        favOrder++;
                    }
                }
            }
            con.commit();
            isUpdated = true;
            con.setAutoCommit(true);
        }
        catch (SQLException e)
        {
            try
            {
                con.rollback();
                con.setAutoCommit(true);
            }
            catch (SQLException e1)
            {
                e1.printStackTrace();
            }
            e.printStackTrace();
        }
        catch (Exception e)
        {
            try
            {
                con.rollback();
                con.setAutoCommit(true);
            }
            catch (SQLException e1)
            {
                e1.printStackTrace();
            }
            e.printStackTrace();
        }
        finally
        {
            try
            {
                DBTool.closeStatement(pstmtDeleteGlobal, pstmtDeletePersonal, pstmtInsertPersonal, pstmtInsertGlobal);
                DBTool.closeConnection(con);
            }
            catch (Exception e)
            {
                log.error("[OracleMySitesDAO.updateSiteList]: " + e);
                e.printStackTrace();
            }
        }

        return isUpdated;
    }

    /**
     * This method checks if the user is an administrator or not.
     * @param userId
     * @param view
     * @return boolean
     * @throws SQLException
     * @throws Exception
     */
    public boolean isAdministrator(String userId, String view) throws SQLException, Exception
    {
        boolean isAdministrator = false;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            pstmt = conn.prepareStatement(SQLScripts.CHECK_ISADMINISTRATOR_SQL);
            pstmt.setString(1, userId);
            pstmt.setString(2, view);

            rs = pstmt.executeQuery();

            while (rs.next())
            {
                if (rs.getString(1).equalsIgnoreCase("0"))
                    isAdministrator = false;
                else
                    isAdministrator = true;
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.isAdministrator]:SQLException in isAdministrator: " + sqle);
            throw new SQLException("[OracleMySitesDAO.isAdministrator]:SQLException in isAdministrator: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.isAdministrator]:Exception in isAdministrator: " + e);
            throw new Exception("[OracleMySitesDAO.isAdministrator]:Exception in isAdministrator: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }
        return isAdministrator;
    }

    /**
     * This method provides the list of admin sites.
     * @param searchKeywords
     * @param userId
     * @param view
     * @return List of Admin Sites
     * @throws SQLException
     * @throws Exception
     */
    public List<Site> getAdminSiteList(String searchKeywords, String userId, String view) throws SQLException, Exception
    {
        ArrayList<Site> al = new ArrayList<Site>();

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String keywordStr = "";
        String keyword = null;
        if (!searchKeywords.equalsIgnoreCase(""))
        {
            StringTokenizer st = new StringTokenizer(searchKeywords.trim(), " ");
            while (st.hasMoreTokens())
            {
                keyword = st.nextToken().trim();
                keywordStr += "Upper(SITE_NA) LIKE '%" + keyword + "%' OR ";
            }
            keywordStr = keywordStr.substring(0, keywordStr.length() - 3).toUpperCase();
        }
        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            String sql = "SELECT DISTINCT MS.SITE_NA, MS.URL_TX FROM MYMCD_SITE MS " + "INNER JOIN MYMCD_SITE_ENTY MSE ON MS.SITE_ID = MSE.SITE_ID " + "INNER JOIN MYMCD_ENTY_TYP MET ON MSE.ENTY_TYP_ID = MET.ENTY_TYP_ID ";
            if (!searchKeywords.equalsIgnoreCase(""))
                sql += "WHERE " + keywordStr;

            sql += "ORDER BY MS.SITE_NA";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            Vector<EntityType> entyTypes = null;
            Map<String, List<AudienceType>> audTypeMap = null;
            while (rs.next())
            {
                Site as = new Site();
                as.setSiteURI(rs.getString("URL_TX"));
                as.setSiteName(rs.getString("SITE_NA"));

                entyTypes = this.getSiteEntityTypes(rs.getString("SITE_NA"), userId);
                as.setEntityType(entyTypes);
                audTypeMap = new HashMap<String, List<AudienceType>>();
                List<AudienceType> audTypeList = null;
                for (EntityType entity : entyTypes)
                {
                    audTypeList = this.getSiteAudienceTypes(rs.getString("SITE_NA"), entity.getEntityType());
                    if (!(audTypeList == null || audTypeList.size() == 0))
                        audTypeMap.put(entity.getEntityType(), audTypeList);
                }
                as.setAudienceType(audTypeMap);
                al.add(as);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getAdminSiteList]:SQLException in getAdminSiteList: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getAdminSiteList]:SQLException in getAdminSiteList: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getAdminSiteList]:Exception in getAdminSiteList: " + e);
            throw new Exception("[OracleMySitesDAO.getAdminSiteList]:Exception in getAdminSiteList: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }

        return al;
    }

    /**
     * This method provides the details of a single admin site.
     * @param siteName
     * @param userID
     * @return Site Object containing the details of a single admin site.
     * @throws Exception
     */
    public Site getAdminSite(String siteName, String userID) throws Exception
    {
        Site site = new Site();

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            String sql = SQLScripts.GET_SITES_SQL;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, siteName);
            rs = pstmt.executeQuery();
            Vector<EntityType> entyTypes = null;
            Map<String, List<AudienceType>> audTypeMap = null;
            if (rs.next())
            {
                site.setSiteURI(rs.getString("URL_TX"));
                site.setSiteName(rs.getString("SITE_NA"));
                entyTypes = this.getSiteEntityTypes(rs.getString("SITE_NA"), userID);
                site.setEntityType(entyTypes);
                audTypeMap = new HashMap<String, List<AudienceType>>();
                for (EntityType entity : entyTypes)
                {
                    audTypeMap.put(entity.getEntityType(), this.getSiteAudienceTypes(rs.getString("SITE_NA"), entity.getEntityType()));
                }
                site.setAudienceType(audTypeMap);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getAdminSite]:SQLException in getAdminSite: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getAdminSite]:SQLException in getAdminSite: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getAdminSite]:Exception in getAdminSite: " + e);
            throw new Exception("[OracleMySitesDAO.getAdminSite]:Exception in getAdminSite: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }

        return site;
    }

    /**
     * This method adds an admin site to Database.
     * @param adminSite
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String addAdminSite(Site adminSite) throws SQLException, Exception
    {
        String returnMsg = "";

        String siteID = adminSite.getSiteID();
        String siteName = adminSite.getNewSiteName().trim();
        String siteURI = adminSite.getSiteURI().trim();
        Vector<EntityType> entityTypes = adminSite.getEntityType();
        Map<String, List<AudienceType>> audienceTypesMap = adminSite.getAudienceType();

        Connection conn = null;
        PreparedStatement pstmtCheckSite = null;
        PreparedStatement pstmtSequence = null;
        PreparedStatement pstmtInsertMySite = null;
        PreparedStatement pstmtInsertEntity = null;
        PreparedStatement pstmtInsertAudType = null;
        ResultSet rsCheckSite = null;
        ResultSet rsSequence = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            log.info("[addAdminSite]Connection Created..");
            String sqlCheckSite = SQLScripts.CHECK_SITES_SQL;

            pstmtCheckSite = conn.prepareStatement(sqlCheckSite);
            pstmtCheckSite.setString(1, siteName.trim());
            rsCheckSite = pstmtCheckSite.executeQuery();

            log.info("[addAdminSite]Check Site Executed..");
            if (!rsCheckSite.next())
            {
                if (audienceTypesMap.size() == 0)
                {
                    returnMsg = MySitesConstants.NO_AUD_TYPE_SELECTED;
                }
                else
                {
                    for (EntityType entityType : entityTypes)
                    {
                        conn.setAutoCommit(false);
                        List<AudienceType> audienceTypes = null;
                        audienceTypes = audienceTypesMap.get(entityType.getEntityType());

                        if (audienceTypes != null)
                        {
                            String seqsql = SQLScripts.GET_SEQUENCE_SQL;
                            pstmtSequence = conn.prepareStatement(seqsql);
                            rsSequence = pstmtSequence.executeQuery();

                            if (rsSequence.next())
                            {
                                siteID = rsSequence.getString(1);
                            }
                            log.info("[addAdminSite]Site ID Generated.." + siteID);
                            String sqlInsertMySite = SQLScripts.INSERT_SITE_SQL;
                            pstmtInsertMySite = conn.prepareStatement(sqlInsertMySite);

                            log.info("[addAdminSite]sqlInsertMySite.." + sqlInsertMySite);
                            log.info("[addAdminSite]siteID.." + siteID);
                            log.info("[addAdminSite]siteURI.." + siteURI);
                            log.info("[addAdminSite]siteName.." + siteName);
                            
                            pstmtInsertMySite.setString(1, siteID);
                            pstmtInsertMySite.setString(2, siteURI.trim());
                            pstmtInsertMySite.setString(3, siteName.trim());
                            pstmtInsertMySite.execute();
                            log.info("[addAdminSite]Site Inserted..");
                            String sqlInsertEntity = SQLScripts.INSERT_SITE_ENTITY_SQL;
                            pstmtInsertEntity = conn.prepareStatement(sqlInsertEntity);
                            pstmtInsertEntity.setString(1, siteID);
                            pstmtInsertEntity.setString(2, entityType.getEntityTypeId());
                            pstmtInsertEntity.execute();
                            log.info("[addAdminSite]Entity Type Inserted..");
                            for (AudienceType audType : audienceTypes)
                            {
                                String sqlInsertAudType = SQLScripts.INSERT_SITE_AUDIENCE_TYPE_SQL;
                                pstmtInsertAudType = conn.prepareStatement(sqlInsertAudType);
                                pstmtInsertAudType.setString(1, siteID);
                                pstmtInsertAudType.setString(2, audType.getAudienceTypeId());
                                pstmtInsertAudType.execute();
                                log.info("[addAdminSite]Audience Type Inserted..");
                            }
                        }
                    }
                    returnMsg = MySitesConstants.SITE_ADDED_SUCCESSFULLY;
                }
                log.info("[addAdminSite]Site Inserted Finally..");
            }
            else
            {
                returnMsg = MySitesConstants.SITE_ALREADY_EXISTS;
            }

            conn.commit();
            conn.setAutoCommit(true);
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.addAdminSite]:SQLException in addAdminSite: " + sqle);
            throw new SQLException("[OracleMySitesDAO.addAdminSite]:SQLException in addAdminSite: " + sqle);
        }
        catch (Exception e)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.addAdminSite]:Exception in addAdminSite: " + e);
            throw new Exception("[OracleMySitesDAO.addAdminSite]:Exception in addAdminSite: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rsCheckSite, rsSequence);
            DBTool.closeStatement(pstmtCheckSite, pstmtSequence, pstmtInsertMySite, pstmtInsertEntity, pstmtInsertAudType);
            DBTool.closeConnection(conn);
        }

        return returnMsg;
    }

    /**
     * This method updates an admin site to Database.
     * @param adminSite
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String editAdminSite(Site adminSite) throws SQLException, Exception
    {
        String returnMsg = "";
        boolean updateCheckFlag = false;

        String siteID = adminSite.getSiteID();
        log.error("siteID 1=============" + siteID);
        String oldSiteName = adminSite.getSiteName().trim();
        String newSiteName = adminSite.getNewSiteName().trim();
        String siteURI = adminSite.getSiteURI().trim();
        Vector<EntityType> entityTypes = adminSite.getEntityType();
        Map<String, List<AudienceType>> audienceTypesMap = adminSite.getAudienceType();

        Connection conn = null;
        PreparedStatement pstmtCheckSite = null;
        PreparedStatement pstmtUpdateSite = null;
        PreparedStatement pstmtGetSiteID = null;
        PreparedStatement pstmtSequence = null;
        PreparedStatement pstmtInsertMySite = null;
        PreparedStatement pstmtDeleteAudType = null;
        PreparedStatement pstmtDeleteEntityType = null;
        PreparedStatement pstmtInsertEntity = null;
        PreparedStatement pstmtInsertAudType = null;

        ResultSet rsCheckSite = null;
        ResultSet rsGetSiteID = null;
        ResultSet rsSequence = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            log.error("[editAdminSite]Connection is=============" + conn);
            conn.setAutoCommit(false);
            if (oldSiteName.equalsIgnoreCase(newSiteName))
            {
                updateCheckFlag = true;
            }
            else
            {
                String sqlCheckSite = SQLScripts.CHECK_SITES_SQL;
                pstmtCheckSite = conn.prepareStatement(sqlCheckSite);
                pstmtCheckSite.setString(1, newSiteName.trim());
                rsCheckSite = pstmtCheckSite.executeQuery();
                if (rsCheckSite != null)
                {
                    if (rsCheckSite.next())
                    {
                        updateCheckFlag = false;
                        returnMsg = MySitesConstants.SITE_ALREADY_EXISTS;
                    }
                    else
                    {
                        updateCheckFlag = true;
                    }
                }
            }
            log.error("[editAdminSite]updateCheckFlag=============" + updateCheckFlag);
            if (updateCheckFlag)
            {
                String sqlUpdateSite = SQLScripts.UPDATE_SITE_SQL;
                pstmtUpdateSite = conn.prepareStatement(sqlUpdateSite);
                pstmtUpdateSite.setString(1, siteURI.trim());
                pstmtUpdateSite.setString(2, newSiteName.trim());
                pstmtUpdateSite.setString(3, oldSiteName);
                pstmtUpdateSite.execute();
                conn.commit();
                log.error("[editAdminSite]entityTypes=============" + entityTypes);
                for (EntityType entityType : entityTypes)
                {
                    String sqlGetSiteID = SQLScripts.GET_SITE_ID_SQL;
                    pstmtGetSiteID = conn.prepareStatement(sqlGetSiteID);
                    pstmtGetSiteID.setString(1, newSiteName.trim());
                    pstmtGetSiteID.setString(2, entityType.getEntityType().trim());
                    rsGetSiteID = pstmtGetSiteID.executeQuery();
                    if (rsGetSiteID.next())
                    {
                        siteID = rsGetSiteID.getString(1);
                    }
                    else
                    {
                        log.error("[editAdminSite]entityType=============" + entityType);
                        if (audienceTypesMap.get(entityType.getEntityType()) != null)
                        {
                            String seqsql = SQLScripts.GET_SEQUENCE_SQL;
                            pstmtSequence = conn.prepareStatement(seqsql);
                            rsSequence = pstmtSequence.executeQuery();

                            if (rsSequence.next())
                            {
                                siteID = rsSequence.getString(1);
                            }
                            String sqlInsertMySite = SQLScripts.INSERT_SITE_SQL;
                            pstmtInsertMySite = conn.prepareStatement(sqlInsertMySite);

                            pstmtInsertMySite.setString(1, siteID);
                            pstmtInsertMySite.setString(2, siteURI.trim());
                            pstmtInsertMySite.setString(3, newSiteName.trim());
                            pstmtInsertMySite.execute();

                            String sqlInsertEntity = SQLScripts.INSERT_SITE_ENTITY_SQL;
                            pstmtInsertEntity = conn.prepareStatement(sqlInsertEntity);
                            pstmtInsertEntity.setString(1, siteID);
                            pstmtInsertEntity.setString(2, entityType.getEntityTypeId());
                            pstmtInsertEntity.execute();
                        }
                        else
                        {
                            siteID = "";
                        }
                    }
                    log.error("[editAdminSite]siteID=============" + siteID);
                    if (!siteID.equalsIgnoreCase(""))
                    {
                        String sqlDeleteAudType = SQLScripts.DELETE_SITE_AUDIENCE_TYPE_SQL;
                        pstmtDeleteAudType = conn.prepareStatement(sqlDeleteAudType);
                        pstmtDeleteAudType.setString(1, siteID);
                        pstmtDeleteAudType.execute();

                        List<AudienceType> audienceTypes = null;

                        audienceTypes = audienceTypesMap.get(entityType.getEntityType());

                        if (audienceTypes != null)
                        {
                            for (AudienceType audType : audienceTypes)
                            {
                                String sqlInsertAudType = SQLScripts.INSERT_SITE_AUDIENCE_TYPE_SQL;
                                pstmtInsertAudType = conn.prepareStatement(sqlInsertAudType);
                                pstmtInsertAudType.setString(1, siteID);
                                pstmtInsertAudType.setString(2, audType.getAudienceTypeId());
                                pstmtInsertAudType.execute();
                            }
                        }
                    }
                    siteID = "";
                }
                returnMsg = MySitesConstants.SITE_UPDATED_SUCCESSFULLY;
            }

            conn.commit();
            conn.setAutoCommit(true);
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.editAdminSite]:SQLException in editAdminSite: " + sqle);
            throw new SQLException("[OracleMySitesDAO.editAdminSite]:SQLException in editAdminSite: " + sqle);
        }
        catch (Exception e)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.editAdminSite]:Exception in editAdminSite: " + e);
            throw new Exception("[OracleMySitesDAO.editAdminSite]:Exception in editAdminSite: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rsCheckSite, rsGetSiteID, rsSequence);
            DBTool.closeStatement(pstmtCheckSite, pstmtUpdateSite, pstmtGetSiteID, pstmtSequence, pstmtInsertMySite, pstmtDeleteAudType, pstmtDeleteEntityType, pstmtInsertEntity, pstmtInsertAudType);
            DBTool.closeConnection(conn);
        }

        return returnMsg;
    }

    /**
     * This method deletes the admin site(s) from Database.
     * @param adminSiteIds
     * @return String Status Code.
     * @throws Exception
     */
    public String deleteAdminSite(String[] adminSiteIds) throws Exception
    {
        boolean duSuccess = false;
        String returnMsg = "";

        Connection conn = null;
        PreparedStatement pstmtDeleteEntityType = null;
        PreparedStatement pstmtDeleteAudType = null;
        PreparedStatement pstmtDeleteSite = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            conn.setAutoCommit(false);

            for (int i = 0; i < adminSiteIds.length; i++)
            {
                duSuccess = deleteUserSiteRecord(adminSiteIds[i]);

                if (duSuccess == true)
                {
                    String sqlDeleteEntityType = SQLScripts.DELETE_SITE_ENTITY_SQL;
                    pstmtDeleteEntityType = conn.prepareStatement(sqlDeleteEntityType);
                    pstmtDeleteEntityType.setString(1, adminSiteIds[i]);
                    pstmtDeleteEntityType.execute();

                    String sqlDeleteAudType = SQLScripts.DELETE_SITE_AUDIENCE_TYPE_SQL;
                    pstmtDeleteAudType = conn.prepareStatement(sqlDeleteAudType);
                    pstmtDeleteAudType.setString(1, adminSiteIds[i]);
                    pstmtDeleteAudType.execute();

                    String sqlDeleteSite = SQLScripts.DELETE_SITE_SQL;
                    pstmtDeleteSite = conn.prepareStatement(sqlDeleteSite);
                    pstmtDeleteSite.setString(1, adminSiteIds[i]);
                    pstmtDeleteSite.execute();
                }
            }
            conn.commit();
            returnMsg = MySitesConstants.SITE_DELETED_SUCCESSFULLY;
            conn.setAutoCommit(true);
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.deleteAdminSite]:SQLException in deleteAdminSite: " + sqle);
            throw new SQLException("[OracleMySitesDAO.deleteAdminSite]:SQLException in deleteAdminSite: " + sqle);
        }
        catch (Exception e)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.deleteAdminSite]:Exception in deleteAdminSite: " + e);
            throw new Exception("[OracleMySitesDAO.deleteAdminSite]:Exception in deleteAdminSite: " + e);
        }
        finally
        {
            DBTool.closeStatement(pstmtDeleteEntityType, pstmtDeleteAudType, pstmtDeleteSite);
            DBTool.closeConnection(conn);
        }

        return returnMsg;
    }

    /**
     * This method provides all audience types.
     * @return Vector of all Audience Types.
     * @throws SQLException
     * @throws Exception
     */
    public Vector<AudienceType> getAudienceTypes() throws SQLException, Exception
    {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        Vector<AudienceType> atv = new Vector<AudienceType>();

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            String sql = SQLScripts.GET_ALL_AUDIENCE_TYPE_SQL;
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next())
            {
                AudienceType atb = new AudienceType();

                atb.setAudienceTypeId(rs.getString(1));
                atb.setAudienceType(rs.getString(2));

                atv.addElement(atb);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getAudienceTypes]:SQLException in getAudienceTypes: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getAudienceTypes]:SQLException in getAudienceTypes: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getAudienceTypes]:Exception in getAudienceTypes: " + e);
            throw new Exception("[OracleMySitesDAO.getAudienceTypes]:Exception in getAudienceTypes: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }

        return atv;
    }

    /**
     * This method checks if the user is a superuser or not.
     * @param userId
     * @param view
     * @return boolean
     * @throws SQLException
     * @throws Exception
     */
    public boolean isSuperUser(String userId, String view) throws SQLException, Exception
    {
        boolean isSuperuser = false;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            pstmt = conn.prepareStatement(SQLScripts.CHECK_ISSUPERUSER_SQL);
            pstmt.setString(1, userId);
            pstmt.setString(2, view);
            pstmt.setString(3, "Y");

            rs = pstmt.executeQuery();

            while (rs.next())
            {
                if (rs.getString(1).equalsIgnoreCase("0"))
                    isSuperuser = false;
                else
                    isSuperuser = true;
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.isSuperuser]:SQLException in isSuperuser: " + sqle);
            throw new SQLException("[OracleMySitesDAO.isSuperuser]:SQLException in isSuperuser: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.isSuperuser]:Exception in isSuperuser: " + e);
            throw new Exception("[OracleMySitesDAO.isSuperuser]:Exception in isSuperuser: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }
        return isSuperuser;
    }

    /**
     * This method provides the list of admin users.
     * @param view
     * @return List<AdminUser>
     * @throws SQLException
     * @throws Exception
     */
    public List<AdminUser> getAdminUserList(String view) throws SQLException, Exception
    {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<AdminUser> al = new ArrayList<AdminUser>();

        String entyTyp = view;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            String sql = SQLScripts.GET_ADMIN_USER_LIST_SQL;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, entyTyp);

            rs = pstmt.executeQuery();

            while (rs.next())
            {
                AdminUser au = new AdminUser();
                au.setUserId(rs.getString(1));
                au.setEntityType(rs.getString(2));
                au.setManageUserFlag(rs.getString(3));

                al.add(au);
            }

        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getAdminUserList]:SQLException in getAdminUserList: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getAdminUserList]:SQLException in getAdminUserList: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getAdminUserList]:Exception in getAdminUserList: " + e);
            throw new Exception("[OracleMySitesDAO.getAdminUserList]:Exception in getAdminUserList: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }

        return al;
    }

    /**
     * This method will return the AdminUser Object containing the details of a single admin User.
     * @param userId
     * @param view
     * @return AdminUser.
     * @throws SQLException
     * @throws Exception
     */
    public AdminUser getAdminUser(String userId, String view) throws SQLException, Exception
    {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        AdminUser au = new AdminUser();

        String entyTyp = view;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            String sql = SQLScripts.GET_ADMIN_USER_SQL;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, entyTyp);

            rs = pstmt.executeQuery();

            if (rs.next())
            {
                au.setUserId(rs.getString(1));
                au.setEntityType(rs.getString(2));
                au.setManageUserFlag(rs.getString(3));
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getAdminUser]:SQLException in getAdminUser: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getAdminUser]:SQLException in getAdminUser: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getAdminUser]:Exception in getAdminUser: " + e);
            throw new Exception("[OracleMySitesDAO.getAdminUser]:Exception in getAdminUser: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }
        return au;
    }

    /**
     * This method adds an admin user to the Database.
     * @param adminUser
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String addAdminUser(AdminUser adminUser) throws SQLException, Exception
    {
        String returnMsg = "";

        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement dpstmt = null;
        ResultSet drs = null;

        String userId = adminUser.getUserId();
        String entityType = adminUser.getEntityType();
        String manageUserFlag = adminUser.getManageUserFlag();

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            // check duplicate record
            String dsql = SQLScripts.CHECK_DUPLICATE_ADMIN_USER_SQL;
            dpstmt = conn.prepareStatement(dsql);
            dpstmt.setString(1, userId.trim());
            dpstmt.setString(2, entityType);
            drs = dpstmt.executeQuery();

            if (drs.next() && drs.getInt(1) == 0)
            {
                conn.setAutoCommit(false);
                String sql = SQLScripts.INSERT_ADMIN_USER_SQL;
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, userId.trim());
                pstmt.setString(2, entityType);
                pstmt.setString(3, manageUserFlag);
                pstmt.execute();
                conn.commit();
                returnMsg = MySitesConstants.USER_ADDED_SUCCESSFULLY;
                conn.setAutoCommit(true);
            }
            else
            {
                returnMsg = MySitesConstants.USER_ALREADY_EXISTS;
            }
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.addAdminUser]:SQLException in addAdminUser: " + sqle);
            throw new SQLException("[OracleMySitesDAO.addAdminUser]:SQLException in addAdminUser: " + sqle);
        }
        catch (Exception e)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.addAdminUser]:Exception in addAdminUser: " + e);
            throw new Exception("[OracleMySitesDAO.addAdminUser]:Exception in addAdminUser: " + e);
        }
        finally
        {
            DBTool.closeResultSet(drs);
            DBTool.closeStatement(pstmt, dpstmt);
            DBTool.closeConnection(conn);
        }

        return returnMsg;
    }

    /**
     * This method updates an admin user info in Database.
     * @param adminUser
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String editAdminUser(AdminUser adminUser) throws SQLException, Exception
    {
        String returnMsg = "";

        Connection conn = null;
        PreparedStatement pstmt = null;

        String userId = adminUser.getUserId();
        String entityType = adminUser.getEntityType();
        String manageUserFlag = adminUser.getManageUserFlag();

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            conn.setAutoCommit(false);

            String sql = SQLScripts.UPDATE_ADMIN_USER_SQL;

            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, manageUserFlag);
            pstmt.setString(2, userId.trim());
            pstmt.setString(3, entityType);

            pstmt.execute();

            conn.commit();
            returnMsg = MySitesConstants.USER_UPDATED_SUCCESSFULLY;
            conn.setAutoCommit(true);
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.editAdminUser]:SQLException in editAdminUser: " + sqle);
            throw new SQLException("[OracleMySitesDAO.editAdminUser]:SQLException in editAdminUser: " + sqle);
        }
        catch (Exception e)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.editAdminUser]:Exception in editAdminUser: " + e);
            throw new Exception("[OracleMySitesDAO.editAdminUser]:Exception in editAdminUser: " + e);
        }
        finally
        {
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }
        return returnMsg;
    }

    /**
     * This method deletes admin user(s) from Database.
     * @param adminUserIds
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String deleteAdminUser(String[] adminUserIds) throws SQLException, Exception
    {
        String returnMsg = "";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            conn.setAutoCommit(false);

            for (int i = 0; i < adminUserIds.length; i++)
            {
                String adminUserId = adminUserIds[i];
                StringTokenizer st = new StringTokenizer(adminUserId, "_");
                String userId = st.nextToken();
                String entityType = st.nextToken();

                String sql = SQLScripts.DELETE_ADMIN_USER_SQL;
                pstmt = conn.prepareStatement(sql);

                pstmt.setString(1, userId.trim());
                pstmt.setString(2, entityType);

                pstmt.execute();
            }

            conn.commit();
            returnMsg = MySitesConstants.USER_DELETED_SUCCESSFULLY;
            conn.setAutoCommit(true);           
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.deleteAdminUser]:SQLException in deleteAdminUser: " + sqle);
            throw new SQLException("[OracleMySitesDAO.deleteAdminUser]:SQLException in deleteAdminUser: " + sqle);
        }
        catch (Exception e)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.deleteAdminUser]:Exception in deleteAdminUser: " + e);
            throw new Exception("[OracleMySitesDAO.deleteAdminUser]:Exception in deleteAdminUser: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }

        return returnMsg;
    }

    /**
     * This method will add the particular site as bookmark for that user.
     * @param userID
     * @param site
     * @param override
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String addToMySites(String userID, Site site, boolean override) throws SQLException, Exception
    {
        String statusCode = "";
        PreparedStatement pstmtUpdatePersonalBookMark = null;
        PreparedStatement pstmtCheckMyBookMark = null;
        ResultSet rsCheckMyBookMark = null;
        PreparedStatement pstmtGetMaxOrder = null;
        ResultSet rsGetMaxOrder = null;
        PreparedStatement pstmtInsertPersonalBookmark = null;

        PreparedStatement pstmtGetFavoriteLinksCount = null;
        ResultSet rsGetFavoriteLinksCount = null;

        int maxOrder = 0;
        int favSitesCount = 0;
        boolean isBookmarkExists = false;
        Connection con = null;
        try
        {
            con = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            con.setAutoCommit(false);
            if (override)
            {
                pstmtUpdatePersonalBookMark = con.prepareStatement(SQLScripts.OVERRIDE_PERSONAL_BOOKMARK_SQL);

                pstmtUpdatePersonalBookMark.setString(1, site.getSiteURI());
                pstmtUpdatePersonalBookMark.setString(2, userID);
                pstmtUpdatePersonalBookMark.setString(3, site.getSiteName());

                pstmtUpdatePersonalBookMark.executeUpdate();

                con.commit();
                statusCode = MySitesConstants.BOOKMARK_UPDATED_SUCCESSFULLY;
            }
            else
            {
                pstmtCheckMyBookMark = con.prepareStatement(SQLScripts.CHECK_PERSONAL_BOOKMARK_SQL);

                pstmtCheckMyBookMark.setString(1, userID);
                pstmtCheckMyBookMark.setString(2, site.getSiteName());

                rsCheckMyBookMark = pstmtCheckMyBookMark.executeQuery();

                while (rsCheckMyBookMark.next())
                {
                    if (rsCheckMyBookMark.getString("COUNT").equalsIgnoreCase("0"))
                        isBookmarkExists = false;
                    else
                        isBookmarkExists = true;
                }
                if (isBookmarkExists)
                {
                    statusCode = MySitesConstants.BOOKMARK_ALREADY_EXISTS_OVERRIDE;
                }
                else
                {
                    pstmtGetMaxOrder = con.prepareStatement(SQLScripts.GET_MAX_ORDER_FOR_FAVORITE_BOOKMARK_SQL);

                    pstmtGetMaxOrder.setString(1, userID);
                    pstmtGetMaxOrder.setString(2, "Y");
                    pstmtGetMaxOrder.setString(3, userID);
                    pstmtGetMaxOrder.setString(4, "Y");

                    rsGetMaxOrder = pstmtGetMaxOrder.executeQuery();
                    while (rsGetMaxOrder.next())
                    {
                        maxOrder = rsGetMaxOrder.getInt("ORD");
                    }

                    pstmtInsertPersonalBookmark = con.prepareStatement(SQLScripts.INSERT_PERSONAL_BOOKMARK_FOR_USER_SQL);

                    pstmtInsertPersonalBookmark.setString(1, userID);
                    pstmtInsertPersonalBookmark.setString(2, site.getSiteName());
                    pstmtInsertPersonalBookmark.setString(3, site.getSiteURI());
                    pstmtInsertPersonalBookmark.setInt(4, (maxOrder + 1));
                    pstmtInsertPersonalBookmark.setString(5, "Y");

                    pstmtInsertPersonalBookmark.executeUpdate();

                    con.commit();
                    statusCode = MySitesConstants.BOOKMARK_ADDED_SUCCESSFULLY;

                    pstmtGetFavoriteLinksCount = con.prepareStatement(SQLScripts.GET_FAVORITE_SITE_LIST_COUNT_SQL);
                    pstmtGetFavoriteLinksCount.setString(1, "Y");
                    pstmtGetFavoriteLinksCount.setString(2, userID);
                    pstmtGetFavoriteLinksCount.setString(3, userID);
                    pstmtGetFavoriteLinksCount.setString(4, "Y");

                    rsGetFavoriteLinksCount = pstmtGetFavoriteLinksCount.executeQuery();
                    while (rsGetFavoriteLinksCount.next())
                    {
                        favSitesCount = rsGetFavoriteLinksCount.getInt("COUNT");
                    }

                    if (favSitesCount > MySitesConstants.MAX_SITES)
                    {
                        statusCode = MySitesConstants.FAV_BOOKMARK_SITE_LIMIT_EXEEDED;
                    }
                }
            }
            con.setAutoCommit(true);
        }
        catch (SQLException e)
        {
            try
            {
                con.rollback();
                con.setAutoCommit(true);
            }
            catch (SQLException e1)
            {
                e1.printStackTrace();
            }
            e.printStackTrace();
        }
        catch (Exception e)
        {
            try
            {
                con.rollback();
                con.setAutoCommit(true);
            }
            catch (SQLException e1)
            {
                e1.printStackTrace();
            }
            e.printStackTrace();
        }
        finally
        {
            DBTool.closeResultSet(rsCheckMyBookMark, rsGetMaxOrder);
            DBTool.closeStatement(pstmtUpdatePersonalBookMark, pstmtCheckMyBookMark, pstmtGetMaxOrder, pstmtInsertPersonalBookmark);
            DBTool.closeConnection(con);
        }
        return statusCode;
    }

    /**
     * This method will return the ArrayList of favorite bookmark for that user.
     * @param userID
     * @return ArrayList<Site>
     * @throws SQLException
     * @throws Exception
     */
    public ArrayList<Site> getFavouriteSites(String userID) throws SQLException, Exception
    {
        ArrayList<Site> fsl = new ArrayList<Site>();

        Connection conn = null;
        PreparedStatement pstmtGetFavoriteSiteList = null;
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            conn.setAutoCommit(false);

            pstmtGetFavoriteSiteList = conn.prepareStatement(SQLScripts.GET_FAVORITE_SITE_LIST_SQL);//TODO get Top 30 Records

            pstmtGetFavoriteSiteList.setString(1, "Y");
            pstmtGetFavoriteSiteList.setString(2, userID);
            pstmtGetFavoriteSiteList.setString(3, userID);
            pstmtGetFavoriteSiteList.setString(4, "Y");

            rs = pstmtGetFavoriteSiteList.executeQuery();
            String updatedSiteName = "";
            int count = 0;
            while (rs.next())
            {
                count++;
                if (count > MySitesConstants.MAX_SITES)
                    break;
                Site fs = new Site();

                if (rs.getString("UPDATED_TITLE") != null)
                {
                    updatedSiteName = rs.getString("UPDATED_TITLE");
                }
                else
                {
                    updatedSiteName = rs.getString("GLOBAL_TITLE");
                }
                fs.setSiteID(rs.getString("SITE_ID"));
                fs.setSiteName(updatedSiteName);
                fs.setSiteURI(rs.getString("URL_TX"));
                fsl.add(fs);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getFavouriteSites]:SQLException in getting site list: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getFavouriteSites]:SQLException in getting site list: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getFavouriteSites]:Exception in getting site list: " + e);
            throw new Exception("[OracleMySitesDAO.getFavouriteSites]:Exception in getting site list: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmtGetFavoriteSiteList);
            DBTool.closeConnection(conn);
        }

        return fsl;
    }

    /**
     * This method provides the list of entity types based on the siteName and userID.
     * @param siteName
     * @param userID
     * @return Vector<EntityType>
     * @throws SQLException
     * @throws Exception
     */
    public Vector<EntityType> getSiteEntityTypes(String siteName, String userID) throws SQLException, Exception
    {
        Connection conn = null;

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector<EntityType> setv = new Vector<EntityType>();

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            String sql = SQLScripts.GET_SITE_ENTITY_TYPE_SQL;

            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, userID);
            pstmt.setString(2, siteName);

            rs = pstmt.executeQuery();

            while (rs.next())
            {
                EntityType et = new EntityType();
                et.setEntityTypeId(rs.getString(1));
                et.setEntityType(rs.getString(2));

                setv.addElement(et);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getSiteEntityTypes]:SQLException in getSiteEntityTypes: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getSiteEntityTypes]:SQLException in getSiteEntityTypes: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getSiteEntityTypes]:Exception in getSiteEntityTypes: " + e);
            throw new Exception("[OracleMySitesDAO.getSiteEntityTypes]:Exception in getSiteEntityTypes: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }

        return setv;
    }

    /**
     * This method provides the list of audience types based on the siteName and View
     * @param siteName
     * @param view
     * @return List<AudienceType>
     * @throws SQLException
     * @throws Exception
     */
    public List<AudienceType> getSiteAudienceTypes(String siteName, String view) throws SQLException, Exception
    {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<AudienceType> audTypeList = new ArrayList<AudienceType>();

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            String sql = SQLScripts.GET_SITE_AUDIENCE_TYPE_SQL;

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, siteName);
            pstmt.setString(2, view);
            pstmt.setString(3, siteName);
            rs = pstmt.executeQuery();

            AudienceType audType = null;
            while (rs.next())
            {
                audType = new AudienceType();
                audType.setAudienceTypeId(rs.getString("AUD_TYP_ID"));
                audType.setAudienceType(rs.getString("AUD_TYP_DS"));
                audTypeList.add(audType);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getSiteAudienceTypes]:SQLException in getSiteAudienceTypes: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getSiteAudienceTypes]:SQLException in getSiteAudienceTypes: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getSiteAudienceTypes]:Exception in getSiteAudienceTypes: " + e);
            throw new Exception("[OracleMySitesDAO.getSiteAudienceTypes]:Exception in getSiteAudienceTypes: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }

        return audTypeList;
    }

    /**
     * This method returns the entity type id based on the entity Type
     * @param entityType
     * @return String Entity Type ID
     * @throws SQLException
     * @throws Exception
     */
    public String getEntityTypeId(String entityType) throws SQLException, Exception
    {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String entyTypId = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            String sql = SQLScripts.GET_ENTITY_TYPE_ID_SQL;
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, entityType);
            rs = pstmt.executeQuery();

            while (rs.next())
            {
                entyTypId = rs.getString(1);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getEntityTypeId]:SQLException in getEntityTypeId: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getEntityTypeId]:SQLException in getEntityTypeId: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getEntityTypeId]:Exception in getEntityTypeId: " + e);
            throw new Exception("[OracleMySitesDAO.getEntityTypeId]:Exception in getEntityTypeId: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }

        return entyTypId;
    }

    /**
     * This method removes the access of the site from User whose site ID is passed.
     * @param siteId
     * @return boolean
     * @throws SQLException
     * @throws Exception
     */
    public boolean deleteUserSiteRecord(String siteId) throws SQLException, Exception
    {
        boolean success = false;

        Connection conn = null;
        PreparedStatement pstmtDeleteUser = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            conn.setAutoCommit(false);

            String sqlDeleteUser = SQLScripts.DELETE_USER_SITE_ID_RECORD_SQL;

            pstmtDeleteUser = conn.prepareStatement(sqlDeleteUser);
            pstmtDeleteUser.setString(1, siteId);
            pstmtDeleteUser.execute();

            conn.commit();
            success = true;
            conn.setAutoCommit(true);
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.deleteUserSiteRecord]:SQLException in deleteUserSiteRecord: " + sqle);
            throw new SQLException("[OracleMySitesDAO.deleteUserSiteRecord]:SQLException in deleteUserSiteRecord: " + sqle);
        }
        catch (Exception e)
        {
            conn.rollback();
            conn.setAutoCommit(true);
            log.error("[OracleMySitesDAO.deleteUserSiteRecord]:Exception in deleteUserSiteRecord: " + e);
            throw new Exception("[OracleMySitesDAO.deleteUserSiteRecord]:Exception in deleteUserSiteRecord: " + e);
        }
        finally
        {
            DBTool.closeStatement(pstmtDeleteUser);
            DBTool.closeConnection(conn);
        }

        return success;
    }

    /**
     * This method returns the list of entity types for a user.
     * @param userID
     * @return Vector<EntityType>
     * @throws Exception
     */
    public Vector<EntityType> getEntityTypes(String userId) throws Exception
    {
        Vector<EntityType> entityTypes = new Vector<EntityType>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);

            String sql = SQLScripts.GET_ENTITY_TYPES_SQL;

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next())
            {
                EntityType entity = new EntityType();
                entity.setEntityTypeId(rs.getString(1));
                entity.setEntityType(rs.getString(2));
                entityTypes.addElement(entity);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getEntityTypes]:SQLException in getEntityTypes: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getEntityTypes]:SQLException in getEntityTypes: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getEntityTypes]:Exception in getEntityTypes: " + e);
            throw new Exception("[OracleMySitesDAO.getEntityTypes]:Exception in getEntityTypes: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }

        return entityTypes;
    }

    /**
     * This method returns the details of sites which are to be deleted.
     * @param siteNames
     * @param userID
     * @return List<Site>
     * @throws Exception
     */
    public List<Site> getSites(String[] siteNames, String userID) throws Exception
    {
        ArrayList<Site> al = new ArrayList<Site>();

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String commas = "";
        for (String siteName : siteNames)
        {
            commas = commas + "?,";
        }
        commas = commas.substring(0, commas.length() - 1);

        try
        {
            conn = dbTool.createConnection(MySitesConstants.DEFAULT_DSN);
            String sql = "SELECT MS.SITE_ID, MS.SITE_NA, MS.URL_TX, MET.ENTY_TYP_DS FROM MYMCD_SITE MS " + "INNER JOIN MYMCD_SITE_ENTY MSE ON MS.SITE_ID = MSE.SITE_ID " + "INNER JOIN MYMCD_ENTY_TYP MET ON MSE.ENTY_TYP_ID = MET.ENTY_TYP_ID " + "INNER JOIN MYMCD_SECURITY MSEC ON UPPER(MSEC.VIRTUAL_PORTAL) = UPPER(MET.ENTY_TYP_DS) " + "WHERE MS.SITE_NA IN (" + commas + ") AND MSEC.UID_ID = '" + userID + "' ORDER BY MS.SITE_NA";

            pstmt = conn.prepareStatement(sql);

            for (int i = 0; i < siteNames.length; i++)
            {
                pstmt.setString(i + 1, siteNames[i]);
            }

            rs = pstmt.executeQuery();

            Vector<EntityType> entityType = null;
            EntityType enty = null;
            while (rs.next())
            {
                Site site = new Site();
                entityType = new Vector<EntityType>();
                enty = new EntityType();
                site.setSiteID(rs.getString("SITE_ID"));
                site.setSiteName(rs.getString("SITE_NA"));
                site.setSiteURI(rs.getString("URL_TX"));
                enty.setEntityType(rs.getString("ENTY_TYP_DS"));
                entityType.add(enty);
                site.setEntityType(entityType);
                al.add(site);
            }
        }
        catch (SQLException sqle)
        {
            log.error("[OracleMySitesDAO.getSites]:SQLException in getSites: " + sqle);
            throw new SQLException("[OracleMySitesDAO.getSites]:SQLException in getSites: " + sqle);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.getSites]:Exception in getSites: " + e);
            throw new Exception("[OracleMySitesDAO.getSites]:Exception in getSites: " + e);
        }
        finally
        {
            DBTool.closeResultSet(rs);
            DBTool.closeStatement(pstmt);
            DBTool.closeConnection(conn);
        }
        return al;
    }

    /**
     * This method updates all admin users info in Database.
     * @param adminUser
     * @return String Status Code.
     * @throws Exception
     */
    public String updateAllAdminUsers(List<AdminUser> adminUsers) throws Exception
    {
        String returnMsg = "";
        try
        {
            for (AdminUser adminUser : adminUsers)
            {
                this.editAdminUser(adminUser);
            }
            returnMsg = MySitesConstants.USER_UPDATED_SUCCESSFULLY;
        }
        catch (SQLException e)
        {
            log.error("[OracleMySitesDAO.updateAllAdminUsers]:SQLException in updateAllAdminUsers: " + e);
            throw new SQLException("[OracleMySitesDAO.updateAllAdminUsers]:SQLException in updateAllAdminUsers: " + e);
        }
        catch (Exception e)
        {
            log.error("[OracleMySitesDAO.updateAllAdminUsers]:Exception in updateAllAdminUsers: " + e);
            throw new Exception("[OracleMySitesDAO.updateAllAdminUsers]:Exception in updateAllAdminUsers: " + e);
        }
        return returnMsg;
    }
}