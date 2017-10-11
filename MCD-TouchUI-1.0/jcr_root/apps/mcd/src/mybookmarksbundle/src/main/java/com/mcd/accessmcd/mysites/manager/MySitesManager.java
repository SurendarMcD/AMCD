/*
 * Project: AccessMCD
 *
 * @(#)MySitesManager.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Class acts as a connector
 *                                      between User view pages and 
 *                                      business objects.
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

package com.mcd.accessmcd.mysites.manager;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import javax.jcr.Session;

import org.apache.sling.api.scripting.SlingScriptHelper;

import com.mcd.accessmcd.mysites.bean.AdminUser;
import com.mcd.accessmcd.mysites.bean.EntityType;
import com.mcd.accessmcd.mysites.bean.FavoriteSiteList;
import com.mcd.accessmcd.mysites.bean.Site;
import com.mcd.accessmcd.mysites.bean.SiteList;
import com.mcd.accessmcd.mysites.dao.IMySitesDAO;
import com.mcd.accessmcd.mysites.dao.OracleMySitesDAO;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public class MySitesManager
{
    private IMySitesDAO iMySitesDAO = null;
    SlingScriptHelper sling = null;
    Session jcrSession = null;

    /**
     * Parameterized Constructor
     * @param sling
     * @param jcrSession
     * @throws Exception
     */
    public MySitesManager(SlingScriptHelper sling, Session jcrSession) throws Exception
    {
        this.sling = sling;
        this.jcrSession = jcrSession;
        iMySitesDAO = new OracleMySitesDAO(sling, jcrSession);
    }

    /**
     * This method provides the SiteList Object which contains the Global and Favorite Site Lists.
     * @param userId
     * @param view
     * @return SiteList Object
     * @throws Exception
     */
    public SiteList getSiteList(String userId, String view) throws Exception
    {
        return iMySitesDAO.getSiteList(userId, view);
    }

    /**
     * This method updates a user's site lists.
     * @param userId
     * @param bookmarkList
     * @return boolean
     * @throws Exception
     */
    public boolean updateSiteList(String userId, SiteList bookmarlList) throws Exception
    {
        return iMySitesDAO.updateSiteList(userId, bookmarlList);
    }

    /**
     * This method checks if the user is an administrator or not.
     * @param userId
     * @param view
     * @return boolean
     * @throws Exception
     */
    public boolean isAdministrator(String userId, String view) throws Exception
    {
        return iMySitesDAO.isAdministrator(userId, view);
    }

    /**
     * This method provides the list of admin sites.
     * @param searchKeywords
     * @param userId
     * @param view
     * @return List of Admin Sites
     * @throws Exception
     */
    public List getAdminSiteList(String searchKeywords, String userId, String view) throws Exception
    {
        return iMySitesDAO.getAdminSiteList(searchKeywords, userId, view);
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
        return iMySitesDAO.getAdminSite(siteName, userID);
    }

    /**
     * This method adds an admin site to Database.
     * @param adminSite
     * @return String Status Code.
     * @throws Exception
     */
    public String addAdminSite(Site adminSite) throws Exception
    {
        return iMySitesDAO.addAdminSite(adminSite);
    }

    /**
     * This method updates an admin site to Database.
     * @param adminSite
     * @return String Status Code.
     * @throws Exception
     */
    public String editAdminSite(Site adminSite) throws Exception
    {
        return iMySitesDAO.editAdminSite(adminSite);
    }

    /**
     * This method deletes the admin site(s) from Database.
     * @param adminSiteIds
     * @return String Status Code.
     * @throws Exception
     */
    public String deleteAdminSite(String[] adminSiteIds) throws Exception
    {
        return iMySitesDAO.deleteAdminSite(adminSiteIds);
    }

    /**
     * This method provides all audience types.
     * @return Vector of all Audience Types.
     * @throws Exception
     */
    public Vector getAudienceTypes() throws Exception
    {
        return iMySitesDAO.getAudienceTypes();
    }

    /**
     * This method checks if the user is a superuser or not.
     * @param userId
     * @param view
     * @return boolean
     * @throws Exception
     */
    public boolean isSuperUser(String userId, String view) throws Exception
    {
        return iMySitesDAO.isSuperUser(userId, view);
    }

    /**
     * This method provides the list of admin users.
     * @param view
     * @return List<AdminUser>
     * @throws Exception
     */
    public List getAdminUserList(String view) throws Exception
    {
        return iMySitesDAO.getAdminUserList(view);
    }

    /**
     * This method will return the AdminUser Object containing the details of a single admin User.
     * @param userId
     * @param view
     * @return AdminUser.
     * @throws Exception
     */
    public AdminUser getAdminUser(String userId, String view) throws Exception
    {
        return iMySitesDAO.getAdminUser(userId, view);
    }

    /**
     * This method adds an admin user to the Database.
     * @param adminUser
     * @return String Status Code.
     * @throws Exception
     */
    public String addAdminUser(AdminUser adminUser) throws Exception
    {
        return iMySitesDAO.addAdminUser(adminUser);
    }

    /**
     * This method updates an admin user info in Database.
     * @param adminUser
     * @return String Status Code.
     * @throws Exception
     */
    public String editAdminUser(AdminUser adminUser) throws Exception
    {
        return iMySitesDAO.editAdminUser(adminUser);
    }

    /**
     * This method deletes admin user(s) from Database.
     * @param adminUserIds
     * @return String Status Code.
     * @throws Exception
     */
    public String deleteAdminUser(String[] adminUserIds) throws Exception
    {
        return iMySitesDAO.deleteAdminUser(adminUserIds);
    }

    /**
     * This method will add the particular site as bookmark for that user.
     * @param userID
     * @param site
     * @param override
     * @return String Status Code.
     * @throws Exception
     */
    public String addToMySites(String userID, Site site, boolean override) throws Exception
    {
        return iMySitesDAO.addToMySites(userID, site, override);
    }

    /**
     * This method returns the FavoriteSiteList Object which contains isAdmin, isSuperUser Flags and ArrayList of favorite book mark for a user.
     * @param userID
     * @param view
     * @return
     * @throws Exception
     */
    public FavoriteSiteList getFavourtiteSites(String userID, String view) throws Exception
    {
        boolean isAdminFlag = this.isAdministrator(userID, view);
        boolean isSuperUserFlag = this.isSuperUser(userID, view);
        ArrayList<Site> favSiteList = iMySitesDAO.getFavouriteSites(userID);

        FavoriteSiteList favSiteListBean = new FavoriteSiteList(isAdminFlag, isSuperUserFlag, favSiteList);

        return favSiteListBean;
    }
    
    /**
     * This method returns the list of entity types for a user.
     * @param userID
     * @return Vector<EntityType>
     * @throws Exception
     */
    public Vector<EntityType> getEntityTypes(String userID) throws Exception
    {
        return iMySitesDAO.getEntityTypes(userID);
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
        return iMySitesDAO.getSites(siteNames, userID);
    }
    
    /**
     * This method updates all admin users info in Database.
     * @param adminUser
     * @return String Status Code.
     * @throws Exception
     */
    public String updateAllAdminUsers(List<AdminUser> adminUsers) throws Exception
    {
        return iMySitesDAO.updateAllAdminUsers(adminUsers);
    } 
}