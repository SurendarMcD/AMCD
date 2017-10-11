;
(function($) {
//get dynmic width for subNav menues
    $('.subNav').each(function() {
        var $this = $(this).find('ul'), cloned = $this.clone(), width = 0;

        cloned.css({"display": 'inline-block', "position": "relative", "left": "-5000px"}).appendTo('body');
        cloned.each(function() {
            width += $(this).outerWidth() + 20;
        });
        $this.parent().width(width);
        cloned.remove();
    });
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

    $('.main-nav > ul > li > a, .main-nav > ul .subNav').on('mouseover', function() {
        sectionShowHide($(this), 'subNav', true, true);
    }).on('mouseout', function() {
        sectionShowHide($(this), 'subNav', false, false);
    });
    $('#mobileMenu').on('click', function(e) {
        e.preventDefault();
        $(this).siblings('.mobile-subNav').slideToggle("fast");
    });
    $('#directory-more, #directory-more + .dir-more-section').on('click mouseover ', function(e) {
        e.preventDefault();
        sectionShowHide($(this), 'dir-more-section', true);
    }).on('mouseout', function() {
        sectionShowHide($(this), 'dir-more-section', false);
    });
    $('#q').on('click', function() {
        $(this).siblings('#search-criteria').slideDown("fast");
    });
    $('#search-criteria li').on('click', function() {
        $(this).parents('#search-criteria').slideUp("fast");
    });    
    
    $('#mrkt-View, .top-subNav').on('click mouseover ', function(e) {
        e.preventDefault();
        sectionShowHide($(this), 'top-subNav', true);
    }).on('click mouseout', function() {
        sectionShowHide($(this), 'top-subNav', false);
    });
      
    
})(jQuery);