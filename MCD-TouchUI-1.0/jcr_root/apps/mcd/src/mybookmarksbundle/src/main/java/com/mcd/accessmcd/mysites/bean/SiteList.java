/*
 * Project: AccessMCD
 *
 * @(#)SiteList.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Bean Class contains the List
 *                                      of Global and Favorite Sites.
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
import java.util.ArrayList;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public class SiteList implements Serializable 
{
    ArrayList<Site> globalSiteList = new ArrayList<Site>();
    ArrayList<Site> favoriteSiteList = new ArrayList<Site>();

    /**
     * constructor
     */
    public SiteList()
    {
    }
    
    /**
     * parameterized constructor
     */
    public SiteList(ArrayList<Site> globalSiteList, ArrayList<Site> favoriteSiteList)
    {
        this.globalSiteList = globalSiteList;
        this.favoriteSiteList = favoriteSiteList;
    }
    
    /**
     * method to get the Favorite Site List.
     * @return the favoriteSiteList
     */
    public ArrayList<Site> getFavoriteSiteList() 
    {
        return favoriteSiteList;
    }
    
    /**
     * method to set the Favorite Site List.
     * @param favoriteSiteList
     */
    public void setFavoriteSiteList(ArrayList<Site> favoriteSiteList) 
    {
        this.favoriteSiteList = favoriteSiteList;
    }
    
    /**
     * method to get the Global Site List.
     * @return the globalSiteList
     */
    public ArrayList<Site> getGlobalSiteList() 
    {
        return globalSiteList;
    }
    
    /**
     * method to set the Global Site List.
     * @param globalSiteList
     */
    public void setGlobalSiteList(ArrayList<Site> globalSiteList) 
    {
        this.globalSiteList = globalSiteList;
    }
}