<%@ page session="false" %>
<%-- ########################################### 
 # DESCRIPTION: Search User Email
 #  this file will search the users on the basis of their lastname
 #  and will return then as the list.
 # Environment:    
 # 
 # UPDATE HISTORY : RAJAT CHAWLA 8th Oct 2009  
 # 
 ##############################################--%>
<%@ include file="/apps/mcd/global/global.jsp"%>

<%@ page import="java.util.List,java.util.ArrayList" %>
<%@ page import="com.mcd.accessmcd.util.EmailSearchUtil,com.mcd.accessmcd.mail.bo.UserDataBean"%>
<%@ page import="com.day.cq.security.User" %>
<%@ page import="com.day.cq.security.Group" %>
<%@ page import="com.day.cq.security.UserManager,com.day.cq.security.Authorizable" %>
<%@ page import="com.day.cq.security.UserManagerFactory" %>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<%@page import="org.apache.sling.jcr.api.SlingRepository" %>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.util.Locale" %>
<html>
<head>
<link rel="STYLESHEET" type="text/css" href="/apps/mcd/docroot/css/emailfooter.css">
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script> 
<script type="text/javascript" src="/apps/mcd/docroot/scripts/common.js"></script>
<title><%= langText.get("Search User Email") %></title>
</head>
<%!
      public String rejectCheck(String expression,String param){ 
    
    for (int i = 0; i < expression.length(); i++){
    String c = "" + expression.charAt(i);   
 
    param = param.replace(c,"");
    }
    return(param.trim());
    }

%>
<%
// creating the user object //

final User user = slingRequest.getResourceResolver().adaptTo(User.class);
// retrieving the i18n bundle from the user language //
 // ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());
  ResourceBundle bundle =resourceBundle;  
    // declaring the list //
    List users = new ArrayList();
     // code to retireve the form data  from request // 
    String regex= "/[-!$%&^<>*()_+@|~\"\'`=\\#{}\\[\\]:;?,.\\/]";
    String lastName = request.getParameter("txtSearchLastName");
    String firstName = request.getParameter("txtSearchFirstName");
    String startSearch = "no";
    boolean displayResults = false;
    lastName = rejectCheck(regex,lastName);
    if( firstName != null && firstName.trim().length() > 0){
    firstName = rejectCheck(regex,firstName);
    }
    if (request.getParameter("hidStartSearch")!=null)
        startSearch = request.getParameter("hidStartSearch");

         
    if(startSearch.equalsIgnoreCase("yes") && lastName != null && lastName.trim().length() > 0) {
        // if search button is pressed the the Email search butil is called to 
        // provide the user list from the LDAP //
        EmailSearchUtil searchTool = new EmailSearchUtil();
        users = searchTool.searchUserName(firstName, lastName, true); 
        displayResults = true;
       }

%>

<body onload="javascript:selectedText()">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <nobr><a href="#" onclick="window.opener.focus(); window.close();" class="contentlnkbold"><img src="/apps/mcd/docroot/images/icon_button_close.gif" border=0 align=absmiddle> <%=bundle.getString("PAF_CLOSE") %></a></nobr> 
        </td>
    </tr>
</table>
<form name="frmSearchUser" method="GET">

<input type="hidden" name="hidStartSearch" value="no">


<table border="0" cellpadding="0" cellspacing="0" align="center" width="80%">
    <tr>
    <td nowrap>
       
        <%= bundle.getString("PAF_LASTNAME") %>: <input type="text" name="txtSearchLastName" class="query" value="" width="50">
        &nbsp;&nbsp;&nbsp;
        <%= bundle.getString("PAF_FIRSTNAME") %>: <input type="text" name="txtSearchFirstName" class="query" value="" width="50">
        
    </td>
    <%
    String msg = langText.get("Last Name must be greater than or equal to two characters in length, excluding '*' characters.") ;
    %>  
    
    <td> &nbsp;<input type="image" src="/apps/mcd/docroot/images/btn_search.gif" target="_self" onclick="return validateAndSubmit('<%= msg %>');" valign=absmiddle></button></td>
    </tr>

    <%if(displayResults && (users == null || users.isEmpty()) ) { %>
        <tr><td colspan="3" align="left">&nbsp;</td></tr>
        
        <tr><td colspan="3" align="center" class="error"><%= bundle.getString("PAF_NOTFOUND") %></td></tr>
    <%}%> 
    
    <%if(users != null && !users.isEmpty() ) { 
        int numUsers = users.size();
      
      if (numUsers > 50) {%>
        <tr><td colspan="3" align="left">&nbsp;</td></tr>
        
        <tr><td colspan="3" align="center" class="error"><%= bundle.getString("PAF_FOUNDMAX") %></td></tr>
    <% }  else if(numUsers == 0 && request.getAttribute("searched") != null ) {%>
        <tr><td colspan="3" align="left">&nbsp;</td></tr>
        
        <tr><td colspan="3" align="center" class="error"><%= bundle.getString("PAF_NORESULTS")%></td></tr>
    <%} 
     // if the users are more the 0 then the list will be genrated//   
     if(numUsers > 0) {%>
        <tr><td colspan="3" align="left">&nbsp;</td></tr>
       
        <tr><td colspan="3" align="center" class="error"><%= bundle.getString("PAF_SELECT") %></td></tr>
        <tr><td colspan="3" align="left">&nbsp;</td></tr>
        <tr><td colspan="3" align="right" class="Footerbodynormal">
               
               <%= bundle.getString("PAF_PRE_RESULT") %> <%=numUsers%> <%=bundle.getString("PAF_POST_RESULT") %>
            </td></tr>      
                
        <tr>
            <td colspan="3" width=65%>
                 <table border="0" cellpadding="0" cellspacing="0" class="border" width=100%>
                            <tr align="left" class="Footerbodynormal" bgcolor=#F9E9AE>
                   
                    <td align=center>&nbsp;<br><%= bundle.getString("PAF_USERNAME") %><br>&nbsp;</td>
                    <td width="1" bgcolor=abb2b7><img src="/apps/mcd/docroot/images/0.gif" width="1" height="1"></td>
                    
                    <td align=center>&nbsp;<br><%= bundle.getString("PAF_USERID") %><br>&nbsp;</td>
                    <td width="1" bgcolor=abb2b7><img src="/apps/mcd/docroot/images/0.gif" width="1" height="1"></td>
                    
                    <td align=center>&nbsp;<br><%= bundle.getString("PAF_USEREMAIL") %><br>&nbsp;</td>
                </tr>
                <% // users will be displayed in  the table format // 
                   for(int i=0; i<numUsers; i++) { 
                   UserDataBean theUser = (UserDataBean) users.get(i);
                
                %>
                
                    <tr valign="top" bgcolor="DCDEEC">
                            <td colspan="5" bgcolor="abb2b7"><img src="/apps/mcd/docroot/images/0.gif" width="1" height="1"></td>
                    </tr>
                
                
                <tr bgcolor="<% if(i % 2 == 0){ %>#FFFFFF<% } else { %>#F1F1F1<% } %>">
                    <td>
                    
                    <a href="#" onclick="return setMailId('<%=theUser.getUserId()%>','<%=theUser.getName()%>','<%=theUser.getEmail()%>');" class="contentlnk">&nbsp;<%=theUser.getName()%></a>
                    
                    </td>
                    <td width="1" bgcolor=abb2b7><img src="/apps/mcd/docroot/images/0.gif" width="1" height="1"></td>
                    <td class=Footerbodynormal>&nbsp;<%=theUser.getUserId()%></td>
                    <td width="1" bgcolor=abb2b7><img src="/apps/mcd/docroot/images/0.gif" width="1" height="1"></td>
                    <td class=Footerbodynormal>&nbsp;<%=theUser.getEmail()%></td>
                </tr>
                <% } %>
                </table>
            </td>
        </tr>
<%  }
}%>
    
</table>
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <nobr><a href="#" onclick="window.opener.focus(); window.close();" class="contentlnkbold"><img src="/apps/mcd/docroot/images/icon_button_close.gif" border=0 align=absmiddle> <%=bundle.getString("PAF_CLOSE") %></a></nobr> 
        </td>
    </tr>
</table>
</form>
</body>


</html> 
                            

