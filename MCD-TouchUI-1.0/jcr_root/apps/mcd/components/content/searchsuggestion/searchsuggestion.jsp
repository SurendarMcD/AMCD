<%--
  
  Site Suggestion component        
  
  For maintaining Search Suggestions within CQ
  
  When rendered w/globbing pattern, renders as JSON
  
  ex: [pagename].searchsuggestions.[rolecode].[typeahead characters].html
  
  Erik Wannebo 8/15/2013

--%><%@ page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat, 
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService,
    org.apache.commons.lang.StringEscapeUtils,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.WCMMode,
    org.apache.sling.api.resource.ResourceUtil,
    org.apache.sling.api.resource.ValueMap,
    com.day.image.Layer,
    com.day.cq.wcm.foundation.Download,
    com.day.text.Text,
    java.util.Random" %><%
%>
<%@include file="/apps/mcd/global/global.jsp"%>
<style>
.suggest{
 border: 1pt solid black;
 min-width:200px;
 max-width:200px;
 word-wrap:break-word;

}
</style> 
<%!

public String decodeAudience(String code){
if(code.equals("ce"))return "Employee";
if(code.equals("fe"))return "Franchisee";

if(code.equals("fo"))return "Franchisee Office Staff";

if(code.equals("fm"))return "Franchisee Restaurant Manager";

if(code.equals("rm"))return "McOpCo Manager";

if(code.equals("ag"))return "Agency";

if(code.equals("sv"))return "Supplier/Vendor";
return "";

}

%>

<%

String sitelink= properties.get("sitelink","");
String sitelinkurl="";
String category="Searches";
if(!sitelink.equals("")){
    category="Sites";
    if(sitelink.startsWith("/content/")){
        if(!sitelink.endsWith(".html")){
            sitelinkurl=sitelink+".html";
        }
    }
}
String suggestion= properties.get("suggestion","");
String[] keywords= (properties.containsKey("keywords"))? properties.get("keywords", String[].class) : null;
String strKeywords="";

if(keywords!=null){
    for(int i=0;i<keywords.length;i++){
        strKeywords+=(i>0?",":"")+keywords[i];
    }
}

String[] audience= (properties.containsKey("audience"))? properties.get("audience", String[].class) : null;
String strAudience="";

if(audience!=null){
    for(int i=0;i<audience.length;i++){
        strAudience+=(i>0?"<br>":"")+decodeAudience(audience[i]);
    }
}



if(suggestion.trim().equals("")){
%>
<b>PLEASE COMPLETE SUGGESTION DETAILS</b>
<%
}else{
%>
<table style="table-layout: fixed;"><tr>
<td  class="suggest"><b><%=suggestion %></b></td>
<%
if(!sitelink.equals("")){
%>
<td class="suggest" style="word-break: break-all;"><a href="<%=sitelinkurl %>" target="_new"><%=sitelink %></a></td>
<%
}
%>
<td class="suggest" ><%=strKeywords %></td>
<%
if(!strAudience.equals("")){
%>
<td class="suggest" style="word-break: break-all;"><font color="red"><%=strAudience%></font></td>
<%
}
%>
</tr></table>
<%
}
%>