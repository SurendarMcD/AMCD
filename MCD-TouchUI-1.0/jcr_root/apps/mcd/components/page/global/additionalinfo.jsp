<%--
  ==============================================================================
  Draws the HTML body with content:
  - includes header
  - includes topbar
  - includes bottombar
  ==============================================================================
--%>
<%@ page import="java.util.*,
        java.io.*,
        javax.servlet.*,
        javax.servlet.http.*,
        com.mcd.accessmcd.util.CommonUtil,
        com.day.cq.security.User" %><%   
%> 
<%@include file="/apps/mcd/global/global.jsp"%><%
      
%>  

<script>
/*
var infourl = '<%=currentPage.getPath().replaceAll("/content/","/")%>.moreinfo.html?getdata=1';
var headerxmlhttp = new getXMLObject(); //xmlhttp holds the ajax object

function headerHandleServerResponse() 
{    
   if (headerxmlhttp.readyState == 4)  
   {
     if(headerxmlhttp.status == 200) 
     {             
            UserInfoObject = eval('(' + headerxmlhttp.responseText + ')');    
     } 
     else 
     {
      //  alert("Error during AJAX call while loading the template. Please try again");         
     }
   }
} 

headerAjaxFunction(infourl); 
*/
</script>     
    