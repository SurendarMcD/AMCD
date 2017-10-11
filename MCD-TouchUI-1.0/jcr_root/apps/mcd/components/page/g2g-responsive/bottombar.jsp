<%--
  ==============================================================================
  Draws the HTML body with content:  
  - includes leftbar
  - includes rightbar
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>

    <cq:include script="leftbar.jsp" />
    <cq:include script="rightbar.jsp" /> 

   
    <div class="clearboth">
        <%-- <cq:include path="footerpara" resourceType="foundation/components/iparsys" />  --%>
        <cq:include path="sitefooter" resourceType="/apps/mcd/components/content/sitefooter" /> 
    </div>