<%--
*
* Parses CQ Error Logs
* and returns the data on the "CQTime" entries for the Chart Utility
* 8/17/2010 Erik Wannebo
*
--%><%@ page import="java.io.*,java.util.*,java.util.regex.*,java.text.SimpleDateFormat"  %><%!
private String parseRequests(String requestlogfile,String filter,int startline,int endline){
        StringBuffer sb=new StringBuffer();
        String strComma="";
        HashMap<String,String> requestTimes=new HashMap<String,String>();
        HashMap<String,String> urls=new HashMap<String,String>();
        SimpleDateFormat sf=new SimpleDateFormat("MM/dd/yyyy H:mm:ss");
        String logEntryPattern = "^(\\d+\\/\\d+\\/\\d+ \\d+:\\d+:\\d+) CQTime: ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)";
        Pattern p = Pattern.compile(logEntryPattern);
        DataInputStream in=null;
           try{
            FileInputStream fstream = new FileInputStream(requestlogfile);
            in = new DataInputStream(fstream);
            BufferedReader br = new BufferedReader(new InputStreamReader(in));
            String strLine;
            int linecount=0;
            int totallinecount=0;
            while (((strLine=br.readLine())!=null))   {
                Matcher matcher = p.matcher(strLine);
                if(totallinecount>=startline && totallinecount<=endline){
                    if(matcher.find() && matcher.group(6).equals("ms")){
                        if(filter.equals("") || strLine.indexOf(filter)>-1){
                            String requestTime=matcher.group(1);
                            String url=matcher.group(2);
                            String location=matcher.group(3);
                            String eid=matcher.group(4);
                            String responseTime=matcher.group(5);
                            Date requestDate=sf.parse(requestTime);
                            int timezoneoffset=(-5*3600*1000);
                            String outline=(requestDate.getTime()+timezoneoffset)+"|"+responseTime+"|"+eid+" "+url;
                            sb.append(strComma+"\""+outline+"\"\n");
                            linecount++;
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
%><%
String requestlogfile=request.getParameter("requestlogfile");
if(requestlogfile==null)requestlogfile="request.log";
String servletPath=request.getRealPath("/");
String quickstartPath=servletPath.substring(0,servletPath.indexOf("crx-quickstart"));
//out.write("var servletPath="+servletPath+";");
out.write("[");
String filter=request.getParameter("filter");
if(filter==null)filter=".html";
String startlineParam=request.getParameter("startline");
int startline=0;
if(startlineParam!=null && !startlineParam.equals(""))startline=Integer.valueOf(startlineParam).intValue();
String endlineParam=request.getParameter("endline");
int endline=9999999;
if(endlineParam!=null && !endlineParam.equals(""))endline=Integer.valueOf(endlineParam).intValue();

out.write(parseRequests(quickstartPath+"crx-quickstart/logs/"+requestlogfile,filter,startline,endline));
out.write("]");
%>
