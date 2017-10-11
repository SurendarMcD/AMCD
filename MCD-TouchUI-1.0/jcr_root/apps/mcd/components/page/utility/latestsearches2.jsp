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


public void displayReport(javax.servlet.jsp.JspWriter out,HttpServletRequest cqReq,org.apache.sling.api.scripting.SlingScriptHelper sling,boolean isAdmin)throws IOException{
    DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
 
    String searchMkt=cqReq.getParameter("searchMkt");
    String nbrTerms=cqReq.getParameter("nbrTerms");
 
    if(searchMkt==null)searchMkt="ALL";
    if(nbrTerms==null)nbrTerms="5";

    Connection conn = null;
    String dbSourceName = "search";
    conn = getConnection(sling, dbSourceName);
    
    displayLatestSearches(out, conn, searchMkt, nbrTerms);
                
    
    try{
        closeConnection(conn);
    }catch(Exception e){
        out.println("Exception closing connection:"+e.getMessage());
    }
   
}

         
public void displayLatestSearches(javax.servlet.jsp.JspWriter out, Connection conn, String searchMkt, String nbrTerms) throws IOException{

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    

    try{               
        String searchLogSql = "select srch_log_qt_tx from SRCH.tbsrch_log where srch_log_ts > (sysdate-1) ";
        searchLogSql += (searchMkt.equals("ALL")?"":"and srch_log_mkt_cd='"+searchMkt+"' ");
        searchLogSql += " order by srch_log_ts desc";
        
       
        
        //out.println("searchLogSql:"+searchLogSql+"<br>");   
        
        pstmt = conn.prepareStatement(searchLogSql);

        rs = pstmt.executeQuery();

        long count=0;
        long limit=Integer.parseInt(nbrTerms);

        /***** QUERIES *****/
        //out.println("start queries loop");
        while (rs.next()) {
            out.println(rs.getString(1));
            count++;
            if(count==limit)break;
       }
       
    }catch (Exception e) {
            out.println("searchReport:Exception " + e);
            
    }finally {
        try {

            closeStatement(pstmt);
            closeResultSet(rs);
            
        } catch (Exception e) {System.out.println("searchReport:Exception closing");}
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