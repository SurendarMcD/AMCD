<%-- #############################################################################
# DESCRIPTION:  Import Utility Template is used to upload assets of flash and html. 
                It includes only flash utility component.
#
# Author: Deepali 
# Environment: 
# 
# INTERFACE   
# Controller: 
# Targets: 
# Inputs: global.jsp, flash utility component
#                    
# Outputs:      
# 
# UPDATE HISTORY        
# 1.0  Deepali Goyal, 03-05-2010, Initial Version 
# 
# Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
###################################################################################--%>

<%@include file="/apps/mcd/global/global.jsp"%><%
%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<html>

<head>
<cq:include script="/apps/mcd/global/init.jsp"/>
<script>
    
    function updateClock()
    {
      var currentTime = new Date ();
      
      var month = currentTime.getMonth() + 1
      var day = currentTime.getDate()
      var year = currentTime.getFullYear()
      
      var currentDate = month + "/" + day + "/" + year; 
      //alert(currentDate);
      var currentHours = currentTime.getHours();
      var currentMinutes = currentTime.getMinutes();
      var currentSeconds = currentTime.getSeconds();

      // Pad the minutes and seconds with leading zeros, if required
      currentMinutes = ( currentMinutes < 10 ? "0" : "" ) + currentMinutes;
      currentSeconds = ( currentSeconds < 10 ? "0" : "" ) + currentSeconds;

      // Choose either "AM" or "PM" as appropriate
      var timeOfDay = ( currentHours < 12 ) ? "AM" : "PM";

      // Convert the hours component to 12-hour format if needed
      currentHours = ( currentHours > 12 ) ? currentHours - 12 : currentHours;

      // Convert an hours component of "0" to "12"
      currentHours = ( currentHours == 0 ) ? 12 : currentHours;

      // Compose the string for display
      var currentTimeString = currentHours + ":" + currentMinutes + ":" + currentSeconds + " " + timeOfDay;

      // Update the time display
      document.getElementById("clock").firstChild.nodeValue = currentTimeString;      
    }
    
    
</script>
    <title>Import Utility</title>
    
    <style type="text/css">
        div {
            font-family:arial,tahoma,helvetica,sans-serif;
            font-size:11px;
            white-space:nowrap;
        }
        .action {
            display: inline;
            width: 120px;
            float: left;
        }
        .error {
            color: red;
            font-weight: bold;
        }
        .title {
            display: inline;
            width: 150px;
            float: left;
            margin: 0 8px 0 0;
            overflow: hidden;
        }
        
        .cf {
            color: #888888;
        }
        .path {
            display: inline;
            width: 100%;
        }

    </style>
    
</head>

<body onload="javascript:updateClock();setInterval('updateClock()', 1000 )" width="100%" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#999966">
  <tr>
    <td width="100%" style="padding:0 0 0 3px;"><font face="Arial Black" size="6" color="#000000">Flash Import Utility</font></td>
  </tr>
</table>

<table border="0" width="100%" bgcolor="#000000" cellspacing="0" cellpadding="0">
  <tr>
    <td width="100%" style="padding:0 0 0 3px;">
<%
        DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
        Date date = new Date();
%>
        <font color="#FFFFFF" face="Arial" size="2">
        <b><%=dateFormat.format(date)%>&nbsp;&nbsp;<span id="clock">&nbsp;</span></b>
    </font>
    </td>
  </tr>
</table>
<%
%>
<cq:include path="flashutility" resourceType="mcd/components/content/flashutility" />
<%
%>
<table border="0" width="100%" bgcolor="#000000" cellspacing="0" cellpadding="0">
  <tr>
    <td width="100%"><font size="1">&nbsp;</font></td>
  </tr>
</table>

</body>
</html>