<%--

  Page Commenting component.
 
  

--%><%
%><%@ page import="com.day.cq.security.User, 
                   com.mcd.accessmcd.comments.util.NodeUtility,
                   java.util.List,
                   com.mcd.accessmcd.comments.constants.CommentsConstants,
                   com.mcd.accessmcd.comments.util.UserDetails,
                   java.util.*,
                   com.day.cq.wcm.api.WCMMode,
                   java.net.*, java.util.Locale,com.day.cq.wcm.api.Page,
      com.day.cq.wcm.api.PageManager" %>      
<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>      
<%@include file="/apps/mcd/global/global.jsp"%><%
response.setHeader("Cache-Control","no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", 0);
%><%@page session="false" %><%
    Locale pg = currentPage.getLanguage(false);
    String lang = pg.getLanguage();
    if(!lang.equals("fr"))
     lang = "en";
    String subscriptionConfirmText = currentStyle.get("subscribe_confirm_text",langText.get("Please confirm your Email Address"));
    String subscriptionExceptionText = currentStyle.get("subscribe_exception_text",langText.get("You have already subscribed."));
    String unsubscriptionAlertText = currentStyle.get("unsubscribe_alert_text",langText.get("You have successfully unsubscribed from the comments."));
    String commentText = currentStyle.get("comment_text",langText.get("Add a Comment"));
    String subscriptionText = currentStyle.get("subscribe_text",langText.get("Subscribe"));
%>
  
<script language="javascript"  src="/scripts/jquery.timeago.<%= lang%>.js"></script>
<cq:includeClientLib categories="granite.csrf.standalone" />
   
<script>  
 
$(document).ready(function() {

 var pagePath="<%=currentPage.getPath()%>";
   var matchStr= "na/mcweb/fr";
        if(pagePath.indexOf(matchStr) != -1){
        $('.replydiv reply-img').removeClass("reply-img").addClass("reply-img_fr");
          }


    $("abbr.timeago").timeago();
    
    try {
        $('a.subscribeLink').mcdColorboxSubscribeUser({question:"<p><%=subscriptionConfirmText%> - "+commentUserObject.userEmail+"</p><p><%=langText.get("To update your email address, visit <a href='https://account.mcd.com'>GAM</a> or contact your local IT Service Desk.")%></p>",yescontrol:"<%= langText.get("Ok") %>",nocontrol:"<%= langText.get("Cancel") %>",yesfunction:function() {subscribe();} });
        
    } catch ( exeption ) { /* silence */ } 
}); 
 


function getUser(path,id){ 

    var authpath = path;
    var pars = "path=" +authpath;             
    var likeAction ="<%=resource.getPath()%>" + ".likeComments.html";     
            $.ajax({
                url: likeAction,
                type: 'POST',    
                timeout: 10000, 
                data: pars, 
                cache: true,   
                error: function(){
                    window.location.reload();    
                },    
                success: function(data){
                /*var element = document.getElementById("ui-reply-img");
                element.style.opacity = "1";
                element.style.filter  = "alpha(opacity=100)";  */
                var display = document.getElementById("displayCount_"+id);
                display.className = "reply-smile-img"; 
                display.innerHTML = data;
                         
                }
            });       
        }

    var ajaxObj = null;
    function checkUser(y,x)
    {      
     
        var commentPath = x;
        var url = "<%=currentPage.getPath()%>.gethover.html?path="+commentPath;
        if(ajaxObj) ajaxObj.abort();
        ajaxObj = $.ajax({
                type: 'GET',
                data:'',
                url: url, 
                error: function(e){
                //alert("Error during AJAX call. Please try again " + e );
  
                },
                
                success: function(data){
                   
                    var exists = data.results.value;
                    
                    if(exists.indexOf("false")==0)
                    {
                      
                       y.style.opacity=1.0;
                      if (typeof y.filters!= 'undefined') {
                       y.filters.alpha.opacity=100;
                       }
                    }

             }
             });   
              
    }
    
     function checkUsers(x)
    {   
       if(ajaxObj) ajaxObj.abort();
       x.style.opacity=0.5;
       if (typeof x.filters!= 'undefined') {
           x.filters.alpha.opacity=50;
          }
    }

</script>  

<script type="text/javascript">
   
    var commentUserObject;
    function getUserID() {
        commentUserObject = eval('(' + Sling.httpGet('<%=resource.getPath().replace("/content/","/")%>.getUserInfo.html?getData=1').responseText + ')');
    }
     
    function subscribe() {
        var form = document.getElementById("pagecommenting_form"); 
        form.action = "<%=resource.getPath()%>.subscribeUser.html?authorId=" + commentUserObject.uid;
        form.submit();
    }
     
    function unsubscribe() {
        var form = document.getElementById("pagecommenting_form");
        form.action = "<%=resource.getPath()%>.unsubscribeUser.html?authorId=" + commentUserObject.uid; 
        form.submit();
    }
    
    function showCommentForm(id, setfocus) {

       $('.commentFormDiv').each(function(i){
            $(this ).css("display","none");
        });
        
        $('#'+id).css("display","block");
       
        var formId = '';
        if(id=='formDiv') { 
            formId = 'pagecommenting_form';
        } else {
            formId = id.replace('replyForm_','') + '_form';
        }    
        
        var form = document.getElementById(formId);
        
            
        form.comment_description.value = '';
        document.getElementById(formId + "_remLen").innerHTML = 2000;
        if (!(<%= WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.EDIT %>)) {
                resetColctrlHeight();
        } 
        if(setfocus) {
            setTimeout( function(){ form.comment_description.focus(); } ,1000); 
        }
    }
    
    function showAlert(message) {
        alert(message);
    }

       

    
    function submitCommentForm(commentAction, formId, validationMessage) {
        var regex= "/[-!$%&^<>*()_+@|~\"\'`=\\#{}\\[\\]:;?,.\\/";
       // var regex = /<script\b[^>]*>([\s\S]*?)<\/script>/gm;
        var form = document.getElementById(formId);
        var commentCount;
        var commentDesc = form.comment_description.value;   
       //var commentDesc = $("#comment_description").val();   
         
        if(commentDesc=='') {              
            form.comment_description.focus();  
        } else {            
            //form.action = commentAction;
            //form.submit();
            commentDesc = rejectCheck(regex,commentDesc);

            var pars = "comment_description=" + encodeURIComponent(commentDesc) + "&authorId=" + commentUserObject.uid + "&designPath=<%=currentDesign.getPath()%>";             
         
            $.ajax({
                url: commentAction,
                type: 'POST',    
                timeout: 10000, 
                data: pars, 
                cache: true,   
                error: function(){
                    window.location.reload();    
                },    
                success: function(xml){                  
                DisplayAlert('SubmitButtonAlertBox',100,500);                                                     
                    if(formId=='pagecommenting_form') {
                   
                        $('#formDiv').css('display','none');
                        //var commentHtml = $('.commentdiv #commentContainer').html();
                        
                        $('.commentdiv #commentContainer').html($('.commentdiv #commentContainer').html() + decodeURIComponent(escape(xml)));
                       // $('.commentdiv #commentContainer').text($('.commentdiv #commentContainer').html() + decodeURIComponent(escape(xml)));
                       
                        
                    } else {
                    
                        $('#replyForm_'+formId.replace('_form','')).css('display','none');
                        var parentDiv = $('#replyForm_'+formId.replace('_form','')).parent();
                        parentDiv.html(parentDiv.html() + decodeURIComponent(escape(xml)));
                        
                        $('#replyForm_' + formId.replace('_form','')).parents('.replydiv').each(function(i){
                            var count = parseInt($(this).children('.replyCountNumber').html());
                            if(count==0) {
                                $(this).children('.replyCountText').html('Reply');
                            } else if(count==1) {
                              $(this).children('.replyCountText').html('Replies');
                            }
                           $(this).children('.replyCountNumber').html(count+1);
                        }); 
                    }
                    $("abbr.timeago").timeago();
                    if($('.toptxthead h2').html().replace(/^\s*/, "").replace(/\s*$/, "") == '') { 
                        $('.toptxthead h2').html('<span class="commentCountNumber">1</span> <span class="commentCountText">comment</span>'); 
                        $('.toptxthead span:last').html('<a href="#formDiv" onClick="javascript:showCommentForm(\'formDiv\');" class="buttonmargin button buttonpadding"><%=commentText%></a>'+$('.toptxthead span:last').html());
                       // alert("TEST");
                        $('.toptxthead span a.subscribeLink').mcdColorboxSubscribeUser({question:"<p><%=subscriptionConfirmText%> - "+commentUserObject.userEmail+"</p><p><To update your email address, visit <a href='https://account.mcd.com'>GAM</a> or contact your local IT Service Desk.></p>",yescontrol:"Ok",nocontrol:"Cancel",yesfunction:function() {subscribe();} }); 
                       // alert("TEST33333");
                    } else {
                         commentCount = parseInt($('.toptxthead h2 .commentCountNumber').html());
                       
                        $('.toptxthead h2 .commentCountText').html('comments');
                        $('.toptxthead h2 .commentCountNumber').html(commentCount+1);
                    }
                }
            });
        }
    }
    
     function rejectCheck(regex,commentDesc) {
    if(commentDesc.match(/([\<])([^\>]{1,})*([\>])/i)==null){
    commentDesc = commentDesc;
    }else{
    commentDesc ="";
    }return commentDesc;
    }
     
        
    function displayLimit(formId,maxlimit) 
    {
        var form = document.getElementById(formId); 
        var field = form.comment_description;
        if (field.value.length > maxlimit) 
            field.value = field.value.substring(0, maxlimit);
        else 
            document.getElementById(formId+"_remLen").innerHTML = maxlimit - field.value.length;
    } 
    
    getUserID();
    
</script> 

<% 
    // Retrieve the Comment Node and its properties
    log.info("**************************INSIDE JSP FILE*****************");
    //out.println(resource.getPath());
    NodeUtility nodeUtil = new NodeUtility(resource);
    List<Node> nodeList = null;
    List<Node> childNodeList = null;
    int commentCount = 0;
   // out.println("***************"+nodeUtil.getReferredNode());
    if(null != nodeUtil.getReferredNode()) {
    
        nodeList = nodeUtil.getReferredNodeList();
       // out.println("Node Listt------->"+nodeList.size());
        childNodeList = nodeUtil.getChildNodeList(nodeUtil.getReferredNode());
       
        if(null != childNodeList) {
            commentCount = childNodeList.size();
         //   out.println("-----"+commentCount);
        }
    }
    // Set style as the request attribute
    request.setAttribute("commentStyle",currentStyle);
   
%>
 <!--pagecommentingstart-->
 <div class="commentdiv">
 <!-- comment header start here -->

    <div class="toptxthead">

    <h2>
<%    
        if (commentCount == 0) {
            
        } else {
%>        
           <span class="commentCountNumber" id="commentSecDiv"><%= commentCount %></span> <span class="commentCountText"><%= commentCount == 1 ? langText.get("comment") : langText.get("comments") %></span>
<%
        }
        
%>
    </h2>

    <span style="float:right;">
    <%
        if(commentCount != 0) 
        {
%>
        <a href="#formDiv" onClick="javascript:showCommentForm('formDiv', true);" class="button buttonpadding"><%=commentText%></a> 
<%
        }
%>
        <a href="javascript:void(0);" class="button buttonpadding subscribeLink"><%=subscriptionText%></a>
    </span>
    <div class="clear"></div>
    </div>
    
    <!-- comment header end here -->
    <!-- Comment starts here -->
    <div id="commentContainer"> 
<%
    if(null != nodeList) {
        for (Node node : nodeList) {
            %><div class="margintop">
                   <cq:include path="<%=node.getPath()%>" resourceType="mcd/components/content/pagecommenting/replies" />
              </div><%      
        }
    }
%>
    </div>
    <!-- Comment ends here --> 
    
    <div id="formDiv" class="commentFormDiv margintop">
        <cq:include script="/apps/mcd/components/content/pagecommenting/pagecommentingform.jsp"/>
    </div>
</div>
<!--pagecommentingend-->
<%-- Hidden Div for Submit Button--%>
<div id="SubmitButtonAlertBox" style="z-index:1000" class="alert">
    <table border=0 width=500 cellpadding="4" style='table-layout:fixed;'>
     <col width=400>
     <col width=100>
    <tr>
        <td colspan="2" align="center">
          <B><%=langText.get("Comment has been submitted.")%></B>
        </td>
    </tr>
    <tr>
        <td colspan="2" align="center">
          <TEXTAREA ID="holdtext" STYLE="display:none;"> </TEXTAREA>
          <form style="text-align:center">
            <!--<input 
               type="button" 
               value="Close" 
               style="width:75px;" 
               onclick="grayOut('AlertBox',false);">-->
                   <a style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;color:#000000;" href="#" onClick="javascript:grayOut('SubmitButtonAlertBox',false);" ><img align="absMiddle" src="/images/cancel.gif" />&nbsp;<%=langText.get("Close")%></a>
          </form>
        </td>   
    </tr>
    </table>
</div> 
<%
    String subscribeStatus = request.getParameter("subscribeStatus") != null? request.getParameter("subscribeStatus").toString() : "";
    if(!"".equals(subscribeStatus)){
        if("1".equals(subscribeStatus)) {
        %>
        <script type="text/javascript">showAlert("<%=subscriptionExceptionText%>")</script>
        <%
        }
    }
    
    String unsubscribeStatus = request.getParameter("unsubscribeStatus") != null? request.getParameter("unsubscribeStatus").toString() : "";
    if(!"".equals(unsubscribeStatus)){
        if("0".equals(unsubscribeStatus)) {
        %>
        <script type="text/javascript">showAlert("<%=unsubscriptionAlertText%>")</script>
        <%
        }
    }
    
    String[] selectors = slingRequest.getRequestPathInfo().getSelectors();
    if(null != selectors)
    {
        if(selectors.length > 0) {
            if(selectors[0].equalsIgnoreCase("unsubscribe"))
            {
            %>
            <script type="text/javascript">unsubscribe();</script>
            <%
            }
        }
    }
    
    if(commentCount == 0) {
    %>
        <script type="text/javascript">showCommentForm("formDiv", false);</script>
    <%
    }
%>
  