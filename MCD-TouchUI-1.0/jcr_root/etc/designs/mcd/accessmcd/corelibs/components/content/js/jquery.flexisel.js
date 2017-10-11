/*
 * File: jquery.flexisel.js  
 * Version: 1.0.2
 * Description: Responsive carousel jQuery plugin
 * Author: 9bit Studios
 * Copyright 2012, 9bit Studios
 * http://www.9bitstudios.com
 * Free to use and abuse under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 */
(function ($) {
    $.fn.flexisel = function(options) {
        var defaults = $.extend({
            visibleItems : 5,
            animationSpeed : 200,
            autoPlay : false,
            autoPlaySpeed : 3000,
            pauseOnHover : true,
            setMaxWidthAndHeight : false,
            clone : false
        }, options);
        
        /******************************
        Private Variables
         *******************************/
        var initialCount = 1;
        var object = $(this);
        var settings = $.extend(defaults, options);
        var itemsWidth; // Declare the global width of each item in carousel
        var canNavigate = true;
        var itemsVisible = settings.visibleItems; // Get visible items        
        var totalItems = object.children().length; // Get number of elements
        var responsivePoints = [];
        var activeIndex = 0;
        
        /******************************
        Public Methods
        *******************************/
        var methods = {
            init : function() {
                return this.each(function() {
                    methods.appendHTML();
                    methods.setEventHandlers();
                    methods.initializeItems();
                });
            },
            
            /******************************
            Initialize Items
            Fully initialize everything. Plugin is loaded and ready after finishing execution
        *******************************/
            initializeItems : function() {

                var listParent = object.parent();
                var innerHeight = listParent.height();                
                var childSet = object.children();               
                methods.sortResponsiveObject(settings.responsiveBreakpoints);
                
                var innerWidth = listParent.width(); // Set widths
                itemsWidth = (innerWidth) / itemsVisible;
                childSet.width(itemsWidth);  
                /*if (settings.clone) {
                    childSet.last().insertBefore(childSet.first());
                    childSet.last().insertBefore(childSet.first());
                    object.css({
                        'left' : -itemsWidth
                    });
                }*/

                object.fadeIn();
                $(window).trigger("resize"); // needed to position arrows correctly

            },
            
        /******************************
            Append HTML
            Add additional markup needed by plugin to the DOM
        *******************************/
            appendHTML : function() {
                object.addClass("nbs-flexisel-ul");
                object.wrap("<div class='nbs-flexisel-container'><div class='nbs-flexisel-inner'></div></div>");
                object.find("li").addClass("nbs-flexisel-item");

                if (settings.setMaxWidthAndHeight) {
                    var baseWidth = $(".nbs-flexisel-item a").width();
                    var baseHeight = $(".nbs-flexisel-item a").height();
                    $(".nbs-flexisel-item a").css("max-width", baseWidth);
                    $(".nbs-flexisel-item a").css("max-height", baseHeight);
                }
                $("<div class='nbs-flexisel-nav-left'></div><div class='nbs-flexisel-nav-right'></div>").insertAfter(object);
                /*if (settings.clone) {
                    var cloneContent = object.children().clone();
                    object.append(cloneContent);
                }*/
            },
            /******************************
            Set Event Handlers
        Set events: click, resize, etc
            *******************************/
            setEventHandlers : function() {

                var listParent = object.parent();
                var childSet = object.children();
                var leftArrow = listParent.find($(".nbs-flexisel-nav-left"));
                var rightArrow = listParent.find($(".nbs-flexisel-nav-right"));

                $(window).on("resize", function(event) {

                    methods.setResponsiveEvents();

                    var innerWidth = $(listParent).width();
                    var innerHeight = $(listParent).height();
                    //alert("Inner Width :: " + innerWidth);
                    itemsWidth = (innerWidth) / itemsVisible;
                    //alert("Items Width :: " + itemsWidth);
                    childSet.width(itemsWidth);
                    if (settings.clone) {
                        object.css({
                            'left' : -itemsWidth                            
                        });
                    }else {
                        object.css({
                            'left' : 0
                        });
                    }

                    var halfArrowHeight = (leftArrow.height()) / 2;
                    var arrowMargin = (innerHeight / 2) - halfArrowHeight;
                    leftArrow.css("top", arrowMargin + "px");
                    rightArrow.css("top", arrowMargin + "px");

                });
                $(leftArrow).on("click", function(event) {
                    methods.scrollLeft();
                });
                $(rightArrow).on("click", function(event) {
                    methods.scrollRight();
                });
                if (settings.pauseOnHover == true) {
                    $(".nbs-flexisel-item").on({
                        mouseenter : function() {
                            canNavigate = false;
                        },
                        mouseleave : function() {
                            canNavigate = true;
                        }
                    });
                }
                if (settings.autoPlay == true) {

                    setInterval(function() {
                        if (canNavigate == true)
                            methods.scrollRight();
                    }, settings.autoPlaySpeed);
                }

            },
            /******************************
            Set Responsive Events
            Set breakpoints depending on responsiveBreakpoints
            *******************************/            
            
            setResponsiveEvents: function() {
                var contentWidth = $('html').width();
                
                if(settings.enableResponsiveBreakpoints) {
                    
                    var largestCustom = responsivePoints[responsivePoints.length-1].changePoint; // sorted array 
                    
                    for(var i in responsivePoints) {
                        
                        if(contentWidth >= largestCustom) { // set to default if width greater than largest custom responsiveBreakpoint 
                            itemsVisible = settings.visibleItems;
                            break;
                        }
                        else { // determine custom responsiveBreakpoint to use
                        
                            if(contentWidth < responsivePoints[i].changePoint) {
                                itemsVisible = responsivePoints[i].visibleItems;
                                break;
                            }
                            else
                                continue;
                        }
                    }
                }
            },

            /******************************
            Sort Responsive Object
            Gets all the settings in resposiveBreakpoints and sorts them into an array
            *******************************/            
            
            sortResponsiveObject: function(obj) {
                
                var responsiveObjects = [];
                
                for(var i in obj) {
                    responsiveObjects.push(obj[i]);
                }
                
                responsiveObjects.sort(function(a, b) {
                    return a.changePoint - b.changePoint;
                });
            
                responsivePoints = responsiveObjects;
            },
            
            /******************************
            Scroll Left
            *******************************/
            scrollLeft : function() {
                if (object.position().left < 0) {
                    if (canNavigate == true) {
                        canNavigate = false;

                        var listParent = object.parent();
                        var innerWidth = listParent.width();

                        itemsWidth = (innerWidth) / itemsVisible;

                        var childSet = object.children();
                        
                        var objectWidth = object.css("left");
                        objectWidth = objectWidth.replace("px","");
                        var total = parseInt(objectWidth) + itemsWidth;
                        
                        //alert(total);
                        
                       // if((total > 1 || total <= 0 )&& total != 1.875)
                        //{
                            object.animate({
                                'left' : "+=" + itemsWidth
                            }, {
                                queue : false,
                                duration : settings.animationSpeed,
                                easing : "linear",
                                complete : function() {
                                    /*if (settings.clone) {
                                    
                                        childSet.last().insertBefore(
                                                childSet.first()); // Get the first list item and put it after the last list item (that's how the infinite effects is made)                                   
                                    }*/
                                    //methods.adjustScroll();
                                    methods.adjustNavigation();
                                    canNavigate = true;
                                }
                            });
                       //}
                        activeIndex = activeIndex - 1;                     
                    }
                }
            },
            /******************************
            Scroll Right
            *******************************/            
            scrollRight : function() {    
                //alert("Inside scroll right");          
                var listParent = object.parent();
                                               
                var innerWidth = listParent.width();            
                itemsWidth = (innerWidth) / itemsVisible;               
                var difObject = (itemsWidth - innerWidth);              
                var objPosition = (object.position().left + ((totalItems-itemsVisible)*itemsWidth)-innerWidth);    
                var count = totalItems - itemsVisible;
                var diff = count-1;
                
                
                if((difObject < Math.ceil(objPosition)) && (!settings.clone)){              
                    if (canNavigate == true) {
                        canNavigate = false;                    
    
                        object.animate({
                            'left' : "-=" + itemsWidth
                        }, {
                            queue : false,
                            duration : settings.animationSpeed,
                            easing : "linear",
                            complete : function() {                                
                                methods.adjustScroll();
                                methods.adjustNavigation();
                                canNavigate = true;
                            }
                        });
                        activeIndex = activeIndex + 1;
                    }
                    
                } else if(settings.clone){              
                    if (canNavigate == true) {
                        canNavigate = false;                                            
                        var childSet = object.children();   
                    
                       //alert("Initial Count"+initialCount);
                        //alert("Count"+count); 
                        //alert("Left"+object.css("left"));
                        var objectWidth = object.css("left");
                        objectWidth = objectWidth.replace("px","");
                        var objectInt = parseInt(objectWidth);
                        //alert(objectInt);
                        var check = count+diff;
                        var allowedWidth = 91.875 * (3+count);
                        allowedWidth = parseInt(allowedWidth);

                       //alert(check);  
                       //alert("AllowedWidth "+allowedWidth);                       
                       //alert("Object Width"+objectInt);                                              
                    
                        //if(initialCount < check)  
                        //{
                            //alert("1")
                            //if(objectInt > -allowedWidth)
                            //{
                                //alert("2");
                                 //if(initialCount >= count+1)
                                 //{  
                                     //alert("3")
                                     //initialCount = 1;                                                                     
                                     //do nothing
                                     //alert("TEST459458");
                                     //alert(object.css("left"));                                     
                                 //}else
                                 //{                                      
                                    //alert("4");
                                    object.animate({
                                    'left' : "-=" + itemsWidth
                                    }, {
                                        queue : false,
                                        duration : settings.animationSpeed,
                                        easing : "linear",
                                        complete : function() {                                                                    
                                            canNavigate = true;
                                        }
                                    });
                               
                                 //}                                
                           // }
                            //initialCount++;
                        //}else
                        //{    
                            //alert("ELSE");
                          // var leftValue = object.css("left");
                           //alert(leftValue);
                           //object.css("left","")                       
                          // initialCount = 1;
                        //}
                    }
                };                
            },
            /******************************
            Adjust Scroll 
             *******************************/
            adjustScroll : function() {
                var listParent = object.parent();
                var childSet = object.children();

                var innerWidth = listParent.width();
                itemsWidth = (innerWidth) / itemsVisible;
                childSet.width(itemsWidth);
                if (settings.clone) {
                    object.css({
                        'left' : -itemsWidth
                    });
                }
                
            },
            /******************************
            Adjust Navigation 
            *******************************/
            adjustNavigation : function() {
                var parentEl = object.parent(),
                prevBtn = parentEl.find('.nbs-flexisel-nav-left'),
                nextBtn = parentEl.find('.nbs-flexisel-nav-right');

                if (activeIndex >= totalItems - itemsVisible) {
                    /*prevBtn.css('display', '');
                    nextBtn.css('display', 'none');*/
                    prevBtn.css('opacity', '');
                    nextBtn.css('opacity', '0.5');
                }
                else if (activeIndex <= 0) {
                    prevBtn.css('opacity', '0.5');
                    nextBtn.css('opacity', '');
                }
                else {
                    prevBtn.css('opacity', '');
                    nextBtn.css('opacity', '');
                }
            }
        };
        if (methods[options]) { // $("#element").pluginName('methodName', 'arg1', 'arg2');
            return methods[options].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof options === 'object' || !options) { // $("#element").pluginName({ option: 1, option:2 });
            return methods.init.apply(this);
        } else {
            $.error('Method "' + method + '" does not exist in flexisel plugin!');
        }
    };
})(jQuery);