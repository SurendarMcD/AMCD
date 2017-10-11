/**
 *  Plugin which is applied on a list of img objects and calls
 *  the specified callback function, only when all of them are loaded (or errored).
 *  @author:  H. Yankov (hristo.yankov at gmail dot com)
 *  @version: 1.0.0 (Feb/22/2010)
 *  http://yankov.us
 */

$.fn.batchImageLoad = function(options) {
    var images = $(this);
    var originalTotalImagesCount = images.size();
    var totalImagesCount = originalTotalImagesCount;
    var elementsLoaded = 0;

    // Init
    $.fn.batchImageLoad.defaults = {
        loadingCompleteCallback: null, 
        imageLoadedCallback: null
    }
    var opts = $.extend({}, $.fn.batchImageLoad.defaults, options);
        
    // Start
    images.each(function() {
        // The image has already been loaded (cached)
        if ($(this)[0].complete) {
            totalImagesCount--;
            if (opts.imageLoadedCallback) opts.imageLoadedCallback(elementsLoaded, originalTotalImagesCount);
        // The image is loading, so attach the listener
        } else {
            $(this).load(function() {
                elementsLoaded++;
                
                if (opts.imageLoadedCallback) opts.imageLoadedCallback(elementsLoaded, originalTotalImagesCount);

                // An image has been loaded
                if (elementsLoaded >= totalImagesCount)
                    if (opts.loadingCompleteCallback) opts.loadingCompleteCallback();
            });
            $(this).error(function() {
                elementsLoaded++;
                
                if (opts.imageLoadedCallback) opts.imageLoadedCallback(elementsLoaded, originalTotalImagesCount);
                    
                // The image has errored
                if (elementsLoaded >= totalImagesCount)
                    if (opts.loadingCompleteCallback) opts.loadingCompleteCallback();
            });
        }
    });

    // There are no unloaded images
    if (totalImagesCount <= 0)
        if (opts.loadingCompleteCallback) opts.loadingCompleteCallback();
};

   


//changed to be called only after batchImageLoad plugin has executed
//Hemant Bellani 06-02-2011

function resetColctrlHeightCallback(){
    
    
    for(var a=0;a<colctrlArray.length;a++) {
        
        var maxColHeight = 0;
        var colHeight = 0;
        var colPaddingTop = 0;
        var colPaddingBottom = 0;
        var distinctColID = 'main'+colctrlArray[a][0];          
        var columnNum = colctrlArray[a][1];


        // to find max height column 
        for(var i=0;i<columnNum;i++) {
            var colID = distinctColID+i;
            var linkColor = $("#" + colID + " a").css("color");   
            var columnColor = $("#" + colID).css("background-color");

            if(linkColor == columnColor) {
                $("#" + colID + " a").css("color","#FFFFFF");
                $("#" + colID + " a.commentAuthorLink").css("color", linkColor); 
            }

            var col = document.getElementById(colID);
            if(col){
                col.style.height = 'auto';
                colHeight = col.scrollHeight;//get image height                
                if (colHeight > maxColHeight) { 
    
                    maxColHeight = colHeight; 
                
                    colPaddingTop = $(col).css("padding-top");
                    colPaddingTop = colPaddingTop.substring(0,(colPaddingTop.length)-2);
                    
                    colPaddingBottom = $(col).css("padding-bottom");
                    colPaddingBottom = colPaddingBottom.substring(0,(colPaddingBottom.length)-2);
                }
            }
        }
        var browser = navigator.appName;
        var url = location.href;
        if(url.indexOf(".print.html")!=-1 && browser == "Microsoft Internet Explorer")
        {
            maxColHeight = maxColHeight;
        }
        else
        {
            maxColHeight = maxColHeight - colPaddingTop - colPaddingBottom ;
        }
    
        // to reset height of all columns to maxColHeight
        for(var j=0;j<columnNum;j++) {
            var colID = distinctColID+j;
            var col = document.getElementById(colID);
            if(col);
                //col.style.height = maxColHeight+'px';                
        }
    }    
} 
function resetColctrlHeight(){

   $('img').batchImageLoad({ 
    loadingCompleteCallback: resetColctrlHeightCallback
    });   
}

/*
function resetColctrlHeight() {
    
    for(var a=0;a<colctrlArray.length;a++) {
        var maxColHeight = 0;
        var colHeight = 0;
        var colPaddingTop = 0;
        var colPaddingBottom = 0;
        var distinctColID = 'main'+colctrlArray[a][0];          
        var columnNum = colctrlArray[a][1];
    
        // to find max height column 
        for(var i=0;i<columnNum;i++) {
            var colID = distinctColID+i;
            var col = document.getElementById(colID);
            if(col){
                colHeight = col.scrollHeight;//get image height
                
                if (colHeight > maxColHeight) { 
    
                    maxColHeight = colHeight; 
                
                    colPaddingTop = $(col).css("padding-top");
                    colPaddingTop = colPaddingTop.substring(0,(colPaddingTop.length)-2);
                    
                    colPaddingBottom = $(col).css("padding-bottom");
                    colPaddingBottom = colPaddingBottom.substring(0,(colPaddingBottom.length)-2);
                }
            }
        }
        var browser = navigator.appName;
        var url = location.href;
        if(url.indexOf(".print.html")!=-1 && browser == "Microsoft Internet Explorer")
        {
            maxColHeight = maxColHeight;
        }
        else
        {
            maxColHeight = maxColHeight - colPaddingTop - colPaddingBottom ;
        }
    
        // to reset height of all columns to maxColHeight
        for(var j=0;j<columnNum;j++) {
            var colID = distinctColID+j;
            var col = document.getElementById(colID);
            if(col)
                col.style.height = maxColHeight+'px';
        }
    }
}
*/ 