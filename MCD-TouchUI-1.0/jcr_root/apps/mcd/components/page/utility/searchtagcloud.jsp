<%/*
Search Tag Cloud - Creates a tag cloud from top Search Log queries
Erik Wannebo 04/20/2012
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
        java.sql.*   ,
        javax.sql.DataSource,
        com.day.commons.datasource.poolservice.DataSourcePool
        
        "%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<HTML>
<TITLE>Search Term Tag Cloud</TITLE>
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
<script type="text/javascript" language="Javascript" src="/scripts/jquery.tagcloud.0.5.0.min.js"></script>
<script language="javascript" src="/scripts/jquery-ui-1.7.2.datepicker.min.js" ></SCRIPT>
<script language=Javascript>
jQuery.fn.sortElements = (function(){
 
    var sort = [].sort;
 
    return function(comparator, getSortable) {
 
        getSortable = getSortable || function(){return this;};
 
        var placements = this.map(function(){
 
            var sortElement = getSortable.call(this),
                parentNode = sortElement.parentNode,
 
                // Since the element itself will change position, we have
                // to have some way of storing its original position in
                // the DOM. The easiest way is to have a 'flag' node:
                nextSibling = parentNode.insertBefore(
                    document.createTextNode(''),
                    sortElement.nextSibling
                );
 
            return function() {
 
                if (parentNode === this) {
                    throw new Error(
                        "You can't sort elements if any one is a descendant of another."
                    );
                }
 
                // Insert before flag:
                parentNode.insertBefore(this, nextSibling);
                // Remove flag:
                parentNode.removeChild(nextSibling);
 
            };
 
        });
 
        return sort.call(this, comparator).each(function(i){
            placements[i].call(getSortable.call(this));
        });
 
    };
 
})();

</script>
</head>
<body style="font-family:arial">
<%!

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

public class byValueComparator implements Comparator {
  Map base_map;
    
  public byValueComparator(Map base_map) {
    this.base_map = base_map;
  }
    
  public int compare(Object arg0, Object arg1) {
    if(!base_map.containsKey(arg0) || !base_map.containsKey(arg1)) {
      return 0;
    }
    
    if(((Integer)base_map.get(arg0)).intValue() < ((Integer)base_map.get(arg1)).intValue()) {
      return 1;
    } else if(((Integer)base_map.get(arg0)).intValue()== ((Integer)base_map.get(arg1)).intValue()) {
      return 0;
    } else {
      return -1;
    }
  }
}



private String td(String val){
    return "<TD>"+val+"</TD>";
}

public void displayForm(javax.servlet.jsp.JspWriter out,HttpServletRequest cqReq)throws IOException{
    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
 
    String searchMkt=cqReq.getParameter("searchMkt");
    String startDate=cqReq.getParameter("startDate");
    String endDate=cqReq.getParameter("endDate");
    boolean bIncludeRole=false;
    if(cqReq.getParameter("bIncludeRole")!=null)bIncludeRole=true;
    boolean bArchive=false;
    if(cqReq.getParameter("bArchive")!=null)bArchive=true;    
    String nbrTerms="";
    if(cqReq.getParameter("nbrTerms")!=null)nbrTerms=cqReq.getParameter("nbrTerms");
    
    if(searchMkt==null)searchMkt="corp";
    
    if(startDate==null || endDate==null){
        java.util.Date endingDate = new java.util.Date();
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(endingDate);
        gc.add(Calendar.DAY_OF_YEAR, -7);
        java.util.Date startingDate = gc.getTime(); 
            startDate = dateFormat.format(startingDate);
        endDate = dateFormat.format(endingDate);
    }
    
    out.println("<h2 style=\"font-family: Arial;\">Search Term Tag Cloud: "+startDate+" - "+endDate+"</h2><br>");
    out.println("Search queries appearing 5 or more times during report period. Queries are lower-cased before being logged.<br><br>");

    out.println("<FORM name=\"pciquery\" action=\"\" method=\"GET\">");


    out.println("<B>Search Market:</B><SELECT name=\"searchMkt\" >");
    out.println("<OPTION value=\"corp\" "+ (searchMkt.equals("corp")?"SELECTED":"")+">Global</OPTION>");
    out.println("<OPTION value=\"us\" "+ (searchMkt.equals("us")?"SELECTED":"")+">US</OPTION>");
    out.println("<OPTION value=\"au\" "+ (searchMkt.equals("au")?"SELECTED":"")+">Australia</OPTION>");
    out.println("<OPTION value=\"japan\" "+ (searchMkt.equals("japan")?"SELECTED":"")+">Japan</OPTION>");
    out.println("<OPTION value=\"mcweb\" "+ (searchMkt.equals("mcweb")?"SELECTED":"")+">McWeb</OPTION>");
    out.println("</SELECT>");
    
    //out.println("<b>By Role</b><INPUT type=checkbox name=\"bIncludeRole\" "+ (bIncludeRole?"CHECKED":"")+">");
    
    out.println("<B>Number of Terms:</B><SELECT name=\"nbrTerms\" >");
    out.println("<OPTION value=\"10\" "+ (nbrTerms.equals("10")?"SELECTED":"")+">10</OPTION>");
    out.println("<OPTION value=\"25\" "+ (nbrTerms.equals("25")?"SELECTED":"")+">25</OPTION>");
    out.println("<OPTION value=\"50\" "+ (nbrTerms.equals("50")?"SELECTED":"")+">50</OPTION>");
    out.println("<OPTION value=\"100\" "+ (nbrTerms.equals("100")?"SELECTED":"")+">100</OPTION>");
    out.println("</SELECT>");
    out.println("<br>");
    out.println("<B>Start Date:</B><INPUT type=\"text\" id=\"startDate\" name=\"startDate\" value=\""+startDate+"\">");
    out.println("<B>End Date:</B><INPUT type=\"text\"  id=\"endDate\" name=\"endDate\"  value=\""+endDate+"\">");
    
    out.println("<b>Use Archive</b><INPUT type=checkbox name=\"bArchive\" "+ (bArchive?"CHECKED":"")+"> (>90 days)");
    out.println("<br>");
 
    out.println("<INPUT TYPE=SUBMIT value=\"Get Tag Cloud\">");
        
    out.println("</FORM><BR>");

    

}

public void getSearchReport(javax.servlet.jsp.JspWriter out,HttpServletRequest cqReq,org.apache.sling.api.scripting.SlingScriptHelper sling) throws IOException{

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
 
    String searchMkt=cqReq.getParameter("searchMkt");
    String startDate=cqReq.getParameter("startDate");
    String endDate=cqReq.getParameter("endDate");
    boolean bIncludeRole=false;
    if(cqReq.getParameter("bIncludeRole")!=null)bIncludeRole=true;
    boolean bArchive=false;
    if(cqReq.getParameter("bArchive")!=null)bArchive=true;
    String nbrTerms="";
    if(cqReq.getParameter("nbrTerms")!=null)nbrTerms=cqReq.getParameter("nbrTerms");   
     
    if(searchMkt==null)searchMkt="corp";
    
    if(startDate==null || endDate==null){
        java.util.Date endingDate = new java.util.Date();
        GregorianCalendar gc = new GregorianCalendar();
        gc.setTime(endingDate);
        gc.add(Calendar.DAY_OF_YEAR, -7);
        java.util.Date startingDate = gc.getTime(); 
            startDate = dateFormat.format(startingDate);
        endDate = dateFormat.format(endingDate);
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    if(searchMkt==null)searchMkt="corp";
        
    try{        
        //out.println("<TABLE id='rawdata' class='tablesorter'>");
        //out.println("<thead><tr style='font-weight:bold'>");
        //if(bIncludeRole)out.println("<th>Role</th>");
        //out.println("<th>Search Query</th>");
        //out.println("<th>Searches</th>");
        //out.println("</tr></thead><tbody>");
        
        
        String dbSourceName = "search";
        conn = getConnection(sling, dbSourceName);

        String searchTermSql = "select * from (select srch_log_qt_tx,count(*),srch_log_mkt_cd,srch_log_lang_cd " +
        "from SRCH.tbsrch_log "+
        "where srch_log_ts > TO_DATE('"+startDate+"','MM/dd/yyyy') "+
        "and TRUNC(srch_log_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
        "and srch_log_mkt_cd='"+searchMkt+"' "+ 
        "group by srch_log_qt_tx,srch_log_mkt_cd,srch_log_lang_cd "+
        "having count(*)>4 order by count(*) desc) where rownum<="+nbrTerms;
        
         if(bArchive){
        searchTermSql = "select * from (select srch_log_qt_tx,count(*),srch_log_mkt_cd,srch_log_lang_cd " +
        "from SRCH.tbsrch_log_arch "+
        "where srch_log_ts > TO_DATE('"+startDate+"','MM/dd/yyyy') "+
        "and TRUNC(srch_log_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
        "and srch_log_mkt_cd='"+searchMkt+"' "+ 
        "group by srch_log_qt_tx,srch_log_mkt_cd,srch_log_lang_cd "+
        "having count(*)>4 order by count(*) desc) where rownum<="+nbrTerms;
        }
        
        if(bIncludeRole){
        searchTermSql = "select SRCH.tbsrch_role.SRCH_ROLE_DS,srch_log_qt_tx,count(*),srch_log_mkt_cd,srch_log_lang_cd " +
        "from SRCH.tbsrch_log, SRCH.tbsrch_role "+
        "where srch_log_ts > TO_DATE('"+startDate+"','MM/dd/yyyy') "+
        "and TRUNC(srch_log_ts) <= TO_DATE('"+endDate+"','MM/dd/yyyy') "+
        "and srch_log_mkt_cd='"+searchMkt+"' "+ 
        "and SRCH.tbsrch_role.srch_role_cd=SRCH.tbsrch_log.SRCH_ROLE_CD "+
        "group by SRCH.tbsrch_role.SRCH_ROLE_DS,srch_log_qt_tx,srch_log_mkt_cd,srch_log_lang_cd "+
        "having count(*)>4 order by count(*) desc"; 
        }
        //out.println(searchTermSql+"<br>");            
        pstmt = conn.prepareStatement(searchTermSql);
        rs = pstmt.executeQuery();
        String searchterm="";
        String role="";
        String searchcount="";
        long count=0;
        out.println("<ul id='tagcloud' style='width:600px'>");
        while (rs.next()) {
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
                out.println("<li value='"+searchcount+"' title='"+searchterm+"'><a href='https://search.accessmcd.com/mcdSearch/Search?mkt="+searchMkt+"&qt="+searchterm.replaceAll(" ","%20")+"'>"+searchterm+"</a></li>");
                //if(bIncludeRole)out.println("<td>"+role+"</td>");
                //out.println("<td>"+searchterm+"</td>");
                //out.println("<td>"+searchcount+"</td>");
                //out.println("</tr>");
            }
            count++;
            //if(bTopHundred && count==100)break;
        }
        out.println("</ul>");
                
        
    } catch (SQLException sqle) {
            System.out.println("searchReport:SQLException " + sqle);
            
    } catch (Exception e) {
            System.out.println("searchReport:Exception " + e);
            
    }finally {
        try {
            //if(pstmt != null) pstmt.close();
            //if(rs != null) rs.close();
            //if(conn != null) conn.close();
            closeStatement(pstmt);
            closeResultSet(rs);
            closeConnection(conn);
        } catch (Exception e) {System.out.println("searchReport:Exception closing");}
    }
    return;
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
HttpServletRequest cqReq = request;
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    out.write("<a href='/libs/cq/core/content/login.html?resource=/content/utility/utility.usermaintenance.html'>LOGIN HERE</a>");
    return;
}

response.setContentType("text/html;charset=UTF-8");
displayForm(out,cqReq);
getSearchReport(out,cqReq,sling);

boolean bIncludeRole=false;
if(cqReq.getParameter("bIncludeRole")!=null)bIncludeRole=true;
String tbsortcolumn="1";
if(bIncludeRole)tbsortcolumn="2";

%>

<script language="javascript">
function showcloud(cloudtype){
$("#tagcloud").tagcloud({type: cloudtype,sizemin:10,sizemax:40,colormin:"00B"});
    $("#tagcloud li").sortElements(function(a, b){
    return $(a).text() > $(b).text() ? 1 : -1;
});
}


    
$(document).ready(function(){
    $("#startDate").datepicker();
    $("#endDate").datepicker();
    //$("#rawdata").tablesorter({sortList: [[<%=tbsortcolumn %>,1]]}); 
    showcloud("list");

    //$("#tagcloud").before($("<a href='#'>sphere</a>").click(function(){showcloud('sphere')}));
    //$("#tagcloud").before($("<span> </span>")).before($("<a href='#'>cloud</a>").click(function(){showcloud('cloud')}));
    //$("#tagcloud")..before($("<span></span>")).before($("<a href='#'>list</a>").click(function(){showcloud('list')}));
    
    });

</script> 