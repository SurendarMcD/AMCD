<%-- #####################################################################################
# DESCRIPTION:  IFrame Component is to open up any web URL (external & internal) inside its body
#
# Author: HCL 
# Environment: 
# 
# INTERFACE 
# Controller: 
# Targets: 
# Inputs:global.jsp
#                    
# Outputs:      
# 
# UPDATE HISTORY       
# 1.0  HCL, 15-02-2010, Initial Version 
# 
# Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
########################################################################################--%>

<%@ page import="java.net.URLEncoder,java.net.URLDecoder,
    java.util.Enumeration" %><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%>

<%
    // Declarations of variables
    String frameName = "frame".concat(currentNode.getName()); 
    String targetURL = null;
    String frameHeight = null;
    String frameWidth = null;
    String showScroll=null;
    String bottomPadding = properties.get("btmpadding","");
    if(!"".equals(bottomPadding))
    {
        bottomPadding = "padding-bottom:" + bottomPadding + "px;";
    }
    
    // Set error msg text from language resource bundle
    String errorMsg = "iFrame_Error_Msg"; 
     
%>

<%
//check for Search shortcuts
//Erik Wannebo 5-2-12  (put in common_g2g.js instead)
/*
if((null != request.getParameter("qt")) && (null != request.getParameter("mkt")) && (null == request.getParameter("SearchSiteURL"))){
    String searchShortcut=SearchShortcut.findShortcut(request.getParameter("mkt"),request.getParameter("qt"));
    if(searchShortcut!=null){
        response.sendRedirect(searchShortcut);
        return;
    }
}
*/

//retrieve values from dialog
frameHeight = properties.get("height","500");
frameWidth = properties.get("width","100%");
showScroll = properties.get("showscroll","no");
targetURL = properties.get("targeturl","");

if(targetURL.equals(" ") ) 
{
  if(null != request.getParameter("frameTarget")){
        targetURL = request.getParameter("frameTarget"); 
        
        if(null != request.getParameter("view")){
            targetURL = targetURL + "?view="+request.getParameter("view");
        }
  }      
}
if(!"".equals(targetURL)){
    
    if(targetURL.startsWith("/content/") && targetURL.indexOf(".html") == -1){
        targetURL = targetURL +".html";
     }
    String param1 = "";
    String param2 = "";
    String param3 = "";
    String param4 = "";
    String param5 = "";
    String param6 = "";
    String param7 = "";
    String param8 = "";
    String param9 = "";
    String param10 = "";
    String param11 = "";
    
    if(null != request.getParameter("queryText"))
        param1 = request.getParameter("queryText"); 
   
    if(null != request.getParameter("collection"))
        param2 = request.getParameter("collection"); 
    
    if(null != request.getParameter("primaryCity"))
        param3 = request.getParameter("primaryCity");
    
    if(null != request.getParameter("postalCode"))
        param4 = request.getParameter("postalCode");
    
    if(null != request.getParameter("country"))
        param5 = request.getParameter("country"); 
    
    if(null != request.getParameter("RMURL"))
        param6 = request.getParameter("RMURL");
    
    if(targetURL.contains("navigate.do?link"))
        param7 = "src";
        
    if(null != request.getParameter("search"))
        param8 = request.getParameter("search");
        
    if(null != request.getParameter("qt"))
       {
        param9 =request.getParameter("qt");
       }   
    if(null != request.getParameter("BASIC_SEARCH_COUNTRY"))
        param10 = request.getParameter("BASIC_SEARCH_COUNTRY");
    
    if(null != request.getParameter("vpHandle"))
        param11 = request.getParameter("vpHandle");
    
        
    String height = frameHeight.indexOf("%") == -1 ? (frameHeight.trim()) + "px" : frameHeight.trim();
    String width = frameWidth.indexOf("%") == -1 ? (frameWidth.trim()) + "px" : frameWidth.trim();  
    
    String searchType = "simpleSearch=true&advancedSearch=false&fileFormat=any&numResults=10&queryText="+ URLEncoder.encode(param1,"UTF-8");
    if(param8.equals("advanced"))
    {
        searchType = "simpleSearch=false&advancedSearch=true&fileFormat=any&numResults=10&anyWords="+ URLEncoder.encode(param1,"UTF-8");
    }
    
    if( !("".equals(param1) && "".equals(param2)) )
        targetURL += "?sort=rel&" + searchType + "&collection=" + param2;
    else if( !("".equals(param3) && "".equals(param4) && "".equals(param5) ) )
        targetURL += "?method=search&primaryCity="+ URLEncoder.encode(param3,"UTF-8") + "&postalCode=" + URLEncoder.encode(param4,"UTF-8") +"&country="+param5;
    else if( !("".equals(param6)) )
        targetURL += "?RMURL="+param6;
    else if(!"".equals(param9)){
     //  out.println("hello : " + param9 + "decoded : " + URLDecoder.decode(param9,"UTF-8") + "Encoded : " + URLEncoder.encode(param9,"UTF-8"));
        String lang = request.getParameter("la");
        String ParameterNames = "";  
        String ParameterValues = "";                  
        int count = 0;
        Enumeration e = null;
        for(e = request.getParameterNames(); e.hasMoreElements(); ){
            ParameterNames = (String)e.nextElement();
            ParameterValues = request.getParameter(ParameterNames);     
            if(ParameterValues==null)
                ParameterValues = "";
           if(ParameterNames.equals("qt") && lang.equals("ja"))
            {
            }
            else
            {  
            
             if(count==0){
                targetURL+="?"+ ParameterNames  + "=" + URLEncoder.encode(ParameterValues,"UTF-8");            
             }       
             else{
                targetURL+="&" + ParameterNames + "=" + ParameterValues;
             }
              count++;
          }       
           
        }
        
    }
    else if(!"".equals(param10)){
        String ParameterNames = "";
        String ParameterValues = "";                
        int count = 0;
        Enumeration e = null;
        for(e = request.getParameterNames(); e.hasMoreElements(); ){
            ParameterNames = (String)e.nextElement();
            ParameterValues = request.getParameter(ParameterNames);     
            if(ParameterValues==null)
                ParameterValues = "";
            if(count==0){
                targetURL+="?"+ ParameterNames  + "=" + ParameterValues;           
            }       
            else{
                targetURL+="&" + ParameterNames + "=" + ParameterValues;
            }       
            count++;
        }
    }
    else if(!"".equals(param11)){
        String ParameterNames = "";
        String ParameterValues = "";                
        int count = 0;
        Enumeration e = null;
        for(e = request.getParameterNames(); e.hasMoreElements(); ){
            ParameterNames = (String)e.nextElement();
            ParameterValues = request.getParameter(ParameterNames);     
            if(ParameterValues==null)
                ParameterValues = "";
                            
            if(count==0){
                targetURL+="?"+ ParameterNames  + "=" + ParameterValues;           
            }       
            else{
                targetURL+="&" + ParameterNames + "=" + ParameterValues;
            }   
                
            count++;
        }
    }
    
    if(request.getParameter("encoding")!=null){
    if(request.getParameter("encoding").equalsIgnoreCase("true")){
        String ParameterNames = "";
        String ParameterValues = "";                
        int count = 0;
        if( targetURL.contains("?")){ targetURL= targetURL.substring(0, targetURL.indexOf("?"));}
        Enumeration e = null;
        for(e = request.getParameterNames(); e.hasMoreElements(); ){
            ParameterNames = (String)e.nextElement();
            ParameterValues = request.getParameter(ParameterNames);     
            if(ParameterValues==null)
                ParameterValues = "";
            if(count==0){
                targetURL+="?"+ ParameterNames  + "=" + URLEncoder.encode(ParameterValues,"UTF-8");           
            }       
            else{
                targetURL+="&" + ParameterNames + "=" + URLEncoder.encode(ParameterValues,"UTF-8");
            }       
            count++;
        }
    }
    }
    
      //  out.println("URL :" + targetURL);
%>
      <input type="hidden" id="parameter1" value="<%= param1 %>"/>
      <input type="hidden" id="parameter2" value="<%= param2 %>"/>
      <input type="hidden" id="parameter3" value="<%= param3 %>"/>
      <input type="hidden" id="parameter4" value="<%= param4 %>"/>
      <input type="hidden" id="parameter5" value="<%= param5 %>"/>
      <input type="hidden" id="parameter6" value="<%= param6 %>"/>
      <input type="hidden" id="parameter7" value="<%= param7 %>"/>
      <input type="hidden" id="parameter9" value="<%= param9 %>"/>
      <input type="hidden" id="parameter10" value="<%= param10 %>"/>
      <input type="hidden" id="parameter11" value="<%= param11 %>"/>

        <section class="iframe-box">
            <div class="">
                <div class="embed-responsive embed-responsive-16by9">
                    <iframe id="<%= frameName %>" name="<%= frameName %>" frameborder="0" scrolling="<%=showScroll%>" class="embed-responsive-item"></iframe>
                </div>
            </div>
        </section>
    <script>
    
    function getParameterByName(name) {   name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");   var regexS = "[\\?&]" + name + "=([^&#]*)";   var regex = new RegExp(regexS);   var results = regex.exec(window.location.search);   if(results == null)     return "";   else     return decodeURIComponent(results[1].replace(/\+/g, " ")); } 
    
    var frameId = "<%=frameName%>";
    var target = "<%=targetURL%>";
    var iframe = document.getElementById(frameId);
    var param1 = document.getElementById('parameter1');
    var param2 = document.getElementById('parameter2');
    var param3 = document.getElementById('parameter3');
    var param4 = document.getElementById('parameter4');
    var param5 = document.getElementById('parameter5');
    var param6 = document.getElementById('parameter6');
    var param7 = document.getElementById('parameter7');
    var param9 = document.getElementById('parameter9');
    var param10 = document.getElementById('parameter10');
    var param11 = document.getElementById('parameter11');
  //  alert(param9.value + getParameterByName('qt'));
    
    if( !(""==(param1.value) && ""==(param2.value) && ""==(param7.value)) )
       iframe.src = '<%= targetURL %>'+'&src='+window.location.host;
    else if( !(""==(param3.value) && ""==(param4.value) && ""==(param5.value) ))
        iframe.src = '<%= targetURL %>'+'&src='+window.location.host;  
    else if( !(""==param6.value) )
        iframe.src = '<%= targetURL %>';
    else if( target.indexOf("/subscribe/subscribe.jsp")!=-1 )
        iframe.src = '<%= targetURL %>'+'?src='+window.location.host; 
    else if(!(""==param9.value))
        {
         var target = '<%= targetURL %>';
         
        if(getParameterByName('la') == 'ja')
        {
         target = target + '&qt=' +  encodeURIComponent(getParameterByName('qt'));
          iframe.src = target;
        }
        else
         { 
          iframe.src = '<%= targetURL %>';
         }
        
           
        }
    else if(!(""==param10.value))
        iframe.src= '<%= targetURL %>'; 
    else if(!(""==param11.value))
        iframe.src= '<%= targetURL %>';        
    else{
        iframe.src = '<%= targetURL %>';
    }    
       
    function updateIFrame( height ) 
    {
            var frameId = "<%=frameName%>";
        var iframe = document.getElementById( frameId );
        iframe.setAttribute( 'height', height );
    }
    
    </script>
<%
} 
else{
%>
     <%=langText.get("IFrame Component: Please provide the value for target URL.")%>
   
<%
}

%>
   <div class="module_spacing" style="<%=bottomPadding%>"></div> 
   <div class="clear"></div>         