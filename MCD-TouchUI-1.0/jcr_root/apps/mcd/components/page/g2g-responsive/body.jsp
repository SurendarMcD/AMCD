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
    String awesomeBarType = properties.get("awesomeBarType","responsive");
    String hideFeedbackSection = properties.get("hideFeedbackSection","no");
    String backgroundColor = properties.get("feedbackBGColor","");//949599
    if(!"".equals(backgroundColor)){
        backgroundColor = "background:#"+backgroundColor+";";
    }
%>
    <body class="home">

        <!-- Google Tag Manager -->
        <noscript><iframe src="//www.googletagmanager.com/ns.html?id=<%=gaCode%>"
        height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
        <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
        })(window,document,'script','dataLayer','<%=gaCode%>');</script>
        <!-- End Google Tag Manager -->

         
                <%-- To include site level properties component --%>
                <cq:include path="sitelevelproperties" resourceType="/apps/mcd/components/content/sitelevelproperties" />
                <cq:include script="additionalinfo.jsp" /> 
        <header>
<% 
                String pageLayout = properties.get("pageLayout","two");
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
                    do{
                        ValueMap props = thisPage.getProperties();
                        hideHeader = props.get("hideHeader","");
                        if( (!hideHeader.equals("yes")) && (!hideHeader.equals("no")))  {
                            thisPage = thisPage.getParent();
                        } 
                        else{
                            break;
                        }
                    } 
                    while(((thisPage.getDepth())> siteRootLevel) && (thisPage != null));
                
                }
                catch(Exception e) 
                {} 
                
                if((hideHeader.equals("no"))){
                    if(hideHeaderParam ==null || !("true".equals(hideHeaderParam))) {
%>          
                        <cq:include path="awesomebarpara" resourceType="mcd/components/content/awesomebar" />
                        <cq:include path="navigationpara" resourceType="mcd/components/content/navigationbar" />
<%    
                    }
                } 
%>                                 
        </header>
        <%-- Begin - updated for redirect text Hemant 24-Nov-2010 --%>
        <div class="clearboth">
            <%-- Out of box script to redirect page to its redirect URL --%>
            <cq:include script="redirect.jsp"/>
        </div>
        <%-- End - updated for redirect text Hemant 24-Nov-2010 --%>
        <section class="outer-container">
            <div class="container">                 
                <div class="row"> 
<%
                    if("two".equals(pageLayout)){
%>                
                        <cq:include path="topnavipara" resourceType="foundation/components/iparsys" />
                        <div class="col-md-8 col-sm-8 article-details">
                             <cq:include path="leftresponsiveipara" resourceType="foundation/components/iparsys" />
                             <cq:include path="leftresponsivepara" resourceType="foundation/components/parsys" />
                             <cq:include path="leftresponsiveiparasecond" resourceType="foundation/components/iparsys" />
                                                           
                        </div>
                        <div class="col-md-4 col-sm-4 article-news">
                        <cq:include path="rightresponsiveipara" resourceType="foundation/components/iparsys" />
                            <cq:include path="rightresponsivepara" resourceType="foundation/components/parsys" />
                            <cq:include path="rightresponsiveiparasecond" resourceType="foundation/components/iparsys" />
                        </div>
<%
                    }
                    else{ 
%>                                       
                        <cq:include path="homepagepara" resourceType="foundation/components/parsys" />
<%
                    }
%>
                </div>
                <script>
                    /*var awesomeBarType = "<%=awesomeBarType%>";
                    if(awesomeBarType == "responsive"){*/
                        //getResponsiveAwesomeHeader('<%=currentPage.getPath()%>','<%=currentDesign.getPath()%>');
                    /*}
                    else{
                        getAwesomeHeader('<%=currentPage.getPath()%>','<%=currentDesign.getPath()%>');
                    }*/
                </script> 
            </div>
        </section>
<%
        if("yes".equals(hideFeedbackSection)){
%>        
           <section class="feedback-box" style="<%=backgroundColor%>">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6 col-sm-6 col-xs-12 feedback" id="pole">
                             <cq:include path="feedbacksectionleft" resourceType="foundation/components/parsys" />
                        </div>
                        <div class="col-md-6 col-sm-6 col-xs-12 result">
                             <cq:include path="feedbacksectionright" resourceType="foundation/components/parsys" />
                        </div>
                    </div>
                </div>
            </section>
<%
        }
%>        
        <footer class="footer">
            <cq:include path="footerresponsivepara" resourceType="foundation/components/iparsys" />
        </footer>
<script>
    function getUserInfo(){    
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
    
</script>     

</body> 
