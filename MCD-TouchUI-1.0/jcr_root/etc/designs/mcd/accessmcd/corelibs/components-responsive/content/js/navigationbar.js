function renderNav(NavJSONobject,id, title,pUrl,url){
    //render navigation bar UI (Navigation Bar)

    var html="";
    var selchild=null;
    var parentUrl = "";
    var navLabel = title;
    var navObject;
    var pagetitle="";
   if(NavJSONobject == null)
    {
     return false;
    }
    else
    {
     navObject  = NavJSONobject ;
    } 
    
  var colSettings = navObject.flyoutColumns;
  var minLinkSettings = navObject.minLinksPerColumn;
  var childpages="";
              
    //render main navigation
  for(var p=0;p<navObject.Navigation.length;p++){
          var landing=navObject.Navigation[p];
          var landingpath="/content"+landing.URL;
          if(landingpath.indexOf(".html")>0)
          landingpath=landingpath.substring(0,landingpath.indexOf(".html"));
          childtitle = "";    
          var totalLinks = landing.children.length;
              
          var activeclass="";
          if(pUrl.indexOf(landingpath)==0){
                  selchild= landing;
                  parentUrl = landing.URL;
                  navLabel = landing.Title;
                  activeclass=" class='active'";
                  pagetitle=landing.Title;
          }
           
          if (colSettings != "off" ) {
               var maxcols=parseInt(colSettings);
               var minLinks=parseInt(minLinkSettings);             
               
               if(totalLinks == 0){
                   var colHide = " class='noFlyout'";
               } else {
                   var colHide = "";
                   while(maxcols>1 && (totalLinks/maxcols)<minLinks){
                       maxcols--;
                   }
               }
               
               var linksPerCol=Math.floor(totalLinks/maxcols);
               var extralinks=totalLinks%maxcols;
               if(extralinks>0){
                   linksPerCol++;
               }
                         
               html+="<li " + colHide + "><a href='" + landing.URL + "'"+activeclass+">" + landing.Title + "</a><div id='flyouts' class='hideFlyouts'><div id='col"+(maxcols==1?"-end":"")+"'><ul>";
               var collinks=0;
               var colcount=1;
               for(var i=0;i<landing.children.length;i++)
               {
                   var child=landing.children[i];
                   parentTitle = landing.Title;
                   childtitle=child.Title;
                   childlink=child.URL;
                   childtarget=child.Launch;
                   
                   html += "<li><a href='"+childlink+"' target='"+childtarget+"'>" + childtitle + "</a></li>";
                   collinks++;
                   
                   if(collinks==linksPerCol && colcount<maxcols) {
                           html += "</ul></div>";
                           colcount++;
                           collinks=0;
                           if(colcount==maxcols){
                               html += "<div id='col-end'><ul>";
                           }else{
                               html += "<div id='col'><ul>";
                           }
                           if(extralinks==1){
                               linksPerCol--;
                           }    
                           extralinks--;   
                    }
                 }
                 html += "</ul></div></div></li>";;
           }
           else {
               html +="<li class='noFlyout'><a href='" + landing.URL+ "'"+activeclass+">" + landing.Title+ "</a></li>";
               //build childpages
               if(pUrl.indexOf(landingpath)==0){
                      var sep="";
                      for(var i=0;i<landing.children.length;i++)
                       {
                           var child=landing.children[i];
                           childtitle=child.Title;
                           var childlandingpath="/content"+child.URL;
                           if(childlandingpath.indexOf(".html")>0)
                               childlandingpath=childlandingpath.substring(0,childlandingpath.indexOf(".html"));
                           if(pUrl.indexOf(childlandingpath)==0)
                            {
                               childtitle="<b>"+childtitle+"</b>";
                            }
                            
                            childpages+=sep+"<a href ='"+child.redURL +"' target = '" + child.Launch +  "'>" +childtitle+"</a>";
                            sep="&nbsp;&bull;&nbsp;";
                       }
                       pagetitle=landing.Title;
               }
           }
    }
    
    $(id).html(html);
   

    if(pagetitle==""){
               pagetitle=title ; 
    }

   $(".pagetitleheadingchildpages").html("<span class='textbold'>"+pagetitle+"</span>");                     
 
     $(".childpages").html(childpages);
      
    //render title in navigation bar
    navLabel = navLabel;
    var navBarLabel = navLabel.split(" ");
    var navFlag = 0;
    for(i = 0; i < navBarLabel.length; i++){        
        if(navBarLabel[i].length == 1 && /[^a-zA-Z0-9_]/.test(navBarLabel[i])) {
            navBarLabel[i] = "</b>" + navBarLabel[i] + "<b>";
            navFlag = 1; 
        }       
    }
    var navTitle = "";
    var sep = "";
    if(navFlag == 1) {
        for(i = 0; i < navBarLabel.length; i++){        
             navTitle =  navTitle + sep + navBarLabel[i];
             sep = " ";   
        }
        navTitle = "<b>" + navTitle + "</b>" ;    
    } else {    
        for(i = 0; i < navBarLabel.length; i++){        
             navTitle =  navTitle + sep + navBarLabel[i];
             sep = " "; 
             if(i == 0)  {
                 sep = " <b>"; 
             }
        }
        navTitle = navTitle + "</b>" ;
    }
    

    $('#mainPageTitle').html(navTitle); 

    //render subnavigation links in navi#gation bar for child pages
    /*
    OBSOLETE?
    if(selchild!=null) {
        
        html = "";
        var sep="";
        for(var c in selchild.children){ 
            
            var child=selchild.children[c];
            if(child.label != undefined) {    
                
                html = sep + html; 
                if(child.selected){
                        html="<li class='textbold'><a href='" + child.url + ".html'>" + child.label + "</a></li>" + html;
                }
                else{
                        if(child.childselected) {
                            html ="<li class='textbold'><a href='" + child.url + ".html'>" + child.label + "</a></li>" + html;
                       }
                        else {
                            html ="<li><a href='" + child.url + ".html'>" + child.label + "</a></li>" + html;
                       }
                }
                                            
                sep="<li class='bullet-sptr'>&bull; </li>"; 
           }            
        }
        
        $('.sec-nav-links').html(html);
    } 
    */
    
       
    if (colSettings != "off" ) setupFlyouts();
    
    
    if($("#mcdLink").length) {
        $("#mcdLink").attr("href", parentUrl) 
    } 

}



function renderSlimNav(NavJSONobject,id, title,pUrl,url){
    //render navigation bar UI (Navigation Bar)
    var html="";
    var selchild=null;
    var parentUrl = "";
    var navLabel = title;
    var navObject;
    var pagetitle="";
    var designPath = "";
    var designColor;
    var matchStr= "canada";
    var corp_style="";
    var ca_style="";
    
   if(NavJSONobject == null)
    {
     return false;
    }
    else
    {
     navObject  = NavJSONobject ;
    } 
    
  var colSettings = navObject.flyoutColumns;
  var minLinkSettings = navObject.minLinksPerColumn;
  var childpages="";
              
    //render main navigation
  for(var p=0;p<navObject.Navigation.length;p++){
          var landing=navObject.Navigation[p];
          var landingpath="/content"+landing.URL;
          if(landingpath.indexOf(".html")>0)
          landingpath=landingpath.substring(0,landingpath.indexOf(".html"));
          childtitle = "";    
          var totalLinks = landing.children.length;
              
          var activeclass="";
          if(pUrl.indexOf(landingpath)==0){
                  selchild= landing;
                  parentUrl = landing.URL;
                  navLabel = landing.Title;
                  activeclass="active";
                  pagetitle=landing.Title;


          }
                designPath = landing.DesignColor;
                designColor = designPath.split(',');

               if((UserInfoObject.view).indexOf(matchStr) != -1 ){
                ca_style = "border-bottom:5px solid "+designColor[0]+"!important;border:1px solid #d9d9d9;";
                corp_style="background: none repeat scroll 0 0 #FFFFFF; border-color: "+designColor[0]+";border-width: 1px 1px 1px 1px;"; 
                ca_border_style = "border-color:"+designColor[0]+";";
                $("#mainNavMenu").removeClass("mainNavMenu").addClass("mainNavMenu_ca");
                $("#headerwrapper").removeClass("bg_corp").addClass("bg");
                $("#stocksDiv").attr("id","stocksDiv_ca");
                
                
               }else{
                corp_style="background-color:"+designColor[0]+";";
                ca_style="";   
                ca_border_style="";
                activeclass="";
               }
           
          if (colSettings != "off" ) {
               var maxcols=parseInt(colSettings);
               var minLinks=parseInt(minLinkSettings);             
               
                   if(totalLinks == 0){
                   var colHide = " class='noFlyout'";
                   } else {
                   var colHide = "";
                   while(maxcols>1 && (totalLinks/maxcols)<minLinks){
                       maxcols--;
                   }
               }
               
               var linksPerCol=Math.floor(totalLinks/maxcols);
               var extralinks=totalLinks%maxcols;
               if(extralinks>0){
                   linksPerCol++;
               }
                
                if(activeclass == "active"){
                ca_style=ca_style+"color:"+designColor[0]+"!important;";
                }

              html+="<li style='"+corp_style+"' ><a class='hasChild "+activeclass+"' style='"+ca_style+"' href='" + landing.URL + "'><span>" + landing.Title + "</span></a>";
               var collinks=0;
               var colcount=1;
              var newclass="";
              if(maxcols==1)
              {
                newclass="nav_last";
              }else{
                  newclass="";
              }

                  if(landing.children.length>0 ){
                 html+="<div class='nav_ulContainer' style='"+corp_style+"'><ul style='"+ca_border_style+"' class='"+newclass+"'>"

               for(var i=0;i<landing.children.length;i++)
               {
                   var child=landing.children[i];
                   parentTitle = landing.Title;
                   childtitle=child.Title;
                   childlink=child.URL;
                   childtarget=child.Launch;

                   html += "<li><a href='"+childlink+"' target='"+childtarget+"' data-attr='" + designColor[1] + "'> "+childtitle + "</a></li>";

                   collinks++;


                   if(collinks==linksPerCol && colcount<maxcols) {
                           html += "</ul>";
                           colcount++;
                           collinks=0;
                         if(colcount==maxcols){
                               html += "<ul style='"+ca_border_style+"' class='nav_last'>";
                           } else {
                               html += "<ul style='"+ca_border_style+"'>";
                           }
                            
                           if(extralinks==1){
                               linksPerCol--;
                           }    
                           extralinks--;   
                    }

                 }
                  }
                 html += "</ul></div></li>";;
                 




           }
           else {
              
                 html+="<li style='"+corp_style+"'><a  style='"+ca_style+"' href='" + landing.URL + "'"+activeclass+"><span>" + landing.Title + "</span></a></li>";
              
               //build childpages
               if(pUrl.indexOf(landingpath)==0){
                      var sep="";
                      for(var i=0;i<landing.children.length;i++)
                       {
                           var child=landing.children[i];
                           childtitle=child.Title;
                           var childlandingpath="/content"+child.URL;
                           if(childlandingpath.indexOf(".html")>0)
                               childlandingpath=childlandingpath.substring(0,childlandingpath.indexOf(".html"));
                           if(pUrl.indexOf(childlandingpath)==0)
                            {
                               childtitle="<b>"+childtitle+"</b>";
                            }

                            childpages+=sep+"<a href ='"+child.redURL +"' target = '" + child.Launch +  "'>" +childtitle+"</a>";
                            sep="&nbsp;&bull;&nbsp;";
                       }
                       pagetitle=landing.Title;
               }
           }

    }

    $(id).html(html);

 $('ul#mainNavMenu li ul li a').each(function(i) {
        $(this).hover(function() {
            $(this).css("background-color",$(this).attr('data-attr'));
            
        }, function() {
            $(this).css("background","none");
           
        });
    });
    $('ul#mainNavMenu li a.hasChild').each(function() {
        //$(this).parent().find('div.nav_ulContainer').width($(this).parent().find('div.nav_ulContainer').width()+1 +'px');
        var width = 0;
       
        
       $(this).parent().find('div.nav_ulContainer ul').each(function() {
         width += $(this).width()+5;
               
        });
        //console.log(width + " :: " + $(this).parent().find('div.nav_ulContainer').width());
        $(this).parent().find('div.nav_ulContainer').width(width);
    });
  
    $('div.nav_ulContainer').css("display","none").css("visibility","visible");
    slimNavEffects();

    if(pagetitle==""){
               pagetitle=title ; 
    }

   $(".pagetitleheadingchildpages").html("<span class='textbold'>"+pagetitle+"</span>");                     

     $(".childpages").html(childpages);

    //render title in navigation bar
    navLabel = navLabel;
    var navBarLabel = navLabel.split(" ");
    var navFlag = 0;
    for(i = 0; i < navBarLabel.length; i++){        
        if(navBarLabel[i].length == 1 && /[^a-zA-Z0-9_]/.test(navBarLabel[i])) {
            navBarLabel[i] = "</b>" + navBarLabel[i] + "<b>";
            navFlag = 1; 
        }       
    }
    var navTitle = "";
    var sep = "";
    if(navFlag == 1) {
        for(i = 0; i < navBarLabel.length; i++){        
             navTitle =  navTitle + sep + navBarLabel[i];
             sep = " ";   
        }
        navTitle = "<b>" + navTitle + "</b>" ;    
    } else {    
        for(i = 0; i < navBarLabel.length; i++){        
             navTitle =  navTitle + sep + navBarLabel[i];
             sep = " "; 
             if(i == 0)  {
                 sep = " <b>"; 
             }
        }
        navTitle = navTitle + "</b>" ;
    }
    

    $('id').html(navTitle); 

    if($("#mcdLink").length) {
        $("#mcdLink").attr("href", parentUrl) 
    } 
//checkDiv();
}

function renderResponsiveSlimNav(NavJSONobject,id,title,pUrl,url){
    //render navigation bar UI (Navigation Bar)
    var html = "";
    var selchild = null;
    var parentUrl = "";
    var navLabel = title;
    var navObject;
    var pagetitle = "";
    var designPath = "";
    var designColor;
    var matchStr = "canada";
    var corp_style = "";
    var ca_style = "";
    
    if(NavJSONobject == null){
        return false;
    }
    else{
        navObject  = NavJSONobject ;
    } 
    
    var colSettings = navObject.flyoutColumns;
    var minLinkSettings = navObject.minLinksPerColumn;
    var childpages="";
    
    //render main navigation
    html+="<nav class='main-nav'><ul class='text-right'>";
    for(var p=0;p<navObject.Navigation.length;p++){
        var landing=navObject.Navigation[p];
        var landingpath="/content"+landing.URL;
        if(landingpath.indexOf(".html")>0){
            landingpath=landingpath.substring(0,landingpath.indexOf(".html"));
        }
        childtitle = "";    
        var totalLinks = landing.children.length;
        var activeclass="";
        if(pUrl.indexOf(landingpath)==0){
            selchild= landing;
            parentUrl = landing.URL;
            navLabel = landing.Title;
            activeclass="active";
            pagetitle=landing.Title;
        }
        designPath = landing.DesignColor;
        designColor = designPath.split(',');
        
        
        corp_style=designColor[0];
        ca_style="";   
        ca_border_style="";
        activeclass="";
        
        if (colSettings != "off" ) {
            var maxcols=parseInt(colSettings);
            var minLinks=parseInt(minLinkSettings);             
            
            if(totalLinks == 0){
                var colHide = " class='noFlyout'";
            } 
            else {
                var colHide = "";
                while(maxcols>1 && (totalLinks/maxcols)<minLinks){
                    maxcols--;
                }
            }
            
            var linksPerCol = Math.floor(totalLinks/maxcols);
            var extralinks=totalLinks%maxcols;
            if(extralinks>0){
                linksPerCol++;
            }
            
            var collinks = 0;
            var colcount = 1;
            var newclass = "";
            if(maxcols == 1){
                newclass = "nav_last";
            }
            else{
                newclass = "";
            }
            html+="<li class='"+corp_style+"'><a class='navItems' href='" + landing.URL + "'>" + landing.Title + "</a>";
            if(landing.children.length>0 ){
                html+="<div class='subNav' id='bigMenu'><ul>";
                
                for(var i=0;i<landing.children.length;i++){
                    var child = landing.children[i];
                    parentTitle = landing.Title;
                    childtitle = child.Title;
                    childlink = child.URL;
                    childtarget = child.Launch;
                    html += "<li><a href='"+childlink+"' target='"+childtarget+"'> "+childtitle + "</a></li>";
                    collinks++;
                    if(collinks==linksPerCol && colcount<maxcols) {
                        html += "</ul>";
                        colcount++;
                        collinks=0;
                        if(colcount==maxcols){
                            html += "<ul>";
                        } else {
                            html += "<ul>";
                        }
                        
                        if(extralinks==1){
                            linksPerCol--;
                        }    
                        extralinks--;   
                    }
                }
            }
            html+= "</ul></div></li>";
        }
        else{
            html+="<li><a class='navItems' href='" + landing.URL + "'>" + landing.Title + "</a></li>";
            //build childpages
            if(pUrl.indexOf(landingpath)==0){
                var sep="";
                for(var i=0;i<landing.children.length;i++){
                    var child=landing.children[i];
                    childtitle=child.Title;
                    var childlandingpath="/content"+child.URL;
                    if(childlandingpath.indexOf(".html")>0){
                        childlandingpath=childlandingpath.substring(0,childlandingpath.indexOf(".html"));
                    }
                    if(pUrl.indexOf(childlandingpath)==0){
                        childtitle="<b>"+childtitle+"</b>";
                    }
                    childpages+=sep+"<a href ='"+child.redURL +"' target = '" + child.Launch +  "'>" +childtitle+"</a>";
                    sep="&nbsp;&bull;&nbsp;";
                }
                pagetitle=landing.Title;
            }
        }
    }
    html+= "</ul></nav>";
    //console.log("Id :: " + id);
    //console.log(html);
    $(id).html(html);
    var navHTML = $(id).html();
    //console.log("Nav HTML :: " + navHTML);
    
    if(pagetitle==""){
        pagetitle=title ; 
    }
    
    
    //render title in navigation bar
    navLabel = navLabel;
    var navBarLabel = navLabel.split(" ");
    var navFlag = 0;
    for(i = 0; i < navBarLabel.length; i++){        
        if(navBarLabel[i].length == 1 && /[^a-zA-Z0-9_]/.test(navBarLabel[i])) {
            navBarLabel[i] = "</b>" + navBarLabel[i] + "<b>";
            navFlag = 1; 
        }       
    }
    var navTitle = "";
    var sep = "";
    if(navFlag == 1) {
        for(i = 0; i < navBarLabel.length; i++){        
            navTitle =  navTitle + sep + navBarLabel[i];
            sep = " ";   
        }
        navTitle = "<b>" + navTitle + "</b>" ;    
    } 
    else{    
        for(i = 0; i < navBarLabel.length; i++){        
            navTitle =  navTitle + sep + navBarLabel[i];
            sep = " "; 
            if(i == 0)  {
                sep = " <b>"; 
            }
        }
        navTitle = navTitle + "</b>" ;
    }
    $('id').html(navTitle); 
    
    if($("#mcdLink").length) {
        $("#mcdLink").attr("href", parentUrl) 
    } 
    
     $('.subNav').each(function() {
        var $this = $(this).find('ul'), cloned = $this.clone(), width = 0;

        cloned.css({"display": 'inline-block', "position": "relative", "left": "-5000px"}).appendTo('body');
        cloned.each(function() {
            width += $(this).outerWidth() + 20;
        });
        $this.parent().width(width);
        cloned.remove();
    });
    $('.main-nav > ul > li > a, .main-nav > ul .subNav').on('mouseover', function() {
        sectionShowHide($(this), 'subNav', true, true);
    }).on('mouseout', function() {
        sectionShowHide($(this), 'subNav', false, false);
    });
}

function renderResponsiveMobileSlimNav(NavJSONobject,id,title,pUrl,url){
    //render navigation bar UI (Navigation Bar)
    var html = "";
    var selchild = null;
    var parentUrl = "";
    var navLabel = title;
    var navObject;
    var pagetitle = "";
    var designPath = "";
    var designColor;
    var matchStr = "canada";
    var corp_style = "";
    var ca_style = "";
    
    if(NavJSONobject == null){
        return false;
    }
    else{
        navObject  = NavJSONobject ;
    } 
    
    var colSettings = navObject.flyoutColumns;
    var minLinkSettings = navObject.minLinksPerColumn;
    var childpages="";
    
    //render main navigation
    //html+="<nav class='main-nav'><ul class='text-right'>";
    for(var p=0;p<navObject.Navigation.length;p++){
        var landing=navObject.Navigation[p];
        var landingpath="/content"+landing.URL;
        if(landingpath.indexOf(".html")>0){
            landingpath=landingpath.substring(0,landingpath.indexOf(".html"));
        }
        childtitle = "";    
        var totalLinks = landing.children.length;
        var activeclass="";
        if(pUrl.indexOf(landingpath)==0){
            selchild= landing;
            parentUrl = landing.URL;
            navLabel = landing.Title;
            activeclass="active";
            pagetitle=landing.Title;
        }
        designPath = landing.DesignColor;
        designColor = designPath.split(',');
        
        
        corp_style=designColor[0];
        ca_style="";   
        ca_border_style="";
        activeclass="";
        
        if (colSettings != "off" ) {
            var maxcols=parseInt(colSettings);
            var minLinks=parseInt(minLinkSettings);             
            
            if(totalLinks == 0){
                var colHide = " class='noFlyout'";
            } 
            else {
                var colHide = "";
                while(maxcols>1 && (totalLinks/maxcols)<minLinks){
                    maxcols--;
                }
            }
            
            var linksPerCol = Math.floor(totalLinks/maxcols);
            var extralinks=totalLinks%maxcols;
            if(extralinks>0){
                linksPerCol++;
            }
            
            var collinks = 0;
            var colcount = 1;
            var newclass = "";
            if(maxcols == 1){
                newclass = "nav_last";
            }
            else{
                newclass = "";
            }
            html+="<li><a>" + landing.Title + "</a>";
            if(landing.children.length>0 ){
                html+="<div class='mSubNav'><ul>";
                
                for(var i=0;i<landing.children.length;i++){
                    var child = landing.children[i];
                    parentTitle = landing.Title;
                    childtitle = child.Title;
                    childlink = child.URL;
                    childtarget = child.Launch;
                    html += "<li><a href='"+childlink+"' target='"+childtarget+"'> "+childtitle + "</a></li>";
                }
            }
            html+= "</ul></div></li>";
        }
        else{
            html+="<li><a href='" + landing.URL + "'>" + landing.Title + "</a></li>";
            //build childpages
            if(pUrl.indexOf(landingpath)==0){
                var sep="";
                for(var i=0;i<landing.children.length;i++){
                    var child=landing.children[i];
                    childtitle=child.Title;
                    var childlandingpath="/content"+child.URL;
                    if(childlandingpath.indexOf(".html")>0){
                        childlandingpath=childlandingpath.substring(0,childlandingpath.indexOf(".html"));
                    }
                    if(pUrl.indexOf(childlandingpath)==0){
                        childtitle="<b>"+childtitle+"</b>";
                    }
                    childpages+=sep+"<a href ='"+child.redURL +"' target = '" + child.Launch +  "'>" +childtitle+"</a>";
                    sep="&nbsp;&bull;&nbsp;";
                }
                pagetitle=landing.Title;
            }
        }
    }
    //html+= "</ul></nav>";
    //console.log("Id :: " + id);
    //console.log(html);
    $(id).html(html);
    var navHTML = $(id).html();
    if(navHTML == undefined){
        window.location.reload(true);
    }
    //console.log("Nav HTML :: " + navHTML);
    var url = UserInfoObject.viewPath + '.mobilelinks.html';
    $.ajax({
        url: url,
        type: 'GET',    
        timeout: 10000, 
        cache: true,   
        error: function(){
         
        },    
        success: function(data){                                   
            HeaderInfoObject = eval('(' + data + ')');
            /*var templatePath = HeaderInfoObject.templateType;
            var awesomeBarType = HeaderInfoObject.awesomeBarType;*/
            var mExtraLinHTML = HeaderInfoObject.moblileLinks;
            $("#mextralinks").html(mExtraLinHTML);
        }
    });
    
    
    if(pagetitle==""){
        pagetitle=title ; 
    }
    
    
    //render title in navigation bar
    navLabel = navLabel;
    var navBarLabel = navLabel.split(" ");
    var navFlag = 0;
    for(i = 0; i < navBarLabel.length; i++){        
        if(navBarLabel[i].length == 1 && /[^a-zA-Z0-9_]/.test(navBarLabel[i])) {
            navBarLabel[i] = "</b>" + navBarLabel[i] + "<b>";
            navFlag = 1; 
        }       
    }
    var navTitle = "";
    var sep = "";
    if(navFlag == 1) {
        for(i = 0; i < navBarLabel.length; i++){        
            navTitle =  navTitle + sep + navBarLabel[i];
            sep = " ";   
        }
        navTitle = "<b>" + navTitle + "</b>" ;    
    } 
    else{    
        for(i = 0; i < navBarLabel.length; i++){        
            navTitle =  navTitle + sep + navBarLabel[i];
            sep = " "; 
            if(i == 0)  {
                sep = " <b>"; 
            }
        }
        navTitle = navTitle + "</b>" ;
    }
    $('id').html(navTitle); 
    
    if($("#mcdLink").length) {
        $("#mcdLink").attr("href", parentUrl) 
    } 
    
     $('.subNav').each(function() {
        var $this = $(this).find('ul'), cloned = $this.clone(), width = 0;

        cloned.css({"display": 'inline-block', "position": "relative", "left": "-5000px"}).appendTo('body');
        cloned.each(function() {
            width += $(this).outerWidth() + 20;
        });
        $this.parent().width(width);
        cloned.remove();
    });
    $('#mobileMenu').on('click', function(e) {
        //e.preventDefault();
        $(this).siblings('.mobile-subNav').slideToggle("fast");
    });

    $('.mobile-subNav #mnav > li').on('click', function(e) {
        //e.preventDefault();
        $('.mSubNav').slideUp("fast");
        if (!$(this).children('.mSubNav').is(':visible')) {
            $(this).children('.mSubNav').slideDown("fast");
        }
    });
    $('.mobile-subNav #mnav > li li').click(function(e) {
        e.stopPropagation();
    });
}
var navigationBarRetryCount=0;

function getNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath , displayType) {
    //retrieve and iterate through the view based links
    if(!getUserInfoObject(currentPage_Path)){
        setTimeout(function(){getNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath,displayType)},25);
        return;
    }
    var type =  displayType;
    var audienceType=UserInfoObject.alias;
    var view = UserInfoObject.view;
    var glob = "navigation." + audienceType +navigationBarRetryCount+ "." + view;
    var url = UserInfoObject.viewPath + '.'+glob+'.html';
    navigationBarRetryCount++;
    if(navigationBarRetryCount>5){
        $("#navrender").html("Error loading menus.");
        return;
    }
    $.ajax({
        url: url,
        type: 'GET',    
        timeout: 10000, 
        data: '', 
        dataType : "json",
        cache: true,   
        error: function(){
            location.reload(true);
        },    
        success: function(NavJSONobject){                                      
            if(navigationBarRetryCount<5 && NavJSONobject==null){
                getNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath);
            }
            else{
                if(type == 'vertical'){
                    buildNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath,NavJSONobject);
                }
                else{
                    buildSlimNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath,NavJSONobject);
                }    
            }
        }
    });                       
}
function getResponsiveNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath , displayType) {
    //retrieve and iterate through the view based links
    if(!getUserInfoObject(currentPage_Path)){
        setTimeout(function(){getResponsiveNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath,displayType)},25);
        return;
    }
    var type =  displayType;
    var audienceType=UserInfoObject.alias;
    var view = UserInfoObject.view;
    var glob = "responsivenavigation." + audienceType +navigationBarRetryCount+ "." + view;
    var url = UserInfoObject.viewPath + '.'+glob+'.html';
    navigationBarRetryCount++;
    if(navigationBarRetryCount>5){
        $("#navrender").html("Error loading menus.");
        return;
    }
    //alert("Nav Bar URL :: " + url);
    $.ajax({
        url: url,
        type: 'GET',    
        timeout: 10000, 
        data: '', 
        dataType : "json",
        cache: true,   
        error: function(){
            location.reload(true);
        },    
        success: function(NavJSONobject){                                      
            if(navigationBarRetryCount<5 && NavJSONobject==null){
                getResponsiveNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath);
            }
            else{
                if(type == 'vertical'){
                    buildNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath,NavJSONobject);
                }
                else{
                    buildResponsiveSlimNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath,NavJSONobject);
                }    
            }
        }
    });                       
}

function buildResponsiveSlimNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath,NavJSONobject){
    var audienceType=UserInfoObject.alias;
    var view = UserInfoObject.view;
    var glob = "navigation." + audienceType + "." + view;
    var url = UserInfoObject.viewPath + '.'+glob+'.html';
    
    //iterate through the view based links
    var pUrl="";
    var parenturl=''; 
    if(currentPage_Parent!=null){
        parenturl= currentPage_Parent_Path; 
    }
    
    var childtitle='';
    //get navigation details in form of JSON from navigation.jsp
    var childpages="";
    var navglobalAddtext = NavJSONobject.globalAddtext;
    if(navglobalAddtext == undefined || navglobalAddtext == null){
        navglobalAddtext = "";
    }
    
    //$("#noGlobaladtext").html(NavJSONobject.globalAddtext);
    $("#noGlobaladtext").html(navglobalAddtext);
    //iterate through the JSON object inorder to update the tree structure
    var inurl = currentPage_Path;
    
    //render view based links in navigation bar
    renderResponsiveSlimNav(NavJSONobject,".menuWrapper",child_title,(isHomepage == 'true')?" ":currentPage_Path,url); 
    renderResponsiveMobileSlimNav(NavJSONobject,"#mnav",child_title,(isHomepage == 'true')?" ":currentPage_Path,url); 
    
    var gat =  NavJSONobject.globalAddtext;
    if(gat != undefined){
        // to restrict the  length of Global Ad Text to 50 characters
        if(gat.length > 50){
            gat = gat.substring(0,50);
        }
        var trimGat = gat.replace(/^\s+|\s+$/g, '') ;
        if (trimGat.length < 1){
            $("#globaladtext").css({'display':'none'});
            $(".headingtextchildpages").css({'margin-top':'36px'});
        } 
        else{
            $("#globaladtext").css({'display':'block','visibility':'visible'});
            $("#globaladtext").html("<a href=" +  NavJSONobject.link +  " target=_blank >" + gat + "</a>");
        }
    }
    else{
        if($("#globaladtext").css("display") == "none"){
            $(".headingtextchildpages").css({'margin-top':'36px'});
        }
        else{
            $("#globaladtext").css({'display':'none'});
            $(".headingtextchildpages").css({'margin-top':'36px'});
        }
    }       
    
    
    // Stock data
    var stockURL = "https://query.yahooapis.com/v1/public/yql?q=select%20Symbol%2CName%2CDaysLow%2CDaysHigh%2CYearLow%2CYearHigh%2CLastTradePriceOnly%2CLastTradeDate%2CLastTradeTime%2CMarketCapitalization%2CChange_PercentChange%20from%20yahoo.finance.quotes%20where%20symbol%3D%22MCD%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=?";
    var arrQuote, stockPrice,stockChange,stockChangeDirection,arrStockChangePercent,res;
    $.getJSON(stockURL, function (data) {                                  
        arrQuote = data.query.results.quote;
        stockPrice = parseFloat(Math.round(arrQuote["LastTradePriceOnly"] * 100) / 100).toFixed(2);
        arrStockChangePercent = arrQuote["Change_PercentChange"].split(" - ");
        stockChange = arrStockChangePercent[0];
        res = parseFloat(Math.round(stockChange.slice(1) * 100) / 100).toFixed(2);
        stockChangeDirection = stockChange.charAt(0);
        res = stockChangeDirection + res;
        $("#stockPrice").html(stockPrice); 
        $("#stockChangePrice").html(res);
        if (stockChangeDirection === "+") {
            if(NavJSONobject.path.indexOf("/na/mcweb/") != -1){
                $("div#stocksDiv_ca").addClass("stockUp_ca"); 
            }
            else{
                $("div#stocksDiv").addClass("stockUp");      
            }
        }
        else{
            if(NavJSONobject.path.indexOf("/na/mcweb/") != -1){
                $("div#stocksDiv_ca").addClass("stockUp_ca");
            }
            else{
                $("div#stocksDiv").addClass("stockDown");
            }
        }    
    });  
       
}




function buildNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath,NavJSONobject) 
    {
       
       var audienceType=UserInfoObject.alias;
       var view = UserInfoObject.view;
       var glob = "navigation." + audienceType + "." + view;
       var url = UserInfoObject.viewPath + '.'+glob+'.html';
       
       //iterate through the view based links
        var pUrl="";
        var parenturl=''; 
        if(currentPage_Parent!=null)
        {
            parenturl= currentPage_Parent_Path; 
        }
       
        var childtitle='';
        //get navigation details in form of JSON from navigation.jsp

        var childpages="";

       var navglobalAddtext = NavJSONobject.globalAddtext;
       if(navglobalAddtext == undefined || navglobalAddtext == null){
           navglobalAddtext = "";
       }
        //$("#noGlobaladtext").html(NavJSONobject.globalAddtext);
        $("#noGlobaladtext").html(navglobalAddtext);
       
        //iterate through the JSON object inorder to update the tree structure
        var childcount=0;
        var landingtitle="";
        var linkfound=0;
        var chPage="";
        var m=0;
        var landingPage= new Array();
        var k=0;
        var existingPage= currentPage_Path;
        

        var inurl = currentPage_Path;
       // nav.updateSelected(pUrl,true); 
      
       if(NavJSONobject.Navigation.length==0)
       {
         $('#headerwrapper .top-nav .topnavigationitems').css("padding","36px 0");
       
       }  
        
       //render view based links in navigation bar
         renderNav(NavJSONobject,"#navrender",child_title,(isHomepage == 'true')?" ":currentPage_Path,url); 

        $("#nav_bar").css("display", "block");

       // url = '/utility/utility.stockdetails.html?getdata=1'; 
       
       var gat =  NavJSONobject.globalAddtext;
       if(gat != undefined)
       {
         // to restrict the  length of Global Ad Text to 50 characters
         if(gat.length > 50)                            
         {
              gat = gat.substring(0,50);
         }
         var trimGat = gat.replace(/^\s+|\s+$/g, '') ;
         if (trimGat.length < 1){
             $("#globaladtext").css({'display':'none'});
             $(".headingtextchildpages").css({'margin-top':'36px'});
         } else {
             $("#globaladtext").css({'display':'block','visibility':'visible'});
             $("#globaladtext").html("<a href=" +  NavJSONobject.link +  " target=_blank >" + gat + "</a>");
         }
       }
       else{
          if($("#globaladtext").css("display") == "none"){
              $(".headingtextchildpages").css({'margin-top':'36px'});
          }
          else{
              $("#globaladtext").css({'display':'none'});
             $(".headingtextchildpages").css({'margin-top':'36px'});
          }
       }       
   
    if(isHomepage=='true'){
       
       var dyksection="";
       $(".pagetitleheadingchildpages").html("<span class='textbold'>"+title+"</span>");    
         for(i=0;i<NavJSONobject.DYK.length;i++)
        {  
          if(NavJSONobject.DYK[i].dykDesc != "")
          {
              var dykOutput = NavJSONobject.DYK[i].dykDesc;
              
              var dykTotal = dykOutput.length;
              
              if (dykTotal > 150) { dykOutput = dykOutput.substring(0, 150) + "..."; }
              
              if (dykOutput.length > 125) {
              
                  var dykCount = (dykOutput.length / 4) + 3;
                  var dykBreak1 = dykOutput.substring(0, dykCount);
                  var dykSpace1 = dykBreak1.lastIndexOf(" ");
                  var dykLine1 = dykOutput.substring(0, dykSpace1);
                  var dykLine1Length = dykLine1.length;
                  
                  var dykCount2 = dykLine1Length + dykCount;   
                  var dykBreak2 = dykOutput.substring(0, dykCount2);
                  var dykSpace2 = dykBreak2.lastIndexOf(" ");
                  var dykLine2 = dykOutput.substring(dykLine1Length, dykSpace2);
                  var dykLine2Length = dykLine2.length;
                  
                  var dykCount3 = dykLine1Length + dykLine2Length + dykCount;
                  var dykBreak3 = dykOutput.substring(0, dykCount3);
                  var dykSpace3 = dykBreak3.lastIndexOf(" ");
                  var dykLine3 = dykOutput.substring(dykLine1Length + dykLine2Length, dykSpace3);
                  var dykLine3Length = dykLine3.length;
                  
                  var dykCount4 = dykTotal;
                  var dykLine4 = dykOutput.substring(dykLine1Length + dykLine2Length + dykLine3Length, dykTotal);
                  
              } else if (dykOutput.length > 75) {
              
                  var dykCount = (dykOutput.length / 3) + 2; 
                  var dykBreak1 = dykOutput.substring(0, dykCount);
                  var dykSpace1 = dykBreak1.lastIndexOf(" ");
                  var dykLine1 = dykOutput.substring(0, dykSpace1);
                  var dykLine1Length = dykLine1.length;
                  
                  var dykCount2 = dykLine1Length + dykCount;   
                  var dykBreak2 = dykOutput.substring(0, dykCount2);
                  var dykSpace2 = dykBreak2.lastIndexOf(" ");
                  var dykLine2 = dykOutput.substring(dykLine1Length, dykSpace2);
                  var dykLine2Length = dykLine2.length;
                  
                  var dykCount3 = dykLine1Length + dykLine2Length + dykCount;
                  var dykBreak3 = dykOutput.substring(0, dykCount3);
                  var dykSpace3 = dykBreak3.lastIndexOf(" ");
                  var dykLine3 = dykOutput.substring(dykLine1Length + dykLine2Length, dykTotal);
                  
                  var dykLine4 = "";
                  
              } else if (dykOutput.length > 30) {
              
                  var dykCount = (dykOutput.length / 2) + 1;
                  var dykBreak1 = dykOutput.substring(0, dykCount);
                  var dykSpace1 = dykBreak1.lastIndexOf(" ");
                  var dykLine1 = dykOutput.substring(0, dykSpace1);
                  var dykLine1Length = dykLine1.length;
                  
                  var dykCount2 = dykLine1Length + dykCount;   
                  var dykBreak2 = dykOutput.substring(0, dykCount2);
                  var dykSpace2 = dykBreak2.lastIndexOf(" ");
                  var dykLine2 = dykOutput.substring(dykLine1Length, dykTotal);
                  
                  var dykLine3 = "";
                  
                  var dykLine4 = "";
                  
                  
              } else {
              
                  var dykLine1 = dykOutput;

                  var dykLine2 = "";
                  
                  var dykLine3 = "";
                  
                  var dykLine4 = "";
                  
              }
              
              dyksection=dyksection+"<div><span style='WIDTH: 270px; PADDING-RIGHT: 15px; FLOAT: left;'> <a class='dyk' href="+NavJSONobject.DYK[i].dykURL+" style='color:#ffffff;'>"+dykLine1+"<br>"+dykLine2+"<br>"+dykLine3+"<br>"+dykLine4+"</a> </span></div>";

         }
       }
       $(".newHd").html("<u>"+NavJSONobject.dykTitle+"</u>");
       $(".newHd").attr("href",NavJSONobject.dykLink);
       $(".slides").html(dyksection);
       startDYKRotation();
       
       }
       // Stock data
       $("#stockPrice").html(NavJSONobject.currentPrice); 
       $("#stockChangePrice").html(NavJSONobject.changePrice);                
       $("img.stockImg").attr("src", currentDesign_getPath + "/images/" + NavJSONobject.stockImageName);   
       
     
}  

function buildSlimNavigationBar(title , currentPage_Parent , currentPage_Parent_Path,currentPage_Path,isHomepage , child_title , currentDesign_getPath,NavJSONobject){
    var audienceType=UserInfoObject.alias;
    var view = UserInfoObject.view;
    var glob = "navigation." + audienceType + "." + view;
    var url = UserInfoObject.viewPath + '.'+glob+'.html';
    
    //iterate through the view based links
    var pUrl="";
    var parenturl=''; 
    if(currentPage_Parent!=null){
        parenturl= currentPage_Parent_Path; 
    }
    
    var childtitle='';
    //get navigation details in form of JSON from navigation.jsp
    var childpages="";
    var navglobalAddtext = NavJSONobject.globalAddtext;
    if(navglobalAddtext == undefined || navglobalAddtext == null){
        navglobalAddtext = "";
    }
    
    //$("#noGlobaladtext").html(NavJSONobject.globalAddtext);
    $("#noGlobaladtext").html(navglobalAddtext);
    //iterate through the JSON object inorder to update the tree structure
    var inurl = currentPage_Path;
    
    //render view based links in navigation bar
    renderSlimNav(NavJSONobject,"#mainNavMenu",child_title,(isHomepage == 'true')?" ":currentPage_Path,url); 
    
    var gat =  NavJSONobject.globalAddtext;
    if(gat != undefined){
        // to restrict the  length of Global Ad Text to 50 characters
        if(gat.length > 50){
            gat = gat.substring(0,50);
        }
        var trimGat = gat.replace(/^\s+|\s+$/g, '') ;
        if (trimGat.length < 1){
            $("#globaladtext").css({'display':'none'});
            $(".headingtextchildpages").css({'margin-top':'36px'});
        } 
        else{
            $("#globaladtext").css({'display':'block','visibility':'visible'});
            $("#globaladtext").html("<a href=" +  NavJSONobject.link +  " target=_blank >" + gat + "</a>");
        }
    }
    else{
        if($("#globaladtext").css("display") == "none"){
            $(".headingtextchildpages").css({'margin-top':'36px'});
        }
        else{
            $("#globaladtext").css({'display':'none'});
            $(".headingtextchildpages").css({'margin-top':'36px'});
        }
    }       
    
    
    // Stock data
    var stockURL = "https://query.yahooapis.com/v1/public/yql?q=select%20Symbol%2CName%2CDaysLow%2CDaysHigh%2CYearLow%2CYearHigh%2CLastTradePriceOnly%2CLastTradeDate%2CLastTradeTime%2CMarketCapitalization%2CChange_PercentChange%20from%20yahoo.finance.quotes%20where%20symbol%3D%22MCD%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=?";
    var arrQuote, stockPrice,stockChange,stockChangeDirection,arrStockChangePercent,res;
    $.getJSON(stockURL, function (data) {                                  
        arrQuote = data.query.results.quote;
        stockPrice = parseFloat(Math.round(arrQuote["LastTradePriceOnly"] * 100) / 100).toFixed(2);
        arrStockChangePercent = arrQuote["Change_PercentChange"].split(" - ");
        stockChange = arrStockChangePercent[0];
        res = parseFloat(Math.round(stockChange.slice(1) * 100) / 100).toFixed(2);
        stockChangeDirection = stockChange.charAt(0);
        res = stockChangeDirection + res;
        $("#stockPrice").html(stockPrice); 
        $("#stockChangePrice").html(res);
        if (stockChangeDirection === "+") {
            if(NavJSONobject.path.indexOf("/na/mcweb/") != -1){
                $("div#stocksDiv_ca").addClass("stockUp_ca"); 
            }
            else{
                $("div#stocksDiv").addClass("stockUp");      
            }
        }
        else{
            if(NavJSONobject.path.indexOf("/na/mcweb/") != -1){
                $("div#stocksDiv_ca").addClass("stockUp_ca");
            }
            else{
                $("div#stocksDiv").addClass("stockDown");
            }
        }    
    });  
       
}  