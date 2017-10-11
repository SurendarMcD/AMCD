/*
 * Project: AccessMCD
 *
 * @(#)DBTool.java
 * Revisions:
 * Date            Programmer           Description
 * -----------------------------------------------------------------------
 * 15,Dec,2010     Manoj Kumar Verma    This Utility Class contains the
 *                                      methods for getting and releasing 
 *                                      Database connections.
 * -----------------------------------------------------------------------                                             
 * Description:
 * This software is the confidential and proprietary information of
 * McDonald's Corp. ("Confidential Information").
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with McDonald's.
 *
 * Copyright (c) 2010 McDonalds Corp.
 * All Rights Reserved.
 * www.mcdonalds.com
 */

package com.mcd.accessmcd.mysites.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.jcr.Session;
import javax.sql.DataSource;

import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.commons.datasource.poolservice.DataSourcePool;

/**
 * @author Manoj Kumar Verma
 * @version 1.0
 * @since 1.0
 */
public class DBTool 
{
    private static final Logger log = LoggerFactory.getLogger(DBTool.class);
    SlingScriptHelper sling = null;
    Session jcrSession = null;
    
    /**
     * Parameterized Constructor.
     * @param sling
     * @param jcrSession
     */
    public DBTool(SlingScriptHelper sling, Session jcrSession)
    {
        this.sling = sling;
        this.jcrSession = jcrSession;
    }
    
    /**
     * This method is used to get Database connection.
     * @param dataSourceName
     * @return Connection
     * @throws Exception
     */
    public Connection createConnection(String dataSourceName) throws Exception
    {
        DataSourcePool dbService = sling.getService(DataSourcePool.class);
        Connection connection = null;
        DataSource dataSource = (DataSource)dbService.getDataSource(dataSourceName);
        connection = dataSource.getConnection();

        return connection;
    }
    
    /**
     * This method will be use to execute query and return ResultSet object.
     * @param con
     * @param query
     * @return ResultSet
     * @throws Exception
     */
    public static ResultSet executeQuery(Connection con, String query) throws Exception
    {
        ResultSet rs = null;
        Statement stmt = con.createStatement();
        rs = stmt.executeQuery(query);
        return rs;
    }
    
    /**
     * This method will be use to add, update or delete records in database
     * @param con
     * @param query
     * @return Integer
     * @throws Exception
     */
    public static Integer executeUpdate(Connection con, String query) throws Exception
    {
        Integer result = null;
        PreparedStatement pstmt = con.prepareStatement(query);
        int resultUpdated = pstmt.executeUpdate();
        result = new Integer(resultUpdated);
        return result;
    }
    
    /**
     * This method will be use to close PreparedStatement objects. 
     * @param variable arguments of prepared statement objects. 
     * @throws Exception
     */
    public static void closeStatement(PreparedStatement... pstmts) throws Exception
    {
        for (PreparedStatement stmt : pstmts) 
        {
            if(stmt != null)
            {
                stmt.close();
            }
        }       
    }
    
    /**
     * This method will be use to close ResultSet objects.
     * @param variable arguments of resultset objects.
     * @throws Exception
     */
    public static void closeResultSet(ResultSet... resultsets) throws Exception
    {
        for (ResultSet rs : resultsets) 
        {
            if(rs != null)
            {
                rs.close();
            }
        }       
    }
    
    /**
     * This method will be use to close Connections
     * @param variable arguments of connection objects
     * @throws Exception
     */
    public static void closeConnection(Connection... connections) throws Exception
    {
        for (Connection con : connections) 
        {
            if(con != null)
            {
                con.close();
            }
        }       
    }
}