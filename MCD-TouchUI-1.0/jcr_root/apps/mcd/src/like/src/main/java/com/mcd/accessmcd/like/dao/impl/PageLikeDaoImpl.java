package com.mcd.accessmcd.like.dao.impl;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import javax.jcr.Session;
import org.slf4j.LoggerFactory;
import com.mcd.accessmcd.like.dao.PageLikeDao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.mcd.accessmcd.like.DBUtil;
import java.sql.SQLException;
import java.sql.Timestamp;
import com.mcd.accessmcd.like.manager.impl.LikeManagerImpl;
public class PageLikeDaoImpl implements PageLikeDao{

/**
* default logger
*/        
private static final Logger log = LoggerFactory.getLogger(PageLikeDaoImpl.class);
Connection con = null;
PreparedStatement psLikeData = null;        
ResultSet rsLikeData = null;
DBUtil dbUtil= null;
boolean value=false;
SlingScriptHelper sling = null;
Session jcrSession = null;
DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
   //get current date time with Date()
   Date date = new Date();
   //System.out.println(dateFormat.format(date)); don't print it, but save it!
   String yourDate = dateFormat.format(date);
     
    public void PageLikeDaoImpl(){
        
    }
   
     //insert details of the user who liked the page
    public boolean insertUser(String userId,String pageURL,SlingScriptHelper sling) throws Exception
    {      log.info("--------->insertUser Method");
           LikeManagerImpl likeManagerImpl = new LikeManagerImpl();
           value = likeManagerImpl.getUser(userId,pageURL,sling);
           log.info("value---->"+value);
           if(!value){
           try 
        {
          
           dbUtil= new DBUtil(sling);
           log.info("----dbUtil----->"+dbUtil);
           con = dbUtil.getConnection();
           String queryString = "INSERT INTO LIKEDATA (USER_ID,PAGE_URL,LIKE_DATE) VALUES (?,?,?)";
           log.info("********query String********"+queryString.toString());
           psLikeData = con.prepareStatement(queryString.toString());
           psLikeData.setString(1, userId);
           psLikeData.setString(2, pageURL);
           psLikeData.setTimestamp(3,new java.sql.Timestamp(date.getTime()));
           psLikeData.executeUpdate();
           value=true;
           }
            catch (SQLException sqle)
            {
                log.info("insertUser:SQLException in getting site list: " + sqle);
                throw new SQLException("insertUser:SQLException in getting site list: " + sqle);
                
            }
            catch (Exception e)
            {
                log.info("insertUser:Exception in getting site list: " , e);
                throw new Exception("insertUser:Exception in getting site list: " , e);
                
            }
            finally
            {
                con.close(); 
            } 
           }  else
           {
           value=false;
           }                                     
        
    return value;
   }
   

}