var selectedAccordian = 0;
function activateAccordian(i){
    if( i != selectedAccordian){
        $( "ul.ptw-priority-points li:nth-child(" + selectedAccordian + ")" ).removeClass("active");
        $( "ul.ptw-priority-points li:nth-child(" + i + ")" ).addClass("active");
        selectedAccordian = i;
    }else{
        $( "ul.ptw-priority-points li:nth-child(" + selectedAccordian + ") " ).removeClass("active");
        selectedAccordian = 0;
    }
}

$(window).on("scroll", function(){
    stickyNav();
});
$(window).on("load", function(){
    stickyNav();
});

function stickyNav(){
    var pos = $(this).scrollTop();
    var NAV = $(".nav");
    if(pos >=  2090 && !NAV.hasClass("sticky")){
        NAV.addClass("sticky");
    }else if(pos < 2090 && NAV.hasClass("sticky")){
        NAV.removeClass("sticky");
    }
}

$("a[href^=#]").click(function(e) { 
    e.preventDefault(); 
    var dest = $(this).attr('href'); 
    $('html,body').animate({ 
        scrollTop: $(dest).offset().top 
    }, 'slow'); 
});
