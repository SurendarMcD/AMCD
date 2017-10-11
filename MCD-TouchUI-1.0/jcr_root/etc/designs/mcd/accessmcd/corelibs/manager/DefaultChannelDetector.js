/*
 * Copyright 1997-2010 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 *
 * 
 * The default channel detector uses the client user manager to drill down
 * the channels.
 */
CQClientLibraryManager.setChannelCB(function(){
    var channels = [
        {
            channel: "ie6",
            match: "MSIE 6."
        }, 
        {
            channel: "ie7",
            match: "MSIE 7."
        }, 
        {
            channel: "ie8",
            match: "MSIE 8."
        }, 
        {
            channel: "ie9",
            match: "MSIE 9."
        }, {
            channel: "firefox",
            match: "Firefox/"
        }, {
            channel: "chrome",
            match: "Chrome/"
        }, {
            channel: "safari",
            match: "Safari"
        }, {
            channel: "touch",
            match: "iPhone"
        }, {
            channel: "touch",
            match: "iPad"
        }
    ];
    var ua = navigator.userAgent;
    //console.log(ua);
    for (var i=0; i<channels.length; i++) {
        var c = channels[i];
        if (ua.indexOf(c.match) >=0) {
            return c.channel;
        }
    }
    return "";
});