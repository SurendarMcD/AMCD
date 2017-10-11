var series=[];
var currentdata=[];
var allpointLabels=[];
var pointLabels=[];

var previousPoint = null;
var chartedpage="";
var chartoptions = {
                lines: {show:false },
                points: {show:true },
                grid: { hoverable:true},
                xaxis: { mode: "time" },
                yaxis: { min: 0 ,tickFormatter: function (v, axis) { return v.toFixed(axis.tickDecimals) +"s" }},
                legend: {position: "nw"},
                selection: { mode: "x" }
        
    };
var startDateTime=new Date();
var endDateTime=0;
var sumDataPoints=0.0;

function parseData(){
sumDataPoints=0;
var cnt=0;
startDateTime=new Date();
endDateTime=0;
var retSeries=new Array();
for(var ix in perfdata){
  var line=perfdata[ix];
  var fields=line.split("|")
  var requesttime=parseInt(fields[0]);
  var timing=parseInt(fields[1])/1000;
    pointLabels[fields[0]+"|"+timing]=fields[2];
    retSeries[cnt++]=[fields[0],timing];
     sumDataPoints+=timing; 
    if(requesttime<startDateTime){
        startDateTime=requesttime;
    }else{
        if(requesttime>endDateTime)
           endDateTime=requesttime;
    }
}
 $("#TotalNbrDataPoints").html(cnt);
     if(cnt>0){
         var avg=Math.round((sumDataPoints/cnt)*10)/10;
         $("#TotalAvg").html(avg);
        // retSeries.sort(TimingSorter);
        // var ninetypct=retSeries[Math.floor(retSeries.length*0.9)][1];
        // alert(ninetypct);
         $("#TotalNinetyPercent").html(seriesPercentile(retSeries,0.9));
     }
return retSeries;
}

function findPointToolTip(inseries,x,y){
    return pointLabels[x+"|"+y];
}
 
function parseCurrentData(series,x1,x2,y1,y2,filter){
sumDataPoints=0
var cnt=0;
var retSeries=new Array();


for(var ix in series){
  var datapoint=series[ix];
  
  if(datapoint[0]>x1 && datapoint[0]<=x2){
     
     if(filter!="" && pointLabels[datapoint[0]+"|"+datapoint[1]].indexOf(filter)<0){
          //console.log(pointLabels[datapoint[0]+"|"+datapoint[1]]);
      }else{
          //console.log(pointLabels[datapoint[0]+"|"+datapoint[1]]);
          //pointLabels[cnt]=allpointLabels[ix];
          retSeries[cnt++]=datapoint;
          var requesttime=parseInt(datapoint[0]);
          sumDataPoints+=datapoint[1];   
             if(requesttime<startDateTime){
                 startDateTime=requesttime;
             }else{
                 if(requesttime>endDateTime)
                    endDateTime=requesttime;
             }
     }
  }
}
//console.log("retSeries:"+retSeries.length);
return retSeries;
}

function TimingSorter(x,y){
    if(x[1]<y[1])return -1;
    return 1;
}

function seriesPercentile(series,percentile){
    series.sort(TimingSorter);
    var ix=Math.floor(series.length*percentile);
    return series[ix][1];
}

function getData( x1, x2,y1,y2,filtername,filter,filternumber){
    //var data=new Array();
    var series=new Object();
    series.label="";
    series.data=[];
    if(filtername!=""){
      filter=$("#"+filtername).val();
    }
    if(filter!="" || filternumber==1){
          filtername="filter"+filternumber;
          $("#"+filtername).val(filter);                
    }else{
        return null;
    }
    series.data=parseCurrentData(currentdata[0],x1,x2,y1,y2,filter);
    //console.log("series length:"+series.data.length);
    if(filternumber==1)series.color=timingseriescolor;
    if(filternumber==2)series.color="red";
    if(filternumber==3)series.color="green";
    if(filternumber==4)series.color="orange";
    series.label=filter;
     

    var nbrDataPoints=series.data.length;
     $("#"+filtername+"NbrDataPoints").html(nbrDataPoints).css({"color" : series.color});;
     var avg=0;
     var ninetypct=0;
     if(nbrDataPoints>0){
         avg=Math.round((sumDataPoints/nbrDataPoints)*10)/10;
         ninetypct=seriesPercentile(series.data,.90);
     }
     $("#"+filtername+"Avg").html(avg).css({"color" : series.color});
     $("#"+filtername+"NinetyPercent").html(ninetypct).css({"color" : series.color});;
     var timezoneoffset=6*3600000;
     $("#startDateTime").html(""+new Date(startDateTime+timezoneoffset)).css({"color" : timingseriescolor});;
     $("#endDateTime").html(""+new Date(endDateTime+timezoneoffset)).css({"color" : timingseriescolor});;
         
    return series;
}

function drawChart(){
startDateTime=new Date();
endDateTime=0;
var dataseries=[];
var filter=$("#filter1").val();

  
  var series1=getData(0, 2297944457000,"","","filter1","",1);
  dataseries.push(series1);
  var series2=getData(0, 2297944457000,"","","filter2","",2);
  if(series2!=null)dataseries.push(series2);
  var series3=getData(0, 2297944457000,"","","filter3","",3);
  if(series3!=null)dataseries.push(series3);
  var series4=getData(0, 2297944457000,"","","filter4","",4);
  if(series4!=null)dataseries.push(series4);
  
  
  $.plot($('#chart'), dataseries, chartoptions);

 

$("#unzoom").remove();
}

function showTooltip(x, y, contents) {
        $('<div id="tooltip">' + contents + '</div>').css( {
        position: 'absolute',
        display: 'none',
        top: y + 5,
        left: x + 5,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80
    }).appendTo("body").fadeIn(200);
}



function showChart() {
      
    drawChart();
  
    $("#chart").bind("plotselected", function (event, ranges) {
        // clamp the zooming to prevent eternal zoom
        if (ranges.xaxis.to - ranges.xaxis.from < 0.00001)
            ranges.xaxis.to = ranges.xaxis.from + 0.00001;
        if (ranges.yaxis.to - ranges.yaxis.from < 0.00001)
            ranges.yaxis.to = ranges.yaxis.from + 0.00001;
        
        // do the zooming
        startDateTime=new Date();
        endDateTime=0;
          var dataseries=[];
          var series1=getData(ranges.xaxis.from, ranges.xaxis.to,"","","filter1","",1);
          dataseries.push(series1);
          var series2=getData(ranges.xaxis.from, ranges.xaxis.to,"","","filter2","",2);
          if(series2!=null)dataseries.push(series2);
          var series3=getData(ranges.xaxis.from, ranges.xaxis.to,"","","filter3","",3);
          if(series3!=null)dataseries.push(series3);
          var series4=getData(ranges.xaxis.from, ranges.xaxis.to,"","","filter4","",4);
          if(series4!=null)dataseries.push(series4);
        plot = $.plot($("#chart"), dataseries,
                      $.extend(true, {}, chartoptions, {
                          xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to },
                          //yaxis: { min: ranges.yaxis.from, max: ranges.yaxis.to }
                      }));
        if($("#unzoom").length==0)$("#chart").before($('<button id="unzoom">zoom out</button>').click(drawChart)); 
    });
    $("#chart").bind("plothover", function (event, pos, item) {
        $("#x").text(pos.x.toFixed(2));
        $("#y").text(pos.y.toFixed(2));

            if (item) {
                if (previousPoint != item.datapoint) {
                    previousPoint = item.datapoint;
                    
                    $("#tooltip").remove();
                    var x = item.datapoint[0],
                        y = item.datapoint[1];
                    
                    showTooltip(item.pageX, item.pageY,
                                findPointToolTip(item.series.data,x,y));
                }
            }
            else {
                $("#tooltip").remove();
                previousPoint = null;            
            }
    });
  
}


function loadData(){
    var requestlog=$("#requestLogFile").val();
    var fordate=$("#fordate").val();
    var now=new Date();
    var dateno=now.getDate();
    if(dateno<10)dateno="0"+dateno;
    var monthno=now.getMonth()+1;
    if(monthno<10)monthno="0"+monthno;
    if(fordate=="")fordate=monthno+"/"+dateno+"/"+now.getFullYear();
    var filter=$("#filter").val();
    var startline=$("#startline").val();
    var endline=$("#endline").val();
    $.getJSON(datarequesturl, 
        {"requestlogfile":requestlog,"filter":filter,"startline":startline,"endline":endline,"fordate":fordate},
        function(data) {
          if(data.length>500 &&  $.browser.msie){ 
                  if(!confirm("There are "+data.length+" datapoints to plot.  This may be quite slow (particularly on Internet Explorer). Do you want to continue?")){
                  alert("Action cancelled.");
                  return;
              }
          }
          perfdata=data;
          currentdata[0]=parseData();
          showChart();

        });
     $("#fordate").val(fordate); 
     $("#chart").html("Loading...");      
} 

function getDataTable(){
var datatable="<table><tr><td>Date</td><td>Timing</td><td>User</td><td>URL</td></tr>";
for(var ix in perfdata){
  var line=perfdata[ix];
  var fields=line.split("|");
  var requesttime=parseInt(fields[0]);
  var reqDateTime=new Date();
  reqDateTime.setTime(requesttime);
  var timing=parseInt(fields[1])/1000;
  var dispDate=""+(reqDateTime.getMonth()+1)+"/"+(reqDateTime.getDate()+1)+"/"+(reqDateTime.getFullYear())+" ";
  var hours=reqDateTime.getHours();
  if(hours<10)dispDate+="0";
  dispDate+=hours+":";
  var mins=reqDateTime.getMinutes();
  if(mins<10)dispDate+="0";
  dispDate+=mins+":";
  var secs=reqDateTime.getSeconds();
  if(secs<10)dispDate+="0";
  dispDate+=secs;
  var text=fields[2].split(" ");
 
  datatable+="<tr><td>"+dispDate+"</td><td>"+timing+"</td><td>"+text[0]+"</td><td>"+(text.length>1?text[1]:'')+"</td></tr>";
}
datatable+="</table>";
var win=window.open();
win.document.write(datatable);

}

function AOWfilter(){
$("#filter1").val("/accessmcd/corp");
$("#filter2").val("/accessmcd/na/us");
$("#filter3").val("/accessmcd/apmea");
$("#filter4").val("/accessmcd/na/mcweb");
drawChart();
}

function Homepagefilter(){
$("#filter1").val("/accessmcd/corp.");
$("#filter2").val("/accessmcd/na/us.");
$("#filter3").val("/accessmcd/apmea/au.");
$("#filter4").val("/accessmcd/na/mcweb/en.");
drawChart();
}

function Browserfilter(){
$("#filter1").val("IE7");
$("#filter2").val("IE8");
$("#filter3").val("FF");
$("#filter4").val("Chrome");
drawChart();
}


function clearFilters(){
for(var i=1;i<5;i++){
$('#filter'+i).val('');
$("#filter"+i+"NbrDataPoints").html("");
$("#filter"+i+"Avg").html("");
$("#filter"+i+"NinetyPercent").html("");
}
drawChart();
}  