<%--
  ==============================================================================
  Draws the logo, breadcrumb and top nav section of template
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
    <div>
        <div id="logo_t">      
            <%-- Draws inheritance parsys for Logo--%>
            <cq:include path="sitelogopara" resourceType="foundation/components/iparsys" />
        </div>
        <div id="bread_tnav_cntr" >        
            <div>
                <%-- Draws inheritance parsys for Breadcrumb--%>
                <cq:include path="breadcrumbpara" resourceType="foundation/components/iparsys" />
            </div>
<%

 // Check for hideHeader
       String hideTopNavigation = "";      
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
               hideTopNavigation = props.get("hideTopNav",""); 
                
               if( (!hideTopNavigation.equals("yes")) && (!hideTopNavigation.equals("no")))  {
                       thisPage = thisPage.getParent();
                   } else {
                       break;
                   }
           } 
           while( ((thisPage.getDepth())> siteRootLevel) && (thisPage != null) ); 
           
       }
       catch(Exception e) 
       {}
         
        if(!hideTopNavigation.equals("yes")) { 
%>        
            <div class="clear">
                <cq:include path="topnavpara" resourceType="foundation/components/iparsys" />
            </div>
<%        
        } 
%>
        </div> 
    </div>
    <div class="clearboth"></div>
    