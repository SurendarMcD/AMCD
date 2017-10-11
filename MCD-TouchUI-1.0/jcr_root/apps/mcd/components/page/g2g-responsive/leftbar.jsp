<%--
  ==============================================================================
  Draws the left bar of template:
  - draw leftnavpar inheritance parsys
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
    
<div id="left-widgets-column">
<%
   String hideLeftNavigation = "";      
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
           hideLeftNavigation = props.get("hideLeftNav",""); 
           
           if( (!hideLeftNavigation.equals("yes")) && (!hideLeftNavigation.equals("no")))  {
                   thisPage = thisPage.getParent();
               } else {
                   break;
               }
       } 
       while( ((thisPage.getDepth())> siteRootLevel) && (thisPage != null) ); 
       
   }
   catch(Exception e) 
   {}
   
   if(!hideLeftNavigation.equals("yes")) {
%>       
        <%-- Draws inheritance parsys for Left Navigation bar --%>
        <cq:include path="leftnavpara" resourceType="foundation/components/iparsys" />
<%      
   }
%>
    <%-- Draws parsys for Left Section --%>
    <cq:include path="leftcontentpara" resourceType="foundation/components/iparsys" />
</div>
    