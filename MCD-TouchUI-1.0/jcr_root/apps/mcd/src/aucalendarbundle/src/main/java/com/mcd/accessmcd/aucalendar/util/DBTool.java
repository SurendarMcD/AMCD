/*wei - temporarily make a copy, will remove it*/     
/* Judy, 01_18_2011, update connection info  

*/

package com.mcd.accessmcd.aucalendar.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.jcr.Session;
import javax.sql.DataSource;

import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.commons.datasource.poolservice.DataSourcePool;

public class DBTool 
{
    private static final Logger log = LoggerFactory.getLogger(DBTool.class);
    SlingScriptHelper sling = null;
    Session jcrSession = null;
    DataSourcePool dbService = null;
    
    public DBTool(SlingScriptHelper sling, Session jcrSession)
    {
        this.sling = sling;
        this.jcrSession = jcrSession;
        dbService = sling.getService(DataSourcePool.class);
    }
    
    public DBTool(DataSourcePool dbService, Session jcrSession)
    {
        this.dbService = dbService;
        this.jcrSession = jcrSession;
    }
    /**
     * This method will be use to get connection details of database.
     * @param dataSourceName
     * @return Connection
     * @throws Exception
     */
    public Connection createConnection(String dataSourceName) throws Exception
    {
        //DataSourcePool dbService = sling.getService(DataSourcePool.class);
        Connection connection = null;
        try 
        { 
            DataSource dataSource = (DataSource)dbService.getDataSource(dataSourceName);
            connection = dataSource.getConnection();
        }
        catch(Exception e)
        {
            log.error("[DBTool.createConnection]:Exception in creating connection: " + e);
            System.out.println("Exception ====>"+e.getMessage());
            e.printStackTrace();
        }

        return connection;
    }
    
    
    
    public static Connection createConnection() throws Exception
    {
        Connection con = null;
        try
        {
            Class.forName("oracle.jdbc.driver.OracleDriver");           
            String serverName = "mcdeagsun104d";
            String portNumber = "1528";
            String sid = "SSHR03";
            String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":" + sid;
//            String username = "scott";
  //          String password = "tiger";
            String username = "pci";
            String password = "b1gm4c1s";
            con = DriverManager.getConnection(url, username, password);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return con;
    }
    
    /**
     * This method will be use to execute query and return ResultSet object.
     * @param con
     * @param query
     * @return ResultSet
     * @throws Exception
     */
    public static ResultSet executeQuery(Connection con, String query)
    {
        ResultSet rs = null;
        try
        {
            Statement stmt = con.createStatement();
            rs = stmt.executeQuery(query);
        }
        catch (SQLException e)
        {
            log.error("[DBTool.executeQuery]:Exception in executing query: " + e);
            e.printStackTrace();
        }
        return rs;
    }
    
    /**
     * This method will be use to add, update or delete records in database
     * @param con
     * @param query
     * @return Integer
     * @throws Exception
     */
    public static Integer executeUpdate(Connection con, String query)
    {
        Integer result = null;
        try
        {
            PreparedStatement pstmt = con.prepareStatement(query);
            int resultUpdated = pstmt.executeUpdate();
            result = new Integer(resultUpdated);
        }
        catch (SQLException e)
        {
            log.error("[DBTool.executeUpdate]:Exception in executing query: " + e);
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * This method will be use to close PreparedStatement objects. 
     * @param variable arguments of preparedstatement objects. 
     * @throws Exception
     */
    public static void closeStatement(PreparedStatement... pstmts)
    {
        try
        {
            for (PreparedStatement stmt : pstmts) 
            {
                if(stmt != null)
                {
                    stmt.close();
                }
            }
        }
        catch (SQLException e)
        {
            log.error("[DBTool.closeStatement]:Exception in closing prepared statements: " + e);
            e.printStackTrace();
        }       
    }
    
    /**
     * This method will be use to close ResultSet objects.
     * @param variable arguments of resultset objects.
     * @throws Exception
     */
    public static void closeResultSet(ResultSet... resultsets)
    {
        try
        {
            for (ResultSet rs : resultsets) 
            {
                if(rs != null)
                {
                    rs.close();
                }
            }
        }
        catch (SQLException e)
        {
            log.error("[DBTool.closeResultSet]:Exception in closing resultset: " + e);
            e.printStackTrace();
        }       
    }
    
    /**
     * This method will be use to close Connections
     * @param variable arguments of connection objects
     * @throws Exception
     */
    public static void closeConnection(Connection... connections)
    {
        try
        {
            for (Connection con : connections) 
            {
                if(con != null && !con.isClosed())
                {
                    con.close();
                }
            }
        }
        catch (SQLException e)
        {
            log.error("[DBTool.closeConnection]:Exception in closing connection: " + e);
            e.printStackTrace();
        }       
    }
}  