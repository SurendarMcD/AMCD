<%@ page import="com.day.commons.datasource.poolservice.DataSourceNotFoundException" %> 
<%@ page import="com.day.commons.datasource.poolservice.DataSourcePool" %> 
<%@ page import="javax.sql.DataSource" %> 
<%@ page import="java.sql.Connection" %> 
<%@ page import="java.sql.SQLException" %> 
<%@ page import="java.sql.Statement" %> 
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.ResultSetMetaData" %> 
<%@include file="/libs/foundation/global.jsp" %>
  
<h1>DB Test</h1> 
<%   
    final DataSourcePool dbService = sling.getService(DataSourcePool.class); 
    try { 
        final DataSource dataSource = (DataSource)dbService.getDataSource("mySitesDSN"); 
        //final DataSource dataSource = (DataSource)dbService.getDataSource("gcddbpool"); 
        out.println("Data Source Object :::: " + dataSource + "<br>");
        try { 
            out.println("Connection :::: " );     
            final Connection connection = dataSource.getConnection(); 
            out.println("Connection :::: " + connection + "<br>");     
            final Statement statement = connection.createStatement(); 


                
    
        } catch (SQLException e) { 
            out.println(e);     
        } 
    } catch (DataSourceNotFoundException e) { 
        out.println(e.getMessage());
        out.println(e);   
    }   finally{
     }
%> 
  