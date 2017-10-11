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
            html+="<li class='has-children'><a>" + landing.Title +"</a>";
            if(landing.children.length>0 ){
                
                html+="<ul class='cd-secondary-dropdown is-hidden'>";
                html+="<li class='go-back'><a href='#' id='mobileSubMenuHeading'>"+landing.Title+"</a></li>";
                for(var i=0;i<landing.children.length;i++){
                    var child = landing.children[i];
                    parentTitle = landing.Title;
                    childtitle = child.Title;
                    childlink = child.URL;
                    childtarget = child.Launch;
                    html += "<li><a href='"+childlink+"' target='"+childtarget+"'> "+childtitle + "</a></li>";
                }
                //html + "</ul></li>";
                html+="</ul>";
            }
            html+="</li>";
            /*else{
                html+="<li><a href='"+landing.URL+"'>" + landing.Title +"</a></li>";
            }*/
            
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
    $(id).append(html);
    var navHTML = $(id).html();
    if(navHTML == undefined){
        window.location.reload(true);
    }
    var mobileNavDividerText = "";
    var url = UserInfoObject.viewPath + '.resmobilelinks.html';
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
            $(id).append(mExtraLinHTML);
            mobileNavDividerText = HeaderInfoObject.mobileNavDividerText;
        }
    });
    
    var topNavPath = $("#rootPath").html();
    var absParentLevel = $("#absParentLevel").html();
    if(topNavPath == undefined){
        topNavPath = "";
    }
    if(absParentLevel == undefined ){
        absParentLevel = "";
    }
    
    if(topNavPath != "" || absParentLevel != "" ){
        var url = UserInfoObject.viewPath + '.resTopNavigation.html?rootPath='+topNavPath+'&absParentLevel='+absParentLevel;
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
                var topNavLinksHTML = HeaderInfoObject.topNavLinks;
				topNavLinksHTML += "<li class='cd-divider'>"+mobileNavDividerText+"</li>";
                //$(id).append(topNavLinksHTML);
                $(".new-searchbox-mobile-li").after(topNavLinksHTML);

                
                /* THIS IS THE NEW MOBILE RIGHT SLIDE NAVIGATION */
                //open/close mega-navigation
                $('.mobile-header .cd-dropdown-trigger').on('click', function(event){
                    //event.preventDefault();
					toggleNav();
                });
            
                //close meganavigation
                $('.cd-dropdown .cd-close').on('click', function(event){
                    //event.preventDefault();
                    //$('.mobile-header #mnav').hide();
                    //$('.mobile-header #mextralinks').hide();
                    toggleNav();
                });
            
                //on mobile - open submenu
                $('.mobile-header .has-children').children('a').on('click', function(event){
                    //prevent default clicking on direct children of .has-children 
                    //event.preventDefault();
                    var selected = $(this);
                    selected.next('ul').removeClass('is-hidden').end().parent('.has-children').parent('ul').addClass('move-out');
                    
                    
                    //console.log('dfsdfsdfsdf sdf sd');
                    $('.new-searchbox-mobile-li').fadeOut();
                    
                    
                    
                    
                    $("body").animate({ scrollTop:0 }, "fast");
                            $(".cd-dropdown-content").animate({ scrollTop:0 }, "fast");
                    
                    
                });
            
                //on desktop - differentiate between a user trying to hover over a dropdown item vs trying to navigate into a submenu's contents
                var submenuDirection = ( !$('.cd-dropdown-wrapper').hasClass('open-to-left') ) ? 'right' : 'left';
                $('.cd-dropdown-content').menuAim({
                    activate: function(row) {
                        $(row).children().addClass('is-active').removeClass('fade-out');
                        if( $('.cd-dropdown-content .fade-in').length == 0 ) $(row).children('ul').addClass('fade-in');
                    },
                    deactivate: function(row) {
                        $(row).children().removeClass('is-active');
                        if( $('li.has-children:hover').length == 0 || $('li.has-children:hover').is($(row)) ) {
                            $('.cd-dropdown-content').find('.fade-in').removeClass('fade-in');
                            $(row).children('ul').addClass('fade-out')
                        }
                    },
                    exitMenu: function() {
                        $('.cd-dropdown-content').find('.is-active').removeClass('is-active');
                        return true;
                    },
                    submenuDirection: submenuDirection,
                });

                //submenu items - go back link
                $('.go-back').on('click', function(){
                    var selected = $(this),
                        visibleNav = $(this).parent('ul').parent('.has-children').parent('ul');
                    selected.parent('ul').addClass('is-hidden').parent('.has-children').parent('ul').removeClass('move-out');
                    
                    if($('ul.cd-dropdown-content').hasClass('move-out') == false){
                        
                        $('.new-searchbox-mobile-li').fadeIn();
                        
                    }
                    
                    
                }); 

                $('a.cd-dropdown-trigger').click(function(){
    	            $('body').toggleClass('mobile-fixed-body');
				})

                //IE9 placeholder fallback
                //credits http://www.hagenburger.net/BLOG/HTML5-Input-Placeholder-Fix-With-jQuery.html
                if(!Modernizr.input.placeholder){
                    $('[placeholder]').focus(function() {
                        var input = $(this);
                        if (input.val() == input.attr('placeholder')) {
                            input.val('');
                        }
                    }).blur(function() {
                        var input = $(this);
                        if (input.val() == '' || input.val() == input.attr('placeholder')) {
                            input.val(input.attr('placeholder'));
                        }
                    }).blur();
                    $('[placeholder]').parents('form').submit(function() {
                        $(this).find('[placeholder]').each(function() {
                            var input = $(this);
                            if (input.val() == input.attr('placeholder')) {
                                input.val('');
                            }
                        })
                    });
                }
            }
        });
    }
    else{
        /* THIS IS THE NEW MOBILE RIGHT SLIDE NAVIGATION */
        //open/close mega-navigation
        $('.mobile-header .cd-dropdown-trigger').on('click', function(event){
            //event.preventDefault();
			toggleNav();
        });
    
        //close meganavigation
        $('.cd-dropdown .cd-close').on('click', function(event){
            //event.preventDefault();
            //$('.mobile-header #mnav').hide();
            //$('.mobile-header #mextralinks').hide();
            toggleNav();
        });
    
        //on mobile - open submenu
        $('.mobile-header .has-children').children('a').on('click', function(event){
            //prevent default clicking on direct children of .has-children 
            //event.preventDefault();
            var selected = $(this);
            $('a#mobileSubMenuHeading').each(function(i){
                $(this).html(selected.html());
            });
            selected.next('ul').removeClass('is-hidden').end().parent('.has-children').parent('ul').addClass('move-out');
            
            
            //console.log('dfsdfsdfsdf sdf sd');
            $('.new-searchbox-mobile-li').fadeOut();
            
            
            
            
            $("body").animate({ scrollTop:0 }, "fast");
                    $(".cd-dropdown-content").animate({ scrollTop:0 }, "fast");
            
            
        });
    
        //on desktop - differentiate between a user trying to hover over a dropdown item vs trying to navigate into a submenu's contents
        var submenuDirection = ( !$('.cd-dropdown-wrapper').hasClass('open-to-left') ) ? 'right' : 'left';
        $('.cd-dropdown-content').menuAim({
            activate: function(row) {
                $(row).children().addClass('is-active').removeClass('fade-out');
                if( $('.cd-dropdown-content .fade-in').length == 0 ) $(row).children('ul').addClass('fade-in');
            },
            deactivate: function(row) {
                $(row).children().removeClass('is-active');
                if( $('li.has-children:hover').length == 0 || $('li.has-children:hover').is($(row)) ) {
                    $('.cd-dropdown-content').find('.fade-in').removeClass('fade-in');
                    $(row).children('ul').addClass('fade-out')
                }
            },
            exitMenu: function() {
                $('.cd-dropdown-content').find('.is-active').removeClass('is-active');
                return true;
            },
            submenuDirection: submenuDirection,
        });
    
        //submenu items - go back link
        $('.go-back').on('click', function(){
            var selected = $(this),
                visibleNav = $(this).parent('ul').parent('.has-children').parent('ul');
            selected.parent('ul').addClass('is-hidden').parent('.has-children').parent('ul').removeClass('move-out');
            
            if($('ul.cd-dropdown-content').hasClass('move-out') == false){
                
                $('.new-searchbox-mobile-li').fadeIn();
                
            }
            
            
        }); 
    	$('a.cd-dropdown-trigger').click(function(){
            $('body').toggleClass('mobile-fixed-body');
        })
        //IE9 placeholder fallback
        //credits http://www.hagenburger.net/BLOG/HTML5-Input-Placeholder-Fix-With-jQuery.html
        if(!Modernizr.input.placeholder){
            $('[placeholder]').focus(function() {
                var input = $(this);
                if (input.val() == input.attr('placeholder')) {
                    input.val('');
                }
            }).blur(function() {
                var input = $(this);
                if (input.val() == '' || input.val() == input.attr('placeholder')) {
                    input.val(input.attr('placeholder'));
                }
            }).blur();
            $('[placeholder]').parents('form').submit(function() {
                $(this).find('[placeholder]').each(function() {
                    var input = $(this);
                    if (input.val() == input.attr('placeholder')) {
                        input.val('');
                    }
                })
            });
        }
        
    }
    
    
    
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
    //alert("Nav Bar URL Top Nav:: " + url);
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

function toggleNav(){
        var navIsVisible = ( !$('.cd-dropdown').hasClass('dropdown-is-active') ) ? true : false;
        $('.cd-dropdown').toggleClass('dropdown-is-active', navIsVisible);
        $('.cd-dropdown-trigger').toggleClass('dropdown-is-active', navIsVisible);
        if( !navIsVisible ) {
            $('.cd-dropdown').one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend',function(){
                $('.has-children ul').addClass('is-hidden');
                $('.move-out').removeClass('move-out');
                $('.is-active').removeClass('is-active');
            }); 
        }
    }