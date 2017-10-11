<%-- ################################################################################ 
 # DESCRIPTION: Used for stock details. 
 #              Retrieve values like current price, changed price and stock image name in form of JSON object.
 #  
 # Environment: 
 # 
 # UPDATE HISTORY       
 # 1.0  Deepali Goyal Initial Version
 #
 #####################################################################################--%>

<%@ page import="com.mcd.stockticker.facade.StockTickerFacadeImpl" %>
<%@ page import="com.mcd.stockticker.constants.StockTickerConstants" %>
<%@ page import="com.mcd.stockticker.bean.StockDetails" %>
<%@ page import="com.mcd.stockticker.util.StockUtil" %><%
%>
     
<%@include file="/apps/mcd/global/global.jsp"%> 
<% response.setHeader("Cache-Control","no-cache"); %><%     
%>
  
<%
//STOCK DETAILS
StockTickerFacadeImpl facade = new StockTickerFacadeImpl();
StockDetails stockBean = facade.getStockInfo(StockTickerConstants.url, StockTickerConstants.timeout);  
String currentPrice = "";
String changePrice = "";
String stockImgName = "down-arrow.png" ; 
if(stockBean != null) {
    StockUtil sUtil = new StockUtil();
    currentPrice = stockBean.getTradePrice();
    changePrice = stockBean.getChange();
    
    double price = 0;
    try{
         price = Double.valueOf(changePrice.trim()).doubleValue();
       }catch(NumberFormatException e){
        log.error("moreinfo.jsp Error " + e.getMessage());  
       }
    if(price > 0){
        changePrice = "+" + changePrice;
        stockImgName = "up-arrow.png" ;
    } else if(price < 0){
        stockImgName = "down-arrow.png" ;
    } 
} 
%>
{   
   "currentPrice" : "$<%=currentPrice %>",
   "changePrice" : "<%=changePrice %>", 
   "stockImageName" : "<%=stockImgName %>"    
}