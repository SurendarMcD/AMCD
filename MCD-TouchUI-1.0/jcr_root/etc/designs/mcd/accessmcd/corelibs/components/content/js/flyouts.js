function setupFlyouts() {
    $('#navrender li').mouseover(function() {
        var fwidth = 0;
        var fheight = 0;
        var colCount = 0;
        var flyout = $(this).find('#flyouts');
        $(flyout).removeClass('hideFlyouts');
        $(flyout).addClass('showFlyouts');
        
        fheight = $(flyout).find('div').height();
        
        $(flyout).find('div').each(function() {
            fwidth = fwidth + $(this).width();
            colCount++;
            if(fheight < $(this).height()) {
                fheight = $(this).height();
                $(this).height(fheight);
                if(fheight > $(flyout).find('div').slice(0,1).height()) {
                    $(flyout).find('div').slice(0,1).height(fheight);
                }
            } else {
                $(this).height(fheight);
            }
        });
        
        $(flyout).width(fwidth + (colCount * 20));
        
        if($(flyout).width() < fwidth) {
            $(flyout).width(fwidth + (colCount * 20));
        }
        
        if($(this).find('#flyouts').height() < 10) {
            $(flyout).css({'visibility':'hidden'});
            $(flyout).removeClass('showFlyouts');
            $(flyout).addClass('hideFlyouts');
        }
    }).mouseleave(function(){
        $(this).find('#flyouts').removeClass('showFlyouts');
        $(this).find('#flyouts').addClass('hideFlyouts');
    }); 
}