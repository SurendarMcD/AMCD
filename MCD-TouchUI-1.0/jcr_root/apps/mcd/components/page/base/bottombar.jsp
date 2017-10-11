<%--
  ==============================================================================
  Draws the bottom content of template:
  - includes rightbar
  - includes leftbar
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp" %>
      
    <div class="rightbar">
        <cq:include script="rightbar.jsp" />
    </div>
<%  
    // include leftbar jsp if hideLeftNav is null
    String hideLeftNav = properties.get("hideLeftNav","");
    if(hideLeftNav.equals("")) {
%>
        <div class="leftbar" > 
            <cq:include script="leftbar.jsp" />
        </div>
<%
    }
%>
        