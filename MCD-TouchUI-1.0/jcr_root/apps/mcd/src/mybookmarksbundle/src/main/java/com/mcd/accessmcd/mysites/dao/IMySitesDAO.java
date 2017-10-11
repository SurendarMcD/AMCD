/*
 * Project: AccessMCD
 *
 * @(#)IMySitesDAO.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Interface contains the methods
 *                                      used in Application.
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

package com.mcd.accessmcd.mysites.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import com.mcd.accessmcd.mysites.bean.AdminUser;
import com.mcd.accessmcd.mysites.bean.EntityType;
import com.mcd.accessmcd.mysites.bean.Site;
import com.mcd.accessmcd.mysites.bean.SiteList;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public interface IMySitesDAO 
{
    /**
     * This method provides the SiteList Object which contains the Global and Favorite Site Lists.
     * @param userId
     * @param view
     * @return SiteList Object
     * @throws SQLException
     * @throws Exception
     */
    public SiteList getSiteList (String userId, String view) throws SQLException, Exception;
    
    /**
     * This method updates a user's site lists.
     * @param userId
     * @param bookmarkList
     * @return boolean
     * @throws SQLException
     * @throws Exception
     */
    public boolean updateSiteList(String userId, SiteList bookmarkList) throws SQLException, Exception;
    
    /**
     * This method checks if the user is an administrator or not.
     * @param userId
     * @param view
     * @return boolean
     * @throws SQLException
     * @throws Exception
     */
    public boolean isAdministrator(String userId, String view) throws SQLException, Exception;
    
    /**
     * This method provides the list of admin sites.
     * @param searchKeywords
     * @param userId
     * @param view
     * @return List of Admin Sites
     * @throws SQLException
     * @throws Exception
     */
    public List getAdminSiteList(String searchKeywords, String userId, String view) throws SQLException, Exception;
    
    /**
     * This method provides the details of a single admin site.
     * @param siteName
     * @param userID
     * @return Site Object containing the details of a single admin site.
     * @throws Exception
     */
    public Site getAdminSite(String siteName, String userID) throws Exception;
    
    /**
     * This method adds an admin site to Database.
     * @param adminSite
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String addAdminSite(Site adminSite) throws SQLException, Exception;
    
    /**
     * This method updates an admin site to Database.
     * @param adminSite
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String editAdminSite(Site adminSite) throws SQLException, Exception;
    
    /**
     * This method deletes the admin site(s) from Database.
     * @param adminSiteIds
     * @return String Status Code.
     * @throws Exception
     */
    public String deleteAdminSite(String[] adminSiteIds) throws Exception;
    
    /**
     * This method provides all audience types.
     * @return Vector of all Audience Types.
     * @throws SQLException
     * @throws Exception
     */
    public Vector getAudienceTypes() throws SQLException, Exception;
 
    /**
     * This method checks if the user is a superuser or not.
     * @param userId
     * @param view
     * @return boolean
     * @throws SQLException
     * @throws Exception
     */
    public boolean isSuperUser(String userId, String view) throws SQLException, Exception;
    
    /**
     * This method provides the list of admin users.
     * @param view
     * @return List<AdminUser>
     * @throws SQLException
     * @throws Exception
     */
    public List getAdminUserList(String view) throws SQLException, Exception;
    
    /**
     * This method will return the AdminUser Object containing the details of a single admin User.
     * @param userId
     * @param view
     * @return AdminUser.
     * @throws SQLException
     * @throws Exception
     */
    public AdminUser getAdminUser(String userId, String view) throws SQLException, Exception;
    
    /**
     * This method adds an admin user to the Database.
     * @param adminUser
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String addAdminUser(AdminUser adminUser) throws SQLException, Exception;
    
    /**
     * This method updates an admin user info in Database.
     * @param adminUser
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String editAdminUser(AdminUser adminUser) throws SQLException, Exception;
    
    /**
     * This method deletes admin user(s) from Database.
     * @param adminUserIds
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String deleteAdminUser(String[] adminUserIds) throws SQLException, Exception;
    
    /**
     * This method will add the particular site as bookmark for that user.
     * @param userID
     * @param site
     * @param override
     * @return String Status Code.
     * @throws SQLException
     * @throws Exception
     */
    public String addToMySites(String userID, Site site, boolean override) throws SQLException, Exception;
    
    /**
     * This method will return the ArrayList of favorite bookmark for that user.
     * @param userID
     * @return ArrayList<Site>
     * @throws SQLException
     * @throws Exception
     */
    public ArrayList<Site> getFavouriteSites(String userID) throws SQLException, Exception;
    
    /**
     * This method returns the list of entity types for a user.
     * @param userID
     * @return Vector<EntityType>
     * @throws Exception
     */
    public Vector<EntityType> getEntityTypes(String userID) throws Exception;
    
    /**
     * This method returns the details of sites which are to be deleted.
     * @param siteNames
     * @param userID
     * @return List<Site>
     * @throws Exception
     */
    public List<Site> getSites(String[] siteNames, String userID) throws Exception;
    
    /**
     * This method updates all admin users info in Database.
     * @param adminUser
     * @return String Status Code.
     * @throws Exception
     */
    public String updateAllAdminUsers(List<AdminUser> adminUsers) throws Exception;
}