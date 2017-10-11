<%@include file="/apps/mcd/global/global.jsp"%>
<%@page session="false" %>
<%@page import="com.day.cq.security.User,
        java.util.Map, java.util.List,
        com.day.cq.wcm.api.WCMMode,
        com.mcd.accessmcd.searchhistory.bean.HistoryItem,
        com.mcd.accessmcd.searchhistory.manager.SearchHistoryManager,
        com.mcd.accessmcd.searchhistory.manager.impl.SearchHistoryManagerImpl"%>
        
<%   
        response.setHeader("Cache-Control","no-cache");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");
%>
   
<link rel="stylesheet" href="/apps/mcd/components/content/searchHistory/searchHistory.css" type="text/css">
<%
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);
    String userId = user.getID().toUpperCase();
    String labelMsg = langText.get("Search History");  
    String labelText = properties.get("label",labelMsg);
    String searchURL = properties.get("searchURL","/content/accessmcd/search");
    String dateFormat =  properties.get("dateFormat","EEEE, MMMM d, yyyy");
    String noOfDays = properties.get("days","");
    String displayOrder = properties.get("Order", "DESC");
    String searchMsg = langText.get("Search History is not available right now. Please try again later.");
    String noResult1  = langText.get("User has not performed any search for "); 
    String noResult2  = langText.get("Days");
    String noResult=noResult1+noOfDays+" "+noResult2;
    WCMMode wcmMode= WCMMode.fromRequest(request);  
    SearchHistoryManager historyMgr = new SearchHistoryManagerImpl();
    Map<String, List<HistoryItem>> resultMap=null;
    String view="";
    if(currentPage.getPath().contains("/na/mcweb/en/")){
    
    view="canada_en";
    }
    if(currentPage.getPath().contains("/na/mcweb/fr/")){
    
    view="canada_fr";
    }
    String language = prop.getProperty(view+"Language");  
    if(language ==  null) language = "en";
        pageContext.setAttribute("noResult", noResult);
        pageContext.setAttribute("label", labelText.trim());
        pageContext.setAttribute("searchURL", searchURL);
        pageContext.setAttribute("noOfDays", noOfDays);
    if(noOfDays.equals("")){
    if ((wcmMode == WCMMode.EDIT) ||(wcmMode == WCMMode.PREVIEW) ){
    %>      
        <div class="historyWrapper">
        <h1><%=labelText%></h1>
        <p>&nbsp;</p>
        <span><%=langText.get("Please enter some value in dialog box.")%></span>  
        <div style="clear:both;"></div>
        </div>
              
    <% 
    } }else{        
    try{
        resultMap = historyMgr.getUserSearchHistory(userId, noOfDays, dateFormat, displayOrder, sling,language);

        pageContext.setAttribute("result", resultMap);



         %>
<div class="historyWrapper">
    <h1>${label}</h1>
    <p>&nbsp;</p>

    <c:choose>
        <c:when test="${fn:length(result)==0}">
            <p>${noResult}</p>
        </c:when>
        <c:otherwise>
            <c:choose>
                <c:when test="${fn:length(result)%2==0}">
                    <c:set value="${fn:length(result)/2}" var="resultSize"/>
                </c:when>
                <c:otherwise>
                    <c:set value="${fn:length(result)/2 + 0.5}" var="resultSize"/>
                </c:otherwise>
            </c:choose>
             <c:if test="${resultSize<5}">
                <c:set var="resultSize" value="5"/>
            </c:if>
            
            <div class="historyColumn">
                <c:set var="columnDivided" value="false"/>
                                
                <c:forEach var="entry" items="${result}" varStatus="loopStatus" end="${noOfDays}">
                    
                    
                    <c:if test="${(loopStatus.count> resultSize)  and !columnDivided}">
                        <div class="historyColumn">
                            <c:set var="columnDivided" value="true"/>
                        </c:if>
                                       
                        <div class='searchDate'><b>${entry.key}</b></div>
                        <c:set var="historyItems" value="${entry.value}"/>
                        <c:if test="${fn:length(historyItems)>0}">
                            <ul style="list-style:none">
                                <c:forEach var="item" items="${historyItems}">
                                    <li>
                                        <a style="color:#003399;text-decoration: none;" href="${searchURL}.html?qt=${item.queryText}&la=${item.language}&mkt=${item.market}">
                                            ${item.queryText}
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                            
                         </c:if>
                         
                        <c:if test="${(loopStatus.count==resultSize)}">
                        </div> 
                    </c:if>
                   
                </c:forEach>        
            </div>
            <div style="clear:both;"></div>
            
        </c:otherwise>
    </c:choose>
</div>

<%
 }catch(Exception e){
        out.println("<div class=\"historyWrapper\">");
        out.println("<h1>"+labelText+"</h1>");
        out.println("<p>&nbsp;</p>");
        out.println("<span>"+searchMsg+"</span>");
        out.println("<div style=\"clear:both;\"></div>");
        out.println("</div>");
    }
}
%>