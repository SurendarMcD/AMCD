<%--

  World Clock Component component.

  Displays world clock flash application.

--%>
<%@include file="/libs/foundation/global.jsp"%>
<%@page session="false" %>   
<cq:includeClientLib categories="granite.csrf.standalone" />
<%
    String rounded = properties.get("rounded", "");
    String bgColor = properties.get("bgColor", "");
    String width = properties.get("width", "auto");
    if (!width.equals("auto")){
        width = width + "px";
    }
    String margin = properties.get("margin", "0") + "px;";
    String padding = properties.get("padding", "0") + "px;";
    
    String innerMargin = "";
%>
<div class="clockContainer <%=bgColor%> &nbsp; <%=rounded%>" style="width: <%=width%>; margin: <%=margin%>">
    <center>
    <div class="clockEmbed" style="padding: <%=padding%> &nbsp; <%=innerMargin%>">
        <embed height="130" width="305" class="swfClock" src="/apps/mcd/docroot/flash/WorldClockWidget.swf" type="application/x-shockwave-flash" base="/apps/mcd/docroot/flash/" wmode="transparent"></embed>
    </div>
    </center>
</div>   
