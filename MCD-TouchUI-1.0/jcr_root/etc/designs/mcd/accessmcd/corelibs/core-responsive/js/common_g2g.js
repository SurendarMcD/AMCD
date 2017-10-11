//Global Variables 

var JSinclude=0;
var BookMarkDisplay = 0;
var awesomeRetryCount = 0;
var NavJSONobject = null;
//render content through ajax
 
function getPageContent(url, div, errormsg) {
    $.ajax({
        url: url,
        type: 'GET',     
        timeout: 120000,
        data: '', 
        cache: true,    
        error: function(){
              //  alert(errormsg);    
        },    
        success: function(xml){                                      
                $(div).html(xml); 
                $("#footerBookmarksAction").mcdColorbox({ iframe: true, innerWidth: 550, innerHeight: 262 });  
                // function to reset heights of columns
                resetColctrlHeight();                   
            }
    });
}
function checkDiv() {
    var awesome=  $( "#headerwrap #topheader" ).html();
    console.log("Awesome HTML :: " + awesome);
    var nav = $( "#headerwrapper #mainNavMenuContainer ul#mainNavMenu li" ).html();
    console.log("Nav HTML ::" + nav);
    if(awesome=="" || nav=="&nbsp;"){ 
    window.location.reload(true); }
    }
function changeSize(img,size)
{
    if(size!=1.0)
    {
        var width=(img.width*size);
        img.width=width;
    } 
}

function checkedit(element){
    var el=element; 
} 
 
$.widget( "custom.catcomplete", $.ui.autocomplete, {
    _create: function() {
      this._super();
      this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
    },
    _renderMenu: function( ul, items ) {
      var that = this,
        currentCategory = "";
      $.each( items, function( index, item ) {
        var li;
        if ( item.category != currentCategory ) {
          ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        li = that._renderItemData( ul, item );
        /*if ( item.category ) {
          li.attr( "aria-label", item.category + " : " + item.label );
        }*/
      });
    }
  });
// --------------------------------------------------------------------------
// setupSearchAutocomplete(market, userrole)
//  This method creates autocomplete url for the autocopmlete utility of jQuery.
//  The autocomplete url consists of Suggestion Servlet url, for fetching 
//  keyword suggestion from DB, and other parameters required by the servlet.
//  The url is then passed to autocomplete function with other jQuery parameters.
//  Also, when any suggestion is seleted then the query text is automatically
//  submitted to search application for fetching search results. 
//  Updated 9/20/12 ECW for Enhanced Search Suggestions

// --------------------------------------------------------------------------


var loadedterm="zzz";
        
      
function getData(response, term){
if(term.length<2)return false;
var lcterm=term.toLowerCase();

if(term.length>1 && lcterm.indexOf(loadedterm)!=0){

var svpId = UserInfoObject.view;
var userRole = UserInfoObject.mcdAudienceGlob;     
var suggesturl=UserInfoObject.viewPath+"/util/searchsuggestions.searchsuggestions."+UserInfoObject.view+"."+UserInfoObject.alias+"."+lcterm.substring(0,2)+".html";

    $.ajax(
        {url: suggesturl,
        dataType: "json"
        }
    ).complete(function(data){
    loadedterm=lcterm;
    suggestions=eval(data.responseText);
    //alert(suggestions.length);
    response(filterData(lcterm));
    });
}else{
    response(filterData(lcterm));
}
}

function filterData(term){

if(term.length<1)return false;
var nSites=0;
var nSearches=0;
return $.grep(suggestions,function(a){
  if(nSites>4 && nSearches>4) return false;
  if(typeof a.keywords != 'undefined' &&  a.keywords.indexOf('|'+term)>-1){
      if(a.category=="Sites"){
          if(nSites>4) return false;
          nSites++;
      }
      if(a.category=="Searches"){
          if(nSearches>4) return false;
          nSearches++;
      }
      if(typeof a.value == 'undefined')a.value=a.label;
      return true;
  }
  return false;
});

}


function logSuggestionClick(query,url){
    
    var suggestionlogurl="/content/utility/utility.searchlogger.html?query="+query+"&mkt="+UserInfoObject.view+"&role="+UserInfoObject.mcdAudience+"&url="+url;
    //alert(suggestionlogurl);
    $.ajax({
        url: suggestionlogurl,
        type: 'GET'
        });
      
    //alert('pause');
}



function setupSearchAutocomplete(market, userrole) { 
    

        
$(".desktop-header #txt_search").catcomplete({
    delay: 0,
    source: function( request, response ) {
    getData(response, request.term);
},
select: function( event, ui ) {
    if(ui.item.value.indexOf("/")==0 || ui.item.value.indexOf("http")==0 || ui.item.value.indexOf("newwin")==0){
        var url=ui.item.value;
        var newwin=false;
        if(url.indexOf("newwin")==0){
            newwin=true;
            url=url.substring(6);
        }
        if(url.indexOf("/accessmcd/")==0)url="https://www.accessmcd.com"+url;
        logSuggestionClick($('.desktop-header #txt_search').val(),url);
        if(newwin){
            window.open(url,"","height=600,width=800,resizable=1,menubar=1");
            ui.item.value="";
            return true;
        }else{
            setTimeout("goToSite('"+url+"')",1000);
        }
        ui.item.value="";
        return false;
     }else{
         $('.desktop-header #txt_search').val(ui.item.value);
         $('.desktop-header #searchForm').submit();
     }
},
    focus: function( event, ui ) {if(ui.item.value.indexOf("/")==0 || ui.item.value.indexOf("http")==0 || ui.item.value.indexOf("newwin")==0)return false;} 
});

$(".mobile-header #txt_search").catcomplete({
    delay: 0,
    source: function( request, response ) {
    getData(response, request.term);
},
select: function( event, ui ) {
    if(ui.item.value.indexOf("/")==0 || ui.item.value.indexOf("http")==0 || ui.item.value.indexOf("newwin")==0){
        var url=ui.item.value;
        var newwin=false;
        if(url.indexOf("newwin")==0){
            newwin=true;
            url=url.substring(6);
        }
        if(url.indexOf("/accessmcd/")==0)url="https://www.accessmcd.com"+url;
        logSuggestionClick($('.mobile-header #txt_search').val(),url);
        if(newwin){
            window.open(url,"","height=600,width=800,resizable=1,menubar=1");
            ui.item.value="";
            return true;
        }else{
            setTimeout("goToSite('"+url+"')",1000);
        }
        ui.item.value="";
        return false;
     }else{
         $('.mobile-header #txt_search').val(ui.item.value);
         $('.mobile-header #searchForm1').submit();
     }
},
    focus: function( event, ui ) {if(ui.item.value.indexOf("/")==0 || ui.item.value.indexOf("http")==0 || ui.item.value.indexOf("newwin")==0)return false;} 
});



}   
  
function goToSite(url){
    window.location.href=url;
}  



function getAwesomeBarData(audienceType, view, uname, uid, userEmail, designPath, mcdAudience,currentPagePath)  
    {    
        
        var displayType="g2gDesign"; 
        var path=currentPagePath;
        var displaylength = $('#awesomedesign').length;
        var pathLength = $('#path').length;
        if(pathLength>0){
            path=document.getElementById('path').value;
        }
        if(displaylength>0){
            displayType = document.getElementById('awesomedesign').value;
        }
         
        if((path.indexOf("/apmea/au") != -1 )|| (path.indexOf("/apmea/nz") != -1) ){
           //retrieve data from awesome.jsp 
            var glob = "awesome." + audienceType +awesomeRetryCount+ "." + view; 
            var url = UserInfoObject.viewPath + '.'+glob+'.html'; 
        }
        else{
            var glob = "slimawesomebar." + audienceType +awesomeRetryCount+ "." + view; 
            var url = UserInfoObject.viewPath + '.'+glob+'.html'; 
        }
       $.ajax({
        url: url,
        type: 'GET',     
        timeout: 10000,
        data: '', 
        cache: true,    
        error: function(){
            if(document.getElementById('topheader')!=null) {
                   document.getElementById('topheader').innerHTML='Error retrieving Awesome Bar. Try again.';                             
            }
            window.location.reload(true);
            awesomeRetryCount++;  
            if(awesomeRetryCount<5)getAwesomeBarData(audienceType, view, uname, uid, userEmail, designPath, mcdAudience,currentPagePath); 
        },    
        success: function(xml){                                      
            if(xml.indexOf("HTTP 500")>-1){
               if(awesomeRetryCount<5){
                   getAwesomeBarData(audienceType, view, uname, uid, userEmail, designPath, mcdAudience,currentPagePath);

               }/*else{
                   checkDiv();
                   //document.getElementById('topheader').innerHTML="<font color='red'>Error loading Awesome Bar.  Please refresh your browser.</font>";  
               }*/
            }else{
                if(document.getElementById('topheader')!=null) {
                    document.getElementById('topheader').innerHTML=xml;              
                    setAwesomeBarContent(currentPagePath, view, uname, uid, userEmail, designPath,displayType); 
                    setupSearchAutocomplete(view, mcdAudience);  
                                
                } 
            } 
            $('#wrapToplinks ul li:last-child').addClass('lastLI');
            $('.searched_wrapper ul li:last-child').addClass('lastLI');
        }
        });

      
    }
function getResponsiveAwesomeBarData(audienceType, view, uname, uid, userEmail, designPath, mcdAudience,currentPagePath){    
        var displayType="g2gDesign"; 
        var path=currentPagePath;
        var displaylength = $('#awesomedesign').length;
        var pathLength = $('#path').length;
        
        var template = $("#template").html(); 
        //alert("Template Name :: " + template); 
        
        if(pathLength>0){
            path=document.getElementById('path').value;
        }
        if(displaylength>0){
            displayType = document.getElementById('awesomedesign').value;
        }
         
        if((path.indexOf("/apmea/au") != -1 )|| (path.indexOf("/apmea/nz") != -1) ){
           //retrieve data from awesome.jsp 
            var glob = "awesome." + audienceType +awesomeRetryCount+ "." + view; 
            var url = UserInfoObject.viewPath + '.'+glob+'.html'; 
        }
        else{
            var glob = "responsiveslimawesomebar." + audienceType +awesomeRetryCount+ "." + view; 
            var url = UserInfoObject.viewPath + '.'+glob+"."+template+'.html'; 
        }
        //alert("Responsive Awesomebar :: " + url);
       $.ajax({
        url: url,
        type: 'GET',     
        timeout: 10000,
        data: '', 
        cache: true,    
        error: function(){
            if(document.getElementById('responsiveheader')!=null) {
                   document.getElementById('responsiveheader').innerHTML='Error retrieving Awesome Bar. Try again.';                             
            }
            //window.location.reload(true);
            awesomeRetryCount++;  
            if(awesomeRetryCount<5)getResponsiveAwesomeBarData(audienceType, view, uname, uid, userEmail, designPath, mcdAudience,currentPagePath); 
        },    
        success: function(xml){                                      
            if(xml.indexOf("HTTP 500")>-1){
               if(awesomeRetryCount<5){
                   getResponsiveAwesomeBarData(audienceType, view, uname, uid, userEmail, designPath, mcdAudience,currentPagePath);

               }/*else{
                   checkDiv();
                   //document.getElementById('topheader').innerHTML="<font color='red'>Error loading Awesome Bar.  Please refresh your browser.</font>";  
               }*/
            }else{
                if(document.getElementById('responsiveheader')!=null) {
                    document.getElementById('responsiveheader').innerHTML=xml;   
                    setResponsiveAwesomeBarContent(currentPagePath, view, uname, uid, userEmail, designPath,displayType); 
                    setupSearchAutocomplete(view, mcdAudience);  
                                
                } 
            } 
            //$('#wrapToplinks ul li:last-child').addClass('lastLI');
            //$('.searched_wrapper ul li:last-child').addClass('lastLI');
        }
        });

      
}     
    
    //previous initialize function location


//function used to create tree structure in navigation bar
function TreeItem(lbl,path,theme){
  this.highlight="yellow";
  this.highlightParents=true;
    this.label=lbl;
    this.level=0;
    this.url=path;
    this.parent="";
    this.children=[];
    this.selected=false;
    this.childselected=false;
    this.id=Math.random();
    this.theme="red";
    if(theme)this.theme=theme;
    this.add=function(lbl,path,theme){
        var a=new TreeItem(lbl,path);
        a.highlight=this.highlight;
        a.highlightParents=this.highlightParents;
        a.level=this.level+1;
        if(theme){
            a.theme=theme;
        }else{
            a.theme=this.theme;
        }
        this.children.push(a);
        a.parent=this;
        return a;
    }
    
  this.findSelected=function(inurl){
    var selNode=null;
    if(this.selected)return this;
    for(var c in this.children){
                selNode=this.children[c].findSelected(inurl);
                if(selNode!=null)return selNode;
        }
    return selNode;
    }
    this.updateSelected=function(inurl,includechildren){
        this.selected=false;
        this.childselected=false;
        if(this.url==inurl)
            this.selected=true;
        if(this.highlightParents && this.level>0 && inurl.indexOf(this.url)==0){
            this.childselected=true;
            if (this.level>1)
                this.parent.childselected=true; 
        }   
        if(includechildren)
            for(var c in this.children){
                if(this.children[c].label != undefined) { 
                    this.children[c].updateSelected(inurl,includechildren);
                } 
            }
    }
      
}

function getXMLObject()  //XML OBJECT
{
   var xmlHttp = false;
   try { 
     xmlHttp = new ActiveXObject("Msxml2.XMLHTTP")  // For Old Microsoft Browsers
   }
   catch (e) {
     try {
       xmlHttp = new ActiveXObject("Microsoft.XMLHTTP")  // For Microsoft IE 6.0+
     }
     catch (e2) {
       xmlHttp = false   // No Browser accepts the XMLHTTP Object then false
     }
   }
   if (!xmlHttp && typeof XMLHttpRequest != 'undefined') {
     xmlHttp = new XMLHttpRequest();        //For Mozilla, Opera Browsers
   }
  
 
   return xmlHttp;  // Mandatory Statement returning the ajax object created
}

function headerAjaxFunction(url) {   
    
  if(headerxmlhttp) {  
    var servletURL = url; 
    headerxmlhttp.open("GET",servletURL,false); //getname will be the servlet name    
    headerxmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    headerxmlhttp.send(""); 
    headerHandleServerResponse();
  }
  
}
function sectionShowHide(obj, siblingClass, isShow, isAddClass) {
    var subSection = null, activeLinkObj = null;
    if (obj[0].className !== siblingClass) {
        subSection = obj.siblings('.' + siblingClass);
        activeLinkObj = obj;
    } else {
        subSection = obj;
        activeLinkObj = obj.siblings('a');
    }
    isAddClass ? activeLinkObj.addClass("active") : activeLinkObj.removeClass("active");
    isShow ? subSection.show() : subSection.hide();
}
function compAjaxFunction(url,cfunc)
{
   
        try { 
            compXmlHttp = new ActiveXObject("Msxml2.XMLHTTP")  // For Old Microsoft Browsers
        }
        catch (e) {
            try {
                compXmlHttp = new ActiveXObject("Microsoft.XMLHTTP")  // For Microsoft IE 6.0+
            }
            catch (e2) {
                compXmlHttp = false   // No Browser accepts the XMLHTTP Object then false
            }
        }
        if (!compXmlHttp && typeof XMLHttpRequest != 'undefined') {
            compXmlHttp = new XMLHttpRequest();        //For Mozilla, Opera Browsers
        }

    compXmlHttp.onreadystatechange=cfunc;
    compXmlHttp.open("GET",url,true);
    compXmlHttp.send();
}
function setResponsiveAwesomeBarContent(currentPagePath, view, uname, uid, userEmail, currentDesignPath,displayType){
    var currentPath = currentPagePath.replace("/content/", "/");
    var type=displayType;
     if(type=="g2gDesign"){   
        //display user name and audience type in awesome bar  
        $("#userName #user").html(uname + "&nbsp;-&nbsp;" + $("#userName  ").html());      
     }
     else{
      $(".ribbon #user").html(uname);
     }   
    
    $('#mrkt-View, .top-subNav').on('click mouseover ', function(e) {
        //e.preventDefault();
        sectionShowHide($(this), 'top-subNav', true);
    }).on('click mouseout', function() {
        sectionShowHide($(this), 'top-subNav', false);
    });
    
    $('#mySiteLinksList, .top-subNavBookmark').on('click mouseover ', function(e) {
        //e.preventDefault();
        sectionShowHide($(this), 'top-subNavBookmark', true);
    }).on('click mouseout', function() {
        sectionShowHide($(this), 'top-subNavBookmark', false);
    });
    
    $("#footerBookmarksAction").mcdColorbox({ iframe: true, innerWidth: 610, innerHeight: 350});  
    
    //hiding share flyout        
    if($('#share').length!=0) {
        $('#share_flyout').hide();         
    }
    //setting position for my bookmarks drop down    
    /*if($('#li_mysite').length!=0) {    
        var _bookmarksLeft = $('#li_mysite').position().left - 10;
        var _bookmarksTop = $('#li_mysite').position().top + 13;
        $('#bookmarksList').css('left', _bookmarksLeft); 
        $('#bookmarksList').css('top', _bookmarksTop); 
    }*/
    
    //display dropdown of my bookmarks on hover
    $('#li_mysite').mouseenter(function() {
        BookMarkDisplay =0;
        $("#dropdownList").css("display","none");   
        showMySiteRecord(currentPagePath, uid, view,'li_mysite','bookmarksList');        
    });    
   
    //hide my bookmarks dropdown 
    $('#li_mysite').mouseleave(function() {
       $('#bookmarksList').hide() ; 
       BookMarkDisplay =1;
    }); 
    
    //updating feedback link
    if($('#feedbackLink').length!=0) {    
        var feedbackHref = $('#feedbackLink a').attr("href"); 
        feedbackHref = feedbackHref.replace("userEmail",userEmail); 
        feedbackHref = feedbackHref.replace("userID",uid); 
        feedbackHref = feedbackHref.replace("userName",uname); 
        $('#feedbackLink a').attr("href", feedbackHref);
    } 
    
    //updating print link 
    if($('.printLink').length!=0) {
        var printLocation=location.href;
        var printLocationFirst=printLocation.substring(0,printLocation.lastIndexOf("/")+1);              
        var printLocationSecond=printLocation.substring(printLocation.lastIndexOf("/")+1);
        var printLocationSplit=printLocationSecond.split(".");        
        var count=printLocationSplit.length;
        $('.printLink').attr("href",printLocationFirst+printLocationSplit[0]+".print."+printLocationSplit[count-1]+"?wcmmode=disabled"); 
    } 
    
    /******Share Email******/
    $(".shareEmailAction").click(function(){
       openEmailWin(currentPagePath,'','name'); 
     });  
    
    (function($){
    $(".sharebookmarksAction").attr("href", currentPagePath.replace("/content/", "/") + ".addtobookmark.html"); 
    
    /*setting colorbox for sending email*/
    $(".shareEmailAction").mcdColorbox({ iframe: true, innerWidth: 610, innerHeight: 450 });  
    
    //setting colorbox for adding bookmarks 
    $(".sharebookmarksAction").mcdColorbox({ iframe: true, innerWidth: 550, innerHeight: 262 });
    })(jQuery);
    //Show share options like email, add to bookmarks and get link
    $('#share').mouseenter(function() {
        var _left_alt = $('#share').position().left - 85; // 135;
        var _top_alt = $('#share').position().top + 5;
        
        var _dims_alt = {
            'top':  _top_alt + 'px',
            'left': _left_alt + 'px'                
        }
        
        $('#share_flyout').css(_dims_alt);
        show_share(); 
    });
    
    //Hide share options   
    $('#share').mouseleave(function() { 
        hide_share();  
    });
    

    //hover effect on go button available in search
    $("#go_button").attr("src",currentDesignPath + "/images/search.jpg");
        
    
    $("#globe_icon").click(function(){
        $("#dropdown").css("display","block");
        $("#searchalert").hide();
    }); 
     //$("#dropdownList").css('min-width', $("#userRole").width()) ;   
    //$("#dropdownList").css("width", "auto");   
    //$("#dropdownList").css("display","block");
    //$("#dropdownList").css('left', $('#userRole').position().left + $('#userRole').width() - $('#dropdownList').width() - 8) ;
    $("#dropdownList").css("display","none");
        
    /*$('#topheader ul li.viewSwitcher').mouseenter(function() {   
        $("#dropdownList").css("width", "auto");
        $("#dropdownList").css("display","block");
        $('#bookmarksList').hide() ; 
    });

    $('#topheader ul li.viewSwitcher').mouseleave(function() {
       $("#dropdownList").css("display","none"); 
    });*/
    
      
   
    $(".desktop-header .select_code .sugBox").click(function(){
        $(".desktop-header #search-criteria").toggle();
    });
    
    $(".desktop-header .text-left li").click(function(){
        $('.desktop-header .select_code .searchoption1').html($(this).find('.searchoption').html());
        $(".desktop-header #search-criteria").hide();  
        
        var id = $(this).attr('id');
        if(id == 'view'){
            setCookie('myCookie','1', 1);
            $(".desktop-header #selSites").attr("value","default");
            $(".desktop-header #SearchSiteURL").attr("value", "default");
        }
        if(id == 'all'){
            setCookie('myCookie','2', 1);
            $(".desktop-header #selSites").attr("value","");   
            $(".desktop-header #SearchSiteURL").attr("value", "default");      
        } 
        if(id == 'site'){
            setCookie('myCookie','3', 1);
            $(".desktop-header #SearchSiteURL").attr("value", currentPagePath); 
            $(".desktop-header #selSites").attr("value","default"); 
        } 
    
    });
    
    var x = getCookie('myCookie'); 
    if(x == '1'){
        $('.desktop-header .select_code .searchoption1').html($('#view .searchoption').html());
        $(".desktop-header #selSites").attr("value","default");   
        $(".desktop-header #SearchSiteURL").attr("value", "default");     
    }
    if(x == '2'){
        $('.desktop-header .select_code .searchoption1').html($('#all .searchoption').html());
        $(".desktop-header .selectLabel").html($("#all").html());
        $(".desktop-header #selSites").attr("value","");   
        $(".desktop-header #SearchSiteURL").attr("value", "default");     
    }
    if(x == '3' ){
        $('.desktop-header .select_code .searchoption1').html($('#site .searchoption').html());
        $(".desktop-header .selectLabel").html($("#site").html());
        $(".desktop-header #SearchSiteURL").attr("value", currentPagePath); 
        $(".desktop-header #selSites").attr("value","default");
    } 
    //MOBILE SEARCH
    $(".mobile-header .select_code .sugBox").click(function(){
        $(".mobile-header #search-criteria").toggle();
    });
    
    $(".mobile-header .text-left li").click(function(){
        $('.mobile-header .select_code .searchoption1').html($(this).find('.searchoption').html());
        $(".mobile-header #search-criteria").hide();  
        
        var id = $(this).attr('id');
        if(id == 'view'){
            setCookie('myCookie','1', 1);
            $(".mobile-header #selSites").attr("value","default");
            $(".mobile-header #SearchSiteURL").attr("value", "default");
        }
        if(id == 'all'){
            setCookie('myCookie','2', 1);
            $(".mobile-header #selSites").attr("value","");   
            $(".mobile-header #SearchSiteURL").attr("value", "default");      
        } 
        if(id == 'site'){
            setCookie('myCookie','3', 1);
            $(".mobile-header #SearchSiteURL").attr("value", currentPagePath); 
            $(".mobile-header #selSites").attr("value","default"); 
        } 
    
    });
    
    var x = getCookie('myCookie'); 
    if(x == '1'){
        $('.mobile-header .select_code .searchoption1').html($('#view .searchoption').html());
        $(".mobile-header #selSites").attr("value","default");   
        $(".mobile-header #SearchSiteURL").attr("value", "default");     
    }
    if(x == '2'){
        $('.mobile-header .select_code .searchoption1').html($('#all .searchoption').html());
        $(".mobile-header .selectLabel").html($("#all").html());
        $(".mobile-header #selSites").attr("value","");   
        $(".mobile-header #SearchSiteURL").attr("value", "default");     
    }
    if(x == '3' ){
        $('.mobile-header .select_code .searchoption1').html($('#site .searchoption').html());
        $(".mobile-header .selectLabel").html($("#site").html());
        $(".mobile-header #SearchSiteURL").attr("value", currentPagePath); 
        $(".mobile-header #selSites").attr("value","default");
    }
    
    //setting colorbox for sending email  
    (function($){
    $(".shareEmailAction").mcdColorbox({ iframe: true , innerWidth: "610", innerHeight: "450" }); 
    })(jQuery);
    
     
    //setting colorbox for adding bookmarks 
   // $(".sharebookmarksAction").mcdColorbox({ iframe: true , innerWidth: "550", innerHeight: "262"});
     
}  
function setAwesomeBarContent(currentPagePath, view, uname, uid, userEmail, currentDesignPath,displayType)  
{
    var currentPath = currentPagePath.replace("/content/", "/");
    var type=displayType;
     if(type=="g2gDesign"){   
        //display user name and audience type in awesome bar  
        $("#userName #user").html(uname + "&nbsp;-&nbsp;" + $("#userName  ").html());      
     }
     else{
      $("#topLeftLinks #user").html(uname);
     }   
    //hiding share flyout        
    if($('#share').length!=0) {
        $('#share_flyout').hide();         
    }
    
    //setting position for my bookmarks drop down    
   if($('#li_mysite').length!=0) {    
        var _bookmarksLeft = $('#li_mysite').position().left - 10;
        var _bookmarksTop = $('#li_mysite').position().top + 13;
        $('#bookmarksList').css('left', _bookmarksLeft); 
        $('#bookmarksList').css('top', _bookmarksTop); 
    }
    
    //display dropdown of my bookmarks on hover
    $('#li_mysite').mouseenter(function() {
        BookMarkDisplay =0;
        $("#dropdownList").css("display","none");   
       showMySiteRecord(currentPagePath, uid, view,'li_mysite','bookmarksList');        
//         $("#dropdownList").css("display","none");   
    });    
   
    //hide my bookmarks dropdown 
    $('#li_mysite').mouseleave(function() {
       $('#bookmarksList').hide() ; 
       BookMarkDisplay =1;
    }); 
    
    //updating feedback link
    if($('#feedbackLink').length!=0) {    
        var feedbackHref = $('#feedbackLink a').attr("href"); 
        feedbackHref = feedbackHref.replace("userEmail",userEmail); 
        feedbackHref = feedbackHref.replace("userID",uid); 
        feedbackHref = feedbackHref.replace("userName",uname); 
        $('#feedbackLink a').attr("href", feedbackHref);
    } 
    
    //updating print link 
    if($('.printLink').length!=0) {
        var printLocation=location.href;
        var printLocationFirst=printLocation.substring(0,printLocation.lastIndexOf("/")+1);              
        var printLocationSecond=printLocation.substring(printLocation.lastIndexOf("/")+1);
        var printLocationSplit=printLocationSecond.split(".");        
        var count=printLocationSplit.length;
        $('.printLink').attr("href",printLocationFirst+printLocationSplit[0]+".print."+printLocationSplit[count-1]+"?wcmmode=disabled"); 
    } 
    
    /******Share Email******/
    $(".shareEmailAction").click(function(){
       openEmailWin(currentPagePath,'','name'); 
     });  
    
    (function($){
    $(".sharebookmarksAction").attr("href", currentPagePath.replace("/content/", "/") + ".addtobookmark.html"); 
    
    /*setting colorbox for sending email*/
    $(".shareEmailAction").mcdColorbox({ iframe: true, innerWidth: 610, innerHeight: 450 });  
    
    //setting colorbox for adding bookmarks 
    $(".sharebookmarksAction").mcdColorbox({ iframe: true, innerWidth: 550, innerHeight: 262 });
    })(jQuery);
    //Show share options like email, add to bookmarks and get link
    $('#share').mouseenter(function() {
        var _left_alt = $('#share').position().left - 85; // 135;
        var _top_alt = $('#share').position().top + 5;
        
        var _dims_alt = {
            'top':  _top_alt + 'px',
            'left': _left_alt + 'px'                
        }
        
        $('#share_flyout').css(_dims_alt);
        show_share(); 
    });
    
    //Hide share options   
    $('#share').mouseleave(function() { 
        hide_share();  
    });
    

    //hover effect on go button available in search
    $("#go_button").attr("src",currentDesignPath + "/images/search.jpg");
        
    
    $("#globe_icon").click(function(){
      
        $("#dropdown").css("display","block");
        $("#searchalert").hide();
      
    }); 
     //$("#dropdownList").css('min-width', $("#userRole").width()) ;   
    //$("#dropdownList").css("width", "auto");   
    //$("#dropdownList").css("display","block");
    //$("#dropdownList").css('left', $('#userRole').position().left + $('#userRole').width() - $('#dropdownList').width() - 8) ;
    $("#dropdownList").css("display","none");
        
    $('#topheader ul li.viewSwitcher').mouseenter(function() {   

      //$("#dropdownList").css('min-width', $("#userRole").width()) ;
        $("#dropdownList").css("width", "auto");
        $("#dropdownList").css("display","block");
   // $("#dropdownList").css('left', $('#userName').position().left + $('#userName').width() - 45) ; 
//    $("#dropdownList").css('right', $('#switcher').position().right ) ; 
     
        $('#bookmarksList').hide() ; 
    
    });

    $('#topheader ul li.viewSwitcher').mouseleave(function() {
       $("#dropdownList").css("display","none"); 
    }); 
    
      
   
$(".select_code").click(function(){
    $(".select_box").show();
//}, function(){
// $(".select_box").slideUp();  
});
 
$(".option li").click(function(){
        $('.select_code .searchfield').html($(this).find('.searchfield').html());
         $('.select_code .searchoption').html($(this).find('.searchoption').html());
  //      $(".selectLabel").html($(this).html());
        //alert("This");
        $(".select_box").hide();  
          
        var id = $(this).attr('id');
       
        if(id == 'view')
         {
          setCookie('myCookie','1', 1);
          $("#selSites").attr("value","default");
          $("#SearchSiteURL").attr("value", "default");
         }
        
        if(id == 'all')
         {
          setCookie('myCookie','2', 1);
          $("#selSites").attr("value","");   
          $("#SearchSiteURL").attr("value", "default");      
         } 
        if(id == 'site')  
          {
           setCookie('myCookie','3', 1);
           $("#SearchSiteURL").attr("value", currentPagePath); 
           $("#selSites").attr("value","default"); 
          } 
          
    });


    
    
    var x = getCookie('myCookie'); 
      if(x == '1')
      {
         $('.select_code .searchfield').html($('#view .searchfield').html());
         $('.select_code .searchoption').html($('#view .searchoption').html());
     
 //       $(".selectLabel").html($("#view").html());
        $("#selSites").attr("value","default");   
        $("#SearchSiteURL").attr("value", "default");     
       
      
      }

      if(x == '2')
      {
     
        $('.select_code .searchfield').html($('#all .searchfield').html());
        $('.select_code .searchoption').html($('#all .searchoption').html());
        $(".selectLabel").html($("#all").html());
        $("#selSites").attr("value","");   
        $("#SearchSiteURL").attr("value", "default");     
       
      
      }
     if(x == '3' ) 
      {
       $('.select_code .searchfield').html($('#site .searchfield').html());
       $('.select_code .searchoption').html($('#site .searchoption').html());
       $(".selectLabel").html($("#site").html());
       $("#SearchSiteURL").attr("value", currentPagePath); 
       $("#selSites").attr("value","default");
      }   
              
              
   
        
  //  $(".sharebookmarksAction").attr("href", currentPagePath.replace("/content/", "/") + ".addtobookmark.html"); 
    
    //setting colorbox for sending email  
    (function($){
    $(".shareEmailAction").mcdColorbox({ iframe: true , innerWidth: "610", innerHeight: "450" }); 
    })(jQuery);
    
     
    //setting colorbox for adding bookmarks 
   // $(".sharebookmarksAction").mcdColorbox({ iframe: true , innerWidth: "550", innerHeight: "262"});
     
}

function setCookie(name,value,days) {
     if (days) { 
      var date = new Date();  
      date.setTime(date.getTime()+(days*24*60*60*1000)); 
      var expires = "; expires="+date.toGMTString(); 
     }
     else 
       var expires = "";   
     document.cookie = name+"="+value+expires+"; path=/";
    }  
 

 function getCookie(name)
  {
    var nameEQ = name + "=";  
    var ca = document.cookie.split(';'); 
    for(var i=0;i < ca.length;i++) {
     var c = ca[i];       
      while (c.charAt(0)==' ') 
         c = c.substring(1,c.length);       
    if (c.indexOf(nameEQ) == 0) 
    return c.substring(nameEQ.length,c.length);  
   }
    return null; }
            
      
  function deleteCookie(name) {     setCookie(name,"",-1); } 

 
function setContentPara() 
{
    $('#right-results-column').css('float','left');     
    var logo_para_height= $('#logo_t').height();
    if(logo_para_height == 0) {
     $('#bread_tnav_cntr').css('width', '100%');
     var usLogoWidth = $('#pagecontentwrapper').width() - $('#ussearcharea').width();
     $('#uslogoarea').css('width', usLogoWidth + 'px' );         
    } 
    var left_sec_height= $('#left-widgets-column').height();
    var right_sec_height= $('#right_content_par').height(); 
    if (left_sec_height == null || left_sec_height == 0) {      
        $('#left-widgets-column').css('margin-right','0px');
        if(right_sec_height != 0) {  
            var rightParaMarginLeft = $('#right_content_par').css('margin-left'); 
            var rightParaMarginRight = $('#right_content_par').css('margin-right'); 
            var rightParaWidth = $('#right_content_par').width();
            if(rightParaMarginLeft == '20px') {
                rightParaWidth  = rightParaWidth + 20; 
            }else if(rightParaMarginLeft == '10px') {
                rightParaWidth  = rightParaWidth + 10; 
            }
                            
            if(rightParaMarginRight == '10px') {
                rightParaWidth  = rightParaWidth + 10; 
            }
            var contentWidth = $('#pagecontentwrapper').width() - rightParaWidth ;                
            $('#content_txt').css('width', contentWidth + 'px'); 
        }
        else {
            $('#content_txt').css('width', '100%');
            $('#right_content_par').css({'margin':'0px', 'padding':'0px', 'display':'none'}); 
        }
            
        $('#right-results-column').css({'width':'100%', 'padding':'0px', 'margin':'0 auto'});
        // $('#right-results-column').css({'padding':'0px', 'margin':'0 auto'});
                 
    } 
    else if(right_sec_height == 0) {
        $('#content_txt').css('width', '100%');
        $('#right_content_par').css({'margin':'0px', 'padding':'0px'}); 
    }
    
    // function to reset heights of columns
    resetColctrlHeight();
}


// function to change the mouse over color of the rounded corners //
function changecolor(id) 
    {
        
        // retrieving the class name of the ID on which the mouse over effect event has fired //    
        var classname = document.getElementById(id).className;
        // checking if the selected class is implemented on the child then no mouse over effect will be fired//
        if((classname.indexOf("On"))<0){
         if(id==111) {
               document.getElementById("LeftNavtop0").className="leftnavBorderSel";
               for(i=1;i<=5;i++) {
                   document.getElementById("LeftNavtop"+i).className="leftnavBorderSel"+i;
               }
               
         } else if(id==000){
               document.getElementById("LeftNavbottom0").className="leftnavBorderSel";
               for(i=1;i<=5;i++) {
                   document.getElementById("LeftNavbottom"+i).className="leftnavBorderSel"+i;
               }
               
         }
         else
         {
               document.getElementById("LeftNavtop0").className="leftnavBorderSel";
               for(i=1;i<=5;i++) {
                   document.getElementById("LeftNavtop"+i).className="leftnavBorderSel"+i;
               }
               document.getElementById("LeftNavbottom0").className="leftnavBorderSel";
               for(i=1;i<=5;i++) {
                   document.getElementById("LeftNavbottom"+i).className="leftnavBorderSel"+i;
               }  
         }
      }
    }

//function to change the color of the rounded corners //    
    function togglecolor(id)
    {
        // retrieving the class name of the ID on which the mouse over effect event has fired //    
        var classname = document.getElementById(id).className;
      //checking if the selected class is implemented on the child then no mouse over effct will be fired//
      if((classname.indexOf("On"))<0) {
        if(id==111)  {
               document.getElementById("LeftNavtop0").className="leftnavBorder";
               
               for(i=1;i<=5;i++)  {
                   document.getElementById("LeftNavtop"+i).className="leftnavBorder"+i;
               }
               
        } else if(id==000){
               document.getElementById("LeftNavbottom0").className="leftnavBorder";
               for(i=1;i<=5;i++) {
                   document.getElementById("LeftNavbottom"+i).className="leftnavBorder"+i;
               }
              
        }else
        {
               document.getElementById("LeftNavtop0").className="leftnavBorder";
               
               for(i=1;i<=5;i++)  {
                   document.getElementById("LeftNavtop"+i).className="leftnavBorder"+i;
               }
               document.getElementById("LeftNavbottom0").className="leftnavBorder";
               for(i=1;i<=5;i++) {
                   document.getElementById("LeftNavbottom"+i).className="leftnavBorder"+i;
               }
        }
      }
    }   


function changediv(count,color)     {
              for(var i=0;i<6;i++)
              {
               var element1='element'+i;
               element2='element'+i+6;
               element1=document.getElementById("top"+i+count);
               element2=document.getElementById("bottom"+i+count);
               if(i==0)
                   i="";
               if(element1)
                   element1.className="roundcorner"+color+"Hover"+i;
               if(element2)
                   element2.className="roundcorner"+color+"Hover"+i;
              }
              elementmain=document.getElementById("main"+count);
              if(elementmain)
               elementmain.className="columncontrolmain"+color+"Hover";
}

function togglediv(count,color)     {
                for(var i=0;i<6;i++)
                {
                   var element1='element'+i;
                   element2='element'+i+6;
                   element1=document.getElementById("top"+i+count);
                   element2=document.getElementById("bottom"+i+count);
                   if(i==0)
                       i="";
                   if(element1)
                       element1.className="roundcorner"+color+i;
                   if(element2)
                       element2.className="roundcorner"+color+i;
                }
                elementmain=document.getElementById("main"+count);
                if(elementmain)
                    elementmain.className="columncontrolmain"+color;
}    

var colctrlArray = new Array();

function insertInColctrlArray(distinctID,columnNum,index){
    colctrlArray[index] = new Array(2); 
    colctrlArray[index][0] = distinctID; 
    colctrlArray[index][1] = columnNum;
}



function resetColctrlColor() {    

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
            
            if(!((window.location.pathname).indexOf("wwc") > -1)){
                if(linkColor == columnColor) {
                    $("#" + colID + " a").css("color","#FFFFFF");
                    $("#" + colID + " a.commentAuthorLink").css("color", linkColor);
                }
            } 
        }        
    }
}  


// function for printer friendly
function NewPrintWindow(mypage, myname, w, h, scroll, resize) {
     var winl = (screen.width - w) / 2;
     var wint = (screen.height - h) / 2;
     winprops = 'height='+h+',width='+w+',top='+wint+',left='+winl+',scrollbars='+scroll+',resizable='+resize
     win = window.open(mypage, myname, winprops);
     if (parseInt(navigator.appVersion) >= 4) { win.window.focus(); }
}

//function to print the current page // 
function printWindow()      {
   bV = parseInt(navigator.appVersion);
   if (bV >= 4) window.print();
} 

//**** function for footer component  ****//
// function to bookmark the current page //
function bookmark(title,prefixAMCD){
    var url = this.location;
    var title=title;
    
       url=url.toString();
       if(url.indexOf('/accessmcd/apmea/au.')>-1)
       {
           url=url.substring(0,url.indexOf('/accessmcd/apmea/au.'));
           url=url+"/accessmcd/apmea/au.html";                  
        }
    
    
       url=prefixAMCD+url;
      if ((navigator.appName == "Microsoft Internet Explorer") && (parseInt(navigator.appVersion) >= 4)) {
      window.external.AddFavorite(url,title);
      } else if (navigator.appName == "Netscape") {
        window.sidebar.addPanel(title,url,"");
      } else {
        alert("Press CTRL-D (Netscape) or CTRL-T (Opera) to bookmark");
      }
}

 // function to open the new window with the provided parameters //
function NewWindow(mypage, myname, w, h, scroll) {
    var winl = (screen.width - w) / 2;
    var wint = (screen.height - h) / 2;
    winprops = 'height='+h+',width='+w+',top='+wint+',left='+winl+',scrollbars='+scroll+',resizable'
    win = window.open(mypage, myname, winprops)
    if (parseInt(navigator.appVersion) >= 4) { 
        win.window.focus(); 
    }
}

//function to display the get linkg box //
function DisplayAlert(id,height,width) {           
    var myWidth = 0;
    var myHeight = 0;
    if( typeof( window.innerWidth ) == 'number' ) {
        //Non-IE
        myWidth = window.innerWidth;
        myHeight = window.innerHeight;
    } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
        //IE 6+ in 'standards compliant mode'
        myWidth = document.documentElement.clientWidth;
        myHeight = document.documentElement.clientHeight;
    } else if( document.body && ( document.body.clientHeight || document.body.clientWidth ) ) {
        //IE 4 compatible
        myWidth = document.body.clientWidth;
        myHeight = document.body.clientHeight;
    }

    var scrOfX = 0, scrOfY = 0;
    if( typeof( window.pageYOffset ) == 'number' ) {
        //Netscape compliant
        scrOfY = window.pageYOffset;
        scrOfX = window.pageXOffset;
    } else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
        //DOM compliant
        scrOfY = document.body.scrollTop;
        scrOfX = document.body.scrollLeft;
    } else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
        //IE6 standards compliant mode
        scrOfY = document.documentElement.scrollTop;
        scrOfX = document.documentElement.scrollLeft;
    }
    var top = (myHeight+scrOfY)-500;
    var left = myWidth/2-width/2;
    document.getElementById(id).style.left=left+'px';
    document.getElementById(id).style.top=top+'px';
    document.getElementById(id).style.height=height+'px';
    document.getElementById(id).style.width=width+'px';
    grayOut(id,true);

    //document.getElementById(id).style.display='block';
}

//function to copy the text to the clip board //
function ClipBoard(){
    var copyText = document.getElementById("copytext").innerText;
    document.getElementById("holdtext").innerText = copyText;
    Copied = document.getElementById("holdtext").createTextRange();
    Copied.execCommand("Copy");
}


// function to validate the email form //
function validateEmail() {
    
    var form = document.frmEmailAction;
    var addr = form.hidShareUserEmail.value;
    

    var yemail = form.emailfrom.value;
    var subEmail = "";

    if (addr.length == 0 || (yemail.length == 0 && myform.hidAddMe.checked )){ 
           alert("Email Address(es) is empty.");
       return false;
    } else{
       while (addr.length>0)   {
           addrIndex = addr.lastIndexOf(',');
           if ( addrIndex == 0)       {
                return validateEmailAddr(subEmail);
           } else { 
                subEmail = addr.substr(addrIndex+1);
                addr = addr.substr(0,addrIndex);
                if (!validateEmailAddr(subEmail)) {
                return false;
            }
           }
       }
    }
    
    return true;
}

// function to trim the blank spaces from the text//
function TrimString(sInString) {
    sInString = sInString.replace( /^\s+/g, "" );// strip leading
    return sInString.replace( /\s+$/g, "" );// strip trailing
}

// function to valide the email addresses //
function validateEmailAddr(emailStr) {

    emailStr = TrimString(emailStr).toLowerCase();
    var checkTLD=1;
    var knownDomsPat=/^(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum)$/;
    var emailPat=/^(.+)@(.+)$/;
    var specialChars="\\(\\)><@,;^&*$%#!+=~|?:\\\\\\\"\\.\\[\\]";
    var validChars="\[^\\s" + specialChars + "\]";
    var quotedUser="(\"[^\"]*\")";
    var ipDomainPat=/^\[(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\]$/;
    var atom=validChars + '+';
    var word="(" + atom + "|" + quotedUser + ")";
    var userPat=new RegExp("^" + word + "(\\." + word + ")*$");
    var domainPat=new RegExp("^" + atom + "(\\." + atom +")*$");
    var matchArray=emailStr.match(emailPat);
    if (matchArray==null) {
        alert("Invalid Email Address: " + emailStr);
        return false;
    }
    var user=matchArray[1];
    var domain=matchArray[2];

    for (i=0; i<user.length; i++) {
        if (user.charCodeAt(i)>127) {
            alert("Invalid char in "+ emailStr);
            return false;
        }
    }
    for (i=0; i<domain.length; i++) {
        if (domain.charCodeAt(i)>127) {
            alert("Invalid dom char "+ emailStr);
            return false;
        }
    }

    if (user.match(userPat)==null) {

        alert("Invalid address : "+ emailStr);
        return false;
    }

    var IPArray=domain.match(ipDomainPat);
    if (IPArray!=null) {

        for (var i=1;i<=4;i++) {
            if (IPArray[i]>255) {
                alert("Invalid IP : "+ emailStr);
                return false;
            }
        }
        return true;
    }

    var atomPat=new RegExp("^" + atom + "$");
    var domArr=domain.split(".");
    var len=domArr.length;
    for (i=0;i<len;i++) {
        if (domArr[i].search(atomPat)==-1) {
            alert("Invalid domain :" + emailStr);
            return false;
        }
    }

    if (checkTLD && domArr[domArr.length-1].length!=2 && 
    domArr[domArr.length-1].search(knownDomsPat)==-1) {
        alert("Unknown domain: " + emailStr);
        return false;
    }

    if (len<2) {
        alert("Missing host : " + emailStr);
        return false;
    }

    return true;
}
function utf8(wide) {
      var checkValue, showValue;
      var enc = "";
      var i = 0;
      while(i<wide.length) {
        checkValue= wide.charCodeAt(i++);
        if (checkValue>=0xDC00 && checkValue<0xE000) continue;
        if (checkValue>=0xD800 && checkValue<0xDC00) {
          if (i>=wide.length) continue;
          showValue= wide.charCodeAt(i++);
          if (showValue<0xDC00 || checkValue>=0xDE00) continue;
          checkValue= ((checkValue-0xD800)<<10)+(showValue-0xDC00)+0x10000;
        }
        if (checkValue<0x80) enc += String.fromCharCode(checkValue);
        else if (checkValue<0x800) enc += String.fromCharCode(0xC0+(checkValue>>6),0x80+(checkValue&0x3F));
        else if (checkValue<0x10000) enc += String.fromCharCode(0xE0+(checkValue>>12),0x80+(checkValue>>6&0x3F),0x80+(checkValue&0x3F));
        else enc += String.fromCharCode(0xF0+(checkValue>>18),0x80+(checkValue>>12&0x3F),0x80+(checkValue>>6&0x3F),0x80+(checkValue&0x3F));
      }
      return enc;
}
    
var hexchars = "0123456789ABCDEF";
    
// convert into hexadecimal //
function toHex(numVal) {
  return hexchars.charAt(numVal>>4)+hexchars.charAt(numVal & 0xF);
}
// declared as global variable//
var okURIchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-";


// function to encode the URI//
function encodeURIComponentNew(linkValue) {
  var sVal = utf8(linkValue);
  var c;
  var enc = "";
  for (var i= 0; i<linkValue.length; i++) {
    if (okURIchars.indexOf(sVal.charAt(i))==-1)
      enc += "%"+toHex(sVal.charCodeAt(i));
    else
      enc += sVal.charAt(i);
  }
  return enc;
}

// function to encode the url for sending as the request object //
function buildURL(fld)
{
    if (fld == "") return "";
    var encodedField = "";
    var encodeVal = fld;
    if (typeof encodeURIComponent == "function")
    {
        encodedField = encodeURIComponent(encodeVal);
    }
    else 
    {
        encodedField = encodeURIComponentNew(encodeVal);
    }
    return encodeURIComponentNew(fld);
}

// function to validate the form and then submit the search //
function validateAndSubmit() {

    var form = document.frmSearchUser;
    var searchStr = form.txtSearchLastName.value;   
    
    var count = 0;
    var i = 0;
    var max = searchStr.length;
    while(i < max){
        if(searchStr.charAt(i) == '*'){
            count++;
        }
        i++;
    }

    if((TrimString(searchStr).length) - count < 2){
        alert("Last Name must be greater than or equal to two characters in length, excluding '*' characters.");
        form.txtSearchLastName.focus();
        return false;
    }else{    
        form.hidStartSearch.value = "yes";
            form.submit();
        return true;
    }           
}

// function to set the email id from the opened window to the parent // 
function setMailId(usedID, userName, userEmail) {  
    
    var closeWin=true;
    var frmopener;     
    frmopener = window.opener.document.frmEmailAction;
    var oldvalue = frmopener.sendToEmail.value;
    
    if (oldvalue!=null && oldvalue.length > 0)
        frmopener.sendToEmail.value = oldvalue +","+ userEmail;
    else 
        frmopener.sendToEmail.value = userEmail;
    var contains = 'to';
    var emailSet = false;

    if(closeWin){
     window.close();
    }
    return false;
}

// for selecting the text box on page load
function selectedText()
{
document.frmSearchUser.txtSearchLastName.focus();   
}

  
function openEmailWin(currentPagePath,prefixMCD,winID){
        
        var location = this.location;
        var location_arr = location.toString().split("?");
         if(currentPagePath.indexOf('/content/')>-1)
        {
           currentPagePath=currentPagePath.replace('/content/','/');
        
        }
        var hostLink =  currentPagePath+".emailaction.html?";
        if(prefixMCD!="") {
            hostLink  = hostLink + "prefixAMCD="+prefixMCD;
            hostLink = hostLink + "&";
        }   
       
        if(location_arr[0].indexOf('/content/')>-1)
        {
            location_arr[0]=location_arr[0].replace('/content/','/');
        
        }
        
        if(location_arr[0].indexOf('/accessmcd/apmea/au.')>-1)
        {
           location_arr[0]=location_arr[0].substring(0,location_arr[0].indexOf('/accessmcd/apmea/au.'));
           location_arr[0]=location_arr[0]+"/accessmcd/apmea/au.html";                  
        }
        hostLink += "hostLink="+encodeURIComponentNew(location_arr[0]);
        $(".shareEmailAction").attr("href",hostLink); 
        $("#footerEmailAction").attr("href",hostLink);
        $("#footerEmailAction").mcdColorbox({ iframe: true, innerWidth: 610, innerHeight:450 }); 
        
        //NewWindow(hostLink,winID,'610','450','yes'); 
    }

function changeSize(img,size) 
{
    if(size!=1.0)
    {
        var width=(img.width*size);
        img.width=width;
    }
}
   
var newRequestFlag = '1';
var html = "";

function changeRequestFlag(value)
{
    newRequestFlag = value; 
}

function showMySiteRecord(URL, userID, view,nav_mysite,navBookmarksList)
{
    var pars = "";  
    //pars = pars + "?userID="+userID;
    pars = pars + "?view="+view;
    //var randomnumber=Math.floor(Math.random()*1000001)
    //pars = pars + "&time="+randomnumber;
    
    var url = URL+'.mysitemenu.html' + pars;
    //alert(url);

    if(newRequestFlag != '0')
    {
        $.ajax({
            url: url,
            type: 'GET',    
            timeout: 3000,
            data: '',   
            cache: false,   
            error: function(){
                //alert("some error");  
            },
            success: function(xml)
            { 
                newRequestFlag = '0';
                html = xml;
                var div_mysite = document.getElementById(navBookmarksList);
                
                var li_mysite = document.getElementById(nav_mysite);
                
                if(div_mysite!=null)
                {
                    try
                    {   
                        div_mysite.innerHTML = xml;                                     
                        var subMenuUL = div_mysite.getElementsByTagName("ul");
                        if(subMenuUL.length>0)
                        {
                            div_mysite.className="tabHover";                
                            var maxitemwidth=widenIt(subMenuUL[0]);
                            setPostion(li_mysite,subMenuUL[0],maxitemwidth);
                            ie6Ptach(subMenuUL[0]);
                        }
                        html = div_mysite.innerHTML; 
                        if(BookMarkDisplay == 0)
                        {
                         $('#'+navBookmarksList).css('display','block');  
                         $('#' + navBookmarksList).css('left',$('#'+nav_mysite).position().left + $('#'+nav_mysite).width() - $('#' + navBookmarksList).width());
                        } 
                    }
                    catch(ex)
                    {
                        alert(ex.message); // never displayed
                    }
                }
            }
        }
        );
    }
    else 
    {
        var div_mysite = document.getElementById(navBookmarksList); 
        if(div_mysite!=null)
        {
            try
            {
                div_mysite.innerHTML = html; 
                $('#'+navBookmarksList).css("display","block");
                var bookmark_width = $('#' + navBookmarksList).width();
                var li_width = $('#'+nav_mysite).width();
                var bookmark_left = $('#'+nav_mysite).position().left + li_width - bookmark_width;
                $('#' + navBookmarksList).css('left',bookmark_left);                         
            }
            catch(ex)
            {
                alert(ex.message); // never displayed
            }
        }
    }
}

function widenIt(containerVal) 
{        
    var anchorVal = containerVal.getElementsByTagName("a");
    var lisVal = containerVal.getElementsByTagName("li");

    var maxlength = 100;
    
    // added spanVal after new AU view changes
    var spanVal = containerVal.getElementsByTagName("span");

    // New - calculate width of submenu with span tag
    for (i = 0; i < spanVal.length; i++) 
    {
        if (spanVal[i].innerHTML.length * 9 > maxlength) 
        {
            maxlength = spanVal[i].innerHTML.length * 9;
        }
    }
        
    /* Old - calculate width of submenu with anchor tag
    for (i = 0; i < anchorVal.length; i++) 
    {
        if (anchorVal[i].innerHTML.length * 7 > maxlength) 
        {
            maxlength = anchorVal[i].innerHTML.length * 7;
        }
    }
    */
        
    for (i = 0; i < anchorVal.length; i++) 
    {
        anchorVal[i].style.width = "" + maxlength + "px";
    }
    for (j = 0; j < lisVal.length; j++) 
    {
        lisVal[j].style.width = "" + maxlength + "px";
    }
    containerVal.style.width = "" + maxlength + "px";
    return maxlength;
}

//function for browser detection code and global variable //
var IEVersion = 99;//default assumption
if (navigator.appName == "Microsoft Internet Explorer") 
{
    var ua = navigator.userAgent;
    var re = new RegExp("MSIE ([0-9]{1,}[.0-9]{0,})");
    if (re.exec(ua) != null) 
    {
        IEVersion = parseFloat(RegExp.$1);
    }
}

// function used in top navigation menu bar
function menuGoTo(linkVal, launchType, linkType, menuId, uuId) {
    var svpId = UserInfoObject.view;
    var userRole = UserInfoObject.mcdAudienceGlob; 
    var userId = UserInfoObject.uid;
    menuReporting(menuId, uuId, svpId, userRole, userId);
    openLinkval(linkVal, launchType);
}

function menuReporting(menuId, uuId, Svp, userRole, userId) {
    var xmlHttp = false;
    var self = this;
    var mkt = "";
    if (window.XMLHttpRequest) {
        xmlHttp = new XMLHttpRequest;
    } else if (window.ActiveXObject) {
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    var servletURL = "/mcdp/MCDClickTrackerServlet";
    if (Svp != null) {
        mkt = Svp.substring(Svp.lastIndexOf("/") + 1);
    }
    if (mkt == "global") {
        mkt = "Corp";
    }
    // @15sep09 - set market code for AU Redesign view
    if (mkt == "mcsource") {
        mkt = "aus";
    }
    servletURL += "?desc=" + uuId + "&menuid=" + menuId + "&mkt=" + mkt + "&role=" + userRole + "&id=menu" + "&userid=" + userId;
    xmlHttp.open("GET", servletURL, true);
    xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4) {
                //do nothing
        }
    };
    xmlHttp.send("");
}

function openLinkval(linkVal, launchType) {
    if (launchType == "MyFrame") {
        window.open(linkVal, launchType);
    } else {
        window.open(linkVal, launchType); // @22feb11 - launch type included instead of blank
    }
} 

// --------------------------------------------------------------------------
// MENUS  //
// --------------------------------------------------------------------------
function setMenu(){

    var menuVal = document.getElementById("navMenu");
    var tabsVal = menuVal.getElementsByTagName("li");
    
    for(i=0;i<tabsVal.length;i++){
        if(tabsVal[i].offsetParent){
            if(tabsVal[i].offsetParent.id=="navMenu"){
                tabsVal[i].onmouseover=function(e) {    
                if(!e)e=window.event;
                  if(!isMouseLeaveOrEnter(e,this))return;
                    var subMenuVal = this.getElementsByTagName("ul")
                    if(subMenuVal.length>0){
                        this.className="tabHover";
                        var maxitemwidth=widenIt(subMenuVal[0]);
                        setPostion(this,subMenuVal[0],maxitemwidth);
                        ie6Ptach(subMenuVal[0]);
                    }
                }
                tabsVal[i].onmouseout=function(e) { 
                if(!e)e=window.event;
                  if(!isMouseLeaveOrEnter(e,this))return;
                    var subMenuVal = this.getElementsByTagName("ul")
                    if(subMenuVal.length>0){
                        this.className="";
                    }
                }
                tabsVal[i].onclick=function() { 
                    var subMenuVal = this.getElementsByTagName("ul")
                    if(subMenuVal.length>0){
                        this.className="";
                    }
                }
            }
        }
    }
}

// functon to check the browser type //
function ie6Ptach(containerVal) {
    if (IEVersion <= 7) {
        var iframes = containerVal.getElementsByTagName("iframe");
        if (iframes != null && iframes.length > 0) {
            return;
        }
        var ieMat = document.createElement("iframe");
        if (document.location.protocol == "https:") {
            ieMat.src = "/images/spacer.gif";
        } else if (window.opera != "undefined") {
            ieMat.src = "";
        } else {
            ieMat.src = "javascript:false";
        }
        ieMat.scrolling = "no";
        ieMat.frameBorder = "0";
        ieMat.style.width = containerVal.offsetWidth + "px";
        ieMat.style.height = containerVal.offsetHeight + "px";
        ieMat.style.zIndex = "-1";
        containerVal.insertBefore(ieMat, containerVal.childNodes[0]);
        containerVal.style.zIndex = "100";
    }
}

// function to set the position for the child pages in the menu bar //
function setPostion(parentVal, childVal, maxitemwidth) {
    var pageWidthVal = document.documentElement.clientWidth;
    if (pageWidthVal <= 0) {
        pageWidthVal = document.body.clientWidth;
    }
    var extraWidthVal = maxitemwidth + parentVal.offsetLeft;
    var newLeftVal = parentVal.offsetLeft;
    if (extraWidthVal > pageWidthVal) {
        newLeftVal = (parentVal.offsetLeft + parentVal.offsetWidth) - maxitemwidth;
        if (newLeftVal < 0) {
            newLeftVal = 0;
        }
    }
    childVal.style.left = (newLeftVal-1) + "px";
}

// this function is to track the event //
function isMouseLeaveOrEnter(e, handler) {
    if (e.type != "mouseout" && e.type != "mouseover") {
        return false;
    }
    var reltg = e.relatedTarget ? e.relatedTarget : e.type == "mouseout" ? e.toElement : e.fromElement;
    while (reltg && reltg != handler) {
        reltg = reltg.parentNode;
    }
    return reltg != handler; 
} 




// --------------------------------------------------------------------------
// WINDOW/LINK OPENERS
// --------------------------------------------------------------------------
 function viewAll(link, openType) {
 var form = document.frmRegionContent;
 if (openType == "yes") {
 window.open(link, "NewWinNoHeader", "toolbar=1,scrollbars=1,location=1,status=1,menubar=1,resizable=1,width=700,height=400,screenX=5,left=5,screenY=5,top=5");
 } else {
 //link = link + ".html";
 document.location.href = link;
 }
 }

function openLink(link)
{
   if(!TrimString(link)=="" || !link=="#")
   {
             if(checkInternalLink(link)=="false" && link.indexOf('/')!=0)
             {
                 window.open(link, '', 'location=yes,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,width=800,height=600')
 
              }else
              {

                 window.open(link, '_self', 'location=yes,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,width=800,height=600')
              }

// window.open(link, "", "toolbar=1,scrollbars=1,location=1,status=1,menubar=1,resizable=1,width=700,height=400,screenX=5,left=5,screenY=5,top=5");
  }
}



function view(url) 
{
 document.location.href = url;
} 



function switchview(url) 
{
  setCookie("userview","",-1);
  view(url);
} 

//Feature Story Script Start         
function slideShow(){        
        if(isRunning)
            return;
          
        isRunning=true;
          
        $('.carousel li').removeClass('selected');
        $('.carousel li:eq('+currentSlideImg+')').addClass('selected');
        
        $('#slide-img1').hide();
        $('#slide-img2').hide();
        $('#slide-img3').hide();
        
        $('.thumb-info').hide();
        
      
        if(currentSlideImg==0){
            $('#slide-img img').attr('src',$('#slide-img1 img').attr('src'));
            $('#slide-info').html($('#slide-info1').html());
            
            $('#slide-img2').show();
            $('#slide-img3').show();

            $('#slide-img3').remove().insertAfter($('#slide-img2'));
            mainImageLink=image1Link;
        }
        
        
        if(currentSlideImg==1){
            $('#slide-img img').attr('src',$('#slide-img3 img').attr('src'));
            $('#slide-info').html($('#slide-info3').html());    
            
            $('#slide-img1').show();
            $('#slide-img2').show();
            
            $('#slide-img2').remove().insertAfter($('#slide-img1'));
            mainImageLink=image3Link; 
        }


        if(currentSlideImg==2){
            $('#slide-img img').attr('src',$('#slide-img2 img').attr('src'));
            $('#slide-info').html($('#slide-info2').html());
            
            $('#slide-img3').show();
            $('#slide-img1').show();            
            
            $('#slide-img1').remove().insertAfter($('#slide-img3'));
            mainImageLink=image2Link;
        } 
        
        $('#slide-img').stop(); 
        $('#slide-img').css({'opacity':0});
        $('#slide-img').animate({opacity:1},fadeTime);    
        clearInterval(timeIntervalIdFeatureStory);
        if(transitionTime>0)timeIntervalIdFeatureStory=window.setInterval(slideShow,transitionTime);                   
        currentSlideImg++;
        if(currentSlideImg>2)
            currentSlideImg=0;
            $('.thumb-info').mouseout(function(){
                $(this).hide(); 
            }); 
       $('.slideImg').mouseover(function(){       
            $('.thumb-info',$(this).parent().parent()).show();
        });
    
        $('.slideImg').mouseout(function(){
             $('.thumb-info',$(this).parent().parent()).hide();
             $('.thumb-info').mouseover(function(){                                    
                $(this).show();
             });
        });  
        
        isRunning=false;
    } 

//Feature Story Script End          


// Function to get Query String Parameter


function getQuerystring(key, default_)
{
  if (default_==null) default_=""; 
  key = key.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regex = new RegExp("[\\?&]"+key+"=([^&#]*)");
  var qs = regex.exec(window.location.href);
  if(qs == null)
    return default_;
  else
    return qs[1];
}
 

  
 
/* to validate search */
var escapeURIchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-";
 

// function to encode the URI//
function escapeNew(linkValue) {
  var sVal = linkValue;
  var c;
  var enc = "";
  for (var i= 0; i<linkValue.length; i++) {
    if (escapeURIchars.indexOf(sVal.charAt(i))==-1)
      enc += "%"+toHex(sVal.charCodeAt(i));
    else
      enc += sVal.charAt(i);
  }
  return enc;
}

function rejectCheck(regex,commentDesc) {
    if(commentDesc.match(/([\<])([^\>]{1,})*([\>])/i)==null){
    commentDesc = commentDesc;
    }else{
    commentDesc ="";
    }return commentDesc;
    }
function validatesearch(link,par1,par2,par3)
{
 var regex= "/[-!$%&^<>*()_+@|~\"\'`=\\#{}\\[\\]:;?,.\\/";
 var searchText = jQuery.trim($('#txt_search').val());
 
 if(jQuery.trim($('#txt_search').val()) == jQuery.trim($('#viewSearch').html()) || jQuery.trim($('#txt_search').val()) == jQuery.trim($('#mcdSearch').html()) || jQuery.trim($('#txt_search').val()) == jQuery.trim($('#siteSearch').html()) || jQuery.trim($('#txt_search').val()) =='' )
 {
      $('#searchalert').show();
     
 } 
else
 {
searchText = rejectCheck(regex,searchText);
par1 = rejectCheck(regex,par1);
par2 = rejectCheck(regex,par2);
par3 = rejectCheck(regex,par3);

  $('#searchalert').hide();
  if(par1 == 'ja')
   {
   var formActionn = link + '?qt=' + encodeURIComponent(searchText) + '&la=' + par1 + '&mkt=' + par2+ '&inthe=' + par3 ;
   }
   else
   {
    var formActionn = link + '?qt=' +  escape(searchText) + '&la=' + par1 + '&mkt=' + par2+ '&inthe=' + par3 ;
   }
   if($("#selSites").attr('value') =='')
   {
     formActionn  = formActionn + '&selSites=';
   } 
    if($("#SearchSiteURL").attr('value') != 'default')
   {
    formActionn  = formActionn + '&SearchSiteURL=' + $("#SearchSiteURL").attr('value') ;  
   }
 //    + '&selSites=' + par3 + '&SearchSiteURL=' + par4;  
   window.open(formActionn,"_self"); 

 }
 
}    
function validatesearchDesktop(link,par1,par2,par3)
{
 var regex= "/[-!$%&^<>*()_+@|~\"\'`=\\#{}\\[\\]:;?,.\\/";
 var searchText = jQuery.trim($('.desktop-header #txt_search').val());
 
 if(jQuery.trim($('.desktop-header #txt_search').val()) == jQuery.trim($('#viewSearch').html()) || jQuery.trim($('.desktop-header #txt_search').val()) == jQuery.trim($('#mcdSearch').html()) || jQuery.trim($('.desktop-header #txt_search').val()) == jQuery.trim($('#siteSearch').html()) || jQuery.trim($('.desktop-header #txt_search').val()) =='' )
 {
      $('.desktop-header #searchalert').show();
     
 } 
else
 {
searchText = rejectCheck(regex,searchText);
par1 = rejectCheck(regex,par1);
par2 = rejectCheck(regex,par2);
par3 = rejectCheck(regex,par3);

  $('.desktop-header #searchalert').hide();
  if(par1 == 'ja')
   {
   var formActionn = link + '?qt=' + encodeURIComponent(searchText) + '&la=' + par1 + '&mkt=' + par2+ '&inthe=' + par3 ;
   }
   else
   {
    var formActionn = link + '?qt=' +  escape(searchText) + '&la=' + par1 + '&mkt=' + par2+ '&inthe=' + par3 ;
   }
   if($(".desktop-header #selSites").attr('value') =='')
   {
     formActionn  = formActionn + '&selSites=';
   } 
    if($(".desktop-header #SearchSiteURL").attr('value') != 'default')
   {
    formActionn  = formActionn + '&SearchSiteURL=' + $(".desktop-header #SearchSiteURL").attr('value') ;  
   }
 //    + '&selSites=' + par3 + '&SearchSiteURL=' + par4;  
   window.open(formActionn,"_self"); 

 }
 
}
function validatesearchMobile(link,par1,par2,par3)
{
 var regex= "/[-!$%&^<>*()_+@|~\"\'`=\\#{}\\[\\]:;?,.\\/";
 var searchText = jQuery.trim($('.mobile-header #txt_search').val());
 
 if(jQuery.trim($('.mobile-header #txt_search').val()) == jQuery.trim($('#viewSearch').html()) || jQuery.trim($('.mobile-header #txt_search').val()) == jQuery.trim($('#mcdSearch').html()) || jQuery.trim($('.mobile-header #txt_search').val()) == jQuery.trim($('#siteSearch').html()) || jQuery.trim($('.mobile-header #txt_search').val()) =='' )
 {
      $('.mobile-header #searchalert1').show();
     
 } 
else
 {
searchText = rejectCheck(regex,searchText);
par1 = rejectCheck(regex,par1);
par2 = rejectCheck(regex,par2);
par3 = rejectCheck(regex,par3);

  $('.mobile-header #searchalert1').hide();
  if(par1 == 'ja')
   {
   var formActionn = link + '?qt=' + encodeURIComponent(searchText) + '&la=' + par1 + '&mkt=' + par2+ '&inthe=' + par3 ;
   }
   else
   {
    var formActionn = link + '?qt=' +  escape(searchText) + '&la=' + par1 + '&mkt=' + par2+ '&inthe=' + par3 ;
   }
   if($(".mobile-header #selSites").attr('value') =='')
   {
     formActionn  = formActionn + '&selSites=';
   } 
    if($(".mobile-header #SearchSiteURL").attr('value') != 'default')
   {
    formActionn  = formActionn + '&SearchSiteURL=' + $(".mobile-header #SearchSiteURL").attr('value') ;  
   }
 //    + '&selSites=' + par3 + '&SearchSiteURL=' + par4;  
   window.open(formActionn,"_self"); 

 }
 
} 

 
function changeSize(img,size)
{
 img.width= img.width*size;
}     
            
//Past Stories JS
function pastStoriesNext(tableIdFlag, traverseNext, traverseBack){
    $("#table_"+tableIdFlag).css('display','none');
    $("#table_"+traverseNext).css('display','block');  
    tableIdFlag++;      
    traverseNext++;
    traverseBack++;
        
    if($("#table_"+traverseNext).attr('id')){    
        $("#next").css('display','block');
    }
    else{   
        $("#next").css('display','none');
    }
    if(traverseBack>0){
    $("#pre").css('display','block');
    } 
}

function pastStoriesPrev(tableIdFlag, traverseNext, traverseBack){
    traverseBack--;
    $("#table_"+tableIdFlag).css('display','none');
    $("#table_"+traverseBack).css('display','block');  
    tableIdFlag--;
    traverseNext--;
    if(traverseBack>0){
        $("#pre").css('display','block');
    }
    else{
        $("#pre").css('display','none');
    }
    $("#next").css('display','block');
}   
function openSiteLink(sURI, launchType, sServerName, linkType, PageName, entityName) {
        if(sURI.indexOf('/content/')==0)sURI=sURI.substring(8);
        var link = sServerName + sURI;
        if(!TrimString(link)=="" || !link=="#")
        {
             if(checkInternalLink(link)=="false" && link.indexOf('/')!=0)
             {
                 window.open(link, '', 'location=yes,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,width=800,height=600')
 
              }else
              {

                 window.open(link, '_self', 'location=yes,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,width=800,height=600')
              }

 
        }
        
    }     
    
    
    //adjust content area for missing sidebars
    $(document).ready(function() {
        var leftColWidth = $('#left-widgets-column').width();
       //alert("left-------------->"+leftColWidth);
        var rightColWidth = $('#right_content_par').width();
       //alert("right------------->"+rightColWidth);
        var contentColWidth = 960 - leftColWidth - rightColWidth;
       //  alert("content----------->"+contentColWidth);
        if (leftColWidth != 0) {
            contentColWidth = contentColWidth-25;
        //    alert("LeftcontentColWidth---------->"+contentColWidth);
        }
        if (rightColWidth != 0) {
            contentColWidth = contentColWidth - 20;
           //  alert("Right contentColWidth---------->"+contentColWidth);
        }
        if ($('.cq-wcm-edit')[0]) {
            if (window.location.href.indexOf('na/us') != -1) {
                //$('#content_txt').css({'width':'490px !important'});
                $('#content_txt').css({'width':'490px'});
            } else {
                $('#content_txt').css({'width':'420px'});
            }
        } else {
              if(contentColWidth > 710 && leftColWidth != 0)
              {
                contentColWidth  = 710;
              }
            //  alert("contentColWidth----->"+contentColWidth);
            $('#content_txt').css({'width':contentColWidth});
            $('#content_txt').find('.parsys_column').each(function() {
                var parHeight = $(this).height();
                
                var trueHeight = 0;
                if ( $(this).attr('id') == 'mainColumnCntrl' ) { 
                    //skip
                } else {
                    $(this).find('.parbase').each(function() {
                        trueHeight += $(this).height();
                    });
                    if (parHeight < trueHeight) {
                        $(this).height(trueHeight);
                    }
                }
            });
        }
    });
  
   
   
