/* 
 * IBuildingDAO.java                                                                                            
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep Jain                                                  
 * Date        :- December 09, 2008                                                     
 * Description :-  this interface is used for delegating requests to actual implementation.
 *
 */
 
 
package com.mcd.accessmcd.gcd.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import com.mcd.accessmcd.gcd.bean.BuildingDetails;
import org.apache.sling.api.scripting.SlingScriptHelper;

/*************************************************************************

 * This is an interface for delegating requests to actual implementation. 
 * @version 1.0 &nbsp; November 13, 2008
 * @author : Sandeep jain 
 *
 *************************************************************************/


public interface IBuildingDAO 
{
    public ArrayList getUSBuildings(SlingScriptHelper sling) throws SQLException, Exception; 

    public ArrayList getIntlBuildings(SlingScriptHelper sling) throws SQLException, Exception;
    
    public int updateUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception; 
    
    public int mergeUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception;
    
    public int updateIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception; 
    
    public int mergeIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception;

    public int addUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception; 
    
    public int addIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling)throws SQLException, Exception; 
    
    public int deleteBuilding(int bldgCd,SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList getBuildingNamesByBldgCode(int bldgCd,SlingScriptHelper sling)throws SQLException, Exception;
}