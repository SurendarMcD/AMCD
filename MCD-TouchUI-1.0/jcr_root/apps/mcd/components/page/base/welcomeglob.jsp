<%--
 
  Welcome component's globbing jsp

  Displays the welcome message to be displayed to the 
  current logged in user

--%><%@ page import="com.day.cq.security.User " %>
<%@ page import="java.util.*"%>
<%@include file="/apps/mcd/global/global.jsp" %>
<%
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
    String userName = "";//For storing user name
    //String firstName = user.getProfile().getGivenName();//For storing first name
    //String lastName = user.getProfile().getFamilyName();//For storing Last name
    //Changed 5/14/2010 ECW - Autosynch does not update profile fields
    String firstName = user.getProperty("givenName");
    String lastName = user.getProperty("familyName");
    
    firstName=(firstName!=null)?firstName:"";
    lastName=(lastName!=null)?lastName:"";
    String nameFormat = request.getParameter("nameFormat");
    if(nameFormat.equals("first"))//If name format is First Name Last Name
    {
        userName = firstName+" "+lastName ;
    }
    else //If name format is Last Name First Name
    {
        userName = lastName+" "+firstName ;
    }
    userName=(userName.trim().equals(""))?user.getName():userName;
    out.println(userName);
           
    
%>  