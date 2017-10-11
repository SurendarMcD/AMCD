<%--

  Comment Replies component.

 

--%><%@ page import="org.apache.sling.api.scripting.SlingBindings,
                     org.apache.sling.api.scripting.SlingScriptHelper,
                     com.mcd.accessmcd.comments.util.NodeUtility,
                     com.day.cq.wcm.api.WCMMode,
                     com.day.cq.wcm.foundation.TextFormat,
                     com.day.cq.wcm.api.designer.Style,
                     java.util.List,java.util.Date,
                     java.text.DateFormat,java.util.TimeZone,java.util.Locale,
                     com.day.cq.security.UserManagerFactory,
                     com.day.cq.security.UserManager,
                     com.day.cq.security.User,
                     org.apache.jackrabbit.api.security.user.*,
                     com.day.cq.commons.jcr.*,
                     com.mcd.accessmcd.comments.util.UserDetails,
                     com.mcd.accessmcd.comments.util.CommonUtilities,
                     com.mcd.accessmcd.comments.constants.CommentsConstants,
                     java.util.*,
                     org.apache.sling.api.resource.Resource,
                     javax.jcr.Node,
                     com.day.cq.security.Group,
                     javax.jcr.Session,
                     javax.jcr.*,
                     org.apache.sling.api.resource.ResourceResolver,
                     com.day.cq.commons.jcr.JcrUtil
                     " %><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page session="false" %><%
%>

<%
    // Retrieve the Comment Node and its properties

    NodeUtility nodeUtil = new NodeUtility(resource);
    String commentId = currentNode.getName();
    String commentPath = currentNode.getPath();
    String comment = properties.get("jcr:description","");
    String replStatus = properties.get("cq:lastReplicationAction","");
    String commentAuthor = properties.get("userIdentifier","Anonymous");
        
    Date commentDate = (Date)properties.get("added", properties.get("jcr:created", new Date(resource.getResourceMetadata().getCreationTime())));
    
    String disableClass = "";
    String disableStatement = "";
    if(WCMMode.fromRequest(request) == WCMMode.EDIT || WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.PREVIEW){
        if("Deactivate".equalsIgnoreCase(replStatus)){
            disableClass = "disablebgcolor";
            disableStatement = "<h2><I><font color='#CE0000'>[" + langText.get("DISABLED") + "]</font></I></h2>&nbsp;";
        }    
    }         
          
    // Retrieve the comment replies and the total reply count
    List<Node> replyList = nodeUtil.getReferredNodeList();
    List<Node> replyChildList = nodeUtil.getChildNodeList(currentNode);
    int replyCount = 0;
   
    if(null != replyChildList ) {
        replyCount = replyChildList.size();
    }
   
  
    // Retrieve the comment author properties
   
    String authorName = "";
    String authorEmail = "";
    log.info("********** Comment Author **********" + commentAuthor); 
    Map<String, String> userDetailsMap = UserDetails.getUserPropertiesFromLDAP(commentAuthor);
    log.info("************ User Detail Map **********" + userDetailsMap );
    if(userDetailsMap == null)
    {
        UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
        Session jcrSession = slingRequest.getResource().getResourceResolver().adaptTo(Session.class);
        UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
        User user = (User) uMgr.get(commentAuthor);
        if (user != null)
        {
            if (null != user.getProperty("rep:e-mail"))
                authorEmail = user.getProperty("rep:e-mail");
            if (user.getProperty("rep:fullname") == null)
                authorName = user.getID()==null? "" : user.getID();
            else
            {
                authorName = user.getProperty("rep:fullname") == null? "" : user.getProperty("rep:fullname");
                authorName = CommonUtilities.capitalizeFirstLetters(authorName.toLowerCase());
            }
        }
        user = null;
        log.info("************ Author Name **********" + authorName ); 
        log.info("************ Author Email **********" + authorEmail );
    }
    else
    { 
        authorName = userDetailsMap.get(CommentsConstants.FULLNAME);
        authorName = CommonUtilities.capitalizeFirstLetters(authorName.toLowerCase());
        authorEmail = userDetailsMap.get(CommentsConstants.MAIL);
    }
        // Convert the time in UST timezone
    TimeZone tz = TimeZone.getTimeZone("CST");
    DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, Locale.US);
    formatter.setTimeZone(tz);
    String formattedDate = formatter.format(commentDate); 
   
    // Retrieve properties from style
    Style commentStyle = (Style) request.getAttribute("commentStyle");
    String replyText = commentStyle.get("reply_text",langText.get("Reply"));
   
   // code added for like button functionality
    long likeCountNum = 0;
    
    if(currentNode.hasNode("like"))
    {
        String likePath = currentNode.getPath()+"/like";
        Node nodeLike = resourceResolver.getResource(likePath).adaptTo(Node.class);
        if(nodeLike.hasProperty("likecounts"))
        {
         likeCountNum = nodeLike.getProperty("likecounts").getLong();
         
        }
       
    }
    
   
  %> 
 
    <div class="graybgcolor topborder padding7px">
        <em><strong>
            <a class="commentAuthorLink" href="mailto:<%=authorEmail%>"><%= authorName %></a>
        </strong></em>
        <abbr class="timeago" title="<%=formattedDate %>"><%=formattedDate %></abbr>
    </div>  
       
    <div class="comment_desc padding7px <%=disableClass%>"> 
      <%=disableStatement%>
      <%
       //     comment = comment.replaceAll("<","&lt;"); 
      //      comment = comment.replaceAll(">","&gt;");
      %>
      
      <%= comment %>
    </div>
       
    <div class="reply_section" id="reply_section_<%=commentId%>">
       
        <div class="replydiv" > 
        
        <span class="replyCountNumber"><%=replyCount%></span> <span class="replyCountText"><%= replyCount == 1 ? langText.get("Reply") : langText.get("Replies") %></span> : <a href="#reply_section_<%=commentId%>" title="Reply" onClick="javascript:showCommentForm('replyForm_<%=commentId%>', true);"><%=replyText%></a>
        &nbsp;&nbsp;&nbsp;
        <% if (currentPage.getPath().contains("na/mcweb/fr") ) { %>
        <% if(likeCountNum!=0){%>     
        <form  action="javascript:getUser('<%=commentPath%>','<%=commentId%>');" method="POST" name="commentForm" style="display:inline-block; padding-left:7px;">
        <input id="ui-reply-img" class="reply-img_fr" onmouseover="checkUser(this,'<%=commentPath%>')" onmouseout="checkUsers(this)" type="submit" name="Submit" value="" >
        <span class="reply-smile-img" id="displayCount_<%=commentId%>"><%=likeCountNum%></span> 
        </form>
         <%} else if (likeCountNum==0){%>
        <form    action="javascript:getUser('<%=commentPath%>','<%=commentId%>');" method="POST" name="commentForm" style="display:inline-block; padding-left:7px;">
        <input id="ui-reply-img" class="reply-img_fr" onmouseover="checkUser(this,'<%=commentPath%>')" onmouseout="checkUsers(this)" type="submit" name="Submit" value="" >
        <span id="displayCount_<%=commentId%>"></span>
        </form>         
         <%}%>
          <% } else { %>
          <% if(likeCountNum!=0){%>     
        <form  action="javascript:getUser('<%=commentPath%>','<%=commentId%>');" method="POST" name="commentForm" style="display:inline-block; padding-left:7px;">
        <input id="ui-reply-img" class="reply-img" onmouseover="checkUser(this,'<%=commentPath%>')" onmouseout="checkUsers(this)" type="submit" name="Submit" value="" >
        <span class="reply-smile-img" id="displayCount_<%=commentId%>"><%=likeCountNum%></span> 
        </form>
         <%} else if (likeCountNum==0){%>
        <form    action="javascript:getUser('<%=commentPath%>','<%=commentId%>');" method="POST" name="commentForm" style="display:inline-block; padding-left:7px;">
        <input id="ui-reply-img" class="reply-img" onmouseover="checkUser(this,'<%=commentPath%>')" onmouseout="checkUsers(this)" type="submit" name="Submit" value="" >
        <span id="displayCount_<%=commentId%>"></span>
        </form> 
          
           <% }%> 
          <% }%> 
            <div class="margintop commentFormDiv" id="replyForm_<%=commentId%>" style="display:none;"> 
            <cq:include script="/apps/mcd/components/content/pagecommenting/pagecommentingform.jsp" /> 
        </div> 
        
        <div style="padding-top:5px;"></div>
    <%
        if (replyCount > 0) {
            for (Node replyNode : replyList) {
                if(replyNode.getName().equals("like")) {
              // do nothing
                }else{   %>          
                 <cq:include path="<%=replyNode.getPath()%>" resourceType="mcd/components/content/pagecommenting/replies" /><%    
                }
            }
       }     
    %>
        
    </div> 
</div>
 
