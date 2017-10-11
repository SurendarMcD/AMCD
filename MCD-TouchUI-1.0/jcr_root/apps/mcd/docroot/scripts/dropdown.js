$(document).ready(function() {

    // 
    // Init current cursor position for DROPDOWN menus.
    var _current = 0;

    //
    // Bind all BACK BUTTONS to scroll window to top of document.
    $('#meal_back_button a').bind('click', function() { $(window).scrollTop(0); return false; });

    //
    // Bind toggle events to DROPDOWN selection
    $('.acts_as_dropdown').toggle(

    //
    // Function for DROPDOWN activation
        function() {
            $(this)
                .children('.dropdown_node')
                .addClass('dropdown_active')
                .bind('mouseover', function(i) {
                    _current = $(this).attr('rel');
                });
        },

    //
    // Function for DROPDOWN selection
    // |-> Deactivate DROPDOWN
    // |-> Apply selection class
    // '-> Scroll window to matching item
        function() {

            $(this).children('.dropdown_node').each(function(index, elem) {
                $(elem).removeClass('dropdown_active').removeClass('dropdown_selected');
                if ($(elem).attr('rel') == _current) {
                    $(elem).addClass('dropdown_selected');
                    if ($('#' + _current).length > 0) {
                        $(window).scrollTop($('#' + _current).offset().top);
                    } else {
                        $(this).children('.dropdown_node:first').addClass('dropdown_selected');
                    }
                } else {
                    $(this).children('.dropdown_node:first').addClass('dropdown_selected');
                }
            });

        }
    );

    /* ALINA */
    /* this is my dropdown implementation */

    $('.dropdown_trigger').click(function() {
        var holder = $(this).parent();
        var title = $(this);
        if ($(this).hasClass("dropdown_header")) {
            $(this).removeClass("dropdown_header");
            $(this).addClass("dropdown_header_active");
            holder.children('ul.dropdown_body').eq(0).slideDown('medium');
            holder.children('ul.dropdown_body').eq(0).children().bind('mouseover', function(i) {
                _current = $(this).children('a').eq(0).attr('href');
              
            });
            holder.children('ul.dropdown_body_96x31').eq(0).children().children('a').bind('click', function(){
                var _string = $(this).html();
                if ( $('label', holder).length > 0 ) {
                    $('label', holder).html(_string);
                } else {
                    holder.children().eq(0).html(_string);
                }
                holder.children('ul.dropdown_body_96x31').eq(0).slideUp('medium', function() {
                    title.removeClass("dropdown_header_active_96x31");
                    title.addClass("dropdown_header_96x31");
                });
                return false;
            });
            holder.children('ul.dropdown_body').eq(0).children().bind('click', function(i) {
                var _string = $('a', this).length > 0 ? $('a', this).eq(0).html() : $(this).html();
                if ( $('label', holder).length > 0 ) {
                    $('label', holder).html(_string);
                } else {
                    holder.children().eq(0).html(_string);
                }
                holder.children('ul.dropdown_body').eq(0).slideUp('medium', function() {
                    title.removeClass("dropdown_header_active");
                    title.addClass("dropdown_header");

                });
            });
            /*
                Bind roll-up on mouse-leave
            */
            holder.bind('mouseleave', function(){
                holder.children('ul').eq(0).slideUp('medium', function() {
                    title.removeClass("dropdown_header_active");
                    title.addClass("dropdown_header");
                });
            });
        }
        else {
            holder.children('ul.dropdown_body').eq(0).slideUp('medium', function() {
                title.removeClass("dropdown_header_active");
                title.addClass("dropdown_header");

            });

        }


    });


    /* end of ALINA */

});