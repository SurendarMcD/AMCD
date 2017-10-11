<html>
 <head> 
    <title>CQ Dashboard</title>
<script id="source1" language="javascript" >
var perfdata=[];
</script>

    <!--[if IE]><script language="javascript" src="/apps/mcd/docroot/scripts/flot/excanvas.min.js"></script><![endif]-->
    <link rel="stylesheet" href="/css/jquery-ui-1.7.2.datepicker.css" type="text/css" />
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery-1.4.1.min.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.selection.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/dashboard.js"></script>
    <script language="javascript" src="/scripts/jquery-ui-1.7.2.datepicker.min.js" ></SCRIPT> 
 </head>
    <body style="font-family:Arial,Helvetica,sans-serif;">
<h2>CQ Dashboard</h2><!--[if IE]><font color=red>This page is best viewed in FireFox/Chrome.</font><![endif]-->

<b>Date:</b><input id="fordate">

<!--b>Data Filter:</b><input id="filter" value="" /--> 

<button id="reload data" onclick="loadData(false);">Reload Data</button>
<!--button id="data table" onclick="getDataTable();">data table</button><br-->
<!--table border=1>
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
<button onclick="drawChart()">Apply</button>&nbsp;<button onclick="clearFilters()">Clear</button><br>
-->
<br>

<table>
<tr>
<td>
<b>Unique Users - PUBLISH</b>Time Interval:<select onchange="loadData(1);" id="timeintervalpub">
<option value="60">60 min</option>
<option value="30">30 min</option>
<option selected value="15">15 min</option>
<option value="5">5 min</option>
<option value="1">1 min</option>
</select><br> 
 
<div id='chart1' style='width:800px;height:400px;'></div>
</td>
<td>
<b>Unique Users - AUTHOR</b>   Time Interval:<select onchange="loadData(2);" id="timeinterval">
<option value="60">60 min</option>
<option value="30">30 min</option>
<option selected value="15">15 min</option>
<option value="5">5 min</option>
<option value="1">1 min</option>
</select><br> 
<div id='chart1a' style='width:800px;height:400px;'></div>
</td>
</tr>
<tr>
<td>
<b>Average Page Load Times - PUBLISH</b><br> 

<div id='chart0' style='width:800px;height:400px;'></div>
</td>
<td>
<b>Average Page Load Times - AUTHOR</b><br> 
<div id='chart0a' style='width:800px;height:400px;'></div>
</div>
</td>
</tr>
</table>
 


<script id="source" language="javascript" >
var datarequesturl='/content/utility/utility.timings.html?summary=y&publishservers=true&fordate=';
var timingseriescolor="blue";

 
$(function () {
    loadData(0);
    $("#fordate").datepicker();
});
</script>

 </body>
</html>