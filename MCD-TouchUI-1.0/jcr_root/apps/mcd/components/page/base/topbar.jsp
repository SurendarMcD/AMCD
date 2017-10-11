<%--
  ==============================================================================
  Draws the top/header part of the template:  
  - include awesome bar component
  - include top navigation menu bar component
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp" %>
    <div id="headerwrap">    
        <div id="wrap" class="clearfix">   
            <cq:include path="awesomebarpara" resourceType="mcd/components/content/awesomebar" />              
        </div>    
    </div>  
    <div id="headerwrapper">  <!--Top Navigation Header-->
        <cq:include path="menubarpara" resourceType="mcd/components/content/topNavMenu" />
    </div> 
       
    <div class="clearboth"></div> 