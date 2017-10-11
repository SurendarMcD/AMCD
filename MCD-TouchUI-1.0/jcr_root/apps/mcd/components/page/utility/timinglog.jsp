<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<%
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    out.write("<a href='/libs/cq/core/content/login.html'>LOGIN HERE</a>");
    return;
}
%>

<html>
 <head> 
    <title>CQ Timings Chart</title>
    <meta http-equiv="Pragma" content="no-cache">
<script id="source1" language="javascript" >
var perfdata=[];
</script>
    <!--[if IE]><script language="javascript" src="/apps/mcd/docroot/scripts/flot/excanvas.min.js"></script><![endif]-->
    <link rel="stylesheet" href="/css/jquery-ui-1.7.2.datepicker.css" type="text/css" />
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery-1.4.1.min.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.selection.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/mcd_performance_chart.js"></script>
    <script language="javascript" src="/scripts/jquery-ui-1.7.2.datepicker.min.js" ></SCRIPT> 
</head>
    <body style="font-family:Arial,Helvetica,sans-serif;">
       <h2>CQ Timings Chart</h2><!--[if IE]><font color=red>This page is best viewed in FireFox/Chrome.</font><![endif]-->
<!--
<b>Current log:</b><select id="requestLogFile">
<option selected value="timing.log">timing.log</option>
<option value="timing.log.0">timing.log.0</option>
<option value="timing.log.1">timing.log.1</option>
<option value="timing.log.2">timing.log.2</option>
<option value="timing.log.3">timing.log.3</option>
<option value="timing.log.4">timing.log.4</option>
<option value="timing.log.5">timing.log.5</option>
<option value="timing.log.6">timing.log.6</option>
<option value="timing.log.7">timing.log.7</option>
<option value="timing.log.8">timing.log.8</option>
<option value="timing.log.9">timing.log.9</option>
</select>
-->
<b>Date:</b><input id="fordate">
<button id="reload data" onclick="loadData();">reload data</button>
<b>Data Filter:</b><input id="filter" value="" /> 
<button id="data table" onclick="getDataTable();">data table</button><br>
<table border=1>
<tr><td></td><td><b># Data Points</b></td><td><b>Avg (s.)</b></td><td><b>90th Percentile (s.)</b></td></tr>
<tr>
<td><b>TOTAL DATASET</b></td>
<td align=right><b><span  id="TotalNbrDataPoints"></span></b></td>
<td align=right><b><span id="TotalAvg"></span></b></td>
<td align=right><b><span id="TotalNinetyPercent"></span></b></td>
</tr>
<tr>
<td>Subfilter:<input id="filter1"></td>
<td align=right><span id="filter1NbrDataPoints"></span></td>
<td align=right><span id="filter1Avg"></span></td>
<td align=right><span id="filter1NinetyPercent"></span></td>
</tr>
<tr>
<td>Subfilter:<input id="filter2"></td>
<td align=right><span  id="filter2NbrDataPoints"></span></td>
<td align=right><span  id="filter2Avg"></span></td>
<td align=right><span  id="filter2NinetyPercent"></span></td>
</tr>
<tr>
<td>Subfilter:<input id="filter3"></td>
<td align=right><span  id="filter3NbrDataPoints"></span></td>
<td align=right><span  id="filter3Avg"></span></td>
<td align=right><span  id="filter3NinetyPercent"></span></td>
</tr>
<tr>
<td>Subfilter:<input id="filter4"></td>
<td align=right><span  id="filter4NbrDataPoints"></span></td>
<td align=right><span  id="filter4Avg"></span></td>
<td align=right><span  id="filter4NinetyPercent"></span></td>
</tr>
</table>
<button onclick="AOWfilter()">AOW</button>
<button onclick="Homepagefilter()">Homepages</button>
<button onclick="Browserfilter()">Browsers</button>
<button onclick="Mobilefilter()">Mobile</button>
<button onclick="drawChart()">Apply</button>&nbsp;<button onclick="clearFilters()">Clear</button><br>

<b>Start Date/Time: </b><span id="startDateTime"></span><br>
<b>End Date/Time: </b><span id="endDateTime"></span><br>
<div id='chart' style='width:950px;height:500px;'></div>

<script id="source" language="javascript" >
var datarequesturl='/content/utility/utility.timings.html';
var timingseriescolor="blue";

 
$(function () {
    loadData();
    $("#fordate").datepicker();
    
});
</script>

 </body>
</html>