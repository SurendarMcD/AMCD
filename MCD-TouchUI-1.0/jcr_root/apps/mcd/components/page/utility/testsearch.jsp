<%/*
Search test
Erik Wannebo 11/11/2011
*/
%>
<%@ page import="java.util.Calendar,
        java.text.SimpleDateFormat,
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
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean"%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<HTML>
<TITLE>Search Test</TITLE>
<head>

</head>
<body style="font-family:arial">
<h2>Search Test</h2>
<table>
<%
String[] terms={"us","2011","2010","europe","chicken","beef","hamburger","fries","mcdonalds","drive","restaurant","test"};
for(int i=0;i<20;i++){
    String query="/jcr:root/content/accessmcd//*[cq:tags ='"+terms[(int)Math.floor(terms.length*Math.random())]+"']";
    long startTime=System.currentTimeMillis();
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    out.print("<tr><td>"+query+"</td><td>time: "+(System.currentTimeMillis()-startTime)+"</td>");
    int count=0;
    while(result.hasNext()){result.next();count++;}
    out.print("<td>count="+count+"</td></tr>");
    }
//query="/jcr:root/content/accessmcd//*[cq:tags ='web']"; 
//startTime=System.currentTimeMillis();
//result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
//out.print(query+"<br>"+"time: "+(System.currentTimeMillis()-startTime)+"<BR>");
//count=0;
//while(result.hasNext()){result.next();count++;}
//out.print("count="+count+"<br>");
%>
</table>
