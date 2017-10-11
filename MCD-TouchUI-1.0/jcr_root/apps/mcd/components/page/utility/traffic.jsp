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

private void visualize(javax.servlet.jsp.JspWriter out,TreeMap urlfollows){

}

private void outputJSON(javax.servlet.jsp.JspWriter out,TreeMap urlfollows,TreeMap urllist,int minhits,int chartsize,int circlesize){
        SimpleDateFormat sf= new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
        
     try{
                
        int centerx=(chartsize/2);
        int centery=chartsize/2;
        String json="var urlpaths={nodes:[";
        Iterator iterUrls=urllist.keySet().iterator();
        TreeMap newurllist=new TreeMap();
        int ix=0;
        int reg=0;
        int hp=6;
        //int circlesize=chartsize/120;
        int large_sites=10;
        int large_site_step=1;
        double large_site_multiplier=0.9;
        int hpx=(centerx*9)/4;
        int hpy=100;
        double large_site_steps=80.0;
        double lpx=0;
        double lpy=0;
        int lastlhits=0;
        double lastlpx=0;
        double lastlpy=0;
        HashMap homepageY=new HashMap();
        HashMap homepageX=new HashMap();
        while(iterUrls.hasNext() ){
            String url=(String)iterUrls.next();
            Integer urlhits=(Integer)urllist.get(url);
            if(urlhits.intValue()>=minhits){
                boolean bSkip=false;
                
                //json+="{name:\""+url+"\",hits:"+urlhits.toString()+"},";
                
                if(true){
                    if(url.equals("/_search.html")){
                        json+="{name:\"/Search.html\",hits:"+urlhits.toString()+",x:"+centerx+",y:"+centery+",fixed:true";
                        bSkip=true;
                    }else{
                        json+="{name:\""+url+"\",hits:"+urlhits.toString()+"";
                    }
                    
                    
                    if(url.contains("isp_whitelist.html")){
                        json+=",x:"+centerx*2+",y:"+centery*0.20+",fixed:true";
                        bSkip=true;
                    }
                    /*if(url.contains("regns.html") || (url.contains("/regns/") && url.contains("home.html"))){
                        double regx=(centerx*1.8)+(Math.cos((2*Math.PI)*(reg/30.0))*100);
                        double regy=(centery*1.7)+(Math.sin((2*Math.PI)*(reg/30.0))*100);
                        json+=",x:"+regx+",y:"+regy+",fixed:true"; 
                        reg++;  
                        bSkip=true;
                    }*/
                    if(url.contains("/us.") || url.contains("/corp.")|| url.contains("/mcweb/en.")|| url.contains("/mcweb/fr.")|| url.contains("/apmea/au.")|| url.contains("/apmea.nz.")){
                        //double hpx=0+(Math.cos((2*Math.PI)*(hp/60.0))*centerx*2.25);
                        //double hpy=centery/2+(Math.sin((2*Math.PI)*(hp/60.0))*centerx*2.25);
                        String hpyurl=url.replace("/us.","/us/").replace("/corp.","/corp/").replace("/en.","/en/").replace("/fr.","/fr/");
        
                        homepageY.put(hpyurl,new Integer(hpy)); 
                        homepageX.put(hpyurl,new Integer(hpx)); 
                        hpy+=Math.sqrt((urlhits+1)*circlesize);
                        json+=",x:"+hpx+",y:"+hpy+",fixed:true";
                        hpy+=Math.sqrt((urlhits+1)*circlesize);
        
                        bSkip=true;
                    }
                    if(url.contains("/sitesAZ.")||url.contains("/sitesA-Z.")){
                        //hpx=-50+(Math.cos((2*Math.PI)*(sitesaz/60.0))*centerx*2.25);
                        //hpy=-50+centery/2+(Math.sin((2*Math.PI)*(sitesaz/60.0))*centerx*2.25);
                        String hpyurl=url.replace("sitesAZ.","").replace("sitesA-Z.","");
                        Integer hpY=(Integer)homepageY.get(hpyurl);
                        int sitex=2*centerx;
                        int sitey=2*centery;
                        if(hpY!=null)
                            sitey=hpY.intValue();
        
                        Integer hpX=(Integer)homepageX.get(hpyurl);
        
                        if(hpX!=null)
                            sitex=hpX.intValue();
         
                        json+=",x:"+(sitex-50)+",y:"+(sitey-25)+",fixed:true";
        
                        bSkip=true;
                        
                    }
                    if(!bSkip && urlhits>=(40/Math.sqrt(circlesize))){
                        do{
                        lpx=centerx+(Math.cos((2*Math.PI)*(large_sites/large_site_steps))*(centerx*large_site_multiplier));
                        lpy=centery+(Math.sin((2*Math.PI)*(large_sites/large_site_steps))*(centery*large_site_multiplier));
                        large_sites+=1; 
                        if(large_sites>(large_site_steps-2)){
                            large_sites=0;
                            large_site_multiplier-=0.2;
                        }
                        }while(Math.sqrt((lastlpx-lpx)*(lastlpx-lpx)+(lastlpy-lpy)*(lastlpy-lpy))<(Math.sqrt((urlhits+1)*circlesize)+Math.sqrt((lastlhits+1)*circlesize)));
                        
                        json+=",x:"+lpx+",y:"+lpy+",fixed:true";
                        /*
                        large_sites+=large_site_step;
                        if(large_sites>(large_site_steps-1)){
                            //large_site_step=-1*large_site_step;
                            large_sites=0;
                            large_site_multiplier-=0.1;
                        }
                        */
                        //large_sites+=large_site_step; 
                        lastlpx=lpx;
                        lastlpy=lpy;
                        lastlhits=urlhits;
                        
                    }
                    /*if(url.contains("us.fm.html"))json+=",x:800,y:100,fixed:true";
                    if(url.contains("sitesAZ.fm.html"))json+=",x:700,y:50,fixed:true";
                    if(url.contains("us.rm.html"))json+=",x:825,y:250,fixed:true";
                    if(url.contains("sitesAZ.rm.html"))json+=",x:825,y:300,fixed:true";
                    if(url.contains("us.fe.html"))json+=",x:850,y:350,fixed:true";
                    if(url.contains("us.fo.html"))json+=",x:825,y:450,fixed:true";
                    if(url.contains("us.ce.html"))json+=",x:800,y:550,fixed:true";
                    if(url.contains("corp.fm.html"))json+=",x:800,y:100,fixed:true";
                    if(url.contains("corp.rm.html"))json+=",x:825,y:250,fixed:true";
                    if(url.contains("corp.fe.html"))json+=",x:825,y:400,fixed:true";
                    if(url.contains("corp.ce.html"))json+=",x:800,y:550,fixed:true";           
                    */
                    if(url.contains("search.html"))json+=",x:"+centerx+",y:"+centery+",fixed:true";
                    
                    //if(url.contains("home.html"))json+=",fixed:true";
                    json+="},";
                }//skip positioning
                newurllist.put(url,ix);
                ix++;
                }
        }
        json=json.substring(0,json.length()-1)+"]";
        json+=",links:[";
        iterUrls=urlfollows.keySet().iterator();
        ix=0;
        while(iterUrls.hasNext()){
            
            String url=(String)iterUrls.next();
            HashMap urlcounts=(HashMap)urlfollows.get(url);
            
            int totalcount=((Integer)urlcounts.get("totalcount")).intValue();

            Iterator iterCounts=urlcounts.keySet().iterator();


            while(iterCounts.hasNext()){
                String followurl=(String)iterCounts.next();
                Integer followcount=(Integer)urlcounts.get(followurl);
                if(!followurl.equals("totalcount")){
                    Integer srcurl=(Integer)newurllist.get(url);
                    Integer flwurl=(Integer)newurllist.get(followurl);
                    if(srcurl!=null && flwurl!=null){
                        json+="{source:"+srcurl+",target:"+flwurl+",value:"+followcount+"},";
                    }
                    
                } 
            }
            ix++;
            
        }
        
        json=json.substring(0,json.length()-1)+"]};";
        out.println("<script language=Javascript>");
        out.println(json);
        out.println("</script>");
        
    }catch (Exception e) {
            try{
                out.println("timingstats:Exception " + e);
            }catch(IOException ioe){
            }
    }
    return;
} 

private void outputFollows(javax.servlet.jsp.JspWriter out,TreeMap urlfollows){
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
        
        Iterator iterUrls=urlfollows.keySet().iterator();
        String html="";
        String bgcolor="white";
        while(iterUrls.hasNext()){
            
            String url=(String)iterUrls.next();
            HashMap urlcounts=(HashMap)urlfollows.get(url);
            HashMap sortedurlcounts=(HashMap)sortByComparator(urlcounts);
            int totalcount=((Integer)sortedurlcounts.get("totalcount")).intValue();
            if(totalcount>5){
                Iterator iterCounts=sortedurlcounts.keySet().iterator();
                int count=0;
                if(bgcolor.equals("white"))
                    bgcolor="#dddddd";
                else 
                    bgcolor="white";
                while(iterCounts.hasNext()){
                    String followurl=(String)iterCounts.next();
                    Integer followcount=(Integer)sortedurlcounts.get(followurl);
                    if(!followurl.equals("totalcount")){
                        double percent=((followcount.intValue()*1000)/totalcount)/10.0; 
                        if(percent>0.1){
                            html="<tr bgcolor='"+bgcolor+"' style='font-size:"+(8+(Math.log(followcount)*5))+"px;'>";
                           
                            //html+=td(count==0?url:"");
                            //html+=td(followurl);
                            html+=td(url+"->"+followurl);
                            
                            html+=td(percent+"%");
                            html+=td(followcount.toString());
                            html+="</tr>";
                              
                            out.println(html);
                        }
                        count++;
                    }
                }
                
            }//totalcount
        }
        out.println("</tbody></table>");
 
        
    }catch (Exception e) {
            try{
                out.println("timingstats:Exception " + e);
            }catch(IOException ioe){
            }
    }
    return;
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
        
        long start=0;
        while(iterEvent.hasNext()){
            
            TimingEvent event=(TimingEvent)iterEvent.next();
                    if(lastevent!=null && event.sessionid != lastevent.sessionid){
                        if(bPassFilter){
                            out.println(sessiondata);
                            sessiondata="<tr><td colspan=12 ><hr /></td></tr><tr>";
                        }
                        
                        //sessiondata="";
                        lastevent=null;
                        start=event.timestamp.getTime();
                        bPassFilter=false;
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

                        sessiondata+=td("<b>"+event.url+"</b>",(""));
                        //sessiondata+=td("<b>QuickLink</b>","#ff6");;
                       
                        if(event.isExitDoc)
                            sessiondata+=td("Exit");
                        else 
                            sessiondata+=td("");
                        String doclink="<a target=_blank href='"+event.url+"'>"+event.url+"</a>";
                        
                        sessiondata+=td("<b>"+doclink+"</b>",("")); 
   
                    if(!bPassFilter && (filter.equals("") || event.url.toLowerCase().contains(filter))){
                        bPassFilter=true;
                    }
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


private void incrementURLCounts(Map urlfollows,Map urllist,String eventurl,String lasteventurl,String filter,int sessionclickno){

     if(!filter.equals(""))
         if(!(((eventurl.startsWith(filter) || lasteventurl.startsWith(filter)))) || (eventurl.equals("") || lasteventurl.equals("")))return;
      
     //if(!urlfollows.containsKey(eventurl) && !urlfollows.containsKey(eventurl)){
         incrementURLList(urllist,eventurl,filter);
        if(sessionclickno==1) incrementURLList(urllist,lasteventurl,filter);
         if(urlfollows.containsKey(lasteventurl)){
             HashMap urlcounts=(HashMap)urlfollows.get(lasteventurl);
                if(urlcounts.containsKey(eventurl)){
                    Integer urlcount=(Integer)urlcounts.get(eventurl);
                    urlcounts.put(eventurl,new Integer(urlcount.intValue()+1));
                }else{
                    urlcounts.put(eventurl,new Integer(1));
                }    
                if(urlcounts.containsKey("totalcount")){
                    Integer urlcount=(Integer)urlcounts.get("totalcount");
                    urlcounts.put("totalcount",new Integer(urlcount.intValue()+1));
                }else{
                    urlcounts.put("totalcount",new Integer(1));
                }     
            }else{
                HashMap urlcounts=new HashMap();
                urlcounts.put(eventurl,new Integer(1));
                urlcounts.put("totalcount",new Integer(1));
                urlfollows.put(lasteventurl,urlcounts);
            }
     //}

}

private void incrementURLList(Map urllist,String url,String filter){

     //String filter="/corp/services_support";
     //if(!filter.equals("") && !(url.startsWith("/mcd/")|| url.contains("search.html")  || url.startsWith(filter)) )return;
     if(urllist.containsKey(url)){
            Integer urlcount=(Integer)urllist.get(url);
            urllist.put(url,new Integer(urlcount.intValue()+1)); 
     }else{
        urllist.put(url,new Integer(1));
     }

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
        TreeMap urlfollows=new TreeMap(); 
        TreeMap urllist=new TreeMap(); 
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
                           incrementURLCounts(urlfollows,urllist,eventurl,lasteventurl,filter,sessionclickno);
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
            
        //outputPathSessions(out, events,"");  
        //outputFollows(out,urlfollows);
        outputJSON(out,urlfollows,urllist,minhits,chartsize,circlesize);

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
%><%
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

parseRequests(out,quickstartPath+"crx-quickstart/logs/"+requestlogfile,startdate,enddate,filter,rolefilter,minhits,chartsize,circlesize);

%> 
<script>

var width = <%=chartsize%>+300,
    height = <%=chartsize%>;

//var color = d3.scale.category20();
function color(url){
if(url.indexOf("Search.html")>-1)return "yellow";
if(url.indexOf("isp_whitelist.html")>-1)return "blue";

if(url.indexOf("/services_support")>-1)return "#007796";
if(url.indexOf("/career")>-1)return "#e37123";
if(url.indexOf("/compensation")>-1)return "#a6a93a";
if(url.indexOf("/company")>-1)return "#6f7cb6";
if(url.indexOf("/corp/marketing")>-1)return "#941a46";
if(url.indexOf("/legal")>-1)return "#5c297e";
if(url.indexOf("/corp.")>-1)return "#dc291e";

if(url.indexOf("/people")>-1)return "#e37123";
if(url.indexOf("/business_resources")>-1)return "#941a46";
if(url.indexOf("/about_company")>-1)return "#6f7cb6";
if(url.indexOf("/restaurant_ops")>-1)return "#a6a93a";
if(url.indexOf("/legal_policies")>-1)return "#5c297e";
if(url.indexOf("/us.")>-1)return "#dc291e";
if(url.indexOf("/regns")>-1)return "#dc291e";

if(url.indexOf("/mcweb")>-1){
    if(url.indexOf("/en.")>-1 || url.indexOf("/fr.")>-1)return "#dc291e";
    if(url.indexOf("/about")>-1)return "#eaa90a";
    if(url.indexOf("/brand")>-1)return "#798f3c";
    if(url.indexOf("/business")>-1)return "#644e38";
    if(url.indexOf("/restaurant")>-1)return "#426f9a";
    if(url.indexOf("/learning")>-1)return "#2d4957";
    if(url.indexOf("/mymcd")>-1)return "#cf9405";
    if(url.indexOf("/operator")>-1)return "#334418";   
}


return "gray";
}
var force; 
var svg;

$(function () {
    $("#fordate").datepicker();
    $("#reset").hide();
  force = d3.layout.force()
    .charge(-120)
    .linkDistance(30)
    .size([width, height]);

  svg = d3.select("#chart").append("svg")
    .attr("width", width)
    .attr("height", height)
    .on("click",resetHighlight);

  graph=urlpaths; 
<% if(false){  //sankey
%>
var sankey = d3.sankey()
    .size([width, height])
    .nodeWidth(15)
    .nodePadding(10)
    .nodes(graph.nodes)
    .links(graph.links)
    .layout(32);
    
var path = sankey.link(); 

var link = svg.append("g").selectAll(".link")
      .data(graph.links)
    .enter().append("path")
      .attr("class", "link")
      .attr("d", path)
      .style("stroke-width", function(d) { return Math.max(1, d.dy); })
      .sort(function(a, b) { return b.dy - a.dy; });

  link.append("title")
      .text(function(d) { return d.source.name + " → " + d.target.name + "\n" + format(d.value); });

  var node = svg.append("g").selectAll(".node")
      .data(energy.nodes)
    .enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
    .call(d3.behavior.drag()
      .origin(function(d) { return d; })
      .on("dragstart", function() { this.parentNode.appendChild(this); })
      .on("drag", dragmove));

  node.append("rect")
      .attr("height", function(d) { return d.dy; })
      .attr("width", sankey.nodeWidth())
      .style("fill", function(d) { return d.color = color(d.name.replace(/ .*/, "")); })
      .style("stroke", function(d) { return d3.rgb(d.color).darker(2); })
    .append("title")
      .text(function(d) { return d.name + "\n" + format(d.value); });

  node.append("text")
      .attr("x", -6)
      .attr("y", function(d) { return d.dy / 2; })
      .attr("dy", ".35em")
      .attr("text-anchor", "end")
      .attr("transform", null)
      .text(function(d) { return d.name; })
    .filter(function(d) { return d.x < width / 2; })
      .attr("x", 6 + sankey.nodeWidth())
      .attr("text-anchor", "start");

  function dragmove(d) {
    d3.select(this).attr("transform", "translate(" + d.x + "," + (d.y = Math.max(0, Math.min(height - d.dy, d3.event.y))) + ")");
    sankey.relayout();
    link.attr("d", path);
  }


<% }else{ %>





   
  force
      .nodes(graph.nodes)
      .links(graph.links)
      .gravity(0.1)
      .charge(-100)
      .start();

  var link = svg.selectAll(".link")
      .data(graph.links)
    .enter().append("line")
      .attr("class", "link")
      .style("stroke-width", function(d) { return Math.sqrt((<%=circlesize %>/5)*d.value); });

   var node = svg.selectAll(".node")
      .data(graph.nodes)
      .enter().append("g") 
      .attr("class", "node")
      .call(force.drag);
      
   
   node.append("circle")
      .attr("r", function(d){return Math.sqrt((d.hits+1)*<%=circlesize %>);})
      .style("fill", function(d) { return color(d.name); })
      .on("click",highlight())
      .on("contextmenu",openurl());
  

  node.append("title")
      .text(function(d) { return d.name; });

    
  node.append("text")
     .attr("text-anchor", "middle")
     .attr("dy", ".35em")
    //.text(function(d) { return d.name;});
    .text(function(d) { 
      var label="";
      if( d.name.indexOf("/home.html")>-1){
        label=d.name.substring(0,d.name.indexOf("/home.html"));
      }else{
          if(d.hits>=10)label=d.name.substring(0,d.name.indexOf(".html"));
      }
      label=label.substring(label.lastIndexOf("/")+1);
      return label; });
      


  force.on("tick", function() {
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    //node.attr("cx", function(d) { return d.x; })
    //    .attr("cy", function(d) { return d.y; });
        
    node.attr("transform", function(d) {
      return "translate(" + [d.x, d.y] + ")";
});
        //force.stop();
  });//onload
     
  var node_drag = force.drag()
        .on("dragstart", dragstart)
        .on("drag", dragmove)
        .on("dragend", dragend);

 <% } %>
  
  });   
 

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
<font size=6>AccessMcD Traffic</font>&nbsp;&nbsp;<span id="selectedmode"></span>
<!--[if IE]><font color=red>This page is best viewed in FireFox/Chrome.</font><![endif]--><form id="mainform" action="" method=GET>
<select name="days" onchange="$('#mainform').submit();">
<option <%=(strDays.equals("1"))?"selected":"" %> value="1">1</option>
<option <%=(strDays.equals("2"))?"selected":"" %> value="2">2</option>
<option <%=(strDays.equals("3"))?"selected":"" %> value="3">3</option>
<option <%=(strDays.equals("7"))?"selected":"" %> value="7">7</option>
</select><b>Days Through End Of:</b><input id="fordate" name="fordate" value="<%=fordate %>" onchange="$('#mainform').submit();">
<b>Path:</b><select name="filter" onchange="$('#mainform').submit();">
<option <%=(filter.equals("/corp"))?"selected":"" %> value="/corp">/corp</option>
<option <%=(filter.equals("/na/us"))?"selected":"" %>  value="/na/us">/na/us</option>
<option <%=(filter.equals("/na/us/natl/regns"))?"selected":"" %>  value="/na/us/natl/regns">/na/us/natl/regns</option>
<option <%=(filter.equals("/na/mcweb/en"))?"selected":"" %>  value="/na/mcweb/en">/na/mcweb/en</option>
<option <%=(filter.equals("/na/mcweb/fr"))?"selected":"" %>  value="/na/mcweb/fr">/na/mcweb/fr</option>
<option <%=(filter.equals("/mcd"))?"selected":"" %>  value="/mcd">/mcd</option>
<option <%=(filter.equals("/apmea/au"))?"selected":"" %>  value="/apmea/au">/apmea/au</option>
<option <%=(filter.equals("/apmea/nz"))?"selected":"" %>  value="/apmea/nz">/apmea/nz</option>
</select>
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
<b>Minimum Hits/Page</b><select name="minhits" onchange="$('#mainform').submit();">
<option <%=(minhits==1)?"selected":"" %> value="1">1</option>
<option <%=(minhits==5)?"selected":"" %>  value="5">5</option>
<option <%=(minhits==10)?"selected":"" %>  value="10">10</option>
<option <%=(minhits==20)?"selected":"" %>  value="20">20</option>
<option <%=(minhits==50)?"selected":"" %>  value="50">50</option>
<option <%=(minhits==100)?"selected":"" %>  value="100">100</option>
</select> 
<b>Chart Size:</b><select name="chartsize" onchange="$('#mainform').submit();">
<option <%=(chartsize==600)?"selected":"" %> value="600">small</option>
<option <%=(chartsize==750)?"selected":"" %>  value="750">medium</option>
<option <%=(chartsize==900)?"selected":"" %>  value="900">large</option>
</select> 
<!--<button id="reload data" onclick="loadData();">reload data</button>-->  
</form>
<div id="chart"></div>
</body>