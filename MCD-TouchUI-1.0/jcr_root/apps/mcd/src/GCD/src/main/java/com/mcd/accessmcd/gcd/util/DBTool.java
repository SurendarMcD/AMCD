package com.mcd.accessmcd.gcd.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.sql.DataSource;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.day.commons.datasource.poolservice.DataSourcePool;  
import com.mcd.accessmcd.gcd.constants.GCDConstants;
import com.mcd.accessmcd.gcd.util.DBUtil;

/*************************************************************************
 * This class interacts with the DB to get the connection from the
 * database and holds SQL query . 
 *
 * @version 1.0 &nbsp; December 22, 2011
 * @author : Mansi
 *
 *************************************************************************/
  
 
public class DBTool
{
    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(DBTool.class);
    
    public static Connection getConnection (SlingScriptHelper dbSling)
    {
        Connection connection = null;
        try
        {
        // code to retrieve the database details form the felix console//   
            DataSourcePool dbService = dbSling.getService(DataSourcePool.class); 
            DataSource dataSource = (DataSource)dbService.getDataSource(GCDConstants.DATA_SOURCE); 
            connection = dataSource.getConnection(); 
        
        } catch(Exception e)
        {
            log.error("[GCD DBTool] exception"+ e);
            DBUtil.sendExceptionMail(e);
        }
        return connection;
        
    }
    
    public static void closeObjects(Connection conn,ResultSet resultSet,PreparedStatement pstmt)
    {
        if(resultSet != null)
        {
            try
            {
                resultSet.close();
            }
            catch(SQLException _ex) { 
                log.error("[GCD DBTool] exception"+ _ex.getMessage());
            }
        }
        if(pstmt != null)
        {
            try
            {
                pstmt.close();
            }
            catch(SQLException _ex) { 
                log.error("[GCD DBTool] exception"+ _ex.getMessage());
            }
        }
        if(conn != null)
        {
            try
            {
                conn.close();
            }
            catch(SQLException _ex) { 
                log.error("[GCD DBTool] exception"+ _ex.getMessage());
                DBUtil.sendExceptionMail(_ex);
            }
        }
   }
   
   public static void closeObjects(Connection conn,PreparedStatement pstmt)
    {
        if(pstmt != null)
        {
            try
            {
                pstmt.close();
            }
            catch(SQLException _ex) { 
                log.error("[GCD DBTool] exception"+ _ex.getMessage());
            }
        }
        if(conn != null)
        {
            try
            {
                conn.close();
            }
            catch(SQLException _ex) { 
                log.error("[GCD DBTool] exception"+ _ex.getMessage());
                DBUtil.sendExceptionMail(_ex);
            }
        }
   }
}




