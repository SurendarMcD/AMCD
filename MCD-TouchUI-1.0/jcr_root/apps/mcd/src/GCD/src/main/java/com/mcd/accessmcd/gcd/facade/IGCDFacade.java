/* 
 * IGCDFacade.java                                                                                      
 * Developed by HCL Technologies.                                                       
 * Author      :- Mansi                                                      
 * Date        :- December 22, 2011                                                     
 * Description :-  A generic façade interface for delegating requests to actual implementation. 
 * 
 */

package com.mcd.accessmcd.gcd.facade;

import java.util.ArrayList;
import org.apache.sling.api.scripting.SlingScriptHelper;
import com.mcd.accessmcd.gcd.bean.*;

/*************************************************************************

 * This is an interface for delegating requests to actual implementation. 
 * @version 1.0 &nbsp; December 22, 2011
 * @author : Mansi 
 *
 *************************************************************************/

public interface IGCDFacade 
{
    /** This method will provide the list of active countries.
     */
    public ArrayList<String> getActiveCountries(SlingScriptHelper sling) throws Exception;
      
    public int updateCountriesStatus(ArrayList<CountryDetails> countryList,String eid,SlingScriptHelper sling) throws Exception;
    
    public int updateCountriesFlag(SlingScriptHelper sling)throws Exception;
    
    public ArrayList<String> getCountries(SlingScriptHelper sling) throws Exception ;

    // Methods Related to US and International Building
    public ArrayList<String> getUSBuildings(SlingScriptHelper sling) throws Exception; 
    
    public ArrayList<String> getIntlBuildings(SlingScriptHelper sling) throws Exception;
    
    public int maintainUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception; 
    
    public int maintainIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception;
    
    public int deleteBuilding(int bldgCd,SlingScriptHelper sling)throws Exception;
        
    public ArrayList<String> getBuildingNamesByBldgCode(int bldgCd,SlingScriptHelper sling)throws Exception; 
    
    // Methods Related to Search
    public ArrayList<String> getSearchResult(BasicSearch basicSearch,SlingScriptHelper sling)throws Exception;   
             
    public ArrayList<String> getSearchResult(AdvancedSearch advancedSearch,SlingScriptHelper sling) throws Exception;
    
    public ArrayList<String> selectProfileByEid(String eid,SlingScriptHelper sling) throws Exception; 
    
    public ArrayList<String> selectOwnerOperatorProfile(String ownerOperatorId,SlingScriptHelper sling)throws Exception;      
                    
    public AdvanceSearchParameter getAdvanceSearchParameters(SlingScriptHelper sling) throws Exception;
}

