<%--
  ==============================================================================
  Draws the right content section of template:
  - draw rightnavpar inheritance parsys and main content section par
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>

<div id="right-results-column" >   
    
        <div id="right_content_par" >
           <%-- Draws inheritance parsys for Right Navigation bar --%>
           <cq:include path="rightcontentpara" resourceType="foundation/components/iparsys" />
        </div> 
  
        <div id="content_txt">
            <%-- Draws parsys for content section --%>
            <cq:include path="maincontentpara" resourceType="/apps/mcd/components/content/parsys" />
        </div>
  </div>
                
         