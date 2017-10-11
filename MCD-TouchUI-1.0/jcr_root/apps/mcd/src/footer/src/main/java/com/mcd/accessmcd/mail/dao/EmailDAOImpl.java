package com.mcd.accessmcd.mail.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.sql.DataSource;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.commons.datasource.poolservice.DataSourcePool;

/**
 * This class is used for saving the mail data into database  
 *
 * @author Rajat Chawla
 * @version 1.0
 *
 */

public class EmailDAOImpl implements IEmailDAO{
    
    private static final Logger log = LoggerFactory.getLogger(com.mcd.accessmcd.mail.dao.EmailDAOImpl.class);
    
    // method to store the email details in the database //
    public void postEmailData (String sender_id, String sender_role, String article_url, String article_name, String sendto,SlingScriptHelper sling)
    {
             // name of the table //
            String PAF_TABLE = "MCDX.EMAILED_ARTICLES";
             // Query for inserting the values in the database //
            String PAF_INSERT = "INSERT INTO " + PAF_TABLE + " (EMAIL_ID,SENDER_ID,SENDER_ROLE,ARTICLE_URL,ARTICLE_NAME, SENDTOADDR,SENDDATE) " +
            "VALUES (MCDX.EMAILED_ARTICLES_SEQ.NEXTVAL,?,?,?,?,?,SYSDATE)";
             // calling the getConnection method for getting the connection from the flix console //
             // passing the sling object & database source name //
            Connection con =getConnection(sling,"mailData");
            PreparedStatement pstmt = null;
            
            // checking for connection value //
            if(con == null)
            {
                return;
            }
            // if sender id & article URl is null //
            if(sender_id == null || article_url == null)
            {
                return;
            }
            // if sender role is null //
            if(sender_role == null)
            {
                sender_role = "";
            }
            try
            {
                con.setAutoCommit(false);
                pstmt = con.prepareStatement(PAF_INSERT);
                pstmt.setString(1, sender_id.trim());
                pstmt.setString(2, sender_role.trim());
                pstmt.setString(3, article_url.trim());
                pstmt.setString(4, article_name.trim());
                pstmt.setString(5, sendto.trim());
                pstmt.executeUpdate();
                con.commit();
            }
            catch(SQLException ex)
            {
                log.error("[EmailDAOImpl] exception "+ex.getMessage());
            }
            catch(Exception e)
            {
                log.error("[EmailDAOImpl] exception caught "+e);
            }
            finally
            {
                
                if(con != null)
                {
                    try
                    {
                        con.close();
                    }
                    catch(SQLException _ex) { 
                        log.error("EmailDAOImpl] exception"+ _ex.getMessage());}
                }
                if(pstmt != null)
                {
                    try
                    {
                        pstmt.close();
                    }
                    catch(SQLException _ex) { 
                        log.error("EmailDAOImpl] exception"+ _ex);
                        }
                }
            }
        
    
    
    
    }
    
       // method to return the database connection //
    private Connection getConnection (SlingScriptHelper sling1, String dsName)
    {
        Connection connection = null;
        try
        {
        // code to retrieve the database details form the felix console//   
        DataSourcePool dbService = sling1.getService(DataSourcePool.class); 
        DataSource dataSource = (DataSource)dbService.getDataSource(dsName); 
         connection = dataSource.getConnection(); 
        
        } catch(Exception e)
        {
            log.error("EmailDAOImpl] exception"+ e);
        }
        return connection;
        
    }
    

}