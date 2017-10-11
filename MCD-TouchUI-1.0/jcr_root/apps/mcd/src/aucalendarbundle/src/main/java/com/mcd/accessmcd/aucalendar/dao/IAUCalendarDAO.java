package com.mcd.accessmcd.aucalendar.dao;

//import com.day.cq.wcm.api.Page;
import java.sql.SQLException;
import java.util.ArrayList;
import com.mcd.accessmcd.aucalendar.bean.*;


public interface IAUCalendarDAO { 

    /** This method will provide the list of sites.
     */ 
    public ArrayList getCategoryList() throws SQLException, Exception;

    /** This method will provide the list of posts
     */ 
    public ArrayList<PostEntry> getPostList(String catid) throws SQLException, Exception;   

    /** This method will provide the list of posts
     */ 
    public ArrayList<PostEntry> getPostOnCtntID(String ctntid) throws SQLException, Exception;   

    /** This method will provide the list of posts
     */ 
    public ArrayList<PostEntry> getPostOnUUID(String ctntid) throws SQLException, Exception;   
    

    /** This method will make the post in DB inactive
     */ 
    public boolean deletePost(String ctntid) throws SQLException, Exception;   

    /** This method will make the post in DB inactive
     */ 
    public boolean deletePostByUUID(String uuid) throws SQLException, Exception;   
    
    /** This method will insert the post into DB
     */ 
    public boolean insertPost(PostEntry pe) throws SQLException, Exception;

    /** This method will update the post into DB
     */ 
    public boolean updatePost(PostEntry pe) throws SQLException, Exception;
  
}