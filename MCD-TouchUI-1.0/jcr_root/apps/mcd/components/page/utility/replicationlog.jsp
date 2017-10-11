<html>
 <head>
    <title>CQ Replication.Log Chart</title>
<script id="source1" language="javascript" >
var perfdata=[];
</script>
    <!--[if IE]><script language="javascript" src="/apps/mcd/docroot/scripts/flot/excanvas.min.js"></script><![endif]-->
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery-1.4.1.min.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.selection.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/mcd_performance_chart.js"></script>
 </head>
    <body style="font-family:Arial,Helvetica,sans-serif;">
    <h2>CQ Replication Log Chart</h2><!--[if IE]><font color=red>This page is best viewed in FireFox/Chrome.</font><![endif]-->
<b>Current log:</b><select id="requestLogFile">
<option selected value="error.log">error.log</option>
<option value="error.log.0">error.log.0</option>
<option value="error.log.1">error.log.1</option>
<option value="error.log.2">error.log.2</option>
<option value="error.log.3">error.log.3</option>
<option value="error.log.4">error.log.4</option>
</select>
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
<button onclick="drawChart()">Apply</button>&nbsp;<button onclick="clearFilters()">Clear</button><br>
<b>Start Date/Time: </b><span id="startDateTime"></span><br>
<b>End Date/Time: </b><span id="endDateTime"></span><br>
<div id='chart' style='width:950px;height:500px;'></div>

<script id="source" language="javascript" >
var datarequesturl='/content/utility/utility.replications.html';
var timingseriescolor="blue"; 
$(function () {
    loadData();

});
</script>

 </body> 
</html>