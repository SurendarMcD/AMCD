<%--
  ==============================================================================
  Draws the HTML body with content:
  - includes topbar
  - includes bottombar
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<body>
<div id="compbody">
    <div class="mainbody">
    <%
       // Check for hideHeader
       String hideHeader = "";      

       Page thisPage = currentPage;

       int siteRootLevel = 3;
           
       do {
           ValueMap props = thisPage.getProperties();
           hideHeader = props.get("hideHeader","");

           if( (!hideHeader.equals("yes")) && (!hideHeader.equals("no")))  {
               thisPage = thisPage.getParent();
           } else {
               break;
           }
        
       } while( ((thisPage.getDepth())>siteRootLevel) && (thisPage != null) );  

       if(!hideHeader.equals("yes"))    {
%>         <div class="topbar clear">
               <cq:include script="topbar.jsp" /> 
           </div>
<%    
       }  
%>
       <div class="bottombar clear">
            <cq:include script="bottombar.jsp" />        
       </div>    
    </div>
</div>    
</body>