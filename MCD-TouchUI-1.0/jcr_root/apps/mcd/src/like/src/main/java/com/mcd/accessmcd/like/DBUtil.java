package com.mcd.accessmcd.like;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.SQLException;
import javax.jcr.Session;
import java.sql.Connection;
import javax.sql.DataSource;
import com.day.commons.datasource.poolservice.DataSourcePool;
import org.apache.sling.api.scripting.SlingScriptHelper;

public class DBUtil{

//Dev Database
      /** @scr.reference policy="static" */
    private DataSourcePool dataSourceService;
    
    
    private static final Logger log = LoggerFactory.getLogger(DBUtil.class);
    SlingScriptHelper sling = null;
    
   
    
    /**
     * Parameterized Constructor.
     * @param sling
     * @param jcrSession
     */
    public DBUtil(SlingScriptHelper sling)
    {
        this.sling=sling;
    }    
  
    
    /*Getting connection 
    */
    public Connection getConnection()throws Exception {
             Connection connection = null;
              
            try
            {
             log.info("Connection1");
              DataSourcePool dbService = sling.getService(DataSourcePool.class);
              log.info("Connection2------>"+dbService);
              DataSource dataSource = (DataSource)dbService.getDataSource("mySitesDSN");
               log.info("Connection3");
              connection = dataSource.getConnection();
              log.info("Connection4"); 
                  
            }
            catch (SQLException sqle)
            {
            log.info("SQLException in getting Connection: " + sqle);
            throw new SQLException("SQLException in getting Connection: " + sqle);
            
            }
            catch (Exception e)
            {
            log.info("SQLException in getting Connection: " + e);
            throw new Exception("SQLException in getting Connection:" + e);
            
            }
            return connection; 
    }  
    
}