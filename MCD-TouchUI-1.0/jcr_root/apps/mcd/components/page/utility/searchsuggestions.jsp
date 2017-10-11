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

<TITLE>AccessMCD Search Suggestions Maintenance</TITLE>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
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



private String td(String val){
    return "<TD>"+val+"</TD>";
}

private String td(String val,String bgcolor){
    return "<TD style='background-color:"+bgcolor+"'>"+val+"</TD>";
}



 public String getSuggestionForm(String mkt, String role, String language, String suggestions, String type) throws Exception 
    {
        String retString="";
        
        retString="<fieldset><legend>Search Suggestions</legend>";
        retString+="<FORM id=\"suggform\" name=\"suggform\" action=\"\" method=\"get\" accept-charset=\"UTF-8\">";
        retString+="<TABLE border = '0'>";
        retString+="<TR><TD><B>Suggestions:</B></TD><TD><TEXTAREA rows=5 cols=60 name=\"suggestions\">"+ suggestions+"</TEXTAREA></TD></TR>";
        retString+="<TR><TD><B>&nbsp;</B></TD><TD>Note: Please enter a '|'-delimited list of suggestions.</TD></TR>";
               
        retString+="<TR><TD><B>ROLE:</B></TD><TD><SELECT id=\"role\" NAME=\"role\">";
        retString+="<OPTION value=\"999\""+(role.equalsIgnoreCase("999") ? "selected" : "")+">ALL</OPTION>";
        retString+="<OPTION value=\"100\""+(role.equalsIgnoreCase("100") ? "selected" : "")+">CorpEmployees</OPTION>";
        retString+="<OPTION value=\"101\""+(role.equalsIgnoreCase("101") ? "selected" : "")+">McOpCoRestMgrs</OPTION>";
        retString+="<OPTION value=\"102\""+(role.equalsIgnoreCase("102") ? "selected" : "")+">Franchisees</OPTION>";
        retString+="<OPTION value=\"103\""+(role.equalsIgnoreCase("103") ? "selected" : "")+">FranchiseeRestMgrs</OPTION>";
        retString+="<OPTION value=\"104\""+(role.equalsIgnoreCase("104") ? "selected" : "")+">Crew</OPTION>";
        retString+="<OPTION value=\"105\""+(role.equalsIgnoreCase("105") ? "selected" : "")+">SupplierVendor</OPTION>";
        retString+="<OPTION value=\"106\""+(role.equalsIgnoreCase("106") ? "selected" : "")+">Agency</OPTION>";
        retString+="<OPTION value=\"107\""+(role.equalsIgnoreCase("107") ? "selected" : "")+">FranchiseeOfficeStaff</OPTION>";

        retString+="</SELECT></TD></TR>";

        retString+="<TR><TD><B>SEARCH MARKET:</B></TD><TD><SELECT id=\"mkt\" NAME=\"mkt\">";
        retString+="<OPTION value=\"corp\""+(mkt.equalsIgnoreCase("corp") ? "selected" : "")+">Global</OPTION>";
        retString+="<OPTION value=\"us\""+(mkt.equalsIgnoreCase("us") ? "selected" : "")+">US</OPTION>";          
        retString+="<OPTION value=\"mcweb\""+(mkt.equalsIgnoreCase("mcweb") ? "selected" : "")+">mcweb</OPTION>";          
        retString+="<OPTION value=\"canada_en\""+(mkt.equalsIgnoreCase("canada_en") ? "selected" : "")+">Canada English</OPTION>";
        retString+="<OPTION value=\"canada_fr\""+(mkt.equalsIgnoreCase("canada_fr") ? "selected" : "")+">Canada French</OPTION>";
        retString+="<OPTION value=\"au\""+(mkt.equalsIgnoreCase("au") ? "selected" : "")+">Australia</OPTION>";          
        retString+="<OPTION value=\"nz\""+(mkt.equalsIgnoreCase("nz") ? "selected" : "")+">New Zealand</OPTION>";          
        retString+="<OPTION value=\"viewerca\""+(mkt.equalsIgnoreCase("viewerca") ? "selected" : "")+">Viewer Canada - English</OPTION>";  
        retString+="<OPTION value=\"viewercafr\""+(mkt.equalsIgnoreCase("viewercafr") ? "selected" : "")+">Viewer Canada - French</OPTION>";  
        retString+="<OPTION value=\"vieweruk\""+(mkt.equalsIgnoreCase("vieweruk") ? "selected" : "")+">Viewer UK</OPTION>"; 
        retString+="<OPTION value=\"viewerrsg\""+(mkt.equalsIgnoreCase("viewerrsg") ? "selected" : "")+">Viewer RSG</OPTION>";
        retString+="<OPTION value=\"viewerus\""+(mkt.equalsIgnoreCase("viewerus") ? "selected" : "")+">Viewer US - English</OPTION>";  
        retString+="<OPTION value=\"viewerussp\""+(mkt.equalsIgnoreCase("viewerussp") ? "selected" : "")+">Viewer US - Spanish</OPTION>";  
 
        retString+="</SELECT></TD></TR>";

        retString+="<TR><TD><B>LANGUAGE:</B></TD><TD><SELECT id=\"language\" NAME=\"language\">";
        retString+="<OPTION value=\"en\""+(language.equalsIgnoreCase("en") ? "selected" : "")+">English</OPTION>";
        retString+="<OPTION value=\"fr\""+(language.equalsIgnoreCase("fr") ? "selected" : "")+">French</OPTION>";  
        retString+="<OPTION value=\"es\""+(language.equalsIgnoreCase("es") ? "selected" : "")+">Spanish</OPTION>";          
        retString+="</SELECT></TD></TR>";

               
        retString+="<TR><TD><B>ACTION:</B></TD><TD><SELECT name=\"pmACTION\" >";
        retString+="<OPTION value=\"view\""+(type.equalsIgnoreCase("view") ? "selected" : "")+">view suggestions</OPTION>";
        retString+="<OPTION value=\"add\""+(type.equalsIgnoreCase("add") ? "selected" : "")+">add suggestions</OPTION>";
        
        retString+="</SELECT></TD></TR>";

        retString+="</TR></TABLE>";
        retString+="<br><INPUT class='btn' type=\"submit\" value=\"SUBMIT\" /><br>";
        retString+="</FORM></fieldset><br><br>";
        
        return(retString);
    }


public void addSuggestions (javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String role, String suggestions, String language) throws IOException{

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
        
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String searchSuggestionInsertSql = "insert into SRCH.TBSRCH_HIST values (SEQ_SRCH_HIST.NEXTVAL,?,?,1,?,?,'Y','wc',SYSDATE,USER)";
try{ 
    pstmt = conn.prepareStatement(searchSuggestionInsertSql );
    
    StringTokenizer suggs= new StringTokenizer(suggestions,"|");
    while(suggs.hasMoreTokens()){
        String suggestion=suggs.nextToken();
        //out.println("Suggestion:"+suggestion);
        if(!suggestion.trim().equals("")){
            pstmt.setString(1,role);

            String convertedSuggestion=suggestion.trim().toLowerCase();
            pstmt.setString(2,convertedSuggestion);
    
            pstmt.setString(3,language);
            pstmt.setString(4,searchMkt);
            
            pstmt.executeUpdate();
            out.println("Added suggestion: "+suggestion.trim()+"<br>");
        }
    }
    
    conn.commit();
    } catch (SQLException sqle) {
            System.out.println("searchSuggestions:SQLException " + sqle);
            
    } catch (Exception e) {
            System.out.println("searchSuggestions:Exception " + e);
            
    }finally {
        try {

            closeStatement(pstmt);
            
            
        } catch (Exception e) {System.out.println("searchSuggestions:Exception closing");}
    } 
}

public void deleteSuggestion (javax.servlet.jsp.JspWriter out, Connection conn, String id) throws IOException{

        
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String searchSuggestionDeleteSql = "delete from SRCH.TBSRCH_HIST where srch_hist_seq_id = ?";
try{ 
    pstmt = conn.prepareStatement(searchSuggestionDeleteSql  );
    
    
    pstmt.setString(1,id);
    
    pstmt.executeUpdate();
    out.println("Removed suggestion: "+ id);

    
    conn.commit();
    } catch (SQLException sqle) {
            System.out.println("searchSuggestions:SQLException " + sqle);
            
    } catch (Exception e) {
            System.out.println("searchSuggestions:Exception " + e);
            
    }finally {
        try {

            closeStatement(pstmt);
            
            
        } catch (Exception e) {System.out.println("searchSuggestions:Exception closing");}
    }
}

public void displaySuggestionsReport(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String role ) throws IOException{


        
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    
    try{               
    
        String searchSuggestionSql = "select SRCH_HIST_SEQ_ID,SRCH_HIST_MKT_CD,SRCH_HIST_QT_TX,SRCH_ROLE_CD,SRCH_HIST_LANG_CD,SRCH_HIST_RANK_NU,SRCH_HIST_AUTO_FL,SRCH_HIST_TAB_CD,SRCH_HIST_TS,SRCH_HIST_MOD_ID "+
        "from SRCH.tbsrch_hist "+
        "where SRCH_HIST_MKT_CD = '"+searchMkt +"' ";
        if(!role.equals("") && !role.equals("999")){
            searchSuggestionSql+="and SRCH_ROLE_CD= '"+role +"' ";
        }
        searchSuggestionSql+="order by SRCH_HIST_QT_TX asc";

        //out.println(searchSuggestionSql);
        out.println("Search suggestions.<br>");
              
        out.println("<TABLE id='rawdata' class='tablesorter' >");
        out.println("<thead><tr style='font-weight:bold'>");
        out.println("<th>Seq ID</th>");
        out.println("<th>Market</th>");
        out.println("<th>Suggestion</th>");
        out.println("<th>Role</th>");
        out.println("<th>Language</th>");
        out.println("<th>Rank</th>");

        out.println("</tr></thead><tbody>");

        //out.println(searchLogSql);    
        pstmt = conn.prepareStatement(searchSuggestionSql);

        rs = pstmt.executeQuery();

        long count=0;
       
        out.println("start loop");
        
        while (rs.next()) {
            out.println("<tr>");
            out.println(td(rs.getString(1)));
            out.println(td(rs.getString(2)));
            out.println(td(rs.getString(3)));
            
            out.println(td(rs.getString(4)));
            out.println(td(rs.getString(5)));
            out.println(td(rs.getString(6)));
            
            out.println("</tr>");
           
        }
       
        
        out.println("</tbody></table>");
 
        
    } catch (SQLException sqle) {
            System.out.println("searchSuggestions:SQLException " + sqle);
            
    } catch (Exception e) {
            System.out.println("searchSuggestions:Exception " + e);
            
    }finally {
        try {

            closeStatement(pstmt);
            closeResultSet(rs);
            
            
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

out.println("encoding:"+cqReq.getCharacterEncoding()+"<br>");

if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    out.write("<a href='/libs/cq/core/content/login.html?resource=/content/utility/utility.searchsuggestions.html'>LOGIN HERE</a>");
    return;
}


try {
        //String suggestions=request.getParameter("suggestions");
        String suggestions= new String(request.getParameter("suggestions").getBytes("ISO-8859-1"), "UTF-8");
        String market=request.getParameter("mkt");
        String role=request.getParameter("role");
        String id=request.getParameter("id");
        String language=request.getParameter("language");
        
        String pmAction=request.getParameter("pmACTION");

        //wei added for call from the link
        String pmFlag=request.getParameter("FLAG");
        
        if(suggestions==null)suggestions="";
        //suggestions=new String(suggestions.getBytes("ISO-8859-1"));
        if(market==null)market="corp";
        if(role==null)role="999";
        if(language==null)language="en";
        if(pmAction==null)pmAction="view";
            
        String dbSourceName = "search";
        Connection conn = getConnection(sling, dbSourceName);
        response.setContentType("text/html;charset=UTF-8");
        
        out.write(getSuggestionForm(market,role,language,suggestions,pmAction ));
        
        if(pmAction.equals("view"))displaySuggestionsReport(out,conn,market,role);
        if(pmAction.equals("add"))addSuggestions(out,conn,market,role,suggestions,language);
        
        closeConnection(conn);

}catch(Exception e){
}
 
%>