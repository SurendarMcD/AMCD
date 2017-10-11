if(typeof jQuery != 'undefined') {
        jQuery(function($) {
        $.fn.extend({
            loopedSlider: function(options) {
                var settings = $.extend({}, $.fn.loopedSlider.defaults, options);
                    return this.each(
                    function() {
                    if($.fn.jquery < '1.3.2') {return;}
                    var $t = $(this);
                    var o = $.metadata ? $.extend({}, settings, $t.metadata()) : settings;                  
                    var distance = 0;
                    var times = 1;
                    var slides = $(o.slides,$t).children().size();
                    var width = $(o.slides,$t).children().outerWidth();
                    var position = 0;
                    var active = false;
                    var number = 0;
                    var interval = 0;
                    var restart = 0;
                    var hp_pnbox = $("."+o.hp_pnbox+" li a",$t);
                    var pause=false;
                                         
                    if(o.addhp_pnbox && !$(hp_pnbox).length && slides>1){
                        var buttons = slides;
                        
                        $($t).append("<ul class="+o.hp_pnbox+">");
                        $(o.slides,$t).children().each(function(){
                            if (number<buttons) {
                                $("."+o.hp_pnbox,$t).append("<li><a rel="+(number+1)+" href=\"#\" ><img class=\"imagesrel\" id=\"rel"+(number+1)+"\" src=\"/images/blt.png\" border=\"0\" style=\"margin-right:0px;\" /></a></li>");
                                number = number+1;
                            } else {
                                number = 0;
                                return false;
                            }
                            $("."+o.hp_pnbox+" li a:eq(0)",$t).parent().addClass("active");
                        });
                        hp_pnbox = $("."+o.hp_pnbox+" li a",$t);
                        $("#rel1").attr({src:'/images/blt-hr.png'});    
                    } else {
                        $(hp_pnbox,$t).each(function(){
                            number=number+1;
                            $(this).attr("rel",number);
                            //$("#rel"+number).attr({src:'/images/blt-hr.png'});  
                            
                            $(hp_pnbox.eq(0),$t).parent().addClass("active");
                        });
                    }
 

                    if (slides===1) {
                        $(o.slides,$t).children().css({position:"absolute",top:"410",left:position,display:"block"});
                        return;
                    }
 
                    $(o.slides,$t).css({width:(slides*width)});
 
                    $(o.slides,$t).children().each(function(){
                        $(this).css({position:"absolute",left:position,display:"block"});
                        position=position+width;
                    });
 
                    $(o.slides,$t).children(":eq("+(slides-1)+")").css({position:"absolute",left:-width});
 
                    if (slides>3) {
                        $(o.slides,$t).children(":eq("+(slides-1)+")").css({position:"absolute",left:-width});
                    }
 
                    if(o.autoHeight){autoHeight(times);}
 
                    $(".next",$t).click(function(){
                        if(active===false) {
                            animate("next",true);
                            if(o.autoStart){                    
                                if (o.restart) {autoStart();}
                                else {clearInterval(sliderIntervalID);                                      
                                }
                            }
                        } return false;
                    });
 
                    $(".previous",$t).click(function(){
                        if(active===false) {    
                            animate("prev",true);
                            if(o.autoStart){
                                if (o.restart) {autoStart();}
                                else {clearInterval(sliderIntervalID);                                      
                                }
                            }
                        } return false;
                    });
 
                    $(hp_pnbox,$t).click(function(){
                        if ($(this).parent().hasClass("active")) {return false;}
                        else {
                            times = $(this).attr("rel");
                            $(hp_pnbox,$t).parent().siblings().removeClass("active");
                            $(this).parent().addClass("active");
                            animate("fade",times);
                            if(o.autoStart){
                                if (o.restart) {autoStart();}
                                else {
                                clearInterval(sliderIntervalID);                                
                                autoStart(); 
                                }
                            }
                        } return false;
                    });
 
                    $('.slideContainer',$(this)).mouseover(function(){
                        o.pause=true;                        
                    });
                    
                    $('.slideContainer',$(this)).mouseout(function(){
                        o.pause=false;
                    });
 
                    if (o.autoStart) {
                        if(o.pause) return;
                        
                        sliderIntervalID = setInterval(function(){
                            if(active===false) {animate("next",true);}
                        },o.autoStart);
                        
                         function autoStart() {                          
                                clearInterval(sliderIntervalID);
                                clearInterval(interval);
                                clearTimeout(restart);
                                    restart = setTimeout(function() {
                                        interval = setInterval( function(){
                                            animate("next",true);
                                        },o.autoStart);
                                    },o.restart);                             
                        };
                    }
 
                    function current(times) {
                        //alert(times);
                        //alert(o.data);
                        if(times===slides+1){times = 1;}
                        if(times===0){times = slides;}
                        $(hp_pnbox,$t).parent().siblings().removeClass("active");
                        $(".hp_pnbox[rel='" + (times) + "']",$t).parent().addClass("active");
                        
                        //$('#text').html(o.data[times]);
                    };
 
 
                    function autoHeight(times) {
                        if(times===slides+1){times=1;}
                        if(times===0){times=slides;}    
                        var getHeight = $(o.slides,$t).children(":eq("+(times-1)+")",$t).outerHeight();
                        $(o.container,$t).animate({height: getHeight},o.autoHeight);                    
                    };      
 
                    function animate(dir,clicked){  
                        if(o.pause) return;
                        
                        active = true;  
                        switch(dir){
                            case "next":
                            var newimg=times+1;
                            if(newimg>slides){
                            newimg=1;
                                times=0;
                            }
                            
                            $(".imagesrel").attr({src:'/images/blt.png'});  
                                $("#rel"+newimg).attr({src:'/images/blt-hr.png'});  
                                
                                times = times+1;
                                
                            $(hp_pnbox,$t).parent().siblings().removeClass("active");
                            $(this).parent().addClass("active");
                            animate("fade",times);
                            if(o.autoStart){
                                if (o.restart) {autoStart();}
                                else {autoStart();
                                clearInterval(sliderIntervalID);
                                }
                           }
                           
                           
                                /*
                $(o.slides,$t).animate({left: distance}, o.slidespeed,function(){
                                    if (times===slides+1) {
                                        times = 1;
                                        $(o.slides,$t).css({left:0},function(){$(o.slides,$t).animate({left:distance})});                           
                                        $(o.slides,$t).children(":eq(0)").css({left:0});
                                        $(o.slides,$t).children(":eq("+(slides-1)+")").css({ position:"absolute",left:-width});             
                                    }
                                    if (times===slides) $(o.slides,$t).children(":eq(0)").css({left:(slides*width)});
                                    if (times===slides-1) $(o.slides,$t).children(":eq("+(slides-1)+")").css({left:(slides*width-width)});
                                    active = false;
                                
                                }); */              
                                break; 
                            case "prev":
                                times = times-1;
                                distance = (-(times*width-width));
                                current(times);
                                if(o.autoHeight){autoHeight(times);}
                                if (slides<3){
                                    if(times===0){$(o.slides,$t).children(":eq("+(slides-1)+")").css({position:"absolute",left:(-width)});}
                                    if(times===1){$(o.slides,$t).children(":eq(0)").css({position:"absolute",left:0});}
                                }
                                $(o.slides,$t).animate({left: distance}, o.slidespeed,function(){
                                    if (times===0) {
                                        times = slides;
                                        $(o.slides,$t).children(":eq("+(slides-1)+")").css({position:"absolute",left:(slides*width-width)});
                                        $(o.slides,$t).css({left: -(slides*width-width)});
                                        $(o.slides,$t).children(":eq(0)").css({left:(slides*width)});
                                    }
                                    if (times===2 ) $(o.slides,$t).children(":eq(0)").css({position:"absolute",left:0});
                                    if (times===1) $(o.slides,$t).children(":eq("+ (slides-1) +")").css({position:"absolute",left:-width});
                                    active = false;
                                });
                                break;
                            case "fade":
                                times = [times]*1;
                            var newimg=times;
                            if(newimg>slides)
                            newimg=1;
                            
                            $(".imagesrel").attr({src:'/images/blt.png'});  
                                $("#rel"+newimg).attr({src:'/images/blt-hr.png'});  
                            
                                distance = (-(times*width-width));
                                current(times);
                                if(o.autoHeight){autoHeight(times);}
                                $(o.slides,$t).children().fadeOut(o.fadespeed, function(){
                                    $(o.slides,$t).css({left: distance});
                                    $(o.slides,$t).children(":eq("+(slides-1)+")").css({left:slides*width-width});
                                    $(o.slides,$t).children(":eq(0)").css({left:0});
                                    if(times===slides){$(o.slides,$t).children(":eq(0)").css({left:(slides*width)});}
                                    if(times===1){$(o.slides,$t).children(":eq("+(slides-1)+")").css({ position:"absolute",left:-width});}
                                    $(o.slides,$t).children().fadeIn(o.fadespeed);
                                    active = false;
                                });
                                break; 
                            default:
                                break;
                            }                   
                        };
                    }
                );
            }
        });
        $.fn.loopedSlider.defaults = {
            //container: ".container", //Class/id of main container. You can use "#container" for an id.
            slides: ".slides", //Class/id of slide container. You can use "#slides" for an id.
            hp_pnbox: "hp_pnbox", //Class name of parent ul for numbered links. Don't add a "." here.
            containerClick: true, //Click slider to goto next slide? true/false
            autoStart: 0, //Set to positive number for true. This number will be the time between transitions.
            restart: 0, //Set to positive number for true. Sets time until autoStart is restarted.
            slidespeed: 300, //Speed of slide animation, 1000 = 1second.
            fadespeed: 200, //Speed of fade animation, 1000 = 1second.
            autoHeight: 0, //Set to positive number for true. This number will be the speed of the animation.
            addhp_pnbox: false //Add hp_pnbox links based on content? true/false
        };  
    });
}   


 
 
   
