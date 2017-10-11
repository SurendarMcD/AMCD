package com.mcd.accessmcd.searchhistory.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.api.scripting.SlingScriptHelper;

import java.sql.SQLException;
import java.sql.Connection;
import javax.sql.DataSource;

import com.day.commons.datasource.poolservice.DataSourcePool;

public class DBUtil {

    private static final String CQDATASOURCENAME="search";
    private static final Logger log = LoggerFactory.getLogger(DBUtil.class);
    
    /**
     * Retreiving connection using DataSourcePool Service 
     */
    public static Connection getConnection(SlingScriptHelper sling) throws Exception {
        Connection connection = null;
        
        try {
            DataSourcePool dbService = sling.getService(DataSourcePool.class);
            DataSource dataSource = (DataSource)dbService.getDataSource(CQDATASOURCENAME);
            connection = dataSource.getConnection();
            log.info("Connection to Search DataBase Successful"); 
        } catch (SQLException sqle) {
            log.info("SQLException in getting Connection: ",sqle);
            throw new SQLException("SQLException in getting Connection: " + sqle);
        } catch (Exception e) {
            log.info("Exception in getting Connection: ",e);
            throw new Exception("Exception in getting Connection:" + e);
        }
        return connection; 
    }  
    
    /**
     * Close the input connection
     * @param conn - Database connection
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) { 
                /* ignored */
                log.error("Error while closing the connection", e);
            }
        }
    }
}