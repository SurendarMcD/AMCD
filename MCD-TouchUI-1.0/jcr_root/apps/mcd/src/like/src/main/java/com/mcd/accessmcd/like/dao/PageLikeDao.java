package com.mcd.accessmcd.like.dao;
import org.apache.sling.api.scripting.SlingScriptHelper;
public interface PageLikeDao {

    public boolean insertUser(String userId,String pageURL,SlingScriptHelper sling) throws Exception;
    
   

}
