<%--
* 
* Parses CQ Access Logs
* and returns the data for the Request Log Chart Utility
* 4/16/2010 Erik Wannebo
*
--%><%@ page import="java.io.*,java.util.*,java.util.regex.*,java.text.SimpleDateFormat"  %><%!
private String parseRequests(String baseFileName,String fordate,String filter){
        StringBuffer sb=new StringBuffer();
        String strComma="";
        boolean bFoundDate=false;
        boolean bPassedDate=false;
        int filecount=-1;
        HashMap<String,String> requestTimes=new HashMap<String,String>();
        HashMap<String,Integer> timecounts=new HashMap<String,Integer>();
        SimpleDateFormat sf=new SimpleDateFormat("MMM dd,yyyy H:mm:ss");
    //String logEntryPattern = "^((\\d+).(\\w+).(\\d+):(\\d+):(\\d+):(\\d+) ([^ ]+) \\[(\\d+)\\] ([^ ]+) ([^ ]+) ([^ ]+)( [^ ]+)+";
    //String logEntryPattern = "^([\\d.]+) (\\S+) (\\S+) (\\d+).(\\w+).(\\d+):(\\d+):(\\d+):(\\d+) ([^ ]+) \"(.+?)\" (\\d{3}) (\\d+) \"([^\"]+)\" \"([^\"]+)\"";
        String logEntryPattern = "^([^ ]+) (\\S+) (\\S+) (\\d+).(\\w+).(\\d+):(\\d+):(\\d+):(\\d+) ([^ ]+) \"(.+?)\" (.*)";
        Pattern p = Pattern.compile(logEntryPattern);
        DataInputStream in=null;
           try{
            while(!bPassedDate&&filecount<10){
                if(bFoundDate){
                    bPassedDate=true;
                    bFoundDate=false;
                }  
                String logfile=baseFileName+((filecount==-1)?"":"."+filecount);
                System.out.println("requestlogfile:"+logfile);
                FileInputStream fstream = new FileInputStream(logfile);
                in = new DataInputStream(fstream);
                BufferedReader br = new BufferedReader(new InputStreamReader(in));
                String strLine;
                int linecount=0;
                int totallinecount=0; 
                long localtime=System.currentTimeMillis();
                long timezoneoffset=(TimeZone.getTimeZone("America/Chicago").getOffset(localtime));
                //sb.append("timezoneoffset:"+timezoneoffset);
                //timezoneoffset=0; 
                //sb.append("requestlogfile:"+requestlogfile); 
                while (((strLine=br.readLine())!=null))   {
                    if(strLine.indexOf(" "+fordate)>-1){
                        //System.out.println("datematch");
                        Matcher matcher = p.matcher(strLine);                   
                      if(matcher.find()){
                          //System.out.println("found");
                          if(!bFoundDate)bFoundDate=true;
                        bPassedDate=false;
                        String requestTime=matcher.group(5)+" "+matcher.group(4)+", "+matcher.group(6);
                        requestTime+=" "+matcher.group(7)+":"+matcher.group(8)+":"+matcher.group(9);
                        String eid=matcher.group(3);
                        String url=matcher.group(11);
                        Date requestDate=sf.parse(requestTime);
                        if(timecounts.containsKey(requestTime)){
                            timecounts.put(requestTime,((Integer)timecounts.get(requestTime))+1);
                        }else{
                            timecounts.put(requestTime,1);
                        }
                        String outline=(requestDate.getTime()+timezoneoffset)+"|"+timecounts.get(requestTime)*100+"|"+eid+":"+url;
                        sb.append(strComma+"\""+outline+"\"\n");
                        linecount++;
                        }   
                     if(linecount==1)strComma=",";
                     }

                    totallinecount++;
                }
                //sb.append("totallinecount:"+totallinecount); 
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
/*
private String parseRequests(String requestlogfile,String filter,int startline,int endline){
        StringBuffer sb=new StringBuffer();
        String strComma="";
        HashMap<String,String> requestTimes=new HashMap<String,String>();
        HashMap<String,String> urls=new HashMap<String,String>();
        SimpleDateFormat sf=new SimpleDateFormat("MMM dd,yyyy H:mm:ss");
        String logEntryPattern = "^(\\d+).(\\w+).(\\d+):(\\d+):(\\d+):(\\d+) ([^ ]+) \\[(\\d+)\\] ([^ ]+) ([^ ]+) ([^ ]+)( [^ ]+)+";
        Pattern p = Pattern.compile(logEntryPattern);
        DataInputStream in=null;
           try{
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
                if(totallinecount>=startline && totallinecount<=endline){
                    if(matcher.find()){
                        String day = matcher.group(1);
                        String month=matcher.group(1);
                        String requestTime=matcher.group(2)+" "+matcher.group(1)+", "+matcher.group(3);
                        requestTime+=" "+matcher.group(4)+":"+matcher.group(5)+":"+matcher.group(6);
                        String id=matcher.group(8);
                        if(matcher.group(9).equals("->")){
                            String url=matcher.group(11);
                            if(url.contains("?"))url=url.substring(0,url.indexOf("?"));
                            if(filter=="" || url.contains(filter)){
                                urls.put(id,url);
                                requestTimes.put(id,requestTime);
                            }
                        }else{
                            if(requestTimes.containsKey(id)){
                                String responseTime=matcher.group(matcher.groupCount()).trim();
                                if(!responseTime.contains("ms"))responseTime=matcher.group(13);
                                responseTime=responseTime.substring(0,responseTime.length()-2);
                                Date requestDate=sf.parse(requestTimes.get(id));
                                String outline=(requestDate.getTime()+timezoneoffset)+"|"+responseTime+"|"+urls.get(id);
                                sb.append(strComma+"\""+outline+"\"\n");
                                linecount++;
                            }
                        }   
                    }
                    if(linecount==1)strComma=",";
                }
                totallinecount++;
                
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
    */
%><%
String logfile=request.getParameter("requestlogfile");
//String quickstartPath="/day/cq56/crx-quickstart/logs/access.log";
//if(logfile!=null && !logfile.equals(""))quickstartPath=logfile+"access.log";
String servletPath=request.getRealPath("/");
String quickstartPath=servletPath.substring(0,servletPath.indexOf("crx-quickstart"))+"crx-quickstart/logs/access.log";


//out.write("var servletPath="+servletPath+";");
out.write("[");
String filter=request.getParameter("filter");
if(filter==null)filter=".html";
String startlineParam=request.getParameter("startline");
int startline=0;
if(startlineParam!=null && !startlineParam.equals(""))startline=Integer.valueOf(startlineParam).intValue();
String endlineParam=request.getParameter("endline");
int endline=9999999;
String fordate=request.getParameter("fordate");
SimpleDateFormat sf=new SimpleDateFormat("MM/dd/yyyy");
SimpleDateFormat sfRequest=new SimpleDateFormat("dd/MMM/yyyy");
if(fordate==null){
    fordate=sfRequest.format(new Date());
}else{
    fordate=sfRequest.format(sf.parse(fordate));
}
//out.write("fordate:"+fordate);
if(endlineParam!=null && !endlineParam.equals(""))endline=Integer.valueOf(endlineParam).intValue();
out.write(parseRequests(quickstartPath,fordate,filter));
//out.write(parseRequests(quickstartPath+"crx-quickstart/logs/"+requestlogfile,filter,startline,endline));
out.write("]");
%>