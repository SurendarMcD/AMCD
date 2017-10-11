<%--
*
* Parses CQ Error Logs
* and returns the data on the "Timing" entries for the Chart Utility
* 4/27/2010 Erik Wannebo
*
--%><%@ page import="java.io.*,
java.util.*,
java.util.regex.*,
org.apache.commons.httpclient.*,
org.apache.commons.httpclient.auth.*,
org.apache.commons.httpclient.methods.*,
java.text.SimpleDateFormat"  %>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects /><%!
private String parseRequests(String baseFileName,String fordate,String filter){
        StringBuffer sb=new StringBuffer();
        String strComma="";
        boolean bFoundDate=false;
        boolean bPassedDate=false;
        int filecount=-1;
        HashMap<String,String> requestTimes=new HashMap<String,String>();
        HashMap<String,String> urls=new HashMap<String,String>();
        SimpleDateFormat sf=new SimpleDateFormat("MM/dd/yyyy H:mm:ss");
        String logEntryPattern = "^(\\d+\\/\\d+\\/\\d+ \\d+:\\d+:\\d+) Timing: ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)";
        Pattern p = Pattern.compile(logEntryPattern);
        DataInputStream in=null;
           try{
            while(!bPassedDate&&filecount<10){
                if(bFoundDate){
                    bPassedDate=true;
                    bFoundDate=false;
                }
                String requestlogfile=baseFileName+((filecount==-1)?"":"."+filecount);
                FileInputStream fstream = new FileInputStream(requestlogfile);
                in = new DataInputStream(fstream);
                BufferedReader br = new BufferedReader(new InputStreamReader(in));
                String strLine;
                int linecount=0;
                int totallinecount=0; 
                long localtime=System.currentTimeMillis();
                long timezoneoffset=(TimeZone.getTimeZone("America/Chicago").getOffset(localtime));
                //sb.append("timezoneoffset:"+timezoneoffset);
                //timezoneoffset=0;
                while (((strLine=br.readLine())!=null))   {
                    Matcher matcher = p.matcher(strLine);
                    if(matcher.find() && matcher.group(6).equals("ms")){
                        if(strLine.startsWith(fordate)){
                            if(!bFoundDate)bFoundDate=true;
                            bPassedDate=false;
                            if(filter.equals("") || strLine.indexOf(filter)>-1){
                                String requestTime=matcher.group(1);
                                String url=matcher.group(2);
                                String location=matcher.group(3);
                                String eid=matcher.group(4);
                                String responseTime=matcher.group(5);
                                Date requestDate=sf.parse(requestTime);
                                
                                String outline=(requestDate.getTime()+timezoneoffset)+"|"+responseTime+"|"+eid+" "+url;
                                sb.append(strComma+"\""+outline+"\"\n");
                                linecount++;
                            }
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
                    in.close();
                }catch(IOException ioe){
                    //OK
                }
            }   

            return sb.toString();
    
    }
    
    private String parseSummaryRequests(String baseFileName,String fordate,String strTimeInterval){
        StringBuffer sb=new StringBuffer();
        String strComma="";
        HashMap<String,String> requestTimes=new HashMap<String,String>();
        HashMap<String,String> urls=new HashMap<String,String>();
        SimpleDateFormat sf=new SimpleDateFormat("MM/dd/yyyy H:mm:ss");
        int timeinterval=Integer.parseInt(strTimeInterval);
        String logEntryPattern = "^(\\d+\\/\\d+\\/\\d+ \\d+:\\d+:\\d+) Timing: ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)";
        Pattern p = Pattern.compile(logEntryPattern);
        DataInputStream in=null;
        boolean bFoundDate=false;
        boolean bPassedDate=false;
        int linecount=0;
        int filecount=-1;
        //int timeinterval=15;
        int timescale=(24*60)/timeinterval;
        Date[] times=new Date[timescale];
        int[] timeRequests=new int[timescale];
        long[] timings=new long[timescale];
        HashMap[] uniqueUsers=new HashMap[timescale];
        long localtime=System.currentTimeMillis();
        long timezoneoffset=(TimeZone.getTimeZone("America/Chicago").getOffset(localtime));  
        
        try{
            for(int i=0;i<timescale;i++){
                uniqueUsers[i]=new HashMap();
                int hour=(timeinterval*i)/60;
                int minute=(timeinterval*i)%60;
                times[i]=sf.parse(fordate+" "+(hour<10?"0":"")+hour+":"+(minute<10?"0":"")+minute+":00");
            }
              
            while(!bPassedDate&&filecount<10){
                    if(bFoundDate){
                        bPassedDate=true;
                        bFoundDate=false;
                    }
                    String requestlogfile=baseFileName+((filecount==-1)?"":"."+filecount);
                    FileInputStream fstream = new FileInputStream(requestlogfile);
                    in = new DataInputStream(fstream);
                    BufferedReader br = new BufferedReader(new InputStreamReader(in));
                    String strLine;

                    int totallinecount=0; 

                    while (((strLine=br.readLine())!=null))   {
                        Matcher matcher = p.matcher(strLine);
                            if(matcher.find() && matcher.group(6).equals("ms")){
                                if(strLine.startsWith(fordate)){
                                   
                                    if(!bFoundDate)bFoundDate=true;
                                    bPassedDate=false;

                                    String requestTime=matcher.group(1);
                                    Date requestDate=sf.parse(requestTime);
                                    int hours=requestDate.getHours();
                                    int minutes=requestDate.getMinutes();
                                    int tm=((hours*60)+minutes)/timeinterval;
                                    //String url=matcher.group(2);
                                    //String location=matcher.group(3);
                                    String eid=matcher.group(4);
                                    String responseTime=matcher.group(5);
                                    //sb.append("hour:"+hour);
                                    
                                    if(!eid.equals("")){
                                        uniqueUsers[tm].put(eid, "1");
                                    }
                                    timeRequests[tm]=timeRequests[tm]+1;
                                    timings[tm]=timings[tm]+Integer.valueOf(responseTime).intValue();
                                           
                                    
                                    linecount++;
                                }
                            }
                            
                        totallinecount++;
                    }
                    br.close();
                    in.close();
                    fstream.close();
                    filecount++;
                }
                
            }catch (Exception e){//Catch exception if any
              sb.append("Error: " + e.getMessage());
            }finally{
                try{
                    in.close();
                }catch(IOException ioe){
                    //OK
                }
            }   
            
            for(int tm=0;tm<timescale;tm++){

                String outline=(times[tm].getTime()+timezoneoffset)+"|"+timeRequests[tm]+"|"+timings[tm]+"|"+uniqueUsers[tm].size();
                sb.append(strComma+"\""+outline+"\"\n");
                strComma=",";
            }
            return "{\"server\":\"servername\",\"series\":["+sb.toString()+"]}";
    
    }
    
    
     public static byte[] getCQ5Content(String url){
             
            byte[] retbytes="".getBytes();
            GetMethod getPageMeth=null; 
            org.apache.commons.httpclient.HttpClient client = new HttpClient();
            HostConfiguration host = client.getHostConfiguration();
            
            try {

                host.setHost(new org.apache.commons.httpclient.URI(url));
                org.apache.commons.httpclient.Credentials credentials = new UsernamePasswordCredentials("admin", "H@rs!615D");
                client.getState().setCredentials(AuthScope.ANY, credentials);
                
                getPageMeth= new GetMethod(url);
                
                getPageMeth.setDoAuthentication( true );       
                getPageMeth.getParams().setParameter("http.socket.timeout", new Integer(10000));        
                client.getParams().setAuthenticationPreemptive( true );

                int status = client.executeMethod(getPageMeth);
                              
                if(status==200){
                    //retbytes= getPageMeth.getResponseBody(); 
                    byte[] byteArray=new byte[1024];
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream() ;
                    int count = 0 ;
                    while((count = getPageMeth.getResponseBodyAsStream().read(byteArray, 0, byteArray.length)) > 0)
                    { 
                     outputStream.write(byteArray, 0, count) ;
                    }                 
                    retbytes=outputStream.toByteArray();             
                 }      
            } catch(Exception e){
            }
            finally {
                getPageMeth.releaseConnection();
                client=null;
            }
            return retbytes;
     }

    
    private String getPublishSummaries(String datestring,String timeinterval){
        StringBuffer sb=new StringBuffer();
        String strComma="";
        /*
        String[] serverlist={
        "mcdeagsun113b.mcd.com:4212",        
        "mcdeagsun113b.mcd.com:4213"
        };
         */
        
        String[] serverlist={
         "mcdeagsun113b.mcd.com:4212",
         "mcdeagsun113b.mcd.com:4216", 
         "mcdeagsun115.mcd.com:4212",       
         "mcdeagsun115.mcd.com:4214"
        };
        /*
        "mcdeagsun113b.mcd.com:4213",
        "mcdeagsun113b.mcd.com:4214",
       ,"mcdeagsun115.mcd.com:4213"};       
        */
        for(int ix=0;ix<serverlist.length;ix++){
            String publishtimings=new String(getCQ5Content("http://"+serverlist[ix]+"/content/utility/utility.timings.html?summary=y&fordate="+datestring+"&timeinterval="+timeinterval));
            if(!publishtimings.equals("")){
                publishtimings=publishtimings.replaceAll("servername",serverlist[ix]);
                sb.append(strComma+publishtimings+"\n");
                strComma=",";
            }
        }
        return sb.toString();
    
    }
%><%
HttpServletRequest cqReq = request;
boolean isAdmin=false;
if(!slingRequest.getUserPrincipal().getName().equals("admin") && !slingRequest.getUserPrincipal().getName().equals("em006969")){
    isAdmin=false;
   // out.write("userid: "+slingRequest.getUserPrincipal().getName().equals("em006969")+"<br>");

    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    out.write("<a href='/libs/cq/core/content/login.html?resource=/content/utility/utility.timings.html'>LOGIN HERE</a>");
    return;
}

SimpleDateFormat sf=new SimpleDateFormat("MM/dd/yyyy");
String currentdate=sf.format(new Date());

String requestlogfile=request.getParameter("requestlogfile");
if(requestlogfile==null)requestlogfile="timing.log";
String summary=request.getParameter("summary");
String publishservers=request.getParameter("publishservers");
String datestring=request.getParameter("fordate");
if(datestring==null)datestring=currentdate;
String timeinterval=request.getParameter("timeinterval");
if(timeinterval==null)timeinterval="15";
String servletPath="/app/mcd/cms/fs04/wcm1_auth_prod/crx-quickstart/l";
String quickstartPath=servletPath.substring(0,servletPath.indexOf("crx-quickstart"));
//out.write("var servletPath="+servletPath+";");
if(summary==null)out.write("[");
String filter=request.getParameter("filter");
if(filter==null)filter="";
/*
String startlineParam=request.getParameter("startline");
int startline=0;
if(startlineParam!=null && !startlineParam.equals(""))startline=Integer.valueOf(startlineParam).intValue();
String endlineParam=request.getParameter("endline");
int endline=9999999;
if(endlineParam!=null && !endlineParam.equals(""))endline=Integer.valueOf(endlineParam).intValue();
*/
if(summary!=null){
   if(publishservers!=null){
           out.write("["+getPublishSummaries(datestring,timeinterval)+"]");
   }else{
           out.write(parseSummaryRequests(quickstartPath+"crx-quickstart/logs/"+requestlogfile,datestring,timeinterval));
   }
}else{
     out.write(parseRequests(quickstartPath+"crx-quickstart/logs/"+requestlogfile,datestring,filter));
}
if(summary==null)out.write("]");   
%>