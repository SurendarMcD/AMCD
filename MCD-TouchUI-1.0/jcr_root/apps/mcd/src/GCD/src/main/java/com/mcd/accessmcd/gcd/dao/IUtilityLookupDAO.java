/* 
 * IUtilityLookupDAO.java                                                                                           
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep Jain                                                  
 * Date        :- December 09, 2008                                                     
 * Description :-  this interface is used for delegating requests to actual implementation.
 *
 */

package com.mcd.accessmcd.gcd.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.sling.api.scripting.SlingScriptHelper; 


/*************************************************************************

 * This is an interface for delegating requests to actual implementation. 
 * @version 1.0 &nbsp; November 13, 2008
 * @author : Sandeep jain 
 *
 *************************************************************************/

public interface IUtilityLookupDAO
{
    public ArrayList<String> getAllCompanyNames(SlingScriptHelper sling)throws SQLException, Exception; 
        
    public ArrayList<String> getAllDepartmentNamesByNumber(SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList<String> getAllDepartmentNumbers(SlingScriptHelper sling)throws SQLException, Exception;
    
    public ArrayList<String> getAllSiteIdCodes(SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList<String> getAllLocations(SlingScriptHelper sling)throws SQLException, Exception; 
        
    public ArrayList<String> getAllBuildingCodes(SlingScriptHelper sling)throws SQLException, Exception; 
        
    public ArrayList<String> getAllStateCodes(SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList<String> getAllJobTitles(SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList<String> getAllRegionNames(SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList<String> getAllRegionCodes(SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList<String> getAllPrefMailCodes(SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList<String> getAllMailCodes(SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList<String> getAllVmBoxNu(SlingScriptHelper sling)throws SQLException, Exception;     
}