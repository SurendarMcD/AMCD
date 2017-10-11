//THIS FILE COMBINES JDATEPICKER AND CALENDAR JAVASCRIPT FILES TO MAKE THE NOTICEBOARD FUNCTIONAL.

//START JDATEPICKER.JS

var datePickerDivID = "datepicker";
var iFrameDivID = "datepickeriframe";

//judy , update this
var dayArrayShort = new Array('S', 'M', 'T', 'W', 'T', 'F', 'S');
var dayArrayMed = new Array('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
var dayArrayLong = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
var monthArrayShort = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
var monthArrayMed = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec');
var monthArrayLong = new Array('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
 
// these variables define the date formatting we're expecting and outputting.
// If you want to use a different format by default, change the defaultDateSeparator
// and defaultDateFormat variables either here or on your HTML page.
var defaultDateSeparator = "/";        // common values would be "/" or "."
var defaultDateFormat = "dmy"    // valid values are "mdy", "dmy", and "ymd"
var dateSeparator = defaultDateSeparator;
var dateFormat = defaultDateFormat;


function displayDatePicker(dateFieldName, displayBelowThisObject, dtFormat, dtSep)
{
  var targetDateField = document.getElementsByName (dateFieldName).item(0);
 
  // if we weren't told what node to display the datepicker beneath, just display it
  // beneath the date field we're updating
  if (!displayBelowThisObject)
    displayBelowThisObject = targetDateField;
 
  // if a date separator character was given, update the dateSeparator variable
  if (dtSep)
    dateSeparator = dtSep;
  else
    dateSeparator = defaultDateSeparator;
 
  // if a date format was given, update the dateFormat variable
  if (dtFormat)
    dateFormat = dtFormat;
  else
    dateFormat = defaultDateFormat;
 
  var x = displayBelowThisObject.offsetLeft;
  var y = displayBelowThisObject.offsetTop + displayBelowThisObject.offsetHeight ;
 
  // deal with elements inside tables and such
  var parent = displayBelowThisObject;
  while (parent.offsetParent) {
    parent = parent.offsetParent;
    x += parent.offsetLeft;
    y += parent.offsetTop ;
  }
 
  drawDatePicker(targetDateField, x, y);
}


/**
Draw the datepicker object (which is just a table with calendar elements) at the
specified x and y coordinates, using the targetDateField object as the input tag
that will ultimately be populated with a date.

This function will normally be called by the displayDatePicker function.
*/
function drawDatePicker(targetDateField, x, y)
{
  var dt = getFieldDate(targetDateField.value );
 
  // the datepicker table will be drawn inside of a <div> with an ID defined by the
  // global datePickerDivID variable. If such a div doesn't yet exist on the HTML
  // document we're working with, add one.
  if (!document.getElementById(datePickerDivID)) {
    // don't use innerHTML to update the body, because it can cause global variables
    // that are currently pointing to objects on the page to have bad references
    //document.body.innerHTML += "<div id='" + datePickerDivID + "' class='dpDiv'></div>";
    var newNode = document.createElement("div");
    newNode.setAttribute("id", datePickerDivID);
    newNode.setAttribute("class", "x-date-picker");
    newNode.setAttribute("style", "visibility: hidden;");
    document.body.appendChild(newNode);
  }
 
  // move the datepicker div to the proper x,y coordinate and toggle the visiblity
  var pickerDiv = document.getElementById(datePickerDivID);
  pickerDiv.style.position = "absolute";
  pickerDiv.style.left = x + "px";
  pickerDiv.style.top = y + "px";
  pickerDiv.style.visibility = (pickerDiv.style.visibility == "visible" ? "hidden" : "visible");
  pickerDiv.style.display = (pickerDiv.style.display == "block" ? "none" : "block");
  pickerDiv.style.zIndex = 10000;
 
  // draw the datepicker table
  refreshDatePicker(targetDateField.name, dt.getFullYear(), dt.getMonth(), dt.getDate());
}

//Judy, 02/28/2011, added function to handle from date
function jgetAjax(dateFieldName,dString){

    var dArray;
    var dateString;
    var myPath;
    
    try {
          dArray = splitDateString(dString);
          if (dArray) {
            dateString = dArray[1]+dateSeparator +dArray[0]+dateSeparator +dArray[2];
            if(dateFieldName=="BDate" && dateString){  
               if( document.getElementsByName('BPath').item(0)!=null)
                    myPath = document.getElementsByName('BPath').item(0).value;
                    
               //wei - passing in 'ALL' for calling getCalData from datepicker. This is for fixing the ie cache issue when editing calendar entries.
               if (myPath!=null&&myPath!='undefined'&&myPath!='null')                  
                    getCalData(myPath, 'ALL', 1, '5',dateString);
               else
                    getCalData('/accessmcd/apmea/au', 'ALL', 1, '5',dateString);
            }else if(dateFieldName=="ADate" && dateString){
               if( document.getElementsByName('APath').item(0)!=null)
                    myPath = document.getElementsByName('APath').item(0).value;
               if (myPath!=null&&myPath!='undefined'&&myPath!='null')                  
                    getNBData(myPath, '', 1, '5',dateString);
               else
                    getNBData('/accessmcd/apmea/au', '', 1, '5',dateString);
               
               
            }//end else 
          }//end if
    }catch(e){
    }      
             
}
       
       

/**
This is the function that actually draws the datepicker calendar.
*/
function refreshDatePicker(dateFieldName, year, month, day)
{
  // if no arguments are passed, use today's date; otherwise, month and year
  // are required (if a day is passed, it will be highlighted later)
  var thisDay = new Date();
 
  if ((month >= 0) && (year > 0)) {
    thisDay = new Date(year, month, 1);
  } else {
    day = thisDay.getDate();
    thisDay.setDate(1);
  }
 
  // the calendar will be drawn as a table
  // you can customize the table elements with a global CSS style sheet,
  // or by hardcoding style and formatting elements below
  var crlf = "\r\n";
  var TABLE = "<table cols=7 cellspacing='0' style='width:175px;'>" + crlf;
  var xTABLE = "</table>" + crlf;
  var TR = "<tr class='dpTR'>";
  var TR_title = "<tr class='dpTitleTR'>";
  var TR_days = "<tr class='dpDayTR'>";
  var TR_todaybutton = "<tr class='dpTodayButtonTR'>";
  var xTR = "</tr>" + crlf;
  var TD = "<td class='dpTD' onMouseOut='this.className=\"dpTD\";' onMouseOver=' this.className=\"dpTDHover\";' ";    // leave this tag open, because we'll be adding an onClick event
  var TD_title = "<td colspan=5 class='dpTitleTD'>";
  var TD_buttons = "<td class='dpButtonTD'>";
  var TD_LEFT_buttons = "<td class='dpButtonTDLeft'>";
  var TD_RIGHT_buttons = "<td class='dpButtonTDRight'>";
  var TD_todaybutton = "<td colspan=7 class='x-date-bottom'>";
  var DIV_todaybutton = "<div>";
  var TABLE_todaybutton = "<table cellspacing=0 cellpadding=0 width='100%'>";
  var TBODY_todaybutton = "<tbody>";
  var TR_todaybutton = "<tr align='center'>";
  var TD_multiokbutton = "<td align='right' class='x-date-multiokbtn'></td>"
  var TD_sectodaybutton = "<td class='x-date-todaybtn'>"
  var TABLE_todaybtnwrap = "<table cellspacing='0' cellpadding='0' border='0' class='x-btn-wrap x-btn' style='width: auto;'>"
  var LEFT_todaybutton = "<td class='x-btn-left'><i>&nbsp;</i></td>";
  var CENTER_todaybutton = "<td class='x-btn-center'>";
  var EM_todaybutton = "<em unselectable='on'>"
  var RIGHT_todaybutton = "<td class='x-btn-right'><i>&nbsp;</i></td>";
  var BTN_todaybutton = "<button type='button' class='x-btn-text' onClick='refreshDatePicker(\"" + dateFieldName + "\");'>Today</button>";
  
  //judy add close button
  var CLR_button = "<button type='button' class='x-btn-text' onClick='updateDateField(\"" + dateFieldName + "\");'>Close</button>";


  var TD_days = "<th class='dpDayTD'>";
  var TD_selected = "<td class='dpDayHighlightTD' onMouseOut='this.className=\"dpDayHighlightTD\";' onMouseOver='this.className=\"dpTDHover\";' ";    // leave this tag open, because we'll be adding an onClick event
  var xTD = "</td>" + crlf;
  var DIV_title = "<div class='dpTitleText'>";
  var DIV_selected = "<div class='dpDayHighlight'>";
  var xDIV = "</div>";
  var xTBODY = "</tbody>" + crlf;
  var xEM = "</em>" + crlf;
 
  // start generating the code for the calendar table
  var html = TABLE;
 
  // this is the title bar, which displays the month and the buttons to
  // go back to a previous month or forward to the next month
  html += TR_title;
  html += TD_LEFT_buttons + getButtonCode(dateFieldName, thisDay, -1, "") + xTD;
  html += TD_title + DIV_title + monthArrayLong[ thisDay.getMonth()] + " " + thisDay.getFullYear() + xDIV + xTD;
  html += TD_RIGHT_buttons + getButtonCode(dateFieldName, thisDay, 1, "") + xTD;
  html += xTR;
 
  // this is the row that indicates which day of the week we're on
  html += TR_days;
  for(i = 0; i < dayArrayShort.length; i++)
    html += TD_days + dayArrayShort[i] + xTD;
  html += xTR;
 
  // now we'll start populating the table with days of the month
  html += TR;
 
  // first, the leading blanks
  for (i = 0; i < thisDay.getDay(); i++)
    html += TD + "&nbsp;" + xTD;
 
  // now, the days of the month
  do {
    dayNum = thisDay.getDate();

    TD_onclick = " onclick=\"updateDateField('" + dateFieldName + "', '" + getDateString(thisDay) + "');\">";

    
    if (dayNum == day)
      html += TD_selected + TD_onclick + DIV_selected + dayNum + xDIV + xTD;
    else
      html += TD + TD_onclick + dayNum + xTD;
    
    // if this is a Saturday, start a new row
    if (thisDay.getDay() == 6)
      html += xTR + TR;
    
    // increment the day
    thisDay.setDate(thisDay.getDate() + 1);
  } while (thisDay.getDate() > 1)
 
  // fill in any trailing blanks
  if (thisDay.getDay() > 0) {
    for (i = 6; i > thisDay.getDay(); i--)
      html += TD + "&nbsp;" + xTD;
  }
  html += xTR;
 
  // add a button to allow the user to easily return to today, or close the calendar
  var today = new Date();
  var todayString = "Today is " + dayArrayMed[today.getDay()] + ", " + monthArrayMed[ today.getMonth()] + " " + today.getDate();
  html += TR_todaybutton + TD_todaybutton + DIV_todaybutton + TABLE_todaybutton + TBODY_todaybutton + TR_todaybutton 
      + TD_multiokbutton + TD_sectodaybutton + TABLE_todaybtnwrap + TBODY_todaybutton + TR_todaybutton + LEFT_todaybutton + CENTER_todaybutton
      +EM_todaybutton + BTN_todaybutton + RIGHT_todaybutton + LEFT_todaybutton + CENTER_todaybutton +EM_todaybutton +  CLR_button +RIGHT_todaybutton;
      
//judy, changed this
  html += xEM + xTD + xTR + xTBODY + xTABLE + xTD +  xTR + xTBODY + xTABLE + xDIV + xTD + xTR;
 
  // and finally, close the table
  html += xTABLE;
 
  document.getElementById(datePickerDivID).innerHTML = html;
  // add an "iFrame shim" to allow the datepicker to display above selection lists
  adjustiFrame();
}


/**
Convenience function for writing the code for the buttons that bring us back or forward
a month.
*/
function getButtonCode(dateFieldName, dateVal, adjust, label)
{
  var newMonth = (dateVal.getMonth () + adjust) % 12;
  var newYear = dateVal.getFullYear() + parseInt((dateVal.getMonth() + adjust) / 12);
  if (newMonth < 0) {
    newMonth += 12;
    newYear += -1;
  }
 return "<a href='javascript:' style='-moz-user-select: none;' onClick='refreshDatePicker(\"" + dateFieldName + "\", " + newYear + ", " + newMonth + ");'></a>";
}


/**
Convert a JavaScript Date object to a string, based on the dateFormat and dateSeparator
variables at the beginning of this script library.
*/
function getDateString(dateVal)
{
  var dayString = "00" + dateVal.getDate();
  var monthString = "00" + (dateVal.getMonth()+1);
  dayString = dayString.substring(dayString.length - 2);
  monthString = monthString.substring(monthString.length - 2);
 
  switch (dateFormat) {
    case "dmy" :
      return dayString + dateSeparator + monthString + dateSeparator + dateVal.getFullYear();
    case "ymd" :
      return dateVal.getFullYear() + dateSeparator + monthString + dateSeparator + dayString;
    case "mdy" :
    default :
      return monthString + dateSeparator + dayString + dateSeparator + dateVal.getFullYear();
  }
}


/**
Convert a string to a JavaScript Date object.
*/
function getFieldDate(dateString)
{
  var dateVal;
  var dArray;
  var d, m, y;
 
  try {
    dArray = splitDateString(dateString);
    if (dArray) {
      switch (dateFormat) {
        case "dmy" :
          d = parseInt(dArray[0], 10);
          m = parseInt(dArray[1], 10) - 1;
          y = parseInt(dArray[2], 10);
          break;
        case "ymd" :
          d = parseInt(dArray[2], 10);
          m = parseInt(dArray[1], 10) - 1;
          y = parseInt(dArray[0], 10);
          break;
        case "mdy" :
        default :
          d = parseInt(dArray[1], 10);
          m = parseInt(dArray[0], 10) - 1;
          y = parseInt(dArray[2], 10);
          break;
      }
      dateVal = new Date(y, m, d);
    } else if (dateString) {
      dateVal = new Date(dateString);
    } else {
      dateVal = new Date();
    }
  } catch(e) {
    dateVal = new Date();
  }
 
  return dateVal;
}

function splitDateString(dateString)
{
  var dArray;
  if (dateString.indexOf("/") >= 0)
    dArray = dateString.split("/");
  else if (dateString.indexOf(".") >= 0)
    dArray = dateString.split(".");
  else if (dateString.indexOf("-") >= 0)
    dArray = dateString.split("-");
  else if (dateString.indexOf("\\") >= 0)
    dArray = dateString.split("\\");
  else
    dArray = false;
 
  return dArray;
}

function updateDateField(dateFieldName, dateString)
{
  var targetDateField = document.getElementsByName (dateFieldName).item(0);
  if (dateString)
    targetDateField.value = dateString;
 
  var pickerDiv = document.getElementById(datePickerDivID);
  pickerDiv.style.visibility = "hidden";
  pickerDiv.style.display = "none";
 
  adjustiFrame();
  
  if ((dateString) && (typeof(datePickerClosed) == "function"))
    datePickerClosed(targetDateField);
    
//judy
   jgetAjax(dateFieldName,dateString); 
   
}


/**
Use an "iFrame shim" to deal with problems where the datepicker shows up behind
selection list elements, if they're below the datepicker. The problem and solution are
described at:

http://dotnetjunkies.com/WebLog/jking/archive/2003/07/21/488.aspx
http://dotnetjunkies.com/WebLog/jking/archive/2003/10/30/2975.aspx
*/
function adjustiFrame(pickerDiv, iFrameDiv)
{
  var is_opera = (navigator.userAgent.toLowerCase().indexOf("opera") != -1);
  if (is_opera)
    return;
  
  // put a try/catch block around the whole thing, just in case
  try {
    if (!document.getElementById(iFrameDivID)) {
      var newNode = document.createElement("iFrame");
      newNode.setAttribute("id", iFrameDivID);
      newNode.setAttribute("src", "javascript:false;");
      newNode.setAttribute("scrolling", "no");
      newNode.setAttribute ("frameborder", "0");
      document.body.appendChild(newNode);
    }
    
    if (!pickerDiv)
      pickerDiv = document.getElementById(datePickerDivID);
    if (!iFrameDiv)
      iFrameDiv = document.getElementById(iFrameDivID);
    
    try {
      iFrameDiv.style.position = "absolute";
      iFrameDiv.style.width = pickerDiv.offsetWidth;
      iFrameDiv.style.height = pickerDiv.offsetHeight ;
      iFrameDiv.style.top = pickerDiv.style.top;
      iFrameDiv.style.left = pickerDiv.style.left;
      iFrameDiv.style.zIndex = pickerDiv.style.zIndex - 1;
      iFrameDiv.style.visibility = pickerDiv.style.visibility ;
      iFrameDiv.style.display = pickerDiv.style.display;
    } catch(e) {
    }
 
  } catch (ee) {
  }
 
}

//START CALENDAR.JS
        var cacheCount=0; // var that will restrict the user to not scroll beyond the given limit. 

        /*
        * java script method that make an ajax call to call the glob to load the calendar data of 
        * next / previous week.
        * @param Globing jsp path, Audience Type, Week no.
        */
        function getAjaxData(pagePath, audType, counter, cachePageCount)
        {
            var nextCachePageCount = cachePageCount;
            var prevCachePageCount = -cachePageCount;
            if(counter == 0)
                cacheCount = counter;
            else
                cacheCount = cacheCount+counter;

            var url = pagePath+".morecalendarinfo."+cacheCount+"."+audType+".html";
            if(cacheCount < nextCachePageCount) // Block for Next Link 
            {
                if(document.getElementById("nextlinkenabled") != null)
                    document.getElementById("nextlinkenabled").style.display = "block";
                if(document.getElementById("nextlinkdisabled") != null)
                    document.getElementById("nextlinkdisabled").style.display = "none";
                if(document.getElementById("rightimageicon") != null)
                    document.getElementById("rightimageicon").style.display = "block";
            }
            else
            {
                if(document.getElementById("nextlinkenabled") != null)
                    document.getElementById("nextlinkenabled").style.display = "none";
                if(document.getElementById("nextlinkdisabled") != null)
                    document.getElementById("nextlinkdisabled").style.display = "block";
                if(document.getElementById("rightimageicon") != null)
                    document.getElementById("rightimageicon").style.display = "none";
            }

            if(cacheCount > prevCachePageCount) // Block for Previous Link
            {
                if(document.getElementById("prevlinkenabled") != null)
                    document.getElementById("prevlinkenabled").style.display = "block";
                if(document.getElementById("prevlinkdisabled") != null)
                    document.getElementById("prevlinkdisabled").style.display = "none";
                if(document.getElementById("leftimageicon") != null)
                    document.getElementById("leftimageicon").style.display = "block";
            }
            else
            {
                if(document.getElementById("prevlinkenabled") != null)
                    document.getElementById("prevlinkenabled").style.display = "none";
                if(document.getElementById("prevlinkdisabled") != null)
                    document.getElementById("prevlinkdisabled").style.display = "block";
                if(document.getElementById("leftimageicon") != null)
                    document.getElementById("leftimageicon").style.display = "none";
            }
            // Loading ajax-wait-image while fetching the data...
            if(document.getElementById("ajaximage"))
                document.getElementById("ajaximage").style.display = "block";
            var data = Sling.httpGet(url).responseText;
            
            if(document.getElementById("calendarpart") != null)
                document.getElementById("calendarpart").innerHTML = data;
            
            expandsDiv('expndedDivID');
     }

        /*
        * java script method that make an ajax call to load the calendar data  
        */
        function getCalData(pagePath, audType, counter, cachePageCount,fromDt)
        {
            var newDt = fromDt.replace(/\//g,"_");
            var url ="";
            
            //judy , check this is on author or pub
            if(audType=="ALL"){
                  //wei added timestamp as query string to get rid of the ie browser cache for morecalendarinfonew.xx_xx_xxxx.html request
                  var ts = new Date().getTime(); 
                  url = pagePath+".morecalendarinfonew."+newDt +"."+audType+".html" +"?fromDate="+ts;
            }else{
                  url = pagePath+".morecalendarinfonew."+newDt +"."+audType+".html";
            }
            // Loading ajax-wait-image while fetching the data...
            if(document.getElementById("ajaximage"))
                document.getElementById("ajaximage").style.display = "block";
            var data = Sling.httpGet(url).responseText;
            
            if(document.getElementById("calendarpart") != null)
                document.getElementById("calendarpart").innerHTML = data;
               
            $('div',data).each(function(i){
                if($(this).hasClass('calendarday'))
                {
                    var calId = $(this).attr('id');
                    var calHTML = $("#"+calId+" div.restDetails").html();
                    if(calHTML != '' && calHTML !='</FORM>'){
                        divno = calId.substring(11,calId.length);
                        //alert("Div No. :: " + divno);
                        if(divno != "1")
                            showHideDay(divno);
                    }
                }
            });
 
     }


        
     /*
      * function that expands the date divisions having some data
     */
     
     function expandsDiv(divID)
     {
        // expanding the divisions having data
         if(document.getElementById(divID) != null)
         {
             var divDetail = document.getElementById(divID).innerHTML;
             
             if(null != divDetail)
             {
                var arrDivDetails = divDetail.split("$");
                
                for(index=0; index<arrDivDetails.length; index++)
                {
                    var param = arrDivDetails[index].split(",");
                    //alert("Param : " + param);
                    showOrHide(param[0],param[1],param[2],param[3],param[4],param[5]);
                }
             }
         }
     }


        /*
        * java script method that make an ajax call to call the glob to load the Notice Board data 
        * @param 
        */
        function getNBData(pagePath, audType, counter, cachePageCount,fromDt)
        {
            var newDt = fromDt.replace(/\//g,"_");
            
            //wei added timestamp as query string to get rid of the ie browser cache for morenoticeboardinfo.xx_xx_xxxx.html request
            var ts = new Date().getTime(); 
            var url = pagePath+".morenoticeboardinfo."+newDt +"."+audType+".html" +"?fromDate="+ts;

           // Loading ajax-wait-image while fetching the data...
            if(document.getElementById("ajaximg"))
                document.getElementById("ajaximg").style.display = "block";
            var data = Sling.httpGet(url).responseText;
            
            if(document.getElementById("nbpost") != null)
                document.getElementById("nbpost").innerHTML = data;
            
     }
        
     
     /*
      * Trim Function
      */
     String.prototype.trim = function() { return this.replace(/^\s+|\s+$/g, ""); };

        
    /*
     * The method is responsible in expanding or collapsing the height of division.
     */
    function showOrHide(mainId, eId, thisImg, open_close_text_div, open_close_img_div, state)
    {   
        try
        {
            mainId = mainId.trim();
            divmain = document.getElementById(mainId)
            if (e = document.getElementById(eId))
            {
                if (state == null)
                {
                    state = e.style.display == 'none';
                    if(state)
                    {
                        e.style.display = '';
                        divmain.style.height="auto";
                    }
                    else
                    {
                        e.style.display = 'none';
                        divmain.style.height="34px";
                    }
                }
            
                if (state == true){ 
                    
                    if(document.getElementById(open_close_text_div) != null)
                        document.getElementById(open_close_text_div).innerHTML = "close";
                    if(document.getElementById(open_close_img_div) != null)
                        document.getElementById(open_close_img_div).style.backgroundPosition="-50px -147px";
                }
                if (state == false)
                {
                    if(document.getElementById(open_close_text_div) != null)
                        document.getElementById(open_close_text_div).innerHTML = "open";
                    if(document.getElementById(open_close_img_div) != null)
                        document.getElementById(open_close_img_div).style.backgroundPosition="-50px -175px";
                }
                
                  
                resetColctrlHeight(); // Method is called to resize the height of page when divs expand/collapse
            }
        }
        catch(err)
        {}
        
    } 
    
     function showHideDay(divno)
    {     
            
            if($("#openclose"+divno).html()=="close"){
                $("#open_close_img_div"+divno).css("backgroundPosition","-50px -175px");
                $("#openclose"+divno).html("open");
                $("#activity"+divno).css("height","34px");
                $("#calendarday"+divno).hide();
                
            }else{
                $("#open_close_img_div"+divno).css("backgroundPosition","-50px -147px");
                $("#openclose"+divno).html("close");
                $("#activity"+divno).css("height","auto");
                $("#calendarday"+divno).show();
                
            }
            resetColctrlHeight(); // Method is called to resize the height of page when divs expand/collapse
    }
    
    //wei - added this for the more link on notice board
    function showHideEntry(divno, moreText)
    {     
            if(($("#moreopen"+divno).html()).indexOf(moreText)!=-1){
                // if($("#moreopen"+divno).html()=="More"){
                $("#moreopen"+divno).html("Close");
                $("#entries"+divno).css("height","auto");
                $("#entry"+divno).show();
                
            }else{
                $("#moreopen"+divno).html(moreText);
                // $("#moreopen"+divno).html("More");
                $("#entries"+divno).css("height","auto"); 
                $("#entry"+divno).hide();
                
            }
            
            for(var a=0;a<colctrlArray.length;a++) {
                var maxColHeight = 'auto';
                var colHeight = 0;
                var colPaddingTop = 0;
                var colPaddingBottom = 0;
                var distinctColID = 'main'+colctrlArray[a][0];          
                var columnNum = colctrlArray[a][1];
                            // to reset height of all columns to maxColHeight
                for(var j=0;j<columnNum;j++) {
                    var colID = distinctColID+j;
                    var col = document.getElementById(colID);
                    if(col)
                        col.style.height = maxColHeight;                    
                }
            }
                
            resetColctrlHeight(); // Method is called to resize the height of page when divs expand/collapse 
    }
    
       var calendarConfig;
       var calendarDialog;
       var calendarDialogValues;
       var pageHandle;
       var AUDIENCE_STAFF = "1";
       var AUDIENCE_FRANCHIEES = "4";
       var VIEW_AU = "4";
       var VIEW_NZ = "5";
       var CALENDAR_POSTING_TYPE = "1";
       var CALENDAR_CATEGORY_ID = "3000";
       var NOTICE_BOARD_POSTING_TYPE = "2";
       var NOTICE_BOARD_CATEGORY_ID = "4000";
       //var dialogValueUrl;
                         
       function openCalendarDialog(action, component, componentpath, uuid, startdate) {
           
           if (component == "calendar") {
               calendarConfig = CQ.WCM.getDialogConfig("/apps/mcd/components/content/calendarForRedesign/dialog");
           } else if (component == "noticeboard") {
               calendarConfig = CQ.WCM.getDialogConfig("/apps/mcd/components/content/noticeboard/dialog");
           }
           calendarDialog = CQ.WCM.getDialog(calendarConfig);
           calendarDialog.show();
           
            calendarDialog.refreshComponent=(function(){
               var comp=CQ.utils.WCM.getEditable(componentpath);
               if(comp!=null){
                   comp.refreshSelf();
               }else{
                   CQ.wcm.EditBase.refreshPage();
               }
           });
           
                 
           if (action == "add") {
               pageHandle=location.toString();
               var today = new Date();               
                
               calendarDialog.getField('./postingDate').setValue(today);
               calendarDialog.getField('./action').setValue(action);
               /* not crazy about this hard-coded path - should be a component-level setting Erik 3/14 */
               if (pageHandle.indexOf("/apmea/au") != -1) calendarDialog.getField('./viewAU').setValue(VIEW_AU);
               if (pageHandle.indexOf("/apmea/nz") != -1) calendarDialog.getField('./viewNZ').setValue(VIEW_NZ);
               if (component == "calendar") {
                             calendarDialog.getField('./postingType').setValue(CALENDAR_POSTING_TYPE);
                             calendarDialog.getField('./categoryId').setValue(CALENDAR_CATEGORY_ID);
               } else if (component == "noticeboard") {                             
                             calendarDialog.getField('./postingType').setValue(NOTICE_BOARD_POSTING_TYPE); 
                             calendarDialog.getField('./categoryId').setValue(NOTICE_BOARD_CATEGORY_ID);  
                             calendarDialog.getField('./startDate').setValue(startdate);      
               }
           }
              
           if (action == "edit") {
                
                  var dialogValueUrl=CQ.HTTP.noCaching('/content/utility/utility.getdialogvalues.html?component='+component+'&uuid='+uuid);
                  calendarDialogValues = CQ.Util.formatData(CQ.HTTP.eval(CQ.HTTP.get(dialogValueUrl)));   
                 // alert("testing=" + calendarDialogValues[0].title);
                              
                 calendarDialog.getField('./postingDate').setValue(calendarDialogValues[0].postingDate);
                 calendarDialog.getField('./title').setValue(calendarDialogValues[0].title); 
                 calendarDialog.getField('./audienceStaff').setValue(calendarDialogValues[0].audienceStaff);
                 calendarDialog.getField('./linkStaff').setValue(calendarDialogValues[0].linkStaff);
                 calendarDialog.getField('./displayStaff').setValue(calendarDialogValues[0].displayStaff);                                      
                 calendarDialog.getField('./audienceFranchiees').setValue(calendarDialogValues[0].audienceFranchiees);
                 calendarDialog.getField('./linkFranchiees').setValue(calendarDialogValues[0].linkFranchiees);
                 calendarDialog.getField('./displayFranchiees').setValue(calendarDialogValues[0].displayFranchiees);
                 calendarDialog.getField('./viewAU').setValue(calendarDialogValues[0].viewAU);
                 calendarDialog.getField('./viewNZ').setValue(calendarDialogValues[0].viewNZ);
                 calendarDialog.getField('./postingType').setValue(calendarDialogValues[0].postingType);
                 calendarDialog.getField('./categoryId').setValue(calendarDialogValues[0].categoryId);
                 calendarDialog.getField('./action').setValue(calendarDialogValues[0].action);
                 calendarDialog.getField('./uuid').setValue(calendarDialogValues[0].uuid);
                                         
                 if (component == "noticeboard") {
                     calendarDialog.getField('./description').setValue(calendarDialogValues[0].description);
                     calendarDialog.getField('./prefix').setValue(calendarDialogValues[0].prefix); 
                     calendarDialog.getField('./startDate').setValue(startdate);               
                 }
            }
       }       
            
//wei opening dialog for adding or editing   
       function confirmDelete(uuid,componentpath) {
          var msg = "Are you sure you want to delete?";
  
          if ( confirm(msg) ) {
              
              CQ.HTTP.get('/mcd/accessmcd/aucalnbservlet/AUCalendarInsertPost?action=delete&uuid=' + uuid,
                  function(){
                   var comp=CQ.utils.WCM.getEditable(componentpath);
                   if(comp!=null){
                       comp.refreshSelf();
                   }else{
                       CQ.wcm.EditBase.refreshPage();
                   }
                   });
          }
          
       }
   
    
    
    
    