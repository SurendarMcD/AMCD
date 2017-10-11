        var cacheCount=0; // var that will restrict the user to not scroll beyond the given limit.

        /*
        * java script method that make an ajax call to call the glob to load the calendar data of 
        * next / previous week.
        * @param Globing jsp path, Audience Type, Week no.
        */

        function getPosts(audType, view, pagePath,startTime,endTime)
        {
/*
            var nextCachePageCount = cachePageCount;
            var prevCachePageCount = -cachePageCount;
            if(counter == 0)
                cacheCount = counter;
            else
                cacheCount = cacheCount+counter;
*/
//            var url = "/utility/utility.disppost.html?stTime="+startTime+"&edTime="+endTime+"&autype="+audType+"&vw="+view;
//alert("pagePath ::"+pagePath);
//            var url = pagePath+".disppost.html?stTime="+startTime+"&edTime="+endTime+"&autype="+audType+"&vw="+view;

            var newDts = startTime.replace(/\//g,"_");
            var newDte = endTime.replace(/\//g,"_");
            var url = pagePath+".disppost."+newDts+"."+newDte+"."+audType+"."+view+".html";


           // Loading ajax-wait-image while fetching the data...
            if(document.getElementById("ajaximg"))
                document.getElementById("ajaximg").style.display = "block";
            var data = Sling.httpGet(url).responseText;
            
            if(document.getElementById("archivedpost") != null)
                document.getElementById("archivedpost").innerHTML = data;
            
            expandsDiv('expndDivID');
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
         }
     }
     
     /*
      * Trim Function
      */
     String.prototype.trim = function() { return this.replace(/^\s+|\s+$/g, ""); };

        
