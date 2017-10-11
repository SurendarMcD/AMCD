package com.mcd.accessmcd.like.manager;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.apache.sling.api.SlingHttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.SQLException;

public interface LikeManager
{
    public boolean getUser(String user,String pagePath,SlingScriptHelper sling) throws Exception;
    
    public int likePage(SlingHttpServletRequest request,SlingScriptHelper sling) throws Exception,SQLException;
    
    public int likeCount(SlingScriptHelper sling,String path) throws Exception,SQLException;
    
}