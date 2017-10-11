<%/*
SQL test
Erik Wannebo 03/28/2016 
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
<TITLE>SQL test</TITLE>
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



public void runTest(javax.servlet.jsp.JspWriter out,HttpServletRequest cqReq,org.apache.sling.api.scripting.SlingScriptHelper sling)throws IOException{

 
    String datasource=cqReq.getParameter("datasource");
    if(datasource==null)datasource="search";
    
    
    out.println("<h2 style=\"font-family: Arial;\">SQL Test</h2><br>");
    
    out.println("datasource:"+datasource+"<br>");
    
    Connection conn = null;
    conn = getConnection(sling, datasource);
    
    String sql="";
    String sqlbase="select * from SRCH.tbsrch_log where SRCH_LOG_SEQ_ID=";
    
    long starttime=System.currentTimeMillis();
    for(int i=0;i<10;i++){
        int param=(int)Math.floor(Math.random()*1000);
        sql=sqlbase+param;
        testSQL(out,conn,sql);
    }
    long exectime=System.currentTimeMillis()-starttime;
    out.println("Finished all scripts in "+exectime+" ms.");
    
        try{
            closeConnection(conn);
        }catch(Exception e){
            out.println("Exception closing connection:"+e.getMessage());
        }

   
}

public void testSQL(javax.servlet.jsp.JspWriter out, Connection conn, String sql) throws IOException{
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try{   
        out.println("Executing "+sql+"<br>");
        long starttime=System.currentTimeMillis();
        pstmt=conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        long exectime=System.currentTimeMillis()-starttime;
        out.println("Finished in "+exectime+" ms.<br>");
         
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

runTest(out,cqReq,sling);

%>