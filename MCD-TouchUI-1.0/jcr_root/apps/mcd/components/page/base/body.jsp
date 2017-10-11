<%--
  ==============================================================================
  Draws the HTML body with content:
  - includes topbar 
  - includes bottombar
  ==============================================================================
--%>
<%@ page import="com.day.cq.wcm.api.WCMMode" %><%
%> 

<%@include file="/apps/mcd/global/global.jsp"%>

<body>
    <div class="mainbody">

    <%-- To include site level properties component --%>
    <cq:include path="sitelevelproperties" resourceType="/apps/mcd/components/content/sitelevelproperties" /> 
    <cq:include script="additionalinfo.jsp" />
<%

       // Check for hideHeader
       String hideHeader = "";      
       
       Page thisPage = currentPage;
       
       // Read Root Node Level value from site level properties
       Node siteLevelNode = null;
       try{
            siteLevelNode = slingRequest.getResourceResolver().getResource(currentDesign.getPath()+"/jcr:content/base/sitelevelproperties").adaptTo(Node.class);
       }catch(Exception e) {}
       
       if(siteLevelNode!=null){
       int siteRootLevel = (siteLevelNode.hasProperty("siteRootLevel"))?Integer.parseInt(siteLevelNode.getProperty("siteRootLevel").getValue().getString()):1;
       
       do {
           ValueMap props = thisPage.getProperties();
           hideHeader = props.get("hideHeader","");

           if( (!hideHeader.equals("yes")) && (!hideHeader.equals("no")))  {
               thisPage = thisPage.getParent();
           } else {
               break;
           }
       } while( ((thisPage.getDepth())>siteRootLevel) && (thisPage != null) );
       }
      
       if(!hideHeader.equals("yes"))    {
%>         
               <cq:include script="topbar.jsp" />            
<%    
       }   
%>  

<%
        String homePages[] = prop.getProperty("cacheContent").split(",");
        boolean isHomePage = false;
      
        for(int i=0; i<homePages.length ; i++) {
            if( homePages[i].equals(currentPage.getPath()) ) {
                isHomePage = true;
                break;
            } 
        }
 
           if ( WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.EDIT || !isHomePage ) { 
%>               
               <div class="bottombar clear" >
                    <cq:include script="bottombar.jsp" /> 
               </div>           
       <% 
           } else { 
       %>
               <div class="bottombar clear" > </div> 
       
               <script>
                   
                   if(UserInfoObject == null){ 
                        var url = '<%=currentPage.getPath().replaceAll("/content/","/")%>.moreinfo.html?getdata=1';
                        $.ajax({
                            url: url,
                            type: 'GET',    
                            timeout: 120000, 
                            data: '', 
                            cache: true,   
                            error: function(){
                                  //  alert("Error during AJAX call while loading the body. Please try again");   
                            },    
                            success: function(xml){                                   
                                    UserInfoObject = eval('(' + xml + ')'); 
                                    
                                    //retrieve data from bottombar.jsp
                                    getPageContent('<%=currentPage.getPath().replaceAll("/content/","/")%>.bottombar.'+ UserInfoObject.mcdAudienceGlob +'.html', '.bottombar', 'Error during AJAX call while loading the body. Please try again') ;                                                
                                }
                        });                        
                    } else {  
                    
                        //retrieve data from bottombar.jsp
                        getPageContent('<%=currentPage.getPath().replaceAll("/content/","/")%>.bottombar.'+ UserInfoObject.mcdAudienceGlob +'.html', '.bottombar', 'Error during AJAX call while loading the body. Please try again') ; 
                             
                    }                     
                
               </script>  
         <%
            }            
          %>               
    </div>    
<%-- This function is being called here to avoid the operation aborted 
     error which is specific to some IE7 browsers. --%> 
<script>
    if (<%= WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.EDIT %>) {
        resetColctrlColor();
    }
    else {    
        resetColctrlHeight();
    }
    
    $(window).load(function() {
      getAwesomeHeader('<%=currentPage.getPath()%>','<%=currentDesign.getPath()%>');
    });    
    
    function setContent() {
        resetColctrlHeight();
    }
</script>      

 
<script>
    function getUserInfo()
    {    
        var aID ="UNKNOWN";
        var aRole ="UNKNOWN";
        var aCombo ="UNKNOWN_UNKNOWN";

        if(UserInfoObject == null){
                        var url = '<%=currentPage.getPath().replaceAll("/content/","/")%>.moreinfo.html?getdata=1';
                        $.ajax({
                            url: url,
                            type: 'GET',    
                            timeout: 6000, 
                            data: '', 
                            cache: true,   
                            error: function(){
                              //     _tag.DCSext.EID=aID;
                              //     _tag.DCSext.ROLE=aRole;
                              //     _tag.DCSext.COMBO=aCombo;
                              //     _tag.dcsCollect(); 
                            },    
                            success: function(xml){                                   
                                    UserInfoObject = eval('(' + xml + ')'); 
                                    if(UserInfoObject!=null){
                                        aID=UserInfoObject.uid;
                                        aRole=UserInfoObject.mcdAudience;
                                        aCombo= aID+"_"+aRole;
                                    }
                                   _tag.DCSext.EID=aID;
                                   _tag.DCSext.ROLE=aRole;
                                   _tag.DCSext.COMBO=aCombo;
                                   _tag.dcsCollect(); 
                            }
                        });                        
        
        }else{
             aID=UserInfoObject.uid;
             aRole=UserInfoObject.mcdAudience;
             aCombo= aID+"_"+aRole;
             _tag.DCSext.EID=aID;
             _tag.DCSext.ROLE=aRole;
             _tag.DCSext.COMBO=aCombo;
             _tag.dcsCollect(); 
        }
    }
    

</script>      







<!-- START OF SmartSource Data Collector TAG -->
<!-- Copyright (c) 1996-2009 WebTrends Inc.  All rights reserved. -->
<!-- Created: 4/07/2011 04:44:12 -->
<script src="https://www1.mcdonalds.com/metrics/internalcq5/webtrends.js" type="text/javascript"></script>     
<!-- ----------------------------------------------------------------------------------- -->
<!-- Warning: The two script blocks below must remain inline. Moving them to an external -->
<!-- JavaScript include file can cause serious problems with cross-domain tracking.      -->
<!-- ----------------------------------------------------------------------------------- -->
<script type="text/javascript">
//<![CDATA[
var _tag=new WebTrends();
_tag.dcsGetId();
//]]>>
</script>
<script type="text/javascript">
//<![CDATA[
// Add custom parameters here.
//_tag.DCSext.param_name=param_value;
getUserInfo();
//_tag.dcsCollect(); 
//]]>>
</script><noscript>
<div><img alt="DCSIMG" id="DCSIMG" width="1" height="1" src="https://statse.webtrendslive.com/dcsfjtxxtuz5bd31zrbgx7sqj_4b8u/njs.gif?dcsuri=/nojavascript&amp;WT.js=No&amp;WT.tv=8.6.1"/></div>
</noscript>
<!-- END OF SmartSource Data Collector TAG -->

 

</body>   


