/*
 * Project: AccessMCD
 *
 * @(#)EmailDataBean.java
 * Revisions:
 * Date            Programmer           Description
 * --------------------------------------------------------------------------------------------
 * 27,April 2011   HCL                  This Bean Class contains the details for sending 
 *                                      the mail.
 * --------------------------------------------------------------------------------------------
 * Description:
 * This software is the confidential and proprietary information of
 * McDonald's Corp. ("Confidential Information").
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with McDonald's.
 *
 * Copyright (c) 2010 McDonalds Corp.
 * All Rights Reserved.
 * www.mcdonalds.com
 */

package com.mcd.accessmcd.comments.bean;

import java.util.Date;

/**
 * @author HCL
 * @version 1.0
 * @since 1.0
 */
public class EmailDataBean
{
    private String mailTo;
    private String mailCC;
    private String mailAction;
    private String mailFrom;
    private String mailSubject;
    private String pageTitle;
    private String commentDescription;
    private String commentByEID;
    private Date commentLastUpdated;
    private String commentURL;
    private String mailBody;
    private String commentSubscribeURL;
    private String commentUnsubscribeURL;
    
    /**
     * method to get the mail to list.
     * @return String
     */
    public String getMailTo()
    {
        return mailTo;
    }   
    /**
     * method to set the mail to list.
     * @param String mailTo
     */
    public void setMailTo(String mailTo)
    {
        this.mailTo = mailTo;
    }   
    /**
     * method to get the mail CC list.
     * @return String
     */
    public String getMailCC()
    {
        return mailCC;
    }   
    /**
     * method to set the mail CC list.
     * @param String mailCC
     */
    public void setMailCC(String mailCC)
    {
        this.mailCC = mailCC;
    }   
    /**
     * method to get the mail Action.
     * @return String Added/Subscribed.
     */
    public String getMailAction()
    {
        return mailAction;
    }   
    /**
     * method to set the mail Action.
     * @param mailAction Added/Subscribed.
     */
    public void setMailAction(String mailAction)
    {
        this.mailAction = mailAction;
    }   
    /**
     * method to get the sender mail address.
     * @return String
     */
    public String getMailFrom()
    {
        return mailFrom;
    }   
    /**
     * method to set the sender mail address.
     * @param String mailFrom.
     */
    public void setMailFrom(String mailFrom)
    {
        this.mailFrom = mailFrom;
    }   
    /**
     * method to get the mail subject.
     * @return String
     */
    public String getMailSubject()
    {
        return mailSubject;
    }   
    /**
     * method to set the mail subject.
     * @param mailSubject
     */
    public void setMailSubject(String mailSubject)
    {
        this.mailSubject = mailSubject;
    }   
    /**
     * method to get the comment page title.
     * @return String.
     */
    public String getPageTitle()
    {
        return pageTitle;
    }   
    /**
     * method to set the comment page title.
     * @param String pageTitle
     */
    public void setPageTitle(String pageTitle)
    {
        this.pageTitle = pageTitle;
    }   
    /**
     * method to get the comment description.
     * @return String.
     */
    public String getCommentDescription()
    {
        return commentDescription;
    }   
    /**
     * method to set the comment description.
     * @param commentDescription
     */
    public void setCommentDescription(String commentDescription)
    {
        this.commentDescription = commentDescription;
    }   
    /**
     * method to get the comment last updated date.
     * @return Date
     */
    public Date getCommentLastUpdated()
    {
        return commentLastUpdated;
    }   
    /**
     * method to set the comment last updated date.
     * @param Date commentLastUpdated
     */
    public void setCommentLastUpdated(Date commentLastUpdated)
    {
        this.commentLastUpdated = commentLastUpdated;
    }   
    /**
     * method to get the comment URL.
     * @return String.
     */
    public String getCommentURL()
    {
        return commentURL;
    }   
    /**
     * method to set the comment URL.
     * @param String commentURL
     */
    public void setCommentURL(String commentURL)
    {
        this.commentURL = commentURL;
    }   
    /**
     * method to get the mail body.
     * @return String
     */
    public String getMailBody()
    {
        return mailBody;
    }   
    /**
     * method to set the mail body.
     * @param String mailBody
     */
    public void setMailBody(String mailBody)
    {
        this.mailBody = mailBody;
    }   
    /**
     * method to get the comment by EID.
     * @return String
     */
    public String getCommentByEID()
    {
        return commentByEID;
    }   
    /**
     * method to set the comment by EID.
     * @param String commentByEID
     */
    public void setCommentByEID(String commentByEID)
    {
        this.commentByEID = commentByEID;
    }   
    /**
     * method to get the comment unsubscribe URL.
     * @return String
     */
    public String getCommentUnsubscribeURL()
    {
        return commentUnsubscribeURL;
    }   
    /**
     * method to set the comment unsubscribe URL.
     * @param String commentUnsubscribeURL
     */
    public void setCommentUnsubscribeURL(String commentUnsubscribeURL)
    {
        this.commentUnsubscribeURL = commentUnsubscribeURL;
    }   
    /**
     * method to get the comment subscribe URL.
     * @return String
     */
    public String getCommentSubscribeURL()
    {
        return commentSubscribeURL;
    }   
    /**
     * method to set the comment subscribe URL.
     * @param commentSubscribeURL
     */
    public void setCommentSubscribeURL(String commentSubscribeURL)
    {
        this.commentSubscribeURL = commentSubscribeURL;
    }
}
