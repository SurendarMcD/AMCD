<%-- ################################################################################ 
 # DESCRIPTION: Used in awesome and navigation bar. 
 #              Retrieve values like user, audience type etc in form of JSON object.
 #  
 # Environment: 
 # 
 # UPDATE HISTORY       
 # 1.0  Deepali Goyal Initial Version
 #
 #####################################################################################--%><%

%><%@ page import="com.day.cq.security.User,
                 java.util.Map,
                 com.mcd.accessmcd.comments.util.UserDetails,
                 com.mcd.accessmcd.comments.constants.CommentsConstants"%><%
%><%@include file="/apps/mcd/global/global.jsp"%><%     

    response.setHeader("Cache-Control","no-cache");
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
    
    String userID = user.getID();
    
    String userEmail = "";
    Map<String, String> userDetailsMap = UserDetails.getUserPropertiesFromLDAP(userID);
    if(userDetailsMap == null)
    {
       if(user != null) {
        if(user.getProperty("rep:e-mail")!= null)
            userEmail = user.getProperty("rep:e-mail");
        } 
    }
    else
    {
        userEmail = userDetailsMap.get(CommentsConstants.MAIL);
    }
%>
{
   "uid" : "<%=userID %>",
   "userEmail" : "<%=userEmail%>"
}