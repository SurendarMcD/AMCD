package com.mcd.accessmcd.pci.bo;

import com.mcd.accessmcd.pci.util.PCIProperties;

import java.text.SimpleDateFormat;
import java.util.Date;
/**
Holds criteria to query PCI. <br>

Erik Wannebo 11/24/08
 */ 
public class PCIQuery {
    
    private String categoryID;
    private String entityType="ENT"; //AccessMCD View
    private String audience; 
    private String actionType="read";
    private String resultStart="1"; 
    private String resultCount="10"; 
    private String sortType="rchrono";
    private String viewType="content"; 
   // private String urlPCI;//??
    //private String userPCI;//??
    private String topStoryCategoryID;
    private Date fromDate=null;
    private Date toDate=null;
    
    private int cacheRefresh=30;//seconds
    
    //only used by XSLTs
   // private String styleSheet;
   // private String descriptionUnder;
    //private String descriptionAbove;
    //private String viewAllPage;
    
    public PCIQuery(){
        this.cacheRefresh=PCIProperties.DEFAULT_OSCACHE_REFRESH;
    }
    public String getActionType() {
        return actionType;
    }
    /**
    Sets PCI Action. <br>
    <br>
    <i> Acceptable values: <br>
    read [Default]<br>
    add <br>
    delete <br>
    reload <br>
    </i>
     */ 
    public void setActionType(String actionType) {
        this.actionType = actionType;
    }
    public String getAudience() {
        return audience;
    }
    /**
    Sets audience type (role) to use to filter PCI documents. <br>
    <br>
    <i>
    Acceptable values: <br>
    CorpEmployees <br>
    McOpCoRestMgrs <br>
    Franchisees <br>
    FranchiseeRestMgrs <br>
    Crew <br>
    SupplierVendors <br>
    ALL (added 3/4/2011)<br>
    </i>
    <br>
    Default Value:null
     */     
    public void setAudience(String audience) {
        this.audience = audience;
    }
    public String getCategoryID() {
        return categoryID;
    }
    /**
    Sets PCI category to return documents from. <br>
     */ 
    public void setCategoryID(String categoryID) {
        this.categoryID = categoryID;
    }
    public String getEntityType() {
        return entityType;
    }
    /**
    Sets AccessMCD Entity (View) to return documents from. <br>
    <br>
    <i>
    Acceptable Values:<br>
    ENT (Global) [Default]<br>
    US (US) <br>
    AU (Australia) <br>
    JA (Japan) <br>
    ALL (added 3/4/2011)<br>
    </i>
         */ 
    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }
    public String getResultCount() {
        return resultCount;
    }
    /**
    Sets maximum number of PCI documents to return. <br>
    Default Value: 10
         */ 
    public void setResultCount(String resultCount) {
        this.resultCount = resultCount;
    }
    public String getResultStart() {
        return resultStart;
    }
    /**
    Sets number of PCI result to start returning from. <br>
    Default Value: 1
     */ 
    public void setResultStart(String resultStart) {
        this.resultStart = resultStart;
    }
    public String getSortType() {
        return sortType;
    }
    /**
    Sets the sort order of the returned PCI results. <br>
    <br>
    <i>Acceptable Values:<br>
    alpha <br>
    chrono <br>
    chronouuid (chrono +UUID added 3/9/2011)<br>
    rchrono [Default] (reverse chronological)<br>
    rchronouuid (rchrono + UUID added 3/9/2011)<br>
    </i>
     */ 
    public void setSortType(String sortType) {
        this.sortType = sortType;
    }

    public String getTopStoryCategoryID() {
        return topStoryCategoryID;
    }

    /**
    Sets the category ID of the Top Story Category. <br>
    The Top Story item is included as the first result in the results <br>
    Default: null
     */ public void setTopStoryCategoryID(String topStoryCategoryId) {
        this.topStoryCategoryID = topStoryCategoryId;
    }
    public String getViewType() {
        return viewType;
    }
    /**
    Sets the View Type for the results. <br>
    Each view type has a different XML structure <br>
    <br>
    <i>
    Acceptable Values: <br>
    content [Default]<br>
    category <br>
    combo (combination sub-categories plus content items--used for Content Index)<br>
    sf (SiteFinder)<br>
    </i>
     */ 
    public void setViewType(String viewType) {
        this.viewType = viewType;
    }
    
    /**
    Returns the PCIQuery object as a querystring <br>
    Used to make a HTTP request sent to the PCI Servlet application <br>
    <br>
    @param topstory : Return Top Story querystring? (true/false)<br>
     */ 
    public String toQueryString(boolean topstory){
        
        StringBuffer qs=new StringBuffer("");
        qs.append("action="+this.actionType);
        if(topstory){
            qs.append("&sorting=rchrono&count=1&start=1&catid="+this.topStoryCategoryID);
        }else{
            qs.append("&catid="+this.categoryID);
            int resultcount=10;//default
            try{
                resultcount=Integer.parseInt(this.resultCount);
            }catch(NumberFormatException nfe ){
                //ignore
            }
            //for old PCI to get Australia up and running
            //will be different when working with new PCI DB DAO
            //9/25/2009 ECW
            if(this.fromDate!=null && this.toDate!=null){
                this.resultStart="1";
                this.resultCount="10000"; //large # for now
                //this.sortType="chrono";
                SimpleDateFormat sdf=new SimpleDateFormat("M/dd/yyyy");
                qs.append("&fromDate="+sdf.format(this.fromDate));
                qs.append("&toDate="+sdf.format(this.toDate));
            }
            if(this.topStoryCategoryID!=null && !this.topStoryCategoryID.equals("") && resultcount>1){
                //return one less of the main category, if there is a top story category
                qs.append("&count="+(resultcount-1));
            }else{
                qs.append("&count="+this.resultCount);
            }
            qs.append("&start="+this.resultStart);
            qs.append("&sorting="+this.sortType);
        }
        qs.append("&viewtype="+this.viewType);
        qs.append("&mcdaudience="+this.audience);
        qs.append("&mcdentity="+this.entityType);
        qs.append("&sm_user=test");
        return qs.toString();
    }
    
    /**
    Returns the cachekey to be used when caching results in PCIContentManager
    using the OSCache caching framework.
    <br>
     */ 
    public String getOSCacheKey(){
        StringBuffer oscachekey=new StringBuffer("");
        oscachekey.append(this.categoryID);
        oscachekey.append("|");
        oscachekey.append(this.audience);
        oscachekey.append("|");
        oscachekey.append(this.entityType);
        oscachekey.append("|");
        oscachekey.append(this.resultStart);
        oscachekey.append("|");
        oscachekey.append(this.resultCount);
        oscachekey.append("|");
        oscachekey.append(this.sortType);
        oscachekey.append("|");
        oscachekey.append(this.viewType);
        oscachekey.append("|");
        oscachekey.append(this.topStoryCategoryID);
        oscachekey.append("|");
        if(this.fromDate!=null && this.toDate!=null){
            SimpleDateFormat sdf=new SimpleDateFormat("MM_dd_yyyy");
            oscachekey.append(sdf.format(this.fromDate));
            oscachekey.append("|");
            oscachekey.append(sdf.format(this.toDate));
            oscachekey.append("|");
        }

        return oscachekey.toString();
    }
    public int getCacheRefresh() {
        return cacheRefresh;
    }
    /**
    Sets the cache refresh time in seconds
    (Default is 60 seconds)
    <br>
     */ 
    public void setCacheRefresh(int cacheRefresh) {
        this.cacheRefresh = cacheRefresh;
    }
    public Date getFromDate() {
        return fromDate;
    }
    /**
    Sets starting Publish Date from which to return results<br>
    <br>
    If not specified, it will not be used to filter results.<br>
    <br><i>(Added 9/25/2009)</i><br>
    </i>
    */
    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }
    public Date getToDate() {
        return toDate;
    }
    /**
    Sets ending Publish Date (inclusive) from which to return results<br>
    <br>
    If not specified, it will not be used to filter results.<br>
    <br><i>(Added 9/25/2009)</i><br>
    </i>
    */  public void setToDate(Date toDate) {
        this.toDate = toDate;
    }
    

}

