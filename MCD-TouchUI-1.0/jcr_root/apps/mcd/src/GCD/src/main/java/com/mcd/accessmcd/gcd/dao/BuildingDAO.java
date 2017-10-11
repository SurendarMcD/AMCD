/* 
 * BuildingDAO.java                                                                                         
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep Jain                                                  
 * Date        :- December 09, 2008                                                     
 * Description :-  This class interacts with the DBTool class to get the 
 * connection from the database and holds different SQL queries on the basis of selected method. 
 *
 */

package com.mcd.accessmcd.gcd.dao;

import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.util.ArrayList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.api.scripting.SlingScriptHelper;
import com.mcd.accessmcd.gcd.util.DBTool;
import com.mcd.accessmcd.gcd.util.StringUtils;
import com.mcd.accessmcd.gcd.bean.BuildingDetails;


/*************************************************************************
 * This class interacts with the DBTool class to get the connection from the
 * database and holds different SQL queries related to building on the basis 
 * of selected method.
 * 
 * @version 1.0 &nbsp; December 09, 2008
 * @author : Sandeep Jain 
 * 
 *************************************************************************/

public class BuildingDAO implements IBuildingDAO{
    
    /**
     * default logger
     */
    private static final Logger log = LoggerFactory.getLogger(BuildingDAO.class);
    
    public ArrayList getUSBuildings(SlingScriptHelper sling) throws SQLException, Exception
    {

        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try {
            if(conn!=null){
                pstmt = conn.prepareStatement(SELECT_ALL_US_BUILDING_NAMES_SQL);
                resultSet = pstmt.executeQuery(); 
                BuildingDetails buildingDetails;
                while(resultSet.next())
                {
                    buildingDetails = new BuildingDetails();
                    buildingDetails.setBldgCd(resultSet.getInt(1));
                    buildingDetails.setBldgNa(StringUtils.nullToEmptyString(resultSet.getString(2)));
                    buildingDetails.setSiteDs(StringUtils.nullToEmptyString(resultSet.getString(3)));
                    buildingDetails.setSiteL1Ad(StringUtils.nullToEmptyString(resultSet.getString(4)));
                    buildingDetails.setSiteL2Ad(StringUtils.nullToEmptyString(resultSet.getString(5)));
                    buildingDetails.setSiteCityAd(StringUtils.nullToEmptyString(resultSet.getString(6)));
                    buildingDetails.setSiteAbbrStAd(StringUtils.nullToEmptyString(resultSet.getString(7)));
                    buildingDetails.setSitePstlCd(StringUtils.nullToEmptyString(resultSet.getString(8)));
                    buildingDetails.setCtryCd(StringUtils.nullToEmptyString(resultSet.getString(9)));
                    buildingDetails.setSiteOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(10)));
                    
                    queryResults.add(buildingDetails);
                }
            }
            
        } catch (SQLException sqle) {
            log.error("[GCD] [BuildingDAO getUSBuildings] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [BuildingDAO getUSBuildings] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO getUSBuildings] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [BuildingDAO getUSBuildings] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }

    public ArrayList getIntlBuildings(SlingScriptHelper sling) throws SQLException, Exception
    {
        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(SELECT_ALL_INTL_BUILDING_NAMES_SQL);
                resultSet = pstmt.executeQuery(); 
                BuildingDetails buildingDetails;
                while(resultSet.next())
                {
                    buildingDetails = new BuildingDetails();
                    buildingDetails.setBldgCd(resultSet.getInt(1));
                    buildingDetails.setBldgNa(StringUtils.nullToEmptyString(resultSet.getString(2)));
                    buildingDetails.setSiteDs(StringUtils.nullToEmptyString(resultSet.getString(3)));
                    buildingDetails.setSiteL1Ad(StringUtils.nullToEmptyString(resultSet.getString(4)));
                    buildingDetails.setSiteL2Ad(StringUtils.nullToEmptyString(resultSet.getString(5)));
                    buildingDetails.setSiteCityAd(StringUtils.nullToEmptyString(resultSet.getString(6)));
                    buildingDetails.setSiteAbbrStAd(StringUtils.nullToEmptyString(resultSet.getString(7)));
                    buildingDetails.setSitePstlCd(StringUtils.nullToEmptyString(resultSet.getString(8)));
                    buildingDetails.setCtryCd(StringUtils.nullToEmptyString(resultSet.getString(9)));
                    buildingDetails.setSiteOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(10)));
                    buildingDetails.setSiteCtryNa(StringUtils.nullToEmptyString(resultSet.getString(11)));
                    buildingDetails.setSiteL3Ad(StringUtils.nullToEmptyString(resultSet.getString(12)));
                    buildingDetails.setSiteL4Ad(StringUtils.nullToEmptyString(resultSet.getString(13)));
                    buildingDetails.setSiteL5Ad(StringUtils.nullToEmptyString(resultSet.getString(14)));
                    buildingDetails.setSitePhneNu(StringUtils.nullToEmptyString(resultSet.getString(15)));
                    buildingDetails.setSiteFaxNu(StringUtils.nullToEmptyString(resultSet.getString(16)));
                    buildingDetails.setSiteCourierCd(StringUtils.nullToEmptyString(resultSet.getString(17)));
                    buildingDetails.setSiteOffcDs(StringUtils.nullToEmptyString(resultSet.getString(18)));
                    buildingDetails.setSiteIntlPstlCd(StringUtils.nullToEmptyString(resultSet.getString(19)));
                    buildingDetails.setSiteId(resultSet.getInt(20));
                    
                    queryResults.add(buildingDetails);
                }
            }
        
        } catch (SQLException sqle) {
            log.error("[GCD] [BuildingDAO getIntlBuildings] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( " [GCD] [BuildingDAO getIntlBuildings] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO getIntlBuildings] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [BuildingDAO getIntlBuildings] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }
    
    
    public int mergeUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception 
    {
        int retVal = 0;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        
        try {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(MERGE_US_BUILDING_NAME_SQL);
                pstmt.setInt(1, buildingDetails.getBldgCd());
                pstmt.setString(2, buildingDetails.getBldgNa());
                pstmt.setString(3, buildingDetails.getSiteDs());
                pstmt.setString(4, buildingDetails.getSiteL1Ad());
                pstmt.setString(5, buildingDetails.getSiteL2Ad());
                pstmt.setString(6, buildingDetails.getSiteCityAd());
                pstmt.setString(7, buildingDetails.getSiteAbbrStAd());
                pstmt.setString(8, buildingDetails.getSitePstlCd());
                pstmt.setString(9, "US");
                pstmt.setString(10, buildingDetails.getSiteOffcPhne());
                pstmt.setInt(11, buildingDetails.getBldgCd());
                pstmt.setString(12, buildingDetails.getBldgNa());
                pstmt.setString(13, buildingDetails.getSiteDs());
                pstmt.setString(14, buildingDetails.getSiteL1Ad());
                pstmt.setString(15, buildingDetails.getSiteL2Ad());
                pstmt.setString(16, buildingDetails.getSiteCityAd());
                pstmt.setString(17, buildingDetails.getSiteAbbrStAd());
                pstmt.setString(18, buildingDetails.getSiteIntlPstlCd());
                pstmt.setString(19, buildingDetails.getSitePstlCd());
                pstmt.setString(20,"US");
                pstmt.setString(21, buildingDetails.getSiteOffcPhne());
                retVal = pstmt.executeUpdate();
                conn.commit();
            }

        } catch (SQLException sqle) {
            log.error("[GCD] [BuildingDAO mergeUSBuilding] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [BuildingDAO mergeUSBuilding] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO mergeUSBuilding] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [BuildingDAO mergeUSBuilding] Error while fetching data from database " + e.getMessage());
        }
        finally{
            /// closing the database connection
            DBTool.closeObjects(conn,pstmt);       
        }
        return retVal;
    }
    
    public int updateUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception 
    {
        int retVal = 0;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        
        try {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(UPDATE_US_BUILDING_NAME_SQL);
                pstmt.setString(1, buildingDetails.getBldgNa());
                pstmt.setString(2, buildingDetails.getSiteDs());
                pstmt.setString(3, buildingDetails.getSiteL1Ad());
                pstmt.setString(4, buildingDetails.getSiteL2Ad());
                pstmt.setString(5, buildingDetails.getSiteCityAd());
                pstmt.setString(6, buildingDetails.getSiteAbbrStAd());
                pstmt.setString(7, buildingDetails.getSitePstlCd());
                pstmt.setString(8, "US");
                pstmt.setString(9, buildingDetails.getSiteOffcPhne());
                pstmt.setInt(10, buildingDetails.getBldgCd());
                retVal = pstmt.executeUpdate();
                conn.commit();
            }

        } catch (SQLException sqle) {
            log.error("[GCD] [BuildingDAO updateUSBuilding] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "Error while fetching data from database updateUSBuilding:: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO updateUSBuilding] Error while fetching data from database " + e.getMessage());
            throw new Exception(" Error while fetching data from database updateUSBuilding " + e.getMessage());
        }
        finally{
            /// closing the database connection
            DBTool.closeObjects(conn,pstmt);  
        }
        return retVal;
    }

    
    public int updateIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception 
    {
        int retVal = 0;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        
        try {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(UPDATE_INTL_BUILDING_NAME_SQL);
                pstmt.setString(1, buildingDetails.getBldgNa());
                pstmt.setString(2, buildingDetails.getSiteDs());
                pstmt.setString(3, buildingDetails.getSiteL1Ad());
                pstmt.setString(4, buildingDetails.getSiteL2Ad());
                pstmt.setString(5, buildingDetails.getSiteCityAd());
                pstmt.setString(6, buildingDetails.getSiteAbbrStAd());
                pstmt.setString(7, buildingDetails.getSitePstlCd());
                pstmt.setString(8, buildingDetails.getCtryCd());
                pstmt.setString(9, buildingDetails.getSiteOffcPhne());
                pstmt.setString(10, buildingDetails.getSiteL3Ad());
                pstmt.setString(11, buildingDetails.getSiteL4Ad());
                pstmt.setString(12, buildingDetails.getSiteL5Ad());
                pstmt.setString(13, buildingDetails.getSitePhneNu());
                pstmt.setString(14, buildingDetails.getSiteFaxNu());
                pstmt.setString(15, buildingDetails.getSiteCourierCd());
                pstmt.setString(16, buildingDetails.getSiteOffcDs());
                pstmt.setString(17, buildingDetails.getSiteIntlPstlCd());
                
                if(buildingDetails.getSiteIdStr()==null){
                    pstmt.setNull(18,java.sql.Types.INTEGER);
                }
                else{
                    pstmt.setInt(18, buildingDetails.getSiteId());
                }
                
                pstmt.setInt(19, buildingDetails.getBldgCd());
                retVal = pstmt.executeUpdate();
                conn.commit();
            }

        } catch (SQLException sqle) {
            log.error("[GCD] [BuildingDAO updateIntlBuilding] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "Error while fetching data from database updateIntlBuilding :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO updateIntlBuilding] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" Error while fetching data from database updateIntlBuilding ::" + e.getMessage());
        }
        finally{
            /// closing the database connection
            DBTool.closeObjects(conn,pstmt); 
        }
        return retVal;
    }
    
    
    public int mergeIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception 
    {
        int retVal = 0;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        
        try {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(MERGE_INTL_BUILDING_NAME_SQL);
                pstmt.setInt(1, buildingDetails.getBldgCd());
                pstmt.setString(2, buildingDetails.getBldgNa());
                pstmt.setString(3, buildingDetails.getSiteDs());
                pstmt.setString(4, buildingDetails.getSiteL1Ad());
                pstmt.setString(5, buildingDetails.getSiteL2Ad());
                pstmt.setString(6, buildingDetails.getSiteCityAd());
                pstmt.setString(7, buildingDetails.getSiteAbbrStAd());
                pstmt.setString(8, buildingDetails.getSitePstlCd());
                pstmt.setString(9, buildingDetails.getCtryCd());
                pstmt.setString(10, buildingDetails.getSiteOffcPhne());
                pstmt.setString(11, buildingDetails.getSiteL3Ad());
                pstmt.setString(12, buildingDetails.getSiteL4Ad());
                pstmt.setString(13, buildingDetails.getSiteL5Ad());
                pstmt.setString(14, buildingDetails.getSitePhneNu());
                pstmt.setString(15, buildingDetails.getSiteFaxNu());
                pstmt.setString(16, buildingDetails.getSiteCourierCd());
                pstmt.setString(17, buildingDetails.getSiteOffcDs());
                pstmt.setString(18, buildingDetails.getSiteIntlPstlCd());
                pstmt.setInt(19, buildingDetails.getBldgCd());
                pstmt.setString(20, buildingDetails.getBldgNa());
                pstmt.setString(21, buildingDetails.getSiteDs());
                pstmt.setString(22, buildingDetails.getSiteL1Ad());
                pstmt.setString(23, buildingDetails.getSiteL2Ad());
                pstmt.setString(24, buildingDetails.getSiteCityAd());
                pstmt.setString(25, buildingDetails.getSiteAbbrStAd());
                pstmt.setString(26, buildingDetails.getSitePstlCd());
                pstmt.setString(27, buildingDetails.getCtryCd());
                pstmt.setString(28, buildingDetails.getSiteOffcPhne());
                pstmt.setString(29, buildingDetails.getSiteL3Ad());
                pstmt.setString(30, buildingDetails.getSiteL4Ad());
                pstmt.setString(31, buildingDetails.getSiteL5Ad());
                pstmt.setString(32, buildingDetails.getSitePhneNu());
                pstmt.setString(33, buildingDetails.getSiteFaxNu());
                pstmt.setString(34, buildingDetails.getSiteCourierCd());
                pstmt.setString(35, buildingDetails.getSiteOffcDs());
                pstmt.setString(36, buildingDetails.getSiteIntlPstlCd());
                pstmt.setString(37, buildingDetails.getSiteCtryNa());
                retVal = pstmt.executeUpdate();
                conn.commit();
            }

        } catch (SQLException sqle) {
            log.error("[GCD] [BuildingDAO mergeIntlBuilding] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "Error while fetching data from database mergeIntlBuilding:: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO mergeIntlBuilding] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" Error while fetching data from database mergeIntlBuilding ::" + e.getMessage());
        }
        finally{
            /// closing the database connection
            DBTool.closeObjects(conn,pstmt); 
        }
        return retVal;
    }
    
    
    
    public int addUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception 
    {   
        int retVal = 0;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        
        try {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(INSERT_BUILDING_NAME_SQL);
                pstmt.setInt(1, buildingDetails.getBldgCd());
                pstmt.setString(2, buildingDetails.getBldgNa());
                pstmt.setString(3, buildingDetails.getSiteDs());
                pstmt.setString(4, buildingDetails.getSiteL1Ad());
                pstmt.setString(5, buildingDetails.getSiteL2Ad());
                pstmt.setString(6, buildingDetails.getSiteCityAd());
                pstmt.setString(7, buildingDetails.getSiteAbbrStAd());
                pstmt.setString(8, buildingDetails.getSitePstlCd());
                pstmt.setString(9, "US");
                pstmt.setString(10, buildingDetails.getSiteOffcPhne());
                retVal = pstmt.executeUpdate();
                conn.commit();
            }

        } catch (SQLException sqle) {
            log.error("[GCD] [BuildingDAO addUSBuilding] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "Error while fetching data from database addUSBuilding:: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO addUSBuilding] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" Error while fetching data from database addUSBuilding::" + e.getMessage());
        }
        finally{
            /// closing the database connection
            DBTool.closeObjects(conn,pstmt);
        }
        return retVal;
    }
    
    
    public int addIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception 
    {
        int retVal = 0;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        
        try {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(INSERT_INTL_BUILDING_NAME_SQL);
                pstmt.setInt(1, buildingDetails.getBldgCd());
                pstmt.setString(2, buildingDetails.getBldgNa());
                pstmt.setString(3, buildingDetails.getSiteDs());
                pstmt.setString(4, buildingDetails.getSiteL1Ad());
                pstmt.setString(5, buildingDetails.getSiteL2Ad());
                pstmt.setString(6, buildingDetails.getSiteCityAd());
                pstmt.setString(7, buildingDetails.getSiteAbbrStAd());
                pstmt.setString(8, buildingDetails.getSitePstlCd());
                pstmt.setString(9, buildingDetails.getCtryCd());
                pstmt.setString(10, buildingDetails.getSiteOffcPhne());
                pstmt.setString(11, buildingDetails.getSiteL3Ad());
                pstmt.setString(12, buildingDetails.getSiteL4Ad());
                pstmt.setString(13, buildingDetails.getSiteL5Ad());
                pstmt.setString(14, buildingDetails.getSitePhneNu());
                pstmt.setString(15, buildingDetails.getSiteFaxNu());
                pstmt.setString(16, buildingDetails.getSiteCourierCd());
                pstmt.setString(17, buildingDetails.getSiteOffcDs());
                pstmt.setString(18, buildingDetails.getSiteIntlPstlCd());
                
                if(buildingDetails.getSiteIdStr()==null){
                    pstmt.setNull(19,java.sql.Types.INTEGER);
                }
                else{
                    pstmt.setInt(19, buildingDetails.getSiteId());
                }
                retVal = pstmt.executeUpdate();
                conn.commit();
            }
        
        } catch (SQLException sqle) {
            log.error("[GCD] [BuildingDAO addIntlBuilding] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException("Error while fetching data from database addIntlBuilding:: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO addIntlBuilding] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [BuildingDAO addIntlBuilding] Error while fetching data from database " + e.getMessage());
        }
        finally{
            /// closing the database connection
            DBTool.closeObjects(conn,pstmt);
        }
        return retVal;
    }
    
    public int deleteBuilding(int bldgCd,SlingScriptHelper sling)throws SQLException, Exception 
    {
        int retVal = 0;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        
        try {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(DELETE_BUILDING_NAME_SQL);
                pstmt.setInt(1, bldgCd);
                retVal = pstmt.executeUpdate();
                conn.commit();
            }
        
        } catch (SQLException sqle) {
            log.error(" [GCD] [BuildingDAO deleteBuilding] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( " [GCD] [BuildingDAO deleteBuilding] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO deleteBuilding] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [BuildingDAO deleteBuilding] Error while fetching data from database " + e.getMessage());
        }
        finally{
            /// closing the database connection
            DBTool.closeObjects(conn,pstmt);
        }
        return retVal;
    }
    
    public ArrayList getBuildingNamesByBldgCode(int bldgCd,SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(SELECT_BUILDING_NAME_BY_BLDG_CODE_SQL);
                pstmt.setInt(1, bldgCd);
                resultSet = pstmt.executeQuery();
                BuildingDetails buildingDetails = null;
                while(resultSet.next())
                {
                    buildingDetails = new BuildingDetails();
                    buildingDetails.setBldgCd(resultSet.getInt(1));
                    buildingDetails.setBldgNa(StringUtils.nullToEmptyString(resultSet.getString(2)));
                    buildingDetails.setSiteDs(StringUtils.nullToEmptyString(resultSet.getString(3)));
                    buildingDetails.setSiteL1Ad(StringUtils.nullToEmptyString(resultSet.getString(4)));
                    buildingDetails.setSiteL2Ad(StringUtils.nullToEmptyString(resultSet.getString(5)));
                    buildingDetails.setSiteCityAd(StringUtils.nullToEmptyString(resultSet.getString(6)));
                    buildingDetails.setSiteAbbrStAd(StringUtils.nullToEmptyString(resultSet.getString(7)));
                    buildingDetails.setSitePstlCd(StringUtils.nullToEmptyString(resultSet.getString(8)));
                    buildingDetails.setCtryCd(StringUtils.nullToEmptyString(resultSet.getString(9)));
                    buildingDetails.setSiteOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(10)));
                    buildingDetails.setSiteL3Ad(StringUtils.nullToEmptyString(resultSet.getString(11)));
                    buildingDetails.setSiteL4Ad(StringUtils.nullToEmptyString(resultSet.getString(12)));
                    buildingDetails.setSiteL5Ad(StringUtils.nullToEmptyString(resultSet.getString(13)));
                    buildingDetails.setSitePhneNu(StringUtils.nullToEmptyString(resultSet.getString(14)));
                    buildingDetails.setSiteFaxNu(StringUtils.nullToEmptyString(resultSet.getString(15)));
                    buildingDetails.setSiteCourierCd(StringUtils.nullToEmptyString(resultSet.getString(16)));
                    buildingDetails.setSiteOffcDs(StringUtils.nullToEmptyString(resultSet.getString(17)));
                    buildingDetails.setSiteIntlPstlCd(StringUtils.nullToEmptyString(resultSet.getString(18)));
                    buildingDetails.setSiteId(resultSet.getInt(19));
                    
                    queryResults.add(buildingDetails);
                }
            }

        } catch (SQLException sqle) {
            log.error("[GCD] [BuildingDAO getBuildingNamesByBldgCode] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( " [GCD] [BuildingDAO getBuildingNamesByBldgCode] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [BuildingDAO getBuildingNamesByBldgCode] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [BuildingDAO getBuildingNamesByBldgCode] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }
    
    // SQL Query Strings
    private static String SELECT_ALL_US_BUILDING_NAMES_SQL = "select bldg_cd, bldg_na, site_ds, site_l1_ad, site_l2_ad, site_city_ad, site_abbr_st_ad,  site_pstl_cd, ctry_cd, site_offc_phne  from gcd_v1bldgna  where ctry_cd = 'US'  order by upper(bldg_na)";
    private static String SELECT_ALL_INTL_BUILDING_NAMES_SQL = "select b.bldg_cd, b.bldg_na, b.site_ds, b.site_l1_ad, b.site_l2_ad, b.site_city_ad, b.site_abbr_st_ad,  b.site_pstl_cd, b.ctry_cd, b.site_offc_phne, c.ctry_na, b.site_l3_ad, b.site_l4_ad, b.site_l4_ad,   b.site_phne_nu, b.site_fax_nu, b.site_courier_cd, b.site_offc_ds, b.site_intl_pstl_cd, b.SITE_ID_NU from gcd_v1bldgna b, gcd_v1contry c  where b.ctry_cd <> 'US' and  b.ctry_cd = c.ctry_cd  order by c.ctry_na, b.bldg_na";
    //private static String SELECT_BUILDING_NAME_SQL = "select bldg_cd, bldg_na, site_ds, site_l1_ad, site_l2_ad, site_city_ad,  site_abbr_st_ad, site_pstl_cd, ctry_cd, site_offc_phne  from gcd_v1bldgna  where bldg_cd like ?, site_ds = ?, site_l1_ad = ?, site_l2_ad = ?, site_city_ad = ?,  site_abbr_st_ad = ?, site_pstl_cd = ?, ctry_cd = ?, site_offc_phne = ?  order by site_ds";
    private static String SELECT_BUILDING_NAME_BY_BLDG_CODE_SQL = "select bldg_cd, bldg_na, site_ds, site_l1_ad, site_l2_ad, site_city_ad, site_abbr_st_ad,  site_pstl_cd, ctry_cd, site_offc_phne, site_l3_ad, site_l4_ad, site_l5_ad, site_phne_nu,  site_fax_nu, site_courier_cd, site_offc_ds, site_intl_pstl_cd,site_id_nu  from gcd_v1bldgna  where bldg_cd = ?  order by site_ds";
    private static String INSERT_BUILDING_NAME_SQL = " insert into gcd_v1bldgna  ( bldg_cd, bldg_na, site_ds, site_l1_ad, site_l2_ad, site_city_ad, site_abbr_st_ad, site_pstl_cd, ctry_cd, site_offc_phne ) values( ?,?,?,?,?,?,?,?,?,? )";
    private static String INSERT_INTL_BUILDING_NAME_SQL = " insert into gcd_v1bldgna  ( bldg_cd, bldg_na, site_ds, site_l1_ad, site_l2_ad, site_city_ad, site_abbr_st_ad, site_pstl_cd, ctry_cd, site_offc_phne,    site_l3_ad, site_l4_ad, site_l5_ad, site_phne_nu, site_fax_nu, site_courier_cd, site_offc_ds, site_intl_pstl_cd, site_id_nu ) values( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    private static String UPDATE_US_BUILDING_NAME_SQL = " update gcd_v1bldgna  set bldg_na = ?, site_ds = ?, site_l1_ad = ?, site_l2_ad = ?, site_city_ad = ?,  site_abbr_st_ad = ?, site_pstl_cd = ?, ctry_cd = ?, site_offc_phne = ?  where bldg_cd = ?";
    private static String UPDATE_INTL_BUILDING_NAME_SQL = " update gcd_v1bldgna  set bldg_na = ?, site_ds = ?, site_l1_ad = ?, site_l2_ad = ?, site_city_ad = ?,  site_abbr_st_ad = ?, site_pstl_cd = ?, ctry_cd = ?, site_offc_phne = ?,  site_l3_ad = ?, site_l4_ad = ?, site_l5_ad = ?, site_phne_nu = ?, site_fax_nu = ?,  site_courier_cd = ?, site_offc_ds = ?, site_intl_pstl_cd = ?, site_id_nu= ? where bldg_cd = ?";
    //private static String SELECT_COUNT_BUILDING_NAME_SQL = " select count(*) from gcd_v1bldgna  where bldg_cd = ? ";
    private static String DELETE_BUILDING_NAME_SQL = " delete from gcd_v1bldgna  where bldg_cd = ? ";
    private static String MERGE_US_BUILDING_NAME_SQL= "MERGE INTO gcd_v1bldgna v USING (select ? bldg_cd from dual) r ON (v.bldg_cd = r.bldg_cd)  WHEN MATCHED THEN UPDATE set bldg_na = ?, site_ds = ?,site_l1_ad = ?, site_l2_ad = ?, site_city_ad = ?, site_abbr_st_ad = ?, site_pstl_cd = ?, ctry_cd = ?, site_offc_phne = ? WHEN NOT MATCHED THEN INSERT VALUES (?,?,?,?,?, null, null, null, ?,?,?, null, null, null, null, ?, ?,?, null)";
    private static String MERGE_INTL_BUILDING_NAME_SQL= "MERGE INTO gcd_v1bldgna vi USING (select ? bldg_cd from dual) r ON (vi.bldg_cd = r.bldg_cd) WHEN MATCHED THEN UPDATE set bldg_na = ?, site_ds = ?,site_l1_ad = ?, site_l2_ad = ?, site_city_ad = ?, site_abbr_st_ad = ?, site_pstl_cd = ?,ctry_cd = ?, site_offc_phne = ?, site_l3_ad = ?, site_l4_ad = ?, site_l5_ad = ?, site_phne_nu = ?, site_fax_nu = ?, site_courier_cd = ?, site_offc_ds = ?, site_intl_pstl_cd = ? WHEN NOT MATCHED THEN INSERT VALUES (?,?,?,?,?, ?, ?, ?, ?,?,?, ?, ?, ?, ?, ?, ?,?, ?)";

}