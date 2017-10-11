/*
 * Autocomplete - jQuery plugin 1.0 Alpha
 *
 * Copyright (c) 2007 Dylan Verheul, Dan G. Switzer, Anjesh Tuladhar, Jörn Zaefferer
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Revision: $Id: jquery.autocomplete.js 3618 2007-10-10 17:36:10Z joern.zaefferer $
 *
 */
 
jQuery.fn.extend({
    autocomplete: function(urlOrData, options) {
        var isUrl = typeof urlOrData == "string";
        options = jQuery.extend({}, jQuery.Autocompleter.defaults, {
            url: isUrl ? urlOrData : null,
            data: isUrl ? null : urlOrData,
            delay: isUrl ? jQuery.Autocompleter.defaults.delay : 10
        }, options);
        
        // if highlight is set to false, replace it with a do-nothing function
        options.highlight = options.highlight || function(value) { return value; };
        // if moreItems is false, replace it w/empty string
        options.moreItems = options.moreItems || "";
        
        return this.each(function() {
            new jQuery.Autocompleter(this, options);
        });
    },
    result: function(handler) {
        return this.bind("result", handler);
    },
    search: function(handler) {
        return this.trigger("search", [handler]);
    },
    flushCache: function() {
        return this.trigger("flushCache");
    },
    setOptions: function(options){
        return this.trigger("setOptions", [options]);
    }
});

jQuery.Autocompleter = function(input, options) {

    var KEY = {
        UP: 38,
        DOWN: 40,
        DEL: 46,
        TAB: 9,
        RETURN: 13,
        ESC: 27,
        COMMA: 188
    };

    // Create jQuery object for input element
    var $input = jQuery(input).attr("autocomplete", "off").addClass(options.inputClass);

    var timeout;
    var previousValue = "";
    var cache = jQuery.Autocompleter.Cache(options);
    var hasFocus = 0;
    var lastKeyPressCode;
    var config = {
        mouseDownOnSelect: false
    };
    var select = jQuery.Autocompleter.Select(options, input, selectCurrent, config);
    
    $input.keydown(function(event) {
        // track last key pressed
        lastKeyPressCode = event.keyCode;
        switch(event.keyCode) {
        
            case KEY.UP:
                event.preventDefault();
                
                if ( select.visible() ) {
                    select.prev();
                } else {
                    onChange(0, true);
                }
                break;
                
            case KEY.DOWN:
                event.preventDefault();
                //if(!select.visible())select.visible();
                if ( select.visible() ) {
                    select.next();
                } else {
                    onChange(0, true);
                }
                break;
            
            // matches also semicolon
            case options.multiple && jQuery.trim(options.multipleSeparator) == "," && KEY.COMMA:
            case KEY.TAB:
            case KEY.RETURN:
                if( selectCurrent() ){
                    // make sure to blur off the current field
                    if( !options.multiple )
                        $input.blur();
                    event.preventDefault();
                }
                break;
                
            case KEY.ESC:
                select.hide();
                break;
                
            default:
                clearTimeout(timeout);
                timeout = setTimeout(onChange, options.delay);
                break;
        }
    }).keypress(function() {
        // having fun with opera - remove this binding and Opera submits the form when we select an entry via return
    }).focus(function(){
        // track whether the field has focus, we shouldn't process any
        // results if the field no longer has focus
        hasFocus++;
    }).blur(function() {
        hasFocus = 0;
        if (!config.mouseDownOnSelect) {
            hideResults();
        }
    }).click(function() {
        // show select when clicking in a focused field
        if ( hasFocus++ > 1 && !select.visible() ) {
            onChange(0, true);
        }
    }).bind("search", function() {
        var fn = (arguments.length > 1) ? arguments[1] : null;
        function findValueCallback(q, data) {
            var result;
            if( data && data.length ) {
                for (var i=0; i < data.length; i++) {
                    if( data[i].result.toLowerCase() == q.toLowerCase() ) {
                        result = data[i];
                        break;
                    }
                }
            }
            if( typeof fn == "function" ) fn(result);
            else $input.trigger("result", result && [result.data, result.value]);
        }
        jQuery.each(trimWords($input.val()), function(i, value) {
            request(value, findValueCallback, findValueCallback);
        });
    }).bind("flushCache", function() {
        cache.flush();
    }).bind("setOptions", function() {
        jQuery.extend(options, arguments[1]);
        // if we've updated the data, repopulate
        if ( "data" in arguments[1] )
            cache.populate();
    });
    
    hideResultsNow();
    
    function selectCurrent() {
        var selected = select.selected();
        if( !selected )
            return false;
        
        var v = selected.result;
        previousValue = v;
        
        if ( options.multiple ) {
            var words = trimWords($input.val());
            if ( words.length > 1 ) {
                v = words.slice(0, words.length - 1).join( options.multipleSeparator ) + options.multipleSeparator + v;
            }
            v += options.multipleSeparator;
        }
        
        $input.val(v);
        hideResultsNow();
        $input.trigger("result", [selected.data, selected.value]);
        return true;
    }
    
    function onChange(crap, skipPrevCheck) {
        if( lastKeyPressCode == KEY.DEL ) {
            select.hide();
            return;
        }
        
        var currentValue = $input.val();
        
        if ( !skipPrevCheck && currentValue == previousValue )
            return;
        
        previousValue = currentValue;
        
        currentValue = lastWord(currentValue);
        if ( currentValue.length >= options.minChars) {
            //moved to where AJAX call is actually made 1/4/08 ECW
            //$input.addClass(options.loadingClass);
            if (!options.matchCase)
                currentValue = currentValue.toLowerCase();
            request(currentValue, receiveData, hideResultsNow);
        } else {
            stopLoading();
            select.hide();
        }
    };
    
    function trimWords(value) {
        if ( !value ) {
            return [""];
        }
        var words = value.split( jQuery.trim( options.multipleSeparator ) );
        var result = [];
        jQuery.each(words, function(i, value) {
            if ( jQuery.trim(value) )
                result[i] = jQuery.trim(value);
        });
        return result;
    }
    
    function lastWord(value) {
        if ( !options.multiple )
            return value;
        var words = trimWords(value);
        return words[words.length - 1];
    }
    
    // fills in the input box w/the first match (assumed to be the best match)
    function autoFill(q, sValue){
        // autofill in the complete box w/the first match as long as the user hasn't entered in more data
        // if the last user key pressed was backspace, don't autofill
        if( options.autoFill && (lastWord($input.val()).toLowerCase() == q.toLowerCase()) && lastKeyPressCode != 8 ) {
            // fill in the value (keep the case the user has typed)
            $input.val($input.val() + sValue.substring(lastWord(previousValue).length));
            // select the portion of the value not typed by the user (so the next character will erase)
            jQuery.Autocompleter.Selection(input, previousValue.length, previousValue.length + sValue.length);
        }
    };

    function hideResults() {
        clearTimeout(timeout);
        timeout = setTimeout(hideResultsNow, 0);
    };

    function hideResultsNow() {
        select.hide();
        clearTimeout(timeout);
        stopLoading();
        if (options.mustMatch) {
            // call search and run callback
            $input.search(
                function (result){
                    // if no value found, clear the input box
                    if( !result ) $input.val("");
                }
            );
        }
    };

    function receiveData(q, data) {
        if ( data && data.length && hasFocus ) {
            stopLoading();
            select.display(data, q);
            autoFill(q, data[0].value);
            select.show();
        } else {
            hideResultsNow();
        }
    };

    function request(term, success, failure) {
        if (!options.matchCase)
            term = term.toLowerCase();
        var data = cache.load(term);
        // recieve the cached data
        if (data && (data.length>-1)) {
            success(term, data);
        // if an AJAX url has been supplied, try loading the data now
        } else if( (typeof options.url == "string") && (options.url.length > 0) ){
            
            var extraParams = {};
            jQuery.each(options.extraParams, function(key, param) {
                extraParams[key] = typeof param == "function" ? param() : param;
            });
            
            $input.addClass(options.loadingClass);
            jQuery.ajax({
                // try to leverage ajaxQueue plugin to abort previous requests
                mode: "abort",
                // limit abortion to this input
                port: "autocomplete" + input.name,
                url: options.url,
                data: jQuery.extend({
                    q: lastWord(term),
                    limit: options.max
                }, extraParams),
                success: function(data) {
                    var parsed = options.parse && options.parse(data) || parse(data);
                    cache.add(term, parsed);
                    success(term, parsed);
                }
            });
        } else {
            failure(term);
        }
    };
    
    function parse(data) {
        var parsed = [];
        var rows = data.split("\n");
        for (var i=0; i < rows.length; i++) {
            var row = jQuery.trim(rows[i]);
            if (row) {
                row = row.split("|");
                parsed[parsed.length] = {
                    data: row,
                    value: row[0],
                    result: options.formatResult && options.formatResult(row, row[0]) || row[0]
                };
            }
        }
        return parsed;
    };

    function stopLoading() {
        $input.removeClass(options.loadingClass);
    };

};

jQuery.Autocompleter.defaults = {
    inputClass: "ac_input",
    resultsClass: "ac_results",
    loadingClass: "ac_loading",
    minChars: 1,
    delay: 400,
    matchCase: false,
    matchSubset: true,
    matchContains: false,
    cacheLength: 10,
    mustMatch: false,
    extraParams: {},
    selectFirst: true,
    max: 10,
    moreItems: "&#x25be;&#x25be;&#x25be; more &#x25be;&#x25be;&#x25be;",
    //size: 10,
    autoFill: false,
    width: 0,
    multiple: false,
    multipleSeparator: ", ",
    highlight: function(value, term) {
        return value.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + term + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>");
    }
};

jQuery.Autocompleter.Cache = function(options) {

    var data = {};
    var length = 0;
    
    function matchSubset(s, sub) {
        if (!options.matchCase) 
            s = s.toLowerCase();
        var i = s.indexOf(sub);
        if (i == -1) return false;
        return i == 0 || options.matchContains;
    };
    
    function add(q, value) {
        if (length > options.cacheLength){
            flush();
        }
        if (!data[q]){ 
            length++;
        }
        data[q] = value;
    }
    
    function populate(){
        if( !options.data ) return false;
        // track the matches
        var stMatchSets = {},
            nullData = 0;

        // no url was specified, we need to adjust the cache length to make sure it fits the local data store
        if( !options.url ) options.cacheLength = 1;
        
        // track all options for minChars = 0
        stMatchSets[""] = [];
        
        // loop through the array and create a lookup structure
        jQuery.each(options.data, function(i, rawValue) {
            // if row is a string, make an array otherwise just reference the array
            
            var value = options.formatItem
                ? options.formatItem(rawValue, i+1, options.data.length)
                : rawValue;
            if ( value === false )
                return;
                
            var firstChar = value.charAt(0).toLowerCase();
            // if no lookup array for this character exists, look it up now
            if( !stMatchSets[firstChar] ) 
                stMatchSets[firstChar] = [];

            // if the match is a string
            var row = {
                value: value,
                data: rawValue,
                result: options.formatResult && options.formatResult(rawValue) || value
            };
            
            // push the current match into the set list
            stMatchSets[firstChar].push(row);

            // keep track of minChars zero items
            if ( nullData++ < options.max ) {
                stMatchSets[""].push(row);
            }
        });

        // add the data items to the cache
        jQuery.each(stMatchSets, function(i, value) {
            // increase the cache size
            options.cacheLength++;
            // add to the cache
            add(i, value);
        });
    }
    
    // populate any existing data
    populate();
    
    function flush(){
        data = {};
        length = 0;
    }
    
    return {
        flush: flush,
        add: add,
        populate: populate,
        load: function(q) {
            if (!options.cacheLength || !length)
                return null;
            /* 
             * if dealing w/local data and matchContains than we must make sure
             * to loop through all the data collections looking for matches
             */
            if( !options.url && options.matchContains ){
                // track all matches
                var csub = [];
                // loop through all the data grids for matches
                for( var k in data ){
                    // don't search through the stMatchSets[""] (minChars: 0) cache
                    // this prevents duplicates
                    if( k.length > 0 ){
                        var c = data[k];
                        jQuery.each(c, function(i, x) {
                            // if we've got a match, add it to the array
                            if (matchSubset(x.value, q)) {
                                csub.push(x);
                            }
                        });
                    }
                }               
                return csub;
            } else 
            // if the exact item exists, use it
            if (data[q]){
                return data[q];
            } else
            if (options.matchSubset) {
                for (var i = q.length - 1; i >= options.minChars; i--) {
                    var c = data[q.substr(0, i)];
                    if (c) {
                        //don't use earlier if it might have had more items
                        if(c.length==options.cacheLength)return null;
                        var csub = [];
                        jQuery.each(c, function(i, x) {
                            if (matchSubset(x.value, q)) {
                                csub[csub.length] = x;
                            }
                        });
                        return csub;
                    }
                }
            }
            return null;
        }
    };
};

jQuery.Autocompleter.Select = function (options, input, select, config) {
    var CLASSES = {
        ACTIVE: "ac_over"
    };
    
    // Create results
    var element = jQuery("<div>")
        .hide()
        .addClass(options.resultsClass)
        .css("position", "absolute")
        .appendTo("body");
    
    var list = jQuery("<ul>").appendTo(element).mouseover( function(event) {
        active = jQuery("li", list).removeClass().index(target(event));
        jQuery(target(event)).addClass(CLASSES.ACTIVE);
    }).mouseout( function(event) {
        jQuery(target(event)).removeClass();
    }).click(function(event) {
        jQuery(target(event)).addClass(CLASSES.ACTIVE);
        select();
        input.focus();
        return false;
    }).mousedown(function() {
        config.mouseDownOnSelect = true;
    }).mouseup(function() {
        config.mouseDownOnSelect = false;
    });
    var listItems,
        active = -1,
        data,
        term = "";
        
    if( options.moreItems.length > 0 ) 
        var moreItems = jQuery("<div>")
            .addClass("ac_moreItems")
            .css("display", "none")
            .html(options.moreItems)
            .appendTo(element);
        
    if( options.width > 0 )
        element.css("width", options.width);
        
    function target(event) {
        var element = event.target;
        while(element && element.tagName != "LI")
            element = element.parentNode;
        // more fun with IE, sometimes event.target is empty, just ignore it then
        if(!element)
            return [];
        return element;
    }

    function moveSelect(step) {
        active += step;
        wrapSelection();
        listItems.removeClass().slice(active, active + 1).addClass(CLASSES.ACTIVE);
    };
    
    function wrapSelection() {
        if (active < 0) {
            active = listItems.size() - 1;
        } else if (active >= listItems.size()) {
            active = 0;
        }
    }
    
    function limitNumberOfItems(available) {
        return (options.max > 0) && (options.max < available)
            ? options.max
            : available;
    }
    
    function fillList() {
        list.empty();
        var num = limitNumberOfItems(data.length);
        for (var i=0; i < num; i++) {
            if (!data[i])
                continue;
            
            var formatted = options.formatItem ? options.formatItem(data[i].data, i+1, num, data[i].value) : data[i].value;
            if ( formatted === false )
                continue;
            
            jQuery("<li>").html( options.highlight(formatted, term) ).appendTo(list)[0].index = i;
        }
        listItems = list.find("li");
        if ( options.selectFirst ) {
            listItems.slice(0, 1).addClass(CLASSES.ACTIVE);
            active = 0;
        }
        if( options.moreItems.length > 0 ) moreItems.css("display", (data.length > num)? "block" : "none");
        list.bgiframe();
    }
    
    return {
        display: function(d, q) {
            data = d;
            term = q;
            fillList();
        },
        next: function() {
            moveSelect(1);
        },
        prev: function() {
            moveSelect(-1);
        },
        hide: function() {
            element.hide();
            active = -1;
        },
        visible : function() {
            return element.is(":visible");
        },
        current: function() {
            return this.visible() && (listItems.filter("." + CLASSES.ACTIVE)[0] || options.selectFirst && listItems[0]);
        },
        show: function() {
            var offset = jQuery(input).offset();
            element.css({
                width: typeof options.width == "string" || options.width > 0 ? options.width : jQuery(input).width(),
                top: offset.top + input.offsetHeight,
                left: offset.left
                //height: jQuery(listItems[0]).height() * options.size,
            }).show();
        }, 
        selected: function() {
            //MCD Bugfix 12-10-2007 ECW
            var selecteditems=listItems.filter("." + CLASSES.ACTIVE);
            if(selecteditems!=null && selecteditems[0]!=null){
                return data && data[ selecteditems[0].index ]
            }
            return data;
        }
    }; 
};

jQuery.Autocompleter.Selection = function(field, start, end) {
    if( field.createTextRange ){
        var selRange = field.createTextRange();
        selRange.collapse(true);
        selRange.moveStart("character", start);
        selRange.moveEnd("character", end);
        selRange.select();
    } else if( field.setSelectionRange ){
        field.setSelectionRange(start, end);
    } else {
        if( field.selectionStart ){
            field.selectionStart = start;
            field.selectionEnd = end;
        }
    }
    field.focus(); 
}; 