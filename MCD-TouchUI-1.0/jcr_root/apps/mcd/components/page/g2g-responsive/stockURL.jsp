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


     
<%@include file="/apps/mcd/global/global.jsp"%> 
<%@ include file="Stock.html" %>
<html>
 <head>
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title> MCD Stock Details </title>
 <script type="text/javascript" src="/etc/designs/mcd/accessmcd/corelibs/core/js/jquery-1.7.1.min.js"></script> 
 <script type="text/javascript" src="/apps/mcd/docroot/scripts/handlebars-v2.0.0.js"></script>

<style>

   .ccbnHR                       {background-color: #BF0C0C;
                                  color: #BF0C0C;
                                  width: 100%;
                                  height: 2px;
                                  border: none;
                                  margin: 15px 0px;}

   a:link, a:visited, a:active, a:hover {color: #000;}

/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
/* x             Page Styles - General Txt/Bg             x */
/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */

   .ccbnTblTtl                   {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #000;
                                  line-height: 14pt;}

   .ccbnBgTblTtl                 {background-color: #FFF;}

   .ccbnTblSubTtl                {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTblSubTtl              {background-color: #FFFFFF;}

   .ccbnBgTblSubTtl td           {border-bottom: 1px solid #dedede;}

   .ccbnBgTblSubTtl td td        {border-bottom: none;}


   .ccbnTblOdd                   {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTblOdd                 {background-color: #FFFFFF;}

   .ccbnBgTblOdd td              {border-bottom: 1px solid #dedede;}

   .ccbnBgTblOdd td td           {border-bottom: none;}

   .ccbnTblEven                  {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTblEven                {background-color: #FFFFFF;}


   .ccbnBgTblEven td             {border-bottom: 1px solid #dedede;}

   .ccbnBgTblEven td td          {border-bottom: none;}


   .ccbnTblTxt                   {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTblTxt                 {background-color: #FFFFFF;}

   .ccbnTblTxtBold               {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTblTxtBold             {background-color: #FFFFFF;}

   .ccbnTblHighlight             {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTblHighlight           {background-color: #FFFFFF;}

   .ccbnTblSubTxt                {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTblSubTxt              {background-color: #FFFFFF;}

   .ccbnTblLnk                   {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  line-height: 14pt;}

   .ccbnBgTblLnk                 {background-color: #FFFFFF;}

   .ccbnTblHighlightLnk          {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  line-height: 14pt;}

   .ccbnBgTblHighlightLnk        {background-color: #FFFFFF;}

   .ccbnTblLabelLnk              {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  line-height: 14pt;}

   .ccbnBgTblLabelLnk            {background-color: #FFFFFF;}

   .ccbnTtl                      {color: #363636;
                                  font-family: Arial,Helvetica,sans-serif;
                                  font-size: 13px;
                                  font-weight: bold;
                                  line-height: 15pt;
                                  margin: 0 0 5px;
                                  display: block;}

   .ccbnBgTtl                    {background-color: #FFFFFF;}

   .ccbnSubTtl                   {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgSubTtl                 {background-color: #FFFFFF;}

   .ccbnTxt                      {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTxt                    {background-color: #FFFFFF;}

   .ccbnTxtBold                  {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTxtBold                {background-color: #FFFFFF;}

   .ccbnTxtBoldSub               {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTxtBoldSub             {background-color: #FFFFFF;}

   .ccbnSubTxt                   {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgSubTxt                 {background-color: #FFFFFF;}

   .ccbnRequired                 {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  line-height: 14pt;
                                  color: #BF0C0C;}

   .ccbnBgRequired               {background-color: #FFFFFF;}

   .ccbnError                    {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  line-height: 14pt;
                                  color: #BF0C0C;}

   .ccbnBgError                  {background-color: #FFFFFF;}

   .ccbnConfirmBold              {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgConfirmBold            {background-color: #FFFFFF;}

   .ccbnNeg                      {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  line-height: 14pt;
                                  color: #BF0C0C;}

   .ccbnBgNeg                    {background-color: #BF0C0C;}

   .ccbnPos                      {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  line-height: 14pt;
                                  color: #00B000;}

   .ccbnBgPos                    {background-color: #00B000;}

   .ccbnPrice                    {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgPrice                  {background-color: #FFFFFF;}

   .ccbnLnk                      {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  line-height: 14pt;}

   .ccbnBgLnk                    {background-color: #FFFFFF;}

   .ccbnSubLnk                   {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  line-height: 14pt;}

   .ccbnBgSubLnk                 {background-color: #FFFFFF;}

   .ccbnTblSubLnk                {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  line-height: 14pt;}

   .ccbnBgTblSubLnk              {background-color: #FFFFFF;}

   .modDisclaimer                {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 10px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnDisclaimer               {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 10px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgDisclaimer             {background-color: #FFFFFF;}

   .ccbnLabel                    {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgLabel                  {background-color: #FFFFFF;}

   .ccbnTblLabelLeft             {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTblLabelLeft           {background-color: #FFFFFF;}

   .ccbnTblLabelTop              {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgTblLabelTop            {background-color: #FFFFFF;}

   .ccbnNav                      {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: bold;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnSelect                   {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgSelect                 {background-color: #FFFFFF;}

   .ccbnInput                    {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgInput                  {background-color: #FFFFFF;}

   .ccbnButton                   {font-family: Arial,Helvetica,sans-serif;
                                  font-size: 12px;
                                  font-weight: normal;
                                  color: #4F4F4F;
                                  line-height: 14pt;}

   .ccbnBgButton                 {background-color: #FFFFFF;}

   .ccbnOutline                  {background-color: #FFFFFF;}

   .ccbnOutlineChart             {background-color: #FFFFFF;}

   .ccbnOutlineQuote             {background-color: #FFFFFF;}

   .ccbnBgChart                  {background-color: #FFFFFF;}

   .ccbnBgLine                   {background-color: #000000;}

   .ccbnBgSpacer                 {background-color: #FFFFFF;}


/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
/* x             SEC - keyword search results             x */
/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */

   #CCBNSECRes                   {}


/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
/* x                 Enumerate Backgrounds                x */
/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */

   .ccbnEnumBodyBg               {}

   .ccbnEnumBg                   {background-color: #CCCCCC;}

   .ccbnEnumBgLogo               {background-color: #FFFFFF;}

   .ccbnEnumHighlightLt          {background-color: #FFFFFF;}

   .ccbnEnumHighlight            {background-color: #EFEFEF;}

   .ccbnEnumShadow               {background-color: #999999;}

   .ccbnEnumShadowDk             {background-color: #666666;}


/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
/* x                    Enumerate Links                   x */
/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */

   .ccbnEnumTabLnk               {font-family: arial, helvetica, sans-serif;
                                  font-size: 10px;
                                  color: #000000;
                                  text-transform: uppercase;}

   a.ccbnEnumTabLnk:link         {font-family: arial, helvetica, sans-serif;
                                  font-size: 10px;
                                  color: #000000;
                                  text-transform: uppercase;
                                  text-decoration: underline;}

   a.ccbnEnumTabLnk:hover        {text-decoration: none;}

   a.ccbnEnumTabLnk:active       {text-decoration: none;}

   a.ccbnEnumTabLnk:visited      {font-family: arial, helvetica, sans-serif;
                                  font-size: 10px;
                                  color: #000000;
                                  text-transform: uppercase;
                                  text-decoration: underline;}

   .ccbnEnumPeerListLnk          {font-size: 11px;}


/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
/* x                    Enumerate Rows                    x */
/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */

   .ccbnEnumTxtEven              {font-family: arial, verdana, helvetica, sans-serif;
                                  font-size: 11px;}

   .ccbnEnumTxtOdd               {font-family: arial, verdana, helvetica, sans-serif;
                                  font-size: 11px;}

   .ccbnBgEnumTblEven            {background-color: #EFEFEF;}

   .ccbnBgEnumTblOdd             {background-color: #FFFFFF;}


/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
/* x                   Mouse Over Styles                  x */
/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */


/*global class applied to all divs that peform hovering functions all global settings should be applied here*/

   .ccbnPopover                  {position:absolute;
                                  visibility:hidden;
                                  overflow:auto;
                                  width:200px;
                                  height:auto;
                                  background:#ffffff;
                                  text-align:left;
                                  border:1px solid #000;
                                  top:0px;
                                  left:0px;}


/*all hovers will inherit styles from ccbnPopover but you can overwrite those styles by using the selectors below if you would like to customize a HOVER style or add new styles specific to a hover type, add them here*/

   .ccbnDefinitionHover          {width: 300px;
                                  height: auto;}

   .ccbnEventHeaderHover         {width: 300px;
                                  height: auto;}

   .ccbnBioHover                 {width: 300px;
                                  height: auto;}

   .ccbnNewsHover                {width: 300px;
                                  height: auto;}


/*table rows beneath a table that has a class of ccbnRowHoverTbl will change color when hovered over - set your own color or other styles for the row here*/

   .ccbnRowHoverTbl tr:hover td, .ccbnRowHoverTbl tr.ccbnIE6Over td{}


/*we do not want the rows that are titles to change color, this is the fix the styles of this should be the same as the value of ccbnBgTblTtl*/

   .ccbnRowHoverTbl tr.ccbnBgTblTtl:hover td{}


/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
/* x                   Scrolling Module                   x */
/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */


/*this class is applied to all divs that will scroll as well as the scroll container the container also has an ID which can be referenced in this stylesheet if necessary*/

   .ccbnScroll                   {position:relative;
                                  overflow:hidden;
                                  height:160px;}


/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
/* x                Company Calendar Styles               x */
/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */


/*HOVER COLOR - background color for when a user hovers over one of the day cells This should be changed to reflect the clients color scheme*/

   .ccbnCalendarTable tbody td.ccbnEvent:hover, .ccbnCalendarTable tbody td.ccbnIE6Over{}


/*HOVER COLOR - background color for when a user hovers over one of the header cells This should be changed to reflect the clients color scheme*/

   .ccbnCalendarTable thead td.ccbnCalButton:hover, .ccbnCalendarTable thead td.ccbnCalButton.ccbnIE6Over{}


/*all hovers will inherit styles from ccbnPopover but you can overwrite those styles by using the selectors  below if you would like to customize a HOVER style or add new styles specific to a hover type, add them here*/

   .ccbnCalendarDiv              {height:auto;
                                  max-height:100px;
                                  height:expression(this.scrollHeight>100?"100px":"auto");}

   .ccbnCalendarHelpDiv          {}


/*the mouse click version of the module uses this style for the div where the event information appears after a mouse click of a date*/

   .ccbnCalendarDivClick         {overflow:auto;
                                  height:230px;}


/*styles for days that are weekends This should be changed to reflect the clients color scheme*/

   .ccbnWeekend                  {}


/*styles for the table cell which represents todays date This should be changed to reflect the clients color scheme*/

   .ccbnToday                    {border:1px solid #000;}


/*styles for days that have events This should be changed to reflect the clients color scheme*/

   .ccbnEvent                    {background:#BBBBBB;}

   .ccbnCalButton                {}

   .ccbnDay                      {}

   .ccbnName                     {}

   .ccbnCalendar                 {cursor:default;}

   .ccbnCalendarTable            {}


/*since the month / year title row also has the ? cell, text-align center is not sufficient to center the text, this is a fix for that problem*/

   .ccbnCalCenterTitle           {padding-left:2.5em;}


/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */
/* x                    Calendar Icons                    x */
/* xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx */

   .ccbnCalIconAnalyst           {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_am.gif) no-repeat;}

   .ccbnCalIconConference        {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_cf.gif) no-repeat;}

   .ccbnCalIconConferencePres    {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_cp.gif) no-repeat;}

   .ccbnCalIconConferenceCall    {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_cc-ne.gif) no-repeat;}

   .ccbnCalIconCustom            {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_custom.gif) no-repeat;}

   .ccbnCalIconEarningsConfCall  {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_cc-er.gif) no-repeat;}

   .ccbnCalIconEarnings          {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_er.gif) no-repeat;}

   .ccbnCalIconReports           {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_fin_rpt.gif) no-repeat;}

   .ccbnCalIconMA                {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_ma.gif) no-repeat;}

   .ccbnCalIconGuidance          {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_ga.gif) no-repeat;}

   .ccbnCalIconOther             {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_oc.gif) no-repeat;}

   .ccbnCalIconSalesCall         {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_sc.gif) no-repeat;}

   .ccbnCalIconSalesRelease      {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_sar.gif) no-repeat;}

   .ccbnCalIconShareholders      {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_sm.gif) no-repeat;}

   .ccbnCalIconNewsRelease       {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_news.gif) no-repeat;}

   .ccbnCalIconSEC               {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_sec.gif) no-repeat;}

   .ccbnCalIconPresentations     {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_pres.gif) no-repeat;}

   .ccbnCalIcon52WeekHigh        {background:url(http://media.corporate-ir.net/media_files/irol/global_images/icon_52wkh.gif) no-repeat;}


/*Icons Padding*/

   .ccbnCalIconAnalyst, .ccbnCalIconConference, .ccbnCalIconConferencePres, .ccbnCalIconConferenceCall, .ccbnCalIconCustom, .ccbnCalIconEarningsConfCall, .ccbnCalIconEarnings, .ccbnCalIconReports, .ccbnCalIconMA, .ccbnCalIconGuidance, .ccbnCalIconOther, .ccbnCalIconSalesCall, .ccbnCalIconSalesRelease, .ccbnCalIconShareholders, .ccbnCalIconNewsRelease, .ccbnCalIconSEC, .ccbnCalIconPresentations, .ccbnCalIcon52WeekHigh{padding-left:20px;}


/*DO NOT EDIT - hides the leading and trailing days of each month*/

   .ccbnEmpty span               {visibility:hidden;}


/*DO NOT EDIT - make the hidden section visible when a user hovers over the help cell*/

   td.ccbnCalButton:hover div.ccbnCalendarHelpDiv, .ccbnCalendarTable thead td.ccbnIE6Over div.ccbnCalendarHelpDiv{visibility:visible;
                                  z-index:100;}


/*DO NOT EDIT - make the hidden section visible when a user hovers over the event cell*/

   td.ccbnEvent:hover div.ccbnCalendarDiv, .ccbnCalendarTable tbody td.ccbnIE6Over div.ccbnCalendarDiv{visibility:visible;
                                  z-index:100;}


</style>
 </head>

 <body>
 
 <div class="stockInfo"></div>
 <script>

          var url = "https://query.yahooapis.com/v1/public/yql?q=select%20Symbol%2CName%2CDaysLow%2COpen%2CPreviousClose%2CVolume%2CDaysHigh%2CYearLow%2CYearHigh%2CLastTradePriceOnly%2CLastTradeDate%2CLastTradeTime%2CMarketCapitalization%2CChange_PercentChange%20from%20yahoo.finance.quotes%20where%20symbol%3D%22MCD%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=?";
            var arrQuote, stockPrice, daysHigh, daysLow, yearHigh, yearLow, symbol, company, lastTradeDate, lastTradeTime, marketCap, arrStockChangePercent, stockChange, stockChangePercent, stockChangeDirection, stockInfoMarkup , open , prevClose , volume ,stockChangeDir , dollar;
           $.getJSON(url, function (data) {
                //alert(data);
                arrQuote = data.query.results.quote;
                stockPrice = parseFloat(Math.round(arrQuote["LastTradePriceOnly"] * 100) / 100).toFixed(2);
                daysHigh = arrQuote["DaysHigh"];
                daysLow = arrQuote["DaysLow"];
                yearHigh = arrQuote["YearHigh"];
                yearLow = arrQuote["YearLow"];
                symbol = arrQuote["Symbol"];
                company = arrQuote["Name"];
                open = arrQuote["Open"];
                prevClose = arrQuote["PreviousClose"];
                volume = arrQuote["Volume"].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
                lastTradeDate = arrQuote["LastTradeDate"];
                lastTradeTime = arrQuote["LastTradeTime"];
                marketCap = arrQuote["MarketCapitalization"];
                arrStockChangePercent = arrQuote["Change_PercentChange"].split(" - ");
                stockChange = arrStockChangePercent[0];
                stockChangePercent = arrStockChangePercent[1];
                stockChangeDirection = stockChange.charAt(0);
                if (stockChangeDirection === "+") {
                    stockChangeDir = true;
                }
                else {
                    stockChangeDir = false;
                }
                dollar ="$";
                var source = $("#productData-template1").html();
                 var template = Handlebars.compile(source);
                 var context = {
       
                 stockPriceVal : stockPrice,
                 daysHighVal : daysHigh,
                 daysLowVal : daysLow,
                 yearHighVal: yearHigh,
                 yearLowVal: yearLow,
                 symbolVal : symbol,
                 openVal :  open,
                 prevCloseVal : prevClose,
                 volumeVal : volume,
                 companyVal : company,
                 lastTradeDateVal : lastTradeDate,
                 lastTradeTimeVal : lastTradeTime,
                 changeVal : stockChange,
                 changePercentVal : stockChangePercent,
                changeDirectionVal : stockChangeDir,
                marketCapVal: marketCap,
                dollarVal :dollar
                };
             
                var htmlData = template(context);
                var nutSecHtml=$(".stockInfo").html(htmlData);
                
            });


            
        </script>
 </body></html>