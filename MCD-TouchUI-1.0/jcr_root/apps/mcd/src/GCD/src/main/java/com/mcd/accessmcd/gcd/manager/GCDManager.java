/* 
 * GCDManager.java                                                      
 * Developed by HCL Technologies.                                                       
 * Author      :- HCL                                                  
 * Description :-  This class is a singleton class which interacts
 * with DAO layer to fetch desired results.
 */
package com.mcd.accessmcd.gcd.manager;
 
import java.util.ArrayList;
import java.util.Iterator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory; 
import com.mcd.accessmcd.gcd.bean.CountryDetails;
import com.mcd.accessmcd.gcd.dao.CountryDAO;
import com.mcd.accessmcd.gcd.constants.GCDConstants;
import com.mcd.accessmcd.gcd.util.CacheUtil;
import com.opensymphony.oscache.general.GeneralCacheAdministrator;
import org.apache.sling.api.scripting.SlingScriptHelper;
import java.util.HashMap;
import com.mcd.accessmcd.gcd.bean.*;
import com.mcd.accessmcd.gcd.dao.*;
 
/***********************************************************************
 * 
 * This class is a singleton class which interacts
 * with DAO layer to fetch desired details.
 *
 * @version 1.0 &nbsp; November 13, 2008
 * @author : Sandeep Jain
 *
 ************************************************************************/ 
 
public class GCDManager  
{
    /**
     * default logger
     */
    private static final Logger log = LoggerFactory.getLogger(GCDManager.class);
    
    private static GeneralCacheAdministrator admin = null;
    private static GCDManager gcdManager=null;
    private static boolean cacheFlag=true;
    private static String cacheProperty="";
    
    //private constructor
    private GCDManager(){
    }
 
    //get the Instance of GCDManager 
    public static GCDManager getInstance()
    {        
        try
        {
            cacheProperty = GCDConstants.GCD_CACHE_FLAG;       
            if("false".equals(cacheProperty)){
                cacheFlag=false;
            }
            if (gcdManager == null){
                gcdManager = new GCDManager();
            }
             log.error("******************************************************************");   
         }catch(Exception ex)
         {
          log.error("Cannot Create GCD Manager Instance !!!");
         }
            
        return gcdManager;
    }
    
     
    /**
     * This method pulls the countries.
     * 
     * 
     * @return ArrayList object
     * @throws Exception
     */ 
    public ArrayList<String> getCountries(SlingScriptHelper sling) throws Exception {
        ArrayList<String> getSearchResult = null;
        try{
            admin = CacheUtil.getInstance();
            //Check for data in cache 
            int interval = Integer.parseInt(GCDConstants.GCD_OSCACHE_INTERVAL);
            getSearchResult = (ArrayList<String>) admin.getFromCache(GCDConstants.COUNTRY_CACHE_KEY,interval);
        } 
        catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            
            //Data is not available in cache so get it from thr DAO layer
            CountryDAO countryDAO = new CountryDAO();
            getSearchResult = countryDAO.getCountries(sling);
            
            //Putting data again in cache
            if(cacheFlag){
                admin.putInCache(GCDConstants.COUNTRY_CACHE_KEY, getSearchResult);
            }
        }
        catch (Exception e) {
            log.error(" [GCD] [GCDManager] [getCountries()] Error while Fatching data  " + e.getMessage());
            throw new Exception(" [GCD] [GCDManager] [getCountries()] Error while Fatching data " + e.getMessage());
        }
        return getSearchResult;
    }
    
    /**
     * This method pulls the countries by code.
     * 
     * 
     * @return ArrayList object
     * @throws Exception
     */ 
    public String getCountryNameByCode(String countryCode,SlingScriptHelper sling) throws Exception {
        ArrayList<String> getSearchResult = null;
        HashMap countryNames = null;
        String countryName = null;
        CountryDetails countryDetails = null;
        try {
            admin = CacheUtil.getInstance();
            //Check for data in cache 
            int interval = Integer.parseInt(GCDConstants.GCD_OSCACHE_INTERVAL);
            countryNames = (HashMap) admin.getFromCache(GCDConstants.COUNTRY_NAMES_CACHE_KEY,interval);
            countryName = (String)countryNames.get(countryCode);
        } 
        catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            
            ICountryDAO countryDAO = new CountryDAO();
            countryNames = new HashMap();
            getSearchResult = countryDAO.getCountries(sling);
            Iterator itr = getSearchResult.iterator();
            while(itr.hasNext()){
                countryDetails = (CountryDetails)itr.next();
                countryNames.put(countryDetails.getCtryCd(), countryDetails.getCtryNm());
            }
            
            //Putting data again in cache
            if(cacheFlag){
                admin.putInCache(GCDConstants.COUNTRY_NAMES_CACHE_KEY, countryNames);
            }    
            
            countryName = (String)countryNames.get(countryCode);
        }
        catch (Exception e) {
            log.error(" [GCD] [GCDManager getCountryNameByCode] Error while pushing data  " + e.getMessage());
            throw new Exception(" [GCD] [GCDManager getCountryNameByCode] Error while pushing data " + e.getMessage());
        }
        return countryName;
    }   
    
    
    /**
     * This method returns the active country list.
     * 
     * @return ArrayList object
     * @throws Exception
     */
    public ArrayList<String> getActiveCountries(SlingScriptHelper sling) throws Exception {        
        ArrayList<String> getSearchResult = null;
        CountryDetails countryDetails=null;
        try {
            admin = CacheUtil.getInstance();
            //Check for data in cache 
            int interval = Integer.parseInt(GCDConstants.GCD_OSCACHE_INTERVAL);
            getSearchResult = (ArrayList<String>) admin.getFromCache(GCDConstants.ACTIVE_COUNTRY_CACHE_KEY,interval);
        } 
        catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            
            //Data is not available in cache so get it from thr DAO layer
            CountryDAO countryDAO = new CountryDAO();
            getSearchResult = countryDAO.getCountries(sling);
            Iterator itr = getSearchResult.iterator();
            
            //Check for only Active countries
            while (itr.hasNext()) {
                countryDetails = (CountryDetails) itr.next();
                if ((GCDConstants.INACTIVE_COUNTRY_FLAG).equals(countryDetails.getActiveFl())) {
                    itr.remove();
                }
            }
             
            //Putting data again in cache
            if(cacheFlag){
                admin.putInCache(GCDConstants.ACTIVE_COUNTRY_CACHE_KEY, getSearchResult);
            }
        }
        catch (Exception e) {
            log.error(" [GCD] [GCDManager] [getActiveCountries()] Error while Fatching data  " + e.getMessage());
            throw new Exception(" [GCD] [GCDManager] [getActiveCountries()] Error while Fatching data " + e.getMessage());
        }
        return getSearchResult;
    }
    

    /**
     * This method updates the status of countries.
     * 
     * @return int value
     * @throws Exception
     */
    public int updateCountriesStatus(ArrayList<CountryDetails> countryList,String eid,SlingScriptHelper sling)throws Exception{
        int retVal = 0;
        CountryDAO countryDAO = new CountryDAO();
        retVal = countryDAO.updateCountriesStatus(countryList,eid,sling);
        
        if(retVal !=0){
            CacheUtil.getInstance().flushEntry(GCDConstants.COUNTRY_CACHE_KEY);
            CacheUtil.getInstance().flushEntry(GCDConstants.ACTIVE_COUNTRY_CACHE_KEY);
        }
        return retVal;
    }   
      
    /**
     * This method updates the status of countries.
     * 
     * @return int value
     * @throws Exception
     */
    public int updateCountriesFlag(SlingScriptHelper sling)throws Exception{
        int retVal = 0;
        CountryDAO countryDAO=new CountryDAO();
        retVal=countryDAO.updateCountriesFlag(sling);
        
        if(retVal !=0){
            CacheUtil.getInstance().flushEntry(GCDConstants.COUNTRY_CACHE_KEY);
            CacheUtil.getInstance().flushEntry(GCDConstants.ACTIVE_COUNTRY_CACHE_KEY);
        }
        return retVal;
    } 
          
    /**
     * This method returns the US building information.
     * 
     * @return ArrayList object
     * @throws Exception
     */  
    public ArrayList<String> getUSBuildings(SlingScriptHelper sling) throws Exception 
    {       
        ArrayList<String> getSearchResult = null;
        try{
            admin = CacheUtil.getInstance();
            int interval = Integer.parseInt(GCDConstants.GCD_OSCACHE_INTERVAL);
            getSearchResult = (ArrayList<String>)admin.getFromCache(GCDConstants.US_BUILDING_CACHE_KEY,interval);
        }
        catch(com.opensymphony.oscache.base.NeedsRefreshException nre){
            
            IBuildingDAO buildingDAO = new BuildingDAO();
            getSearchResult = buildingDAO.getUSBuildings(sling);
            
            //Putting data again in cache
            if(cacheFlag){
                admin.putInCache(GCDConstants.US_BUILDING_CACHE_KEY, getSearchResult);
            }    
        }
        catch(Exception e){
            log.error(" [GCD] [GCDManager getUSBuildings] [v] Error while pushing data  "+e.getMessage());
            throw new Exception(" [GCD] [GCDManager] [getUSBuildings()] Error while pushing data "+e.getMessage());
        }
        return getSearchResult;
    }
    
    /**
     * This method returns the INTL building information.
     * 
     * @return ArrayList object
     * @throws Exception
     */
    public ArrayList<String> getIntlBuildings(SlingScriptHelper sling) throws Exception 
    {
        ArrayList<String> getSearchResult = null;
        try{
            admin = CacheUtil.getInstance();          
            int interval = Integer.parseInt(GCDConstants.GCD_OSCACHE_INTERVAL);
            getSearchResult = (ArrayList<String>)admin.getFromCache(GCDConstants.INTL_BUILDING_CACHE_KEY,interval);
        }
        catch(com.opensymphony.oscache.base.NeedsRefreshException nre){
            
            IBuildingDAO buildingDAO = new BuildingDAO();
            getSearchResult = buildingDAO.getIntlBuildings(sling);
            
            //Putting data again in cache
            if(cacheFlag){
                admin.putInCache(GCDConstants.INTL_BUILDING_CACHE_KEY, getSearchResult);
            }    
        }
        catch(Exception e){
            log.error(" [GCD] [GCDManager] [getIntlBuildings()] Error while fetching data  "+e.getMessage());
            throw new Exception(" [GCD] [GCDManager] [getIntlBuildings()] Error while fetching intl data "+e.getMessage());
        }
        return getSearchResult;  
    }
    
    /**
     * This method adds or modify the US building information
     * 
     * @return int value
     * @throws Exception
     */
    public int maintainUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception 
    {
        int retVal = 0;
        ArrayList<String> alBuildingResult = new ArrayList<String>();
        BuildingDAO buildingDAO = new BuildingDAO();
        alBuildingResult = buildingDAO.getBuildingNamesByBldgCode(buildingDetails.getBldgCd(),sling);
        if(alBuildingResult.size()>=1){
            retVal = updateUSBuilding(buildingDetails,sling);
        }
        else{
            retVal = addUSBuilding(buildingDetails,sling);
        }
                
        if(retVal != 0){
            CacheUtil.getInstance().flushEntry(GCDConstants.US_BUILDING_CACHE_KEY);
        }
        return retVal;
    }
    
    /**
     * This method adds or modify the US building information
     * 
     * @return int value
     * @throws Exception
     */
    public int mergeUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception 
    {
        int retVal = 0;
        BuildingDAO buildingDAO = new BuildingDAO();
        retVal = buildingDAO.mergeUSBuilding(buildingDetails,sling);
        return retVal;
    }
    
    /**
     * This method adds or modify the International building information
     * 
     * @return int value
     * @throws Exception
     */
    public int maintainIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception 
    {
        int retVal = 0;
        ArrayList<String> getSearchResult = new ArrayList<String>();
        BuildingDAO buildingDAO = new BuildingDAO();
        getSearchResult = buildingDAO.getBuildingNamesByBldgCode(buildingDetails.getBldgCd(),sling);
        if(getSearchResult.size()>=1){
            retVal=updateIntlBuilding(buildingDetails,sling);
        }
        else{
            retVal=addIntlBuilding(buildingDetails,sling);
        }

        CacheUtil.getInstance().flushEntry(GCDConstants.INTL_BUILDING_CACHE_KEY);
        return retVal;
    }
    
    /**
     * This method adds or modify the Intl building information
     * 
     * @return int value
     * @throws Exception
     */
    public int mergeIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception 
    {
        int retVal = 0;
        BuildingDAO buildingDAO = new BuildingDAO();
        retVal = buildingDAO.mergeIntlBuilding(buildingDetails,sling);
        return retVal;
    }
    
    /**
     * This method modify the US building information
     * 
     * @return int value
     * @throws Exception
     */
    private int updateUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception 
    {
        int retVal = 0;
        BuildingDAO buildingDAO = new BuildingDAO();
        retVal = buildingDAO.updateUSBuilding(buildingDetails,sling);
        return retVal;
    }
    
    /**
     * This method modify the International building information
     * 
     * @return int value
     * @throws Exception
     */
    private int updateIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception 
    {
        int retVal = 0;
        BuildingDAO buildingDAO = new BuildingDAO();
        retVal = buildingDAO.updateIntlBuilding(buildingDetails,sling);
        return retVal;
    }
    
    /**
     * This method Add the US building information
     * 
     * @return int value
     * @throws Exception
     */
    private int addUSBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception 
    {
        int retVal = 0;
        BuildingDAO buildingDAO = new BuildingDAO();
        retVal = buildingDAO.addUSBuilding(buildingDetails,sling);
        return retVal;
    }
    
    /**
     * This method Add the International building information
     * 
     * @return int value
     * @throws Exception
     */
    private int addIntlBuilding(BuildingDetails buildingDetails,SlingScriptHelper sling) throws Exception 
    {
        int retVal = 0;
        BuildingDAO buildingDAO = new BuildingDAO();
        retVal = buildingDAO.addIntlBuilding(buildingDetails,sling);
        return retVal;
    }

    /**
     * This method deletes the building information
     * 
     * @return int value
     * @throws Exception
     */
    public int deleteBuilding(int bldgCd,SlingScriptHelper sling)throws Exception
    {
        int retVal = 0;
        IBuildingDAO buildingDAO = new BuildingDAO();
        retVal = buildingDAO.deleteBuilding(bldgCd,sling);
        
        if(retVal!=0){
            CacheUtil.getInstance().flushEntry(GCDConstants.US_BUILDING_CACHE_KEY);
            CacheUtil.getInstance().flushEntry(GCDConstants.INTL_BUILDING_CACHE_KEY);
        }
        return retVal;
    }

    public ArrayList<String> getBuildingNamesByBldgCode(int bldgCd,SlingScriptHelper sling)throws Exception 
    {
        return new BuildingDAO().getBuildingNamesByBldgCode(bldgCd,sling);
    }
    
    /**
     * This method returns the SearchResult array
     * @param BasicSearch basicSearch
     * @return Array of SearchResult
     * @throws Exception
     */
    public ArrayList<String> getSearchResult(BasicSearch basicSearch,SlingScriptHelper sling) throws Exception
    {
        ArrayList<String> getSearchResult = null;
        UserProfileDAO UserProfileDAO = new UserProfileDAO();
        getSearchResult = UserProfileDAO.getSearchResult(basicSearch,sling);        
        return getSearchResult;
    }
    
    
    /**
     * This method returns the SearchResult array
     * @param AdvancedSearch advancedSearch
     * @return Array of SearchResult
     * @throws Exception
     */
    public ArrayList<String> getSearchResult(AdvancedSearch advancedSearch,SlingScriptHelper sling) throws Exception 
    {
        ArrayList<String> getSearchResult = null;
        UserProfileDAO UserProfileDAO = new UserProfileDAO();
        getSearchResult = UserProfileDAO.getSearchResult(advancedSearch,sling);             
        return getSearchResult;
    }
    
    /**
     * This method returns the profile of a single user
     * @param String eid
     * @return ViewProfile object
     * @throws Exception
     */
    public ArrayList<String> selectProfileByEid(String eid,SlingScriptHelper sling) throws Exception 
    {
        ArrayList<String> getSearchResult=null;
        try {
            admin = CacheUtil.getInstance();
            int interval = Integer.parseInt(GCDConstants.GCD_OSCACHE_INTERVAL);
            getSearchResult = (ArrayList<String>) admin.getFromCache(eid,interval);
        } 
        catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            
            UserProfileDAO userProfileDAO = new UserProfileDAO();    
            getSearchResult = userProfileDAO.selectProfileByEid(eid,sling);
            
            if(cacheFlag){
                admin.putInCache(eid, getSearchResult);
            }    
        }
        catch (Exception e) {
            log.error(" [GCD] [GCDManager] [selectProfileByEid(String eid)] Error while pushing data  " + e.getMessage());
            throw new Exception(" [GCD] [GCDManager] [selectProfileByEid(String eid)] Error while pushing data " + e.getMessage());
        }
        return getSearchResult;
    }
    
    public ArrayList<String> selectOwnerOperatorProfile(String ownerOperatorId,SlingScriptHelper sling) throws Exception 
    {
        ArrayList<String> getSearchResult=null;
        try {
            admin = CacheUtil.getInstance();
            int interval = Integer.parseInt(GCDConstants.GCD_OSCACHE_INTERVAL);
            getSearchResult = (ArrayList<String>) admin.getFromCache(ownerOperatorId,interval);
        } 
        catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            
            UserProfileDAO userProfileDAO = new UserProfileDAO();    
            getSearchResult = userProfileDAO.selectOwnerOperatorProfile(ownerOperatorId,sling);
            
            if(cacheFlag){
                admin.putInCache(ownerOperatorId, getSearchResult);
            }
        }
        catch (Exception e) {
            log.error(" [GCD] [GCDManager] [selectOwnerOperatorProfile(String ownerOperatorId)] Error while pushing data  " + e.getMessage());
            throw new Exception(" [GCD] [GCDManager] [selectOwnerOperatorProfile(String ownerOperatorId)] Error while pushing data " + e.getMessage());
        }
        return getSearchResult;
    }  
    
    /**
     * This method returns the parameters for advanced search
     * 
     * @return Array of SearchResult
     * @throws Exception
     */
    public AdvanceSearchParameter getAdvanceSearchParameters(SlingScriptHelper sling) throws Exception
    {
        AdvanceSearchParameter advanceSearchParameter=null;
        try {
            admin = CacheUtil.getInstance();
            int interval = Integer.parseInt(GCDConstants.GCD_OSCACHE_INTERVAL);
            advanceSearchParameter = (AdvanceSearchParameter) admin.getFromCache(GCDConstants.ADVANCE_SEARCH_PARAMETERS_CACHE_KEY,interval);            
        } 
        catch (com.opensymphony.oscache.base.NeedsRefreshException nre) { 
            advanceSearchParameter = new AdvanceSearchParameter();
            UtilityLookupDAO utilityLookupDAO = new UtilityLookupDAO();
            
            advanceSearchParameter.setAllCountryNames(getActiveCountries(sling));
            advanceSearchParameter.setAllDepartmentNamesByNumber(getAllDepartmentNamesByNumber(sling));
            advanceSearchParameter.setDepartmentNumber(getAllDepartmentNumbers(sling));  
            advanceSearchParameter.setAllStateCodes(utilityLookupDAO.getAllStateCodes(sling));
            advanceSearchParameter.setAllRegionNames(getAllRegionNames(sling));
            advanceSearchParameter.setAllRegionCodes(getAllRegionCodes(sling));
            advanceSearchParameter.setCompanyName(utilityLookupDAO.getAllCompanyNames(sling));
            advanceSearchParameter.setAllJobTitles(utilityLookupDAO.getAllJobTitles(sling));
            advanceSearchParameter.setAllPrefMailCodes(utilityLookupDAO.getAllPrefMailCodes(sling));
            advanceSearchParameter.setVmNodeNo(utilityLookupDAO.getAllVmBoxNu(sling));
            advanceSearchParameter.setAllLocation(utilityLookupDAO.getAllLocations(sling));
            
            if(cacheFlag){
                admin.putInCache(GCDConstants.ADVANCE_SEARCH_PARAMETERS_CACHE_KEY, advanceSearchParameter); 
            }    
        }
        catch (Exception e) {
            log.error(" [GCD] [GCDManager] [getAdvanceSearchParameters()] Error while getting data  " + e.getMessage());
            throw new Exception(" Errorss while pushing data getAdvanceSearchParameters... " + e.getMessage());
        }
        return advanceSearchParameter;
    }
    
     /**
     * This method returns the ArrayList of Department Names
     * 
     * @return Array of SearchResult
     * @throws Exception
     */
    private ArrayList<String> getAllDepartmentNamesByNumber(SlingScriptHelper sling)throws Exception
    {       
        return new UtilityLookupDAO().getAllDepartmentNamesByNumber(sling);
    }
    
    /**
     * This method returns the ArrayList of Department Numbers
     * 
     * @return Array of SearchResult
     * @throws Exception
     */
    private ArrayList<String> getAllDepartmentNumbers(SlingScriptHelper sling)throws Exception
    {
        return new UtilityLookupDAO().getAllDepartmentNumbers(sling);
    }
    
    /**
     * This method returns the ArrayList of Region Names
     * 
     * @return Array of SearchResult
     * @throws Exception
     */
    private ArrayList<String> getAllRegionNames(SlingScriptHelper sling)throws Exception
    {
        return new UtilityLookupDAO().getAllRegionNames(sling);
    }
    
    /**
     * This method returns the ArrayList of Region Codes
     * 
     * @return Array of SearchResult
     * @throws Exception
     */
    private ArrayList<String> getAllRegionCodes(SlingScriptHelper sling)throws Exception
    {
        return new UtilityLookupDAO().getAllRegionCodes(sling);
    }  
    
}
