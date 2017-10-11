 <%@include file="/apps/mcd/global/global.jsp"%>
 <cq:include script="/apps/mcd/global/init.jsp"/> 
 <%@ page import="java.util.ArrayList,java.util.Iterator,com.day.cq.wcm.api.PageFilter"%> 
<%@ page import="com.day.cq.security.User,java.util.*,
                 com.mcd.accessmcd.calendar.util.DesEncrypter,
                 com.mcd.accessmcd.util.CommonUtil,
                 com.day.cq.wcm.api.WCMMode"%>


 <script type="text/javascript"  src="/scripts/jquery-1.3.2.min.js"  ></script>
 <script type="text/javascript">

function sizeFrame(frameId) {
    var F = document.getElementById(frameId);
    if(F.contentDocument) {
    F.height = F.contentDocument.documentElement.scrollHeight+30; //FF
    } 
    else{
    F.height = F.contentWindow.document.body.scrollHeight+30; //IE6, IE7 and Chrome
    }
}



</script>
 <%
   final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
   CommonUtil commonUtil = new CommonUtil();
   String url  =request.getRequestURI();
   String alias=""; 
   String mcdAudience="CorpEmployees";
    mcdAudience = user.getProperty("rep:mcdAudience");
    if(mcdAudience == null || "null".equals(mcdAudience) || mcdAudience.equals("")) 
            mcdAudience = "CorpEmployees" ; 
            
    // To Get Alias of Audience Type
     alias = commonUtil.getAlias(mcdAudience);
     if(alias == null || "null".equals(alias ) || alias.equals("")) 
       alias="CE";     
     alias = "."   + alias;
     if(url.indexOf(alias) < 0)
     {
      url = url.replace(".home" ,alias)   ;
     } 
     
 %>
   

<body style="margin:0px" onload="sizeFrame('jFrame');"> 
<iframe width="100%" id="jFrame" src="<%=url%>" scrolling="auto" height="1000px" frameborder="0" ></iframe>
</body>

<script type="text/javascript">
$(document).ready(function(){
$("#jFrame").attr("src","<%=url%>");
});
</script>
 