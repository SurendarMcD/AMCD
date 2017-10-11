<%/*
Viewer Search Reports 
Erik Wannebo 04/07/2014    
*/
%>
<%@ page import="java.util.Calendar,
        java.text.*,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        java.sql.*,
        java.net.*,
        javax.sql.DataSource,
        com.day.commons.datasource.poolservice.DataSourcePool
        
        "%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<HTML>
<TITLE>AccessMCD Viewer Search Report</TITLE>
<head>
<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
<STYLE>

ul#nav{ /* all lists */
        position:relative;zoom:1;
        list-style:none;
        float: left;
        padding: 0;
        margin:0;
        background-color:#ffffff;  
        background-image:url('/images/bg_topnav.gif');
        width:100%;
        border-width:1px 0px;
        border-style:solid;
        border-color:#000000;
        font-family: Arial, Helvetica, sans-serif;
        z-index: 1;
}

ul#nav li { /* all lists items */  
    float:left;
    padding: 0;
    margin: 0;  
}

ul#nav li a{
    cursor:pointer;
    padding:4px 10px;
    font-size:11px;
    display:block;
    text-decoration:none;
    background-color:#CC0000;
    color:#FFFFFF;
    border-right:1px solid #990000;
    font-weight:bold;
}
ul#nav li a:hover, ul#nav li.tabHover a{
    background-color:#990000;
    text-decoration:underline;
}

ul#nav li ul{   
    display:none;
    position:absolute;
    border:1px solid #990000;
    background-color:#FFF;
    margin:0;
    padding:0;
    width:300px;
    z-index: 100;
}

ul#nav li.tabHover ul{
    display:block;
    
}

ul#nav li.tabHover ul li{
    clear:both;
    display:block;
    position:relative;
    background-color:#FFF;
    white-space:normal;
    width:300px;
}

ul#nav li.tabHover ul li a{
    display:block;
    width:300px;
    background:none;
    color:#000000;
    border:none;
    background-color:#FFFFFF;
    white-space:nowrap;
    overflow:hidden; 
    text-decoration:none;
}

ul#nav li.tabHover ul li a:hover{
    background-color:#fcebb5;
    text-decoration:none;
}

* html ul#nav iframe, * html ul#nav iframe {
    position: absolute;
    /* account for the border */
    left: -1px;
    right: -1px;
    top:-1px;
    z-index:1000;
    /*filter: progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0);*/
}

.headerrole {
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    color: #666666;
}
/* tables */
table.tablesorter {
    font-family:arial;
    background-color: #CDCDCD;
    margin:10px 0pt 15px;
    font-size: 8pt;
    width: 100%;
    text-align: left;
}
table.tablesorter thead tr th, table.tablesorter tfoot tr th {
    background-color: #e6EEEE;
    border: 1px solid #FFF;
    font-size: 8pt;
    padding: 4px;
}
table.tablesorter thead tr .header {
    background-image: url(/images/bg.gif);
    background-repeat: no-repeat;
    background-position: center right;
    cursor: pointer;
}
table.tablesorter tbody td {
    color: #3D3D3D;
    padding: 4px;
    background-color: #FFF;
    vertical-align: top;
}
table.tablesorter tbody tr.odd td {
    background-color:#F0F0F6;
}
table.tablesorter thead tr .headerSortUp {
    background-image: url(asc.gif);
}
table.tablesorter thead tr .headerSortDown {
    background-image: url(desc.gif);
}
table.tablesorter thead tr .headerSortDown, table.tablesorter thead tr .headerSortUp {
background-color: #8dbdd8;
}

</STYLE>
<link rel="stylesheet" href="/css/jquery-ui-1.7.2.datepicker.css" type="text/css" />
<script language="javascript" src="/scripts/jquery-1.3.2.min.js"></script>
<script type="text/javascript" language="Javascript" src="/scripts/jquery.tablesorter.min.js"></script>
<script language="javascript" src="/scripts/jquery-ui-1.7.2.datepicker.min.js" ></SCRIPT> 
<script language="javascript">
$(document).ready(function(){

    }
);



</script>
</head>
<body style="font-family:arial">
<%!

private class SearchEvent  {
          public java.util.Date timestamp=null;
          public String eid="";
          public String mkt="";
          public String role="";
          public String query="";
          public int resultno=0;
          public String url="";
          public boolean isClick=false;
          public boolean isQuickLink=false;
          public boolean isSearchSuggestion=false;
          public boolean isSlowSession=false;
          public boolean isQLSession=false;
          public boolean isSuggestSession=false;
          public boolean isExitDoc=false;
          public int sessionid=0;
          public long elapsed=0;
        }

public class eventComparator implements Comparator {
    
  public int compare(Object evt1, Object evt2) {
    if(((SearchEvent)evt2).eid.equals(((SearchEvent)evt1).eid)){
        return ((SearchEvent)evt1).timestamp.compareTo(((SearchEvent)evt2).timestamp);
    }else{
        return ((SearchEvent)evt1).eid.compareTo(((SearchEvent)evt2).eid);
    }
    }
}



private Connection getConnection(org.apache.sling.api.scripting.SlingScriptHelper sling, String dataSourceName){
    Connection connection = null;
    try{
        DataSourcePool dbService = sling.getService(DataSourcePool.class);
        DataSource dataSource = (DataSource)dbService.getDataSource(dataSourceName);
        connection = dataSource.getConnection();
    }catch(Exception e){
    }
    return connection;   

}

private static <K,V extends Comparable<? super V>> SortedSet<Map.Entry<K,V>> entriesSortedByValues(Map<K,V> map) {
        SortedSet<Map.Entry<K,V>> sortedEntries = new TreeSet<Map.Entry<K,V>>(
            new Comparator<Map.Entry<K,V>>() {
                public int compare(Map.Entry<K,V> e1, Map.Entry<K,V> e2) {
                    int res = e2.getValue().compareTo(e1.getValue());
                    return res != 0 ? res : 1; // Special fix to preserve items with equal values
                }
            }
        );
        sortedEntries.addAll(map.entrySet());
        return sortedEntries;
    }


private String td(String val){
    return "<TD>"+val+"</TD>";
}

private String td(String val,String bgcolor){
    return "<TD style='background-color:"+bgcolor+"'>"+val+"</TD>";
}



public void displayReport(javax.servlet.jsp.JspWriter out,HttpServletRequest cqReq,org.apache.sling.api.scripting.SlingScriptHelper sling,boolean isAdmin)throws IOException{
    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
 
    String searchMkt=cqReq.getParameter("searchMkt");
    String reportType=cqReq.getParameter("reportType");
    String startDate=cqReq.getParameter("startDate");
    String endDate=cqReq.getParameter("endDate");
    String nbrTerms=cqReq.getParameter("nbrTerms");
    String docURL=cqReq.getParameter("docURL");
    String eid=cqReq.getParameter("eid");
    String role=cqReq.getParameter("role");
    
    String basePeriod=cqReq.getParameter("basePeriod");
    //String trendPeriod=cqReq.getParameter("trendPeriod");
    
    if(basePeriod==null)basePeriod="30";
    //if(trendPeriod==null)trendPeriod="2";
    String trendPeriod=""+(Integer.parseInt(basePeriod)/2);
    if(eid==null)eid="";
    eid=eid.toUpperCase();
    if(role==null)role="";
    if(docURL==null)docURL="";
    String clickQuery=cqReq.getParameter("clickQuery");
    if(clickQuery==null)clickQuery="";    
    boolean bIncludeRole=false;
    if(cqReq.getParameter("bIncludeRole")!=null)bIncludeRole=true;
    boolean bExactQuery=false;
    if(cqReq.getParameter("bExactQuery")!=null)bExactQuery=true;
    boolean bChildPages=false;
    if(cqReq.getParameter("bChildPages")!=null)bChildPages=true;
    
    boolean bArchive=false;
    if(cqReq.getParameter("bArchive")!=null)bArchive=true; 
    //test
    
    if(searchMkt==null)searchMkt="ALL";
    if(reportType==null)reportType=""; 
    if(nbrTerms==null)nbrTerms="50";
    
    if(!reportType.equals("sessions") && !reportType.equals("sessionstats") && (endDate==null || endDate.equals(""))){
        java.util.Date endingDate = new java.util.Date();
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(endingDate);

        endDate = dateFormat.format(endingDate);  
    }
    
    if(startDate==null || startDate.equals("") ){
        java.util.Date endingDate = new java.util.Date();
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(endingDate);
        gc.add(Calendar.DAY_OF_YEAR, -7);
        java.util.Date startingDate = gc.getTime(); 
        startDate = dateFormat.format(startingDate);

    }
    
    
    
    out.println("<h2 style=\"font-family: Arial;\">Viewer Search Reports");
   // if(!startDate.equals(""))out.println(startDate+" - ");
   // if(!endDate.equals(""))out.println(endDate);
    out.println("</h2><br>");

    out.println("<FORM name=\"searchreports\" action=\"\" method=\"GET\">");
        
    out.println("<div id='divSearchMarket'>");
    
    out.println("<B>Search Market:</B><SELECT name=\"searchMkt\" >");
    out.println("<OPTION value=\"viewerrsg\" "+ (searchMkt.equals("viewerrsg")?"SELECTED":"")+">Viewer - RSG</OPTION>");
    out.println("<OPTION value=\"vieweruk\" "+ (searchMkt.equals("vieweruk")?"SELECTED":"")+">Viewer - UK</OPTION>");
    out.println("<OPTION value=\"viewerus\" "+ (searchMkt.equals("viewerus")?"SELECTED":"")+">Viewer - US English</OPTION>");
    out.println("<OPTION value=\"viewerussp\" "+ (searchMkt.equals("viewerussp")?"SELECTED":"")+">Viewer - US Spahish</OPTION>");
    out.println("</SELECT>");
    out.println("</div>");
    out.println("<B>Start Date:</B><INPUT type=\"text\" id=\"startDate\" name=\"startDate\" value=\""+startDate+"\">");

    out.println("<B>End Date:</B><INPUT type=\"text\"  id=\"endDate\" name=\"endDate\"  value=\""+endDate+"\">");

    out.println("<div id='divArchive'>");
    out.println("<b>Use Archive</b><INPUT type=checkbox name=\"bArchive\" "+ (bArchive?"CHECKED":"")+"> (For data more than 90 days old)");
    out.println("</div>");
 
    out.println("<div id='divButton'>");
     
    out.println("<INPUT TYPE=SUBMIT value=\"Run Report\">");
    out.println("</div>");
       
    out.println("</FORM><BR>");
    
    Connection conn = null;
    String dbSourceName = "search";
    conn = getConnection(sling, dbSourceName);
    
    displayMarketReport(out, conn, searchMkt, startDate, endDate, bArchive,  false);
    displayMarketReport(out, conn, searchMkt, startDate, endDate, bArchive,  true);
    
    displayViewerReport(out, conn, searchMkt, startDate, endDate, bArchive);

   
    try{
        closeConnection(conn);
    }catch(Exception e){
        out.println("Exception closing connection:"+e.getMessage());
    }
    
    String tbsortcolumn="0";
    if(reportType.equals("trending"))tbsortcolumn="2";
    if(reportType.equals("topclicks")&& bIncludeRole)tbsortcolumn="1";
    /*
    if(reportType.equals("markets")){
        if(bIncludeRole){
            tbsortcolumn="2";
        }else{
            tbsortcolumn="1";
        }
    }
    */
    out.println("<script language='javascript'>");
    out.println("$(document).ready(function(){");
    
    out.println("$(\"#startDate\").datepicker()");
    out.println("$(\"#endDate\").datepicker()");
    if((!reportType.equals("sessions")) && (!reportType.equals("qleffectiveness")))out.println("$(\"#rawdata\").tablesorter({sortList: [["+tbsortcolumn+",1]]});"); 
    out.println("$(\"#rawdata2\").tablesorter({sortList: [["+tbsortcolumn+",1]]});");
    out.println("});");

    out.println("</script>");
}

public void displayViewerReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String startDate, String endDate, boolean bArchive) throws IOException{

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    //out.println("Search queries appearing 5 or more times during report period. Queries are lower-cased before being logged. <br><br>"); 
    try{        
        out.println("<TABLE id='rawdata' class='tablesorter'>");
        out.println("<thead><tr style='font-weight:bold'>");
        
        out.println("<th>Searches</th>");
        out.println("<th>Search Query</th>");        
        out.println("</tr></thead><tbody>");
        
        String searchTermSql = "select srch_log_qt_tx,count(*),srch_log_mkt_cd " +
        "from SRCH.tbsrch_log"+(bArchive?"_arch ":" ")+
        "where srch_log_ts > TO_DATE('"+startDate+"','MM/dd/yyyy') "+
        "and TRUNC(srch_log_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
        "and srch_log_mkt_cd='"+searchMkt+"' "+ 
        "group by srch_log_qt_tx, srch_log_mkt_cd ";
        
        
        //out.println(searchTermSql+"<br>");            
        pstmt = conn.prepareStatement(searchTermSql);
        rs = pstmt.executeQuery();
        long limit=1000000;
        //if(!nbrTerms.equals(""))limit=Integer.parseInt(nbrTerms);
        String searchterm="";
        String role="";
        String searchcount="";
        long count=0; 
        String baseReportURL="?reportType=queries&bExactQuery=on&searchMkt="+searchMkt+"&startDate="+URLEncoder.encode(startDate)+"&endDate="+URLEncoder.encode(endDate); 
        while (rs.next()) {
            if(count>limit)break;
            

            searchterm=rs.getString(1);
            searchcount=rs.getString(2);

            if(searchterm==null || searchterm.equals("null")){
                continue;
            }else{
                String queriesURL=baseReportURL+"&clickQuery="+URLEncoder.encode(searchterm); 
                String querieslink="<a target=_blank href='"+queriesURL+"'>"+searchterm+"</a>";
                out.println("<tr>");
                out.println("<td>"+searchcount+"</td>");
                
                out.println("<td>"+searchterm+"</td>");
               
                out.println("</tr>");
            }
            count++;
            
        }
        out.println("</tbody></table>");
 
        
    } catch (SQLException sqle) {
            System.out.println("searchReport:SQLException " + sqle);
            
    } catch (Exception e) {
            System.out.println("searchReport:Exception " + e);
            
    }finally {
        try {

            closeStatement(pstmt);
            closeResultSet(rs);
            
        } catch (Exception e) {System.out.println("searchReport:Exception closing");}
    }
    return;
}

public Map synonyms=new HashMap();



public String getSynonym(String term){

if(synonyms.containsKey(term)){
    return (String)synonyms.get(term);
}

return term;

}


public void displayMarketReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String startDate, String endDate, boolean bArchive,  boolean bUniqueUsers) throws IOException{

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
 
      
    String logtable="tbsrch_log";
    String title="Current Log Table";
    if(bArchive){
        logtable="tbsrch_log_arch";
        title="Archive Log Table";
    }   
    if(bUniqueUsers){
        title+= " - Unique Users";
    }else{
        title+= " - Queries";
    }

    PreparedStatement pstmt = null;
    ResultSet rs = null;
            
    try{        
        
        String  searchMktSql = "";
        if(!bUniqueUsers){
            searchMktSql="select TO_CHAR(srch_log_ts,'yyyy-MM') as mnth,srch_log_mkt_cd,count(*) as cnt "+
            "from srch."+logtable+" " +
            "where srch_log_ts > (sysdate-365) " +
            "and srch_log_mkt_cd='"+searchMkt + "' " +
            "group by srch_log_mkt_cd,TO_CHAR(srch_log_ts,'yyyy-MM') "+
            "order by TO_DATE(TO_CHAR(srch_log_ts,'yyyy-MM'),'yyyy-MM'),srch_log_mkt_cd";
        
        
          
        }else{
            //Unique users
            searchMktSql="select mnth,srch_log_mkt_cd,count(*) as cnt "+
            "from ( "+
            "select TO_CHAR(srch_log_ts,'yyyy-MM') as mnth,srch_log_mkt_cd,srch_log_usr_id,count(*) " +
            "from srch."+logtable+" " +
            "where srch_log_ts > (sysdate-365) " +
            "and srch_log_mkt_cd='"+searchMkt + "' " +
            "group by srch_log_usr_id,srch_log_mkt_cd,TO_CHAR(srch_log_ts,'yyyy-MM') "+
            ") "+
            "group by mnth,srch_log_mkt_cd "+
            "order by TO_DATE(mnth,'yyyy-MM'),srch_log_mkt_cd";
        
        
          
        }

        pstmt = conn.prepareStatement(searchMktSql);
        rs = pstmt.executeQuery();
        out.println("<h3>"+title+"</h3>");
        String searchmkt="";
        String role="";
        String searchcount="";
        
        TreeMap tmMonths=new TreeMap();
        TreeMap tmMarkets=new TreeMap();
        while (rs.next()) {
            
            String month=rs.getString(1);
            
            searchmkt=rs.getString(2);
            searchcount=rs.getString(3);
           
            Hashtable htMonth=null;
            if(tmMonths.keySet().contains(month)){
                htMonth=(Hashtable)tmMonths.get(month);
            }else{
                htMonth=new Hashtable();
            }
            htMonth.put(searchmkt,searchcount);
            tmMonths.put(month,htMonth);
            tmMarkets.put(searchmkt,"");
        }
        
        
        out.println("<TABLE id='"+(bUniqueUsers?"users":"queries")+"' class='tablesorter'>");
        out.println("<thead><tr style='font-weight:bold'>");
        out.println("<th>Market</th>");

        Iterator iterMonths=tmMonths.keySet().iterator();
        while(iterMonths.hasNext()){
            String month=(String)iterMonths.next();
            out.println("<th>"+month+"</th>");
        }
        
        out.println("</tr></thead><tbody>");
        Iterator iterMarkets=tmMarkets.keySet().iterator();
        int marketcount=0;
        int monthcount=0;
        long[] monthtotals=new long[20];
        while(iterMarkets.hasNext()){
            String mkt=(String)iterMarkets.next();
            out.println("<td>"+mkt+"</td>");
            monthcount=0;
            iterMonths=tmMonths.keySet().iterator();
            
            while(iterMonths.hasNext()){
                String month=(String)iterMonths.next();
                Hashtable htMonth=(Hashtable)tmMonths.get(month);
                String cnt="";
                if(htMonth.keySet().contains(mkt)){
                    cnt=(String)htMonth.get(mkt);
                }
                out.println("<td align='right'>"+cnt+"</td>");
                if(marketcount==0)monthtotals[monthcount]=0;
                try{
                    monthtotals[monthcount]+=(long)Integer.parseInt(cnt);
                }catch(Exception e){
                }
                monthcount++;
                
            }
            out.println("</tr>");
            marketcount++;      
        }
        out.println("<tr><td><b>_Total</b></td>");
        for(int x=0;x<monthcount;x++){
            out.println("<td align='right'><b>"+monthtotals[x]+"</b></td>");
        }
        out.println("</tr>");   

        out.println("</tbody></table>");
 
        
    } catch (SQLException sqle) {
            System.out.println("searchReport:SQLException " + sqle);
            
    } catch (Exception e) {
            System.out.println("searchReport:Exception " + e);
            
    }finally {
        try {

            closeStatement(pstmt);
            closeResultSet(rs);
            
        } catch (Exception e) {System.out.println("searchReport:Exception closing");}
    }
    return;
}


public void displayTopClickReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String startDate, String endDate, boolean bArchive, boolean bIncludeRole, String nbrTerms) throws IOException{

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");

    PreparedStatement pstmt = null;
    ResultSet rs = null; 
    

    try{        
        out.println("<TABLE id='rawdata' class='tablesorter'>");
        out.println("<thead><tr style='font-weight:bold'>");
        if(bIncludeRole)out.println("<th>Role</th>");
        out.println("<th>Clicks</th>");
        out.println("<th>Document</th>");
        out.println("</tr></thead><tbody>");
        
        String searchSql = "select "+(bIncludeRole?"substr(srch_click_qt_tx,0,INSTR(srch_click_qt_tx, '|', -1)) as qtrole,":"")+" srch_click_url_tx,count(*) " +
        "from SRCH.tbsrch_click " +
        "where srch_click_ts > TO_DATE('"+startDate+"','MM/dd/yyyy') "+
        "and TRUNC(srch_click_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
         (searchMkt.equals("ALL")?"":"and (srch_click_qt_tx like '"+searchMkt+" %' or srch_click_qt_tx like 'ss | "+searchMkt+" %') ")+ 
        "group by "+(bIncludeRole?"substr(srch_click_qt_tx,0,INSTR(srch_click_qt_tx, '|', -1)),":"")+"srch_click_url_tx "+
        "having count(*)>4 order by count(*) desc";
        out.println("SQL:"+searchSql);        
        pstmt = conn.prepareStatement(searchSql);
        rs = pstmt.executeQuery();
        long limit=1000000;
        if(!nbrTerms.equals(""))limit=Integer.parseInt(nbrTerms);
        //out.println("limit:"+limit);
        String searchdoc="";
        String role="";
        String searchcount="";
        long count=0;
        String baseReportURL="?reportType=queries&searchMkt="+searchMkt+"&startDate="+URLEncoder.encode(startDate)+"&endDate="+URLEncoder.encode(endDate); 
        String bgcolor="white";
        while (rs.next()) {
            //out.println("next");  
            
            if(count>limit)break;
            
            if(bIncludeRole){
                role=rs.getString(1);
                int firstpipe=role.indexOf("|");
                int lastpipe=role.lastIndexOf("|");
                if(firstpipe>-1){
                    if(role.startsWith("ss |")){
                        role=role.substring(4);
                        firstpipe=role.indexOf("|");
                        bgcolor="#0f6";
                    }else{
                        bgcolor="white";
                        
                    }
                    
                    role=role.substring(firstpipe+1);
                }  
                        
                searchdoc=rs.getString(2);
                searchcount=rs.getString(3);
            }else{
                searchdoc=rs.getString(1);
                searchcount=rs.getString(2);
            }
            if(searchdoc==null || searchdoc.equals("null")){
                continue;
            }else{
                out.println("<tr>");
                if(bIncludeRole)out.println(td(role,bgcolor));
                String doclink="<a target=_blank href='"+searchdoc+"'>"+searchdoc+"</a>";
                String queriesURL=baseReportURL+"&docURL="+URLEncoder.encode(searchdoc); 
                String querieslink="<a target=_blank href='"+queriesURL+"'>queries</a>";
                out.println(td(searchcount,bgcolor));
                out.println(td(doclink,"white"));

                out.println("</tr>");
            }
            count++;
            
        }
        out.println("</tbody></table>");
 
        
    } catch (SQLException sqle) {
            System.out.println("searchReport:SQLException " + sqle);
            
    } catch (Exception e) {
            System.out.println("searchReport:Exception " + e);
            
    }finally {
        try {

            closeStatement(pstmt);
            closeResultSet(rs);
            
        } catch (Exception e) {System.out.println("searchReport:Exception closing");}
    }
    return;
}



private String decodeRole(String val){
            if(val==null)return "";
            if(val.equals("100"))return "CorpEmployees";
            if(val.equals("101"))return "McOpCoRestMgrs";
            if(val.equals("102"))return "Franchisees";
            if(val.equals("103"))return "FranchiseeRestMgrs";
            if(val.equals("104"))return "Crew";
            if(val.equals("105"))return "SupplierVendor";
            if(val.equals("106"))return "Agency";
            if(val.equals("107"))return "FranchiseeOfficeStaff";
            return "";
        }
         

    private boolean areSimilar(String query1,String query2){
        if(query1==null || query2==null)return true;
        query1=query1.toLowerCase().trim();
        query2=query2.toLowerCase().trim();
        if(query1.equals("") || query2.equals(""))return true;
        if(query1.equals(query2)){
            return true;
        }
        if(query2.contains(query1) || query1.contains(query2)){
            return true;
        }
        if(query1.contains(" ") && query2.contains(" ")){
            for(String word : query1.split(" ")){
                if(query2.contains(word))return true;
            }
        }
        return false;
    }
    
    private void incrementMap(TreeMap map,String key){
        if(map.containsKey(key)){
            map.put(key,new Integer((Integer)map.get(key) + 1));
        }else{
            map.put(key,1);
        }
    }
    
    private void incrementMap(Map map,String key,int incrementvalue){
        if(map.containsKey(key)){
            map.put(key,new Integer((Integer)map.get(key) + incrementvalue));
        }else{
            map.put(key,incrementvalue);
        }
    }
      
    private void incrementMap(TreeMap map,Integer key){
        if(map.containsKey(key)){
            map.put(key,new Integer((Integer)map.get(key) + 1));
        }else{
            map.put(key,1);
        }
    } 
   

private void outdebug(javax.servlet.jsp.JspWriter out,String msg){
try{
    out.println(msg);
}catch(Exception e){
} 
}
            
    public static void closeStatement(PreparedStatement... pstmts) throws Exception
    {
        for (PreparedStatement stmt : pstmts) 
        {
            if(stmt != null)
            {
                stmt.close();
            }
        }       
    }
    

    public static void closeResultSet(ResultSet... resultsets) throws Exception
    {
        for (ResultSet rs : resultsets) 
        {
            if(rs != null)
            {
                rs.close();
            }
        }       
    }

    public static void closeConnection(Connection... connections) throws Exception
    {
        for (Connection con : connections) 
        {
            if(con != null)
            {
                con.close();
            }
        }       
    }

%>
<%

synonyms.put("egg white delight execution manual","egg white delight");
synonyms.put("egg white delight soc","egg white delight");
synonyms.put("egg white","egg white delight");
synonyms.put("htw hiring to win","hiring to win");
synonyms.put("hire to win","hiring to win");
synonyms.put("hiring day","national hiring day");
synonyms.put("gdct global data collection tool","global data collection tool");
synonyms.put("gdct","global data collection tool");
synonyms.put("roip","roip restaurant operations improvement process");
synonyms.put("manager guides","manager's guides");
synonyms.put("soc station observation checklist","station observation checklist");
synonyms.put("soc","station observation checklist");
synonyms.put("socs","station observation checklist");
synonyms.put("bphp","building peak hour performance");
synonyms.put("bphp building peak hour performance","building peak hour performance");
synonyms.put("r2d2","r2d2 regional restaurant data diagnostic");
synonyms.put("service platform","service experience platform");
synonyms.put("rfm","restaurant file maintenance");
synonyms.put("rfm restaurant file maintenance","restaurant file maintenance");
synonyms.put("restaurant file maintenance ( rfm )","restaurant file maintenance"); 
synonyms.put("dmc document management center","dmc"); 
synonyms.put("axiom american express travel services","axiom"); 


HttpServletRequest cqReq = request;
boolean isAdmin=false;
if(slingRequest.getUserPrincipal().getName().equals("admin")){
    isAdmin=true;
    //out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    //out.write("<a href='/libs/cq/core/content/login.html?resource=/content/utility/utility.usermaintenance.html'>LOGIN HERE</a>");
    //return;
}

response.setContentType("text/html;charset=UTF-8");

displayReport(out,cqReq,sling,isAdmin);

%>  