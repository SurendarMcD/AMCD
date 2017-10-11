<!--/*
    Column Control Component for Responsive Pages
*/-->
<%@page import="com.day.cq.wcm.api.WCMMode"%><%
%><%@include file="/libs/foundation/global.jsp"%><%
    %>
<%
    String backgroundColor = properties.get("bgColor","");//949599
    if(!"".equals(backgroundColor)){
        backgroundColor = "background:#"+backgroundColor+";margin-left:15px;margin-right:15px;";
    }
    String borderColor = properties.get("bordercolor","");//d7262e
    String borderSize = properties.get("borderSize","25") + "px";
    if(!"".equals(borderColor)){
        borderColor = "border-top:" + borderSize + " solid #" + borderColor+";";
    }
    
    String enableMobile = properties.get("enableMobile","");
    String mobileClass = "";
    if("true".equals(enableMobile)) {
        mobileClass = "mobileCols";
    }
    
    String[] columnValues = properties.get("columns", String[].class);
    pageContext.setAttribute("columns", columnValues);
    pageContext.setAttribute("wcmmode", (WCMMode.fromRequest(request)!=WCMMode.DISABLED));
    pageContext.setAttribute("mobileClass", mobileClass);
%>
<c:choose>
    <c:when test="${fn:length(columns)>0}">
        <div style="<%=backgroundColor%><%=borderColor%>" class="${mobileClass}">
            <c:forEach items="${columns}" var="item" varStatus="index">
                <c:if test="${!empty item}">
                    <div class="col-xs-12 col-sm-${item}">
                        <cq:include path="col-par-${index.count}" resourceType="foundation/components/parsys"/>
                    </div>
                </c:if>
            </c:forEach>
            <div class="clearfix"></div>
        </div>
    </c:when>
    <c:otherwise>
        <c:if test="${wcmmode}">
            <div>Please configure the number of columns required.</div>
        </c:if>
    </c:otherwise>
</c:choose>
<div class="clearfix"></div>