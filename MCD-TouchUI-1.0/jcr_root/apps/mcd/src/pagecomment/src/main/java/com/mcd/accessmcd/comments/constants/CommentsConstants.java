/*
 * Project: AccessMCD
 *
 * @(#)CommentsConstants.java
 * Revisions:
 * Date            Programmer           Description
 * --------------------------------------------------------------------------------------------
 * 27,April 2011   HCL                  This Class contains the constant variables used in
 *                                      comments component.
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

package com.mcd.accessmcd.comments.constants;

/**
 * @author HCL
 * @version 1.0
 * @since 1.0
 */
public class CommentsConstants
{
    //Properties File
    public static final String PROPERTY_FILE_NAME = "comments.properties";
   
    //Symbols
    public static final String UNDERSCORE = "_";
    public static final String BLANK = "";
    public static final String COMMA = ",";
    public static final String QUESTIONMARK = "?";
    public static final String SLASH = "/"; 
    public static final String TRUE = "true";
    
    public static final String COMMENT_PAGE_PATH = "commentpagepath";
    public static final String COMMENTS_PAGE_PATH = "commentsPagePath";
    public static final String COMMENT_COMPONENT_PATH = "commentcomponentpath";
    public static final String LIKE_NODE = "like";
    public static final String LIKE_PAGE_PATH = "likepagepath";
    public static final String LIKES_PAGE__PATH = "likesPagePath";
    public static final String LIKE_COMPONENT_PATH = "likecomponentpath";
    public static final String ADD_COMMENT_EMAIL_CONTENT = "addcommentemailcontent";
    public static final String UNSUBSCRIBE_EMAIL_CONTENT = "unsubscribeemailcontent";
    public static final String SENDER_EMAIL_ADDRESS = "fromEmailAddress";
    public static final String SENDER_NAME = "sendername";
    public static final String COMMENT_NODE_TYPE = "cq:Comment";
    public static final String PAGE_NODE_TYPE = "cq:Page";
    public static final String GENERAL_NODE_TYPE = "nt:unstructured";  
    public static final String REFERER = "referer";
    public static final String RUN_MODES = "run.modes";
    public static final String NULL = "NULL";
    public static final String JCR_CONTENT = "jcr:content";
    public static final String JCR_CONTENT_PATH = "/jcr:content/";
    public static final String SLING_FOLDER = "sling:Folder";
    public static final String USER_IDENTIFIER = "userIdentifier";
    public static final String LIKE_IDENTIFIER ="likeIdentifier";
    public static final String LIKE_COUNT="likecounts";
    public static final String JCR_CREATED = "jcr:created";
    public static final String JCR_DESCRIPTION = "jcr:description";
    public static final String EXTN_HTML = ".html";
    public static final String EXTN_UNSUBSCRIBE_HTML = ".unsubscribe.html";
    public static final String ADD_NODE = "add_node";
    public static final String ADD_NODE_PATH = SLASH + UNDERSCORE + ADD_NODE + SLASH;;
    public static final String SELECTOR_ADD_COMMENT = "addComment";
    public static final String SELECTOR_LIKE_COMMENT = "likeComments";
    public static final String SELECTOR_LIKE_PAGE = "likePage";  
    public static final String SELECTOR_SUBSCRIBE_USER = "subscribeUser";
    public static final String SELECTOR_UNSUBSCRIBE_USER = "unsubscribeUser";
    public static final String SLING_RES_TYPE = "sling:resourceType";
    public static final String CQ_DISTRIBUTE = "cq:distribute";
    public static final String IP = "ip";
    public static final String USER_AGENT = "userAgent";
    public static final String PROP_LAST_MODIFIED = "cq:lastModified";
    public static final String PROP_LAST_MODIFIED_BY = "cq:lastModifiedBy";
    public static final String CONTENT = "content";
    public static final String LAST_REPLICATION_ACTION = "cq:lastReplicationAction";
    public static final String DEACTIVATE = "Deactivate";
    
    public static final String PROP_ADDED = "added"; 
    public static final String REQUEST_REFERER = "Referer";
    public static final String REQUEST_AUTHORID = "authorId";
    public static final String REQUEST_COMMENT_DESC = "comment_description";
    public static final String REQUEST_USER_AGENT = "User-Agent";
    public static final String PROP_MODIFIED = "modified";
    
    public static final String EMAIL_ADD_ACTION = "Added";
    public static final String EMAIL_UNSUBSCRIBE_ACTION = "Unsubscribed";
    public static final String UNSUBSCRIBE_USER_PROPERTY = "unsubscribedUser";
    public static final String SUBSCRIBED_USERS_NODE = "SubscribedUsers";
    public static final String DEFAULT_USERS_NODE = "DefaultUsers";
    
    // DEV/Staging LDAP details
    public static final String LDAP_INITIAL_CONTEXT_FACTORY = "ldapinitialcontextfactory";
    public static final String LDAP_PROVIDER_URL = "ldapproviderurl";
    public static final String LDAP_SECURITY_PRINCIPAL = "ldapsecurityprincipal";
    public static final String LDAP_SECURITY_CREDENTIALS = "ldapsecuritycredentials"; 
    
    // Time interval in Email
    public static final String AGO = " ago.";
    public static final String A = " a ";
    public static final String MINUTE = " min";
    public static final String MINUTES = " mins";
    public static final String SECOND = " sec";
    public static final String SECONDS = " sec";
    public static final String ABOUT = " about";

    
    //User properties
    public static final String USER_EMAIL = "rep:e-mail";
    public static final String USER_FULLNAME = "rep:fullname";
    public static final String FULLNAME = "fullName";
    public static final String MAIL = "mail";

    //Judy, ADFS, 09/2011
//    public static final String UID = "uid";
    public static final String UID = "samAccountName";
    
    public static final String USERID = "userId";
    public static final String COMMENTNODE = "cn";
    
    //Mail Properties
    public static final String PROP_PAGE_TITLE = "PAGE_TITLE";
    public static final String PROP_COMMENT_BODY = "COMMENT_BODY";
    public static final String PROP_COMMENT_URL = "COMMENT_URL"; 
    public static final String PROP_MAIL_TO_LINK = "MAIL_TO_LINK";
    public static final String MAIL_TO = "mailto:";
    public static final String PROP_COMMENT_BY = "COMMENT_BY";
    public static final String PROP_LAST_UPDATED = "LAST_UPDATED";
    public static final String PROP_UNSUBSCRIBE_URL = "UNSUBSCRIBE_URL" ;
    public static final String ADD_EMAIL_SUBJECT = "addEmailSubject";

} 
