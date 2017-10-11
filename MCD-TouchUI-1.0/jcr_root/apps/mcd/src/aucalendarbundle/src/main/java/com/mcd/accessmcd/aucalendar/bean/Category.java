package com.mcd.accessmcd.aucalendar.bean;

/**
 * @author   Wei
 */
public class Category
{
    private String categoryID = "";
    private String categoryName = "";
   

    /**
     * method to get categoryID.
     * @return   String categoryID
     */
    public String getCategoryID()
    {
        return categoryID;
    }

    /**
     * method to set categoryID.
     * @param  categoryID
     */
    public void setCategoryID(String categoryID)
    {
        this.categoryID = categoryID;
    }

    /**
     * method to get categoryName
     * @return   String categoryName.
     */
    public String getCategoryName()
    {
        return categoryName;
    }

    /**
     * method to set categoryName.
     * @param  categoryName
     */
    public void setCategoryName(String categoryName)
    {
        this.categoryName = categoryName;
    }
}