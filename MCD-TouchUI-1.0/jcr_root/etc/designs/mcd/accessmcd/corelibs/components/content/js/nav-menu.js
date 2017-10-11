var slimNavEffects = function(){
        $('ul#mainNavMenu li a.hasChild').each(function() {
            
            $(this).hover(function() {
                $('div.nav_ulContainer').hide();
                $(this).parent().find('div.nav_ulContainer').css('left', '0px');
                var parent_height = $(this).parent().height();
                var parent_width = $(this).parent().width();
                var parent_pos = $(this).parent().position();
                var mainNavMenu_pos = $('ul#mainNavMenu').position();
                mainNavMenu_pos_right = $('ul#mainNavMenu').width() + mainNavMenu_pos.left;
                //alert(mainNavMenu_pos_right);
                
                $(this).parent().find('div.nav_ulContainer').css('top', parent_pos.top + parent_height).css('left', parent_pos.left);
                
                var nav_ulContainer_pos = $(this).parent().find('div.nav_ulContainer').position();
                nav_ulContainer_pos_right = $(this).parent().find('div.nav_ulContainer').width() + parseInt($(this).parent().find('div.nav_ulContainer').css('left'));
                //alert(nav_ulContainer_pos_right);
                
                if(nav_ulContainer_pos_right >= mainNavMenu_pos_right) {
                    $(this).parent().find('div.nav_ulContainer').css('left', '0px');
                    var get_right_pos = parent_pos.left - $(this).parent().find('div.nav_ulContainer').width() + parent_width;
                    $(this).parent().find('div.nav_ulContainer').css('left', get_right_pos).slideDown('fast');
                } else {
                    $(this).parent().find('div.nav_ulContainer').slideDown('fast');
                }
                var height = 0;
                $(this).parent().find('div.nav_ulContainer ul').each(function(i){
                    var ul_height = $(this).height();
                    if(height < ul_height) {
                        height = ul_height;
                    }
                });
                $(this).parent().find('div.nav_ulContainer ul').height(height+'px');
                
                
            }, function() {
                $(this).parent().find('div.nav_ulContainer').hover(function() {
                    $(this).show();
                }, function() {
                    $(this).hide();
                });
                $(this).parent().find('div.nav_ulContainer').hide();
            });
            
        });
    }