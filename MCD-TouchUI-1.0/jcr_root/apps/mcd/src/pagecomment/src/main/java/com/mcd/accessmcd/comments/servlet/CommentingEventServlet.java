/*
 * Project: AccessMCD
 *
 * @(#)CommentingEventServlet.java
 * Revisions:
 * Date            Programmer           Description
 * --------------------------------------------------------------------------------------------
 * 27,April 2011   HCL                  This Servlet Class calls the methods to create,
 *                                      subscribe and unsubscribe the user to/from the comment.
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
 
package com.mcd.accessmcd.comments.servlet;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.text.DateFormat;
import java.util.TimeZone;
import java.util.Locale;
import java.util.Map;
import javax.jcr.Node;
import javax.jcr.Session;
import javax.servlet.ServletException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.osgi.service.component.ComponentContext;
import org.osgi.framework.BundleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.runmode.RunMode; 
import com.mcd.accessmcd.comments.util.NodeUtility; 
import com.mcd.accessmcd.comments.constants.CommentsConstants;
import com.mcd.accessmcd.comments.util.PropertiesLoader;
import com.mcd.accessmcd.comments.util.UserDetails;
import com.mcd.accessmcd.comments.util.CommonUtilities;
import com.day.cq.commons.jcr.JcrUtil;
import javax.jcr.Value; 
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.net.URLDecoder; 
import org.apache.commons.lang.StringEscapeUtils;
import javax.servlet.Servlet;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="Calendar Servlet"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.resourceTypes", value={ "mcd/components/content/pagecommenting","mcd/components/content/pagecommenting/replies" }),
    @Property(name = "sling.servlet.selectors", value={ "addComment","subscribeUser","unsubscribeUser" }),
    @Property(name = "sling.servlet.methods", value="POST")
})

@SuppressWarnings("serial")

public class CommentingEventServlet extends SlingAllMethodsServlet
{
    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(CommentingEventServlet.class);
    
    @Reference
    private RunMode runMode;

    @Reference
    private SlingRepository repository;
    private BundleContext bundleContext;
    
    @Reference 
    private JcrResourceResolverFactory resolverFactory;
    
    NodeUtility nodeUtility;    
    protected Session session = null;
    private ResourceResolver resourceResolver = null;
    
    /**
     * This method is called when the bundle for this service is deployed in the CRX.
     * @param context
     * @throws Exception
     */
    protected void activate(ComponentContext ctx) throws Exception
    {
        bundleContext = ctx.getBundleContext();
    }
    /**
     * This method is called when the bundle for this service is removed from the CRX.
     * @param context
     */
    protected void deactivate(ComponentContext context)
    {
        if(session != null)
                session.logout(); 
                session = null;
    }
     
    /**
     * The doPost method of the servlet. <br>
     *
     * This method is called when a form has its tag value method equals to post.
     * 
     * @param request the request send by the client to the server
     * @param response the response send by the server to the client
     * @throws ServletException if an error occurred
     * @throws IOException if an error occurred
     */
    @Override
    public void doPost(SlingHttpServletRequest request, SlingHttpServletResponse response) throws ServletException, IOException
    {
        boolean hasPermission = false;
        String redirectUrl = null;
        Resource resource = null;
        String resourcePath = null;
        String contentType = null;
        
        try{
            session = repository.loginAdministrative(null);
            log.info("****** Session Object ****** ::: " + session ); 
            resourceResolver = resolverFactory.getResourceResolver(session); 
            log.info("****** ResourceResolver Object ****** ::: " + resourceResolver );
             
            resource = resourceResolver.getResource(request.getResource().getPath());
            resourcePath = resource.getPath();
            log.error("********************** Resource Path ::::::::::::::: " + resourcePath);
            if (resource != null)
            {
                try
                {
                    if(session == null)
                    {
                        log.error("[doPost()] session is null");
                        hasPermission = false;
                    }
                    
                    log.error("******************NODE VALUE*******************"+(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH))+(CommentsConstants.ADD_NODE_PATH)+ (System.currentTimeMillis()));
                    session.checkPermission((PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)) + (CommentsConstants.ADD_NODE_PATH) + (System.currentTimeMillis()), CommentsConstants.ADD_NODE);
                    hasPermission = true;
                }
                catch(Exception e)
                {
                    log.error("[doPost()] "+(("user '") + (session.getUserID()) + ("' not allowed to add nodes under ")+ (CommentsConstants.COMMENT_PAGE_PATH)), e);
                    hasPermission = false;
                }
            }
            
            if (hasPermission)
            {
                log.error("***************************INSIDE SERVLET******************************");
                nodeUtility = new NodeUtility(resource);
                String[] selectors = request.getRequestPathInfo().getSelectors();
                log.info("[doPost()] selectors[0]: "+selectors[0]);
                if(null != selectors)
                {
                    if(selectors[0].equalsIgnoreCase(CommentsConstants.SELECTOR_ADD_COMMENT))
                    {
                        String[] returnVal = addComment(request);
                        contentType = returnVal[0];
                        log.error("*******************ContentType***************"+contentType);
                        redirectUrl = returnVal[1];
                        log.error("*******************Redirect URL***************"+redirectUrl);
                    }
                    else if(selectors[0].equalsIgnoreCase(CommentsConstants.SELECTOR_SUBSCRIBE_USER))
                    {
                        redirectUrl = subscribeUser(request);
                        contentType = "url";
                    }
                    else if(selectors[0].equalsIgnoreCase(CommentsConstants.SELECTOR_UNSUBSCRIBE_USER))
                    {
                        redirectUrl = unSubscribeUser(request);
                        contentType = "url";
                    }
                }
            } 
            else 
            {
                redirectUrl = resourcePath;
                contentType = "url"; 
            }
        }
        catch(Exception ex){
            log.error("***** Error in CommentingEventingServlet doPost method *****",ex);
        }
        finally{
            if(session != null)
                session.logout();
                session = null;
        }  
        if("content".equals(contentType)) {
            log.error("*************If*************************");
            response.setContentType("text/html; charset=UTF-8");
            response.setStatus(200);
            PrintWriter out = response.getWriter();
            out.println(redirectUrl);
        } else {
            log.error("*************Error*************************");
            response.sendRedirect(redirectUrl.replace("/content/","/"));
        }
        
    }

    /**
     * This method is called when a user creates a comment on a page.
     * @param request
     * @param response
     */
    public String[] addComment(SlingHttpServletRequest request) throws IOException
    {
        log.error("********************INSIDE ADD COMMENT***********************");
        Node commentNode;
        String redirectUrl = (request.getHeader("Referer").indexOf("?")==-1)? request.getHeader("Referer") : request.getHeader("Referer").substring(0,request.getHeader("Referer").indexOf("?"));
        log.error("*******************Redirect URL in Add Comment***************************"+redirectUrl);
        String nodeContent = CommentsConstants.BLANK;
        log.error("request.getHeader(CommentsConstants.REQUEST_REFERER---1111111111---->"+request.getHeader(CommentsConstants.REQUEST_REFERER));
        try
        {
            log.error("********************BEFORE CREATE NODE PATH*********123**************");
            nodeUtility.createNodePath(request.getHeader(CommentsConstants.REQUEST_REFERER));
            log.error("********************AFTER CREATE NODE PATH***********************");
            String authorId = CommentsConstants.BLANK;
            if (null != request.getParameter(CommentsConstants.REQUEST_AUTHORID))
            {
                authorId = (String) request.getParameter(CommentsConstants.REQUEST_AUTHORID);
               
            }
            log.error("[addComment()] Comment Author: "+authorId);
            
            String message = CommentsConstants.BLANK;
            String nodeName = CommentsConstants.BLANK;
            String className = CommentsConstants.BLANK;
            if (request.getParameter(CommentsConstants.REQUEST_COMMENT_DESC) != null)
            {
                message = URLDecoder.decode(URLEncoder.encode((String)request.getParameter(CommentsConstants.REQUEST_COMMENT_DESC),"UTF-8"),"UTF-8");
                message = message.replaceAll("\n","<br>");
                
            }
            nodeName = String.valueOf(System.currentTimeMillis());

            message = linkifyCommentText(message); 
            
            String designPath = CommentsConstants.BLANK;
            if (request.getParameter("designPath") != null)
            {
                designPath = (String)request.getParameter("designPath");
            }
           
            if(!nodeUtility.getReferredNode().hasNode(JcrUtil.createValidName(nodeName)))                  
            {
             commentNode = nodeUtility.getReferredNode().addNode(JcrUtil.createValidName(nodeName), CommentsConstants.COMMENT_NODE_TYPE);
                     
            if(commentNode != null)
             {                    
                commentNode.setProperty(CommentsConstants.PROP_ADDED, Calendar.getInstance()); 
                commentNode.setProperty(CommentsConstants.SLING_RES_TYPE, PropertiesLoader.getProperty(CommentsConstants.COMMENT_COMPONENT_PATH));
                commentNode.setProperty(CommentsConstants.JCR_DESCRIPTION, new String(message.getBytes("8859_1"),"UTF8"));
                commentNode.setProperty(CommentsConstants.USER_IDENTIFIER, authorId);
                
                log.error("******************** Setting Node Properties ---------------------- " + commentNode);
                commentNode.setProperty(CommentsConstants.CQ_DISTRIBUTE, true); 
                log.error("****************** Getting Referrer -------------------- " + request.getHeader(CommentsConstants.REQUEST_REFERER));
                commentNode.setProperty(CommentsConstants.REFERER, request.getHeader(CommentsConstants.REQUEST_REFERER));
                log.error("****************** Getting RootNode -------------------- " + nodeUtility.getRootNode());
                Node content = nodeUtility.getRootNode().getParent();
                log.error("****************** Getting RootNode -------------------- " + nodeUtility.getRootNode().getParent());
                content.setProperty(CommentsConstants.PROP_LAST_MODIFIED, Calendar.getInstance());
                content.setProperty(CommentsConstants.PROP_LAST_MODIFIED_BY, content.getSession().getUserID());
            }
            else
            {
                log.error("[createComment()] Failed to create Node.");
                return new String[]{"url",redirectUrl};
            }
           }
           else
            {
                log.error("[createComment()] Same Node Exist.");
                return new String[]{"url",redirectUrl};
            }
            //redirectUrl += "?comment_added=" + JcrUtil.createValidName(nodeName);
            log.error("commentnode---->"+commentNode);
            
            String contentNode = nodeUtility.getRootNode().toString();
             log.error("contentNode---->"+contentNode);
           if (contentNode.contains("na/mcweb/fr")) {
            className = "reply-img_fr";
            }
            else{
            className ="reply-img";
            }
            nodeContent = getCommentHTML(commentNode, authorId, message, designPath,className);
            
            log.error("nodeContent----->"+nodeContent);
            session.save();
        }
        catch (Exception e)
        {
            log.error("addComment failed to add the comment ", e);
            return new String[]{"url",redirectUrl};
        }
        log.error("******************* Comment Added Successfully* ************************* ");
        return new String[]{"content",nodeContent};
    }
     
    /**
     * This method is called to convert comment text into link.
     * @param messge
     */
    public String linkifyCommentText(String message)
    {
            try {
                    Pattern patt = Pattern.compile("(?i)\\b((?:https?://|www\\d{0,3}[.]|[a-z0-9.\\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:\'\".,<>???“”‘’]))");
                    Matcher matcher = patt.matcher(message);    
                    if(matcher.find()){
                        if (matcher.group(1).startsWith("http://") || matcher.group(1).startsWith("https://")){
                            return matcher.replaceAll("<a target='_blank' href=\"$1\">$1</a>");
                        }else{
                            return matcher.replaceAll("<a target='_blank' href=\"http://$1\">$1</a>");
                        }   
                    }else{
                        return message;
                    } 

            } catch (Exception e) {
               log.error("*********** Error Occurred In Linkifying Text *************",e);
               return message;
            }   
    }    
    
    public String getCommentHTML(Node commentNode, String authorId, String message, String designPath, String className) throws Exception {
        StringBuilder commentHTML = new StringBuilder();       
        if(commentNode != null) {
            Date commentDate = commentNode.getProperty(CommentsConstants.JCR_CREATED).getDate().getTime();
            TimeZone tz = TimeZone.getTimeZone("CST");
            DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, Locale.US);
            formatter.setTimeZone(tz);
            String formattedDate = formatter.format(commentDate);
         //   message = message.replaceAll("<","&lt;"); 
          //  message = message.replaceAll(">","&gt;");
            String authorName = authorId;
            String authorEmail = CommentsConstants.BLANK;
            Map<String, String> userDetailsMap = UserDetails.getUserPropertiesFromLDAP(authorId);
            if(userDetailsMap != null){
                authorName = userDetailsMap.get(CommentsConstants.FULLNAME);
                authorEmail = userDetailsMap.get(CommentsConstants.MAIL);
            }
            
            if(commentNode.getParent().getName().equals("pagecommenting")) {
                commentHTML.append("<div class=\"margintop\">");
                commentHTML.append("<div class=\"parbase replies " + commentNode.getName() + "\">");
            }
            
            commentHTML.append("<div class=\"graybgcolor topborder padding7px\">");
            commentHTML.append("<em><strong>");
            commentHTML.append("<a href=\"mailto:" + authorEmail + "\">" + authorName + "</a>");
            commentHTML.append("</strong></em>");
            commentHTML.append("&nbsp;&nbsp;<abbr title=\"" + formattedDate + "\" class=\"timeago\">" + formattedDate + "</abbr></div>");
            
            commentHTML.append("<div class=\"comment_desc padding7px \"> " + message + "</div>"); 
            commentHTML.append("<div id=\"reply_section_" + commentNode.getName() + "\" class=\"reply_section\">");
            commentHTML.append("<div class=\"replydiv\"> ");
            commentHTML.append("<span class=\"replyCountNumber\">0</span> <span class=\"replyCountText\">Replies</span> : <a onclick=\"javascript:showCommentForm('replyForm_" + commentNode.getName() + "',true);\" title=\"Reply\" href=\"#reply_section_" + commentNode.getName() + "\">Reply</a>");
            commentHTML.append("&nbsp;&nbsp;&nbsp;<form  action=\"javascript:getUser('"+commentNode.getPath()+"','"+commentNode.getName()+"');\" method=\"POST\" name=\"commentForm\" style=\"display:inline-block; padding-left:7px;\"><input  id=\"ui-reply-img\" class=\""+className+"\" *position:relative; *top:6px;\" onmouseover=\"checkUser(this,'"+commentNode.getPath()+"')\" onmouseout=\"checkUsers(this)\" type=\"submit\" class=\"button\" value=\"\" id=\"Submit\" name=\"Submit\" >&nbsp;&nbsp;&nbsp;<span id=\"displayCount_"+commentNode.getName() + "\"></span></form>");
            commentHTML.append("<div style=\"display: none;\" id=\"replyForm_" + commentNode.getName() + "\" class=\"margintop commentFormDiv\"> ");
                                                                                                                   
            commentHTML.append("<div class=\"headertxt\"><img height=\"22\" align=\"absmiddle\" width=\"27\" src=\""+designPath+"/images/comment-icon.jpg\"> Add a Comment</div>");
            commentHTML.append("<form id=\"" + commentNode.getName() + "_form\" name=\"commentForm\" method=\"POST\" action=\"javascript:submitCommentForm('" + commentNode.getPath() + ".addComment.html','" + commentNode.getName() + "_form','Please enter comments before submitting.');\"> ");
            commentHTML.append("<div class=\"grayborder padding7px\">");
            commentHTML.append("<label>");
            commentHTML.append("<textarea onkeyup=\"displayLimit('" + commentNode.getName() + "_form',2000);\" onkeydown=\"displayLimit('" + commentNode.getName() + "_form',2000);\"  id=\"comment_description\" class=\"textarea\" rows=\"5\" cols=\"45\" name=\"comment_description\"></textarea>");
            commentHTML.append("<span><span id=\"" + commentNode.getName() + "_form_remLen\"> 2000 </span> &nbsp;characters remaining on your input limit </span>");
            commentHTML.append("</label>");
            commentHTML.append("<div style=\"margin-top: 7px; float: right;\">");
            commentHTML.append("<label>");
            commentHTML.append("<input type=\"submit\" class=\"button\" value=\"Submit\" id=\"Submit\" name=\"Submit\">");
            commentHTML.append("</label>");
            commentHTML.append("</div>");
            commentHTML.append("<div class=\"clear\"></div>");
            commentHTML.append("</div>");
            commentHTML.append("<input type=\"hidden\" value=\"admin\" name=\"authorId\">");
            commentHTML.append("</form>");
            
            commentHTML.append("</div>");
            commentHTML.append("<div style=\"padding-top:5px;\"></div>");
            commentHTML.append("</div>");
            commentHTML.append("</div>");
            if(commentNode.getParent().getName().equals("pagecommenting")) {
                commentHTML.append("</div></div>");
            }
        }
        return commentHTML.toString();
    }
    
    /**
     * This method is called when a user subscribes for a comment in a page.
     * @param request
     * @param response
     */
    @SuppressWarnings("deprecation")
    public String subscribeUser(SlingHttpServletRequest request)
    {
        
        int returnValue = 0;        
        String eid = CommentsConstants.BLANK;
        String url = CommentsConstants.BLANK;
        String pagePath = CommentsConstants.BLANK;
        Node subscribersNode;
        
        try {
            String referer = request.getHeader(CommentsConstants.REQUEST_REFERER);
            nodeUtility.createNodePath(referer);
            Node commentNode = nodeUtility.getReferredNode();
            Node subscriberPageNode = commentNode.getParent().getParent();
            pagePath = subscriberPageNode.getPath().replace(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH),CommentsConstants.BLANK);
            String subscribersNodePath = subscriberPageNode.getPath() + CommentsConstants.SLASH  + subscriberPageNode.getName() + CommentsConstants.UNDERSCORE + commentNode.getName()+ CommentsConstants.SLASH + CommentsConstants.JCR_CONTENT;
            Resource subscribersRes = resourceResolver.getResource(subscribersNodePath);
            if(null != subscribersRes) {
                subscribersNode = subscribersRes.adaptTo(Node.class);
            } else {
                Node subPageNode = subscriberPageNode.addNode(subscriberPageNode.getName() + CommentsConstants.UNDERSCORE + commentNode.getName(), CommentsConstants.PAGE_NODE_TYPE); 
                subscribersNode = subPageNode.addNode(CommentsConstants.JCR_CONTENT, CommentsConstants.GENERAL_NODE_TYPE);
                subscribersNode.setProperty(CommentsConstants.COMMENTS_PAGE_PATH, pagePath); 
                subscribersNode.setProperty(CommentsConstants.REFERER, (referer.indexOf(CommentsConstants.QUESTIONMARK)==-1 ? referer : referer.substring(0,referer.indexOf(CommentsConstants.QUESTIONMARK))));
                session.save();
            }
            url = subscribersNode.hasProperty(CommentsConstants.COMMENTS_PAGE_PATH) ? subscribersNode.getProperty(CommentsConstants.COMMENTS_PAGE_PATH).getValue().getString() : pagePath;
            url +=  ".html?subscribeStatus=";
            
            if(null != request.getParameter(CommentsConstants.REQUEST_AUTHORID)) {
                eid = (String)request.getParameter(CommentsConstants.REQUEST_AUTHORID);
            }
            log.info("[subscribeUser()] EID: "+eid);
            if(!CommentsConstants.BLANK.equals(eid))
            {
                String[] subscribedUsers = null;
                if(subscribersNode.hasProperty(CommentsConstants.SUBSCRIBED_USERS_NODE))
                {
                    log.info("[subscribeUser()] SubscribedUsers Property available.");
                    Value[] values = subscribersNode.getProperty(CommentsConstants.SUBSCRIBED_USERS_NODE).getValues();
                    subscribedUsers = new String[values.length+1];
                    int i = 0;
                    for(; i < values.length ; i++)
                    {
                        if(values[i].getString().equalsIgnoreCase(eid))
                        {
                            returnValue = 1;
                            break;
                        }
                        subscribedUsers[i] = values[i].getString();
                    }
                    subscribedUsers[i] = eid;
                    if(returnValue == 0)
                    {   
                        subscribersNode.getProperty(CommentsConstants.SUBSCRIBED_USERS_NODE).setValue(subscribedUsers);
                        returnValue = 0;
                    }               
                    log.info("[subscribeUser()] No of Subscribed Users: "+subscribedUsers.length);
                }
                else
                {
                    log.info("[subscribeUser()] SubscribedUsers Property not available.");
                    subscribedUsers = new String[1];
                    subscribedUsers[0] = eid;
                    subscribersNode.setProperty(CommentsConstants.SUBSCRIBED_USERS_NODE, subscribedUsers);
                    returnValue = 0;
                }
                
                if(returnValue == 0) {
                    subscribersNode.setProperty(CommentsConstants.CQ_DISTRIBUTE,true);
                    subscribersNode.setProperty(CommentsConstants.PROP_MODIFIED,CommentsConstants.TRUE);
                    subscribersNode.setProperty(CommentsConstants.PROP_LAST_MODIFIED, Calendar.getInstance());
                    subscribersNode.setProperty(CommentsConstants.PROP_LAST_MODIFIED_BY, subscribersNode.getSession().getUserID());
                }
                
                subscribersNode.save();
    
                log.info("[subscribeUser()] User Subscribed Successfully.");
                
                if (returnValue == 0)
                    log.error("[subscribeUser()] User Subscribed Successfully...");
                else
                    log.error("[subscribeUser()] User Subscription Failed...");
            } else {
                returnValue = 2;
            }
        } catch(Exception e) {
            log.error("[subscribeUser()] : Failed to subscribe user",e);
            returnValue = 2;
        }         
        
        url = !(CommentsConstants.BLANK.equals(url)) ? url + returnValue : CommentsConstants.BLANK;
        log.error("URL ::::::::::::::::: " + url);
        return url;
    } 
    
    /**
     * This method is called when a user unsubscribes from a comment in a page.
     * @param request
     * @param response
     */
    @SuppressWarnings("deprecation")
    public String unSubscribeUser(SlingHttpServletRequest request)
    {
        Node subscribersNode;
        String url = CommentsConstants.BLANK;
        String pagePath = CommentsConstants.BLANK;
        int returnValue = 0;
        
        try {
            String referer = request.getHeader(CommentsConstants.REQUEST_REFERER);
            referer = referer.replaceAll(".unsubscribe", "");
            Node commentNode = nodeUtility.getReferredNode();
            Node subscriberPageNode = commentNode.getParent().getParent();
            pagePath = subscriberPageNode.getPath().replace(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH),CommentsConstants.BLANK);
            String subscribersNodePath = subscriberPageNode.getPath() + CommentsConstants.SLASH + subscriberPageNode.getName() + CommentsConstants.UNDERSCORE + commentNode.getName()+ CommentsConstants.SLASH + CommentsConstants.JCR_CONTENT;;
            subscribersNode = (Node)resourceResolver.getResource(subscribersNodePath).adaptTo(Node.class);
            url = subscribersNode.hasProperty(CommentsConstants.COMMENTS_PAGE_PATH) ? subscribersNode.getProperty(CommentsConstants.COMMENTS_PAGE_PATH).getValue().getString() : pagePath;
            url +=  ".html?unsubscribeStatus=";
            
            String eid = CommentsConstants.BLANK;
            if(null != request.getParameter(CommentsConstants.REQUEST_AUTHORID)) {
                eid = (String)request.getParameter(CommentsConstants.REQUEST_AUTHORID);
            }
            log.info("[unSubscribeUser()] EID: "+eid);
            if(!CommentsConstants.BLANK.equals(eid)) 
            {
                String[] subscribedUsers = null;
                String[] defaultUsers = null;
                
                // Unsubscribe from Subscribed Users List
                if(subscribersNode.hasProperty(CommentsConstants.SUBSCRIBED_USERS_NODE))
                {
                    log.info("[unSubscribeUser()] SubscribedUsers Property available.");
                    Value[] values = subscribersNode.getProperty(CommentsConstants.SUBSCRIBED_USERS_NODE).getValues();
                    subscribedUsers = new String[values.length];
                    boolean containsEID = false;
                    int i = 0;
                    for(; i < values.length ; i++)
                    {
                        if(values[i].getString().equalsIgnoreCase(eid))
                        {
                            containsEID = true;
                        }
                        else
                        {
                            subscribedUsers[i] = values[i].getString();
                        }
                    }
                    if(!containsEID)
                    {
                        log.info("[unSubscribeUser()] User not subscribed.");
                        returnValue = 1;
                    }
                    else
                    {
                        subscribersNode.setProperty(CommentsConstants.SUBSCRIBED_USERS_NODE, subscribedUsers);
                        returnValue = 0;
                    }
                }
                else
                {
                    log.info("[unSubscribeUser()] SubscribedUsers Property not available.");
                    returnValue = 1;
                }
                
                // Unsubscribe from Default Users List
                if(subscribersNode.hasProperty(CommentsConstants.DEFAULT_USERS_NODE))
                {
                    log.info("[unSubscribeUser()] DefaultUsers Property available.");
                    Value[] values = subscribersNode.getProperty(CommentsConstants.DEFAULT_USERS_NODE).getValues();
                    defaultUsers = new String[values.length];
                    boolean containsEID = false;
                    int i = 0;
                    for(; i < values.length ; i++)
                    {
                        if(values[i].getString().equalsIgnoreCase(eid))
                        {
                            containsEID = true;
                        }
                        else
                        {
                            defaultUsers[i] = values[i].getString();
                        }
                    }
                    if(!containsEID)
                    {
                        log.info("[unSubscribeUser()] User is not a default User.");
                    }
                    else
                    {
                        subscribersNode.setProperty(CommentsConstants.DEFAULT_USERS_NODE, defaultUsers);
                        returnValue = 0;
                    }
                }
                else
                {
                    log.info("[unSubscribeUser()] DefaultUsers Property not available.");
                }
                
                if(returnValue == 0) {
                    subscribersNode.setProperty(CommentsConstants.CQ_DISTRIBUTE,true);
                    subscribersNode.setProperty(CommentsConstants.PROP_MODIFIED,CommentsConstants.TRUE);
                    subscribersNode.setProperty(CommentsConstants.PROP_LAST_MODIFIED, Calendar.getInstance());
                    subscribersNode.setProperty(CommentsConstants.PROP_LAST_MODIFIED_BY, eid);
                    subscribersNode.setProperty(CommentsConstants.UNSUBSCRIBE_USER_PROPERTY, eid);
                    subscribersNode.setProperty(CommentsConstants.REFERER, (referer.indexOf(CommentsConstants.QUESTIONMARK)==-1 ? referer : referer.substring(0,referer.indexOf(CommentsConstants.QUESTIONMARK))));
                } 
                subscribersNode.save();
                
                if (returnValue == 0)
                {
                    //sendMail(request, response, eid);
                    log.error("[unSubscribeUser()] User unsubscribed Successfully...");
                }
                else
                    log.error("[unSubscribeUser()] User unsubscription Failed...");
            }
        } catch(Exception e) {
            log.error("[unSubscribeUser()] : Failed to unsubscribe user",e);
        }
        url = !(CommentsConstants.BLANK.equals(url)) ? url + returnValue : CommentsConstants.BLANK; 
        log.error("URL ::::::::::::::::: " + url); 
        return url;
    } 
        
    /**
     * This method initializes the SlingRepository Object.
     * @param repository
     */
    protected void bindRepository(SlingRepository repository)
    {
        this.repository = repository;
    }
    /**
     * This method sets the value of SlingRepository Object to NULL.
     * @param repository
     */
    protected void unbindRepository(SlingRepository repository)
    {
        if(this.repository == repository)
        {
            repository = null;
        }
        if (session.isLive())
                    session.logout();       
        session = null;
    }
    protected void bindResolverFactory(JcrResourceResolverFactory resolverFactory)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.resolverFactory = resolverFactory;
            
    }   
    protected void unbindResolverFactory(JcrResourceResolverFactory resolverFactory)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        resolverFactory = null;
    }
    protected void bindRunMode(RunMode runmode)
    {
        runMode = runmode;        
    }

    protected void unbindRunMode(RunMode runmode)
    {
        if(runMode == runmode)
            runMode = null;
    }
}
 