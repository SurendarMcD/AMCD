<html>
 <head>
    <title>CQ Timings Chart</title>
<script id="source1" language="javascript" >
var perfdata=[];
</script>
    <!--[if IE]><script language="javascript" src="/apps/mcd/docroot/scripts/flot/excanvas.min.js"></script><![endif]-->
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery-1.4.1.min.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.selection.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/mcd_performance_chart.js"></script>
 </head>
    <body>
    <h2>CQ Timing Log Chart (CQ Timing Util)</h2>
    <h3 id="fordate"></h3>
        <br>
         
         <!--[if IE]><font color=red>This page is best viewed in FireFox/Chrome.</font><![endif]-->
</b> <br>
<table border=1>
<tr><td><b># Data Points</b></td><td><b>Avg (s.)</b></td><td><b>90th Percentile (s.)</b></td></tr>
<tr>
<td align=right><span  id="nbrDataPoints"></span></td>
<td align=right><span id="avgDataPoints"></span></td>
<td align=right><span id="ninetypercentDataPoints"></span></td>
</tr>
</table>
<b>Start Date/Time: </b><span id="startDateTime"></span><br>
<b>End Date/Time: </b><span id="endDateTime"></span><br>
<b>Current log:</b><select id="requestLogFile">
<option selected value="error.log">error.log</option>
<option value="error.log.0">error.log.0</option>
<option value="error.log.1">error.log.1</option>
<option value="error.log.2">error.log.2</option>
<option value="error.log.3">error.log.3</option>
<option value="error.log.4">error.log.4</option>
</select><br>
<b>Filter:</b><input id="filter" value=".html" /><br>
<!--
<b>Start Line:</b><input id="startline" value="" /><br>
<b>End Line:</b><input id="endline" value="" /><br>
-->
<button id="reload" onclick="loadData();">reload</button><br>
<div id='chart' style='width:950px;height:500px;'></div>

<script id="source" language="javascript" >
var datarequesturl='/content/utility/utility.cqtimings.html';
var timingseriescolor="green";
$(function () {
    loadData();

});
</script>

 </body>
</html>
