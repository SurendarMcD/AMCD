<%--
  
  Everything component         
  
  Includes the normal or responsive implementaion of component depending upon applied design

--%>
<%@include file="/apps/mcd/global/global.jsp"%>

  
<%
    String designPath = currentDesign.getPath(); 
    boolean checkDesign = designPath.contains("g2g_rwd");  
    if(checkDesign)
    {
       
%>    
            <cq:include script="rwd_everything.jsp"/>    
<%
    }
    else
    {
%>    
            <cq:include script="regular_everything.jsp"/>  
<%  
    }

      
    
%>