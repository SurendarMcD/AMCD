function loadMenu(roundCorners){

        /*TOP NAVIGATION WITH ICONS*/
            
        var id = $(".topnav_icons").length ? "nav-icons" : "nav";
        
        $("#div_topnav > div").attr("id", id);  

        if ( $("#logo_t").height() != 0) {  
            var nav_width = $('#bread_tnav_cntr').width();
            $("#" + id).width(nav_width+"px"); 
            
            $(".bread_tnav_cntr").css({"padding-left":"260px"});
            $("#navcontainer").css({"margin-bottom":"20px"}); 
            
            $('#' + id).addClass("clearboth");
            $('#' + id).css({"margin-top":"0px", "float":"left"});
        } else {
            $('#' + id).addClass("clearboth");
            $('#' + id).css({"margin-top":"0px", "float":"left"});
        }
        $('#' + id).css("display","none");          
        
        drawDynamicNav(id, roundCorners);
                      
    } 
    
    function drawDynamicNav(id, roundCorners) { 
            $('#' + id).css("display","block");  
                   
            var mi_perRow = getLiPerRow(id); 
            $('#' + id).css("display","none");            
            var tw = $("#" + id).width();  //width of Navigation Container
            var ul_id = $("#" + id +" > ul").attr("id"); // Fetch the ID Attribute of the UL
            
            var container = $("#" + id);
            var lis = $("ul#" + ul_id + " > li", container);
            container.empty();
            
            var ul;
            for(var i = 0; i < lis.length; i++) {
                if(i % mi_perRow == 0) 
                    ul = $("<ul />").attr("id", ul_id + i).appendTo(container);
                $(lis[i]).appendTo(ul);
            }
                
            var ulId= 0;
            var w = $('ul#'+ ul_id + ulId + ' > li').size();
            
            var ul_count = $("#" + id +" > ul").size();
            var cal_width = Math.floor(tw/w)-1 + "px";
                            
            for(var i=0; i < ul_count; i++) {
                if (w==1){  
                    $('ul#' + ul_id + ulId + ' > li').css({"border-right": "none"});
                    $('ul#' + ul_id + ulId + ' > li').css({"width": (Math.floor((tw)/w) + "px")});                    
                    $("#" + id +" > ul").css({"margin": "0px"});
                    if(!$(".topnav_icons").length) {
                        $('ul#' + ul_id + ulId + ' > li').css({"border-bottom": "1px solid #cccccc"});
                    }
                } 
                else
                {
                    $('ul#' + ul_id + ulId + ' > li').css({"width": cal_width});
                    $('ul#' + ul_id + ulId + ' > li').css({"z-index": "" + (ul_count + 99 - i)});
                    ulId = ulId + mi_perRow;    
                }                 
                 
                // FUNCTION TO CHANGE THE FONT-SIZE OF THE MENU ITEM - DEPENDS ON THE NUMBER OF MENU ITEMS
                if (w <= 4) {
                    $('#' + id + ' a').css({"font-size": "14px"});
                } 
            }
            
            var submenu_width = Math.floor(tw/w)-3 + "px";
            $(".sub-menu").css({"width": submenu_width});
            
             if(w == 1 && ul_count == 1 ) {
                if(id == 'nav') {
                    var li_elem = $('#nav ul li'); 
                    if(!$(li_elem).hasClass('both_side_active') && $(li_elem).hasClass('active')) {
                        $(li_elem).addClass("straight_nav_active");                        
                    }
                    else if(!$(li_elem).hasClass('both_side_active') && !$(li_elem).hasClass('active') && !$(li_elem).hasClass('both_side')){
                       $(li_elem).addClass("straight_nav");
                                               
                    }
                }
                else if(id == 'nav-icons') {                    
                    var li_elem = $('#nav-icons ul li'); 
                    if(!$(li_elem).hasClass('both_side_active') && $(li_elem).hasClass('active')) {
                        $(li_elem).addClass("straight_navicons_active");                        
                    }
                    else if(!$(li_elem).hasClass('both_side_active') && !$(li_elem).hasClass('active') && !$(li_elem).hasClass('both_side')){
                        $(li_elem).addClass("straight_navicons");                         
                    }
                }
            } 
            
                               
                 var li_img_height = 0;
                 for(var i=0; i < ul_count; i++) {
                 
                    if(roundCorners == "false") {                               
                        $('#' + id + ' > ul:nth-child(' + (i+1) + ') > li:first').css("border-left","1px solid #CCCCCC"); 
                    }
                    
                    //Function to adjust LI height in case icon is present in any of the LI
                    if(isUlWithIcon(id)) {
                        $('#' + id).css("display","block");
                        var li_count = $("#" + id +" > ul > li").size();
                        
                        for ( var j=0; j < li_count; j++)
                        {
                            
                            
                            var isIconPresent = $('#' + id + ' > ul:nth-child(' + (i+1) + ') > li:nth-child(' + (j+1) + ') > a > img:nth-child(1)').attr("class") == 'topnav_icons';
                            if(!isIconPresent) {
                                $("#" + id  + " > ul:nth-child(" + (i+1) + ") > li:nth-child(" + (j+1) + ") > a").css({"padding":"14px 8px", "height":"17px"});
                            }
                            else {
                                $("#" + id  + " > ul:nth-child(" + (i+1) + ") > li:nth-child(" + (j+1) + ") ").css({"height" : "45px"});                             
                                                   
                                var anchor_height = $("#" + id  + " > ul:nth-child(" + (i+1) + ") > li:nth-child(" + (j+1) + ") > a > img").height();
                                 
                                li_img_height = Math.max(anchor_height, li_img_height);                                    
                            } 
                        }
                                               
                    }
                    else {
                        var li_count = $("#" + id +" > ul > li").size(); 
                        for ( var j=0; j < li_count; j++)
                        {
                            $("#" + id  + " > ul:nth-child(" + (i+1) + ") > li:nth-child(" + (j+1) + ")").css({"height":"34px"});
                        }                       
                    }
              }
              
              if ( $("#logo_t").height() != 0) {   
                          
                 if($(".both_side").length){  
                     $(".both_side a").css({"border-right":"0"});
                     $(".both_side").attr("class","both_side700");                                    
                 }
                 if($(".both_side_active").length){
                     $(".both_side_active a").css({"border-right":"0"}); 
                     $(".both_side_active").attr("class","both_side_active700");               
                 }
                 if($(".straight_navicons").length){
                     $(".straight_navicons a").css({"border-right":"0"}); 
                 }
             }
             
            $('#' + id).css("display","block"); 
                          
    }
    
       function getLiPerRow(id) {
        var ul_count = $("#" + id +" > ul").size();
        var li_count = $("#" + id +" > ul > li").size();
        
        var li_size = 0; 
        for(var i=0; i < ul_count; i++ )                        
        {   
            for ( var j=0; j < li_count; j++)
            {
                 
                var li = '#' + id + ' > ul:nth-child(' + (i+1) + ') > li:nth-child(' + (j+1) + ') > a';
                
                var li_padding = 8; 
                var right_padding = 8;
                var arrow_padding = $(".downarrow").length ? 7 : 0;
                var icon_padding = $(".topnav_icons").length ? 5 : 0;
                var border_width = 1;
    
                var current_li_size = $(li).width() + li_padding + right_padding + arrow_padding + icon_padding + border_width  ;  
                
                if($('#' + id + ' > ul:nth-child(' + (i+1) + ') > li:nth-child(' + (j+1) + ') > a > img').length) {                    
                    current_li_size = current_li_size + 9; 
                }                 
                 
                li_size = Math.max(current_li_size, li_size);
             }
        }
        
        var tw = $("#" + id).width();   
     
        var counts_per_row = Math.floor(tw/li_size);
        
        counts_per_row = counts_per_row <= 0 ? 7 : counts_per_row;
        return counts_per_row;
    }    
       
    // Check whether icon is present in any LI of a perticular UL
    function isUlWithIcon (id){
        var ul_count = $("#" + id +" > ul").size();
        var li_count = $("#" + id +" > ul > li").size();
        
        for(var i=0; i < ul_count; i++ )                        
        {                               
            for ( var j=0; j < li_count; j++)
            {
                if($('#' + id + ' > ul:nth-child(' + (i+1) + ') > li:nth-child(' + (j+1) + ') > a > img:nth-child(1)').attr("class") == 'topnav_icons')
                    return true;
            }
        }
        return false; 
    }
        
     function setBckPosition(a, top) {   
        var classname = a.className;
        
        if (classname == 'right_side' || classname == 'right_side_active') {
            a.style.backgroundPosition = "right " + top;
        } else if (classname == 'left_side' || classname == 'left_side_active'){
            a.style.backgroundPosition = "0 " + top;
        } else {
            a.style.backgroundPosition = "-6px " + top;
        }
    } 