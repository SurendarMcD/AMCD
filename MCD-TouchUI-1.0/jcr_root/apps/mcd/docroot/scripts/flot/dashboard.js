var series=[];
var currentdata=[];
var allpointLabels=[];
var pointLabels=[];

var previousPoint = null;
var chartedpage="";
var chartoptions=[
    {
            lines: {show:true },
            points: {show:true },
            grid: { hoverable:true},
            xaxis: { mode: "time" },
            yaxis: { min: 0 ,tickFormatter: function (v, axis) { return v.toFixed(axis.tickDecimals) +"s" }},
            legend: {position: "ne"},
            selection: { mode: "" }
    
},
{
            lines: {show:true },
            points: {show:true },
            grid: { hoverable:true},
            xaxis: { mode: "time" },
            yaxis: { min: 0 ,tickFormatter: function (v, axis) { return v.toFixed(axis.tickDecimals)}},
            legend: {position: "ne"},
            selection: { mode: "" }
        
    
  },
{
            lines: {show:true },
            points: {show:true },
            grid: { hoverable:true},
            xaxis: { mode: "time" },
            yaxis: { min: 0 ,tickFormatter: function (v, axis) { return v.toFixed(axis.tickDecimals)}},
            legend: {position: "ne"},
            selection: { mode: "" }
        
    
  }    
  ];

var startDateTime=new Date();
var endDateTime=0;
var sumDataPoints=0.0;

function parseData(columnno){
sumDataPoints=0;
var cnt=0;
startDateTime=new Date();
endDateTime=0;
var retSeries=new Array();
for(var i=0;i<perfdata.length;i++){
 for(var ix in perfdata[i].series){
  var line=perfdata[i].series[ix];
  var fields=line.split("|")
  var requesttime=parseInt(fields[0]);
  
  if(columnno==0){
    var avgtime=(parseInt(fields[2])/1000)/parseInt(fields[1]);
    pointLabels[fields[0]+"|"+avgtime]=fields[1];
    retSeries[cnt++]=[fields[0],avgtime]; 
  }
  if(columnno==1){
    var users=parseInt(fields[3]);
    pointLabels[fields[0]+"|"+users]=users;
    retSeries[cnt++]=[fields[0],users]; 
  }
  if(requesttime<startDateTime){
        startDateTime=requesttime;
    }else{
        if(requesttime>endDateTime)
           endDateTime=requesttime;
    }
  }
}
/*
 $("#TotalNbrDataPoints").html(cnt);
     if(cnt>0){
         var avg=Math.round((sumDataPoints/cnt)*10)/10;
         $("#TotalAvg").html(avg);
        // retSeries.sort(TimingSorter);
        // var ninetypct=retSeries[Math.floor(retSeries.length*0.9)][1];
        // alert(ninetypct);
         $("#TotalNinetyPercent").html(seriesPercentile(retSeries,0.9));
     }
*/
return retSeries;
}

function findPointToolTip(inseries,x,y){
    return pointLabels[x+"|"+y];
}
 
function parseCurrentData(x1,x2,seriesno,columnno){
sumDataPoints=0
var cnt=0;
var retSeries=new Array();


for(var ix=0;ix<perfdata[seriesno].series.length;ix++){
  var line=perfdata[seriesno].series[ix];
  var fields=line.split("|")
  var requesttime=parseInt(fields[0]);
  if(fields[0]>x1 && fields[0]<=x2){
      if(columnno==0){
        var avgtime=(parseInt(fields[2])/1000)/parseInt(fields[1]);
        pointLabels[fields[0]+"|"+avgtime]=fields[1];
        retSeries[cnt++]=[fields[0],avgtime]; 
      }
      if(columnno==1){
        var users=parseInt(fields[3]);
        pointLabels[fields[0]+"|"+users]=users;
        retSeries[cnt++]=[fields[0],users]; 
      }
      if(requesttime<startDateTime){
            startDateTime=requesttime;
        }else{
            if(requesttime>endDateTime)
               endDateTime=requesttime;
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

function getData( x1, x2,seriesno,columnno){
    //var data=new Array();
    var series=new Object();
    series.label="";
    series.data=[];
    series.data=parseCurrentData(x1,x2,seriesno,columnno);
    //console.log("series length:"+series.data.length);
    if(seriesno==0)series.color=timingseriescolor;
    if(seriesno==1)series.color="red";
    if(seriesno==2)series.color="green";
    if(seriesno==3)series.color="orange";
    if(seriesno==4)series.color="purple";
    series.label=perfdata[seriesno].server;

    return series;
}

function drawChart(bAuthor){
startDateTime=new Date();
endDateTime=0;


for(var chartno=0;chartno<2;chartno++){
     var dataseries=[];
     for(var ix=0;ix<perfdata.length;ix++){ 
      var series=getData(0, 2297944457000,ix,chartno);
      dataseries.push(series);
     }
      
    $.plot($('#chart'+chartno+(bAuthor?"a":"")), dataseries, chartoptions[chartno] );
    $("#chart"+chartno+(bAuthor?"a":"")).bind("plothover", function (event, pos, item) {
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
}


function loadData(bAuthorOnly){
    var requestlog=$("#requestLogFile").val();
    var filter=$("#filter").val();
    var fordate=$("#fordate").val();
    var timeinterval=$("#timeinterval").val();
    if(fordate.length==7)fordate=fordate.substring(0,3)+"0"+fordate.substring(3,4);
    
    if(fordate==""){
        var d=new Date();
        var dateno=d.getDate();
        if(dateno<10)dateno="0"+dateno;
        var monthno=d.getMonth()+1;
        if(monthno<10)monthno="0"+monthno;
        fordate=""+monthno+"/"+dateno+"/"+d.getFullYear();
        $("#fordate").val(fordate);
    }
    var startline=$("#startline").val();
    var endline=$("#endline").val();
    perfdata=[];
    
    if(!bAuthorOnly){
        $("#chart0").html("Loading...");
        $("#chart1").html("Loading...");
    
        
        $.getJSON(datarequesturl+fordate, 
            {},
            function(data) {
              if(data.length>500 &&  $.browser.msie){ 
                      if(!confirm("There are "+data.length+" datapoints to plot.  This may be quite slow (particularly on Internet Explorer). Do you want to continue?")){
                      alert("Action cancelled.");
                      return;
                  }
              }
              perfdata=data;
              //parseData(1); 
              drawChart(false);
              //showChart();
    
            });
     }
     //Author
     $("#chart0a").html("Loading...");
     $("#chart1a").html("Loading...");
     $.getJSON("/content/utility/utility.timings.html?summary=y&fordate="+fordate+"&timeinterval="+timeinterval, 
        {},
        function(data) {
          if(data.length>500 &&  $.browser.msie){ 
                  if(!confirm("There are "+data.length+" datapoints to plot.  This may be quite slow (particularly on Internet Explorer). Do you want to continue?")){
                  alert("Action cancelled.");
                  return;
              }
          }
          perfdata[0]=data;
          perfdata[0].server="Author";
          //parseData(1); 
          drawChart(true);
          //showChart();

        });           
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


function clearFilters(){
for(var i=1;i<5;i++){
$('#filter'+i).val('');
$("#filter"+i+"NbrDataPoints").html("");
$("#filter"+i+"Avg").html("");
$("#filter"+i+"NinetyPercent").html("");
}
drawChart();
}  