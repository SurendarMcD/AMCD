/* 
 * GCDFacadeImpl.java                                                                                       
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep jain                                                  
 * Date        :- December 15, 2008                                                     
 * Description :- This class Implements the IGCDFacade interface. 
 * 
 */
package com.mcd.accessmcd.gcd.facade;

import java.util.ArrayList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.api.scripting.SlingScriptHelper;
import com.mcd.accessmcd.gcd.bean.*;
import com.mcd.accessmcd.gcd.manager.GCDManager;



/***********************************************************************
 * 
 * This class Implements the IGCDFacade interface.
 * 
 * @version 1.0 &nbsp; November 13, 2008
 * @author : Sandeep Jain
 * 
 ************************************************************************/
 
 
public class GCDFacadeImpl implements IGCDFacade {

    GCDManager gcdManager = null;

    private static final Logger log = LoggerFactory.getLogger(GCDFacadeImpl.class);
    
    /**
     * This method pulls the countries.
     * 
     * 
     * @return ArrayList object
     * @throws Exception
     */

    public ArrayList<String> getCountries(SlingScriptHelper sling) throws Exception
    {
        return GCDManager.getInstance().getCountries(sling);
    }

    
    /**
     * This method returns the country Name.
     * @param String country Code
     * @return String
     * @throws Exception
     */
     
    public String getCountryNameByCode(String countryCode,SlingScriptHelper sling) throws Exception {
    
        return GCDManager.getInstance().getCountryNameByCode(countryCode,sling);
    }
    
    
    /**
     * This method returns the active country list.
     * 
     * @return ArrayList object
     * @throws Exception
     */

    public ArrayList<String> getActiveCountries(SlingScriptHelper sling) throws Exception
    {
        
        return GCDManager.getInstance().getActiveCountries(sling);
        
    }
    
    
    
    /**
     * This method updates the status of countries.
     * 
     * @return int value
     * @throws Exception
     */
    
    public int updateCountriesStatus(ArrayList<CountryDetails> countryList,String eid,SlingScriptHelper sling) throws Exception
    {
        return GCDManager.getInstance().updateCountriesStatus(countryList,eid,sling); 
    }
        
    
    /**
     * This method updates the Flag of countries.
     * 
     * @return int value
     * @throws Exception
     */
    
    public int updateCountriesFlag(SlingScriptHelper sling)throws Exception
    {
        return GCDManager.getInstance().updateCountriesFlag(sling);  
    }
    

    
    
    /**
     * This method returns the HashMap of US Buildings
     * 
     * @return ArrayList object
     * @throws Exception
     */
     
    public ArrayList<String> getUSBuildings(SlingScriptHelper sling) throws Exception 
    {
        return GCDManager.getInstance().getUSBuildings(sling);
    }
    
    
    
    /**
     * This method returns the HashMap of International Buildings
     * 
     * @return ArrayList object
     * @throws Exception
     */
    
    public ArrayList<String> getIntlBuildings(SlingScriptHelper sling) throws Exception 
    {
        return GCDManager.getInstance().getIntlBuildings(sling);     
        
    }

        
    
    /**
     * This method adds or modify the US building information
     * 
     * @return int value
     * @throws Exception
     */
     
    public int maintainUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception
    {
        return GCDManager.getInstance().maintainUSBuilding(buildingDetails,sling);
    }
    
    
    
    
    /**
     * This method adds or modify the International building information
     * 
     * @return int value
     * @throws Exception
     */
     
    public int maintainIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception
    {
        return GCDManager.getInstance().maintainIntlBuilding(buildingDetails,sling);
    }


    
    
    /**
     * This method deletes the building information
     * 
     * @return int value
     * @throws Exception
     */
    
    public int deleteBuilding(int bldgCd,SlingScriptHelper sling)throws Exception

    {
        return GCDManager.getInstance().deleteBuilding(bldgCd,sling);
    }
    
    
    /**
     * This method gets the building information
     * 
     * @return ArrayList
     * @throws Exception
     */
    public ArrayList<String> getBuildingNamesByBldgCode(int bldgCd,SlingScriptHelper sling)throws Exception 
    {
        
        return GCDManager.getInstance().getBuildingNamesByBldgCode(bldgCd,sling);
        
    }
    
    /**
     * This method returns the profile of a single user
     * 
     * @return ViewProfile object
     * @throws Exception
     */
     
    public ArrayList<String> selectProfileByEid(String eid,SlingScriptHelper sling) throws Exception 
    {
      
      return GCDManager.getInstance().selectProfileByEid(eid,sling);
          
    }
    
    /**
     * This method returns the profile of a single owner operator user
     * 
     * @return ViewProfile object
     * @throws Exception
     */
     
    public ArrayList<String> selectOwnerOperatorProfile(String ownerOperatorId,SlingScriptHelper sling) throws Exception 
    {
      
      return GCDManager.getInstance().selectOwnerOperatorProfile(ownerOperatorId,sling);
          
    }  
      


    /**
     * This method returns the SearchResult array
     * 
     * @return Array of SearchResult
     * @throws Exception
     */
     
    public ArrayList<String> getSearchResult(BasicSearch basicSearch,SlingScriptHelper sling)throws Exception 
    
    {
        return GCDManager.getInstance().getSearchResult(basicSearch,sling);
     
    }    
    
    /**
     * This method returns the SearchResult array
     * 
     * @return Array of SearchResult
     * @throws Exception
     */
     
    public ArrayList<String> getSearchResult(AdvancedSearch advancedSearch,SlingScriptHelper sling)throws Exception 
    
    {
     return GCDManager.getInstance().getSearchResult(advancedSearch,sling);
     
    }
    
    
    /**
     * This method returns the parameters for advanced search
     * 
     * @return Array of SearchResult
     * @throws Exception
     */
 
    public AdvanceSearchParameter getAdvanceSearchParameters(SlingScriptHelper sling) throws Exception
    { 
     
     return GCDManager.getInstance().getAdvanceSearchParameters(sling);
        
    }

}
