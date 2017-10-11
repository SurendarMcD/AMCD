<%@ page import="com.day.text.Text" %><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page session="false" %><%

    String id = Text.getName(resource.getPath()) + "_form";
    request.setAttribute("formId", id);
    
    //String formAction = resource.getPath().startsWith("/content/")? resource.getPath().replaceFirst("/content/","/") + ".addComment.html" : resource.getPath() + ".addComment.html";
    String formAction = resource.getPath() + ".addComment.html";
    //Style commentStyle = (Style)request.getAttribute("commentStyle"); 
    String formTitle = currentStyle.get("form_title",langText.get("Add a Comment"));
    String submitText = currentStyle.get("form_submit_text",langText.get("Submit"));
    String validationMsg = currentStyle.get("form_validation_msg",langText.get("Please enter comments before submitting.")); 
%> 
    <div class="headertxt"><img src="<%=currentDesign.getPath()%>/images/comment-icon.jpg" width="27" height="22" align="absmiddle" /> <%=formTitle%></div>
      
    <form action="javascript:submitCommentForm('<%=formAction%>','<%=id%>','<%=validationMsg%>');" method="POST" name="commentForm" id="<%=id%>"> 
    
    <div class="grayborder padding7px">
        <label>
            <textarea name="comment_description" cols="45" rows="5" class="textarea" id="comment_description" onKeyDown="displayLimit('<%=id%>',2000);" onKeyUp="displayLimit('<%=id%>',2000);"></textarea> 
             <span><span id='<%=id%>_remLen' > 2000 </span> &nbsp;<%=langText.get("characters remaining on your input limit")%> </span>
           
        </label> 
    <div style="margin-top:7px; float:right">
        <label>
            <input type="submit" name="Submit" id="Submit" value="<%=submitText%>" class="button">
        </label>
    </div>
    <div class="clear"></div>
    </div>
</form>
