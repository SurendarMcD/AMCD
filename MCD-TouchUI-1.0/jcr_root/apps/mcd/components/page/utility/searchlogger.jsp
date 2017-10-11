<%/*
Search Suggestion Click Logger
Logs clicks on Enhanced Search Suggested Sites (awesomebar Search drop down)
Erik Wannebo 09/24/2013    
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
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
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

public void logSuggestionClick (Connection conn, String searchMkt, String role, String query, String url, String eid) throws IOException{

    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
        
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String searchClickInsertSql = "insert into SRCH.TBSRCH_CLICK values (SEQ_SRCH_CLICK.NEXTVAL,?,?,1,?,SYSDATE)";
try{ 
    pstmt = conn.prepareStatement(searchClickInsertSql );
    pstmt.setString(1,eid);
    pstmt.setString(2,"ss | "+ searchMkt+" | "+role+" | "+ query);
    pstmt.setString(3,url);
    pstmt.executeUpdate();
    
    conn.commit();
    } catch (SQLException sqle) {
            System.out.println("logSuggestionClick: Exception " + sqle);
            
    } catch (Exception e) {
            System.out.println("logSuggestionClick: Exception " + e);
            
    }finally {
        try {
            closeStatement(pstmt);
        } catch (Exception e) {System.out.println("logSuggestionClick: Exception closing");}
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
HttpServletRequest cqReq = request;

String eid=slingRequest.getUserPrincipal().getName();

try {
        String query=request.getParameter("query");
        String market=request.getParameter("mkt");
        String role=request.getParameter("role");
        String url=request.getParameter("url");
        
        
        if(query==null)query="";
        if(market==null)market="corp";
        if(role==null)role="";
        if(url==null)url="";
  
            
        String dbSourceName = "search";
        Connection conn = getConnection(sling, dbSourceName);
        response.setContentType("text/html;charset=UTF-8");
        
        logSuggestionClick(conn, market,role,query,url, eid);
        
        closeConnection(conn);

}catch(Exception e){
}
 
%>