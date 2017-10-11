<%--
  ==============================================================================
  Draws the HTML head with some default content:
  - initialization of the WCM
  - includes the current design CSS
  - sets the HTML title
  
  ==============================================================================
--%> 

<%@page import="com.mcd.cq.util.search.SearchGroup,
                java.text.SimpleDateFormat,
                com.day.crx.*,
                com.day.cq.security.*,
                java.util.*, 
                com.day.cq.tagging.*,
                com.day.cq.commons.PathInfo" %>
<%@ page import="com.day.cq.wcm.api.WCMMode" %>
<%@include file="/apps/mcd/global/global.jsp" %>
<%@ page import="com.day.cq.commons.Doctype" %>
<script language=javascript>var timingstart=new Date();</script>
<%
    String xs = Doctype.isXHTML(request) ? "/" : "";
%>
<head>
 
<%
    //Judy added the following 
    String title = currentPage.getTitle();  
    if (title==null  || title.equals("")){
        title = "No Title";
    }       
 
    String metaDescription = currentPage.getDescription();
    if ((metaDescription == null) || metaDescription.equals("") ) {
        metaDescription = title;
    }

    String metaAuthor = currentPage.getLastModifiedBy();
    if ((metaAuthor == null) || metaAuthor.equals("") ) {
        metaAuthor = "[No Author Listed]";
    }
    
    String modDate="No Modified Date";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    if (currentPage.getLastModified() != null) {
        modDate = sdf.format(currentPage.getLastModified().getTime());
    } 
    
    String metaGroups = getAllGroup(currentNode);
    String tmpGroup=SearchGroup.searchGroup(metaGroups);

    String excluedpatterns=prop.getProperty("glob_pattern_allowed",""); 
    String domains=prop.getProperty("domain_allowed","");   
    String corpPath=prop.getProperty("corp","");
    String usaPath=prop.getProperty("us","");
    String jpPath=prop.getProperty("japan","");
    String ausPath=prop.getProperty("au","");
    String nzPath=prop.getProperty("nz",""); 
    String ca_enPath=prop.getProperty("canada_en","");
    String ca_frPath=prop.getProperty("canada_fr","");
    String ukPath=prop.getProperty("uk",""); 
    String frameTargetPage =  prop.getProperty("frame_target_page","");
    
    String quickPollUrl=prop.getProperty("quick_poll_url"); 
%>  

<script> 
    var thisPage = '<%=currentPage.getPath()%>';
    var designMode = '<% if (WCMMode.fromRequest(request) == WCMMode.DESIGN){ %> true <% }else{ %> false <% } %>';
    var editMode = '<% if (WCMMode.fromRequest(request) == WCMMode.EDIT){ %> true <% }else{ %> false <% } %>';
    var previewMode = '<% if (WCMMode.fromRequest(request) == WCMMode.PREVIEW){ %> true <% }else{ %> false <% } %>';
    var excluedpatterns = '<%=excluedpatterns%>';
    var domains = '<%=domains%>';
    var corpPath = '<%=corpPath%>';
    var usaPath = '<%=usaPath%>';
    var jpPath = '<%=jpPath%>';
    var ausPath = '<%=ausPath%>';
    var nzPath = '<%=nzPath%>';
    var ca_enPath = '<%=ca_enPath%>';
    var ca_frPath = '<%=ca_frPath%>';
    var ukPath = '<%=ukPath%>';
    var frameTargetPage = '<%=frameTargetPage%>';
</script>
    
    <meta name="description" content="<%= metaDescription %>" />
    <meta name="keywords" content="<%= WCMUtils.getKeywords(currentPage) %>" />
    <meta name="author" content="<%= metaAuthor %>" />
    <meta name="groupsType" content="<%= tmpGroup %>" />
    <meta name="modified" content="<%= modDate %>" />

    <meta http-equiv="content-type" content="text/html; charset=UTF-8"<%=xs%>>
    <meta http-equiv="keywords" content="<%= WCMUtils.getKeywords(currentPage) %>"<%=xs%>>
    
   
    
    <cq:include script="/apps/mcd/global/init.jsp"/> 
    <cq:include script="sitecolors.jsp"/> 
    <cq:include script="stats.jsp"/>
    
    <%
    String designPath = request.getContextPath() + currentDesign.getPath(); 
    String designLib = "";
    if (designPath.contains("/etc/designs/mcd/accessmcd/g2g")) {
        String designName = designPath.substring(31);
        designLib = "accessmcd." + designName;
    }
    %>
    
    <%-- YUI --%>
   <script src="/scripts/yui/build/yui/yui-min.js"></script>
    
     <%-- Combined include call for css and js clientlibs --%>
    <cq:includeClientLib categories="accessmcd.manager, accessmcd.core, accessmcd.components" />
    
      
    <% if (designPath.contains("/etc/designs/mcd/accessmcd/g2g")) { %>
        <cq:includeClientLib css="<%=designLib%>" />
    <% } %>  
  
    <script language=javascript> 
      
          redirect_Japan('<%=currentPage.getPath()%>','<%= jpPath %>');                
         <%String  selectors=null;
           boolean ignoreJapanPage=false; 
           try{
               String jp_path=jpPath;
              
               if(jp_path.contains("/content")){
                   jp_path.replace("/content","");
               }
               if(currentPage.getPath().contains(jp_path)){
                
                boolean initialize=true;
                String urlPath=request.getRequestURI().toString();
                PathInfo pInfo=new PathInfo(urlPath);
                selectors=pInfo.getSelectorString();
                if(selectors==null)
                {
                    ignoreJapanPage=true; 
                } 
               }
           }catch(Exception e){}
         %>

        if (!(<%= WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.EDIT || WCMMode.fromRequest(request) == WCMMode.PREVIEW %>) && (<%= ignoreJapanPage==false%>)  ) {   
               
               initialize('<%=currentPage.getPath()%>','<%=excluedpatterns%>','<%= domains %>','<%= corpPath %>','<%= usaPath %>','<%= jpPath %>','<%= ausPath %>','<%= nzPath %>','<%= ca_enPath %>','<%= ca_frPath %>','<%= ukPath %>','<%= frameTargetPage %>'); 
            
            }
            
    </script>
    
    <script language=javascript>         
    $(window).ready(    
    function(){       
        var timing=(new Date())-timingstart;
        var winlocation=window.location.href;
        var timingurl="<%=currentPage.getPath()%>.timing.html?timing="+timing+"&source="+escape(winlocation);
        $.get(timingurl);    
       
    });
    </script>
    
    <script type="text/javascript">
    function checkInternalLink(url) {
    
        <%String internalDomains="";%>
        var internal="false";
        if(url.indexOf("/")==0) {
            internal="true";
        } else {
            <% 
            try{
                internalDomains= prop.getProperty("domainNames");
            }catch(Exception e){}
            %>      
            
                var internalDomains="<%=internalDomains%>";
                var domainArr=new Array();
                domainArr=internalDomains.split(",");
               
                for(var i=0;i<domainArr.length;i++)
                {
                   if(url.indexOf("http://")==0)
                   {
 
                      if(url.indexOf(domainArr[i])==7){internal="true";break;}
                   }else if(url.indexOf("https://")==0)
                   {
                      if(url.indexOf(domainArr[i])==8){internal="true";break;}
                   }else if(url.indexOf(domainArr[i])==0)
                   {
                      internal="true";break;
                   }        
     
                
                }
        }
        return internal;
    } 
    </script>
    
<title><%= currentPage.getTitle() == null ? currentPage.getName() : currentPage.getTitle() %></title>
<link rel="stylesheet" type="text/css" href="/etc/designs/mcd/accessmcd/corelibs/core/css/printpreviewnew.css" media="all" /> 
<link rel="stylesheet" type="text/css" href="/etc/designs/mcd/accessmcd/corelibs/core/css/printnew.css" media="print" /> 
</head>