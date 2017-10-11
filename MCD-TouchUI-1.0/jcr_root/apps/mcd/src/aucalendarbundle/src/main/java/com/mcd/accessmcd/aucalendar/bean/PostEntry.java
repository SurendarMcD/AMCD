package com.mcd.accessmcd.aucalendar.bean;

/*
 * Project: AccessMCD
 *
 * @(#)SQLstmts.java
 * Revisions:
 * Date            Author           Description
 * -----------------------------------------------------------------------
 * 01/18/2011     Judy Zhang    This Class contains the SQL Scripts
 *                              Used in AU calendar / Notice board Application.
 * -----------------------------------------------------------------------                                             
 * Description:
 * This software is the confidential and proprietary information of
 * McDonald's Corp. ("Confidential Information").
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with McDonald's.
 *
 * Copyright (c) 2011 McDonalds Corp.
 * All Rights Reserved.
 * www.accessmcd.com
 */


public class PostEntry
{

//PCI_CTNT:    (ID, DOC_URI,UUID,IMG_URL,MEDIA_URL,ALT_URL,ISRT_DT,ISRT_USER,MOD_DT,MOD_USER,AUD_IDS)
//PCI_CTNT_DTL:(ID, CTNT_ID,CAT_ID,VIEW_ID,TITLE,DS,LNCH_TYP,ACTV_FL,PUBL_DT,WKFL_ACTV_DT,ISRT_DT,MOD_DT,MOD_USER)
//PCI_CTNT_AUD:(CTNT_ID,AUD_ID)

    private String docURL = "";
    private String insDate= "";
    private String modDate= "";
    private String insUser= "";
    private String modUser= "";
    private String audienceType = "";

    private String contentID= "";
    private String categoryID= "";
    private String viewID= "";
    private String title= "";
    private String desc= "";
    private String actvFlag= "";
    private String launchtype= "";
    private String pubDate= "";
    
    //added by JZ, 03/09/2011
    private String uuid= "";
   

    /**
     * method to get contentID.
     * @return   String contentID
     */
    public String getContentID()
    {
        return contentID;
    }

    /**
     * method to set contentID
     * @param  contentID
     */
    public void setContentID(String contentID)
    {
        this.contentID= contentID;
    }

    /**
     * method to get title
     * @return   String title
     */
    public String getTitle()
    {
        return title;
    }

    /**
     * method to set title
     * @param  title
     */
    public void setTitle(String title)
    {
        this.title= title;
    }



    /**
     * method to get docURL 
     * @return   String docURL 
     */
    public String getDocURL()
    {
        return docURL ;
    }

    /**
     * method to set docURL 
     * @param  docURL 
     */
    public void setDocURL(String docURL )
    {
        this.docURL = docURL;
    }


    /**
     * method to get audienceType 
     * @return   String audienceType 
     */
    public String getAudienceType ()
    {
        return audienceType ;
    }

    /**
     * method to set audienceType 
     * @param  audienceType 
     */
    public void setAudienceType(String audienceType )
    {
        this.audienceType = audienceType ;
    }

    /**
     * method to get categoryID
     * @return   String categoryID
     */
    public String getCategoryID ()
    {
        return categoryID;
    }

    /**
     * method to set categoryID
     * @param  categoryID
     */
    public void setCategoryID(String categoryID)
    {
        this.categoryID= categoryID;
    }


    /**
     * method to get viewID
     * @return   String viewID
     */
    public String getViewID()
    {
        return viewID;
    }

    /**
     * method to set viewID
     * @param  viewID
     */
    public void setViewID(String viewID)
    {
        this.viewID= viewID;
    }

    /**
     * method to get actvFlag
     * @return   String actvFlag
     */
    public String getActvFlag()
    {
        return actvFlag;
    }

    /**
     * method to set actvFlag
     * @param  actvFlag
     */
    public void setActvFlag(String actvFlag)
    {
        this.actvFlag= actvFlag;
    }

    /**
     * method to get launchtype
     * @return   String launchtype
     */
    public String getLaunchtype()
    {
        return launchtype;
    }

    /**
     * method to set launchtype
     * @param  launchtype
     */
    public void setLaunchtype(String launchtype)
    {
        this.launchtype= launchtype;
    }


    /**
     * method to get pubDate
     * @return   String pubDate
     */
    public String getPubDate()
    {
        return pubDate;
    }

    /**
     * method to set pubDate
     * @param  pubDate
     */
    public void setPubDate(String pubDate)
    {
        this.pubDate= pubDate;
    }


    /**
     * method to get insDate
     * @return   String insDate
     */
    public String getInsDate()
    {
        return insDate;
    }

    /**
     * method to set insDate
     * @param  insDate
     */
    public void setInsDate(String insDate)
    {
        this.insDate= insDate;
    }


    /**
     * method to get modDate
     * @return   String modDate
     */
    public String getModDate()
    {
        return modDate;
    }

    /**
     * method to set modDate
     * @param  modDate
     */
    public void setModDate(String modDate)
    {
        this.modDate= modDate;
    }

    /**
     * method to get insUser
     * @return   String insUser
     */
    public String getInsUser()
    {
        return insUser;
    }

    /**
     * method to set insUser
     * @param  insUser
     */
    public void setInsUser(String insUser)
    {
        this.insUser= insUser;
    }

    /**
     * method to get modUser
     * @return   String modUser
     */
    public String getModUser()
    {
        return modUser;
    }

    /**
     * method to set modUser
     * @param  modUser
     */
    public void setModUser(String modUser)
    {
        this.modUser= modUser;
    }

    /**
     * method to get description
     * @return   String desc
     */
    public String getDesc()
    {
        return desc;
    }

    /**
     * method to set desc
     * @param  desc
     */
    public void setDesc(String desc)
    {
        this.desc= desc;
    }

    /**
     * method to get uuid
     * @return   String uuid
     */
    public String getUUID()
    {
        return uuid;
    }

    /**
     * method to set UUID
     * @param  uuid
     */
    public void setUUID(String ud)
    {
        this.uuid= ud; 
    }


}   