package com.mcd.accessmcd.pci.bo;

import java.util.Date;

/**
Represents a single PCI entry. <br>

Erik Wannebo 11/24/08
 */ 
public class PCIResult {
    
    private String documentTitle;  
    private String categoryID; 
    private String description; 
    private String typeCode;
    private String launchType; 
    private String serverID;
    private String serverHostDomain;
    private String pageURI; 
    private String mediaURI; 
    private String imageURI;
    private String thumbnailURI;
    private String creationDate;
    private Date publishDateObj;
    private String publishDate;
    private String publishDateNonUS;
    private String publishDateJapan;
    private String audienceType;
    private int totalResultCount=0;
    private String categoryTitle;
    private String categoryAbstract;
    private String categoryChildrenCount;
    private String parentCategoryID; 
    private String contentDetailID;
    private String contentID;
    private String entityType;//added 3/4/2011
    private String UUID;//added 3/9/2011
    /**
     [Used for category requests only.] <br>
     */     
    public String getCategoryAbstract() {
        return categoryAbstract;
    }
    public void setCategoryAbstract(String categoryAbstract) {
        this.categoryAbstract = categoryAbstract;
    }
    /**
     [Used for category requests only.] <br>
     */
    public String getCategoryChildrenCount() {
        return categoryChildrenCount;
    }
    public void setCategoryChildrenCount(String categoryChildrenCount) {
        this.categoryChildrenCount = categoryChildrenCount;
    }
    /**
    PCI Category ID. <br>
    <br>
    PCI DB field: CTNT_ITM_CAT_ID
     */ 
    public String getCategoryID() {
        return categoryID;
    }
    public void setCategoryID(String categoryID) {
        this.categoryID = categoryID;
    }
    /**
     [Used for category requests only.] <br>
     */
    public String getCategoryTitle() {
        return categoryTitle;
    }
    public void setCategoryTitle(String categoryTitle) {
        this.categoryTitle = categoryTitle;
    }
    /**
    Date PCI Entry was created. <br>
    <b>Currently this value is not returned by the PCI Servlet XML</b><br>
    <br>
    PCI DB field: CTNT_ITM_CRTE_DT 
     */ 
    public String getCreationDate() {
        return creationDate;
    }
    public void setCreationDate(String creationDate) {
        this.creationDate = creationDate;
    }
    /**
    Description of document contents. <br>
    <br>
    PCI DB field: CTNT_ITM_DESC (2000 characters)
        <br>
    PCI 2.0 DB field: PCI.PCI_CTNT_DTL.DS

     */     
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     Returns PCI Document Title. <br>
    <br>
    PCI DB field: CTNT_ITM_DOC_TITL
     */ 
    public String getDocumentTitle() {
        return documentTitle;
    }
    public void setDocumentTitle(String documentTitle) {
        this.documentTitle = documentTitle;
    }
    /**
    The URI of the Feature Story main image. <br>
    <i>Example: /mcdonalds/featurestory1.featureimage.gif</i> <br>
    <br>
    PCI DB field: N/A
    <br>
    PCI 2.0 DB field: PCI.PCI_CTNT.IMG_URL
     */ 
    public String getImageURI() {
        return imageURI;
    }
    public void setImageURI(String imageURI) {
        this.imageURI = imageURI;
    }
    /**
    Launch Type is passed as a parameter to the displayGoTo function. <br>
    function displayGoTo(sLinkType, <b>sLaunchType</b>, sServerName, sURI, sVP) (function found in AccessMCD global.js) <br>
    <br>
    <i>
    Possible values<br>
    1 : Current Window without Header & Site Navigation<br>
    2 : Current Window WITH Header & Site Navigation<br>
    3 : New Window without Header & Site Navigation<br>
    4 : New Window WITH Header & Site Navigation<br>
    </i><br>
    <br>
    PCI DB field: CTNT_ITM_LNCH_TYP
        <br>
    PCI 2.0 DB field: PCI.PCI_CTNT_DTL.LNCH_TYP (stored with value one less

     */ 
    public String getLaunchType() {
        return launchType;
    }
    public void setLaunchType(String launchType) {
        this.launchType = launchType;
    }
    /**
    URI of media file to be displayed in portal. <br>
    For Internal Feature Story files, this URI will include a .featuremedia. globbing pattern<br>
    The URI's extension can be used by the Feature Story component in determining how it should be rendered (FLV/SWF/MP3)<br>
    <br>
    <i>Example: /mcdonalds/featurestory1.featuremedia.html/video.flv</i><br>
    Note: For Externally hosted Feature Story media, this URI could be a fully qualified external URL.<br>
    <br>
    <i>Example: https://www.talkpoint.com/hosting/video.flv</i><br>
    <br>PCI DB field: CTNT_ITM_RSCE_DS 
    <br>
    PCI 2.0 DB field: PCI.PCI_CTNT.MEDIA_URL
     */ 
    public String getMediaURI() {
        return mediaURI;
    }
    public void setMediaURI(String mediaURI) {
        this.mediaURI = mediaURI;
    }
    /**
    URI of the main document. <br>
    <br>
    Includes .accessmcd. globbing pattern by default -- this opens the story without a header or left navigation<br>
    (This globbing pattern is added by default by the AccessMCD Replication Agent)<br>
    <br>
    If another piece of information needs to be returned from the page, a different globbing pattern can be substituted<br>
    (such as ".interactive." for the Interactive component and template)<br>
    <br>
    <i>Example: /mcdonalds/featurestory1.accessmcd.html</i><br>
    <br>
    PCI DB field: CTNT_ITM_URI  
     */ 
    public String getPageURI() {
        return pageURI;
    }
    public void setPageURI(String pageURI) {
        this.pageURI = pageURI;
    }
    /**
    
    Document date to be displayed in Portal (mm.dd.yy). <br>
    <br>
    <i>Example: 11.25.08</i><br>
    <br>
    PCI DB field: CTNT_ITM_PUBL_DT
     */ 
    public String getPublishDate() {
        String retPublishDate=publishDate;
        if(retPublishDate==null || retPublishDate.equals("")){
            if(publishDateObj!=null){
                
            }
        }else{
            retPublishDate=publishDate;
        }
        return retPublishDate;
    }
    public void setPublishDate(String publishDate) {
        this.publishDate = publishDate;
    }
    /**
    Document date to be displayed in Portal Formatted as (yy.mm.dd). <br>
    <br>
    <i>Example: 08.11.25</i>
     */ 
    public String getPublishDateJapan() {
        return publishDateJapan;
    }
    public void setPublishDateJapan(String publishDateJapan) {
        this.publishDateJapan = publishDateJapan;
    }
    /**
    Document date to be displayed in Portal formatted as (dd.mm.yy). <br>
    <br>
    <i>Example: 25.11.08</i>
     */ 
    public String getPublishDateNonUS() {
        return publishDateNonUS;
    }
    public void setPublishDateNonUS(String publishDateNonUS) {
        this.publishDateNonUS = publishDateNonUS;
    }
    /**
    Decoded host/domain value of serverID. <br>
    to be appended on the URI properties when constructing absolute URLs<br>
    <br>
    <i>Example: https://prodp.mcdexchange.com</i><br>
     */ 
    public String getServerHostDomain() {
        return serverHostDomain;
    }
    public void setServerHostDomain(String serverHostDomain) {
        this.serverHostDomain = serverHostDomain;
    }
    /**
    Server ID is passed as a parameter to the displayGoTo function. <br>
    function displayGoTo(sLinkType, sLaunchType, <b>sServerName</b>, sURI, sVP) (function found in AccessMCD global.js)<br>
    <br>
    <i>
    Example values<br>
    MCDEXCHANGE : prodp.mcdexchange.com<br>
    INTLMCDE : intl.mcdexchange.com  International CQ instance--including McWeb (Canada)<br>
    MCDWMI : www.mcdwmi.com (Worlwide Marketing Intranet/Magic)<br>
    MCDCOM : www.mcdonalds.com<br>
    ICONTENT : apps.accessmcd.com    (IIS Server)<br>
    DCONTENT : content.accessmcd.com (Domino content)<br>
    </i>
    <br>
    PCI DB field: CTNT_ITM_SRVR_ID
     */ 
    public String getServerID() {
        return serverID;
    }
    public void setServerID(String serverID) {
        this.serverID = serverID;
    }
    /**
    The URI of the Feature Story thumbnail, used for Past Feature Stories.
    <i>Example: /mcdonalds/featurestory1.featurethumbnail.gif</i>
    PCI DB field: N/A
    <br>
    PCI 2.0 DB field: PCI.PCI_CTNT.IMG_URL
     */ 
    public String getThumbnailURI() {
        return thumbnailURI;
    }
    public void setThumbnailURI(String thumbnailURI) {
        this.thumbnailURI = thumbnailURI;
    }
    /**
    Type of link. <br>
    Passed as a parameter to the displayGoTo function (AccessMCD global.js) <br>
    function displayGoTo(<b>sLinkType</b>, sLaunchType, sServerName, sURI, sVP) <br>
    <br>
    <i>
    Example values <br>
    A : Link is a content item <br>
    B : Link is a Category Page <br>
    C : Link is a my site page <br>

    <br>
    ("A" is almost exclusively used now)
    </i>
    <br><br>
    PCI DB field: CTNT_ITM_TYP_CD <br>  

     */ 
    public String getTypeCode() {
        return typeCode;
    }
    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }

    /**
    Total number of results available. <br>
    
     */ 
    public int getTotalResultCount() {
        return totalResultCount;
    }
    public void setTotalResultCount(int totalResultCount) {
        this.totalResultCount = totalResultCount;
    }

    
    /**
    Audiences which have access to this content.<br>
    <i>(Added 9/25/2009)</i>
     */ 
    public String getAudienceType() {
        return this.audienceType;
    }
    public void setAudienceType(String audienceType) {
        this.audienceType = audienceType;
    }
    
    /**
    The Date Object for the Publish Date. <br>
    (For easier localication.)
    <br>
    PCI 2.0 DB field: PCI.PCI_CTNT_DTL.PUBL_DT
     */ 
    public Date getPublishDateObj() {
        return publishDateObj;
    }
    public void setPublishDateObj(Date publishDateObj) {
        this.publishDateObj = publishDateObj;
    }
    
    /**
    The ID of the Parent Category.<br>
    <i>(Added 10/20/2009)</i>
     */ 
    public String getParentCategoryID() {
        return this.parentCategoryID;
    }
    public void setParentCategoryID(String parentCategoryID) {
        this.parentCategoryID = parentCategoryID;
    }
    
     /**
    The ID of the content item in the content table,<br>
    <i>(Added 2/24/2011)</i>
     */ 
    public String getContentID() {
        return this.contentID;
    }
    public void setContentID(String contentID) {
        this.contentID= contentID;
    }
    
    /**
    The ID of the content detail item in the detail table,<br>
    <i>(Added 2/24/2011)</i>
     */ 
    public String getContentDetailID() {
        return this.contentDetailID;
    }
    public void setContentDetailID(String contentDetailID) {
        this.contentDetailID= contentDetailID;
    }
     /**
    The ID of the content view in the detail table,<br>
    <i>(Added 3/4/2011)</i>
     */ 
    public String getEntityType() {
        return this.entityType;
    }
    public void setEntityType(String entityType) {
        this.entityType= entityType;
        }
          /**
    The UUID of the entry on the content table,<br>
    <i>(Added 3/9/2011)</i>
     */ 
    public String getUUID() {
        return this.UUID;
    }
    public void setUUID(String UUID) {
        this.UUID= UUID; 
        }
    
}

