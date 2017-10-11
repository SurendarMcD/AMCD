<%--
  ==============================================================================
  Draws the right bar of template:  
  - draw breadcrumbpar inheritance parsys
  - draw printpar inheritance parsys
  - includes contentbar
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp" %>
<%  
    String rightsectionClass = "rightsection";
    String hideLeftNav = properties.get("hideLeftNav","");
    // Change class name for right section in case left bar is hidden
    if(hideLeftNav.equals("true"))
    {
        rightsectionClass = "rightsectionNoLeftNav";
    }
%>
<div class="<%=rightsectionClass %>">   
    <div class="righttopbar clear"> 
             <div class="breadcrumbbar"> 
                 <%-- Draws inheritance parsys for breadcrumb bar --%>
                 <cq:include path="breadcrumbpar" resourceType="foundation/components/iparsys" />
             </div>
             <div class="printbar">
                 <%-- Draws inheritance parsys for Printer friendly bar --%>
                 <cq:include path="printpar" resourceType="foundation/components/iparsys" />
             </div> 
    </div>
    <div class="contentbar clear">
      <cq:include script="contentbar.jsp" />
    </div>       
</div>