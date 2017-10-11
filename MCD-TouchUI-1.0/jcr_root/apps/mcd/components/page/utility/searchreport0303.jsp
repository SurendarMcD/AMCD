<%/*
Search Reports 
Erik Wannebo 04/24/2012    
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
<TITLE>AccessMCD Search Report</TITLE>
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
    updateInterface(true); 
    }
);

function updateInterface(bAfterResults){
    
    var reporttype=$("select[name='reportType']").val();
    //alert("rt:|"+reporttype+"|");
    if("markets|docqueries| ".indexOf(reporttype)>-1){
        $("#divSearchMarket").hide();
        $("select[name='searchMkt']").val('ALL');
    }else{
        $("#divSearchMarket").show();
    }
    if("docqueries".indexOf(reporttype)>-1){
        $("#divDocQuery").show();
    }else{
        $("#divDocQuery").hide();
    } 
    if("sessions".indexOf(reporttype)>-1){
        $("#divEID").show();
    }else{
        $("#divEID").hide();
    }     
    if("trending|markets|sessions|sessionstats|qleffectiveness| ".indexOf(reporttype)>-1){
        $("#divStartDate").hide();
    }else{
        $("#divStartDate").show();
    }
    
    if("trending".indexOf(reporttype)>-1){
        $("#divBasePeriod").show();
        $("#divTrendPeriod").show();
    }else{
        $("#divBasePeriod").hide();
        $("#divTrendPeriod").hide();
    }
    if(!bAfterResults && "sessions".indexOf(reporttype)>-1){
        $("#endDate").val("");
    }
    if("markets|qleffectiveness| ".indexOf(reporttype)>-1){
        $("#divEndDate").hide();
    }else{
        $("#divEndDate").show();
    } 
    if("markets|terms|sessions|sessionstats".indexOf(reporttype)>-1){
        $("#divArchive").show();
    }else{
        $("#divArchive").hide();
    } 
    
    if("terms|documents|docqueries|sessions|trending".indexOf(reporttype)>-1){
        $("#divLimit").show();
    }else{
        $("#divLimit").hide();
    }
    if("|markets|terms".indexOf(reporttype)>-1){
        $("#divRole").show();
    }else{
        $("#divRole").hide();
    }
    
    if("sessions|sessionstats|trending".indexOf(reporttype)>-1){
        $("#divRoles").show();
    }else{
        $("#divRoles").hide();
    } 
    if("| ".indexOf(reporttype)>-1){
        $("#divButton").hide();
    }else{
        $("#divButton").show();
    } 
    
    //terms|documents|docqueries|markets|sessions|qleffectiveness|trending;
    
    
    
     
}

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
    String trendPeriod=cqReq.getParameter("trendPeriod");
    
    if(basePeriod==null)basePeriod="30";
    if(trendPeriod==null)trendPeriod="2";
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
    boolean bArchive=false;
    if(cqReq.getParameter("bArchive")!=null)bArchive=true; 
    
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
    
    
    
    out.println("<h2 style=\"font-family: Arial;\">AccessMcD Search Reports");
   // if(!startDate.equals(""))out.println(startDate+" - ");
   // if(!endDate.equals(""))out.println(endDate);
    out.println("</h2><br>");


    out.println("<FORM name=\"searchreports\" action=\"\" method=\"GET\">");
    
    out.println("<B>Report Type:</B><SELECT name=\"reportType\" onchange=\"updateInterface(false);\">");
    out.println("<OPTION value=\" \" "+ (reportType.equals("")?"SELECTED":"")+">Please Select</OPTION>");
    out.println("<OPTION value=\"terms\" "+ (reportType.equals("terms")?"SELECTED":"")+">Top Queries</OPTION>");
   
        out.println("<OPTION value=\"documents\" "+ (reportType.equals("documents")?"SELECTED":"")+">Top Documents</OPTION>");
        out.println("<OPTION value=\"docqueries\" "+ (reportType.equals("docqueries")?"SELECTED":"")+">Documents & Queries</OPTION>");
        out.println("<OPTION value=\"markets\" "+ (reportType.equals("markets")?"SELECTED":"")+">Search Market Usage</OPTION>");
        
    if(isAdmin){  
       
        out.println("<OPTION value=\"sessions\" "+ (reportType.equals("sessions")?"SELECTED":"")+">Search Sessions</OPTION>");
        out.println("<OPTION value=\"sessionstats\" "+ (reportType.equals("sessionstats")?"SELECTED":"")+">Search Session Stats</OPTION>");
        out.println("<OPTION value=\"qleffectiveness\" "+ (reportType.equals("qleffectiveness")?"SELECTED":"")+">Potential Quick Links</OPTION>");
        out.println("<OPTION value=\"trending\" "+ (reportType.equals("trending")?"SELECTED":"")+">Trending</OPTION>");
    }
    out.println("</SELECT>");
    out.println("<br>");
    
    out.println("<div id='divSearchMarket'>");
    
    out.println("<B>Search Market:</B><SELECT name=\"searchMkt\" >");
    out.println("<OPTION value=\"ALL\" "+ (searchMkt.equals("ALL")?"SELECTED":"")+">ALL</OPTION>");
    out.println("<OPTION value=\"corp\" "+ (searchMkt.equals("corp")?"SELECTED":"")+">Global</OPTION>");
    out.println("<OPTION value=\"us\" "+ (searchMkt.equals("us")?"SELECTED":"")+">US</OPTION>");
    out.println("<OPTION value=\"au\" "+ (searchMkt.equals("au")?"SELECTED":"")+">Australia</OPTION>");
    out.println("<OPTION value=\"canada_en\" "+ (searchMkt.equals("canada_en")?"SELECTED":"")+">Canada - English</OPTION>");    
    out.println("<OPTION value=\"canada_fr\" "+ (searchMkt.equals("canada_fr")?"SELECTED":"")+">Canada - French</OPTION>");
    out.println("<OPTION value=\"vieweruk\" "+ (searchMkt.equals("vieweruk")?"SELECTED":"")+">Viewer - UK</OPTION>");
    out.println("<OPTION value=\"japan\" "+ (searchMkt.equals("japan")?"SELECTED":"")+">Japan</OPTION>");
    out.println("</SELECT>");
    out.println("</div>");

    
    
        out.println("<div id='divDocQuery'>");
        out.println("<B>Document URL:</B><INPUT type=\"text\" size=\"100\" id=\"docURL\" name=\"docURL\" value=\""+docURL+"\"> (end with * to wildcard a site)");
        out.println("<br>");    
        out.println("<B>Query:</B><INPUT type=\"text\" size=\"100\" id=\"clickQuery\" name=\"clickQuery\" value=\""+clickQuery+"\"> ");
        out.println("<br>");   
        out.println("<b>Exact Query Only:</b><INPUT type=checkbox name=\"bExactQuery\" "+ (bExactQuery?"CHECKED":"")+">");
        out.println("<br>"); 
        out.println("</div>");
        out.println("<div id='divEID'>");
        out.println("<B>EID:</B><INPUT type=\"text\" size=\"10\" id=\"eid\" name=\"eid\" value=\""+eid+"\">");

        out.println("</div>");
   
        
    out.println("<div id='divStartDate'>");
    
    out.println("<B>Start Date:</B><INPUT type=\"text\" id=\"startDate\" name=\"startDate\" value=\""+startDate+"\">");
    out.println("</div>");
    out.println("<div id='divEndDate'>");
    out.println("<B>End Date:</B><INPUT type=\"text\"  id=\"endDate\" name=\"endDate\"  value=\""+endDate+"\">");
    out.println("</div>");
    out.println("<div id='divArchive'>");
    out.println("<b>Use Archive</b><INPUT type=checkbox name=\"bArchive\" "+ (bArchive?"CHECKED":"")+"> (For data more than 90 days old)");
    out.println("</div>");
    
    out.println("<div id='divRole'>");
    out.println("<b>By Role</b><INPUT type=checkbox name=\"bIncludeRole\" "+ (bIncludeRole?"CHECKED":"")+">");
    out.println("</div>");
    
    out.println("<div id='divRoles'>");
    out.println("<B>For Role:</B><SELECT name=\"role\" >");
    out.println("<OPTION value=\"\" "+ (role.equals("")?"SELECTED":"")+">ALL</OPTION>");
    out.println("<OPTION value=\"100\" "+ (role.equals("100")?"SELECTED":"")+">CorpEmployees</OPTION>");
    out.println("<OPTION value=\"101\" "+ (role.equals("101")?"SELECTED":"")+">McOpCoRestMgrs</OPTION>");
    out.println("<OPTION value=\"102\" "+ (role.equals("102")?"SELECTED":"")+">Franchisees</OPTION>");
    out.println("<OPTION value=\"103\" "+ (role.equals("103")?"SELECTED":"")+">FranchiseeRestMgrs</OPTION>");
    out.println("<OPTION value=\"104\" "+ (role.equals("104")?"SELECTED":"")+">Crew</OPTION>");
    out.println("<OPTION value=\"105\" "+ (role.equals("105")?"SELECTED":"")+">SupplierVendor</OPTION>");
    out.println("<OPTION value=\"106\" "+ (role.equals("106")?"SELECTED":"")+">Agency</OPTION>");
    out.println("<OPTION value=\"107\" "+ (role.equals("107")?"SELECTED":"")+">FranchiseeOfficeStaff</OPTION>");
    out.println("</SELECT>");
    out.println("<br>");
    out.println("</div>");    



    out.println("<div id='divBasePeriod'>");
    out.println("<B>Base Period (days)</B><SELECT name=\"basePeriod\" >");
    out.println("<OPTION value=\"7\" "+ (basePeriod.equals("7")?"SELECTED":"")+">7</OPTION>");
    out.println("<OPTION value=\"14\" "+ (basePeriod.equals("14")?"SELECTED":"")+">14</OPTION>");
    out.println("<OPTION value=\"30\" "+ (basePeriod.equals("30")?"SELECTED":"")+">30</OPTION>");
    out.println("<OPTION value=\"60\" "+ (basePeriod.equals("60")?"SELECTED":"")+">60</OPTION>");
    out.println("</SELECT>");
    out.println("<br>");
    out.println("</div>");    

    out.println("<div id='divTrendPeriod'>");
    out.println("<B>Trend Period (days)</B><SELECT name=\"trendPeriod\" >");
    out.println("<OPTION value=\"1\" "+ (trendPeriod.equals("1")?"SELECTED":"")+">1</OPTION>");
    out.println("<OPTION value=\"2\" "+ (trendPeriod.equals("2")?"SELECTED":"")+">2</OPTION>");
    out.println("<OPTION value=\"7\" "+ (trendPeriod.equals("7")?"SELECTED":"")+">7</OPTION>");
    out.println("<OPTION value=\"30\" "+ (trendPeriod.equals("30")?"SELECTED":"")+">30</OPTION>");
    out.println("</SELECT>");
    out.println("<br>"); 
    out.println("</div>");
    
       
    out.println("<div id='divLimit'>");
    out.println("<B>Limit</B><SELECT name=\"nbrTerms\" >");
    out.println("<OPTION value=\"\" "+ (nbrTerms.equals("")?"SELECTED":"")+">ALL</OPTION>");
    out.println("<OPTION value=\"10\" "+ (nbrTerms.equals("10")?"SELECTED":"")+">10</OPTION>");
    out.println("<OPTION value=\"25\" "+ (nbrTerms.equals("25")?"SELECTED":"")+">25</OPTION>");
    out.println("<OPTION value=\"50\" "+ (nbrTerms.equals("50")?"SELECTED":"")+">50</OPTION>");
    out.println("<OPTION value=\"100\" "+ (nbrTerms.equals("100")?"SELECTED":"")+">100</OPTION>");
    out.println("<OPTION value=\"200\" "+ (nbrTerms.equals("200")?"SELECTED":"")+">200</OPTION>");
    out.println("<OPTION value=\"500\" "+ (nbrTerms.equals("500")?"SELECTED":"")+">500</OPTION>");
    out.println("</SELECT>");
    out.println("</div>");
 
    out.println("<div id='divButton'>");
     
    out.println("<INPUT TYPE=SUBMIT value=\"Get Report\">");
    out.println("</div>");
       
    out.println("</FORM><BR>");
    if(!reportType.equals("")){
        Connection conn = null;
        String dbSourceName = "search";
        conn = getConnection(sling, dbSourceName);
        
        if(reportType.equals("terms"))displayTermReport(out, conn, searchMkt, startDate, endDate, bArchive, bIncludeRole, nbrTerms,isAdmin);

        if(reportType.equals("documents")){
                 displayDocumentReport(out, conn, searchMkt, startDate, endDate, bArchive, bIncludeRole, nbrTerms);
        }
        if(reportType.equals("docqueries")){
                 displayDocumentQueriesReport(out, conn, searchMkt, startDate, endDate, bArchive, bIncludeRole, nbrTerms,docURL,clickQuery,bExactQuery);
                
        }


        
            if(reportType.equals("markets")){
                     displayMarketReport(out, conn, searchMkt, startDate, endDate, bArchive, bIncludeRole, nbrTerms,false);
                     displayMarketReport(out, conn, searchMkt, startDate, endDate, bArchive, bIncludeRole, nbrTerms,true);
            }           
if(isAdmin){
            if(reportType.equals("sessions")){
                     displaySessionsReport(out, conn, searchMkt, role, startDate, endDate, bArchive, eid, nbrTerms,docURL,clickQuery,1000,false);
                    
            }
            if(reportType.equals("sessionstats")){
                     displaySessionsReport(out, conn, searchMkt, role, startDate, endDate, bArchive, eid, nbrTerms,docURL,clickQuery,1000,true);
                    
            }
            if(reportType.equals("qleffectiveness")){
                     displaySessionsReport(out, conn, searchMkt, role, startDate, endDate, bArchive, eid, nbrTerms,docURL,clickQuery,20000,false);
                    
            }
            if(reportType.equals("trending")){
                     displayTrendingReport(out, conn, searchMkt, role, startDate, endDate, bArchive, bIncludeRole, nbrTerms,isAdmin,basePeriod,trendPeriod);
            }
        }
        try{
            closeConnection(conn);
        }catch(Exception e){
            out.println("Exception closing connection:"+e.getMessage());
        }
    }
    String tbsortcolumn="0";
    if(reportType.equals("trending"))tbsortcolumn="2";
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
    if(reportType.equals("docqueries"))out.println("$(\"#rawdata2\").tablesorter({sortList: [["+tbsortcolumn+",1]]});"); 
    out.println("});");

    out.println("</script>");
}

public void displayTermReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String startDate, String endDate, boolean bArchive, boolean bIncludeRole, String nbrTerms, boolean isAdmin) throws IOException{

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    out.println("Search queries appearing 5 or more times during report period. Queries are lower-cased before being logged. <br><br>"); 
    try{        
        out.println("<TABLE id='rawdata' class='tablesorter'>");
        out.println("<thead><tr style='font-weight:bold'>");
        
        out.println("<th>Searches</th>");
        if(bIncludeRole)out.println("<th>Role</th>");
        out.println("<th>Search Query</th>");        
        out.println("</tr></thead><tbody>");
        
        String searchTermSql = "select srch_log_qt_tx,count(*)"+(searchMkt.equals("ALL")?" ":",srch_log_mkt_cd ") +
        "from SRCH.tbsrch_log"+(bArchive?"_arch ":" ")+
        "where srch_log_ts > TO_DATE('"+startDate+"','MM/dd/yyyy') "+
        "and TRUNC(srch_log_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
        (searchMkt.equals("ALL")?"":"and srch_log_mkt_cd='"+searchMkt+"' ")+ 
        "group by srch_log_qt_tx"+(searchMkt.equals("ALL")?"":",srch_log_mkt_cd")+" "+
        "having count(*)>4 order by count(*) desc";
        
        if(bIncludeRole){
        searchTermSql = "select SRCH.tbsrch_role.SRCH_ROLE_DS,srch_log_qt_tx,count(*),srch_log_mkt_cd " +
        "from SRCH.tbsrch_log"+(bArchive?"_arch ":" ")+", SRCH.tbsrch_role "+
        "where srch_log_ts > TO_DATE('"+startDate+"','MM/dd/yyyy') "+
        "and TRUNC(srch_log_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
        (searchMkt.equals("ALL")?"":"and srch_log_mkt_cd='"+searchMkt+"' ")+ 
        "and SRCH.tbsrch_role.srch_role_cd=SRCH.tbsrch_log"+(bArchive?"_arch":"")+".SRCH_ROLE_CD "+
        "group by SRCH.tbsrch_role.SRCH_ROLE_DS,srch_log_qt_tx"+(searchMkt.equals("ALL")?"":",srch_log_mkt_cd")+" "+
        "having count(*)>4 order by count(*) desc";
        }
        //out.println(searchTermSql+"<br>");            
        pstmt = conn.prepareStatement(searchTermSql);
        rs = pstmt.executeQuery();
        long limit=1000000;
        if(!nbrTerms.equals(""))limit=Integer.parseInt(nbrTerms);
        String searchterm="";
        String role="";
        String searchcount="";
        long count=0; 
        String baseReportURL="?reportType=docqueries&bExactQuery=on&searchMkt="+searchMkt+"&startDate="+URLEncoder.encode(startDate)+"&endDate="+URLEncoder.encode(endDate); 
        while (rs.next()) {
            if(count>limit)break;
            
            if(bIncludeRole){
                role=rs.getString(1);
                searchterm=rs.getString(2);
                searchcount=rs.getString(3);
            }else{
                searchterm=rs.getString(1);
                searchcount=rs.getString(2);
            }
            if(searchterm==null || searchterm.equals("null")){
                continue;
            }else{
                String queriesURL=baseReportURL+"&clickQuery="+URLEncoder.encode(searchterm); 
                String querieslink="<a target=_blank href='"+queriesURL+"'>"+searchterm+"</a>";
                out.println("<tr>");
                out.println("<td>"+searchcount+"</td>");
                if(bIncludeRole)out.println("<td>"+role+"</td>");
                if(isAdmin){
                    out.println("<td>"+querieslink+"</td>");
                }else{
                    out.println("<td>"+searchterm+"</td>");
                }
               
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
public void displayTrendingReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String parmrole, String startDate, String endDate, boolean bArchive, boolean bIncludeRole, String nbrTerms, boolean isAdmin, String baseperiod, String trendperiod) throws IOException{

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    out.println("Search queries appearing 5 or more times during report period. Queries are lower-cased before being logged. <br><br>"); 
    try{        

        
        String searchBaseSql = "select srch_log_qt_tx,count(*)"+
        "from SRCH.tbsrch_log"+(bArchive?"_arch ":" ")+
        "where srch_log_ts > TO_DATE('"+endDate+"','MM/dd/yyyy')-"+baseperiod+
        " and TRUNC(srch_log_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
        (searchMkt.equals("ALL")?"":"and srch_log_mkt_cd='"+searchMkt+"' ")+
        (parmrole.equals("")?"":"and srch_role_cd='"+parmrole+"' ")+  
        "group by srch_log_qt_tx"+(searchMkt.equals("ALL")?"":",srch_log_mkt_cd")+" ";
        searchBaseSql+="having count(*)>4 order by count(*) desc";
        
        String searchTrendSql = "select srch_log_qt_tx,count(*)"+
        "from SRCH.tbsrch_log"+(bArchive?"_arch ":" ")+
        "where srch_log_ts > TO_DATE('"+endDate+"','MM/dd/yyyy')-"+trendperiod+
        " and TRUNC(srch_log_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
        (searchMkt.equals("ALL")?"":"and srch_log_mkt_cd='"+searchMkt+"' ")+ 
        (parmrole.equals("")?"":"and srch_role_cd='"+parmrole+"' ")+  
        "group by srch_log_qt_tx"+(searchMkt.equals("ALL")?"":",srch_log_mkt_cd")+" "+
        "having count(*)>4 order by count(*) desc";
        
        
        //out.println(searchBaseSql +"<br>");  
        //out.println(searchTrendSql+"<br>");            
        
        
        pstmt = conn.prepareStatement(searchBaseSql);
        rs = pstmt.executeQuery();
        long limit=1000000;
        if(!nbrTerms.equals(""))limit=Integer.parseInt(nbrTerms);
        int nBasePeriod=Integer.parseInt(baseperiod);
        int nTrendPeriod=Integer.parseInt(trendperiod);
        double trendthreshold=((nTrendPeriod*1.0)/(nBasePeriod*1.0))*1.2;
        String searchterm="";
        String role="";
        String searchcount="";
        long count=0; 
        String baseReportURL="?reportType=docqueries&bExactQuery=on&searchMkt="+searchMkt+"&startDate="+URLEncoder.encode(startDate)+"&endDate="+URLEncoder.encode(endDate); 
        HashMap counts=new HashMap();
       // out.println("A:");
        while (rs.next()) {
          //  out.println("count:"+count);
            if(count>limit)break;
            
            if(bIncludeRole){
                role=rs.getString(1);
                searchterm=rs.getString(2);
                searchcount=rs.getString(3);
            }else{
                searchterm=rs.getString(1);
                searchcount=rs.getString(2);
            }
            if(searchterm!=null && !searchterm.equals("null")){
                incrementMap(counts,getSynonym(searchterm), (Integer.parseInt(searchcount)));
            }
            count++;
            
        }
        
        //final day of period counts
        pstmt = conn.prepareStatement(searchTrendSql);
        rs = pstmt.executeQuery();
        limit=1000000;
        count=0; 
        TreeMap recentcounts=new TreeMap();
        int maxcount=0;
        while (rs.next()) {
            if(count>limit)break;
            
            if(bIncludeRole){
                role=rs.getString(1);
                searchterm=rs.getString(2);
                searchcount=rs.getString(3);
            }else{
                searchterm=rs.getString(1);
                searchcount=rs.getString(2);
            }
            if(searchterm!=null && !searchterm.equals("null")){
                int cnt=Integer.parseInt(searchcount);
                if(cnt>maxcount)maxcount=cnt;
                incrementMap(recentcounts,getSynonym(searchterm), cnt);
            }
            count++;
            
        }
          
        
        //output
        String tagcloudA="";
        String tagcloudB="";
        String tablehtml="";
        tablehtml+="<TABLE id='rawdata' class='tablesorter'>";
        tablehtml+="<thead><tr style='font-weight:bold'>";
        
        tablehtml+="<th>"+baseperiod+" Day Searches</th>";
        tablehtml+="<th>"+trendperiod+" Day Searches</th>";
        tablehtml+="<th>"+trendperiod+" Day vs "+ baseperiod+" Day</th>";
        if(bIncludeRole)tablehtml+="<th>Role</th>";
        tablehtml+="<th>Search Query</th>";        
        tablehtml+="</tr></thead><tbody>";
        
        //adjust maxcount
        maxcount=0;
        for(Object key:recentcounts.keySet()){
            int recentcount=((Integer)recentcounts.get(key));
            int periodcount=0;
            
            if(counts.containsKey(key))periodcount=((Integer)counts.get(key));
            searchterm=(String)key;
            double trend=0;
            if(recentcount>0){
                trend=recentcount*1.0/(periodcount*1.0);
            }
            if(trend>trendthreshold){
                if(recentcount>maxcount)maxcount=recentcount;
            }
        }
        
        for(Object key:recentcounts.keySet()){
                int recentcount=((Integer)recentcounts.get(key));
                int periodcount=0;
                
                if(counts.containsKey(key))periodcount=((Integer)counts.get(key));
                searchterm=(String)key;
                double trend=0;
                if(recentcount>0){
                    trend=recentcount*1.0/(periodcount*1.0);
                }
                if(trend<1 && trend>trendthreshold){
                    String queriesURL=baseReportURL+"&clickQuery="+URLEncoder.encode(searchterm); 
                    String querieslink="<a target=_blank href='"+queriesURL+"'>"+searchterm+"</a>";
                    tablehtml+="<tr>";
                    tablehtml+="<td>"+periodcount+"</td>";
                    tablehtml+="<td>"+recentcount+"</td>";
                    tablehtml+="<td>"+trend+"</td>";
                    if(bIncludeRole)tablehtml+="<td>"+role+"</td>";
                    if(isAdmin){
                        tablehtml+="<td>"+querieslink+"</td>";
                    }else{
                        tablehtml+="<td>"+searchterm+"</td>";
                        
                    }
                   //if(trend>.6)tagcloud+="<font style='font-size:"+Math.round((trend-.5)*40+6)+"px'>"+searchterm+"</font>&nbsp;&nbsp;";
                   if(trend>trendthreshold){
                       long fontsize=periodcount/((maxcount/48));
                       tagcloudA+="<font style='font-size:"+(fontsize>48?48:fontsize)+"px'>&nbsp;&nbsp;"+searchterm+"&nbsp;&nbsp;</font>";
                       fontsize = 10+Math.round(((trend-trendthreshold)/(1-trendthreshold))*48.0);
                       tagcloudB+="<font style='font-size:"+(fontsize>48?48:fontsize)+"px'>&nbsp;&nbsp;"+searchterm+"&nbsp;&nbsp;</font>";
                   }
                    tablehtml+="</tr>";
                }
            }
        
        tablehtml+="</tbody></table>";
        out.println("<hr><h3><font style='color:green;'>Trending - sized by # queries</font></h3>");
        out.println("<br>"+tagcloudA);
        out.println("<hr><h3><font style='color:green;'>Trending - sized by % Change </font></h3>");
        out.println("<br>"+tagcloudB);
        out.println("<br>"+tablehtml);
        
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

public void displayMarketReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String startDate, String endDate, boolean bArchive, boolean bIncludeRole,  String nbrTerms, boolean bUniqueUsers) throws IOException{

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
            "group by srch_log_mkt_cd,TO_CHAR(srch_log_ts,'yyyy-MM') "+
            "order by TO_DATE(TO_CHAR(srch_log_ts,'yyyy-MM'),'yyyy-MM'),srch_log_mkt_cd";
        
        
            if(bIncludeRole){
            searchMktSql = "select TO_CHAR(srch_log_ts,'yyyy-MM') as mnth,srch_log_mkt_cd,SRCH_ROLE_DS,count(*) as cnt "+
            "from srch."+logtable+", SRCH.tbsrch_role " +
            "where srch_log_ts > (sysdate-365) " +
            "and SRCH.tbsrch_role.srch_role_cd=SRCH."+logtable+".SRCH_ROLE_CD " +
            "group by srch_log_mkt_cd,SRCH_ROLE_DS,TO_CHAR(srch_log_ts,'yyyy-MM') "+
            "order by TO_DATE(TO_CHAR(srch_log_ts,'yyyy-MM'),'yyyy-MM'),srch_log_mkt_cd,SRCH_ROLE_DS";
            }
        }else{
            //Unique users
            searchMktSql="select mnth,srch_log_mkt_cd,count(*) as cnt "+
            "from ( "+
            "select TO_CHAR(srch_log_ts,'yyyy-MM') as mnth,srch_log_mkt_cd,srch_log_usr_id,count(*) " +
            "from srch."+logtable+" " +
            "where srch_log_ts > (sysdate-365) " +
            "group by srch_log_usr_id,srch_log_mkt_cd,TO_CHAR(srch_log_ts,'yyyy-MM') "+
            ") "+
            "group by mnth,srch_log_mkt_cd "+
            "order by TO_DATE(mnth,'yyyy-MM'),srch_log_mkt_cd";
        
        
            if(bIncludeRole){
            searchMktSql = "select TO_CHAR(srch_log_ts,'yyyy-MM') as mnth,srch_log_mkt_cd,SRCH_ROLE_DS,count(*) as cnt "+
            "from srch."+logtable+", SRCH.tbsrch_role " +
            "where srch_log_ts > (sysdate-365) " +
            "and SRCH.tbsrch_role.srch_role_cd=SRCH."+logtable+".SRCH_ROLE_CD " +
            "group by srch_log_mkt_cd,SRCH_ROLE_DS,TO_CHAR(srch_log_ts,'yyyy-MM') "+
            "order by TO_DATE(TO_CHAR(srch_log_ts,'yyyy-MM'),'yyyy-MM'),srch_log_mkt_cd,SRCH_ROLE_DS";
            
            searchMktSql="select mnth,srch_log_mkt_cd,SRCH_ROLE_DS,count(*) as cnt "+
            "from ( "+
            "select TO_CHAR(srch_log_ts,'yyyy-MM') as mnth,srch_log_mkt_cd,SRCH_ROLE_DS,srch_log_usr_id,count(*) " +
            "from srch."+logtable+", SRCH.tbsrch_role " +
            "where srch_log_ts > (sysdate-365) " +
            "and SRCH.tbsrch_role.srch_role_cd=SRCH."+logtable+".SRCH_ROLE_CD " +
            "group by srch_log_usr_id,SRCH_ROLE_DS,srch_log_mkt_cd,TO_CHAR(srch_log_ts,'yyyy-MM') "+
            ") "+
            "group by mnth,srch_log_mkt_cd,SRCH_ROLE_DS "+
            "order by TO_DATE(mnth,'yyyy-MM'),srch_log_mkt_cd,SRCH_ROLE_DS";

            }
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
            if(bIncludeRole){
                searchmkt=rs.getString(2)+" "+rs.getString(3);
                searchcount=rs.getString(4);
            }else{
                searchmkt=rs.getString(2);
                searchcount=rs.getString(3);
            }
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
        if(bIncludeRole){
            out.println("<th>Market/Role</th>");
        }else{
            out.println("<th>Market</th>");
            }
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


public void displayDocumentReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String startDate, String endDate, boolean bArchive, boolean bIncludeRole, String nbrTerms) throws IOException{

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");

    PreparedStatement pstmt = null;
    ResultSet rs = null; 
    

    try{        
        out.println("<TABLE id='rawdata' class='tablesorter'>");
        out.println("<thead><tr style='font-weight:bold'>");
        //if(bIncludeRole)out.println("<th>Role</th>");
        out.println("<th>Clicks</th>");
        out.println("<th>Document</th>");
        out.println("</tr></thead><tbody>");
        
        String searchSql = "select srch_click_url_tx,count(*) " +
        "from SRCH.tbsrch_click " +
        "where srch_click_ts > TO_DATE('"+startDate+"','MM/dd/yyyy') "+
        "and TRUNC(srch_click_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
         (searchMkt.equals("ALL")?"":"and srch_click_qt_tx like '"+searchMkt+" %' ")+ 
        "group by srch_click_url_tx "+
        "having count(*)>4 order by count(*) desc";
        //out.println("SQL:"+searchSql);        
        pstmt = conn.prepareStatement(searchSql);
        rs = pstmt.executeQuery();
        long limit=1000000;
        if(!nbrTerms.equals(""))limit=Integer.parseInt(nbrTerms);
        //out.println("limit:"+limit);
        String searchdoc="";
        String role="";
        String searchcount="";
        long count=0;
        String baseReportURL="?reportType=docqueries&searchMkt="+searchMkt+"&startDate="+URLEncoder.encode(startDate)+"&endDate="+URLEncoder.encode(endDate); 
        while (rs.next()) {
            //out.println("next");
            
            if(count>limit)break;
            
            if(bIncludeRole){
                role=rs.getString(1);
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
                //if(bIncludeRole)out.println("<td>"+role+"</td>");
                String doclink="<a target=_blank href='"+searchdoc+"'>"+searchdoc+"</a>";
                String queriesURL=baseReportURL+"&docURL="+URLEncoder.encode(searchdoc); 
                String querieslink="<a target=_blank href='"+queriesURL+"'>queries</a>";
                out.println("<td>"+searchcount+"</td>");
                out.println("<td>"+doclink+" "+querieslink+"</td>");

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

public void displayDocumentQueriesReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String startDate, String endDate, boolean bArchive, boolean bIncludeRole, String nbrTerms, String docURL, String clickQuery, boolean bExactQuery) throws IOException{
    TreeMap tmDocs=new TreeMap();
    long totalDocs=0;
    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
    boolean bWildcard=false;
    if(docURL.endsWith("*")){
        bWildcard=true;
        docURL=docURL.substring(0,docURL.length()-1);
    }
    boolean bClickQuery=false;
    boolean bClickQueryWildcard=false;
    if(!clickQuery.equals("")){
        bClickQuery=true;
        if(clickQuery.indexOf("|")<0)
            bClickQueryWildcard=true;
    }    
    
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    if(bClickQuery){
        out.println("Documents clicked on for mkt|role|query:"+clickQuery+"<br><br>");
    }else{
        out.println("Search queries resulting in "+(bWildcard?"document clicks within site":"clicks on")+":<a href='"+docURL+(bWildcard?".html":"")+"'>"+docURL+(bWildcard?".html":"")+"</a><br><br>"); 
    }
    try{        
        out.println("<TABLE id='rawdata' class='tablesorter'>");
        out.println("<thead><tr style='font-weight:bold'>");
        out.println("<th>Clicks</th>");
        out.println("<th>Avg Result Position</th>");
        if(bIncludeRole)out.println("<th>Role</th>");
        out.println("<th width=50>Market</th>");
        out.println("<th width=100>Role</th>");
        out.println("<th width=200>Query</th>");
        if(bWildcard||bClickQuery)out.println("<th>Document</th>");
        
        out.println("</tr></thead><tbody>");
        
        String searchSql = "select srch_click_qt_tx,"+((bClickQuery || bWildcard)?"srch_click_url_tx,":"")+" count(*),(avg(srch_click_rslt_nu)+1) " +
        "from SRCH.tbsrch_click " +
        "where srch_click_ts > TO_DATE('"+startDate+"','MM/dd/yyyy') "+
        "and TRUNC(srch_click_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') ";
        if(bClickQuery){
          if(bExactQuery){
              searchSql +="and (srch_click_qt_tx "+(bClickQueryWildcard?" like '%| "+clickQuery+"' ":" ='"+clickQuery+"' ");
              searchSql +="or srch_click_qt_tx "+(bClickQueryWildcard?" like 'QuickLink:"+clickQuery+"' ":" ='"+clickQuery+"' ")+")";
          }else{
              searchSql +="and srch_click_qt_tx "+(bClickQueryWildcard?" like '%"+clickQuery+"%' ":" ='"+clickQuery+"' ");
          }
        }else{
           if(!searchMkt.equals("ALL")){
                searchSql +="and srch_click_qt_tx like '"+searchMkt+" %' ";
           }
           searchSql+="and srch_click_url_tx"+(bWildcard?" like '"+docURL+"%' ":"='"+docURL+"' ");
        }  
        searchSql+= "group by srch_click_qt_tx"+( (bClickQuery || bWildcard)?",srch_click_url_tx ":" ")+
        "order by count(*) desc";
        //out.println(searchSql);
        pstmt = conn.prepareStatement(searchSql);
        rs = pstmt.executeQuery();
        long limit=1000000;
        if(!nbrTerms.equals(""))limit=Integer.parseInt(nbrTerms);
        String searchquery="";
        String searchdoc="";
        String searchcount="";
        String resultno="";
        boolean bQuickLink=false;
        boolean bSuggestedSite=false;
        
        long count=0;
        String baseReportURL="?reportType=docqueries&searchMkt="+searchMkt+"&startDate="+URLEncoder.encode(startDate)+"&endDate="+URLEncoder.encode(endDate);
        while (rs.next()) {
            if(count>limit)break;
            
            if(bWildcard || bClickQuery){
                searchquery=rs.getString(1);
                searchdoc=rs.getString(2);
                searchcount=rs.getString(3);
                resultno=rs.getString(4);
            }else{
                searchquery=rs.getString(1);
                searchcount=rs.getString(2);
                resultno=rs.getString(3);
            }
            if(searchquery==null || searchquery.equals("null")){
                continue;
            }else{
                bQuickLink=searchquery.startsWith("QuickLink");
                bSuggestedSite=searchquery.startsWith("ss |");
                if(bSuggestedSite)searchquery=searchquery.substring(searchquery.indexOf("|")+1);
                int querystart=searchquery.lastIndexOf("|");
                String query=searchquery.substring(querystart+1);
                int marketend=searchquery.indexOf("|");
                String market="";
                String role="";
                String highlightColor=(bQuickLink?"yellow":(bSuggestedSite?"lime":"white"));
                
                if(marketend>-1){
                    market=searchquery.substring(0,marketend);
                    int roleend=searchquery.indexOf("|",marketend+1);
                    if(roleend>-1){
                        role=searchquery.substring(marketend+1,roleend);
                    }
                }
                out.println("<tr >");
                out.println("<td style='background-color:"+highlightColor+"'>");
                out.println(searchcount+"</td>");
                out.println("<td style='background-color:"+highlightColor+"'>");
                if(!bQuickLink){
                    if(resultno.indexOf(".")>-1)resultno=resultno.substring(0,resultno.indexOf(".")+2);                  
                }  
                out.println(resultno+"</td>");
                out.println("<td style='width:50;white-space:nowrap;background-color:"+highlightColor+"'>"+market+"</td>");
                
                out.println("<td style='width:100;white-space:nowrap;background-color:"+highlightColor+"'>"+role+"</td>"); 
                
                out.println("<td style='width:200;white-space:nowrap;background-color:"+highlightColor+"'>");   
                //out.println("<td>");
               // if(bQuickLink)out.println("<font color=green>");
                String queriesDrillDownURL=baseReportURL+"&clickQuery="+URLEncoder.encode(query);
                String boldquery=searchquery;
                if(bQuickLink){
                    boldquery="QuickLink:<font size=3>"+searchquery.substring(10)+"</font>";
                }else{
                    querystart=searchquery.lastIndexOf("|");
                    if(querystart>0)boldquery=(bSuggestedSite?"Suggested Site: ":"")+"<font size=3><b>"+searchquery.substring(querystart+1)+"</b></font>";
                }
                String queriesDrillDownLink="<a target=_blank href='"+queriesDrillDownURL+"'>"+boldquery+"</a>";
                out.println(queriesDrillDownLink);
               // if(bQuickLink)out.println("</font>");
                out.println("</td>");

                if(bWildcard||bClickQuery){
                      int intsearchcount=Integer.valueOf(searchcount).intValue();
                        if(tmDocs.keySet().contains(searchdoc)){
                            tmDocs.put(searchdoc,((Integer)tmDocs.get(searchdoc)).intValue()+intsearchcount);
                        }else{
                            tmDocs.put(searchdoc,intsearchcount);
                        }
                        totalDocs+=intsearchcount;
                //String doclink="<a target=_blank href='"+searchdoc+"'>"+searchdoc+"</a>";
                    String doclink="<a target=_blank href='"+searchdoc+"'>"+searchdoc+"</a>";
                    String queriesURL=baseReportURL+"&docURL="+URLEncoder.encode(searchdoc); 
                    String querieslink="<a target=_blank href='"+queriesURL+"'>queries</a>";
                    //out.println("<td>"+doclink+" "+querieslink+"</td>");                   
                    //out.println("<td>");
                    out.println("<td style='background-color:"+highlightColor+"'>");
                    //if(bQuickLink)out.println("<font color=green>"); 
                    out.println(doclink+" "+querieslink); 
                    //if(bQuickLink)out.println("</font>");
                    out.println("</td>");
                }

                out.println("</tr>");
            }
            count++;
            
        }
        out.println("</tbody></table>");
        
        //output document totals
        Iterator iterDocs=tmDocs.keySet().iterator();
        out.println("<table>");
        out.println("<TABLE id='rawdata2' class='tablesorter'>");
        out.println("<thead><tr style='font-weight:bold'>");

        out.println("<th>Total Clicks</th>");
        out.println("<th>% of Clicks</th>");
        out.println("<th>Document</th>");
                
        out.println("</tr></thead><tbody>");
        while(iterDocs.hasNext()){
            out.println("<tr>");
            String docurl=(String)iterDocs.next();
           
            Integer cnt=(Integer)tmDocs.get(docurl);
            out.println("<td align='right'>"+cnt+"</td>");
            out.println("<td align='right'>"+((cnt*100)/totalDocs)+"%</td>");
             out.println("<td>"+docurl+"</td>");
             out.println("</tr>");
                
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
         
public void displaySessionsReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String role, String startDate, String endDate, boolean bUseArchive, String eid,  String nbrTerms, String docURL, String clickQuery, int rows, boolean bStatsOnly) throws IOException{

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    

    try{               
        String searchLogSql = "select srch_log_ts,srch_log_usr_id,srch_log_mkt_cd,srch_role_cd,srch_log_qt_tx ";
        if(bUseArchive && !endDate.equals("")){
            searchLogSql +="from SRCH.tbsrch_log_arch ";
        }else{
            searchLogSql +="from SRCH.tbsrch_log ";
        }
        
        searchLogSql += "where ";
        if(rows!=20000 && !eid.equals("")){
            searchLogSql += "srch_log_usr_id='"+eid+"' and ";
        }   
        if(!endDate.equals("")){
            searchLogSql +=" srch_log_ts > TO_DATE('"+endDate+"','MM/dd/yyyy')-1";
            if(eid.equals("")){
                searchLogSql +=" and TRUNC(srch_log_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy')";
            }
        }else{
            if(eid.equals(""))
                searchLogSql += " srch_log_seq_id > (select max(srch_log_seq_id) "+
            "from SRCH.tbsrch_log)-"+rows;
            }
      
        
        if(!role.equals("")){
           searchLogSql += " and srch_role_cd="+role;
        }
         
        
        String searchClickSql = "select srch_click_ts,srch_click_usr_id,srch_click_qt_tx,srch_click_rslt_nu+1,srch_click_url_tx " +
        "from SRCH.tbsrch_click ";
        
        
        searchClickSql += "where ";
        if(rows!=20000 && !eid.equals("")){
            searchClickSql += "srch_click_usr_id='"+eid+"' and ";
        }   
        if(!endDate.equals("")){
            searchClickSql +=" srch_click_ts> TO_DATE('"+endDate+"','MM/dd/yyyy')-1";
            if(eid.equals("")){
                searchClickSql +=" and TRUNC(srch_click_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy')";
            }
        }else{
            if(eid.equals(""))
                searchClickSql += " srch_click_seq_id > (select max(srch_click_seq_id) "+
            "from SRCH.tbsrch_click)-"+rows;
            }
            
            
        /*
        if(rows!=20000 && !eid.equals("")){
            searchClickSql += "where srch_click_usr_id='"+eid+"' and srch_click_ts>(SYSDATE-7)";
        }else{
            if(!endDate.equals("")){
               searchClickSql +="where srch_click_ts > TO_DATE('"+endDate+"','MM/dd/yyyy')-1 "+
                    "and TRUNC(srch_click_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy')";
            }else{
                searchClickSql += "where srch_click_seq_id > (select max(srch_click_seq_id) "+
                "from SRCH.tbsrch_click)-"+rows;
            }
        }
        */
        
        //out.println("searchLogSql:"+searchLogSql+"<br>");   
        //out.println("searchClickSql:"+searchClickSql+"<br>");  
        
        pstmt = conn.prepareStatement(searchLogSql);

        rs = pstmt.executeQuery();

        long count=0;
        String rolecode="";
        ArrayList events=new ArrayList();
        HashMap eids=new HashMap();
        /***** QUERIES *****/
        //out.println("start queries loop");
        while (rs.next()) {
            SearchEvent event=new SearchEvent();
            event.timestamp=rs.getTimestamp(1);
            event.eid=rs.getString(2);
            event.mkt=rs.getString(3);
            rolecode=rs.getString(4);
            event.role=decodeRole(rolecode);
            event.query=rs.getString(5);
            if(event.query==null)event.query="";
            count++;
            if((searchMkt.equals("ALL") || event.mkt.equals(searchMkt))){
                     eids.put(event.eid,1);
                     events.add(event);
            }
            //if(count==100)break;
        }
        
        pstmt = conn.prepareStatement(searchClickSql);

        rs = pstmt.executeQuery();

        
        /***** CLICKS *****/
        //out.println("start clicks loop");
        while (rs.next()) {
            SearchEvent event=new SearchEvent();
            event.timestamp=rs.getTimestamp(1);
            event.eid=rs.getString(2).toUpperCase();
            
            String qtTx=rs.getString(3);

            if(qtTx!=null){
             if(qtTx.startsWith("QuickLink:")){
                event.query=qtTx.substring("QuickLink:".length());
                event.isQuickLink=true;
             }else{
                if(qtTx.startsWith("ss | ")){
                    event.isSearchSuggestion=true;
                    
                    qtTx=qtTx.substring("ss | ".length());
                }
                String[] qttx=qtTx.split("\\|");
                if(qttx.length>2){
                    event.mkt=qttx[0].trim();
                    event.role=qttx[1].trim();
                    event.query=qttx[2].trim();
                    if(event.query.startsWith("after:")){
                        event.query=event.role;
                        event.role="";
                    }
                }else if(qttx.length==2){
                    event.mkt=qttx[0].trim();
                    event.query=qttx[1].trim();
                }else{
                    event.query=qtTx;
                }
             }
            }
            event.resultno=rs.getInt(4);
            event.url=rs.getString(5);
            event.isClick=true;
            count++;
            if(eids.containsKey(event.eid) || (event.isSearchSuggestion && (searchMkt.equals("ALL") || event.mkt.equals(searchMkt))))

                   events.add(event);
            //if(count==100)break;
        }
        
        //Collections.sort(events,new eventComparator());
        //outdebug(out,"before analyze");       
        analyzeEvents(out,events,rows,bStatsOnly);
        //outdebug(out,"after analyze");  
    }catch (Exception e) {
            out.println("searchReport:Exception " + e);
            
    }finally {
        try {

            closeStatement(pstmt);
            closeResultSet(rs);
            
        } catch (Exception e) {System.out.println("searchReport:Exception closing");}
    }
}

private void outputSearchSessions(javax.servlet.jsp.JspWriter out,ArrayList<SearchEvent> events,String filter){
        SimpleDateFormat sf= new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
        
     try{
        out.println("Search activity from recent queries.<br>");
              
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
        SearchEvent lastevent=null;
        boolean bPassFilter=false;
        
        long start=0;
        while(iterEvent.hasNext()){
            
            SearchEvent event=(SearchEvent)iterEvent.next();
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
                        if(event.isSlowSession){
                            sessiondata+=td("Slow","#f33");
                        }else{
                            if(event.isQLSession){
                                sessiondata+=td("QuickLink","#ff6");
                            }else{
                                if(event.isSuggestSession){
                                    sessiondata+=td("Search Suggestion","#0f6");
                                }else{
                                    sessiondata+=td("");
                                }
                            }
                        }
                        if(lastevent==null){
                            sessiondata+=td(sf.format(event.timestamp),bgcolor);
                            sessiondata+=td(event.eid,bgcolor);
                            sessiondata+=td(event.mkt,bgcolor);
                            sessiondata+=td(event.role,bgcolor);
                        }else{
                           
                            //sessiondata+=td(sf.format(event.timestamp),bgcolor);
                            
                            sessiondata+=td("+"+event.elapsed+ " s.",(event.elapsed>60)?"#f33":(event.isQuickLink?"#ff6":bgcolor));
                            sessiondata+=td("",bgcolor);
                            sessiondata+=td("",bgcolor);
                            sessiondata+=td("",bgcolor);
                        } 

                        sessiondata+=td("<b>"+event.query+"</b>",(event.isQLSession?"#ff6":""));
                        //sessiondata+=td("<b>QuickLink</b>","#ff6");;
                        if(!event.isQuickLink && !event.isSearchSuggestion){
                            //sessiondata+=td(""+(event.isClick?event.resultno:""));
                            sessiondata+=td(""+(event.resultno>0?event.resultno:""),(event.resultno>10)?"#f33":bgcolor);
                        }else{
                            if(event.isQuickLink){
                                sessiondata+=td("<b>QuickLink</b>","#ff6");
                            }else{
                                sessiondata+=td("<b>Search Suggestion</b>","#0f6");
                            }
                        }
                        if(event.isExitDoc)
                            sessiondata+=td("Exit");
                        else 
                            sessiondata+=td("");
                        String doclink="<a target=_blank href='"+event.url+"'>"+event.url+"</a>";
                        
                        sessiondata+=td("<b>"+doclink+"</b>",(event.isQuickLink?"#ff6":"")); 
   
                        
                    
                    if(!bPassFilter && (filter.equals("") || event.query.toLowerCase().contains(filter))){
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

private void outputQLEffectiveness(javax.servlet.jsp.JspWriter out,ArrayList<SearchEvent> events){
        SimpleDateFormat sf= new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
        
     try{
        
        // Get top queries
        
        TreeMap<String, Integer> topqueries=new TreeMap();
        TreeMap<String, Integer> slowqueries=new TreeMap();
        TreeMap<String, Integer> exitdocs=new TreeMap();
        TreeMap<String, Integer> QLExits=new TreeMap();
        TreeMap<String, Integer> SSExits=new TreeMap();
        
        //TreeMap<String, Integer> helpfulQL=new TreeMap();
        
        for(SearchEvent event:events){
            String query=event.query.toLowerCase().trim();
            if(event.isExitDoc && !query.equals("")){
                incrementMap(topqueries,query);
                if(event.isSlowSession)incrementMap(slowqueries,query);
                String exitdocurl=event.url;
                if(exitdocurl.contains("/content/")){
                    exitdocurl=exitdocurl.replace("/content","");
                }
                if(event.isQuickLink)incrementMap(QLExits,query);
                if(event.isSearchSuggestion)incrementMap(SSExits,query);
                incrementMap(exitdocs,query+"|"+exitdocurl);
            }
        }
        
        //summaries top queries and exit docs and % which are Quick Links
        
        out.println("Potential New or Improved Quick Links<br>");
              
        out.println("<TABLE id='rawdata' class='tablesorter' >");
        out.println("<thead><tr style='font-weight:bold'>");
        out.println("<th>query</th>");
        out.println("<th>Sessions</th>");
        out.println("<th>% Quick Links</th>");
        out.println("<th>% Site Suggestions</th>");
        out.println("<th>% Slow</th>");
        out.println("<th>Top Exit Doc %</th>");
        out.println("<th>Top Exit Doc</th>");
        out.println("</tr></thead><tbody>");
        
        SortedSet sortedterms=entriesSortedByValues(topqueries);
        int count=0;
        for(Object termentry: sortedterms){
            String term=(String)((Map.Entry)termentry).getKey();
            Integer termcount=(Integer)((Map.Entry)termentry).getValue();
            
            
            int maxdoccount=0;
            int totalexits=0;
            
            String maxdoc="";   
            for(Object exdoc: exitdocs.keySet()){
                String querydoc=(String)exdoc;
                if(querydoc.startsWith(term+"|")){
                    Integer clickcount=(Integer)exitdocs.get(exdoc);
                    if(clickcount>maxdoccount){
                        maxdoccount=clickcount;
                        maxdoc=querydoc;
                    }
                    totalexits+=clickcount;
                }
            }
            Integer totalQLexits=(Integer)QLExits.get(term);
            Integer totalSSexits=(Integer)SSExits.get(term);
            Integer totalSlow=(Integer)slowqueries.get(term);

            double qlpct=0;
            if(totalQLexits!=null)qlpct=Math.round((totalQLexits/(totalexits*1.0))*100.0);
            double sspct=0;
            if(totalSSexits!=null)sspct=Math.round((totalSSexits/(totalexits*1.0))*100.0);
            double slowpct=0;
            if(totalSlow!=null)slowpct=Math.round((totalSlow/(totalexits*1.0))*100.0);
            double edpct=0;
            if(maxdoccount>0)edpct=Math.round((maxdoccount/(totalexits*1.0))*100.0);
            String bgcolor="white";
            String edbgcolor="white";
            String slowbgcolor="white";
            String termcolor="white";
            
            if(qlpct<50 || slowpct>10){
                if(qlpct<50)bgcolor="orange";
                if(qlpct<10)bgcolor="red";
                if(edpct>80)edbgcolor="yellow";
                if(edpct>90)edbgcolor="lime";
                if(slowpct>10)slowbgcolor="orange";
                if(slowpct>25)slowbgcolor="red";
                if(qlpct<10 && edpct>80)termcolor=edbgcolor;
                out.println("<tr>");
                out.println(td(term,termcolor)+td(""+totalexits)+td(""+qlpct+"%",bgcolor)+td(""+sspct+"%",bgcolor)+td(""+slowpct+"%",slowbgcolor)+td(""+edpct+"%",edbgcolor)+td(maxdoc.split("\\|")[1]));
                out.println("</tr>");
                count++;
                
            }
            if(count>100)break;
        }

        out.println("</tbody></table>");
 
        
    }catch (Exception e) {
            try{
                out.println("searchReport:Exception " + e);
            }catch(IOException ioe){
            }
    }
    return;
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
    
private void analyzeEvents(javax.servlet.jsp.JspWriter out,ArrayList<SearchEvent> events,int rows,boolean bStatsOnly){
        Collections.sort(events,new eventComparator());
        int sessioncount=0;
        int qlsessions=0;
        int suggestsessions=0;
        int slowsessions=0;
        boolean bQuickLinkSession=false;
        boolean bSlowSession=false;
        boolean bSearchSuggestionSession=false;
        String lastquery="";
        TreeMap<String, Integer> slowterms=new TreeMap();
        TreeMap<String, Integer> slowqueries=new TreeMap();
        TreeMap<String, Integer> okterms=new TreeMap();
        TreeMap<String, Integer> okqueries=new TreeMap();
        
        boolean bStart=true;
        
        String lastEID="";
        
        long start=0;
        long elapsed=0;
        long lasteventtime=0;
        int count=0;
        int ecuser3cnt=0;
        int sessionlinksclicked=0;
        int sessionid=0;
        int elapsedsessions=0;
        long elapsedtotal=0;
        boolean bHaveQuery=false;
        
        SearchEvent lastevent=null;
        ArrayList<SearchEvent> sessionevents=new ArrayList<SearchEvent>();
        
        Iterator iterEvent=events.iterator();
        java.util.Date earliestTimestamp=new java.util.Date();
        while( iterEvent.hasNext()){
            //outdebug(out,""+sessionid);
            SearchEvent event=(SearchEvent)iterEvent.next();

            
            if(lastevent!=null){
                /*
                outdebug(out,"check for session end");
                outdebug(out,""+(lastevent.eid==null));
                outdebug(out,""+(event.eid==null));
                outdebug(out,""+(event.timestamp==null));
                outdebug(out,""+(lastevent.timestamp==null));
                outdebug(out,""+(event.query==null));
                */
                if(!lastevent.eid.equals(event.eid) || 
                        !areSimilar(event.query,lastquery) ||
                        ((event.timestamp.getTime()-lastevent.timestamp.getTime())/1000)>300
                ){
                    
                    /*** Next Session ***/
                   
                    if(!bQuickLinkSession && !bSearchSuggestionSession && lastevent.elapsed>60){
                        bSlowSession=true;
                        slowsessions++;
                    }else{
                        if(bQuickLinkSession)qlsessions++;
                        if(bSearchSuggestionSession){
                           
                            suggestsessions++;
                            }
                    }
                    SearchEvent exitdoc=null;
                    if(event.timestamp.getTime()<earliestTimestamp.getTime()){
                        earliestTimestamp=event.timestamp;
                    }
                    for(SearchEvent e:sessionevents){
                            e.sessionid=sessionid;
                            e.isSlowSession=bSlowSession;
                            e.isQLSession=bQuickLinkSession;
                            e.isSuggestSession=bSearchSuggestionSession;
                            if(e.isClick)exitdoc=e;
                    }
              
              
                    if(lastevent.elapsed>0){
                        elapsedtotal+=((lastevent.elapsed<1800)?lastevent.elapsed:1800);
                        elapsedsessions++;
                    }
                    if(exitdoc!=null)exitdoc.isExitDoc=true;
         
                    
                        if(bSlowSession)incrementMap(slowqueries,lastquery);
                        for(String term:lastquery.split(" ")){
                              if(bSlowSession){
                                    incrementMap(slowterms,term);
                              }else{
                                  if(!bQuickLinkSession){
                                      incrementMap(okterms,term);
                                  }
                              }
                            //if(!bQuickLinkSession) incrementMap(okqueries,lastquery);   
                        }
                    sessionid++;
                    sessioncount++;
                    bStart=true;
                    bQuickLinkSession=false;
                    bSearchSuggestionSession=false;
                    bSlowSession=false;
                    
                    sessionlinksclicked=0;
                    lastEID=event.eid;
                    sessionevents=new ArrayList();
                    lastquery="";
                    bHaveQuery=false;
                    lastevent=event;
                    
                    /*** Next Session End ***/ 
                }
            }//lastevent not null          
            //outdebug(out,""+sessionid);
            if(!bHaveQuery){
                if(!event.isSearchSuggestion && event.isClick ){
                    //outdebug(out,"continue");
                    continue;//ignore clicks without queries
                }else{
                    bHaveQuery=true;
                    start=event.timestamp.getTime();
                }
            }
            //outdebug(out,"haveQ");

            sessionevents.add(event); 
            if(event.isClick){
                if(event.isQuickLink){
                    if(sessionlinksclicked==0)bQuickLinkSession=true;  
                }else{
                    if(event.isSearchSuggestion){
                        bSearchSuggestionSession=true;
                    }else{
                        sessionlinksclicked++;
                        bQuickLinkSession=false;
                        bSearchSuggestionSession=false;
                    }
                }
            }
            if(!event.query.equals(""))lastquery=event.query.toLowerCase().trim();
            
            event.elapsed=(event.timestamp.getTime()-start)/1000;
            lastevent=event;
        }
          
       double slowpct=0.0;
       double avgelapsed=0.0;
       double qlpct=0.0;
       double sspct=0.0;
       if(sessioncount>0){
           slowpct=Math.round((slowsessions*1.0/sessioncount)*1000)/10; 
           qlpct=Math.round((qlsessions*1.0/sessioncount)*1000)/10;
           sspct=Math.round((suggestsessions*1.0/sessioncount)*1000)/10;
           avgelapsed=Math.round((elapsedtotal*1.0/elapsedsessions)*10)/10;
       } 
       try{
           out.println("<b>Total Sessions:</b>"+sessioncount+"<BR>");
           out.println("<b>QL Sessions:</b>"+qlsessions+" ("+qlpct+"%)<BR>");
           out.println("<b>Suggested Site Sessions:</b>"+suggestsessions+" ("+sspct+"%)<BR>");
           out.println("<b>Slow Sessions:</b>"+slowsessions+" ("+slowpct+"%)<BR>");
           out.println("<b>Total Elapsed:</b>"+elapsedtotal+" s. <BR>");
           out.println("<b>Average Elapsed:</b>"+avgelapsed+" s. <BR>");
            out.println("Since "+earliestTimestamp+"<br>");
        }catch(IOException ioe){
        }   
            
        if(!bStatsOnly){
            if( rows!=20000){
                outputSearchSessions(out,events,"");
            }else{
                outputQLEffectiveness(out,events);
            }
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