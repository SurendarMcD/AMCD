/*
 * Project: AccessMCD
 *
 * @(#)FavoriteSiteList.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Bean Class contains the admin
 *                                      and super user flag and also the 
 *                                      list of top 30 Sites.
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

import java.util.ArrayList;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public class FavoriteSiteList
{
    boolean isAdministrator = false;
    boolean isSuperUser = false;
    ArrayList<Site> favoriteSiteList = new ArrayList<Site>();
    
    /**
     * constructor
     */
    public FavoriteSiteList()
    {
        
    }
    /**
     * parameterized constructor
     */
    public FavoriteSiteList(boolean isAdministrator, boolean isSuperUser, ArrayList<Site> favoriteSiteList)
    {
        this.isAdministrator = isAdministrator;
        this.isSuperUser = isSuperUser;
        this.favoriteSiteList = favoriteSiteList;
    }
    /**
     * method to get the favorite site list.
     * @return List of top 30 Sites.
     */
    public ArrayList<Site> getFavoriteSiteList()
    {
        return favoriteSiteList;
    }
    
    /**
     * method to set the favorite site List.
     * @param favoriteSiteList
     */
    public void setFavoriteSiteList(ArrayList<Site> favoriteSiteList)
    {
        this.favoriteSiteList = favoriteSiteList;
    }
    
    /**
     * method to get the isAdministrator flag.
     * @return boolean isAdministrator flag.
     */
    public boolean isAdministrator()
    {
        return isAdministrator;
    }
    
    /**
     * method to set isAdministrator flag.
     * @param isAdministrator
     */
    public void setAdministrator(boolean isAdministrator)
    {
        this.isAdministrator = isAdministrator;
    }
    
    /**
     * method to get the isSuperUser Flag.
     * @return boolean isSuperUser
     */
    public boolean isSuperUser()
    {
        return isSuperUser;
    }
    
    /**
     * method to set isSuperUser Flag.
     * @param isSuperUser
     */
    public void setSuperUser(boolean isSuperUser)
    {
        this.isSuperUser = isSuperUser;
    }
}