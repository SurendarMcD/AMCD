<%--
  ==============================================================================
  Draws the main content layout of template:
  - includes redirect script
  - draw contentpar parsys
  - draw footerpar inheritance parsys 
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp" %>
<div class="content clear">                
    <%-- Out of box script to redirect page to its redirect URL --%>
    <cq:include script="redirect.jsp"/>
    <%-- Draws parsys for page content --%>
    <cq:include path="contentpar" resourceType="foundation/components/parsys" />
</div>
<%-- 

<div class="footerbar clear">
    <cq:include path="footerpar" resourceType="foundation/components/iparsys" />
</div>

--%>

    <%-- To include site level footer component --%>
<%-- 
   <div class="sitefooter clear">
    <cq:include path="sitefooter" resourceType="/apps/mcd/components/content/sitefooter" />
</div>
--%>

</div>
