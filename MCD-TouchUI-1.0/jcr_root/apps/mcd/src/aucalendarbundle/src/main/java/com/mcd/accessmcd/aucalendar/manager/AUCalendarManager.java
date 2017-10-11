package com.mcd.accessmcd.aucalendar.manager;

//import com.day.cq.wcm.api.Page;
import com.mcd.accessmcd.aucalendar.bean.*;
import com.mcd.accessmcd.aucalendar.dao.IAUCalendarDAO;
import com.mcd.accessmcd.aucalendar.dao.OracleAUCalendarDAO;
import java.util.ArrayList;
import javax.jcr.Session;
import org.apache.sling.api.scripting.SlingScriptHelper;
import com.day.commons.datasource.poolservice.DataSourcePool;

/**
 * @author
 */
public class AUCalendarManager
{
    private IAUCalendarDAO iAUCalendarDAO = null;
    SlingScriptHelper sling = null;
    Session jcrSession = null;
    DataSourcePool dbService = null;
    

    /**
     * Constructor
     */
    public AUCalendarManager(SlingScriptHelper sling, Session jcrSession) throws Exception
    {
        this.sling = sling;
        this.jcrSession = jcrSession;
        iAUCalendarDAO = new OracleAUCalendarDAO(sling, jcrSession);
    }
      
    public AUCalendarManager(DataSourcePool dbService, Session jcrSession) throws Exception
    {
        this.dbService = dbService;
        this.jcrSession = jcrSession;
        iAUCalendarDAO = new OracleAUCalendarDAO(dbService, jcrSession);
    }
    
    /**
     * This method will insert post into DB 
     * 
     */
    public boolean insertPost(PostEntry pe) throws Exception
    {
        return iAUCalendarDAO.insertPost(pe);
    }

    /**
     * This method will update post into DB 
     * 
     */
    public boolean updatePost(PostEntry pe) throws Exception
    {
        return iAUCalendarDAO.updatePost(pe);
    }

    /**
     * This method will make post in DB inactive
     * 
     */
    public boolean deletePost(String ctntid) throws Exception
    {
        return iAUCalendarDAO.deletePost(ctntid);
    }

    /** 
     * This method will make the post in DB inactive, we're not deleting them though
     */ 
    public boolean deletePostByUUID(String uuid) throws Exception
    {
        return iAUCalendarDAO.deletePostByUUID(uuid);
    }
    
    /**
     * This method will provide the list of posts
     * 
     */
    public ArrayList<PostEntry> getPostList(String catid) throws Exception
    {
        return iAUCalendarDAO.getPostList(catid);
    }

    /**
     * This method will provide the list of posts
     * 
     */
    public ArrayList<PostEntry> getPostOnCtntID(String ctntid) throws Exception
    {
        return iAUCalendarDAO.getPostOnCtntID(ctntid);
    }

    /**
     * This method will provide the list of posts
     * 
     */
    public ArrayList<PostEntry> getPostOnUUID(String ctntid) throws Exception
    {
        return iAUCalendarDAO.getPostOnUUID(ctntid);
    }

    /**
     * This method will provide the list of categories
     * 
     */
    public ArrayList getCategoryList() throws Exception
    {
        return iAUCalendarDAO.getCategoryList();
    }
}  