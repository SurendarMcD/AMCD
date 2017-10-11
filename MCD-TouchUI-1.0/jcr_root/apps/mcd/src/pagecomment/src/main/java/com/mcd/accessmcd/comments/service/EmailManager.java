/*
 * Project: AccessMCD
 *
 * @(#)EmailManager.java
 * Revisions:
 * Date            Programmer           Description
 * --------------------------------------------------------------------------------------------
 * 27,April 2011   HCL                  This Class contains the methods to create and send 
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

package com.mcd.accessmcd.comments.service;

import java.util.Date;
import java.util.Map;
import java.util.StringTokenizer;
import javax.jcr.Node;
import javax.jcr.Session;
import javax.jcr.Value;
import org.apache.commons.mail.HtmlEmail;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.day.cq.mailer.MailService;
import com.day.cq.security.User;
import com.day.cq.security.UserManager;
import com.day.cq.security.UserManagerFactory;
import com.day.cq.wcm.api.Page;
import com.mcd.accessmcd.comments.bean.EmailDataBean;
import com.mcd.accessmcd.comments.constants.CommentsConstants;
import com.mcd.accessmcd.comments.util.CommonUtilities;
import com.mcd.accessmcd.comments.util.NodeUtility;
import com.mcd.accessmcd.comments.util.PropertiesLoader;
import com.mcd.accessmcd.comments.util.UserDetails;
import java.net.URLEncoder;


/**
 * @author HCL
 * @version 1.0
 * @since 1.0
 */
public class EmailManager
{
    private static final Logger log = LoggerFactory.getLogger(EmailManager.class);
    SlingScriptHelper sling;
    ResourceResolver resolver;
    Node commentNode;
    Node commentRootNode;
    UserManager uMgr;
    User user = null;
    Node commentPageNode;
    Node subscribersNode;
    Page page = null;
    String pagePath = null;
    
    String commentByEID = null;
    String unsubscribeURL = null;
    Date commentLastUpdated = null;
    String commentDescription = null;
    String commentURL = null;
    String commentRootNodePath = null;    
        
    /**
     * Constructor
     * @param sling
     * @param resolver
     * @param node
     */
    public EmailManager(SlingScriptHelper sling, ResourceResolver resolver, Node node)
    {
        log.info("[EmailManager(sling, resolver, node)] Sling: "+sling+", resolver: "+resolver+" and Node: "+node);
        this.commentNode = node;
        this.resolver = resolver;
        this.sling = sling;
        this.uMgr = getUserManager();
        try
        {
            NodeUtility nodeUtility = new NodeUtility(resolver.getResource(commentNode.getPath()));
            commentRootNode = nodeUtility.getRootNode();
            commentPageNode = commentRootNode.getParent().getParent();
            subscribersNode = commentPageNode.getNode(commentPageNode.getName()+CommentsConstants.UNDERSCORE+commentRootNode.getName()).getNode(CommentsConstants.JCR_CONTENT);            
            pagePath = subscribersNode.getProperty(CommentsConstants.COMMENTS_PAGE_PATH).getString();
            page = resolver.getResource(pagePath).adaptTo(Page.class);
            log.error(subscribersNode.getPath() + " :: " + pagePath + " :: " + page);
            commentByEID = CommonUtilities.checkNull(commentNode.getProperty(CommentsConstants.USER_IDENTIFIER).getString());
            unsubscribeURL = CommonUtilities.checkNull(commentNode.getProperty(CommentsConstants.REFERER).getString()).replaceAll(CommentsConstants.EXTN_HTML, CommentsConstants.EXTN_UNSUBSCRIBE_HTML);
            
            if(commentNode.hasProperty(CommentsConstants.PROP_ADDED))
                commentLastUpdated = commentNode.getProperty(CommentsConstants.PROP_ADDED).getDate().getTime();
            else
                commentLastUpdated = commentNode.getProperty(CommentsConstants.JCR_CREATED).getDate().getTime();                
            
            commentDescription = CommonUtilities.checkNull(commentNode.getProperty(CommentsConstants.JCR_DESCRIPTION).getString());            
            commentURL = CommonUtilities.checkNull(commentNode.getProperty(CommentsConstants.REFERER).getString());
            commentRootNodePath = commentRootNode.getName();
        }
        catch (Exception e)
        {
            log.error("[EmailManager()] error occured while initialising ",e);
        }
    }
    
    /**
     * Constructor
     * @param sling
     * @param resolver
     * @param node
     */
    public EmailManager(SlingScriptHelper sling, ResourceResolver resolver)
    {
        log.info("[EmailManager(sling, resolver)] Sling: "+sling+" and resolver: "+resolver);
        this.resolver = resolver;
        this.sling = sling;
        this.uMgr = getUserManager();
    }
    
    /**
     * This method is used to compose the email body by getting the data from EmailDataBean.
     * @param EmailDataBean mailData
     * @return String
     */
    public String composeEmailBody(EmailDataBean mailData)
    {
        log.info("[composeEmailBody()] EmailDataBean: "+mailData);
        String mailContent = null;
        String commentByEmail = null;
        String commentByName = null;
        
        StringBuffer finalTime = new StringBuffer(CommentsConstants.BLANK);
        String commentUpdatedDate = null;
        
        try
        {
            if (mailData.getMailAction().equalsIgnoreCase(CommentsConstants.EMAIL_ADD_ACTION))
            {
                Map<String, String> userDetailsMap = UserDetails.getUserPropertiesFromLDAP(commentByEID);
                if(userDetailsMap == null)
                {
                    user = (User) uMgr.get(commentByEID);
                    if (user != null)
                    {
                        if (!CommonUtilities.checkNull(user.getProperty(CommentsConstants.USER_EMAIL)).equalsIgnoreCase(CommentsConstants.BLANK))
                            commentByEmail = CommonUtilities.checkNull(user.getProperty(CommentsConstants.USER_EMAIL));
                        if (user.getProperty(CommentsConstants.USER_FULLNAME) == null)
                            commentByName = CommonUtilities.checkNull(user.getID());
                        else
                        {
                            commentByName = CommonUtilities.checkNull(user.getProperty(CommentsConstants.USER_FULLNAME));
                            commentByName = CommonUtilities.capitalizeFirstLetters(commentByName.toLowerCase());
                        }
                    }
                    user = null;
                }
                else
                {
                    commentByName = userDetailsMap.get(CommentsConstants.FULLNAME);
                    commentByName = CommonUtilities.capitalizeFirstLetters(commentByName.toLowerCase());
                    commentByEmail = userDetailsMap.get(CommentsConstants.MAIL);
                }
                
                mailContent = PropertiesLoader.getProperty(CommentsConstants.ADD_COMMENT_EMAIL_CONTENT);
                
                if (unsubscribeURL.indexOf(CommentsConstants.QUESTIONMARK) != -1)
                    unsubscribeURL = unsubscribeURL.substring(0, unsubscribeURL.indexOf(CommentsConstants.QUESTIONMARK));
                if (commentURL.indexOf(CommentsConstants.QUESTIONMARK) != -1)
                    commentURL = commentURL.substring(0, commentURL.indexOf(CommentsConstants.QUESTIONMARK));                    
                //hard-coded webserver IP replacement for now (because UAG messes up referrer field) 3-13-12 ECW
                commentURL=commentURL.replace("/content/","/").replace("66.111.151.240:14023","www.accessmcd.com").replace("66.111.151.212:14023","www.accessmcd.com"); 
                unsubscribeURL =unsubscribeURL.replace("/content/","/").replace("66.111.151.240:14023","www.accessmcd.com").replace("66.111.151.212:14023","www.accessmcd.com"); 
                

                /*TimeZone tz = TimeZone.getTimeZone("CST");
                DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, Locale.US);
                formatter.setTimeZone(tz);
                formattedDate = formatter.format(mailData.getCommentLastUpdated());*/
                
                Date currentDate = new Date();
                Date commentDate = commentLastUpdated;

                long milis1 = commentDate.getTime();
                long milis2 = currentDate.getTime();
                //difference in milliseconds
                long diff = milis2 - milis1;
                //difference in seconds
                long diffSeconds = diff / 1000;
                //difference in minutes
                long diffMinutes = diffSeconds / 60;
                //difference in hours

                if (diffMinutes > 0)
                {
                    if (diffMinutes > 1)
                    {
                        finalTime.append(diffMinutes);
                        finalTime.append(CommentsConstants.MINUTES);
                    }
                    else
                    {
                        finalTime.append(CommentsConstants.A);
                        finalTime.append(CommentsConstants.MINUTE);
                    }
                    finalTime.append(CommentsConstants.AGO);
                }
                else if (diffSeconds > 0)
                {
                    if (diffSeconds > 1)
                    {
                        finalTime.append(diffSeconds);
                        finalTime.append(CommentsConstants.SECONDS);
                    }
                    else
                    {
                        finalTime.append(CommentsConstants.A);
                        finalTime.append(CommentsConstants.SECOND);
                    }
                    finalTime.append(CommentsConstants.AGO);
                }
                else
                {
                    finalTime.append(CommentsConstants.ABOUT);
                    finalTime.append(CommentsConstants.A);
                    finalTime.append(CommentsConstants.SECOND);
                    finalTime.append(CommentsConstants.AGO);
                }
                
                commentUpdatedDate = finalTime.toString();
                mailContent = mailContent.replaceAll(CommentsConstants.PROP_PAGE_TITLE, CommonUtilities.checkNull(page.getTitle()));
                mailContent = mailContent.replaceAll(CommentsConstants.PROP_COMMENT_BODY, commentDescription);
                mailContent = mailContent.replaceAll(CommentsConstants.PROP_COMMENT_URL, commentURL); 
                mailContent = mailContent.replaceAll(CommentsConstants.PROP_MAIL_TO_LINK, CommentsConstants.MAIL_TO + commentByEmail);
                mailContent = mailContent.replaceAll(CommentsConstants.PROP_COMMENT_BY, commentByName);
                mailContent = mailContent.replaceAll(CommentsConstants.PROP_LAST_UPDATED, commentUpdatedDate);
                mailContent = mailContent.replaceAll(CommentsConstants.PROP_UNSUBSCRIBE_URL, unsubscribeURL.replace("/content/","/"));
            }
            else if (mailData.getMailAction().equalsIgnoreCase(CommentsConstants.EMAIL_UNSUBSCRIBE_ACTION))
            {
                commentURL = CommonUtilities.checkNull(mailData.getCommentSubscribeURL()); 
                mailContent = PropertiesLoader.getProperty(CommentsConstants.UNSUBSCRIBE_EMAIL_CONTENT);

                mailContent = mailContent.replaceAll(CommentsConstants.PROP_COMMENT_URL, commentURL);
                mailContent = mailContent.replaceAll(CommentsConstants.PROP_PAGE_TITLE, CommonUtilities.checkNull(mailData.getPageTitle())); 
            }
        } 
        catch (Exception e)
        {
            log.error("[composeEmailBody()] Exception: " + e.getMessage());
        }
        user = null;

        return mailContent;
    }
    /**
     * This method is used to send the mail using the data in the EmailDataBean.
     * @param mailData
     * @return boolean sent status.
     */
    public boolean sendMail(EmailDataBean mailData)
    {
        log.info("[sendMail()] EmailDataBean: "+mailData);
        boolean mailSent = false;
        Map<String, String> userDetailsMap = null;
        String pageTitle = null;
        try
        {
            MailService mailService = sling.getService(MailService.class);
            HtmlEmail email = new HtmlEmail();
            email.setCharset("utf-8");
          
            //Setting Mail To.
            String mailToList = CommentsConstants.BLANK;
            String EID = CommentsConstants.BLANK;

            if (!mailData.getMailAction().equalsIgnoreCase(CommentsConstants.EMAIL_UNSUBSCRIBE_ACTION))
            {                
                pageTitle = page.getTitle();
                if (subscribersNode.hasProperty(CommentsConstants.SUBSCRIBED_USERS_NODE))
                {                    
                    Value[] values = subscribersNode.getProperty(CommentsConstants.SUBSCRIBED_USERS_NODE).getValues();

                    int i = 0;
                    for (; i < values.length; i++)
                    {
                        EID = values[i].getString();
                        try
                        {
                            userDetailsMap = UserDetails.getUserPropertiesFromLDAP(EID);
                            if(userDetailsMap != null)
                            {
                                mailToList += CommonUtilities.checkNull(userDetailsMap.get(CommentsConstants.MAIL)) + CommentsConstants.COMMA;
                            }
                            else
                            {
                                log.info("******************USER NOT IN LDAP********************");
                                System.out.println("******************USER NOT IN LDAP********************");
                                user = (User) uMgr.get(EID);
                                if (user != null)
                                {
                                    if (!CommonUtilities.checkNull(user.getProperty(CommentsConstants.USER_EMAIL)).equalsIgnoreCase(CommentsConstants.BLANK))
                                        mailToList += CommonUtilities.checkNull(user.getProperty(CommentsConstants.USER_EMAIL)) + CommentsConstants.COMMA;
                                }
                            }
                        }
                        catch (Exception e)
                        {
                            log.error("[sendMail()] case SubscribedUsers Exception: " + e.getMessage());
                        }
                        userDetailsMap = null;
                        user = null;
                        EID = CommentsConstants.BLANK;
                    }
                }
                if (subscribersNode.hasProperty(CommentsConstants.DEFAULT_USERS_NODE))
                {
                    Value[] values = subscribersNode.getProperty(CommentsConstants.DEFAULT_USERS_NODE).getValues();

                    int i = 0;
                    for (; i < values.length; i++)
                    {
                        EID = values[i].getString();
                        try
                        {
                            userDetailsMap = UserDetails.getUserPropertiesFromLDAP(EID);
                            if(userDetailsMap != null)
                            {
                                mailToList += CommonUtilities.checkNull(userDetailsMap.get(CommentsConstants.MAIL)) + CommentsConstants.COMMA;
                            }
                            else
                            {
                                user = (User) uMgr.get(EID);
                                if (user != null)
                                {
                                    if (!CommonUtilities.checkNull(user.getProperty(CommentsConstants.USER_EMAIL)).equalsIgnoreCase(CommentsConstants.BLANK))
                                        mailToList += CommonUtilities.checkNull(user.getProperty(CommentsConstants.USER_EMAIL)) + CommentsConstants.COMMA;
                                }
                            }
                        }
                        catch (RuntimeException e)
                        {
                            log.error("[sendMail()] case DefaultUsers Exception: " + e.getMessage());
                        }
                        userDetailsMap = null;
                        user = null;
                        EID = CommentsConstants.BLANK;
                    }
                }
            }
            else {
                pageTitle = mailData.getPageTitle();
            }

            if (!(mailData.getMailTo() == null || mailData.getMailTo().equalsIgnoreCase(CommentsConstants.BLANK)))
            {
                try
                {
                    userDetailsMap = UserDetails.getUserPropertiesFromLDAP(mailData.getMailTo());
                    if(userDetailsMap != null)
                    {
                        mailToList += CommonUtilities.checkNull(userDetailsMap.get(CommentsConstants.MAIL)) + CommentsConstants.COMMA;
                    }
                    else
                    {
                        user = (User) uMgr.get(mailData.getMailTo());
                        if (user != null)
                        {
                            if (!CommonUtilities.checkNull(user.getProperty(CommentsConstants.USER_EMAIL)).equalsIgnoreCase(CommentsConstants.BLANK))
                                mailToList += CommonUtilities.checkNull(user.getProperty(CommentsConstants.USER_EMAIL)) + CommentsConstants.COMMA;
                        }
                    }
                }
                catch (RuntimeException e)
                {
                    log.error("[sendMail()] set mail to for Unsubscribed User Exception: " + e.getMessage());
                }
                user = null;
            }

            log.info("[sendMail()] Mail To List......." + mailToList);
            System.out.println("[sendMail()] Mail To List......." + mailToList);

            if (!mailToList.equals(CommentsConstants.BLANK))
            {
                StringTokenizer stNames = new StringTokenizer(mailToList, CommentsConstants.COMMA);
                String mailTo = CommentsConstants.BLANK;
                while (stNames.hasMoreTokens())
                {
                    mailTo = stNames.nextToken();
                    if (mailData.getMailAction().equalsIgnoreCase(CommentsConstants.EMAIL_UNSUBSCRIBE_ACTION))
                    {
                        
                        email.addTo(mailTo);
                        
                    }
                    else  
                    {
                        
                        email.addBcc(mailTo);
                    }
                }
            } 
           
            
            //Setting Mail From.
            email.setFrom(PropertiesLoader.getProperty(CommentsConstants.SENDER_EMAIL_ADDRESS), PropertiesLoader.getProperty(CommentsConstants.SENDER_NAME));

            //Setting Mail Subject.
            email.setSubject(PropertiesLoader.getProperty(CommentsConstants.ADD_EMAIL_SUBJECT) + pageTitle);
            String mailBody = composeEmailBody(mailData);
            //String mailBody = URLEncoder.encode(composeEmailBody(mailData),"utf-8");
            
            //email.setContent(mailBody,"text/plain; charset=utf-8");
            //email.updateContentType("text/plain; charset=utf-8");
            
            email.setHtmlMsg(mailBody);
            email.addReplyTo(PropertiesLoader.getProperty(CommentsConstants.SENDER_EMAIL_ADDRESS), PropertiesLoader.getProperty(CommentsConstants.SENDER_NAME));

            Date sentDate = new Date();
            email.setSentDate(sentDate);
            log.info("[sendMail()] Before Sending MaiL Mail To List......." + mailToList);

            mailService.sendEmail(email);
            mailSent = true;
            log.error("[sendMail()] Mail Sent Successfully from EmailManager...");
            System.out.println("[sendMail()] Mail Sent Successfully from EmailManager...");
        }
        catch (Exception e)
        {
            log.error("[sendMail()] Mail Not Sent...", e);
            mailSent = false;
        }
        return mailSent;
    }
    
    /**
     * This method returns the UserManager Object
     * @return UserManager
     */
    private UserManager getUserManager()
    {
        try
        {
            UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
            Session jcrSession = resolver.adaptTo(Session.class);
            UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
            return uMgr;
        }
        catch (Exception e)
        {
            log.error("[getUserManager()] Exception: "+e.getMessage());
            return null;
        }
    }
}