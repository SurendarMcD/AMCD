<%--
  ==============================================================================
  Draws the HTML body with content:
  - includes header
  - includes topbar
  - includes bottombar
  ==============================================================================
--%>
<%@ page import="java.util.*, 
        java.io.*,
        javax.servlet.*,
        javax.servlet.http.*,
        com.mcd.accessmcd.util.CommonUtil,
        com.day.cq.security.User,  
        com.day.cq.wcm.api.WCMMode" %><%
%>
<%@include file="/apps/mcd/global/global.jsp"%> 
<%
    String gaCode=prop.getProperty("gaCode","");
%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<cq:includeClientLib css="accessmcd.responsivecss" />
<!--[if lt IE 9]>
    <script src="/etc/designs/mcd/accessmcd/corelibs/responsivecss/js/html5shiv.js" type="text/javascript"></script>
    <script src="/etc/designs/mcd/accessmcd/corelibs/responsivecss/js/respond.min.js" type="text/javascript"></script>    
<![endif]-->

<body>
<%
    if(!currentPage.getPath().startsWith("/content/accessmcd/mcd/mysites")){
%> 
        <!-- Google Tag Manager -->
        <noscript><iframe src="//www.googletagmanager.com/ns.html?id=<%=gaCode%>"
        height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
        <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        })(window,document,'script','dataLayer','<%=gaCode%>');</script>
        <!-- End Google Tag Manager -->

<%
    }
%>
    <div class="mainBody">  
    <%-- To include site level properties component --%>
    <cq:include path="sitelevelproperties" resourceType="/apps/mcd/components/content/sitelevelproperties" />
    <cq:include script="additionalinfo.jsp" /> 
    
    
    <% 
       String hideHeaderParam = request.getParameter("hideHeaderParam");
             
       // Check for hideHeader
       String hideHeader = "";      

       Page thisPage = currentPage; 
       
       // Read Root Node Level value from site level properties
       Node siteLevelNode = null;
       int siteRootLevel = 1;
       try{
           siteLevelNode = slingRequest.getResourceResolver().getResource(currentDesign.getPath()+"/jcr:content/g2g/sitelevelproperties") != null ? slingRequest.getResourceResolver().getResource(currentDesign.getPath()+"/jcr:content/g2g/sitelevelproperties").adaptTo(Node.class) : null;
       
           if(siteLevelNode!=null){
               siteRootLevel = (siteLevelNode.hasProperty("siteRootLevel"))?Integer.parseInt(siteLevelNode.getProperty("siteRootLevel").getValue().getString()):1;            
            }
           do {
               ValueMap props = thisPage.getProperties();
               hideHeader = props.get("hideHeader","");
               
               if( (!hideHeader.equals("yes")) && (!hideHeader.equals("no")))  {
                   thisPage = thisPage.getParent();
               } else {
                   break;
               }
           } 
           while( ((thisPage.getDepth())> siteRootLevel) && (thisPage != null) );
           
       }
       catch(Exception e) 
       {} 
       
                if((hideHeader.equals("no"))){
                    if(hideHeaderParam ==null || !("true".equals(hideHeaderParam))) {
%>          
                        <header>
                        <cq:include path="awesomebarpara" resourceType="mcd/components/content/awesomebar" />              
                        <cq:include path="navigationpara" resourceType="mcd/components/content/navigationbar" />
                        </header>
<%    
                    }
                }   
                else if((hideHeader.equals("yes"))){      
%>               
                    </div>
<%    
                }
%>
            
    <%-- Begin - updated for redirect text Hemant 24-Nov-2010 --%>
     <div class="clearboth">
        <%-- Out of box script to redirect page to its redirect URL --%>
        <cq:include script="redirect.jsp"/>
    </div>
    <%-- End - updated for redirect text Hemant 24-Nov-2010 --%>
    <div id="pagecontentwrapper"> 
        <cq:include script="topbar.jsp" />
        <cq:include script="responsivebottombar.jsp" />
    </div>
    <div class="clearboth">
    <footer class="footer">
        <cq:include path="footerresponsivepara" resourceType="foundation/components/iparsys" />
    </footer>  
    </div>  
<script>
  if (<%= WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.EDIT %>) {

         $('#right-results-column').css('float','left');
         resetColctrlColor();
         
    }else{
         setContentPara();
         resetColctrlHeight(); 
         }
    
  
   
        //getResponsiveAwesomeHeader('<%=currentPage.getPath()%>','<%=currentDesign.getPath()%>');
    
   
    function setContent() {
        setContentPara();
         resetColctrlHeight();  
    }
    
</script>
</div>

<script>
    function getUserInfo()
    {    
        var aID ="UNKNOWN";
        var aRole ="UNKNOWN";
        var aCombo ="UNKNOWN_UNKNOWN";
        
         //wait for UserInfoObject to initialize;
        
         if(!getUserInfoObject('<%=currentPage.getPath().replaceAll("/content/","/")%>')){
             setTimeout(function(){getUserInfo()},250);
             return;
         }
         
         aID=UserInfoObject.uid;
         aRole=UserInfoObject.mcdAudience;
         aCombo= aID+"_"+aRole;
         _tag.DCSext.EID=aID;
         _tag.DCSext.ROLE=aRole;
         _tag.DCSext.COMBO=aCombo;
         if(document.readyState!="complete"){
             $(document).ready(function(){
                 _tag.dcsCollect();
             });
         }else{
             _tag.dcsCollect();
             _tag.dcsET();
         }
             
    }
    /* function checkDiv() {
        var awesome=  $( "#headerwrap #topheader" ).html();
        var nav = $( "#headerwrapper #mainNavMenuContainer ul#mainNavMenu li" ).html();
        if(awesome=="" || nav=="&nbsp;"){ 
        window.location.reload(true); }
    }*/

</script>     

</body> 
      