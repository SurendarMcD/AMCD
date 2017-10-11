<%--
*
* Parses Timing Logs for User Behavior analysis
* 2/19/2013 Erik Wannebo 
*
--%><%@ page import="java.io.*,java.util.*,java.util.regex.*,java.text.SimpleDateFormat"  %>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %> 
<sling:defineObjects />
<%
String username=slingRequest.getUserPrincipal().getName();
if(!username.equals("admin")
&& !username.equals("em006969")
&& !username.equals("e1152302")
&& !username.equals("em004795")
&& !username.equals("em015416")
&& !username.equals("em012853")
&& !username.equals("em102375")
&& !username.equals("e0066105")
&& !username.equals("e1202616")// trombetta



){
    out.write("<b><font color=red>You do not have access to this page.</font></b><br>");
    return;
}
%><head> 
    <title>AccessMcD Traffic</title>
    <meta http-equiv="Pragma" content="no-cache">

    <!--[if IE]><script language="javascript" src="/apps/mcd/docroot/scripts/flot/excanvas.min.js"></script><![endif]-->
    <link rel="stylesheet" href="/css/jquery-ui-1.7.2.datepicker.css" type="text/css" />
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery-1.4.1.min.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.js"></script>
    <script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery.flot.selection.js"></script>
    <script language="javascript"  src="/scripts/jquery-ui-1.7.2.datepicker.min.js" ></SCRIPT> 
    <script language="javascript"  src="/scripts/d3.v3.min.js"></script>
    <script language="javascript"  src="/scripts/sankey.js"></script>
<style>
body{
font : 12px helvetica,arial,sans-serif;
}
.node {
  stroke: #fff;
  stroke-width: 1.5px;
}

.link {
  stroke: #999;
  stroke-opacity: .6;
}

.node text {
  pointer-events: none;
  font: 12px helvetica,arial,sans-serif;
  font-weight: normal;
  color: #000000;
  stroke:#000;
  stroke-width: 1px;
}
</style>

<%!
private class TimingEvent  {
          public java.util.Date timestamp=null;
          public String eid="";
          public String mkt="";
          public String role="";
          public String url="";
          public boolean isExitDoc=false;
          public int sessionid=0;
          public long elapsed=0;
        }

public class eventComparator implements Comparator {
    
  public int compare(Object evt1, Object evt2) {
    if(((TimingEvent)evt2).eid.equals(((TimingEvent)evt1).eid)){
        return ((TimingEvent)evt1).timestamp.compareTo(((TimingEvent)evt2).timestamp);
    }else{
        return ((TimingEvent)evt1).eid.compareTo(((TimingEvent)evt2).eid);
    }
    }
}

private static Map sortByComparator(Map unsortMap) {
 
        List list = new LinkedList(unsortMap.entrySet());
 
        // sort list based on comparator
        Collections.sort(list, new Comparator() {
            public int compare(Object o2, Object o1) {
                return ((Comparable) ((Map.Entry) (o1)).getValue())
                                       .compareTo(((Map.Entry) (o2)).getValue());
            }
        });
 
        // put sorted list into map again
                //LinkedHashMap make sure order in which keys were inserted
        Map sortedMap = new LinkedHashMap();
        for (Iterator it = list.iterator(); it.hasNext();) {
            Map.Entry entry = (Map.Entry) it.next();
            sortedMap.put(entry.getKey(), entry.getValue());
        }
        return sortedMap;
    }



private String td(String val){
    return "<TD>"+val+"</TD>";
} 

private String td(String val,String bgcolor){
    return "<TD style='background-color:"+bgcolor+"'>"+val+"</TD>";
}

private void outputPathSessions(javax.servlet.jsp.JspWriter out,ArrayList<TimingEvent> events,String filter){
        SimpleDateFormat sf= new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
        
     try{
              
        out.println("<TABLE id='rawdata' class='tablesorter' >"); 
        out.println("<thead><tr style='font-weight:bold'>");
        out.println("<th>ID</th>");
        out.println("<th>Type</th>");
        out.println("<th>Date</th>");
        out.println("<th>User</th>");
        out.println("<th>Market</th>");
        out.println("<th>Role</th>");
        out.println("<th>Query</th>");
        out.println("<th>ResultNo</th>");
        out.println("<th></th>");
        out.println("<th>URL</th>");
        out.println("</tr></thead><tbody>");
        
        Iterator iterEvent=events.iterator();
        boolean bStart=true;
        String bgcolor="white";
        String lastEID="";
        String sessiondata="";
        TimingEvent lastevent=null;
        boolean bPassFilter=false;
        long sessionid=0;
        long start=0;
        while(iterEvent.hasNext()){
            
            TimingEvent event=(TimingEvent)iterEvent.next();
                    if(event.sessionid != sessionid){
                        if(bPassFilter){
                            
                            //sessiondata+="<tr><td colspan=12 >filter:"+filter+"</td></tr><tr>";
                            out.println(sessiondata);
                            
                             
                        }
                        sessionid=event.sessionid;
                        sessiondata="<tr><td colspan=12 ><hr /></td></tr><tr>";
                        lastevent=null;
                        start=event.timestamp.getTime();
                        bPassFilter=false;
                    }
                    if(!bPassFilter && (filter.equals("") || event.url.toLowerCase().contains(filter))){
                        bPassFilter=true;
                    }
                    if(event.url.toLowerCase().contains(filter)){
                        bgcolor="yellow";
                    }else{
                        bgcolor="";
                    }
                    sessiondata+="<tr>";
      
                        sessiondata+=td(""+event.sessionid);
                        sessiondata+=td("");

                        if(lastevent==null){
                            sessiondata+=td(sf.format(event.timestamp),bgcolor);
                            sessiondata+=td(event.eid,bgcolor);
                            sessiondata+=td(event.mkt,bgcolor);
                            sessiondata+=td(event.role,bgcolor);
                        }else{
                           
                            //sessiondata+=td(sf.format(event.timestamp),bgcolor);
                            sessiondata+=td("+"+event.elapsed+ " s.",(bgcolor));
                            sessiondata+=td("",bgcolor);
                            sessiondata+=td("",bgcolor);
                            sessiondata+=td("",bgcolor);
                        } 

                        //sessiondata+=td("<b>"+event.url+"</b>",(""));
                        //sessiondata+=td("<b>QuickLink</b>","#ff6");;
                       
                        if(event.isExitDoc)
                            sessiondata+=td("Exit");
                        else 
                            sessiondata+=td("");
                        String doclink="<a target=_blank href='"+event.url+"'>"+event.url+"</a>";
                        
                        sessiondata+=td("<b>"+doclink+"</b>",bgcolor); 
   

                    lastevent=event;
                    sessiondata+="</tr>";
                }
                
                if(bPassFilter)out.println(sessiondata);
        
        out.println("</tbody></table>");
 
        
    }catch (Exception e) {
            try{
                out.println("searchReport:Exception " + e);
            }catch(IOException ioe){
            }
    }
    return;
} 





private String cleanURL(String url){
    if(url.indexOf("://")>-1){
        int afterdomain=url.indexOf("/",url.indexOf("://")+3);
        url=url.substring(afterdomain);
    }
    if(url.indexOf("?")>-1)url=url.substring(0,url.indexOf("?"));
    if(url.startsWith("/content/"))url=url.substring("/content".length());
    if(url.startsWith("/accessmcd/"))url=url.substring("/accessmcd".length());
    if(url.contains("search.html"))url="/_search.html";
    if(url.contains("#"))url=url.substring(0,url.indexOf("#"));
    if(url.equals("/na/mcweb/en.html") || url.equals("/na/us.html") || url.equals("/corp.html"))url="";
    return url;
}

private String getRoleCode(String url){
    String ret=url;
    if(ret.lastIndexOf("/")>-1)
        ret=ret.substring(ret.lastIndexOf("/"));
    ret=ret.substring(ret.indexOf(".")+1);
    if(ret.indexOf(".")>-1)ret=ret.substring(0,ret.indexOf("."));
    
    return ret;
}

private boolean isHomepage(String url){
    return ((url.indexOf("/corp.")>-1) || (url.indexOf("/na/us.")>-1) || (url.indexOf("/na/mcweb/en.")>-1) || (url.indexOf("/na/mcweb/fr.")>-1));
}

private void analyzeEvents(javax.servlet.jsp.JspWriter out,ArrayList<TimingEvent> events,String filter,String rolefilter,int minhits,int chartsize,int circlesize){
        

        
        Collections.sort(events,new eventComparator());
        int sessioncount=0;

        boolean bQuickLinkSession=false;
        boolean bSlowSession=false;
        String lastquery="";
        
        boolean bStart=true;
        
        String lastEID="";
        
        long start=0;
        long elapsed=0;
        long lasteventtime=0;
        int count=0;
        int sessionlinksclicked=0;
        int sessionid=0;
        int sessionclickno=1;
        boolean bHaveQuery=false;
        String lasturl="";
        
        String rolecode="";
        
        TimingEvent lastevent=null;
        ArrayList<TimingEvent> sessionevents=new ArrayList<TimingEvent>();

        HashMap sessionurls=new HashMap();
        Iterator iterEvent=events.iterator();
        java.util.Date earliestTimestamp=new java.util.Date();
        
        while( iterEvent.hasNext()){
            //outdebug(out,""+sessionid);
            TimingEvent event=(TimingEvent)iterEvent.next();
            
            if(count==0)earliestTimestamp=event.timestamp;
            
            if(lastevent!=null){

                if((!lastevent.eid.equals(event.eid) || 
                        ((event.timestamp.getTime()-lastevent.timestamp.getTime())/1000)>300)
                        && (true || isHomepage(event.url))
                ){
                    
                    /*** Next Session ***/
                   
                    if(rolecode.equals("")|| rolefilter.equals("") || rolecode.equals(rolefilter)){
                        //incrementURLCounts(urlfollows,urllist,"EXIT",cleanURL(lastevent.url),filter);
                    }
                    rolecode="";
                    TimingEvent exitdoc=null;
                    //if(event.timestamp.getTime()<earliestTimestamp.getTime()){
                        earliestTimestamp=event.timestamp;
                    //}
                    for(TimingEvent e:sessionevents){
                            e.sessionid=sessionid;
                            exitdoc=e;
                    }
                    rolecode=getRoleCode(cleanURL(event.url));
                    
                    if(rolecode.equals("")|| rolefilter.equals("") || rolecode.equals(rolefilter)){
                        //incrementURLCounts(urlfollows,urllist,cleanURL(event.url),"START",filter);
                    }
                    if(exitdoc!=null)exitdoc.isExitDoc=true;
                    
                    
                   
                    sessionid++;
                    sessioncount++;
                    sessionclickno=1;
                    bStart=true;
                    sessionurls=new HashMap();
                    sessionurls.put(cleanURL(event.url),"1");
                    sessionlinksclicked=0;
                    lastEID=event.eid;
                    sessionevents=new ArrayList();
                    lastevent=event;
                    
                    /*** Next Session End ***/ 
                }else{
                    //same session - increment stats
                   
                    String eventurl=cleanURL(event.url);
                    String lasteventurl=cleanURL(lastevent.url);
                    //if(!eventurl.equals(lasteventurl)  && !sessionurls.containsKey(eventurl)){ 
                    if(!eventurl.equals(lasteventurl) ){ 
                        if(rolecode.equals(""))rolecode=getRoleCode(cleanURL(event.url));
                        if(rolecode.equals("")|| rolefilter.equals("") || rolecode.equals(rolefilter)){
                           //incrementURLCounts(urlfollows,urllist,eventurl,lasteventurl,filter,sessionclickno);
                           sessionclickno++;
                        }

                    }
                    sessionurls.put(eventurl,"1");
                    
                }
                
            }//lastevent not null          
            
            sessionevents.add(event);
            
            event.elapsed=(event.timestamp.getTime()-earliestTimestamp.getTime())/1000;
            lastevent=event;
            
            count++;
        }
        
       /*
       try{
            out.println("Since "+earliestTimestamp+"<br>");
        }catch(IOException ioe){
        }   
         
        */
            
        outputPathSessions(out, events,filter);  
        //outputFollows(out,urlfollows);
        //outputJSON(out,urlfollows,urllist,minhits,chartsize,circlesize);

}
private void parseRequests(javax.servlet.jsp.JspWriter out,String baseFileName,Calendar startDate,Calendar endDate, String filter,String rolefilter,int minhits,int chartsize,int circlesize){
 
        String strComma="";
        ArrayList events=new ArrayList();
        boolean bFoundDate=false;
        boolean bPassedDate=false;
        int filecount=-1;

        SimpleDateFormat sf=new SimpleDateFormat("MM/dd/yyyy H:mm:ss");
        String logEntryPattern = "^(\\d+\\/\\d+\\/\\d+ \\d+:\\d+:\\d+) Timing: ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)";
        Pattern p = Pattern.compile(logEntryPattern);
        DataInputStream in=null;
        Calendar calRequest=new GregorianCalendar(); 
        try{
            while(!bPassedDate&&filecount<10){
                if(bFoundDate){
                    bPassedDate=true;
                    bFoundDate=false;
                }
                System.out.println("processing file "+filecount);
                String requestlogfile=baseFileName+((filecount==-1)?"":"."+filecount);
                FileInputStream fstream = new FileInputStream(requestlogfile);
                in = new DataInputStream(fstream);
                BufferedReader br = new BufferedReader(new InputStreamReader(in));
                String strLine;
                int linecount=0;
                int totallinecount=0; 
                long localtime=System.currentTimeMillis();
                long timezoneoffset=(TimeZone.getTimeZone("America/Chicago").getOffset(localtime));
                while (((strLine=br.readLine())!=null))   {
                    Matcher matcher = p.matcher(strLine);
                    if(matcher.find() && matcher.group(6).equals("ms")){
                        String requestTime=matcher.group(1);
                        Date requestDate=sf.parse(requestTime);
                        calRequest.setTime(requestDate);
                        if(startDate.before(calRequest) && calRequest.before(endDate)){
                            if(!bFoundDate)bFoundDate=true;
                            bPassedDate=false;
                            TimingEvent event=new TimingEvent();
                            event.eid=matcher.group(4);
                            event.url=matcher.group(2);
                            /*
                            String location=matcher.group(3);
                            String eid=matcher.group(4);
                            String responseTime=matcher.group(5);
                            */

                            event.timestamp=requestDate;
                            //String outline=(requestDate.getTime()+timezoneoffset)+"|"+responseTime+"|"+eid+" "+url;
                            events.add(event);
                            linecount++;
                        }
                      }
                    if(linecount==1)strComma=",";
                    totallinecount++;
                  }
                 br.close();
                 in.close();
                 fstream.close();
                 filecount++;
             }
            }catch (Exception e){//Catch exception if any
              System.err.println("Error: " + e.getMessage());
            }finally{
                try{
                    if(in!=null)in.close();
                }catch(IOException ioe){
                    //OK
                }
            }   
            analyzeEvents(out,events,filter,rolefilter,minhits,chartsize,circlesize);
    }
%>
<%
String requestlogfile="timing.log";
String servletPath=request.getRealPath("/");
String quickstartPath=servletPath.substring(0,servletPath.indexOf("crx-quickstart"));
//out.write("var servletPath="+servletPath+";");

String filter=request.getParameter("filter");
if(filter==null||filter.equals(""))filter="/corp";
Calendar startdate= new GregorianCalendar();
Calendar enddate= new GregorianCalendar();
String fordate=request.getParameter("fordate");
if(fordate!=null&&!fordate.equals("")){
    startdate.setTime((new SimpleDateFormat("MM/dd/yyyy")).parse(fordate));
    enddate.setTime((new SimpleDateFormat("MM/dd/yyyy")).parse(fordate));
    }else{
        fordate=(new SimpleDateFormat("MM/dd/yyyy")).format(new Date());
    }

startdate.set(Calendar.HOUR,0);
startdate.set(Calendar.MINUTE,0);
startdate.set(Calendar.SECOND,0);

enddate.set(Calendar.HOUR,0);
enddate.set(Calendar.MINUTE,0);
enddate.set(Calendar.SECOND,0);
enddate.add(Calendar.DATE,1);

int days=1;
String strDays=request.getParameter("days");
if(strDays!=null&&!strDays.equals("1")){
    days=Integer.parseInt(strDays);
    //todo: adjust startdate
    startdate.add(Calendar.DATE,-1*days);
}else{
    strDays="1";
}
String rolefilter=request.getParameter("rolefilter");
if(rolefilter==null)rolefilter="";
String strchartsize=request.getParameter("chartsize");
int chartsize=600;
if(strchartsize!=null&& !strchartsize.equals(""))chartsize=Integer.parseInt(strchartsize);
int circlesize=(int)(chartsize/(180*Math.sqrt(days)));
String strminhits=request.getParameter("minhits");
if(strminhits==null||strminhits.equals(""))strminhits="";
int minhits=1;//default
if(!strminhits.equals(""))minhits=Integer.parseInt(strminhits);


%> 
<script>
 

    function openurl() {
        return function(d, i) {
            window.open("https://www.accessmcd.com/accessmcd"+d.name);
           
        }; 
    }

      function highlight2() {
        return function(d, i) {
            svg.selectAll("line").style("stroke", "#999").style("stroke-opacity",".6");
            var associated_inbound_links = svg.selectAll("line").filter(function(d) {
                return d.target.index == i;
            }).each(function(dLink, iLink) {
                d3.select(this).style("stroke", "red").style("stroke-opacity","1");
            });
            var associated_outbound_links = svg.selectAll("line").filter(function(d) {
                return d.source.index == i ;
            }).each(function(dLink, iLink) {
                d3.select(this).style("stroke", "blue").style("stroke-opacity","1");
            });
        }; 
    }
    
    
    var currentnode=0;
    var currentstate=1;
    function highlight() {
        return function(d, i) {
            if(currentnode==i){
                currentstate=-1*currentstate;
            }else{
                currentnode=i;
                currentstate=1;
            }
            svg.selectAll("line").style("stroke", "#999").style("stroke-opacity",".3");
            //svg.selectAll("circle").style("stroke", "#fff").style("stroke-opacity",".6").style("stroke-width","1.5px");
            //svg.selectAll("g").filter(function(dg,ig){return ig!=i;}).each(function(){d3.select(this).style("opacity", ".1");});
            svg.selectAll("g").each(function(dg,ig){d3.select(this).style("opacity", (ig==i?"1":".1"));});
            //svg.selectAll("text").style("opacity", ".1");
            //d3.select(this).parent().style("opacity", "1");
            
            var associated_inbound_links = svg.selectAll("line").filter(function(d) {
                return ((currentstate==1)?d.source.index:d.target.index)==i;
            }).each(function(dLink, iLink) {
                d3.select(this).style("stroke", ((currentstate==1)?"blue":"red")).style("stroke-opacity","1");
                svg.selectAll("g").filter(function(dc,ic){return ((currentstate==1)?dLink.target.index:dLink.source.index)==ic;})
                .each(function(dCirc, iCirc) {
                    d3.select(this).style( "opacity","1");
                });
            });
            $("#selectedmode").html("<font size=5 color="+(currentstate==1?"blue":"red")+">"+(currentstate==1?"outbound":"inbound")+"</font>");
           // $("#reset").show();

            force.stop();
            d3.event.stopPropagation();
            
        }; 
    
    }
    

    
    function resetHighlight() {
        
        svg.selectAll("line").style("stroke", "#999").style("stroke-opacity",".6");
        svg.selectAll("g").style("opacity", "1");
        $("#selectedmode").html("");
        //$("#reset").hide();
        currentnode=-1;
        force.start(); 
        
    }
     function unfix() {
        return function(d, i) {
            var unfix_circles = svg.selectAll(".node").filter(function(d) {
                d.fixed = false;
            })
        };
    }
    
   
    function dragstart(d, i) {
        force.stop() // stops the force auto positioning before you start dragging
       // alert('drag start'); 
    }

    function dragmove(d, i) {
        d.px += d3.event.dx;
        d.py += d3.event.dy;
        d.x += d3.event.dx;
        d.y += d3.event.dy; 
        tick(); // this is the key to make it work together with updating both px,py,x,y on d !
    }

    function dragend(d, i) {
        
        d.fixed = true; // of course set the node to fixed so the force doesn't include the node in its auto positioning stuff
        //tick();
        //force.resume();
    }
  

</script>
</head>
<body> 
<font size=6>AccessMcD Sessions</font>&nbsp;&nbsp;<span id="selectedmode"></span>
<!--[if IE]><font color=red>This page is best viewed in FireFox/Chrome.</font><![endif]--><form id="mainform" action="" method=GET>
<select name="days" onchange="$('#mainform').submit();">
<option <%=(strDays.equals("1"))?"selected":"" %> value="1">1</option>
<option <%=(strDays.equals("2"))?"selected":"" %> value="2">2</option>
<option <%=(strDays.equals("3"))?"selected":"" %> value="3">3</option>
<option <%=(strDays.equals("7"))?"selected":"" %> value="7">7</option>
</select><b>Days Through End Of:</b><input id="fordate" name="fordate" value="<%=fordate %>" onchange="$('#mainform').submit();">
<b>Path:</b><input name="filter" size=80 onchange="$('#mainform').submit();" value="<%=filter%>">

<b>Role:</b><select name="rolefilter" onchange="$('#mainform').submit();">
<option <%=(rolefilter.equals(""))?"selected":"" %> value="">ALL</option>
<option <%=(rolefilter.equals("ce"))?"selected":"" %>  value="ce">Employee</option>
<option <%=(rolefilter.equals("fe"))?"selected":"" %>  value="fe">Franchisee</option>
<option <%=(rolefilter.equals("fo"))?"selected":"" %>  value="fo">Franchisee Office Staff</option>
<option <%=(rolefilter.equals("fm"))?"selected":"" %>  value="fm">Franchisee Rest Mgr</option>
<option <%=(rolefilter.equals("rm"))?"selected":"" %>  value="rm">McOpCo Rest Mgr</option>
<option <%=(rolefilter.equals("sv"))?"selected":"" %>  value="sv">Supplier Vendor</option>
<option <%=(rolefilter.equals("ag"))?"selected":"" %>  value="ag">Agency</option>
</select>


<!--<button id="reload data" onclick="loadData();">reload data</button>-->  
</form>

</body>

<%
parseRequests(out,quickstartPath+"crx-quickstart/logs/"+requestlogfile,startdate,enddate,filter,rolefilter,minhits,chartsize,circlesize);

%>