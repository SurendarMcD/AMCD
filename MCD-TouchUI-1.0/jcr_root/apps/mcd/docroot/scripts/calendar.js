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
   
    
    
    
    