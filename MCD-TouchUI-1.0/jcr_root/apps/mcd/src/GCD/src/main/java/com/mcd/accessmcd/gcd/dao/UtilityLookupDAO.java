/* 
 * UtilityLookupDAO.java                                                                                            
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
import com.mcd.accessmcd.gcd.bean.RegionNameResult;
import com.mcd.accessmcd.gcd.bean.BuildingDetails;
import com.mcd.accessmcd.gcd.bean.DepartmentNameResult;


/*************************************************************************
 * This class interacts with the DBTool class to get the connection from the
 * database and holds different SQL queries on the basis of selected method. 
 *
 * @version 1.0 &nbsp; December 09, 2008
 * @author : Sandeep Jain
 *
 *************************************************************************/


public class UtilityLookupDAO implements IUtilityLookupDAO

{
    /**
     * default logger
     */
    private static final Logger log = LoggerFactory.getLogger(UtilityLookupDAO.class);
    
    public ArrayList<String> getAllCompanyNames(SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_COMPANY_NAMES_SQL);
                resultSet = pstmt.executeQuery(); 
                String companyName=null;
                while(resultSet.next())
                {
                    companyName=StringUtils.nullToEmptyString(resultSet.getString(1));
                    queryResults.add(companyName);
                }
            }
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO getAllCompanyNames] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO getAllCompanyNames] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO getAllCompanyNames] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO getAllCompanyNames] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }
    
    public ArrayList<String> getAllDepartmentNamesByNumber(SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_DEPARTMENT_NAMES_BY_NUMBER);
                resultSet = pstmt.executeQuery(); 
                DepartmentNameResult departmentNameResult;
                while(resultSet.next())
                {
                    departmentNameResult = new DepartmentNameResult();
                    departmentNameResult.setDeptNu(resultSet.getString(1));
                    departmentNameResult.setDeptNa(StringUtils.nullToEmptyString(resultSet.getString(2)));
                    queryResults.add(departmentNameResult);
                }
                
            }                
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO getAllDepartmentNamesByNumber] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO getAllDepartmentNamesByNumber] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO getAllDepartmentNamesByNumber] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO getAllDepartmentNamesByNumber] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }
    
    public ArrayList<String> getAllDepartmentNumbers(SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults= new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_DEPARTMENT_NUMBEresultSet_SQL);
                resultSet = pstmt.executeQuery(); 
                DepartmentNameResult departmentNumberResult;
                while(resultSet.next())
                {
                    departmentNumberResult = new DepartmentNameResult();
                    departmentNumberResult.setDeptNu(resultSet.getString(1));
                    departmentNumberResult.setDeptNa(StringUtils.nullToEmptyString(resultSet.getString(2)));
                    queryResults.add(departmentNumberResult);
                }
            }
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO getAllDepartmentNumbers] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO getAllDepartmentNumbers] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO getAllDepartmentNumbers] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO getAllDepartmentNumbers] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }

    public ArrayList<String> getAllSiteIdCodes(SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults= new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_SITE_ID_NUMBEresultSet_SQL);
                resultSet = pstmt.executeQuery(); 
                int siteIdNumberResult=0;
                while(resultSet.next())
                {
                    siteIdNumberResult = resultSet.getInt(1);
                    queryResults.add(new Integer(siteIdNumberResult));
                }    
            }               
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }

    public ArrayList<String> getAllLocations(SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults= new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_BUILDING_NAMES_SQL);          
                resultSet = pstmt.executeQuery(); 
                while(resultSet.next())
                {
                    queryResults.add(resultSet.getString(2));
                }
            }       
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO getAllLocations] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO getAllLocations] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO getAllLocations] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO getAllLocations] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }

   public ArrayList<String> getAllBuildingCodes(SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults= new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_BUILDING_NAMES_SQL);
                resultSet = pstmt.executeQuery(); 
                BuildingDetails buildingDetails;
                while(resultSet.next())
                {
                    buildingDetails = new BuildingDetails();
                    buildingDetails.setBldgCd(resultSet.getInt(1));
                    buildingDetails.setBldgNa(resultSet.getString(2));
                    queryResults.add(buildingDetails);
                } 
            }           
          } catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO getAllBuildingCodes] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO getAllBuildingCodes] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO getAllBuildingCodes] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO getAllBuildingCodes] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;

    }
    
    public ArrayList<String> getAllStateCodes(SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults= new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_STATE_CODES_SQL);
                resultSet = pstmt.executeQuery(); 
                String stateCodeResult=null;
                while(resultSet.next())
                {
                    stateCodeResult = resultSet.getString(1);
                    queryResults.add(stateCodeResult);
                }
            }
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }

    public ArrayList<String> getAllJobTitles(SlingScriptHelper sling) throws SQLException, Exception 
    {
        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            { 
                    pstmt = conn.prepareStatement(LOOKUP_JOB_TITLES_SQL);
                    resultSet = pstmt.executeQuery();
                    String jobTitleResult;
                    while(resultSet.next())
                    {
                         jobTitleResult = resultSet.getString(1);   
                         queryResults.add(jobTitleResult);
                    }
            }               
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO getAllJobTitles] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO getAllJobTitles] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO getAllJobTitles] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO getAllJobTitles] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }

    public ArrayList<String> getAllRegionNames(SlingScriptHelper sling) throws SQLException, Exception 
    {
        ArrayList queryResults= new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_REGION_NAMES_SQL);
                resultSet = pstmt.executeQuery(); 
                RegionNameResult regionNameResult;
                while(resultSet.next())
                {
                    regionNameResult = new RegionNameResult();
                    regionNameResult.setRegCd(StringUtils.nullToEmptyString(resultSet.getString(1)));
                    regionNameResult.setRegNa(StringUtils.nullToEmptyString(resultSet.getString(2)));
                    regionNameResult.setZoneCd(StringUtils.nullToEmptyString(resultSet.getString(3)));
                    regionNameResult.setZoneNa(StringUtils.nullToEmptyString(resultSet.getString(4)));
                    
                    queryResults.add(regionNameResult);
                }
            }       
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO getAllRegionNames] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO getAllRegionNames] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO getAllRegionNames] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }

    public ArrayList<String> getAllRegionCodes(SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults= new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_REGION_CODES_SQL);
                resultSet = pstmt.executeQuery(); 
                RegionNameResult regionNameResult;
                while(resultSet.next())
                {
                    regionNameResult = new RegionNameResult();
                    regionNameResult.setRegCd(StringUtils.nullToEmptyString(resultSet.getString(1)));
                    regionNameResult.setRegNa(StringUtils.nullToEmptyString(resultSet.getString(2)));
                    
                    queryResults.add(regionNameResult);
                }
            }       
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO getAllRegionCodes] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO getAllRegionCodes] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO getAllRegionCodes] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO getAllRegionCodes] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }
    
    public ArrayList<String> getAllPrefMailCodes(SlingScriptHelper sling) throws SQLException, Exception 
    {
        ArrayList queryResults= new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_PREF_MAIL_CODE_SQL);
                resultSet = pstmt.executeQuery();
                String prefMailCodeResult=null;
                while(resultSet.next())
                {
                    prefMailCodeResult = StringUtils.nullToEmptyString(resultSet.getString(1));
                    queryResults.add(prefMailCodeResult);
                }
                    
             }      
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
        log.error(" [GCD] [UtilityLookupDAO] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }

    public ArrayList<String> getAllMailCodes(SlingScriptHelper sling) throws SQLException, Exception 
    {
        ArrayList queryResults= new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
         
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_MAIL_CODE_SQL);
                resultSet = pstmt.executeQuery(); 
                String mailCodeResult=null;
                while(resultSet.next())
                {
                    mailCodeResult = StringUtils.nullToEmptyString(resultSet.getString(1));
                    queryResults.add(mailCodeResult);
                }
                    
            }
       }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
       }
       catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO] Error while fetching data from database " + e.getMessage());
       }
       finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
       }
        return queryResults;
    }

    public ArrayList<String> getAllVmBoxNu(SlingScriptHelper sling) throws SQLException, Exception 
    {
        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(LOOKUP_VM_NODE_NU_SQL);
                resultSet = pstmt.executeQuery();
                String vmNodeNuResult=null;
                while(resultSet.next())
                {
                    vmNodeNuResult = StringUtils.nullToEmptyString(resultSet.getString(1));
                    queryResults.add(vmNodeNuResult);
                }
           }
        }catch (SQLException sqle) {
            log.error("[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UtilityLookupDAO] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UtilityLookupDAO] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UtilityLookupDAO] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }
    
    private static String LOOKUP_COMPANY_NAMES_SQL = "select distinct trim(co_na)  from gcd_v1userhdr where ctry_cd = 'US' and co_na is not null  order by trim(co_na) ";
    private static String LOOKUP_SITE_ID_NUMBEresultSet_SQL = "select distinct site_id_nu  from gcd_v1userhdr  where site_id_nu is not null and site_id_nu != 0  order by site_id_nu ";
    private static String LOOKUP_STATE_CODES_SQL = "select distinct site_abbr_st_ad  from gcd_v1bldgna  where site_abbr_st_ad is not null  union  select distinct oper_st_prov_ad as \"site_abbr_st_ad\"  from gcd.v1userdtl  where oper_st_prov_ad is not null  order by 1 ";
    private static String LOOKUP_JOB_TITLES_SQL = "select distinct job_titl_ds  from gcd_v1userhdr  where job_titl_ds is not null and disable_fl = 0 and ctry_cd='US' order by job_titl_ds ";
    private static String LOOKUP_REGION_CODES_SQL = "select distinct reg_cd, reg_na, zone_cd, zone_na  from gcd_v1userhdr  where reg_cd is not null and zone_cd is not null  order by reg_cd ";    
    private static String LOOKUP_REGION_NAMES_SQL = "select distinct reg_cd, reg_na, zone_na, zone_cd  from gcd_v1userhdr  where reg_cd is not null  order by reg_na ";
    private static String LOOKUP_PREF_MAIL_CODE_SQL = "select distinct prfd_mail_cd   from gcd_v1userdtl  where prfd_mail_cd is not null and ctry_cd = 'US' order by prfd_mail_cd ";
    private static String LOOKUP_MAIL_CODE_SQL = "select distinct prfd_mail_cd   from gcd_v1userdtl  where prfd_mail_cd is not null order by prfd_mail_cd ";
    private static String LOOKUP_VM_NODE_NU_SQL = "select distinct vm_node_nu   from gcd_v1userdtl  where vm_node_nu is not null and ctry_cd='US' order by vm_node_nu ";
    private static String LOOKUP_DEPARTMENT_NAMES_BY_NUMBER = "select distinct dept_nu, dept_na  from gcd_v1userhdr  where dept_na is not null and ctry_cd = 'US' order by dept_nu ";    
    private static String LOOKUP_DEPARTMENT_NUMBEresultSet_SQL = "select distinct dept_nu, dept_na  from gcd_v1userhdr  where dept_na is not null and dept_nu is not null and ctry_cd = 'US' order by dept_na ";
    private static String LOOKUP_BUILDING_NAMES_SQL = "select distinct bldg_cd, bldg_na from gcd_v1bldgna where ctry_cd = 'US' order by bldg_na ";
    //private static String LOOKUP_LOCATION_NAMES_SQL = "select distinct bldg_cd, bldg_na,site_id_nu from gcd_v1bldgna where ctry_cd = 'US' order by bldg_na ";
} 