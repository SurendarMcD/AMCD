<%--
  ==============================================================================
  Draws the top/header bar of template:  
  - draw logopar inheritance parsys
  - draw searchpar inheritance parsys
  - draw topnavpar inheritance parsys
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp" %>
<div class="headsection clear">        
        <div class="logobar">
            <%--Draws inheritance parsys for Header logo bar--%> 
            <cq:include path="logopar" resourceType="foundation/components/iparsys" />
        </div>
        <div class="srchbar">
            <%--Draws inheritance parsys for Search bar--%>         
            <cq:include path="searchpar" resourceType="foundation/components/iparsys" />
        </div>
</div>
<div class="topnavsection clear">
    <div class="topnavbar">
         <%--Draws inheritance parsys for Top Navigation bar--%> 
        <cq:include path="topnavpar" resourceType="foundation/components/iparsys" />
    </div>
</div>
