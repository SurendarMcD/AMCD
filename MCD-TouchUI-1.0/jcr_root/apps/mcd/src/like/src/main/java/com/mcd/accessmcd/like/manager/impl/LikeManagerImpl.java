package com.mcd.accessmcd.like.manager.impl;

import com.mcd.accessmcd.like.dao.impl.PageLikeDaoImpl;
//import java.io.IOException;
import com.mcd.accessmcd.like.DBUtil;
import javax.jcr.Session;
import javax.servlet.Servlet;
//import javax.servlet.ServletException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
//import org.apache.sling.api.resource.ResourceResolver;
//import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.day.cq.wcm.api.PageManager;
import com.day.cq.wcm.api.Page;
//import org.osgi.service.component.ComponentContext;
//import org.osgi.framework.BundleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
//import org.apache.sling.runmode.RunMode; 
import com.mcd.accessmcd.like.manager.LikeManager;
import org.apache.sling.api.scripting.SlingScriptHelper;
import javax.jcr.Session;
//import com.mcd.accessmcd.comments.constants.CommentsConstants;
//import com.day.cq.commons.jcr.JcrUtil;
import com.day.cq.security.User;

public class LikeManagerImpl implements LikeManager
{
    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(LikeManagerImpl.class);
    /** @scr.reference */
    SlingScriptHelper sling;
    Session jcrSession = null;
    DBUtil dbUtil= null;
    Connection con = null;
    PreparedStatement psLikeData = null;        
    ResultSet rsLikeData = null;
    private PageLikeDaoImpl likePageDao;   
    boolean hover = false; 
  
 /* 
    
    @Override
    public void doPost(SlingHttpServletRequest request, SlingHttpServletResponse response) throws  Exception
    {   log.info("--------->Post");
        try
        {
           // String responseString = likePage(request);
           // response.getWriter().write(responseString);                
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
            log.info("DoPost:Exception in getting site list: " );
        }
    }
   */ 
    public int likePage(SlingHttpServletRequest request ,SlingScriptHelper sling) throws Exception,SQLException
    {   log.info("--------->likePage Method------------>"+sling);
        dbUtil= new DBUtil(sling);
        boolean isLikeCountExists = false;
        int likeCount=0;
        Resource resource = null;
        String resourcePath = null;
        PreparedStatement psLikeData = null;        
        ResultSet rsLikeData = null;
        resource = request.getResourceResolver().getResource(request.getResource().getPath());
        PageManager pageManager = request.getResourceResolver().adaptTo(PageManager.class);
        Page page = pageManager.getContainingPage(resource);
        resourcePath = page.getPath();
       // resourcePath=resourcePath.replaceAll("/jcr:content/maincontentpara/like","");
        log.info("resourcePath----->"+resourcePath);
        final User user = request.getResourceResolver().adaptTo(User.class);//instantiate User object
        String authorId = user.getID();
               
        
           likePageDao=new PageLikeDaoImpl(); 
          boolean bLikePage= likePageDao.insertUser(authorId,resourcePath,sling);
          log.info("bLikePage----------->"+bLikePage);
          
          try
        {
               con = dbUtil.getConnection();
               log.info("con**********" +resourcePath);
               String queryString = "SELECT COUNT(*) FROM LIKEDATA WHERE PAGE_URL = ? ";
               log.info("********query String********"+queryString.toString());
               psLikeData = con.prepareStatement(queryString.toString());
               
               psLikeData.setString(1, resourcePath);
               rsLikeData = psLikeData.executeQuery();  
                                                      
               if(rsLikeData.next()){
                log.info("con**********"+rsLikeData.getInt(1));
                   if (rsLikeData.getInt(1)!= 0){
                       likeCount = rsLikeData.getInt(1);
                     }
                }                                  
             }
            catch (SQLException sqle)
            {
                log.info("likePage:SQLException in getting Like Count list: " , sqle);
                throw new SQLException("likePage:SQLException in getting Like Count list: " , sqle);
               
            }
            catch (Exception e)
            {
                log.info("likePage:Exception in getting Like Count list: " , e);
                throw new Exception("likePage:Exception in getting Like Countlist: " , e);
                
            }
            finally
            {
                con.close(); 
            }  
        
        
        log.info("******************* Like Count Added Successfully* ************************* ");
        return likeCount;
    }
    
    public int likeCount(SlingScriptHelper sling,String path)  throws Exception,SQLException
    {     int likeCounts =0;  
        try
        {   
               
               dbUtil= new DBUtil(sling);
               con = dbUtil.getConnection();
               log.info("con**********" +path);
               String queryString = "SELECT COUNT(*) FROM LIKEDATA WHERE PAGE_URL = ? ";
               log.info("********query String********"+queryString.toString());
               psLikeData = con.prepareStatement(queryString.toString());
               psLikeData.setString(1, path);
               rsLikeData = psLikeData.executeQuery();  
               if(rsLikeData.next()){
                  log.info("con**********"+rsLikeData.getInt(1));
                   if (rsLikeData.getInt(1)!= 0)
                   {
                      likeCounts = rsLikeData.getInt(1);
                   }
               }  
               
          }
            catch (SQLException sqle)
            {
                log.info("likeCount:SQLException in getting Like Count list: " + sqle);
                throw new SQLException("likeCount:SQLException in getting Like Count list: " + sqle);
               
            }
            catch (Exception e)
            {
                log.info("likeCount:Exception in getting Like Count list: " + e);
                throw new Exception("likeCount:Exception in getting Like Countlist: " + e);
                
            }
            finally
            {
                if(con != null && !con.isClosed()){
            
            con.close(); 
            }
            } 
                   return likeCounts;                                
    }
    
     //check if the user has already like the page   
    public boolean getUser(String user,String pagePath,SlingScriptHelper sling) throws Exception
    { 
      try 
      { 
      
            dbUtil= new DBUtil(sling);
            con = dbUtil.getConnection();
           String queryString = "SELECT USER_ID from LIKEDATA WHERE USER_ID = ? AND PAGE_URL= ?";
           log.info("********query String********"+queryString.toString());
           psLikeData = con.prepareStatement(queryString.toString());
           psLikeData.setString(1, user);
           psLikeData.setString(2, pagePath);
           rsLikeData = psLikeData.executeQuery();                                          
           while(rsLikeData.next())
           {                                       
               String userId = rsLikeData.getString("USER_ID").toLowerCase();
               if(null!=userId)
               {
                   if(userId.equalsIgnoreCase(user))
                   {
                        hover = true;
                   }
                   else
                    {
                        hover = false;
                    } 
                }  else {
                
                }                         
           }
           
           
           
      } 
       catch (SQLException sqle)
        {
            log.info("getUser:SQLException in getting site list: " + sqle);
            throw new SQLException("getUser:SQLException in getting site list: " + sqle);
         
        }
        catch (Exception e)
        {
            log.info("getUser:Exception in getting site list: " + e);
            throw new Exception("getUser:Exception in getting site list: " + e);
            
        }
        finally
        {
            if(con != null && !con.isClosed()){
            
            con.close(); 
            }
        }  
     return hover;
    }
    
}