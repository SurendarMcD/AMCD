/* 
 * CountryDAO.java                                                                                          
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep Jain                                                  
 * Date        :- December 09, 2008                                                     
 * Description :-  This class interacts with the DBTool class to get the 
 * connection from the database and holds different SQL queries on the basis of selected method. 
 *
 */

package com.mcd.accessmcd.gcd.dao;

import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.Calendar;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.api.scripting.SlingScriptHelper;
import com.mcd.accessmcd.gcd.util.DBTool;
import com.mcd.accessmcd.gcd.util.StringUtils;
import com.mcd.accessmcd.gcd.bean.CountryDetails;


/*************************************************************************
 * This class interacts with the DBTool class to get the connection from the
 * database and holds different SQL queries on the basis of selected method. 
 *
 * @version 1.0 &nbsp; December 09, 2008
 * @author : Sandeep Jain
 *
 *************************************************************************/

public class CountryDAO implements ICountryDAO
{
    /**
     * default logger
     */ 
    private static final Logger log = LoggerFactory.getLogger(CountryDAO.class);
    
    public ArrayList<String> getCountries(SlingScriptHelper sling) throws SQLException,Exception
    {
        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
         
        try
        {
            pstmt = conn.prepareStatement(SELECT_COUNTRY_SQL);
            if(conn!=null)
            {  
                CountryDetails countryDetails;
                resultSet=pstmt.executeQuery(); 
                while(resultSet.next())
                {
                        Date rowTs = resultSet.getDate(5);
                        rowTs = rowTs != null ? rowTs : new Date(Calendar.getInstance().getTimeInMillis());
                        
                        countryDetails = new CountryDetails();
                        countryDetails.setCtryCd(StringUtils.nullToEmptyString(resultSet.getString(1)));
                        countryDetails.setCtryNm(StringUtils.nullToEmptyString(resultSet.getString(2)));
                        countryDetails.setActiveFl(StringUtils.nullToEmptyString(resultSet.getString(3)));
                        countryDetails.setRowEid(StringUtils.nullToEmptyString(resultSet.getString(4)));
                        countryDetails.setRowTs(rowTs);
                        
                        queryResults.add(countryDetails); 
                 }
            }
        }catch (SQLException sqle) {
            log.error("[GCD] [CountryDAO getCountries] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [CountryDAO getCountries] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [CountryDAO getCountries] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [CountryDAO getCountries] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }

    
    public int updateCountriesStatus(ArrayList<CountryDetails> updateList,String eid,SlingScriptHelper sling)throws SQLException,Exception
    {
        int retVal = 0;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        
        try
        {
            if(conn!=null)
            {           
                pstmt = conn.prepareStatement(UPDATE_COUNTRY_SQL);
                int sizeUpdateList = updateList.size();
                for(int i = 0; i < sizeUpdateList; i++){
                    CountryDetails countryDetails = (CountryDetails)updateList.get(i);
                    pstmt.setString(1, countryDetails.getActiveFl());
                    pstmt.setString(2, eid);
                    pstmt.setString(3, countryDetails.getCtryCd());
                    retVal = pstmt.executeUpdate();
                        
                }
                conn.commit();          
            }
        }catch (SQLException sqle) {
            log.error("[GCD] [CountryDAO updateCountriesStatus] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [CountryDAO updateCountriesStatus] Error while fetching data from database :: "+ sqle.getMessage());
        }

        catch (Exception e) {

            log.error(" [GCD] [CountryDAO updateCountriesStatus] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [CountryDAO updateCountriesStatus] Error while fetching data from database " + e.getMessage());
        }
        
        finally{
             // closing the database connection
            DBTool.closeObjects(conn,pstmt);
        }
        return retVal;
    }

    public int updateCountriesFlag(SlingScriptHelper sling) throws SQLException,Exception
    {
        int retVal = 0;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        
        try
        {
            if(conn!=null)
            {           
                pstmt = conn.prepareStatement(UPDATE_COUNTRY_FLAG_SQL);
                pstmt.setString(1,"F");
                retVal = pstmt.executeUpdate();
                conn.commit();
            }
        }catch (SQLException sqle) {
            log.error("[GCD] [CountryDAO updateCountriesFlag] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [CountryDAO updateCountriesFlag] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [CountryDAO updateCountriesFlag] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [CountryDAO updateCountriesFlag] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,pstmt);
        }
        return retVal;
    }
    
    private static String SELECT_COUNTRY_SQL = "select ctry_cd, ctry_na, active_fl, row_eid, row_ts  from gcd_v1contry order by ctry_na";
    private static String UPDATE_COUNTRY_SQL = "update gcd_v1contry  set active_fl = ?,      row_eid = ?,      row_ts = sysdate  where ctry_cd = ? ";
    private static String UPDATE_COUNTRY_FLAG_SQL ="update gcd_v1contry set active_fl=?";
}