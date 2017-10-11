/*global o, exports, location */
/*jslint white: true, onevar: true, undef: true, newcap: true, nomen: true, regexp: true, plusplus: true, bitwise: true, strict: true, maxerr: 50, indent: 4 */
/*
 @source: http://prettydiff.com/documentation.php
 
 @licstart  The following is the entire license notice for the 
 JavaScript code in this page.
 
 
 Created by Austin Cheney originally on 3 Mar 2009.
 This code may not be used or redistributed unless the following
 conditions are met:
 
 There is no licensing associated with diffview.css.  Please use,
 redistribute, and alter to your content.  However, diffview.css
 provided from Pretty Diff is different from and not aligned with the
 following diffview.js originally from Snowtide Informatics.
 
 * The use of diffview.js and prettydiff.js must contain the following
 copyright:
 Copyright (c) 2007, Snowtide Informatics Systems, Inc.
 All rights reserved.
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the
 distribution.
 * Neither the name of the Snowtide Informatics Systems nor the names
 of its contributors may be used to endorse or promote products
 derived from this software without specific prior written
 permission.
 
 - used as diffview function
 <http://prettydiff.com/diffview.js>
 
 * The author of fulljsmin.js and date of creation must be stated as:
 Franck Marcia - 31 Aug 2006
 
 - used as jsmin function:
 <http://prettydiff.com/fulljsmin.js>
 
 * The fulljsmin.js is used with permission from the author of jsminc.c
 and such must be stated as:
 Copyright (c) 2002 Douglas Crockford  (www.crockford.com)
 
 * The author of js-beautify.js must be stated as:
 Written by Einars Lielmanis, <einars@gmail.com>
 http://elfz.laacz.lv/beautify/
 
 Originally converted to javascript by Vital, <vital76@gmail.com>
 http://my.opera.com/Vital/blog/2007/11/21/
 javascript-beautify-on-javascript-translated
 
 - used as js_beautify function
 <http://prettydiff.com/js-beautify.js>
 
 * cleanCSS.js is originally written by Anthony Lieuallen
 http://tools.arantius.com/tabifier
 
 - used as cleanCSS function
 <http://prettydiff.com/cleanCSS.js>
 
 * charcomp.js is written by Austin Cheney.  Use of this function
 requires that credit be given to Austin Cheney.
 http://prettydiff.com/
 
 - used as charcomp function
 <http://prettydiff.com/charcomp.js>
 
 * charDecoder.js is written by Austin Cheney.  Use of this function
 requires that credit be given to Austin Cheney.
 http://prettydiff.com/
 
 - used as charDecoder function
 <http://prettydiff.com/charDecoder.js>
 
 * csvbeauty.js is written by Austin Cheney.  Use of this function
 requires that credit be given to Austin Cheney.
 http://mailmarkup.org/
 
 - used as csvbeauty function
 <http://prettydiff.com/csvbeauty.js>
 
 * csvmin.js is written by Austin Cheney.  Use of this function requires
 that credit be given to Austin Cheney.
 http://prettydiff.com/
 
 - used as csvmin function
 <http://prettydiff.com/csvmin.js>
 
 * markupmin.js is written by Austin Cheney.  Use of this function
 requires that credit be given to Austin Cheney.
 http://prettydiff.com/
 
 - used as markupmin function
 <http://prettydiff.com/markupmin.js>
 
 * markup_beauty.js is written by Austin Cheney.  Use of this function
 requires that credit be given to Austin Cheney.
 http://prettydiff.com/
 
 - used as markup-beauty function
 <http://prettydiff.com/markup_beauty.js>
 
 * $ function is written by Dustin Diaz.
 http://www.dustindiaz.com/
 
 * o object literal is in the pd.js file and exists to provide a one
 time and external means of access to the DOM.
 
 -----------------------------------------------------------------------
 * The code mentioned above has significantly expanded documentation in
 each of the respective function's external JS file as linked from the
 documentation page:
 <http://prettydiff.com/documentation.php>
 
 * The compilation of cssClean, csvbeauty, csvmin, jsmin, jsdifflib,
 markup_beauty, markupmin, and js-beautify in this manner is a result of
 the prettydiff() function contained in prettydiff.js.  The per
 character highlighting is the result of the charcomp() function also
 contained in prettydiff.js. Any use or redistribution of these
 functions must mention the following:
 Prettydiff created by Austin Cheney originally on 3 Mar 2009.
 <http://mailmarkup.org/>
 
 Contact the author at:
 austin.cheney@us.army.mil
 
 * In addition to the previously stated requirements any use of any
 component, aside from directly using the full files in their entirety,
 must restate the license mentioned at the top of each concerned file.
 
 
 If each and all these conditions are met use and redistribution of
 prettydiff and its required assets is unlimited without author
 permission.
 
 
 @licend  The above is the entire license notice for the JavaScript code
 in this page.
 
 */
var prettydiff = function (apisource, apidiff, apimode, apilang, apicsvchar, apiinsize, apiinchar, apicomments, apiindent, apistyle, apihtml, apicontext, apicontent, apiquote, apisemicolon, apidiffview, apisourcelabel, apidifflabel, localflag) {
    "use strict";
    String.prototype.has = function (c) {
        return this.indexOf(c) > -1;
    };
    var startTime = (function () {
            var d = new Date(),
                t = d.getTime();
            return t;
        }()),
        css_summary,
        js_summary,
        markup_summary,
        errorout = 0,
        charDecoder = function (input) {
            if (!o.dv && !o.dv.innerHTML) {
                return input;
            }
            var b,
                d,
                a = 0,
                c = input,
                x = [],
                y = [],
                uni = (/u\+[0-9a-f]{4,5}\+/),
                unit = (/u\![0-9a-f]{4,5}\+/),
                htmln = (/\&\#[0-9]{1,6}\;/),
                htmlt = (/\&\![0-9]{1,6}\;/);
            if (c.search(unit) === -1 && c.search(uni) === -1 && c.search(htmlt) === -1 && c.search(htmln) === -1) {
                return input;
            }
            for (b = a; b < input.length; b += 1) {
                if (c.search(htmln) === -1 || (c.search(uni) < c.search(htmln) && c.search(uni) !== -1)) {
                    d = c.search(uni);
                    y.push(d + "|h");
                    for (a = d; a < c.length; a += 1) {
                        if (c[a] === "+" && c[a - 1] === "u") {
                            c = c.split("");
                            c.splice(a, 1, "!");
                            c = c.join("");
                        }
                        if (c[a] === "+" && c[a - 1] !== "u") {
                            a += 1;
                            break;
                        }
                    }
                    x.push(c.slice(d + 2, a - 1));
                    c = c.replace(unit, '');
                } else if (c.search(uni) === -1 || (c.search(htmln) < c.search(uni) && c.search(htmln) !== -1)) {
                    d = c.search(htmln);
                    y.push(d + "|d");
                    for (a = d; a < c.length; a += 1) {
                        if (c[a] === "#") {
                            c = c.split("");
                            c.splice(a, 1, "!");
                            c = c.join("");
                        }
                        if (c[a] === ";") {
                            a += 1;
                            break;
                        }
                    }
                    x.push(c.slice(d + 2, a - 1));
                    c = c.replace(htmlt, '');
                }
                if (c.search(uni) === -1 && c.search(htmln) === -1) {
                    break;
                }
            }
            c = c.replace(/u\![0-9a-f]{4,5}\+/g, "").replace(/\&\![0-9]{1,6}\;/g, "").split("");
            for (b = 0; b < x.length; b += 1) {
                y[b] = y[b].split("|");
                if (y[b][1] === "h") {
                    x[b] = parseInt(x[b], 16);
                }
                o.dv.innerHTML = "&#" + parseInt(x[b], 10) + ";";
                x[b] = o.dv.innerHTML;
                c.splice(y[b][0], 0, x[b]);
            }
            return c.join("");
        },
        csvbeauty = function (source, ch) {
            if (ch.length > source.length) {
                return source;
            }
            if (ch === "") {
                ch = ",";
            } else {
                ch = charDecoder(ch);
            }
            var err,
                a = 0,
                c = [],
                error = "Error: Unterminated String begging at character number ",
                str = (function () {
                    var b,
                        src;
                    source = source.replace(/"{2}/g, "{csvquote}");
                    src = source;
                    source = source.split("");
                    for (; a < source.length; a += 1) {
                        if (source[a] === "\"") {
                            for (b = a + 1; b < source.length; b += 1) {
                                if (source[b] === "\"") {
                                    c.push(src.slice(a, b + 1));
                                    source[a] = "{csvstring}";
                                    source[b] = "";
                                    a = b + 1;
                                    break;
                                }
                                source[b] = "";
                            }
                            if (b === source.length) {
                                err = source.join("").slice(a, a + 9);
                                source = error;
                                return;
                            }
                        }
                    }
                    source = source.join("").replace(/\{csvquote\}/g, "\"\"");
                }());
            if (source === error) {
                if (a !== source.length - 1) {
                    return source + a + ", '" + err + "'.";
                } else {
                    return source + a + ".";
                }
            }
            source = source.replace(/\n/g, "\n\n{-}\n\n");
            if (source.charAt(source.length - ch.length) === ch) {
                source = source.slice(0, source.length + 1 - ch.length) + "{|}";
            }
            do {
                source = source.replace(ch, "\n");
            } while (source.indexOf(ch) !== -1);
            for (a = 0; a < c.length; a += 1) {
                c[a] = c[a].replace(/\n/g, "{ }");
                source = source.replace("{csvstring}", c[a]);
            }
            source = source.replace(/\{csvquote\}/g, "\"");
            return source;
        },
        csvmin = function (source, ch) {
            var a,
                b,
                c,
                err,
                d = "",
                error = "Error: Unterminated String begging at character number ",
                src = function () {
                    for (a = 0; a < source.length; a += 1) {
                        c = [];
                        if (source[a].indexOf("\"") !== -1) {
                            source[a] = source[a].split("");
                            for (b = 0; b < source[a].length; b += 1) {
                                if (source[a][b] === "\"") {
                                    c.push(b);
                                }
                            }
                            if (c.length === 1) {
                                d = error;
                                source[a] = source[a].join("");
                                err = source[a].slice(c[0], c[0] + 9);
                                return;
                            } else if (c.length > 2) {
                                for (d = 1; d < c.length - 1; d += 1) {
                                    source[a][c[d]] = "\"\"";
                                }
                            }
                            source[a] = source[a].join("");
                        }
                    }
                },
                multiline = function (x) {
                    var w = [],
                        y,
                        z = x.length - 2;
                    if (x.length === 2) {
                        return "{ }";
                    } else {
                        for (y = 0; y < z; y += 1) {
                            w.push(ch);
                        }
                        return w.join('') + "{ }";
                    }
                };
            if (ch === "") {
                ch = ",";
            } else {
                ch = charDecoder(ch);
            }
            source = source.replace(/\n\n\{\-\}\n\n/g, "{-}").replace(/\n{2,}/g, multiline).split("\n");
            src();
            if (d === error) {
                return error + (source.join(ch).indexOf(source[a]) + c[0]) + " or value number " + (a + 1) + ", '" + err + "'.";
            }
            if (source[source.length - 1] === "{|}") {
                source[source.length - 1] = "";
            }
            source = source.join(ch).replace(/\n/g, ch);
            do {
                source = source.replace("{ }", "\n");
            } while (source.indexOf("{ }") !== -1);
            source = source.replace(/\n{2}/g, "\n");
            if (source.indexOf("{|}") === source.length - 3) {
                source = source.slice(0, source.length - 3) + ch;
            }
            return source.replace(/\{\-\}/g, "\n");
        },
        jsmin = function (comment, input, level, type, alter) {
            if (input === undefined) {
                input = comment;
                comment = '';
                level = 2;
            } else {
                if (level === undefined || level < 1 || level > 3) {
                    level = 2;
                }
                if (type === "javascript") {
                    input = input.replace(/\/\/(\s)*-->/g, "//-->");
                } else if (type !== "css") {
                    return "Error: The type argument is not provided a value of either 'css' or 'javascript'.";
                }
            }
            if (comment.length > 0) {
                comment += '\n';
            }
            var ret,
                atchar = input.match(/\@charset\s+("|')[\w\-]+("|');?/gi),
                error = "",
                a = '',
                b = '',
                geti,
                getl,
                EOF = -1,
                LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
                DIGITS = '0123456789',
                OTHERS,
                ALNUM,
                theLookahead = EOF,
                reduction = function (x) {
                    var a,
                        e,
                        f,
                        g,
                        m,
                        p,
                        b = x.length,
                        c = "",
                        d = [],
                        colorLow = function (x) {
                            x = x.toLowerCase();
                            if (x.length === 7 && x.charAt(1) === x.charAt(2) && x.charAt(3) === x.charAt(4) && x.charAt(5) === x.charAt(6)) {
                                x = "#" + x.charAt(1) + x.charAt(3) + x.charAt(5);
                            }
                            return x;
                        };
                    for (a = 0; a < b; a += 1) {
                        c += x[a];
                        if (x[a] === "{" || x[a + 1] === "}") {
                            d.push(c);
                            c = "";
                        }
                    }
                    if (x[a - 1] === "}") {
                        d.push("}");
                    }
                    b = d.length;
                    for (a = 0; a < b - 1; a += 1) {
                        if (d[a].charAt(d[a].length - 1) !== "{") {
                            if (d[a].charAt(d[a].length - 1) === ";") {
                                d[a] = d[a].substr(0, d[a].length - 1);
                            }
                            c = d[a].replace(/\:/g, "$").replace(/#[a-zA-Z0-9]{3,6}(?!(\w*\)))/g, colorLow).split(";").sort();
                            f = c.length;
                            for (e = 0; e < f; e += 1) {
                                c[e] = c[e].split("$");
                            }
                            g = -1;
                            m = 0;
                            p = 0;
                            for (e = 0; e < f; e += 1) {
                                if (c[e - 1] && c[e - 1][0] === c[e][0]) {
                                    c[e - 1] = "";
                                }
                                if (c[e][0] !== "margin" && c[e][0].indexOf("margin") !== -1) {
                                    m += 1;
                                    if (m === 4) {
                                        c[e][0] = "margin";
                                        c[e][1] = c[e][1] + " " + c[e - 1][1] + " " + c[e - 3][1] + " " + c[e - 2][1];
                                        c[e - 3] = "";
                                        c[e - 2] = "";
                                        c[e - 1] = "";
                                        if (c[e - 4] && c[e - 4][0] === "margin") {
                                            c[e - 4] = "";
                                        }
                                    }
                                } else if (c[e][0] !== "padding" && c[e][0].indexOf("padding") !== -1) {
                                    p += 1;
                                    if (p === 4) {
                                        c[e][0] = "padding";
                                        c[e][1] = c[e][1] + " " + c[e - 1][1] + " " + c[e - 3][1] + " " + c[e - 2][1];
                                        c[e - 3] = "";
                                        c[e - 2] = "";
                                        c[e - 1] = "";
                                        if (c[e - 4] && c[e - 4][0] === "padding") {
                                            c[e - 4] = "";
                                        }
                                    }
                                }
                                if (g === -1 && c[e + 1] && c[e][0].charAt(0) !== "-" && (c[e][0].indexOf("cue") !== -1 || c[e][0].indexOf("list-style") !== -1 || c[e][0].indexOf("outline") !== -1 || c[e][0].indexOf("overflow") !== -1 || c[e][0].indexOf("pause") !== -1) && (c[e][0] === c[e + 1][0].substring(0, c[e + 1][0].lastIndexOf("-")) || c[e][0].substring(0, c[e][0].lastIndexOf("-")) === c[e + 1][0].substring(0, c[e + 1][0].lastIndexOf("-")))) {
                                    g = e;
                                    if (c[g][0].indexOf("-") !== -1) {
                                        c[g][0] = c[g][0].substring(0, c[g][0].lastIndexOf("-"));
                                    }
                                } else if (g !== -1 && c[g][0] === c[e][0].substring(0, c[e][0].lastIndexOf("-"))) {
                                    if (c[g][0] === "cue" || c[g][0] === "pause") {
                                        c[g][1] = c[e][1] + " " + c[g][1];
                                    } else {
                                        c[g][1] = c[g][1] + " " + c[e][1];
                                    }
                                    c[e] = "";
                                } else if (g !== -1) {
                                    g = -1;
                                }
                            }
                            for (e = 0; e < f; e += 1) {
                                if (c[e] !== "") {
                                    c[e] = c[e].join(":");
                                }
                            }
                            d[a] = c.join(";").replace(/;+/g, ";").replace(/^;/, "");
                        }
                    }
                    return d.join("");
                },
                isAlphanum = function (c) {
                    return c !== EOF && (ALNUM.has(c) || c.charCodeAt(0) > 126);
                },
                fixURI = function (x) {
                    var a;
                    x = x.split("url(");
                    for (a = 1; a < x.length; a += 1) {
                        if (x[a].charAt(0) !== "\"" && x[a].charAt(0) !== "'") {
                            x[a] = x[a].split(")");
                            if (x[a][0].charAt(x[a][0].length - 1) !== "\"" && x[a][0].charAt(x[a][0].length - 1) !== "'") {
                                x[a][0] = x[a][0] + "\"";
                            } else if (x[a][0].charAt(x[a][0].length - 1) === "'" || x[a][0].charAt(x[a][0].length - 1) === "\"") {
                                x[a][0] = x[a][0].substr(0, x[a][0].length - 1) + "\"";
                            }
                            x[a] = "url(\"" + x[a].join(')');
                        } else if (x[a].charAt(0) === "\"") {
                            x[a] = x[a].split(")");
                            if (x[a][0].charAt(x[a][0].length - 1) !== "\"" && x[a][0].charAt(x[a][0].length - 1) !== "'") {
                                x[a][0] = x[a][0] + "\"";
                            } else if (x[a][0].charAt(x[a][0].length - 1) === "'" || x[a][0].charAt(x[a][0].length - 1) === "\"") {
                                x[a][0] = x[a][0].substr(0, x[a][0].length - 1) + "\"";
                            }
                            x[a] = "url(" + x[a].join(')');
                        } else {
                            x[a] = x[a].substr(1, x[a].length - 1).split(")");
                            if (x[a][0].charAt(x[a][0].length - 1) !== "\"" && x[a][0].charAt(x[a][0].length - 1) !== "'") {
                                x[a][0] = x[a][0] + "\"";
                            } else if (x[a][0].charAt(x[a][0].length - 1) === "'" || x[a][0].charAt(x[a][0].length - 1) === "\"") {
                                x[a][0] = x[a][0].substr(0, x[a][0].length - 1) + "\"";
                            }
                            x[a] = "url(\"" + x[a].join(')');
                        }
                    }
                    return x.join('');
                },
                rgbToHex = function (x) {
                    var a,
                        y = function (z) {
                            z = Number(z).toString(16);
                            if (z.length === 1) {
                                z = "0" + z;
                            }
                            return z;
                        };
                    a = "#" + x.replace(/\d+/g, y).replace(/rgb\(/, "").replace(/,/g, "").replace(/\)/, "").replace(/\s*/g, "");
                    return a;
                },
                schemeesc = function (x) {
                    return x.replace(/:\/\//, ":xx");
                },
                schemefix = function (x) {
                    return x.replace(/:xx/, "://");
                },
                sameDist = function (x) {
                    if (x === "0") {
                        return x;
                    }
                    var a = "";
                    if (x.charAt(0) === " ") {
                        a = " ";
                        x = x.substr(1, x.length);
                    }
                    x = x.split(" ");
                    if (x.length === 4) {
                        if (x[0] === x[1] && x[1] === x[2] && x[2] === x[3]) {
                            x[1] = "";
                            x[2] = "";
                            x[3] = "";
                        } else if (x[0] === x[2] && x[1] === x[3] && x[0] !== x[1]) {
                            x[2] = "";
                            x[3] = "";
                        } else if (x[0] !== x[2] && x[1] === x[3]) {
                            x[3] = "";
                        }
                    } else if (x.length === 3 && x[0] === x[2] && x[0] !== x[1]) {
                        x[2] = "";
                    } else if (x.length === 2 && a !== " " && x[0] === x[1]) {
                        x[1] = "";
                    }
                    return a + x.join(" ").replace(/\s+/g, " ").replace(/\s+$/, "");
                },
                singleZero = function (x) {
                    var a = x.substr(0, x.indexOf(":") + 1);
                    if (a === "radius:") {
                        return x;
                    }
                    if (x.charAt(x.length - 1) !== "0" || (x.charAt(x.length - 1) === "0" && x.charAt(x.length - 2) !== " ")) {
                        return x;
                    }
                    return a + "0";
                },
                endZero = function (x) {
                    var a = x.indexOf(".");
                    return x.substr(0, a);
                },
                startZero = function (x) {
                    var a = x.indexOf(".");
                    return x.charAt(0) + x.substr(a, x.length);
                },
                fixpercent = function (x) {
                    return x.replace(/%/, "% ");
                },
                get = function () {
                    var c = theLookahead;
                    if (geti === getl) {
                        return EOF;
                    }
                    theLookahead = EOF;
                    if (c === EOF) {
                        c = input.charAt(geti);
                        geti += 1;
                    }
                    if (c >= ' ' || c === '\n') {
                        return c;
                    }
                    if (c === '\r') {
                        return '\n';
                    }
                    return ' ';
                },
                peek = function () {
                    theLookahead = get();
                    return theLookahead;
                },
                next = function () {
                    var c = get();
                    if (c === '/') {
                        switch (peek()) {
                        case '/':
                            for (;;) {
                                c = get();
                                if (c <= '\n') {
                                    return c;
                                }
                            }
                            break;
                        case '*':
                            get();
                            for (;;) {
                                switch (get()) {
                                case "'":
                                    c = get().replace(/'/, '');
                                    break;
                                case '"':
                                    c = get().replace(/"/, '');
                                    break;
                                case '*':
                                    if (peek() === '/') {
                                        get();
                                        return ' ';
                                    }
                                    break;
                                case EOF:
                                    error = 'Error: Unterminated JavaScript comment.';
                                    return error;
                                }
                            }
                            break;
                        default:
                            return c;
                        }
                    }
                    return c;
                },
                action = function (d) {
                    var r = [];
                    if (d === 1) {
                        r.push(a);
                    }
                    if (d < 3) {
                        a = b;
                        if (a === '\'' || a === '"') {
                            for (;;) {
                                r.push(a);
                                a = get();
                                if (a === b) {
                                    break;
                                }
                                if (a <= '\n') {
                                    if (type === "css") {
                                        error = 'Error: This does not appear to be CSS. Try submitting as plain text or markup.';
                                    } else {
                                        error = 'Error: This does not appear to be JavaScript. Try submitting as plain text or markup.';
                                    }
                                    return error;
                                }
                                if (a === '\\') {
                                    r.push(a);
                                    a = get();
                                }
                            }
                        }
                    }
                    b = next();
                    if (b === '/' && '(,=:[!&|'.has(a)) {
                        r.push(a);
                        r.push(b);
                        for (;;) {
                            a = get();
                            if (a === '/') {
                                break;
                            } else if (a === '\\') {
                                r.push(a);
                                a = get();
                            } else if (a <= '\n') {
                                error = 'Error: unterminated JavaScript Regular Expression literal';
                                return error;
                            }
                            r.push(a);
                        }
                        b = next();
                    }
                    return r.join('');
                },
                m = function () {
                    if (error !== "") {
                        return error;
                    }
                    var r = [];
                    a = '\n';
                    r.push(action(3));
                    while (a !== EOF) {
                        if (a === ' ' && !(type === 'css' && b === '#')) {
                            if (isAlphanum(b)) {
                                r.push(action(1));
                            } else {
                                r.push(action(2));
                            }
                        } else if (a === '\n') {
                            switch (b) {
                            case '{':
                            case '[':
                            case '(':
                            case '+':
                            case '-':
                                r.push(action(1));
                                break;
                            case ' ':
                                r.push(action(3));
                                break;
                            default:
                                if (isAlphanum(b)) {
                                    r.push(action(1));
                                } else {
                                    if (level === 1 && b !== '\n') {
                                        r.push(action(1));
                                    } else {
                                        r.push(action(2));
                                    }
                                }
                            }
                        } else {
                            switch (b) {
                            case ' ':
                                if (isAlphanum(a)) {
                                    r.push(action(1));
                                    break;
                                }
                                r.push(action(3));
                                break;
                            case '\n':
                                if (level === 1 && a !== '\n') {
                                    r.push(action(1));
                                } else if (a === '}') {
                                    if (level === 3) {
                                        r.push(action(3));
                                    } else {
                                        r.push(action(1));
                                    }
                                } else {
                                    r.push(action(3));
                                }
                                break;
                            default:
                                r.push(action(1));
                                break;
                            }
                        }
                    }
                    return r.join('');
                };
            if (type === "css") {
                OTHERS = '-._\\';
            } else {
                OTHERS = '_$//';
            }
            ALNUM = LETTERS + DIGITS + OTHERS;
            geti = 0;
            getl = input.length;
            if (type === "css") {
                input = input.replace(/[\w]+:\/\//g, schemeesc);
            }
            ret = m(input);
            if (type === "css") {
                ret = ret.replace(/[\w]+:xx/g, schemefix).replace(/\: #/g, ":#").replace(/\; #/g, ";#").replace(/\, #/g, ",#").replace(/\s+/g, " ").replace(/\} /g, '}').replace(/\{ /g, '{').replace(/http:xx/g, "http://").replace(/\\\)/g, "~PDpar~").replace(/\)/g, ") ").replace(/\) ;/g, ");").replace(/\%(?=\w)/, "% ").replace(/\d%\d/g, fixpercent);
                if (alter === true) {
                    ret = reduction(ret).replace(/@charset("|')?[\w\-]+("|')?;?/gi, "").replace(/(#|\.)?[\w]*\{\}/gi, "").replace(/:[\w\s\!\.\-%]*\d+\.0*(?!\d)/g, endZero).replace(/(:| )0+\.\d+/g, startZero).replace(/\s?((\.\d+|\d+\.\d+|\d+)[a-zA-Z]+|0 )+((\.\d+|\d+\.\d+|\d+)[a-zA-Z]+)|0/g, sameDist).replace(/:\.?0(\%|px|in|cm|mm|em|ex|pt|pc)/g, ":0").replace(/ \.?0(\%|px|in|cm|mm|em|ex|pt|pc)/g, " 0").replace(/bottom:none/g, "bottom:0").replace(/top:none/g, "top:0").replace(/left:none/g, "left:0").replace(/right:none/, "right:0").replace(/:0 0 0 0/g, ":0").replace(/[a-z]*:(0\s*)+\-?\.?\d?/g, singleZero).replace(/ 0 0 0 0/g, " 0").replace(/rgb\(\d+,\d+,\d+\)/g, rgbToHex).replace(/background\-position:0;/gi, "background-position:0 0;").replace(/;+/g, ";").replace(/\s*[\w\-]+:\s*\}/g, "}").replace(/\s*[\w\-]+:\s*;/g, "").replace(/;\}/g, "}").replace(/\{\s+\}/g, "{}");
                    if (atchar === null) {
                        atchar = [""];
                    } else if (atchar[0].charAt(atchar[0].length - 1) !== ";") {
                        atchar[0] = atchar[0] + ";";
                    }
                    ret = atchar[0].replace(/@charset/i, "@charset") + fixURI(ret);
                }
                ret = ret.replace(/~PDpar~/g, "\\)");
            } else {
                ret = ret.replace(/x{2}-->/g, "//-->");
            }
            if (ret.charAt(0) === " " || ret.charAt(0) === "\n" || ret.charAt(0) === "\t") {
                ret = ret.slice(1, ret.length);
            }
            if (error !== "") {
                return error;
            } else {
                return comment + ret;
            }
        },
        cleanCSS = function (x, size, character, comment, alter) {
            var q = x.length,
                a,
                b,
                atchar = x.match(/\@charset\s+("|')[\w\-]+("|');?/gi),
                tab = '',
                fixURI = function (y) {
                    var a;
                    y = y.replace(/\\\)/g, "~PDpar~").split("url(");
                    for (a = 1; a < y.length; a += 1) {
                        if (y[a].charAt(0) !== "\"" && y[a].charAt(0) !== "'") {
                            y[a] = ("url(\"" + y[a]).split(")");
                            if (y[a][0].charAt(y[a][0].length - 1) !== "\"" && y[a][0].charAt(y[a][0].length - 1) !== "'") {
                                y[a][0] = y[a][0] + "\"";
                            } else if (y[a][0].charAt(y[a][0].length - 1) === "'" || y[a][0].charAt(y[a][0].length - 1) === "\"") {
                                y[a][0] = y[a][0].substr(0, y[a][0].length - 1) + "\"";
                            }
                            y[a] = y[a].join(')');
                        } else if (y[a].charAt(0) === "\"") {
                            y[a] = ("url(" + y[a]).split(")");
                            if (y[a][0].charAt(y[a][0].length - 1) !== "\"" && y[a][0].charAt(y[a][0].length - 1) !== "'") {
                                y[a][0] = y[a][0] + "\"";
                            } else if (y[a][0].charAt(y[a][0].length - 1) === "'" || y[a][0].charAt(y[a][0].length - 1) === "\"") {
                                y[a][0] = y[a][0].substr(0, y[a][0].length - 1) + "\"";
                            }
                            y[a] = y[a].join(')');
                        } else {
                            y[a] = ("url(\"" + y[a].substr(1, y[a].length - 1)).split(")");
                            if (y[a][0].charAt(y[a][0].length - 1) !== "\"" && y[a][0].charAt(y[a][0].length - 1) !== "'") {
                                y[a][0] = y[a][0] + "\"";
                            } else if (y[a][0].charAt(y[a][0].length - 1) === "'" || y[a][0].charAt(y[a][0].length - 1) === "\"") {
                                y[a][0] = y[a][0].substr(0, y[a][0].length - 1) + "\"";
                            }
                            y[a] = y[a].join(')');
                        }
                    }
                    return y.join('').replace(/~PDpar~/g, "\\)");
                },
                tabmaker = (function () {
                    var i;
                    for (i = 0; i < Number(size); i += 1) {
                        tab += character;
                    }
                }()),
                sameDist = function (y) {
                    if (y === "0") {
                        return y;
                    }
                    y = y.substr(2, y.length);
                    y = y.split(" ");
                    if (y.length === 4) {
                        if (y[0] === y[1] && y[1] === y[2] && y[2] === y[3]) {
                            y[1] = "";
                            y[2] = "";
                            y[3] = "";
                        } else if (y[0] === y[2] && y[1] === y[3] && y[0] !== y[1]) {
                            y[2] = "";
                            y[3] = "";
                        } else if (y[0] !== y[2] && y[1] === y[3]) {
                            y[3] = "";
                        }
                    } else if (y.length === 3 && y[0] === y[2] && y[0] !== y[1]) {
                        y[2] = "";
                    } else if (y.length === 2 && y[0] === y[1]) {
                        y[1] = "";
                    }
                    return ": " + y.join(" ").replace(/\s+/g, " ").replace(/\s+$/, "");
                },
                endZero = function (y) {
                    var a = y.indexOf(".");
                    return y.substr(0, a);
                },
                startZero = function (y) {
                    return y.replace(/ \./g, " 0.");
                },
                emptyend = function (y) {
                    var b = y.match(/^(\s*)/)[0],
                        c = b.substr(0, b.length - tab.length);
                    return c + "}";
                },
                fixscheme = function (y) {
                    return y.replace(/:\s+/, ":");
                },
                fixpercent = function (y) {
                    return y.replace(/%/, "% ");
                },
                nestblock = function (y) {
                    return y.replace(/\s*;\n/, "\n");
                },
                cleanAsync = function () {
                    var i,
                        b = x.length,
                        tabs = [],
                        tabb = '',
                        out = [tab];
                    for (i = 0; i < b; i += 1) {
                        if ('{' === x.charAt(i)) {
                            tabs.push(tab);
                            tabb = tabs.join("");
                            out.push(' {\n' + tabb);
                        } else if ('\n' === x.charAt(i)) {
                            out.push('\n' + tabb);
                        } else if ('}' === x.charAt(i)) {
                            out[out.length - 1] = out[out.length - 1].replace(/\s*$/, "");
                            tabs = tabs.slice(0, tabs.length - 1);
                            tabb = tabs.join("");
                            if (x.charAt(i + 1) + x.charAt(i + 2) !== "*/") {
                                out.push("\n" + tabb + "}\n" + tabb);
                            } else {
                                out.push("\n" + tabb + "}");
                            }
                        } else if (';' === x.charAt(i) && "}" !== x.charAt(i + 1)) {
                            out.push(';\n' + tabb);
                        } else {
                            out.push(x.charAt(i));
                        }
                    }
                    if (i >= b) {
                        out = [out.join("").replace(/^(\s*)/, '').replace(/(\s*)$/, '')];
                        x = out.join("");
                        tabs = [];
                    }
                },
                reduction = function () {
                    var a,
                        e,
                        f,
                        g,
                        m,
                        p,
                        b = x.length,
                        c = "",
                        d = [],
                        colorLow = function (y) {
                            y = y.toLowerCase();
                            if (y.length === 7 && y.charAt(1) === y.charAt(2) && y.charAt(3) === y.charAt(4) && y.charAt(5) === y.charAt(6)) {
                                y = "#" + y.charAt(1) + y.charAt(3) + y.charAt(5);
                            }
                            return y;
                        },
                        ccex = (/[\w\s:#\-\=\!\(\)"'\[\]\.%-\_\?\/\\]\/\*/),
                        crex = (/\/\*[\w\s:#\-\=\!\(\)"'\[\]\.%-\_\?\/\\]*;[\w\s:#\-\=\!\(\)"'\[\]\.%\_\?\/\\;]*\*\//),
                        cceg = function (a) {
                            return a.replace(/\s*\/\*/, ";/*");
                        },
                        creg = function (a) {
                            if (!crex.test(a)) {
                                return a;
                            }
                            var b = a.length,
                                c;
                            a = a.split("");
                            for (c = 0; c < b; c += 1) {
                                if (a[c] === ";") {
                                    a[c] = "PrettyDiff|";
                                }
                                if (a[c] === "*" && a[c + 1] && a[c + 1] === "/") {
                                    return a.join("");
                                }
                            }
                            return a.join("");
                        };
                    for (a = 0; a < b; a += 1) {
                        c += x.charAt(a);
                        if (x.charAt(a) === "{" || x.charAt(a + 1) === "}") {
                            d.push(c);
                            c = "";
                        }
                    }
                    for (b = a - 1; b > 0; b -= 1) {
                        if (x.charAt(b) === "/" && x.charAt(b - 1) && x.charAt(b - 1) === "*") {
                            for (c = b - 1; c > 0; c -= 1) {
                                if (x.charAt(c) === "/" && x.charAt(c + 1) === "*") {
                                    b = c;
                                    break;
                                }
                            }
                        } else if (!/[\}\s]/.test(x.charAt(b))) {
                            break;
                        }
                    }
                    a = d.length - 1;
                    for (; a > 0; a -= 1) {
                        if (d[a] === "}") {
                            b += 1;
                        } else {
                            break;
                        }
                    }
                    if (b === x.length || x.substring(b + 1, x.length - 1) === d[d.length - 1]) {
                        d.push("}");
                    } else {
                        d.push(x.substring(b + 1, x.length));
                    }
                    b = d.length;
                    for (a = 0; a < b; a += 1) {
                        if (d[a].charAt(d[a].length - 1) === "{") {
                            d[a] = d[a].replace(/,\s*/g, ",\n");
                        }
                    }
                    for (a = 0; a < b - 1; a += 1) {
                        if (d[a].charAt(d[a].length - 1) !== "{") {
                            if (d[a].charAt(d[a].length - 1) === ";") {
                                d[a] = d[a].substr(0, d[a].length - 1);
                            }
                            c = d[a].replace(ccex, cceg);
                            do {
                                c = c.replace(crex, creg);
                            } while (crex.test(c));
                            c = c.replace(/\*\//g, "*/;").replace(/\:(?!(\/\/))/g, "$").replace(/#[a-fA-F0-9]{3,6}(?!(\w*\)))/g, colorLow).split(";");
                            f = c.length;
                            m = [];
                            p = [];
                            for (e = 0; e < f; e += 1) {
                                if (/^(\/\*)/.test(c[e])) {
                                    m.push(c[e].replace(/\/\*\s*/, "/* "));
                                } else if (c[e] !== "") {
                                    p.push(c[e].replace(/^\s*/, ""));
                                }
                            }
                            c = m.sort().concat(p.sort());
                            f = c.length;
                            for (e = 0; e < f; e += 1) {
                                c[e] = c[e].split("$");
                            }
                            g = -1;
                            m = 0;
                            p = 0;
                            for (e = 0; e < f; e += 1) {
                                if (c[e - 1] && c[e - 1][0] === c[e][0]) {
                                    c[e - 1] = "";
                                }
                                if (c[e][0] !== "margin" && c[e][0].indexOf("margin") !== -1) {
                                    m += 1;
                                    if (m === 4) {
                                        c[e][0] = "margin";
                                        c[e][1] = c[e][1] + " " + c[e - 1][1] + " " + c[e - 3][1] + " " + c[e - 2][1];
                                        c[e - 3] = "";
                                        c[e - 2] = "";
                                        c[e - 1] = "";
                                        if (c[e - 4] && c[e - 4][0] === "margin") {
                                            c[e - 4] = "";
                                        }
                                    }
                                } else if (c[e][0] !== "padding" && c[e][0].indexOf("padding") !== -1) {
                                    p += 1;
                                    if (p === 4) {
                                        c[e][0] = "padding";
                                        c[e][1] = c[e][1] + " " + c[e - 1][1] + " " + c[e - 3][1] + " " + c[e - 2][1];
                                        c[e - 3] = "";
                                        c[e - 2] = "";
                                        c[e - 1] = "";
                                        if (c[e - 4] && c[e - 4][0] === "padding") {
                                            c[e - 4] = "";
                                        }
                                    }
                                }
                                if (g === -1 && c[e + 1] && c[e][0].charAt(0) !== "-" && (c[e][0].indexOf("cue") !== -1 || c[e][0].indexOf("list-style") !== -1 || c[e][0].indexOf("outline") !== -1 || c[e][0].indexOf("overflow") !== -1 || c[e][0].indexOf("pause") !== -1) && (c[e][0] === c[e + 1][0].substring(0, c[e + 1][0].lastIndexOf("-")) || c[e][0].substring(0, c[e][0].lastIndexOf("-")) === c[e + 1][0].substring(0, c[e + 1][0].lastIndexOf("-")))) {
                                    g = e;
                                    if (c[g][0].indexOf("-") !== -1) {
                                        c[g][0] = c[g][0].substring(0, c[g][0].lastIndexOf("-"));
                                    }
                                } else if (g !== -1 && c[g][0] === c[e][0].substring(0, c[e][0].lastIndexOf("-"))) {
                                    if (c[g][0] === "cue" || c[g][0] === "pause") {
                                        c[g][1] = c[e][1] + " " + c[g][1];
                                    } else {
                                        c[g][1] = c[g][1] + " " + c[e][1];
                                    }
                                    c[e] = "";
                                } else if (g !== -1) {
                                    g = -1;
                                }
                            }
                            for (e = 0; e < f; e += 1) {
                                if (c[e] !== "") {
                                    c[e] = c[e].join(": ");
                                }
                            }
                            d[a] = c.join(";") + ";";
                        }
                    }
                    x = d.join("").replace(/\*\/\s*;\s*/g, "*/\n").replace(/(\s*[\w\-]+:)$/g, "\n}");
                };
            if ('\n' === x.charAt(0)) {
                x = x.substr(1);
            }
            x = x.replace(/[ \t\r\v\f]+/g, ' ').replace(/\n /g, "\n").replace(/\s?([;:{},+>])\s?/g, '$1').replace(/\{(\.*):(\.*)\}/g, '{$1: $2}').replace(/,/g, ', ').replace(/\b\*/g, ' *').replace(/\*\/\s?/g, "*/\n").replace(/\d%\d/g, fixpercent);
            if (alter === true) {
                reduction();
            }
            cleanAsync();
            if (alter === true) {
                x = x.split("*/");
                b = x.length;
                for (a = 0; a < b; a += 1) {
                    if (x[a].search(/\s*\/\*/) !== 0) {
                        x[a] = x[a].replace(/@charset\s*("|')?[\w\-]+("|')?;?\s*/gi, "").replace(/:[\w\s\!\.\-%]*\d+\.0*(?!\d)/g, endZero).replace(/:[\w\s\!\.\-%]* \.\d+/g, startZero).replace(/ \.?0((?=;)|(?= )|%|in|cm|mm|em|ex|pt|pc)/g, " 0px").replace(/: ((\.\d+|\d+\.\d+|\d+)[a-zA-Z]+|0 )+((\.\d+|\d+\.\d+|\d+)[a-zA-Z]+)|0/g, sameDist).replace(/background\-position: 0px;/g, "background-position: 0px 0px;").replace(/\s+\*\//g, "*/").replace(/PrettyDiff\|/g, "; ").replace(/\s*[\w\-]+:\s*\}/g, emptyend).replace(/\s*[\w\-]+:\s*;/g, "").replace(/\{\s+\}/g, "{}").replace(/url\("\w+: \/\//g, fixscheme).replace(/\}\s*;\s*\}/g, nestblock).replace(/:\s+#/g, ": #").replace(/(\s+;+\n)+/g, "\n");
                    }
                }
                x = x.join("*/");
                if (atchar === null) {
                    atchar = [""];
                } else if (atchar[0].charAt(atchar[0].length - 1) !== ";") {
                    atchar[0] = atchar[0] + ";\n";
                } else {
                    atchar[0] = atchar[0] + "\n";
                }
                x = atchar[0].replace(/@charset/i, "@charset") + fixURI(x);
            }
            if (comment === "noindent") {
                x = x.replace(/\s+\/\*/g, "\n/*").replace(/\n\s+\*\//g, "\n*/");
            }
            css_summary = function () {
                var a = 0,
                    b = [],
                    c = x.split("\n"),
                    d = c.length,
                    e = [],
                    f = q.toString().split("").reverse(),
                    g = x.length.toString().split("").reverse(),
                    h = 0;
                for (; a < d; a += 1) {
                    if (c[a].charAt(0) === "/" && c[a].charAt(1) === "*") {
                        for (; a < d; a += 1) {
                            if (c[a].charAt(c[a].length - 2) === "*" && c[a].charAt(c[a].length - 1) === "/") {
                                break;
                            }
                        }
                    } else if (c[a].indexOf("url") !== -1 && c[a].indexOf("url(\"\")") === -1 && c[a].indexOf("url('')") === -1 && c[a].indexOf("url()") === -1) {
                        b.push(c[a]);
                    }
                }
                d = b.length;
                for (a = 0; a < d; a += 1) {
                    b[a] = b[a].substr(b[a].indexOf("url(\"") + 5, b[a].length);
                    b[a] = b[a].substr(0, b[a].indexOf("\")"));
                }
                for (a = 0; a < d; a += 1) {
                    e[a] = 1;
                    for (c = a + 1; c < d; c += 1) {
                        if (b[a] === b[c]) {
                            e[a] += 1;
                            b[c] = "";
                        }
                    }
                }
                for (a = 0; a < d; a += 1) {
                    if (b[a] !== "") {
                        h += 1;
                        e[a] = e[a] + "x";
                        if (e[a] === "1x") {
                            e[a] = "<em>" + e[a] + "</em>";
                        }
                        b[a] = "<li>" + e[a] + " - " + b[a] + "</li>";
                    }
                }
                if (d === 0) {
                    b = "";
                } else {
                    b = "<h4>List of HTTP requests:</h4><ul>" + b.join("") + "</ul>";
                }
                c = f.length;
                for (a = 2; a < c; a += 3) {
                    f[a] = "," + f[a];
                }
                c = g.length;
                for (a = 2; a < c; a += 3) {
                    g[a] = "," + g[a];
                }
                f = f.reverse().join("");
                g = g.reverse().join("");
                if (f.charAt(0) === ",") {
                    f = f.slice(1, f.length);
                }
                if (g.charAt(0) === ",") {
                    g = g.slice(1, g.length);
                }
                return "<p><strong>Total input size:</strong> <em>" + f + "</em> characters</p><p><strong>Total output size:</strong> <em>" + g + "</em> characters</p><p><strong>Number of HTTP requests:</strong> <em>" + h + "</em></p>" + b;
            };
            return x;
        },
        js_beautify = function (js_source_text, indent_size, indent_char, preserve_newlines, max_preserve_newlines, indent_level, space_after_anon_function, braces_on_own_line, keep_array_indentation, indent_comm, ignore_content) {
            var j = [0, 0],
                k = [0, 0],
                l = [0, 0, 0],
                m = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                n = [0, 0, 0, 0, 0],
                o = [0, 0],
                w = [0, 0, 0, 0],
                i,
                white_count = function (x) {
                    var y,
                        z = x.length;
                    for (y = 0; y < z; y += 1) {
                        if (x.charAt(y) === ' ') {
                            w[1] += 1;
                        } else if (x.charAt(y) === '\t') {
                            w[2] += 1;
                        } else if (x.charAt(y) === '\n') {
                            w[0] += 1;
                        } else if (js_source_text.charAt(y) === '\r' || js_source_text.charAt(y) === '\f' || js_source_text.charAt(y) === '\v') {
                            w[3] += 1;
                        }
                    }
                },
                input = js_source_text,
                input_length = js_source_text.length,
                t,
                output = [],
                token_text,
                last_type = 'TK_START_EXPR',
                last_text = '',
                last_last_text = '',
                last_word = '',
                last_last_word = '',
                flags,
                functestval = 0,
                var_var_test = false,
                comma_test,
                flag_store = [],
                indent_string = '',
                wordchar = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '_', '$'],
                punct = ['+', '-', '*', '/', '%', '&', '++', '--', '=', '+=', '-=', '*=', '/=', '%=', '==', '===', '!=', '!==', '>', '<', '>=', '<=', '>>', '<<', '>>>', '>>>=', '>>=', '<<=', '&&', '&=', '|', '||', '!', '!!', ',', ':', '?', '^', '^=', '|=', '::'],
                parser_pos,
                prefix,
                token_type,
                do_block_just_closed = false,
                wanted_newline,
                just_added_newline = false,
                n_newlines,
                rvalue,
                lines,
                space_before = true,
                space_after = true,
                opt_indent_size = (isNaN(indent_size)) ? 4 : Number(indent_size),
                opt_indent_char = (indent_char && indent_char.length > 0) ? indent_char : ' ',
                opt_preserve_newlines = (preserve_newlines !== true) ? false : true,
                opt_max_preserve_newlines = (max_preserve_newlines) ? max_preserve_newlines : false,
                opt_indent_level = (isNaN(indent_level)) ? 0 : indent_level,
                opt_space_after_anon_function = (space_after_anon_function !== true) ? false : true,
                opt_braces_on_own_line = (braces_on_own_line !== 'allman') ? false : true,
                opt_keep_array_indentation = (keep_array_indentation !== true) ? false : true,
                opt_null_content = (ignore_content !== true) ? false : true,
                trim_output = function (eat_newlines) {
                    eat_newlines = (eat_newlines === undefined) ? false : eat_newlines;
                    while (output.length && (output[output.length - 1] === ' ' || output[output.length - 1] === indent_string || (eat_newlines && (output[output.length - 1] === '\n' || output[output.length - 1] === '\r')))) {
                        output.pop();
                    }
                },
                is_array = function (mode) {
                    return mode === '[EXPRESSION]' || mode === '[INDENTED-EXPRESSION]';
                },
                trim = function (s) {
                    return s.replace(/^\s\s*|\s\s*$/, '');
                },
                print_newline = function (ignore_repeated) {
                    var i;
                    flags.eat_next_space = false;
                    if (opt_keep_array_indentation && is_array(flags.mode)) {
                        return;
                    }
                    ignore_repeated = (ignore_repeated === undefined) ? true : ignore_repeated;
                    flags.if_line = false;
                    if (!output.length) {
                        return;
                    }
                    while (output[output.length - 1] === ' ' || output[output.length - 1] === indent_string) {
                        output.pop();
                    }
                    if (output[output.length - 1] !== "\n" || !ignore_repeated) {
                        just_added_newline = true;
                        output.push("\n");
                    }
                    for (i = 0; i < flags.indentation_level; i += 1) {
                        output.push(indent_string);
                    }
                    if (flags.var_line && flags.var_line_reindented) {
                        output.push(indent_string);
                    }
                },
                print_single_space = function () {
                    var last_output = ' ';
                    if (flags.eat_next_space) {
                        flags.eat_next_space = false;
                        return;
                    }
                    if (output.length) {
                        last_output = output[output.length - 1];
                    }
                    if (last_output !== ' ' && last_output !== '\n' && last_output !== indent_string) {
                        output.push(' ');
                    }
                },
                print_token = function () {
                    just_added_newline = false;
                    flags.eat_next_space = false;
                    output.push(token_text);
                },
                set_mode = function (mode) {
                    if (flags) {
                        flag_store.push(flags);
                    }
                    flags = {
                        previous_mode: flags ? flags.mode : 'BLOCK',
                        mode: mode,
                        var_line: false,
                        var_line_reindented: false,
                        in_html_comment: false,
                        if_line: false,
                        in_case: false,
                        eat_next_space: false,
                        indentation_baseline: -1,
                        indentation_level: (flags ? flags.indentation_level + ((flags.var_line && flags.var_line_reindented) ? 1 : 0) : opt_indent_level)
                    };
                },
                is_expression = function (mode) {
                    return mode === '[EXPRESSION]' || mode === '[INDENTED-EXPRESSION]' || mode === '(EXPRESSION)';
                },
                restore_mode = function () {
                    do_block_just_closed = flags.mode === 'DO_BLOCK';
                    if (flag_store.length > 0) {
                        flags = flag_store.pop();
                    }
                },
                in_array = function (what, arr) {
                    var i;
                    for (i = 0; i < arr.length; i += 1) {
                        if (arr[i] === what) {
                            return true;
                        }
                    }
                    return false;
                },
                is_ternary_op = function () {
                    var i,
                        level = 0,
                        colon_count = 0;
                    for (i = output.length - 1; i >= 0; i -= 1) {
                        if (output[i] === ':' && level === 0) {
                            colon_count += 1;
                        } else if (output[i] === '?' && level === 0) {
                            if (colon_count === 0) {
                                return true;
                            } else {
                                colon_count -= 1;
                            }
                        } else if (output[i] === '{' || output[i] === '(' || output[i] === '[') {
                            if (output[i] === '{' && level === 0) {
                                return false;
                            }
                            level -= 1;
                        } else if (output[i] === ')' || output[i] === '}' || output[i] === ']') {
                            level += 1;
                        }
                    }
                },
                fix_object_own_line = function () {
                    var b = output.length - 2;
                    for (; b > 0; b -= 1) {
                        if (/^(\s+)$/.test(output[b])) {
                            output[b] = '';
                        } else if (in_array(output[b], punct)) {
                            output[b + 1] = ' ';
                            break;
                        }
                    }
                },
                funcfix = function (y) {
                    var a = (y.indexOf("}") - 1),
                        b = "",
                        c;
                    if (y.charAt(0) === "\n") {
                        b = "\n";
                        c = y.substr(1, a);
                    } else {
                        c = y.substr(0, a);
                    }
                    return b + c + "}\n" + c + "(function";
                },
                get_next_token = function () {
                    var c,
                        i,
                        sign,
                        t,
                        comment,
                        inline_comment,
                        keep_whitespace,
                        sep,
                        esc,
                        resulting_string,
                        in_char_class,
                        sharp,
                        whitespace_count = 0;
                    n_newlines = 0;
                    if (parser_pos >= input_length) {
                        return ['', 'TK_EOF'];
                    }
                    wanted_newline = false;
                    c = input.charAt(parser_pos);
                    parser_pos += 1;
                    keep_whitespace = opt_keep_array_indentation && is_array(flags.mode);
                    if (keep_whitespace) {
                        whitespace_count = 0;
                        while (c === "\n" || c === "\r" || c === "\t" || c === " ") {
                            if (c === "\n") {
                                trim_output();
                                output.push("\n");
                                just_added_newline = true;
                                whitespace_count = 0;
                            } else {
                                if (c === '\t') {
                                    whitespace_count += 4;
                                } else if (c !== '\r') {
                                    whitespace_count += 1;
                                }
                            }
                            if (parser_pos >= input_length) {
                                return ['', 'TK_EOF'];
                            }
                            c = input.charAt(parser_pos);
                            parser_pos += 1;
                        }
                        if (flags.indentation_baseline === -1) {
                            flags.indentation_baseline = whitespace_count;
                        }
                        if (just_added_newline) {
                            for (i = 0; i < flags.indentation_level + 1; i += 1) {
                                output.push(indent_string);
                            }
                            if (flags.indentation_baseline !== -1) {
                                for (i = 0; i < whitespace_count - flags.indentation_baseline; i += 1) {
                                    output.push(' ');
                                }
                            }
                        }
                    } else {
                        while (c === "\n" || c === "\r" || c === "\t" || c === " ") {
                            if (c === "\n") {
                                n_newlines += ((opt_max_preserve_newlines) ? (n_newlines <= opt_max_preserve_newlines) ? 1 : 0 : 1);
                            }
                            if (parser_pos >= input_length) {
                                return ['', 'TK_EOF'];
                            }
                            c = input.charAt(parser_pos);
                            parser_pos += 1;
                        }
                        if (opt_preserve_newlines) {
                            if (n_newlines > 1) {
                                for (i = 0; i < n_newlines; i += 1) {
                                    print_newline(i === 0);
                                    just_added_newline = true;
                                }
                            }
                        }
                        wanted_newline = n_newlines > 0;
                    }
                    if (in_array(c, wordchar)) {
                        if (parser_pos < input_length) {
                            while (in_array(input.charAt(parser_pos), wordchar)) {
                                c += input.charAt(parser_pos);
                                parser_pos += 1;
                                if (parser_pos === input_length) {
                                    break;
                                }
                            }
                        }
                        if (parser_pos !== input_length && c.match(/^[0-9]+[Ee]$/) && (input.charAt(parser_pos) === '-' || input.charAt(parser_pos) === '+')) {
                            sign = input.charAt(parser_pos);
                            parser_pos += 1;
                            t = this(parser_pos);
                            c += sign + t[0];
                            return [c, 'TK_WORD'];
                        }
                        if (c === 'in') {
                            return [c, 'TK_OPERATOR'];
                        }
                        if (wanted_newline && last_type !== 'TK_OPERATOR' && !flags.if_line && (opt_preserve_newlines || last_text !== 'var')) {
                            print_newline();
                        }
                        return [c, 'TK_WORD'];
                    }
                    if (c === '(' || c === '[') {
                        return [c, 'TK_START_EXPR'];
                    }
                    if (c === ')' || c === ']') {
                        return [c, 'TK_END_EXPR'];
                    }
                    if (c === '{') {
                        return [c, 'TK_START_BLOCK'];
                    }
                    if (c === '}') {
                        return [c, 'TK_END_BLOCK'];
                    }
                    if (c === ';') {
                        return [c, 'TK_SEMICOLON'];
                    }
                    if (c === '/') {
                        comment = '';
                        inline_comment = true;
                        if (input.charAt(parser_pos) === '*') {
                            parser_pos += 1;
                            if (parser_pos < input_length) {
                                while (!(input.charAt(parser_pos) === '*' && input.charAt(parser_pos + 1) && input.charAt(parser_pos + 1) === '/') && parser_pos < input_length) {
                                    c = input.charAt(parser_pos);
                                    comment += c;
                                    if (c === '\x0d' || c === '\x0a') {
                                        inline_comment = false;
                                    }
                                    parser_pos += 1;
                                    if (parser_pos >= input_length) {
                                        break;
                                    }
                                }
                            }
                            parser_pos += 2;
                            if (inline_comment) {
                                return ['/*' + comment + '*/', 'TK_INLINE_COMMENT'];
                            } else {
                                return ['/*' + comment + '*/', 'TK_BLOCK_COMMENT'];
                            }
                        }
                        if (input.charAt(parser_pos) === '/') {
                            comment = c;
                            while (input.charAt(parser_pos) !== '\r' && input.charAt(parser_pos) !== '\n') {
                                comment += input.charAt(parser_pos);
                                parser_pos += 1;
                                if (parser_pos >= input_length) {
                                    break;
                                }
                            }
                            parser_pos += 1;
                            if (wanted_newline) {
                                print_newline();
                            }
                            return [comment, 'TK_COMMENT'];
                        }
                    }
                    if (c === "'" || c === '"' || (c === '/' && ((last_type === 'TK_WORD' && (last_text === 'return' || last_text === 'do')) || (last_type === 'TK_COMMENT' || last_type === 'TK_START_EXPR' || last_type === 'TK_START_BLOCK' || last_type === 'TK_END_BLOCK' || last_type === 'TK_OPERATOR' || last_type === 'TK_EQUALS' || last_type === 'TK_EOF' || last_type === 'TK_SEMICOLON')))) {
                        sep = c;
                        esc = false;
                        resulting_string = c;
                        if (parser_pos < input_length) {
                            if (sep === '/') {
                                in_char_class = false;
                                while (esc || in_char_class || input.charAt(parser_pos) !== sep) {
                                    resulting_string += input.charAt(parser_pos);
                                    if (!esc) {
                                        esc = input.charAt(parser_pos) === '\\';
                                        if (input.charAt(parser_pos) === '[') {
                                            in_char_class = true;
                                        } else if (input.charAt(parser_pos) === ']') {
                                            in_char_class = false;
                                        }
                                    } else {
                                        esc = false;
                                    }
                                    parser_pos += 1;
                                    if (parser_pos >= input_length) {
                                        return [resulting_string, 'TK_STRING'];
                                    }
                                }
                            } else {
                                while (esc || input.charAt(parser_pos) !== sep) {
                                    resulting_string += input.charAt(parser_pos);
                                    if (!esc) {
                                        esc = input.charAt(parser_pos) === '\\';
                                    } else {
                                        esc = false;
                                    }
                                    parser_pos += 1;
                                    if (parser_pos >= input_length) {
                                        return [resulting_string, 'TK_STRING'];
                                    }
                                }
                            }
                        }
                        parser_pos += 1;
                        resulting_string += sep;
                        if (sep === '/') {
                            while (parser_pos < input_length && in_array(input.charAt(parser_pos), wordchar)) {
                                resulting_string += input.charAt(parser_pos);
                                parser_pos += 1;
                            }
                        }
                        return [resulting_string, 'TK_STRING'];
                    }
                    if (c === '#') {
                        sharp = '#';
                        if (parser_pos < input_length && (input.charAt(parser_pos) === '0' || input.charAt(parser_pos) === '1' || input.charAt(parser_pos) === '2' || input.charAt(parser_pos) === '3' || input.charAt(parser_pos) === '4' || input.charAt(parser_pos) === '5' || input.charAt(parser_pos) === '6' || input.charAt(parser_pos) === '7' || input.charAt(parser_pos) === '8' || input.charAt(parser_pos) === '9')) {
                            do {
                                c = input.charAt(parser_pos);
                                sharp += c;
                                parser_pos += 1;
                            } while (parser_pos < input_length && c !== '#' && c !== '=');
                            if (c !== "#" && input.charAt(parser_pos) === '[' && input.charAt(parser_pos + 1) === ']') {
                                sharp += '[]';
                                parser_pos += 2;
                            } else if (c !== "#" && input.charAt(parser_pos) === '{' && input.charAt(parser_pos + 1) === '}') {
                                sharp += '{}';
                                parser_pos += 2;
                            }
                            return [sharp, 'TK_WORD'];
                        }
                    }
                    if (c === '<' && input.substring(parser_pos - 1, parser_pos + 3) === '<!--') {
                        parser_pos += 3;
                        flags.in_html_comment = true;
                        return ['<!--', 'TK_COMMENT'];
                    }
                    if (c === '-' && flags.in_html_comment && input.substring(parser_pos - 1, parser_pos + 2) === '-->') {
                        flags.in_html_comment = false;
                        parser_pos += 2;
                        if (wanted_newline) {
                            print_newline();
                        }
                        return ['-->', 'TK_COMMENT'];
                    }
                    if (in_array(c, punct)) {
                        while (parser_pos < input_length && in_array(c + input.charAt(parser_pos), punct)) {
                            c += input.charAt(parser_pos);
                            parser_pos += 1;
                            if (parser_pos >= input_length) {
                                break;
                            }
                        }
                        if (c === '=') {
                            return [c, 'TK_EQUALS'];
                        } else {
                            return [c, 'TK_OPERATOR'];
                        }
                    }
                    return [c, 'TK_UNKNOWN'];
                };
            while (opt_indent_size > 0) {
                indent_string += opt_indent_char;
                opt_indent_size -= 1;
            }
            set_mode('BLOCK');
            parser_pos = 0;
            while (true) {
                t = get_next_token(parser_pos);
                token_text = t[0];
                token_type = t[1];
                if (token_type === 'TK_EOF') {
                    break;
                } else if (token_type === 'TK_START_EXPR') {
                    n[4] += 1;
                    if (token_text === '[') {
                        if (last_type === 'TK_WORD' || last_text === ')') {
                            if (last_text === 'continue' || last_text === 'try' || last_text === 'throw' || last_text === 'return' || last_text === 'var' || last_text === 'if' || last_text === 'switch' || last_text === 'case' || last_text === 'default' || last_text === 'for' || last_text === 'while' || last_text === 'break' || last_text === 'function') {
                                print_single_space();
                            }
                            set_mode('(EXPRESSION)');
                            print_token();
                        } else if (flags.mode === '[EXPRESSION]' || flags.mode === '[INDENTED-EXPRESSION]') {
                            if (last_last_text === ']' && last_text === ',') {
                                if (flags.mode === '[EXPRESSION]') {
                                    flags.mode = '[INDENTED-EXPRESSION]';
                                    if (!opt_keep_array_indentation) {
                                        flags.indentation_level += 1;
                                    }
                                }
                                set_mode('[EXPRESSION]');
                                if (!opt_keep_array_indentation) {
                                    print_newline();
                                }
                            } else if (last_text === '[') {
                                if (flags.mode === '[EXPRESSION]') {
                                    flags.mode = '[INDENTED-EXPRESSION]';
                                    if (!opt_keep_array_indentation) {
                                        flags.indentation_level += 1;
                                    }
                                }
                                set_mode('[EXPRESSION]');
                                if (!opt_keep_array_indentation) {
                                    print_newline();
                                }
                            } else {
                                set_mode('[EXPRESSION]');
                            }
                        } else {
                            set_mode('[EXPRESSION]');
                        }
                    } else {
                        set_mode('(EXPRESSION)');
                    }
                    if (token_text !== '[' || (token_text === '[' && (last_type !== 'TK_WORD' && last_text !== ')'))) {
                        if (last_text === ';' || last_type === 'TK_START_BLOCK') {
                            print_newline();
                        } else if (last_type !== 'TK_END_EXPR' && last_type !== 'TK_START_EXPR' && last_type !== 'TK_END_BLOCK' && last_text !== '.') {
                            if ((last_type !== 'TK_WORD' && last_type !== 'TK_OPERATOR') || (last_word === 'function' && opt_space_after_anon_function)) {
                                print_single_space();
                            } else if (last_text === 'continue' || last_text === 'try' || last_text === 'throw' || last_text === 'return' || last_text === 'var' || last_text === 'if' || last_text === 'switch' || last_text === 'case' || last_text === 'default' || last_text === 'for' || last_text === 'while' || last_text === 'break' || last_text === 'function' || last_text === 'catch') {
                                print_single_space();
                            }
                        }
                        print_token();
                    }
                } else if (token_type === 'TK_END_EXPR') {
                    n[4] += 1;
                    if (token_text === ']' && opt_keep_array_indentation && last_text === '}') {
                        if (output.length && output[output.length - 1] === indent_string) {
                            output.pop();
                        }
                        print_token();
                        restore_mode();
                    } else if (token_text === ']' && flags.mode === '[INDENTED-EXPRESSION]' && last_text === ']') {
                        restore_mode();
                        print_newline();
                        print_token();
                    } else {
                        restore_mode();
                        print_token();
                    }
                } else if (token_type === 'TK_START_BLOCK') {
                    n[4] += 1;
                    if (last_word === 'do') {
                        set_mode('DO_BLOCK');
                    } else {
                        set_mode('BLOCK');
                    }
                    if (opt_braces_on_own_line) {
                        if (last_type !== 'TK_OPERATOR') {
                            if (last_text === 'return') {
                                print_single_space();
                            } else {
                                print_newline();
                            }
                        }
                    } else {
                        if (functestval > 1) {
                            flags.indentation_level += 1;
                            var_var_test = true;
                            comma_test = true;
                        }
                        if (last_type !== 'TK_OPERATOR' && last_type !== 'TK_START_EXPR') {
                            if (last_type === 'TK_START_BLOCK') {
                                print_newline();
                            } else {
                                print_single_space();
                            }
                        } else {
                            if (is_array(flags.previous_mode) && last_text === ',') {
                                print_newline();
                            }
                        }
                    }
                    flags.indentation_level += 1;
                    print_token();
                } else if (token_type === 'TK_END_BLOCK') {
                    n[4] += 1;
                    restore_mode();
                    functestval = 0;
                    if (opt_braces_on_own_line) {
                        if (last_text === "{" && in_array(last_last_text, punct)) {
                            fix_object_own_line();
                        } else {
                            print_newline();
                        }
                        print_token();
                    } else {
                        if (last_type === 'TK_START_BLOCK') {
                            if (just_added_newline) {
                                if (output.length && output[output.length - 1] === indent_string) {
                                    output.pop();
                                }
                            } else {
                                trim_output();
                            }
                        } else if (is_array(flags.mode) && opt_keep_array_indentation) {
                            opt_keep_array_indentation = false;
                            print_newline();
                            opt_keep_array_indentation = true;
                        } else {
                            print_newline();
                        }
                        if (var_var_test && (comma_test || (!flags.var_line))) {
                            output.push(indent_string);
                            print_token();
                            var_var_test = false;
                        } else {
                            print_token();
                        }
                    }
                } else if (token_type === 'TK_WORD') {
                    if (token_text === 'alert') {
                        m[0] += 1;
                    } else if (token_text === 'break') {
                        m[2] += 1;
                    } else if (token_text === 'case') {
                        m[4] += 1;
                    } else if (token_text === 'catch') {
                        m[48] += 1;
                    } else if (token_text === 'continue') {
                        m[6] += 1;
                    } else if (token_text === 'default') {
                        m[8] += 1;
                    } else if (token_text === 'delete') {
                        m[10] += 1;
                    } else if (token_text === 'do') {
                        m[12] += 1;
                    } else if (token_text === 'document') {
                        m[44] += 1;
                    } else if (token_text === 'else') {
                        m[14] += 1;
                    } else if (token_text === 'eval') {
                        m[16] += 1;
                    } else if (token_text === 'for') {
                        m[18] += 1;
                    } else if (token_text === 'function') {
                        m[20] += 1;
                    } else if (token_text === 'if') {
                        m[22] += 1;
                    } else if (token_text === 'in') {
                        m[24] += 1;
                    } else if (token_text === 'label') {
                        m[26] += 1;
                    } else if (token_text === 'new') {
                        m[28] += 1;
                    } else if (token_text === 'return') {
                        m[30] += 1;
                    } else if (token_text === 'switch') {
                        m[32] += 1;
                    } else if (token_text === 'this') {
                        m[34] += 1;
                    } else if (token_text === 'throw') {
                        m[50] += 1;
                    } else if (token_text === 'try') {
                        m[52] += 1;
                    } else if (token_text === 'typeof') {
                        m[36] += 1;
                    } else if (token_text === 'var') {
                        m[38] += 1;
                    } else if (token_text === 'while') {
                        m[40] += 1;
                    } else if (token_text === 'with') {
                        m[42] += 1;
                    } else if (token_text === 'window') {
                        m[46] += 1;
                    } else {
                        o[0] += 1;
                        o[1] += token_text.length;
                    }
                    if (token_text !== 'var' && last_text === ';') {
                        comma_test = false;
                    }
                    if (last_text === '{' && last_last_text === ':') {
                        output.push(indent_string);
                        flags.indentation_level += 1;
                    }
                    if (do_block_just_closed) {
                        print_single_space();
                        print_token();
                        print_single_space();
                        do_block_just_closed = false;
                    } else {
                        if (token_text === 'case' || token_text === 'default') {
                            if (last_text === ':') {
                                if (output.length && output[output.length - 1] === indent_string) {
                                    output.pop();
                                }
                            } else {
                                flags.indentation_level -= 1;
                                print_newline();
                                flags.indentation_level += 1;
                            }
                            print_token();
                            flags.in_case = true;
                        } else {
                            if (token_text === 'function') {
                                if (comma_test && (flags.var_line || (!flags.var_line && last_last_word === 'var'))) {
                                    functestval += 1;
                                } else if (!comma_test) {
                                    functestval -= 1;
                                }
                                if ((just_added_newline || last_text === ';') && last_text !== '{') {
                                    n_newlines = just_added_newline ? n_newlines : 0;
                                    if (!opt_preserve_newlines) {
                                        n_newlines = 1;
                                    }
                                    for (i = 0; i < 2 - n_newlines; i += 1) {
                                        print_newline(false);
                                    }
                                }
                            }
                            prefix = 'NONE';
                            if (last_type === 'TK_END_BLOCK') {
                                if (opt_braces_on_own_line || (token_text !== 'else' && token_text !== 'catch' && token_text !== 'finally')) {
                                    prefix = 'NEWLINE';
                                } else {
                                    prefix = 'SPACE';
                                    print_single_space();
                                }
                            } else if (last_type === 'TK_STRING' || last_type === 'TK_START_BLOCK' || (last_type === 'TK_SEMICOLON' && (flags.mode === 'BLOCK' || flags.mode === 'DO_BLOCK'))) {
                                prefix = 'NEWLINE';
                            } else if (last_type === 'TK_WORD' || (last_type === 'TK_SEMICOLON' && is_expression(flags.mode))) {
                                prefix = 'SPACE';
                            } else if (last_type === 'TK_END_EXPR') {
                                print_single_space();
                                prefix = 'NEWLINE';
                            }
                            if (flags.if_line && last_type === 'TK_END_EXPR') {
                                flags.if_line = false;
                            }
                            if (token_text === 'else' || token_text === 'catch' || token_text === 'finally') {
                                if (last_type !== 'TK_END_BLOCK' || opt_braces_on_own_line) {
                                    print_newline();
                                } else {
                                    trim_output(true);
                                    print_single_space();
                                }
                            } else if (last_type !== 'TK_START_EXPR' && last_text !== '=' && last_text !== ',' && (token_text === 'continue' || token_text === 'try' || token_text === 'throw' || token_text === 'return' || token_text === 'var' || token_text === 'if' || token_text === 'switch' || token_text === 'case' || token_text === 'default' || token_text === 'for' || token_text === 'while' || token_text === 'break' || token_text === 'function' || prefix === 'NEWLINE')) {
                                if (last_text === 'return' || last_text === 'throw' || (last_type !== 'TK_END_EXPR' && last_text !== ':' && (last_type !== 'TK_START_EXPR' || token_text !== 'var'))) {
                                    if (token_text === 'if' && last_word === 'else' && last_text !== '{') {
                                        print_single_space();
                                    } else {
                                        print_newline();
                                    }
                                } else if (last_text !== ')' && (token_text === 'continue' || token_text === 'try' || token_text === 'throw' || token_text === 'return' || token_text === 'var' || token_text === 'if' || token_text === 'switch' || token_text === 'case' || token_text === 'default' || token_text === 'for' || token_text === 'while' || token_text === 'break' || token_text === 'function')) {
                                    print_newline();
                                }
                            } else if (prefix === 'SPACE') {
                                print_single_space();
                            } else if (last_text === ';' || (is_array(flags.mode) && last_text === ',' && last_last_text === '}')) {
                                print_newline();
                            }
                            if (token_text === 'var') {
                                if (!var_var_test && comma_test && last_type === 'TK_START_BLOCK') {
                                    flags.indentation_level += 1;
                                    output.push(indent_string);
                                    var_var_test = true;
                                }
                                flags.var_line = true;
                                flags.var_line_reindented = false;
                            }
                            print_token();
                            if (token_text === 'typeof') {
                                print_single_space();
                            }
                            if (token_text === 'if') {
                                flags.if_line = true;
                            }
                            if (token_text === 'else') {
                                flags.if_line = false;
                            }
                            last_last_word = last_word;
                            last_word = token_text;
                        }
                    }
                } else if (token_type === 'TK_SEMICOLON') {
                    n[3] += 1;
                    if (last_text === '}') {
                        comma_test = true;
                    }
                    print_token();
                    flags.var_line = false;
                    flags.var_line_reindented = false;
                } else if (token_type === 'TK_STRING') {
                    l[0] += 1;
                    if ((token_text.charAt(0) === "\"" && token_text.charAt(token_text.length - 1) === "\"") || (token_text.charAt(0) === "'" && token_text.charAt(token_text.length - 1) === "'")) {
                        l[1] += token_text.length - 2;
                        l[2] += 2;
                    } else {
                        l[1] += token_text.length;
                    }
                    white_count(token_text);
                    if (last_type === 'TK_START_BLOCK' || last_type === 'TK_END_BLOCK' || last_type === 'TK_SEMICOLON') {
                        print_newline();
                    } else if (last_type === 'TK_WORD') {
                        print_single_space();
                    }
                    if (opt_null_content) {
                        output.push(token_text.charAt(0) + 'text' + token_text.charAt(0));
                    } else {
                        print_token();
                    }
                } else if (token_type === 'TK_EQUALS') {
                    n[0] += 1;
                    n[1] += 1;
                    print_single_space();
                    print_token();
                    print_single_space();
                } else if (token_type === 'TK_OPERATOR') {
                    if (token_text !== ',') {
                        n[0] += 1;
                        n[1] += token_text.length;
                    }
                    if (token_text === ',') {
                        n[2] += 1;
                        if (flags.mode !== '(EXPRESSION)' && last_last_text !== ':') {
                            comma_test = false;
                        }
                        if (flags.var_line) {
                            if (last_text !== '}') {
                                flags.var_line_reindented = true;
                            }
                            print_token();
                            print_newline();
                        } else if (last_type === 'TK_END_BLOCK' && flags.mode !== '(EXPRESSION)') {
                            print_token();
                            if (last_text === '}') {
                                print_newline();
                            } else {
                                print_single_space();
                            }
                        } else if (flags.mode === 'BLOCK' || flags.mode === 'OBJECT' || is_ternary_op()) {
                            print_token();
                            print_newline();
                        } else {
                            print_token();
                            print_single_space();
                        }
                    } else if (last_text === 'return' || last_text === 'throw') {
                        print_single_space();
                        print_token();
                    } else if (token_text === '::') {
                        print_token();
                    } else if (token_text === '--' || token_text === '++' || token_text === '!' || ((token_text === '-' || token_text === '+') && (last_type === 'TK_START_BLOCK' || last_type === 'TK_START_EXPR' || last_type === 'TK_EQUALS' || last_type === 'TK_OPERATOR' || last_text === 'continue' || last_text === 'try' || last_text === 'throw' || last_text === 'return' || last_text === 'var' || last_text === 'if' || last_text === 'switch' || last_text === 'case' || last_text === 'default' || last_text === 'for' || last_text === 'while' || last_text === 'break' || last_text === 'function'))) {
                        space_before = false;
                        space_after = false;
                        if (last_text === ';' && is_expression(flags.mode)) {
                            space_before = true;
                        }
                        if (last_type === 'TK_WORD' && (last_text === 'continue' || last_text === 'try' || last_text === 'throw' || last_text === 'return' || last_text === 'var' || last_text === 'if' || last_text === 'switch' || last_text === 'case' || last_text === 'default' || last_text === 'for' || last_text === 'while' || last_text === 'break' || last_text === 'function')) {
                            space_before = true;
                        }
                        if (flags.mode === 'BLOCK' && (last_text === '{' || last_text === ';')) {
                            print_newline();
                        }
                    } else if (token_text === '.') {
                        space_before = false;
                    }
                    if (token_text !== ',' && token_text !== ':' && (token_text !== '-' || (token_text === '-' && last_text !== 'continue' && last_text !== 'try' && last_text !== 'throw' && last_text !== 'return' && last_text !== 'var' && last_text !== 'if' && last_text !== 'switch' && last_text !== 'case' && last_text !== 'default' && last_text !== 'for' && last_text !== 'while' && last_text !== 'break' && last_text !== 'function'))) {
                        if (space_before) {
                            print_single_space();
                        }
                        print_token();
                        if (space_after) {
                            print_single_space();
                        }
                    } else if (token_text === ":") {
                        if (flags.in_case) {
                            print_token();
                            print_newline();
                            flags.in_case = false;
                        } else if (is_ternary_op()) {
                            print_single_space();
                            print_token();
                            print_single_space();
                            flags.mode = 'OBJECT';
                        } else if (flags.in_case) {
                            print_single_space();
                            print_token();
                            print_single_space();
                        } else if (last_last_text !== 'case' && last_last_text !== 'default' && last_text !== 'case' && last_text !== 'default') {
                            print_token();
                            print_single_space();
                        }
                    }
                    space_before = true;
                    space_after = true;
                } else if (token_type === 'TK_BLOCK_COMMENT') {
                    j[0] += 1;
                    j[1] += token_text.length;
                    white_count(token_text);
                    if (indent_comm === "noindent") {
                        for (i = output.length - 1; i > 0; i -= 1) {
                            if (output[i] === indent_string || output[i] === " ") {
                                output[i] = "";
                            } else {
                                break;
                            }
                        }
                        print_token();
                        print_newline();
                    } else {
                        lines = token_text.split(/\x0a|\x0d\x0a/);
                        print_newline();
                        output.push(lines[0]);
                        for (i = 1; i < lines.length; i += 1) {
                            print_newline();
                            output.push(' ');
                            output.push(trim(lines[i]));
                        }
                        print_newline();
                    }
                } else if (token_type === 'TK_INLINE_COMMENT') {
                    j[0] += 1;
                    j[1] += token_text.length;
                    white_count(token_text);
                    if (indent_comm !== "noindent") {
                        print_single_space();
                    } else {
                        output.push("\n");
                    }
                    print_token();
                    if (is_expression(flags.mode)) {
                        print_single_space();
                    } else if (indent_comm === "noindent") {
                        output.push("\n");
                    } else {
                        print_newline();
                    }
                } else if (token_type === 'TK_COMMENT') {
                    k[0] += 1;
                    k[1] += token_text.length;
                    white_count(token_text);
                    if (indent_comm === "noindent") {
                        for (i = output.length - 1; i > 0; i -= 1) {
                            if (output[i] === indent_string) {
                                output[i] = "";
                            } else {
                                break;
                            }
                        }
                    } else if (wanted_newline) {
                        print_newline();
                    } else {
                        print_single_space();
                    }
                    print_token();
                    print_newline();
                } else if (token_type === 'TK_UNKNOWN') {
                    n[0] += 1;
                    n[1] += token_text.length;
                    white_count(token_text);
                    if (last_text === 'return' || last_text === 'throw') {
                        print_single_space();
                    }
                    print_token();
                }
                last_last_text = last_text;
                last_type = token_type;
                last_text = token_text;
            }
            rvalue = output.join('').replace(/^(\s+)/, '').replace(/(\s+)$/, '').replace(/\s*\}\(function/g, funcfix).replace(/:\s*\(?function/g, ': function');
            js_summary = function () {
                var a,
                    b,
                    e = 1,
                    f = 1,
                    g = 0,
                    h = 0,
                    i,
                    p = 0,
                    q = [],
                    z = [],
                    output,
                    zero = function (x, y) {
                        if (y === 0) {
                            return "0.00%";
                        } else {
                            return ((x / y) * 100).toFixed(2) + "%";
                        }
                    };
                if (rvalue.length <= input_length) {
                    b = input_length;
                } else {
                    b = rvalue.length;
                }
                for (a = 0; a < b; a += 1) {
                    if (js_source_text.charAt(a) === ' ') {
                        g += 1;
                    } else if (js_source_text.charAt(a) === '\t') {
                        h += 1;
                    } else if (js_source_text.charAt(a) === '\n') {
                        e += 1;
                    } else if (js_source_text.charAt(a) === '\r' || js_source_text.charAt(a) === '\f' || js_source_text.charAt(a) === '\v') {
                        p += 1;
                    }
                    if (rvalue.charAt(a) === "\n") {
                        f += 1;
                    }
                }
                if (m[0] > 0) {
                    q[0] = " class='bad'";
                } else {
                    q[0] = "";
                }
                if (m[6] > 0) {
                    q[1] = " class='bad'";
                } else {
                    q[1] = "";
                }
                if (m[16] > 0) {
                    q[2] = " class='bad'";
                } else {
                    q[2] = "";
                }
                if (m[42] > 0) {
                    q[3] = " class='bad'";
                } else {
                    q[3] = "";
                }
                g = g - w[1];
                h = h - w[2];
                p = p - w[3];
                i = ((e - 1 - w[0]) + g + h + p);
                n.push(l[2] + n[0] + n[2] + n[3] + n[4]);
                n.push(l[2] + n[1] + n[2] + n[3] + n[4]);
                j.push(j[0] + k[0]);
                j.push(j[1] + k[1]);
                m[1] = m[0] * 5;
                m[3] = m[2] * 5;
                m[5] = m[4] * 4;
                m[7] = m[6] * 8;
                m[9] = m[8] * 7;
                m[11] = m[10] * 6;
                m[13] = m[12] * 2;
                m[15] = m[14] * 4;
                m[17] = m[16] * 4;
                m[19] = m[18] * 3;
                m[21] = m[20] * 8;
                m[23] = m[22] * 2;
                m[25] = m[24] * 2;
                m[27] = m[26] * 5;
                m[29] = m[28] * 3;
                m[31] = m[30] * 6;
                m[33] = m[32] * 6;
                m[35] = m[34] * 4;
                m[37] = m[36] * 6;
                m[39] = m[38] * 3;
                m[41] = m[40] * 5;
                m[43] = m[42] * 4;
                m[45] = m[44] * 8;
                m[47] = m[46] * 6;
                m[49] = m[48] * 5;
                m[51] = m[50] * 5;
                m[53] = m[52] * 3;
                m[54] = m[0] + m[2] + m[4] + m[6] + m[8] + m[10] + m[12] + m[14] + m[16] + m[18] + m[20] + m[22] + m[24] + m[26] + m[28] + m[30] + m[32] + m[34] + m[36] + m[38] + m[40] + m[42] + m[44] + m[46] + m[48] + m[50] + m[52];
                m[55] = m[1] + m[3] + m[5] + m[7] + m[9] + m[11] + m[13] + m[15] + m[17] + m[19] + m[21] + m[23] + m[25] + m[27] + m[29] + m[31] + m[33] + m[35] + m[37] + m[39] + m[41] + m[43] + m[45] + m[47] + m[49] + m[51] + m[53];
                z.push(j[2] + l[0] + n[5] + m[54] + o[0] + i);
                z.push(j[3] + l[1] + n[6] + m[55] + o[1] + i);
                output = ["<div id='doc'>"];
                output.push("<table class='analysis' summary='JavaScript character size comparison'><caption>JavaScript data report</caption><thead><tr><th>Data Label</th><th>Input</th><th>Output</th><th>Literal Increase</th><th>Percentage Increase</th></tr>");
                output.push("</thead><tbody><tr><th>Total Character Size</th><td>" + input_length + "</td><td>" + rvalue.length + "</td><td>" + (rvalue.length - input_length) + "</td><td>" + (((rvalue.length - input_length) / rvalue.length) * 100).toFixed(2));
                output.push("%</td></tr><tr><th>Total Lines of Code</th><td>" + e + "</td><td>" + f + "</td><td>" + (f - e) + "</td><td>" + (((f - e) / e) * 100).toFixed(2) + "%</td></tr></tbody></table>");
                output.push("<table class='analysis' summary='JavaScript component analysis'><caption>JavaScript component analysis</caption><thead><tr><th>JavaScript Component</th><th>Component Quantity</th><th>Percentage Quantity from Section</th>");
                output.push("<th>Percentage Qauntity from Total</th><th>Character Length</th><th>Percentage Length from Section</th><th>Percentage Length from Total</th></tr></thead><tbody>");
                output.push("<tr><th>Total Accounted</th><td>" + z[0] + "</td><td>100.00%</td><td>100.00%</td><td>" + z[1] + "</td><td>100.00%</td><td>100.00%</td></tr>");
                output.push("<tr><th colspan='7'>Comments</th></tr>");
                output.push("<tr><th>Block Comments</th><td>" + j[0] + "</td><td>" + zero(j[0], j[2]) + "</td><td>" + zero(j[0], z[0]) + "</td><td>" + j[1] + "</td><td>" + zero(j[1], j[3]) + "</td><td>" + zero(j[1], z[1]) + "</td></tr>");
                output.push("<tr><th>Inline Comments</th><td>" + k[0] + "</td><td>" + zero(k[0], j[2]) + "</td><td>" + zero(k[0], z[0]) + "</td><td>" + k[1] + "</td><td>" + zero(k[1], j[3]) + "</td><td>" + zero(k[1], z[1]) + "</td></tr>");
                output.push("<tr><th>Comment Total</th><td>" + j[2] + "</td><td>100.00%</td><td>" + zero(j[2], z[0]) + "</td><td>" + j[3] + "</td><td>100.00%</td><td>" + zero(j[3], z[1]) + "</td></tr>");
                output.push("<tr><th colspan='7'>Whitespace Outside of Strings and Comments</th></tr>");
                output.push("<tr><th>New Lines</th><td>" + (e - 1 - w[0]) + "</td><td>" + zero(e - 1 - w[0], i) + "</td><td>" + zero(e - 1 - w[0], z[0]) + "</td><td>" + (e - 1 - w[0]) + "</td><td>" + zero(e - 1 - w[0], i) + "</td><td>" + zero(e - 1 - w[0], z[1]) + "</td></tr>");
                output.push("<tr><th>Spaces</th><td>" + g + "</td><td>" + zero(g, i) + "</td><td>" + zero(g, z[0]) + "</td><td>" + g + "</td><td>" + zero(g, i) + "</td><td>" + zero(g, z[1]) + "</td></tr>");
                output.push("<tr><th>Tabs</th><td>" + h + "</td><td>" + zero(h, i) + "</td><td>" + zero(h, z[0]) + "</td><td>" + h + "</td><td>" + zero(h, i) + "</td><td>" + zero(h, z[1]) + "</td></tr>");
                output.push("<tr><th>Other Whitespace</th><td>" + p + "</td><td>" + zero(p, i) + "</td><td>" + zero(p, z[0]) + "</td><td>" + p + "</td><td>" + zero(p, i) + "</td><td>" + zero(p, z[1]) + "</td></tr>");
                output.push("<tr><th>Total Whitespace</th><td>" + i + "</td><td>100.00%</td><td>" + zero(i, z[0]) + "</td><td>" + i + "</td><td>100.00%</td><td>" + zero(i, z[1]) + "</td></tr>");
                output.push("<tr><th colspan='7'>Strings</th></tr>");
                output.push("<tr><th>Strings</th><td>" + l[0] + "</td><td>100.00%</td><td>" + zero(l[0], z[0]) + "</td><td>" + l[1] + "</td><td>100.00%</td><td>" + zero(l[1], z[1]) + "</td></tr>");
                output.push("<tr><th colspan='7'>Syntax Characters</th></tr>");
                output.push("<tr><th>Quote Characters</th><td>" + l[2] + "</td><td>" + zero(l[2], n[5]) + "</td><td>" + zero(l[2], z[0]) + "</td><td>" + l[2] + "</td><td>" + zero(l[2], n[6]) + "</td><td>" + zero(l[2], z[1]) + "</td></tr>");
                output.push("<tr><th>Commas</th><td>" + n[2] + "</td><td>" + zero(n[2], n[5]) + "</td><td>" + zero(n[2], z[0]) + "</td><td>" + n[2] + "</td><td>" + zero(n[2], n[6]) + "</td><td>" + zero(n[2], z[1]) + "</td></tr>");
                output.push("<tr><th>Containment Characters</th><td>" + n[4] + "</td><td>" + zero(n[4], n[5]) + "</td><td>" + zero(n[4], z[0]) + "</td><td>" + n[4] + "</td><td>" + zero(n[4], n[6]) + "</td><td>" + zero(n[4], z[1]) + "</td></tr>");
                output.push("<tr><th>Semicolons</th><td>" + n[3] + "</td><td>" + zero(n[3], n[5]) + "</td><td>" + zero(n[3], z[0]) + "</td><td>" + n[3] + "</td><td>" + zero(n[3], n[6]) + "</td><td>" + zero(n[3], z[1]) + "</td></tr>");
                output.push("<tr><th>Operators</th><td>" + n[0] + "</td><td>" + zero(n[0], n[5]) + "</td><td>" + zero(n[0], z[0]) + "</td><td>" + n[1] + "</td><td>" + zero(n[1], n[6]) + "</td><td>" + zero(n[1], z[1]) + "</td></tr>");
                output.push("<tr><th>Total Syntax Characters</th><td>" + n[5] + "</td><td>100.00%</td><td>" + zero(n[5], z[0]) + "</td><td>" + n[6] + "</td><td>100.00%</td><td>" + zero(n[6], z[1]) + "</td></tr>");
                output.push("<tr><th colspan='7'>Keywords</th></tr>");
                output.push("<tr><th>Keyword 'alert'</th><td" + q[0] + ">" + m[0] + "</td><td>" + zero(m[0], m[54]) + "</td><td>" + zero(m[0], z[0]) + "</td><td>" + m[1] + "</td><td>" + zero(m[1], m[55]) + "</td><td>" + zero(m[1], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'break'</th><td>" + m[2] + "</td><td>" + zero(m[2], m[54]) + "</td><td>" + zero(m[2], z[0]) + "</td><td>" + m[3] + "</td><td>" + zero(m[3], m[55]) + "</td><td>" + zero(m[3], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'case'</th><td>" + m[4] + "</td><td>" + zero(m[4], m[54]) + "</td><td>" + zero(m[4], z[0]) + "</td><td>" + m[5] + "</td><td>" + zero(m[5], m[55]) + "</td><td>" + zero(m[5], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'catch'</th><td>" + m[48] + "</td><td>" + zero(m[48], m[54]) + "</td><td>" + zero(m[48], z[0]) + "</td><td>" + m[49] + "</td><td>" + zero(m[49], m[55]) + "</td><td>" + zero(m[49], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'continue'</th><td" + q[1] + ">" + m[6] + "</td><td>" + zero(m[6], m[54]) + "</td><td>" + zero(m[6], z[0]) + "</td><td>" + m[7] + "</td><td>" + zero(m[7], m[55]) + "</td><td>" + zero(m[7], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'default'</th><td>" + m[8] + "</td><td>" + zero(m[8], m[54]) + "</td><td>" + zero(m[8], z[0]) + "</td><td>" + m[9] + "</td><td>" + zero(m[9], m[55]) + "</td><td>" + zero(m[9], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'delete'</th><td>" + m[10] + "</td><td>" + zero(m[10], m[54]) + "</td><td>" + zero(m[10], z[0]) + "</td><td>" + m[11] + "</td><td>" + zero(m[11], m[55]) + "</td><td>" + zero(m[11], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'do'</th><td>" + m[12] + "</td><td>" + zero(m[12], m[54]) + "</td><td>" + zero(m[12], z[0]) + "</td><td>" + m[13] + "</td><td>" + zero(m[13], m[55]) + "</td><td>" + zero(m[13], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'document'</th><td>" + m[44] + "</td><td>" + zero(m[44], m[54]) + "</td><td>" + zero(m[44], z[0]) + "</td><td>" + m[45] + "</td><td>" + zero(m[45], m[55]) + "</td><td>" + zero(m[45], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'else'</th><td>" + m[14] + "</td><td>" + zero(m[14], m[54]) + "</td><td>" + zero(m[14], z[0]) + "</td><td>" + m[15] + "</td><td>" + zero(m[15], m[55]) + "</td><td>" + zero(m[15], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'eval'</th><td" + q[2] + ">" + m[16] + "</td><td>" + zero(m[16], m[54]) + "</td><td>" + zero(m[16], z[0]) + "</td><td>" + m[17] + "</td><td>" + zero(m[17], m[55]) + "</td><td>" + zero(m[17], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'for'</th><td>" + m[18] + "</td><td>" + zero(m[18], m[54]) + "</td><td>" + zero(m[18], z[0]) + "</td><td>" + m[19] + "</td><td>" + zero(m[19], m[55]) + "</td><td>" + zero(m[19], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'function'</th><td>" + m[20] + "</td><td>" + zero(m[20], m[54]) + "</td><td>" + zero(m[20], z[0]) + "</td><td>" + m[21] + "</td><td>" + zero(m[21], m[55]) + "</td><td>" + zero(m[21], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'if'</th><td>" + m[22] + "</td><td>" + zero(m[22], m[54]) + "</td><td>" + zero(m[22], z[0]) + "</td><td>" + m[23] + "</td><td>" + zero(m[23], m[55]) + "</td><td>" + zero(m[23], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'in'</th><td>" + m[24] + "</td><td>" + zero(m[24], m[54]) + "</td><td>" + zero(m[24], z[0]) + "</td><td>" + m[25] + "</td><td>" + zero(m[25], m[55]) + "</td><td>" + zero(m[25], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'label'</th><td>" + m[26] + "</td><td>" + zero(m[26], m[54]) + "</td><td>" + zero(m[26], z[0]) + "</td><td>" + m[27] + "</td><td>" + zero(m[27], m[55]) + "</td><td>" + zero(m[27], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'new'</th><td>" + m[28] + "</td><td>" + zero(m[28], m[54]) + "</td><td>" + zero(m[28], z[0]) + "</td><td>" + m[29] + "</td><td>" + zero(m[29], m[55]) + "</td><td>" + zero(m[29], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'return'</th><td>" + m[30] + "</td><td>" + zero(m[30], m[54]) + "</td><td>" + zero(m[30], z[0]) + "</td><td>" + m[31] + "</td><td>" + zero(m[31], m[55]) + "</td><td>" + zero(m[31], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'switch'</th><td>" + m[32] + "</td><td>" + zero(m[32], m[54]) + "</td><td>" + zero(m[32], z[0]) + "</td><td>" + m[33] + "</td><td>" + zero(m[33], m[55]) + "</td><td>" + zero(m[33], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'this'</th><td>" + m[34] + "</td><td>" + zero(m[34], m[54]) + "</td><td>" + zero(m[34], z[0]) + "</td><td>" + m[35] + "</td><td>" + zero(m[35], m[55]) + "</td><td>" + zero(m[35], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'throw'</th><td>" + m[50] + "</td><td>" + zero(m[50], m[54]) + "</td><td>" + zero(m[50], z[0]) + "</td><td>" + m[51] + "</td><td>" + zero(m[51], m[55]) + "</td><td>" + zero(m[51], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'typeof'</th><td>" + m[36] + "</td><td>" + zero(m[36], m[54]) + "</td><td>" + zero(m[36], z[0]) + "</td><td>" + m[37] + "</td><td>" + zero(m[37], m[55]) + "</td><td>" + zero(m[37], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'var'</th><td>" + m[38] + "</td><td>" + zero(m[38], m[54]) + "</td><td>" + zero(m[38], z[0]) + "</td><td>" + m[39] + "</td><td>" + zero(m[39], m[55]) + "</td><td>" + zero(m[39], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'while'</th><td>" + m[40] + "</td><td>" + zero(m[40], m[54]) + "</td><td>" + zero(m[40], z[0]) + "</td><td>" + m[41] + "</td><td>" + zero(m[41], m[55]) + "</td><td>" + zero(m[41], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'with'</th><td" + q[3] + ">" + m[42] + "</td><td>" + zero(m[42], m[54]) + "</td><td>" + zero(m[42], z[0]) + "</td><td>" + m[43] + "</td><td>" + zero(m[43], m[55]) + "</td><td>" + zero(m[43], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'window'</th><td>" + m[46] + "</td><td>" + zero(m[46], m[54]) + "</td><td>" + zero(m[46], z[0]) + "</td><td>" + m[47] + "</td><td>" + zero(m[47], m[55]) + "</td><td>" + zero(m[47], z[1]) + "</td></tr>");
                output.push("<tr><th>Keyword 'try'</th><td>" + m[52] + "</td><td>" + zero(m[52], m[54]) + "</td><td>" + zero(m[52], z[0]) + "</td><td>" + m[53] + "</td><td>" + zero(m[53], m[55]) + "</td><td>" + zero(m[53], z[1]) + "</td></tr>");
                output.push("<tr><th>Total Keywords</th><td>" + m[54] + "</td><td>100.00%</td><td>" + zero(m[55], z[0]) + "</td><td>" + m[55] + "</td><td>100.00%</td><td>" + zero(m[55], z[1]) + "</td></tr>");
                output.push("<tr><th colspan='7'>Variables and Other Keywords</th></tr>");
                output.push("<tr><th>Variable Instances</th><td>" + o[0] + "</td><td>100.00%</td><td>" + zero(o[0], z[0]) + "</td><td>" + o[1] + "</td><td>100.00%</td><td>" + zero(o[1], z[1]) + "</td></tr>");
                output.push("</tbody></table></div>");
                return output.join('');
            };
            return rvalue;
        },
        markupmin = function (x, comments, presume_html) {
            var i,
                a,
                b,
                c,
                y,
                Y,
                verbose = (/^\s+$/),
                white = (/\s/),
                html = ["br", "meta", "link", "img", "hr", "base", "basefont", "area", "col", "frame", "input", "param"],
                markupspace = function () {
                    var d = '';
                    Y = x.length;
                    for (a = i; a < Y; a += 1) {
                        if (x[a] === ">") {
                            break;
                        } else {
                            d = d + x[a];
                            x[a] = '';
                        }
                    }
                    d = d.replace(/\s+/g, " ").replace(/\s*,\s+/g, ", ").replace(/\s*\/\s*/g, "/").replace(/\s*\.\s*/g, ".").replace(/\s*=\s*/g, "=").replace(/\s*:\s*/g, ":").replace(/ \="/g, '="').replace(/ \='/g, "='") + ">";
                    i = a;
                    x[i] = d;
                },
                markupcomment = function () {
                    c = '';
                    Y = x.length;
                    for (b = i; b < Y; b += 1) {
                        if (x[b] === "-" && x[b + 1] === "-" && x[b + 2] === ">") {
                            x[b] = "";
                            x[b + 1] = "";
                            x[b + 2] = "";
                            i = b + 2;
                            break;
                        } else if (comments !== "comments" && comments !== "beautify") {
                            x[b] = "";
                        } else {
                            c = c + x[b];
                            x[b] = "";
                        }
                    }
                    if (comments === "comments" || comments === "beautify") {
                        c = " " + c + "-->";
                        x[i] = c;
                    }
                },
                markupscript = function (z) {
                    if (jsmin === undefined) {
                        return;
                    }
                    var e = [],
                        f,
                        h = '',
                        j = "</" + z,
                        m;
                    Y = x.length;
                    for (c = i; c < Y; c += 1) {
                        if ((y.slice(c, c + j.length)).toLowerCase() === j) {
                            f = c;
                            break;
                        }
                    }
                    for (c = i; c < f; c += 1) {
                        if (x[c - 1] !== ">") {
                            e.push(x[c]);
                            x[c] = "";
                        } else {
                            break;
                        }
                    }
                    m = e[0];
                    e.splice(0, 1);
                    if (white.test(e[0])) {
                        e.splice(0, 1);
                    }
                    for (; f < Y; f += 1) {
                        if (x[f] !== ">") {
                            h = h + x[f];
                            x[f] = '';
                        } else {
                            break;
                        }
                    }
                    h = h + ">";
                    i = f;
                    if (e.join('') === "") {
                        x[i] = m + h;
                        return;
                    }
                    e = e.join('');
                    if (comments !== "beautify") {
                        if (z === "style") {
                            e = jsmin('', e, 3, 'css', true);
                        } else {
                            e = jsmin('', e.replace(/^(\s*<\!\-\-)/, "").replace(/(\-\->\s*)$/, ""), 3, 'javascript', false);
                        }
                    }
                    Y = e.length;
                    for (c = 0; c < Y; c += 1) {
                        if (white.test(e.charAt(c))) {
                            e = e.substr(c + 1);
                        } else {
                            break;
                        }
                    }
                    x[i] = m + e + h;
                },
                preserve = function (end) {
                    b = '';
                    Y = x.length;
                    for (c = i; c < Y; c += 1) {
                        if (x[c - 1] + x[c] === end) {
                            break;
                        }
                    }
                    for (a = i; a < c; a += 1) {
                        b += x[a];
                        x[a] = '';
                    }
                    x[i] = b;
                    i = c;
                },
                content = function () {
                    b = '';
                    Y = x.length;
                    for (a = i; a < Y; a += 1) {
                        if (x[a] === "<") {
                            break;
                        } else {
                            b = b + x[a];
                            x[a] = '';
                        }
                    }
                    i = a - 1;
                    x[i] = b.replace(/\s+/g, " ");
                },
                it = (function () {
                    y = x;
                    x = x.split('');
                    for (i = 0; i < x.length; i += 1) {
                        if ((y.slice(i, i + 7)).toLowerCase() === "<script") {
                            if (comments !== "beautify" && comments !== "diff") {
                                markupspace();
                            }
                            markupscript("script");
                        } else if ((y.slice(i, i + 6)).toLowerCase() === "<style") {
                            if (comments !== "beautify" && comments !== "diff") {
                                markupspace();
                            }
                            markupscript("style");
                        } else if (y.slice(i, i + 4) === "<!--" && x[i + 4] !== "#") {
                            markupcomment();
                        } else if (y.slice(i, i + 5) === "<?php") {
                            preserve("?>");
                        } else if (y.slice(i, i + 2) === "<%") {
                            preserve("%>");
                        } else if ((x[i] === "<" && x[i + 1] !== "!") || (x[i] === "<" && x[i + 1] === "!" && x[i + 2] !== "-")) {
                            markupspace();
                        } else if (x[i] === undefined) {
                            x[i] = "";
                        } else if (x[i - 1] !== undefined && x[i - 1].charAt(x[i - 1].length - 1) === ">") {
                            content();
                        }
                    }
                }());
            i = [];
            Y = x.length;
            for (a = 0; a < Y; a += 1) {
                if (x[a] !== "") {
                    i.push(x[a]);
                }
            }
            x = [];
            Y = i.length;
            for (a = 0; a < Y; a += 1) {
                if (!verbose.test(i[a]) || (verbose.test(i[a]) && !verbose.test(i[a + 1]))) {
                    x.push(i[a]);
                }
            }
            Y = x.length;
            for (a = 2; a < Y; a += 1) {
                c = 0;
                if (presume_html === true) {
                    b = "";
                    for (i = 1; i < x[a].length; i += 1) {
                        if (/[a-z]/i.test(x[a].charAt(i))) {
                            b += x[a].charAt(i);
                        } else {
                            break;
                        }
                    }
                    for (i = 0; i < html.length; i += 1) {
                        if (b === html[i] && x[a].charAt(0) === "<") {
                            c = 1;
                            break;
                        }
                    }
                }
                if (verbose.test(x[a - 1])) {
                    if (c !== 1 && (x[a].charAt(0) === "<" && x[a].charAt(1) === "/" && x[a - 1] !== " " && x[a - 2].charAt(0) === "<" && x[a - 2].charAt(1) === "/" && x[a - 3].charAt(0) !== "<") && (x[a].charAt(0) === "<" && x[a].charAt(x[a].length - 2) !== "/") && (x[a].charAt(0) === "<" && x[a].charAt(x[a].length - 2) !== "/" && x[a - 2].charAt(0) === "<" && x[a - 2].charAt(1) === "/")) {
                        x[a - 1] = "";
                    }
                }
            }
            x = x.join('').replace(/-->\s+/g, '-->').replace(/\s+<\?php/g, ' <?php').replace(/\s+<%/g, ' <%').replace(/\s*>\s+/g, '> ').replace(/\s+<\s*/g, ' <').replace(/\s+\/>/g, '/>').replace(/\s+>/g, ">");
            if (white.test(x.charAt(0))) {
                x = x.slice(1, x.length);
            }
            return x;
        },
        markup_beauty = function (source, indent_size, indent_character, mode, indent_comment, indent_script, presume_html, ignore_content) {
            var i,
                Z,
                tab = '',
                token = [],
                build = [],
                cinfo = [],
                level = [],
                inner = [],
                summary = [],
                x = source,
                loop,
                innerset = (function () {
                    var a,
                        b,
                        e,
                        f,
                        g,
                        j,
                        l,
                        m,
                        n,
                        o,
                        p,
                        h = -1,
                        i = 0,
                        k = -1,
                        c = source.length,
                        d = [];
                    for (a = 0; a < c; a += 1) {
                        if (x.substr(a, 7).toLowerCase() === "<script") {
                            for (b = a + 7; b < c; b += 1) {
                                if (x.charAt(b) + x.charAt(b + 1) + x.charAt(b + 2).toLowerCase() + x.charAt(b + 3).toLowerCase() + x.charAt(b + 4).toLowerCase() + x.charAt(b + 5).toLowerCase() + x.charAt(b + 6).toLowerCase() + x.charAt(b + 7).toLowerCase() + x.charAt(b + 8) === "</script>") {
                                    a = b + 8;
                                    h += 1;
                                    break;
                                }
                            }
                        } else if (x.substr(a, 6).toLowerCase() === "<style") {
                            for (b = a + 6; b < c; b += 1) {
                                if (x.charAt(b) + x.charAt(b + 1) + x.charAt(b + 2).toLowerCase() + x.charAt(b + 3).toLowerCase() + x.charAt(b + 4).toLowerCase() + x.charAt(b + 5).toLowerCase() + x.charAt(b + 6).toLowerCase() + x.charAt(b + 7) === "</style>") {
                                    a = b + 7;
                                    h += 1;
                                    break;
                                }
                            }
                        } else if (x.substr(a, 5) === "<?php") {
                            for (b = a + 5; b < c; b += 1) {
                                if (x.charAt(b - 1) === "?" && x.charAt(b) === ">") {
                                    a = b;
                                    h += 1;
                                    break;
                                }
                            }
                        } else if (x.charAt(a) === "<" && x.charAt(a + 1) === "%") {
                            for (b = a + 5; b < c; b += 1) {
                                if (x.charAt(b - 1) === "%" && x.charAt(b) === ">") {
                                    a = b;
                                    h += 1;
                                    break;
                                }
                            }
                        } else if (x.charAt(a) === x.charAt(a + 1) && (x.charAt(a) === "\"" || x.charAt(a) === "'")) {
                            a += 1;
                        } else if (x.charAt(a - 1) === "=" && (x.charAt(a) === "\"" || x.charAt(a) === "'")) {
                            o = -1;
                            for (m = a - 1; m > 0; m -= 1) {
                                if ((x.charAt(m) === "\"" && x.charAt(a) === "\"") || (x.charAt(m) === "'" && x.charAt(a) === "'") || x.charAt(m) === "<") {
                                    break;
                                } else if (x.charAt(m) === ">") {
                                    o = m;
                                    break;
                                }
                            }
                            if (o === -1) {
                                n = 0;
                                for (b = a + 1; b < c; b += 1) {
                                    if (x.substr(b, 7).toLowerCase() === "<script") {
                                        for (p = b + 7; p < c; p += 1) {
                                            if (x.charAt(p) + x.charAt(p + 1) + x.charAt(p + 2).toLowerCase() + x.charAt(p + 3).toLowerCase() + x.charAt(p + 4).toLowerCase() + x.charAt(p + 5).toLowerCase() + x.charAt(p + 6).toLowerCase() + x.charAt(p + 7).toLowerCase() + x.charAt(p + 8) === "</script>") {
                                                b = p + 8;
                                                break;
                                            }
                                        }
                                    } else if (x.substr(b, 6).toLowerCase() === "<style") {
                                        for (p = b + 6; p < c; p += 1) {
                                            if (x.charAt(p) + x.charAt(p + 1) + x.charAt(p + 2).toLowerCase() + x.charAt(p + 3).toLowerCase() + x.charAt(p + 4).toLowerCase() + x.charAt(p + 5).toLowerCase() + x.charAt(p + 6).toLowerCase() + x.charAt(p + 7) === "</style>") {
                                                b = p + 7;
                                                break;
                                            }
                                        }
                                    } else if (x.substr(b, 5) === "<?php") {
                                        for (p = b + 5; p < c; p += 1) {
                                            if (x.charAt(p - 1) === "?" && x.charAt(p) === ">") {
                                                b = p;
                                                break;
                                            }
                                        }
                                    } else if (x.charAt(b) === "<" && x.charAt(b + 1) === "%") {
                                        for (p = b + 5; p < c; p += 1) {
                                            if (x.charAt(p - 1) === "%" && x.charAt(p) === ">") {
                                                b = p;
                                                break;
                                            }
                                        }
                                    } else if (x.charAt(b) === ">" || x.charAt(b) === "<") {
                                        n = 1;
                                    } else if ((x.charAt(b - 1) !== "\\" && ((x.charAt(a) === "\"" && x.charAt(b) === "\"") || (x.charAt(a) === "'" && x.charAt(b) === "'"))) || b === c - 1) {
                                        if (k !== h && l === 1) {
                                            l = 0;
                                            h -= 1;
                                            k -= 1;
                                        } else if (k === h) {
                                            for (e = i + 1; e > a; e += 1) {
                                                if (!/\s/.test(x.charAt(e))) {
                                                    break;
                                                }
                                            }
                                            j = e;
                                            if (i < a && l !== 1) {
                                                l = 1;
                                                h += 1;
                                                k += 1;
                                            }
                                        }
                                        if (n === 1) {
                                            d.push([a, b, h, j]);
                                        }
                                        a = b;
                                        break;
                                    }
                                }
                            }
                        } else if (x.charAt(a) === "<") {
                            if (x.charAt(a + 1) === "!" && x.charAt(a + 2) === "-" && x.charAt(a + 3) === "-") {
                                for (b = a + 4; b < x.length; b += 1) {
                                    if (x.charAt(b) === "-" && x.charAt(b + 1) === "-" && x.charAt(b + 2) === ">") {
                                        break;
                                    }
                                }
                                h += 1;
                                a = b + 2;
                            } else {
                                h += 1;
                                j = a;
                            }
                        } else if (x.charAt(a + 1) === "<" && x.charAt(a) !== ">") {
                            for (b = a; b > 0; b -= 1) {
                                if (!/\s/.test(x.charAt(b)) && x.charAt(b) !== ">") {
                                    h += 1;
                                    k += 1;
                                    j = a;
                                    break;
                                } else if (x.charAt(b) === ">") {
                                    if (h !== k) {
                                        k += 1;
                                        i = a;
                                    }
                                    break;
                                }
                            }
                        } else if (x.charAt(a) === ">") {
                            k += 1;
                            i = a;
                        }
                    }
                    c = d.length;
                    x = x.split('');
                    for (a = 0; a < c; a += 1) {
                        i = d[a][0] + 1;
                        f = d[a][1];
                        g = d[a][2];
                        j = d[a][3];
                        for (e = i; e < f; e += 1) {
                            h = 0;
                            if (x[e] === "<") {
                                x[e] = "[";
                                for (b = e; b > j; b -= 1) {
                                    h += 1;
                                    if (/\s/.test(x[b])) {
                                        for (k = b - 1; k > j; k -= 1) {
                                            if (!/\s/.test(x[k])) {
                                                if (x[k] !== "=") {
                                                    h += 1;
                                                } else if (/\s/.test(x[k - 1])) {
                                                    h -= 1;
                                                }
                                                b = k;
                                                break;
                                            }
                                        }
                                    }
                                }
                                if (/\s/.test(x[i])) {
                                    h -= 1;
                                }
                                inner.push(["<", h, g]);
                            } else if (x[e] === ">") {
                                x[e] = "]";
                                for (b = e; b > j; b -= 1) {
                                    h += 1;
                                    if (/\s/.test(x[b])) {
                                        for (k = b - 1; k > j; k -= 1) {
                                            if (!/\s/.test(x[k])) {
                                                if (x[k] !== "=") {
                                                    h += 1;
                                                } else if (/\s/.test(x[k - 1])) {
                                                    h -= 1;
                                                }
                                                b = k;
                                                break;
                                            }
                                        }
                                    }
                                }
                                if (/\s/.test(x[i])) {
                                    h -= 1;
                                }
                                inner.push([">", h, g]);
                            }
                        }
                    }
                    x = x.join('');
                }()),
                elements = (function () {
                    var q,
                        a,
                        b = function (end) {
                            var d,
                                e,
                                f = '',
                                c = i,
                                z = end.charAt(end.length - 2),
                                y = end.split('').reverse(),
                                g = function () {
                                    for (; c < loop; c += 1) {
                                        if (z !== "-" && z !== "?" && z !== "%" && x[c] === ">") {
                                            break;
                                        } else if (x[c - 1] + x[c] === z + ">") {
                                            break;
                                        }
                                    }
                                    Z = y.length;
                                    for (d = 0; d < Z; d += 1) {
                                        if (x[c - d] !== y[d]) {
                                            e = false;
                                            c += 1;
                                            break;
                                        }
                                        e = true;
                                    }
                                };
                            g();
                            if (e !== true) {
                                do {
                                    g();
                                } while (e !== true);
                            } else if (e === true) {
                                Z = c + 1;
                                for (d = i; d < Z; d += 1) {
                                    f = f + x[d];
                                }
                            }
                            if (x[i - 2] === ">" && x[i - 1] === " ") {
                                f = " " + f;
                            }
                            i = c - 1;
                            return f;
                        },
                        cgather = function (z) {
                            var c,
                                d = '';
                            q = "";
                            for (c = i; c < loop; c += 1) {
                                if (q === "" && x[c - 1] !== "\\" && (x[c] === "'" || x[c] === "\"")) {
                                    q = x[c];
                                } else if (x[c - 1] !== "\\" && ((q === "'" && x[c] === "'") || (q === "\"" && x[c] === "\""))) {
                                    q = "";
                                }
                                if (((z === "script" && q === "") || z === "style") && x[c] === "<" && x[c + 1] === "/" && x[c + 2].toLowerCase() === "s") {
                                    if (z === "script" && (x[c + 3].toLowerCase() === "c" && x[c + 4].toLowerCase() === "r" && x[c + 5].toLowerCase() === "i" && x[c + 6].toLowerCase() === "p" && x[c + 7].toLowerCase() === "t")) {
                                        break;
                                    } else if (z === "style" && (x[c + 3].toLowerCase() === "t" && x[c + 4].toLowerCase() === "y" && x[c + 5].toLowerCase() === "l" && x[c + 6].toLowerCase() === "e")) {
                                        break;
                                    }
                                } else if (z === "other" && x[c] === "<") {
                                    break;
                                } else {
                                    d = d + x[c];
                                }
                            }
                            i = c - 1;
                            if (ignore_content === true) {
                                if (d.charAt(0) === " " && d.charAt(d.length - 1) === " ") {
                                    d = " text ";
                                } else if (d.charAt(0) === " ") {
                                    d = " text";
                                } else if (d.charAt(d.length - 1) === " ") {
                                    d = "text ";
                                } else {
                                    d = "text";
                                }
                            }
                            return d;
                        },
                        type_define = (function () {
                            x = markupmin(x, mode, presume_html).split('');
                            loop = x.length;
                            for (i = 0; i < loop; i += 1) {
                                if (x[i] === "<" && x[i + 1] === "!" && x[i + 2] === "-" && x[i + 3] === "-" && x[i + 4] !== "#") {
                                    build.push(b('-->'));
                                    token.push("T_comment");
                                } else if (x[i] === "<" && x[i + 1] === "!" && x[i + 2] === "-" && x[i + 3] === "-" && x[i + 4] === "#") {
                                    build.push(b('-->'));
                                    token.push("T_ssi");
                                } else if (x[i] === "<" && x[i + 1] === "!" && x[i + 2] !== "-") {
                                    build.push(b('>'));
                                    token.push("T_sgml");
                                } else if (x[i] === "<" && x[i + 1] === "?" && x[i + 2].toLowerCase() === "x" && x[i + 3].toLowerCase() === "m" && x[i + 4].toLowerCase() === "l") {
                                    build.push(b('?>'));
                                    token.push("T_xml");
                                } else if (x[i] === "<" && x[i + 1] === "?" && x[i + 2].toLowerCase() === "p" && x[i + 3].toLowerCase() === "h" && x[i + 4].toLowerCase() === "p") {
                                    build.push(b('?>'));
                                    token.push("T_php");
                                } else if (x[i] === "<" && x[i + 1].toLowerCase() === "s" && x[i + 2].toLowerCase() === "c" && x[i + 3].toLowerCase() === "r" && x[i + 4].toLowerCase() === "i" && x[i + 5].toLowerCase() === "p" && x[i + 6].toLowerCase() === "t") {
                                    build.push(b('>'));
                                    token.push("T_script");
                                } else if (x[i] === "<" && x[i + 1].toLowerCase() === "s" && x[i + 2].toLowerCase() === "t" && x[i + 3].toLowerCase() === "y" && x[i + 4].toLowerCase() === "l" && x[i + 5].toLowerCase() === "e") {
                                    build.push(b('>'));
                                    token.push("T_style");
                                } else if (x[i] === "<" && x[i + 1] === "%") {
                                    build.push(b('%>'));
                                    token.push("T_asp");
                                } else if (x[i] === "<" && x[i + 1] === "/") {
                                    build.push(b('>'));
                                    token.push("T_tag_end");
                                } else if (x[i] === "<" && (x[i + 1] !== "!" || x[i + 1] !== "?" || x[i + 1] !== "/" || x[i + 1] !== "%")) {
                                    for (a = i; a < loop; a += 1) {
                                        if (x[a] === "/" && x[a + 1] === ">") {
                                            build.push(b('/>'));
                                            token.push("T_singleton");
                                            break;
                                        } else if (x[a] !== "/" && x[a + 1] === ">") {
                                            build.push(b('>'));
                                            token.push("T_tag_start");
                                            break;
                                        }
                                    }
                                } else if (x[i - 1] === ">" && (x[i] !== "<" || (x[i] !== " " && x[i + 1] !== "<"))) {
                                    if (token[token.length - 1] === "T_script") {
                                        build.push(cgather("script"));
                                        token.push("T_content");
                                    } else if (token[token.length - 1] === "T_style") {
                                        build.push(cgather("style"));
                                        token.push("T_content");
                                    } else if (x[i - 1] + x[i] + x[i + 1] !== "> <") {
                                        build.push(cgather("other"));
                                        token.push("T_content");
                                    }
                                }
                            }
                        }());
                    summary = summary.concat(build);
                }()),
                code_type = (function () {
                    Z = token.length;
                    for (i = 0; i < Z; i += 1) {
                        if (token[i] === "T_sgml" || token[i] === "T_xml") {
                            cinfo.push("parse");
                        } else if (token[i] === "T_asp" || token[i] === "T_php" || token[i] === "T_ssi") {
                            cinfo.push("singleton");
                        } else if (token[i] === "T_comment") {
                            cinfo.push("comment");
                        } else if ((token[i] === "T_content" && build[i] !== " ") && token[i - 1] === "T_script") {
                            cinfo.push("external");
                        } else if (token[i] === "T_content" && token[i - 1] === "T_style") {
                            cinfo.push("external");
                        } else if (token[i] === "T_content" && build[i].charAt(0) === " " && build[i].charAt(build[i].length - 1) === " ") {
                            cinfo.push("mixed_both");
                        } else if (token[i] === "T_content" && build[i].charAt(0) === " " && build[i].charAt(build[i].length - 1) !== " ") {
                            cinfo.push("mixed_start");
                        } else if (token[i] === "T_content" && build[i].charAt(0) !== " " && build[i].charAt(build[i].length - 1) === " ") {
                            cinfo.push("mixed_end");
                        } else if (token[i] === "T_content") {
                            cinfo.push("content");
                        } else if (token[i] === "T_tag_start") {
                            cinfo.push("start");
                        } else if (token[i] === "T_style") {
                            build[i] = build[i].replace(/\s+/g, " ");
                            cinfo.push("start");
                        } else if (token[i] === "T_script") {
                            build[i] = build[i].replace(/\s+/g, " ");
                            cinfo.push("start");
                        } else if (token[i] === "T_singleton") {
                            cinfo.push("singleton");
                        } else if (token[i] === "T_tag_end") {
                            cinfo.push("end");
                        }
                    }
                }()),
                tab_check = (function () {
                    var a;
                    indent_size = Number(indent_size);
                    if (indent_size !== Number(indent_size)) {
                        indent_size = 4;
                    }
                    Z = indent_size;
                    for (a = 0; a < Z; a += 1) {
                        tab += indent_character;
                    }
                    return tab;
                }()),
                cheat = (function () {
                    if (presume_html !== true) {
                        return;
                    }
                    var a,
                        b;
                    loop = cinfo.length;
                    for (i = 0; i < loop; i += 1) {
                        if (cinfo[i] === "start") {
                            a = build[i].indexOf(" ");
                            if (build[i].length === 3) {
                                b = build[i].charAt(1).toLowerCase();
                            } else if (a === -1) {
                                b = build[i].slice(1, cinfo[i].length - 2).toLowerCase();
                            } else if (a === 0) {
                                b = build[i].slice(1, build[i].length);
                                a = b.indexOf(" ");
                                b = b.slice(1, a).toLowerCase();
                            } else {
                                b = build[i].slice(1, a).toLowerCase();
                            }
                            if (b === "br" || b === "meta" || b === "link" || b === "img" || b === "hr" || b === "base" || b === "basefont" || b === "area" || b === "col" || b === "frame" || b === "input" || b === "param") {
                                cinfo[i] = "singleton";
                                token[i] = "T_singleton";
                            }
                        }
                    }
                }()),
                tab_level = (function () {
                    loop = cinfo.length;
                    var a,
                        c = function (x) {
                            var k,
                                m = 0;
                            if (x === "start") {
                                m += 1;
                            }
                            for (k = i - 1; k > -1; k -= 1) {
                                if (cinfo[k] === "start" && level[k] === "x") {
                                    m += 1;
                                } else if (cinfo[k] === "end") {
                                    m -= 1;
                                } else if (cinfo[k] === "start" && level[k] !== "x") {
                                    return level.push(level[k] + m);
                                } else if (k === 0) {
                                    if (cinfo[k] !== "start") {
                                        return level.push(0);
                                    } else if (cinfo[i] === "mixed_start" || cinfo[i] === "content" || (cinfo[i] === "singleton" && build[i].charAt(0) !== " ")) {
                                        return level.push("x");
                                    } else {
                                        return level.push(1);
                                    }
                                }
                            }
                        },
                        e = function () {
                            var yy = 1,
                                z = function (y) {
                                    for (; y > 0; y -= 1) {
                                        if (level[y] !== "x") {
                                            return level.push(level[y] + 1);
                                        }
                                    }
                                },
                                w = function () {
                                    var k,
                                        q,
                                        y = i - 1,
                                        u = function () {
                                            var t = function () {
                                                var s,
                                                    l = 0;
                                                for (s = i - 1; s > 0; s -= 1) {
                                                    if ((cinfo[s] === "start" && cinfo[s + 1] === "start" && level[s] === level[s + 1] - 1) || (cinfo[s] === "start" && cinfo[s - 1] !== "start" && level[s] === level[s - 1])) {
                                                        break;
                                                    }
                                                }
                                                for (k = s + 1; k < i; k += 1) {
                                                    if (cinfo[k] === "mixed_start" && cinfo[k + 1] === "end") {
                                                        l += 1;
                                                    }
                                                }
                                                if (cinfo[s - 1] === "end" && level[s - 1] !== "x" && l === 0) {
                                                    l += 1;
                                                }
                                                if (l !== 0) {
                                                    if (level[i - 1] === "x") {
                                                        return l - 1;
                                                    } else {
                                                        return l;
                                                    }
                                                } else {
                                                    for (; s < i; s += 1) {
                                                        if (cinfo[s] === "start") {
                                                            l += 1;
                                                        } else if (cinfo[s] === "end") {
                                                            l -= 1;
                                                        }
                                                    }
                                                    return l;
                                                }
                                            };
                                            for (; y > 0; y -= 1) {
                                                if (cinfo[y] !== "mixed_end" || (cinfo[y] === "start" && level[y] !== "x")) {
                                                    if (cinfo[y - 1] === "end") {
                                                        q = "r";
                                                        if (cinfo[i - 1] === "mixed_both" && level[i - 1] === level[y] - t()) {
                                                            return level.push(level[y] - (t() + 1));
                                                        } else if (cinfo[i - 2] === "start" && (cinfo[i - 1] === "mixed_end" || cinfo[i - 1] === "mixed_both")) {
                                                            return level.push(level[y]);
                                                        } else if (level[y] !== "x") {
                                                            if (cinfo[y] === "mixed_both" && y !== i - t()) {
                                                                if (y === i - 1) {
                                                                    return level.push(level[y] - 1);
                                                                } else {
                                                                    return level.push(level[y] + t());
                                                                }
                                                            } else if (cinfo[i - 1] === "mixed_end" && t() === 0) {
                                                                return level.push(level[y] - 1);
                                                            } else {
                                                                return level.push(level[y] - t());
                                                            }
                                                        }
                                                    } else {
                                                        q = y;
                                                        return;
                                                    }
                                                }
                                            }
                                        },
                                        r = function () {
                                            var l = 0;
                                            for (k = i; k > 0; k -= 1) {
                                                if (cinfo[k] === "end") {
                                                    l += 1;
                                                } else if (cinfo[k] === "start") {
                                                    l -= 1;
                                                }
                                                if (l === 0) {
                                                    return k;
                                                }
                                            }
                                        };
                                    if (cinfo[i - 1] === "end" && level[i - 1] !== "x") {
                                        if (cinfo[i - 2] === "start" && level[i - 2] === "x") {
                                            for (k = i - 2; k > 0; k -= 1) {
                                                if (level[k] !== "x") {
                                                    break;
                                                }
                                            }
                                            if (cinfo[k] === "start") {
                                                return c("end");
                                            } else {
                                                return level.push(level[k] - 1);
                                            }
                                        } else if (cinfo[i - 2] === "start" && level[i - 2] !== "x") {
                                            return level.push(level[i - 2] - 1);
                                        } else {
                                            return level.push(level[i - 1] - 1);
                                        }
                                    } else {
                                        u();
                                        if (q === "r") {
                                            return;
                                        } else {
                                            y = 0;
                                            for (q = r(); q > 0; q -= 1) {
                                                if (cinfo[q] === "start") {
                                                    y += 1;
                                                } else if (cinfo[q] === "end") {
                                                    y -= 1;
                                                }
                                                if (level[q] !== "x") {
                                                    if (cinfo[q] === "end" && cinfo[q - 1] === "start" && level[q - 1] !== "x") {
                                                        return level.push(level[q]);
                                                    } else if (level[i - 1] === "x" && build[i].charAt(0) !== " " && cinfo[i - 1] !== "mixed_end" && (cinfo[i - 2] !== "end" || level[i - 2] !== "x") && (cinfo[i - 3] !== "end" || level[i - 3] !== "x")) {
                                                        return level.push("x");
                                                    } else {
                                                        return level.push(level[q] + (y - 1));
                                                    }
                                                }
                                            }
                                            y = 0;
                                            for (q = i; q > -1; q -= 1) {
                                                if (cinfo[q] === "start") {
                                                    y += 1;
                                                } else if (cinfo[q] === "end") {
                                                    y -= 1;
                                                }
                                            }
                                            return level.push(y);
                                        }
                                    }
                                };
                            if (cinfo[i - 1] === "end" || cinfo[i - 1] === "mixed_both" || cinfo[i - 1] === "mixed_end") {
                                return w();
                            } else if (cinfo[i - 1] === "mixed_start" || cinfo[i - 1] === "content") {
                                return level.push("x");
                            } else if (cinfo[i - 1] === "external") {
                                yy = -1;
                                for (a = i - 2; a > 0; a -= 1) {
                                    if (cinfo[a] === "start") {
                                        yy += 1;
                                    } else if (cinfo[a] === "end") {
                                        yy -= 1;
                                    }
                                    if (level[a] !== "x") {
                                        break;
                                    }
                                }
                                if (cinfo[a] === "end") {
                                    yy += 1;
                                }
                                return level.push(level[a] + yy);
                            } else if (build[i].charAt(0) !== " ") {
                                if ((cinfo[i - 1] === "singleton" || cinfo[i - 1] === "content") && level[i - 1] === "x") {
                                    return level.push("x");
                                }
                                yy = 0;
                                for (a = i - 1; a > 0; a -= 1) {
                                    if (cinfo[a] === "singleton" && level[a] === "x" && ((cinfo[a - 1] === "singleton" && level[a - 1] !== "x") || cinfo[a - 1] !== "singleton")) {
                                        yy += 1;
                                    }
                                    if (level[a] !== 0 && level[a] !== "x" && cinfo[i - 1] !== "start") {
                                        if (cinfo[a] === "mixed_both" || cinfo[a] === "mixed_start") {
                                            return level.push(level[a] - yy);
                                        } else if (level[a] === yy || (cinfo[a] === "singleton" && (cinfo[a - 1] === "content" || cinfo[a - 1] === "mixed_start"))) {
                                            return level.push(level[a]);
                                        } else {
                                            return level.push(level[a] - 1);
                                        }
                                    } else if (cinfo[a] === "start" && level[a] === "x") {
                                        return z(a);
                                    } else if (cinfo[i - 1] === "start") {
                                        return level.push(level[a]);
                                    }
                                }
                                return level.push(0);
                            } else {
                                return c("end");
                            }
                        },
                        f = function (z) {
                            var k,
                                l,
                                m,
                                n = (function () {
                                    var j;
                                    if (z === 1) {
                                        k = 0;
                                        l = 0;
                                        m = 0;
                                    } else {
                                        for (j = z - 1; j > 0; j -= 1) {
                                            if (cinfo[j] !== "comment") {
                                                k = j;
                                                break;
                                            }
                                        }
                                        if (k === 1) {
                                            l = 0;
                                            m = 0;
                                        } else {
                                            for (j = k - 1; j > 0; j -= 1) {
                                                if (cinfo[j] !== "comment") {
                                                    l = j;
                                                    break;
                                                }
                                            }
                                            if (l === 1) {
                                                m = 0;
                                            } else {
                                                for (j = l - 1; j > 0; j -= 1) {
                                                    if (cinfo[j] !== "comment") {
                                                        m = j;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }()),
                                p = function () {
                                    var j,
                                        v = 1,
                                        u = -1;
                                    for (j = k; j > 0; j -= 1) {
                                        if (cinfo[j] === "start") {
                                            u -= 1;
                                            if (level[j] === "x") {
                                                v += 1;
                                            }
                                        } else if (cinfo[j] === "end") {
                                            u += 1;
                                            v -= 1;
                                        }
                                        if (level[j] === 0) {
                                            k = 0;
                                            for (l = i - 1; l > j; l -= 1) {
                                                if (cinfo[l] === "start") {
                                                    k += 1;
                                                } else if (cinfo[l] === "end") {
                                                    k -= 1;
                                                }
                                            }
                                            if (k > 0) {
                                                if (level[j + 1] === "x") {
                                                    return level.push(((u) * -1) - 1);
                                                } else if (cinfo[j] !== "external") {
                                                    return level.push((u + 1) * -1);
                                                }
                                            } else {
                                                for (k = i - 1; k > 0; k -= 1) {
                                                    if (level[k] !== "x") {
                                                        return level.push(level[k]);
                                                    }
                                                }
                                            }
                                        }
                                        if (level[j] !== "x" && level[i - 1] !== "x") {
                                            if (cinfo[j] === "start" || cinfo[j] === "end") {
                                                return level.push(level[j] + v);
                                            } else {
                                                return level.push(level[j] + v - 1);
                                            }
                                        } else if (u === -1 && level[j] === "x") {
                                            break;
                                        } else if (u === 1 && level[j] !== "x" && cinfo[j] !== "mixed_start" && cinfo[j] !== "content") {
                                            if (cinfo[j - 1] === "mixed_end" || (level[i - 1] === "x" && cinfo[i - 1] === "end" && cinfo[j] !== "end")) {
                                                return level.push(level[j] - u - 1);
                                            } else {
                                                return level.push(level[j] - u);
                                            }
                                        } else if (u === 0 && level[j] !== "x") {
                                            return c("start");
                                        }
                                    }
                                    return c("start");
                                };
                            if (i - 1 === 0 && cinfo[0] === "start") {
                                return level.push(1);
                            } else if (cinfo[k] === "mixed_start" || cinfo[k] === "content" || cinfo[i - 1] === "mixed_start" || cinfo[i - 1] === "content" || (cinfo[i] === "singleton" && (cinfo[i - 1] === "start" || cinfo[i - 1] === "singleton") && build[i].charAt(0) !== " ")) {
                                return level.push("x");
                            } else if ((cinfo[i - 1] === "comment" && level[i - 1] === 0) || ((cinfo[m] === "mixed_start" || cinfo[m] === "content") && cinfo[l] === "end" && (cinfo[k] === "mixed_end" || cinfo[k] === "mixed_both"))) {
                                return c("start");
                            } else if (cinfo[i - 1] === "comment" && level[i - 1] !== "x") {
                                return level.push(level[i - 1]);
                            } else if ((cinfo[k] === "start" && level[k] === "x") || (cinfo[k] !== "mixed_end" && cinfo[k] !== "mixed_both" && level[k] === "x")) {
                                if (level[i - 1] === "x" && build[i].charAt(0) !== " " && cinfo[i - 1] !== "start" && build[i - 1].charAt(build[i - 1].length - 1) !== " ") {
                                    if ((cinfo[i - 1] === "end" && cinfo[i - 2] === "end") || (cinfo[i - 1] === "end" && cinfo[i] !== "end" && cinfo[i + 1] !== "mixed_start" && cinfo[i + 1] !== "content")) {
                                        return c("start");
                                    } else {
                                        return level.push("x");
                                    }
                                } else {
                                    return p();
                                }
                            } else if (cinfo[k] === "end" && level[k] !== "x" && (cinfo[k - 1] !== "start" || (cinfo[k - 1] === "start" && level[k - 1] !== "x"))) {
                                if (level[k] < 0) {
                                    return c("start");
                                } else {
                                    return level.push(level[k]);
                                }
                            } else if (cinfo[m] !== "mixed_start" && cinfo[m] !== "content" && (cinfo[k] === "mixed_end" || cinfo[k] === "mixed_both")) {
                                l = 0;
                                p = 0;
                                m = 0;
                                for (a = k; a > 0; a -= 1) {
                                    if (cinfo[a] === "end") {
                                        l += 1;
                                    }
                                    if (cinfo[a] === "start") {
                                        p += 1;
                                    }
                                    if (level[a] === 0 && a !== 0) {
                                        m = a;
                                    }
                                    if (cinfo[k] === "mixed_both" && level[a] !== "x") {
                                        return level.push(level[a]);
                                    } else if (cinfo[a] !== "comment" && cinfo[a] !== "content" && cinfo[a] !== "external" && cinfo[a] !== "mixed_end" && level[a] !== "x") {
                                        if (cinfo[a] === "start" && level[a] !== "x") {
                                            if (cinfo[i - 1] !== "end") {
                                                return level.push(level[a] + (p - l));
                                            } else if ((level[a] === level[a - 1] && cinfo[a - 1] !== "end" && level[a + 1] !== "x") || (cinfo[i - 2] === "start" && level[i - 2] !== "x" && level[i - 1] === "x")) {
                                                return level.push(level[a] + 1);
                                            } else if (p <= 1) {
                                                return level.push(level[a]);
                                            }
                                        } else if (l > 0) {
                                            if (p > 1) {
                                                if (m !== 0) {
                                                    return c("start");
                                                } else {
                                                    return level.push(level[a] + 1);
                                                }
                                            } else {
                                                return level.push(level[a] - l + 1);
                                            }
                                        } else {
                                            return level.push(level[a] + p);
                                        }
                                    }
                                }
                            } else if (cinfo[k] === "start" && level[k] !== "x") {
                                for (a = i - 1; a > -1; a -= 1) {
                                    if (cinfo[a] !== "comment" && cinfo[a] !== "content" && cinfo[a] !== "external" && cinfo[a] !== "mixed_end") {
                                        if (cinfo[i + 1] && build[i].charAt(0) !== " " && (cinfo[i + 1] === "content" || cinfo[i + 1] === "mixed_end")) {
                                            return level.push("x");
                                        } else {
                                            return level.push(level[a] + 1);
                                        }
                                    }
                                }
                                return level.push(0);
                            } else {
                                return c("start");
                            }
                        },
                        h = function () {
                            var z;
                            if (cinfo[i] !== "start" && level[i - 1] === "x" && cinfo[i - 1] !== "content" && build[i].charAt(0) !== " " && cinfo[i - 1] !== "mixed_start" && cinfo[i - 1] !== "mixed_end") {
                                return level.push("x");
                            } else if (cinfo[i] !== "start" && build[i] === " ") {
                                build[i] = "";
                                return level.push("x");
                            } else {
                                if (cinfo[i - 1] !== "comment") {
                                    f(i);
                                } else {
                                    for (z = i - 1; z > 0; z -= 1) {
                                        if (cinfo[z] !== "comment") {
                                            break;
                                        }
                                    }
                                    f(z + 1);
                                }
                            }
                        },
                        innerfix = (function () {
                            var a,
                                b,
                                c,
                                d,
                                e = inner.length;
                            for (a = 0; a < e; a += 1) {
                                b = inner[a][0];
                                c = inner[a][1];
                                d = inner[a][2];
                                if (typeof build[d] !== "undefined") {
                                    if (build[d].charAt(0) === " ") {
                                        c += 1;
                                    }
                                    build[d] = build[d].split('');
                                    if (b === "<" && build[d][c] === "[") {
                                        build[d][c] = "<";
                                    } else if (b === ">" && build[d][c] === "]") {
                                        build[d][c] = ">";
                                    }
                                    build[d] = build[d].join('');
                                }
                            }
                        }()),
                        algorithm = (function () {
                            var test = 0,
                                test1 = 0,
                                scriptStart = (/^(\s*<\!\-\-)/),
                                scriptEnd = (/(\-\->\s*)$/);
                            for (i = 0; i < loop; i += 1) {
                                if (i === 0) {
                                    level.push(0);
                                } else if (cinfo[i] === "comment" && indent_comment !== 'noindent') {
                                    h();
                                } else if (cinfo[i] === "comment" && indent_comment === 'noindent') {
                                    level.push(0);
                                } else if (cinfo[i] === "external") {
                                    level.push(0);
                                    if (token[i - 1] === "T_script") {
                                        if (scriptStart.test(build[i])) {
                                            test = 1;
                                        }
                                        if (scriptEnd.test(build[i])) {
                                            test1 = 1;
                                        }
                                        build[i] = js_beautify(build[i].replace(scriptStart, "").replace(scriptEnd, ""), 4, " ", true, 1, 0, true, false, false, indent_comment);
                                        if (test === 1) {
                                            build[i] = "<!--\n" + build[i];
                                        }
                                        if (test1 === 1) {
                                            build[i] = build[i] + "\n-->";
                                        }
                                        build[i] = build[i].replace(/(\/\/(\s)+\-\->(\s)*)$/, "//-->");
                                    } else if (token[i - 1] === "T_style") {
                                        if (scriptStart.test(build[i])) {
                                            test = 1;
                                        }
                                        if (scriptEnd.test(build[i])) {
                                            test1 = 1;
                                        }
                                        build[i] = cleanCSS(build[i].replace(scriptStart, "").replace(scriptEnd, ""), indent_size, indent_character, true);
                                        if (test === 1) {
                                            build[i] = "<!--\n" + build[i];
                                        }
                                        if (test1 === 1) {
                                            build[i] = build[i] + "\n-->";
                                        }
                                    }
                                } else if (cinfo[i] === "content") {
                                    level.push("x");
                                } else if (cinfo[i] === "parse") {
                                    h();
                                } else if (cinfo[i] === "mixed_both") {
                                    h();
                                } else if (cinfo[i] === "mixed_start") {
                                    h();
                                } else if (cinfo[i] === "mixed_end") {
                                    build[i] = build[i].slice(0, build[i].length - 1);
                                    level.push("x");
                                } else if (cinfo[i] === "start") {
                                    h();
                                } else if (cinfo[i] === "end") {
                                    e();
                                } else if (cinfo[i] === "singleton") {
                                    h();
                                }
                            }
                        }());
                }()),
                write_tabs = (function () {
                    var a,
                        indent = '',
                        tab_math = function (x) {
                            for (a = 0; a < level[i]; a += 1) {
                                indent += tab;
                            }
                            if (cinfo[i] === "mixed_both") {
                                x = x.slice(0, x.length - 1);
                            }
                            x = "\n" + indent + x;
                            indent = '';
                            return x;
                        },
                        end_math = function (x) {
                            var b;
                            if (cinfo[i - 1] !== "start") {
                                for (b = i; b > 0; b -= 1) {
                                    if (level[b] !== "x") {
                                        break;
                                    }
                                }
                                for (a = 1; a < level[b] + 1; a += 1) {
                                    indent += tab;
                                }
                                x = "\n" + indent + x;
                                indent = '';
                            }
                            return x;
                        },
                        script_math = function (x) {
                            var b,
                                c;
                            a = 0;
                            if (level[i - 1] === "x") {
                                for (b = i - 1; b > 0; b -= 1) {
                                    if (cinfo[b] === "start") {
                                        a += 1;
                                    } else if (cinfo[b] === "end") {
                                        a -= 1;
                                    }
                                    if (level[b] !== "x") {
                                        break;
                                    }
                                }
                                if (cinfo[b] === "end") {
                                    a += 1;
                                }
                                for (c = 0; c < level[b] + a; c += 1) {
                                    indent += tab;
                                }
                            } else {
                                for (c = 0; c < level[i - 1] + 1; c += 1) {
                                    indent += tab;
                                }
                            }
                            x = "\n" + indent + x.replace(/\n/g, "\n" + indent);
                            indent = '';
                            return x;
                        };
                    loop = build.length;
                    for (i = 1; i < loop; i += 1) {
                        if (cinfo[i] === "end" && (cinfo[i - 1] !== "content" && cinfo[i - 1] !== "mixed_start")) {
                            if (build[i].charAt(0) === " ") {
                                build[i] = build[i].substr(1);
                            }
                            if (level[i] !== "x") {
                                build[i] = end_math(build[i]);
                            }
                        } else if (cinfo[i] === "external" && indent_script === "indent") {
                            build[i] = script_math(build[i]);
                        } else if (level[i] !== "x" && (cinfo[i - 1] !== "content" && cinfo[i - 1] !== "mixed_start")) {
                            if (build[i].charAt(0) === " ") {
                                build[i] = build[i].substr(1);
                            }
                            build[i] = tab_math(build[i]);
                        }
                    }
                }());
            markup_summary = function () {
                var a,
                    b = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                    c,
                    d = build.join('').length,
                    e = source.length,
                    f,
                    g,
                    h,
                    i = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                    j,
                    k,
                    l,
                    m = [],
                    n = [],
                    z = cinfo.length,
                    insertComma = function (x) {
                        if (typeof (x) === "number") {
                            x = x.toString();
                        }
                        if (typeof (x) !== "string") {
                            return x;
                        }
                        x = x.split("").reverse();
                        z = x.length;
                        for (a = 2; a < z; a += 3) {
                            x[a] = "," + x[a];
                        }
                        x = x.reverse().join("");
                        if (x.charAt(0) === ",") {
                            x = x.slice(1, x.length);
                        }
                        return x;
                    },
                    zipf = function () {
                        var a,
                            b,
                            k,
                            w,
                            z = cinfo.length,
                            x = "",
                            h = [],
                            g = [],
                            punctuation = function (y) {
                                return y.replace(/(\,|\.|\?|\!|\:) /, " ");
                            };
                        for (a = 0; a < z; a += 1) {
                            if (cinfo[a] === "content") {
                                x += " " + build[a];
                            } else if (cinfo[a] === "mixed_start") {
                                x += build[a];
                            } else if (cinfo[a] === "mixed_both") {
                                x += build[a].substr(0, build[a].length - 1);
                            } else if (cinfo[a] === "mixed_end") {
                                x += " " + build[a].substr(0, build[a].length - 1);
                            }
                        }
                        if (x.length === 0) {
                            return "";
                        }
                        x = x.substr(1, x.length).toLowerCase();
                        w = x.replace(/\&nbsp;?/gi, " ").replace(/[a-z](\,|\.|\?|\!|\:) /gi, punctuation).replace(/(\(|\)|"|\{|\}|\[|\])/g, "").replace(/ +/g, " ").split(" ");
                        x = x.split(" ");
                        z = w.length;
                        for (a = 0; a < z; a += 1) {
                            if (w[a] !== "") {
                                h.push([1, w[a]]);
                                for (b = a + 1; b < z; b += 1) {
                                    if (w[b] === w[a]) {
                                        h[h.length - 1][0] += 1;
                                        w[b] = "";
                                    }
                                }
                            }
                        }
                        z = h.length;
                        for (a = 0; a < z; a += 1) {
                            k = a;
                            for (b = a + 1; b < z; b += 1) {
                                if (h[b][0] > h[k][0] && h[b][1] !== "") {
                                    k = b;
                                }
                            }
                            g.push(h[k]);
                            if (h[k] !== h[a]) {
                                h[k] = h[a];
                            } else {
                                h[k] = [0, ""];
                            }
                            if (g.length === 11) {
                                break;
                            }
                        }
                        if (g.length < 2) {
                            return "";
                        } else if (g.length > 10) {
                            b = 10;
                        } else {
                            b = g.length - 1;
                        }
                        for (a = 0; a < b; a += 1) {
                            h[a] = (g[a][0] / g[a + 1][0]).toFixed(2);
                            g[a] = "<tr><th>" + (a + 1) + "</th><td>" + g[a][1] + "</td><td>" + g[a][0] + "</td><td>" + h[a] + "</td><td>" + ((g[a][0] / x.length) * 100).toFixed(2) + "%</td></tr>";
                        }
                        g[g.length - 1] = "";
                        return "<table class='analysis' summary=\"Zipf's Law\"><caption>This table demonstrates <em>Zipf's Law</em> by listing the 10 most occuring words in the content and the number of times they occurred.</caption><thead><tr><th>Word Rank</th><th>Most Occurring Word by Rank</th><th>Number of Instances</th><th>Ratio Increased Over Next Most Frequence Occurance</th><th>Percentage from " + insertComma(x.length) + " Total Word</th></tr></thead><tbody>" + g.join("") + "</tbody></table>";
                    };
                for (a = 0; a < z; a += 1) {
                    switch (cinfo[a]) {
                    case "end":
                        b[1] += 1;
                        i[1] += summary[a].length;
                        break;
                    case "singleton":
                        b[2] += 1;
                        i[2] += summary[a].length;
                        if (((build[a].indexOf("<embed ") !== -1 || build[a].indexOf("<img ") !== -1 || build[a].indexOf("<iframe ") !== -1) && (build[a].indexOf("src") !== -1 && build[a].indexOf("src=\"\"") === -1 && build[a].indexOf("src=''") === -1)) || (build[a].indexOf("<link ") !== -1 && build[a].indexOf("rel") !== -1 && build[a].indexOf("canonical") === -1)) {
                            m.push(build[a]);
                        }
                        break;
                    case "comment":
                        b[3] += 1;
                        i[3] += summary[a].length;
                        break;
                    case "content":
                        b[4] += 1;
                        i[4] += summary[a].length;
                        break;
                    case "mixed_start":
                        b[5] += 1;
                        i[5] += summary[a].length;
                        break;
                    case "mixed_end":
                        b[6] += 1;
                        i[6] += summary[a].length;
                        break;
                    case "mixed_both":
                        b[7] += 1;
                        i[7] += summary[a].length;
                        break;
                    case "parse":
                        b[10] += 1;
                        i[10] += summary[a].length;
                        break;
                    case "external":
                        b[17] += 1;
                        i[17] += summary[a].length;
                        if (((build[a].indexOf("<sc") !== -1 || build[a].indexOf("<embed ") !== -1 || build[a].indexOf("<img ") !== -1 || build[a].indexOf("<iframe ") !== -1) && (build[a].indexOf("src") !== -1 && build[a].indexOf("src=\"\"") === -1 && build[a].indexOf("src=''") === -1)) || (build[a].indexOf("<link ") !== -1 && build[a].indexOf("rel") !== -1 && build[a].indexOf("canonical") === -1)) {
                            m.push(build[a]);
                        }
                        break;
                    }
                    switch (token[a]) {
                    case "T_tag_start":
                        b[0] += 1;
                        i[0] += summary[a].length;
                        if (((build[a].indexOf("<embed ") !== -1 || build[a].indexOf("<img ") !== -1 || build[a].indexOf("<iframe ") !== -1) && (build[a].indexOf("src") !== -1 && build[a].indexOf("src=\"\"") === -1 && build[a].indexOf("src=''") === -1)) || (build[a].indexOf("<link ") !== -1 && build[a].indexOf("rel") !== -1 && build[a].indexOf("canonical") === -1)) {
                            m.push(build[a]);
                        }
                        break;
                    case "T_sgml":
                        b[8] += 1;
                        i[8] += summary[a].length;
                        break;
                    case "T_xml":
                        b[9] += 1;
                        i[9] += summary[a].length;
                        break;
                    case "T_ssi":
                        b[11] += 1;
                        i[11] += summary[a].length;
                        break;
                    case "T_asp":
                        b[12] += 1;
                        i[12] += summary[a].length;
                        break;
                    case "T_php":
                        b[13] += 1;
                        i[13] += summary[a].length;
                        break;
                    case "T_script":
                        b[15] += 1;
                        i[15] += summary[a].length;
                        if (build[a].indexOf(" src") !== -1) {
                            m.push(build[a]);
                        }
                        break;
                    case "T_style":
                        b[16] += 1;
                        i[16] += summary[a].length;
                        break;
                    }
                }
                f = [b[0] + b[1] + b[2] + b[3], b[4] + b[5] + b[6] + b[7], b[15] + b[16] + b[17], b[11] + b[12] + b[13]];
                j = [i[0] + i[1] + i[2] + i[3], i[4] + i[5] + i[6] + i[7], i[15] + i[16] + i[17], i[11] + i[12] + i[13]];
                g = [f[0], f[0], f[0], f[0], f[1], f[1], f[1], f[1], b[10], b[10], b[10], f[3], f[3], f[3], f[3], f[2], f[2], f[2]];
                k = [j[0], j[0], j[0], j[0], j[1], j[1], j[1], j[1], i[10], i[10], i[10], j[3], j[3], j[3], j[3], j[2], j[2], j[2]];
                b[2] = b[2] - f[3];
                i[2] = i[2] - j[3];
                c = ["*** Start Tags", "End Tags", "Singleton Tags", "Comments", "Flat String", "String with Space at Start", "String with Space at End", "String with Space at Start and End", "SGML", "XML", "Total Parsing Declarations", "SSI", "ASP", "PHP", "Total Server Side Tags", "*** Script Tags", "*** Style Tags", "JavaScript/CSS Code"];
                z = c.length;
                for (a = 0; a < z; a += 1) {
                    if (g[a] === 0) {
                        h = "0.00%";
                    } else if (b[a] === g[a]) {
                        h = "100.00%";
                    } else {
                        h = ((b[a] / g[a]) * 100).toFixed(2) + "%";
                    }
                    if (k[a] === 0) {
                        l = "0.00%";
                    } else if (i[a] === k[a]) {
                        l = "100.00%";
                    } else {
                        l = ((i[a] / k[a]) * 100).toFixed(2) + "%";
                    }
                    c[a] = "<tr><th>" + c[a] + "</th><td>" + b[a].toString() + "</td><td>" + h + "</td><td>" + ((b[a] / cinfo.length) * 100).toFixed(2) + "%</td><td>" + i[a] + "</td><td>" + l + "</td><td>" + ((i[a] / summary.join("").length) * 100).toFixed(2) + "%</td></tr>";
                }
                g = function (x) {
                    if (f[x] === 0) {
                        return "0.00%";
                    } else {
                        return "100.00%";
                    }
                };
                k = function (x) {
                    if (j[x] === 0) {
                        return "0.00%";
                    } else {
                        return "100.00%";
                    }
                };
                h = function (x) {
                    var y,
                        z;
                    switch (x) {
                    case 0:
                        if ((f[x] / cinfo.length) < 0.7) {
                            y = "bad";
                        } else {
                            y = "good";
                        }
                        if ((j[x] / summary.join("").length) > 0.4) {
                            z = "bad";
                        } else {
                            z = "good";
                        }
                        break;
                    case 1:
                        if ((f[x] / cinfo.length) < 0.25) {
                            y = "bad";
                        } else {
                            y = "good";
                        }
                        if ((j[x] / summary.join("").length) < 0.6) {
                            z = "bad";
                        } else {
                            z = "good";
                        }
                        break;
                    case 2:
                        if ((f[x] / cinfo.length) > 0.05) {
                            y = "bad";
                        } else {
                            y = "good";
                        }
                        if ((j[x] / summary.join("").length) > 0.05) {
                            z = "bad";
                        } else {
                            z = "good";
                        }
                        break;
                    }
                    return "</th><td>" + f[x] + "</td><td>" + g(x) + "</td><td class='" + y + "'>" + ((f[x] / cinfo.length) * 100).toFixed(2) + "%</td><td>" + j[x] + "</td><td>" + k(x) + "</td><td class='" + z + "'>" + ((j[x] / summary.join("").length) * 100).toFixed(2) + "%</td></tr>";
                };
                z = m.length;
                for (a = 0; a < z; a += 1) {
                    n[a] = "<li>" + m[a].replace(/\&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\"/g, "&quot;") + "</li>";
                }
                if (n.length > 0) {
                    n = "<h4>HTML elements making HTTP requests:</h4><ul>" + n.join("") + "</ul>";
                } else {
                    n = "";
                }
                c.splice(18, 0, "<tr><th>Total Script and Style Tags/Code" + h(2));
                c.splice(15, 0, "<tr><th colspan='7'>Style and Script Code/Tags</th></tr>");
                c.splice(11, 0, "<tr><th colspan='7'>Server Side Tags</th></tr>");
                c.splice(8, 0, "<tr><th>Total Content" + h(1) + "<tr><th colspan='7'>Parsing Declarations</th></tr>");
                c.splice(4, 0, "<tr><th>Total Common Tags" + h(0) + "<tr><th colspan='7'>Content</th></tr>");
                c.splice(0, 0, "<div id='doc'>" + zipf() + "<table class='analysis' summary='Analysis of markup pieces.'><caption>Analysis of markup pieces.</caption><thead><tr><th>Type</th><th>Quantity of Tags</th><th>Percentage Quantity in Section</th><th>Percentage Quantity of Total</th><th>** Character Size</th><th>Percentage Size in Section</th><th>Percentage Size of Total</th></tr></thead><tbody><tr><th>Total Pieces</th><td>" + cinfo.length + "</td><td>100.00%</td><td>100.00%</td><td>" + summary.join("").length + "</td><td>100.00%</td><td>100.00%</td></tr><tr><th colspan='7'>Common Tags</th></tr>");
                c.push("</tbody></table></div><p>* The number of requests is determined from the input submitted only and does not count the additional HTTP requests supplied from dynamically executed code, frames, iframes, css, or other external entities.</p><p>** Character size is measured from the individual pieces of tags and content specifically between minification and beautification.</p><p>*** The number of starting &lt;script&gt; and &lt;style&gt; tags is subtracted from the total number of start tags. The combination of those three values from the table above should equal the number of end tags or the code is in error.</p>" + n);
                if (b[0] + b[15] + b[16] !== b[1]) {
                    n = "s";
                    a = (b[0] + b[15] + b[16]) - b[1];
                    if (a > 0) {
                        if (a === 1) {
                            n = "";
                        }
                        a = a + " more start tag" + n + " than end tag" + n + "! ";
                    } else {
                        if (a === -1) {
                            n = "";
                        }
                        a = (a * -1) + " more end tag" + n + " than start tag" + n + "! ";
                    }
                    c.splice(0, 0, "<p><em>" + a + "The combined total number of start tags, script tags, and style tags should equal the number of end tags. For HTML try the 'Presume SGML type HTML' option.</em></p>");
                }
                n = (summary.join("").length / 7500).toFixed(0);
                if (n > 0) {
                    n = (m.length - n) * 4;
                } else {
                    n = 0;
                }
                if (j[1] === 0) {
                    f[1] = 0.00000001;
                    j[1] = 0.00000001;
                }
                b = (((f[0] + f[2] - n) / cinfo.length) / (f[1] / cinfo.length));
                a = function (x, y) {
                    return (((j[0] + x) / summary.join("").length) / ((j[1] * y) / summary.join("").length));
                };
                k = (b / a(j[2], 1)).toPrecision(2);
                l = (b / a(i[15], 1)).toPrecision(2);
                g = (b / a(j[2], 4)).toPrecision(2);
                h = (b / a(i[15], 4)).toPrecision(2);
                if (k === l) {
                    l = "";
                    h = "";
                } else {
                    l = ", or <strong>" + l + "</strong> if inline script code and style tags are removed";
                    h = ", or <strong>" + h + "</strong> if inline script code and style tags are removed";
                }
                c.splice(0, 0, "<p>If the input is content it receives an efficiency score of <strong>" + k + "</strong>" + l + ". The efficiency score if this input is a large form or application is <strong>" + g + "</strong>" + h + ". Efficient markup achieves scores higher than 2.00 and excellent markup achieves scores higher than 4.00. The score reflects the highest number of tags to pieces of content where the weight of those tags is as small as possible compared to the weight of the content. The score is a performance metric only and is not associated with validity or well-formedness, but semantic code typically achieves the highest scores. All values are rounded to the nearest hundreth.</p><p><strong>Total input size:</strong> <em>" + insertComma(e) + "</em> characters</p><p><strong>Total output size:</strong> <em>" + insertComma(d) + "</em> characters</p><p><strong>* Total number of HTTP requests in supplied HTML:</strong> <em>" + m.length + "</em></p>");
                return c.join('');
            };
            return build.join('').replace(/\n(\s)+\n/g, "\n\n");
        },
        diffview = function (baseTextLines, newTextLines, baseTextName, newTextName, contextSize, inline, lang) {
            var thead = "<table class='diff'><thead><tr><th></th>" + ((inline === true) ? "<th></th><th class='texttitle'>" + baseTextName + " vs. " + newTextName + "</th></tr></thead><tbody>" : "<th class='texttitle'>" + baseTextName + "</th><th></th><th class='texttitle'>" + newTextName + "</th></tr></thead><tbody>"),
                tbody = [],
                tfoot = "<tr><th class='author' colspan='" + ((inline === true) ? "3" : "4") + "'>Original diff view created as DOM objects by <a href='http://snowtide.com/jsdifflib'>jsdifflib</a>. Diff view recreated as a JavaScript array by <a href='http://mailmarkup.org/'>Austin Cheney</a>.</th></tr></tfoot></table>",
                node = [],
                rows = [],
                idx,
                opcodes,
                opleng,
                change,
                code,
                b,
                be,
                n,
                ne,
                z,
                rowcnt,
                i,
                jump,
                difference = function (a, b, isjunk) {
                    var isbjunk,
                        matching_blocks = [],
                        b2j = [],
                        opcodes = [],
                        answer = [],
                        get_matching_blocks = function () {
                            var idx,
                                alo,
                                ahi,
                                blo,
                                bhi,
                                qi,
                                i,
                                j,
                                k,
                                x,
                                i2,
                                j2,
                                k2,
                                la = a.length,
                                lb = b.length,
                                queue = [
                                    [0, la, 0, lb]
                                ],
                                block = 0,
                                k1 = block,
                                j1 = k1,
                                i1 = j1,
                                non_adjacent = [],
                                ntuplecomp = function (a, b) {
                                    var i,
                                        mlen = Math.max(a.length, b.length);
                                    for (i = 0; i < mlen; i += 1) {
                                        if (a[i] < b[i]) {
                                            return -1;
                                        }
                                        if (a[i] > b[i]) {
                                            return 1;
                                        }
                                    }
                                    return (a.length === b.length) ? 0 : ((a.length < b.length) ? -1 : 1);
                                },
                                find_longest_match = function (alo, ahi, blo, bhi) {
                                    var i,
                                        newj2len,
                                        jdict,
                                        jkey,
                                        k,
                                        besti = alo,
                                        bestj = blo,
                                        bestsize = 0,
                                        j = null,
                                        j2len = {},
                                        nothing = [],
                                        dictget = function (dict, key, defaultValue) {
                                            return (dict && dict[key]) ? dict[key] : defaultValue;
                                        };
                                    for (i = alo; i < ahi; i += 1) {
                                        newj2len = {};
                                        jdict = dictget(b2j, a[i], nothing);
                                        for (jkey in jdict) {
                                            if (jdict.hasOwnProperty(jkey)) {
                                                j = jdict[jkey];
                                                if (j >= blo) {
                                                    if (j >= bhi) {
                                                        break;
                                                    }
                                                    k = dictget(j2len, j - 1, 0) + 1;
                                                    newj2len[j] = k;
                                                    if (k > bestsize) {
                                                        besti = i - k + 1;
                                                        bestj = j - k + 1;
                                                        bestsize = k;
                                                    }
                                                }
                                            }
                                        }
                                        j2len = newj2len;
                                    }
                                    while (besti > alo && bestj > blo && !isbjunk(b[bestj - 1]) && a[besti - 1] === b[bestj - 1]) {
                                        besti -= 1;
                                        bestj -= 1;
                                        bestsize += 1;
                                    }
                                    while (besti + bestsize < ahi && bestj + bestsize < bhi && !isbjunk(b[bestj + bestsize]) && a[besti + bestsize] === b[bestj + bestsize]) {
                                        bestsize += 1;
                                    }
                                    while (besti > alo && bestj > blo && isbjunk(b[bestj - 1]) && a[besti - 1] === b[bestj - 1]) {
                                        besti -= 1;
                                        bestj -= 1;
                                        bestsize += 1;
                                    }
                                    while (besti + bestsize < ahi && bestj + bestsize < bhi && isbjunk(b[bestj + bestsize]) && a[besti + bestsize] === b[bestj + bestsize]) {
                                        bestsize += 1;
                                    }
                                    return [besti, bestj, bestsize];
                                };
                            while (queue.length) {
                                qi = queue.pop();
                                alo = qi[0];
                                ahi = qi[1];
                                blo = qi[2];
                                bhi = qi[3];
                                x = find_longest_match(alo, ahi, blo, bhi);
                                i = x[0];
                                j = x[1];
                                k = x[2];
                                if (k) {
                                    matching_blocks.push(x);
                                    if (alo < i && blo < j) {
                                        queue.push([alo, i, blo, j]);
                                    }
                                    if (i + k < ahi && j + k < bhi) {
                                        queue.push([i + k, ahi, j + k, bhi]);
                                    }
                                }
                            }
                            matching_blocks.sort(ntuplecomp);
                            for (idx in matching_blocks) {
                                if (matching_blocks.hasOwnProperty(idx)) {
                                    block = matching_blocks[idx];
                                    i2 = block[0];
                                    j2 = block[1];
                                    k2 = block[2];
                                    if (i1 + k1 === i2 && j1 + k1 === j2) {
                                        k1 += k2;
                                    } else {
                                        if (k1) {
                                            non_adjacent.push([i1, j1, k1]);
                                        }
                                        i1 = i2;
                                        j1 = j2;
                                        k1 = k2;
                                    }
                                }
                            }
                            if (k1) {
                                non_adjacent.push([i1, j1, k1]);
                            }
                            non_adjacent.push([la, lb, 0]);
                            matching_blocks = non_adjacent;
                            return matching_blocks;
                        },
                        set_seq2 = (function () {
                            isjunk = isjunk ? isjunk : function (c) {
                                var whitespace = {
                                    " ": true,
                                    "\t": true,
                                    "\n": true,
                                    "\f": true,
                                    "\r": true
                                };
                                if (whitespace.hasOwnProperty(c)) {
                                    return whitespace[c];
                                }
                            };
                            opcodes = null;
                            var chain_b = (function () {
                                var i,
                                    elt,
                                    indices,
                                    n = b.length,
                                    populardict = {},
                                    junkdict = {};
                                for (i = 0; i < b.length; i += 1) {
                                    elt = b[i];
                                    if (b2j[elt]) {
                                        indices = b2j[elt];
                                        if (n >= 200 && indices.length * 100 > n) {
                                            populardict[elt] = 1;
                                            delete b2j[elt];
                                        } else {
                                            indices.push(i);
                                        }
                                    } else {
                                        b2j[elt] = [i];
                                    }
                                }
                                for (elt in populardict) {
                                    if (populardict.hasOwnProperty(elt)) {
                                        delete b2j[elt];
                                    }
                                }
                                if (isjunk) {
                                    for (elt in populardict) {
                                        if (populardict.hasOwnProperty(elt) && isjunk(elt)) {
                                            junkdict[elt] = 1;
                                            delete populardict[elt];
                                        }
                                    }
                                    for (elt in b2j) {
                                        if (b2j.hasOwnProperty(elt) && isjunk(elt)) {
                                            junkdict[elt] = 1;
                                            delete b2j[elt];
                                        }
                                    }
                                }
                                isbjunk = function (key) {
                                    if (junkdict.hasOwnProperty(key)) {
                                        return junkdict[key];
                                    }
                                };
                            }()),
                                result = (function () {
                                    var idx,
                                        block,
                                        ai,
                                        bj,
                                        size,
                                        tag,
                                        i = 0,
                                        j = 0,
                                        blocks = get_matching_blocks();
                                    for (idx in blocks) {
                                        if (blocks.hasOwnProperty(idx)) {
                                            block = blocks[idx];
                                            ai = block[0];
                                            bj = block[1];
                                            size = block[2];
                                            tag = '';
                                            if (i < ai && j < bj) {
                                                tag = 'replace';
                                            } else if (i < ai) {
                                                tag = 'delete';
                                            } else if (j < bj) {
                                                tag = 'insert';
                                            }
                                            if (tag) {
                                                answer.push([tag, i, ai, j, bj]);
                                            }
                                            i = ai + size;
                                            j = bj + size;
                                            if (size) {
                                                answer.push(['equal', ai, i, bj, j]);
                                            }
                                        }
                                    }
                                }());
                        }());
                    return answer;
                },
                stringAsLines = function (str) {
                    var lfpos = str.indexOf("\n"),
                        crpos = str.indexOf("\r"),
                        linebreak = ((lfpos > -1 && crpos > -1) || crpos < 0) ? "\n" : "\r",
                        lines = str.replace(/\&/g, "&amp;").replace(/\$#lt;/g, "%#lt;").replace(/\$#gt;/g, "%#gt;").replace(/</g, "$#lt;").replace(/>/g, "$#gt;");
                    if (linebreak === "\n") {
                        str = str.replace(/\r/g, "");
                    } else {
                        str = str.replace(/\n/g, "");
                    }
                    return lines.split(linebreak);
                },
                addCells = function (row, tidx, tend, textLines, change) {
                    if (tidx < tend) {
                        if (change !== "replace") {
                            textLines = textLines[tidx].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                        }
                        row.push("<th>" + (tidx + 1).toString().replace(/\&/g, "&amp;").replace(/>/g, "&gt;").replace(/</g, "&lt;") + "</th>");
                        row.push("<td class='" + change + "'>" + textLines + "</td>");
                        return tidx + 1;
                    } else {
                        row.push("<th></th><td class='empty'></td>");
                        return tidx;
                    }
                },
                addCellsInline = function (row, tidx, tidx2, textLines, change) {
                    row.push("<th>" + ((tidx === null) ? "" : (tidx + 1).toString().replace(/\&/g, "&amp;").replace(/>/g, "&gt;").replace(/</g, "&lt;")) + "</th>");
                    row.push("<th>" + ((tidx2 === null) ? "" : (tidx2 + 1).toString().replace(/\&/g, "&amp;").replace(/>/g, "&gt;").replace(/</g, "&lt;")) + "</th>");
                    if (tidx === null) {
                        tidx = tidx2;
                    }
                    row.push("<td class='" + change + "'>" + textLines[tidx].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;") + "</td></tr>");
                },
                charcomp = function (c, d) {
                    var i,
                        j,
                        k = 0,
                        n,
                        p,
                        r = 0,
                        ax,
                        bx,
                        zx,
                        entity,
                        compare,
                        a = c.replace(/\'/g, "$#39;").replace(/\"/g, "$#34;").replace(/\&nbsp;/g, " ").replace(/\&#160;/g, " "),
                        b = d.replace(/\'/g, "$#39;").replace(/\"/g, "$#34;").replace(/\&nbsp;/g, " ").replace(/\&#160;/g, " ");
                    if (a === b) {
                        return;
                    } else {
                        ax = a.split('');
                        bx = b.split('');
                        if (ax.length >= bx.length) {
                            zx = ax.length;
                        } else if (bx.length > ax.length) {
                            zx = bx.length;
                        }
                        entity = function (z) {
                            var a = z.length,
                                b = [];
                            for (n = 0; n < a; n += 1) {
                                if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] === "$#gt;") {
                                    z[n] = '$#gt;';
                                    z[n + 1] = "";
                                    z[n + 2] = "";
                                    z[n + 3] = "";
                                    z[n + 4] = "";
                                } else if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] === "$#lt;") {
                                    z[n] = '$#lt;';
                                    z[n + 1] = "";
                                    z[n + 2] = "";
                                    z[n + 3] = "";
                                    z[n + 4] = "";
                                } else if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] + z[n + 5] === "&nbsp;") {
                                    z[n] = ' ';
                                    z[n + 1] = "";
                                    z[n + 2] = "";
                                    z[n + 3] = "";
                                    z[n + 4] = "";
                                    z[n + 5] = "";
                                } else if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] === "$#34;") {
                                    z[n] = "&#34;";
                                    z[n + 1] = "";
                                    z[n + 2] = "";
                                    z[n + 3] = "";
                                    z[n + 4] = "";
                                } else if (z[n] + z[n + 1] + z[n + 2] + z[n + 3] + z[n + 4] === "$#39;") {
                                    z[n] = "&#39;";
                                    z[n + 1] = "";
                                    z[n + 2] = "";
                                    z[n + 3] = "";
                                    z[n + 4] = "";
                                }
                            }
                            for (n = 0; n < a; n += 1) {
                                if (z[n] !== "" && z[n] !== undefined) {
                                    b.push(z[n]);
                                }
                            }
                            return b;
                        };
                        ax = entity(ax);
                        bx = entity(bx);
                        for (i = 0; i < zx; i += 1) {
                            if (ax[i] === "&" && bx[i] !== "&") {
                                bx.splice(i, 0, "", "", "", "");
                            } else if (bx[i] === "&" && ax[i] !== "&") {
                                ax.splice(i, 0, "", "", "", "");
                            }
                        }
                        compare = function () {
                            var em = /<em>/g;
                            for (i = k; i < zx; i += 1) {
                                if (ax[i] === bx[i]) {
                                    r = i;
                                } else {
                                    if (n !== 1 && ax[i] !== bx[i] && !em.test(ax[i]) && !em.test(bx[i]) && !em.test(ax[i - 1]) && !em.test(bx[i - 1])) {
                                        if (ax[i] !== undefined && bx[i] !== undefined) {
                                            ax[i] = "<em>" + ax[i];
                                            bx[i] = "<em>" + bx[i];
                                            errorout += 1;
                                        } else if (ax[i] === undefined && bx[i] !== undefined) {
                                            ax[i] = "<em> ";
                                            bx[i] = "<em>" + bx[i];
                                            errorout += 1;
                                        } else if (ax[i] !== undefined && bx[i] === undefined) {
                                            ax[i] = "<em>" + ax[i];
                                            bx[i] = "<em> ";
                                            errorout += 1;
                                        }
                                        n = 1;
                                    } else if (ax[i] === undefined && (bx[i] === '' || bx[i] === ' ')) {
                                        ax[i] = ' ';
                                    } else if (bx[i] === undefined && (ax[i] === '' || ax[i] === ' ')) {
                                        bx[i] = ' ';
                                    }
                                    break;
                                }
                            }
                            for (j = i + 1; j < zx; j += 1) {
                                if (ax[j] === bx[j]) {
                                    ax[j - 1] = ax[j - 1] + "</em>";
                                    bx[j - 1] = bx[j - 1] + "</em>";
                                    k = j;
                                    n = 0;
                                    break;
                                } else if (ax[j] !== undefined && bx[j] === undefined) {
                                    bx[j] = " ";
                                } else if (ax[j] === undefined && bx[j] !== undefined) {
                                    ax[j] = " ";
                                }
                            }
                            if (j === zx && n === 1) {
                                if (ax[j - 1].indexOf("</em>") === -1) {
                                    ax[ax.length - 1] = ax[ax.length - 1] + "</em>";
                                }
                                if (bx[j - 1].indexOf("</em>") === -1) {
                                    bx[bx.length - 1] = bx[bx.length - 1] + "</em>";
                                }
                            }
                        };
                        for (p = 0; p < zx; p += 1) {
                            if (r + 1 !== zx) {
                                compare();
                            }
                        }
                        c = ax.join("").replace(/\$#lt;/g, "&lt;").replace(/\$#gt;/g, "&gt;").replace(/$#34;/g, "\"").replace(/$#39;/g, "'").replace(/ /g, "&#160;");
                        d = bx.join("").replace(/\$#lt;/g, "&lt;").replace(/\$#gt;/g, "&gt;").replace(/$#34;/g, "\"").replace(/$#39;/g, "'").replace(/ /g, "&#160;");
                    }
                    return [c, d];
                };
            if (baseTextLines === null) {
                return "Error: Cannot build diff view; baseTextLines is not defined.";
            }
            if (newTextLines === null) {
                return "Error: Cannot build diff view; newTextLines is not defined.";
            }
            baseTextLines = stringAsLines(baseTextLines);
            newTextLines = stringAsLines(newTextLines);
            opcodes = difference(baseTextLines, newTextLines);
            opleng = opcodes.length;
            for (idx = 0; idx < opleng; idx += 1) {
                code = opcodes[idx];
                change = code[0];
                b = code[1];
                be = code[2];
                n = code[3];
                ne = code[4];
                rowcnt = Math.max(be - b, ne - n);
                for (i = 0; i < rowcnt; i += 1) {
                    if (contextSize && opcodes.length > 1 && ((idx > 0 && String(i) === contextSize) || (idx === 0 && i === 0)) && change === "equal") {
                        jump = rowcnt - ((idx === 0 ? 1 : 2) * contextSize);
                        if (jump > 1) {
                            node.push("<tr><th>...</th>" + ((inline === true) ? "" : "<td class='skip'></td>") + "<th>...</th><td class='skip'></td></tr>");
                            b += jump;
                            n += jump;
                            i += jump - 1;
                            if (idx + 1 === opcodes.length) {
                                break;
                            }
                        }
                    }
                    if (change !== "equal") {
                        errorout += 1;
                    }
                    if (inline === true) {
                        node.push("<tr>");
                        if (change === "insert") {
                            addCellsInline(node, null, n, newTextLines, change);
                        } else if (change === "replace") {
                            if (b < be && n < ne && baseTextLines[b] !== newTextLines[n]) {
                                z = charcomp(baseTextLines[b], newTextLines[n]);
                                baseTextLines[b] = z[0];
                                newTextLines[n] = z[1];
                                errorout -= 1;
                            }
                            if (b < be) {
                                addCellsInline(node, b, null, baseTextLines, "delete");
                            }
                            if (b < be && n < ne) {
                                node.push("<tr>");
                            }
                            if (n < ne) {
                                addCellsInline(node, null, n, newTextLines, "insert");
                            }
                        } else if (change === "delete") {
                            addCellsInline(node, b, null, baseTextLines, change);
                        } else if (b < be || n < ne) {
                            baseTextLines[b] = baseTextLines[b].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                            addCellsInline(node, b, n, baseTextLines, change);
                        }
                        b += 1;
                        n += 1;
                    } else {
                        node.push("<tr>");
                        if (change === "replace") {
                            if (b < be && n < ne && baseTextLines[b] !== newTextLines[n]) {
                                z = charcomp(baseTextLines[b], newTextLines[n]);
                                errorout -= 1;
                            } else if (baseTextLines[b] !== undefined && newTextLines[n] !== undefined) {
                                z = [];
                                z[0] = baseTextLines[b].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                                z[1] = newTextLines[n].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                            } else if (baseTextLines[b] === undefined || newTextLines[n] === undefined) {
                                z = [];
                                if (baseTextLines[b] !== undefined) {
                                    z[0] = baseTextLines[b].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                                    z[1] = "";
                                } else if (newTextLines[n] !== undefined) {
                                    z[1] = newTextLines[n].replace(/\$#gt;/g, "&gt;").replace(/\$#lt;/g, "&lt;");
                                    z[0] = "";
                                }
                            }
                            b = addCells(node, b, be, z[0], change);
                            n = addCells(node, n, ne, z[1], change);
                        } else {
                            b = addCells(node, b, be, baseTextLines, change);
                            n = addCells(node, n, ne, newTextLines, change);
                        }
                        node.push("</tr>");
                    }
                }
            }
            rows.push(node.join(""));
            tbody.push(rows.join(""));
            return (thead + tbody.join("") + "</tbody><tfoot>" + tfoot).replace(/\%#lt;/g, "$#lt;").replace(/\%#gt;/g, "$#gt;");
        },
        a = [],
        s = "s",
        sizediff,
        auto,
        autotest = false,
        spacetest = (/^\s+$/g),
        apioutput = "",
        apidiffout = "",
        proctime = function () {
            var d = "",
                filename,
                e = "",
                g = new Date(),
                b = ((g.getTime() - startTime) / 1000).toFixed(3),
                plural = function (x, y) {
                    if (x > 1) {
                        x = x + y + "s ";
                    } else {
                        x = x + y + " ";
                    }
                    return x;
                },
                minute = function () {
                    d = (b / 60).toFixed(1);
                    d = Number(d.toString().split(".")[0]);
                    b = (b - (d * 60)).toFixed(3);
                    d = plural(d, " minute");
                };
            if (apimode === "beautify") {
                if (apilang === "javascript") {
                    filename = "a";
                } else if (apilang === "css") {
                    filename = "b";
                } else if (apilang === "markup") {
                    filename = "c";
                } else if (apilang === "csv") {
                    filename = "d";
                }
            } else if (apimode === "minify") {
                if (apilang === "javascript") {
                    filename = "e";
                } else if (apilang === "css") {
                    filename = "f";
                } else if (apilang === "markup") {
                    filename = "g";
                } else if (apilang === "csv") {
                    filename = "h";
                }
            } else if (apimode === "diff") {
                if (apilang === "javascript") {
                    filename = "i";
                } else if (apilang === "css") {
                    filename = "j";
                } else if (apilang === "markup") {
                    filename = "k";
                } else if (apilang === "csv") {
                    filename = "l";
                } else if (apilang === "text") {
                    filename = "m";
                }
            }
            if (filename === undefined) {
                filename = "n";
            }
            if (b >= 60 && b < 3600) {
                minute();
            } else if (b >= 3600) {
                e = (b / 3600).toFixed(1);
                e = Number(e.toString().split(".")[0]);
                b = b - (e * 3600);
                e = plural(e, " hour");
                minute();
            }
            b = "<h2>Summary</h2><p><strong>Execution time:</strong> <em>" + e + d + b + "</em> seconds";
            if (localflag !== true) {
                b = b + "<img src='http://prettydiff.com/" + filename + ".gif' alt=' '/>";
            }
            return b + "</p>";
        },
        pdcomment = function () {
            if (apisource.indexOf("/*prettydiff.com") === -1 && apidiff.indexOf("/*prettydiff.com") === -1) {
                return;
            }
            var a = [],
                b = apisource.length,
                c = apisource.indexOf("/*prettydiff.com") + 16,
                d = true,
                e = [],
                f = -1,
                g = 0;
            if (c === 15) {
                c = apidiff.indexOf("/*prettydiff.com") + 16;
                d = false;
            }
            for (; c < b; c += 1) {
                if (d) {
                    if (apisource.charAt(c) === "*" && apisource.charAt(c + 1) && apisource.charAt(c + 1) === "/") {
                        break;
                    }
                    a.push(apisource.charAt(c));
                } else {
                    if (apidiff.charAt(c) === "*" && apidiff.charAt(c + 1) && apidiff.charAt(c + 1) === "/") {
                        break;
                    }
                    a.push(apidiff.charAt(c));
                }
            }
            a = a.join("").toLowerCase();
            b = a.length;
            d = "";
            for (c = 0; c < b; c += 1) {
                if ((!a.charAt(c - 1) || a.charAt(c - 1) !== "\\") && (a.charAt(c) === "\"" || a.charAt(c) === "'")) {
                    if (d === "") {
                        d = a.charAt(c);
                    } else {
                        d = "";
                    }
                }
                if (d === "") {
                    if (a.charAt(c) === ",") {
                        g = f;
                        f = c;
                        e.push(a.substring(g, f).replace(/^(\s*)/, "").replace(/(\s*)$/, ""));
                    }
                }
            }
            g = f + 1;
            f = a.length;
            e.push(a.substring(g, f).replace(/^(\s*)/, "").replace(/(\s*)$/, ""));
            d = "";
            b = e.length;
            for (c = 0; c < b; c += 1) {
                a = e[c].length;
                for (g = 0; g < a; g += 1) {
                    if (e[c].indexOf(":") === -1) {
                        e[c] = "";
                        break;
                    } else {
                        f = [];
                    }
                    if ((!e[c].charAt(g - 1) || e[c].charAt(g - 1) !== "\\") && (e[c].charAt(g) === "\"" || e[c].charAt(g) === "'")) {
                        if (d === "") {
                            d = e[c].charAt(g);
                        } else {
                            d = "";
                        }
                    }
                    if (d === "") {
                        if (e[c].charAt(g) === ":") {
                            f.push(e[c].substring(0, g).replace(/(\s*)$/, ""));
                            f.push(e[c].substring(g + 1).replace(/^(\s*)/, ""));
                            if (f[1].charAt(0) === f[1].charAt(f[1].length - 1) && f[1].charAt(f[1].length - 2) !== "\\" && (f[1].charAt(0) === "\"" || f[1].charAt(0) === "'")) {
                                f[1] = f[1].substring(1, f[1].length - 1);
                            }
                            e[c] = f;
                            break;
                        }
                    }
                }
            }
            for (c = 0; c < b; c += 1) {
                if (e[c][1]) {
                    if (e[c][0] === "apimode") {
                        if (e[c][1] === "beautify") {
                            apimode = "beautify";
                        } else if (e[c][1] === "minify") {
                            apimode = "minify";
                        } else if (e[c][1] === "diff") {
                            apimode = "diff";
                        }
                    } else if (e[c][0] === "apilang") {
                        if (e[c][1] === "auto") {
                            apilang = "auto";
                        } else if (e[c][1] === "javascript") {
                            apilang = "javascript";
                        } else if (e[c][1] === "css") {
                            apilang = "csv";
                        } else if (e[c][1] === "csv") {
                            apilang = "csv";
                        } else if (e[c][1] === "markup") {
                            apilang = "markup";
                        } else if (e[c][1] === "text") {
                            apilang = "text";
                        }
                    } else if (e[c][0] === "apicsvchar") {
                        apicsvchar = e[c][1];
                    } else if (e[c][0] === "insize" && !/\D/.test(e[c][1])) {
                        apiinsize = e[c][1];
                    } else if (e[c][0] === "inchar") {
                        apiinchar = e[c][0];
                    } else if (e[c][0] === "comments") {
                        if (e[c][1] === "indent") {
                            apicomments = "indent";
                        } else if (e[c][1] === "noindent") {
                            apicomments = "noindent";
                        }
                    } else if (e[c][0] === "apiindent") {
                        if (e[c][1] === "knr") {
                            apiindent = "knr";
                        } else if (e[c][1] === "allman") {
                            apiindent = "allman";
                        }
                    } else if (e[c][0] === "apistyle") {
                        if (e[c][1] === "indent") {
                            apistyle = "indent";
                        } else if (e[c][1] === "noindent") {
                            apistyle = "noindent";
                        }
                    } else if (e[c][0] === "apihtml") {
                        if (e[c][1] === "html-no") {
                            apihtml = "html-no";
                        } else if (e[c][1] === "html-yes") {
                            apihtml = "html-yes";
                        }
                    } else if (e[c][0] === "apicontext" && (!/\D/.test(e[c][1]) || e[c][1] === "")) {
                        apicontext = e[c][1];
                    } else if (e[c][0] === "apicontent") {
                        if (e[c][1] === "true") {
                            apicontent = true;
                        } else if (e[c][1] === "false") {
                            apicontent = false;
                        }
                    } else if (e[c][0] === "apiquote") {
                        if (e[c][1] === "true") {
                            apiquote = true;
                        } else if (e[c][1] === "false") {
                            apiquote = false;
                        }
                    } else if (e[c][0] === "apisemicolon") {
                        if (e[c][1] === "true") {
                            apisemicolon = true;
                        } else if (e[c][1] === "false") {
                            apisemicolon = false;
                        }
                    } else if (e[c][0] === "apidiffview") {
                        if (e[c][1] === "sidebyside") {
                            apidiffview = "sidebyside";
                        } else if (e[c][1] === "inline") {
                            apidiffview = "inline";
                        }
                    } else if (e[c][0] === "apisourcelabel") {
                        apisourcelabel = e[c][1];
                    } else if (e[c][0] === "apidifflabel") {
                        apidifflabel = e[c][1];
                    }
                }
            }
        };
    if (apihtml === "html-yes") {
        apihtml = true;
    }
    if (apisource === "" || apisource === undefined) {
        return ['Source code is missing.', proctime()];
    }
    if (apilang === "auto") {
        autotest = true;
        if (!/^(\s*<)/.test(apisource) && !/(>\s*)$/.test(apisource)) {
            if (/^(\s*\{)/.test(apisource) && /(\}\s*)$/.test(apisource) && apisource.indexOf(",") !== -1) {
                apilang = "javascript";
                auto = "JSON";
            } else if (/((\}?(\(\))?\)*;?\s*)|([a-z0-9]("|')?\)*);?(\s*\})*)$/i.test(apisource) && (/var\s+[a-z]+[a-zA-Z0-9]*/.test(apisource) || /(\=\s*function)|(\s*function\s+[a-zA-Z])/.test(apisource) || apisource.indexOf("{") === -1)) {
                apilang = "javascript";
                auto = "JavaScript";
            } else if (/^(\s*[\.#@a-z0-9])|^(\/\*)/i.test(apisource) && apisource.indexOf("{") !== -1) {
                apilang = "css";
                auto = "CSS";
            } else {
                apilang = "javascript";
                auto = "unknown";
            }
        } else if (/>([a-z0-9\s])*<\/?[a-z]+>/i.test(apisource) && /^(\s*<)/.test(apisource) && /(>\s*)$/.test(apisource)) {
            apilang = "markup";
            if (apihtml === true) {
                auto = "HTML";
            } else {
                auto = "markup";
            }
        } else {
            apilang = "javascript";
            auto = "unknown";
        }
        if (auto === "unknown") {
            auto = "<p>Language set to <strong>auto</strong>, but language could not be determined. Language defaulted to <em>JavaScript</em>.</p>";
        } else {
            auto = "<p>Language set to <strong>auto</strong>. Presumed language is <em>" + auto + "</em>.</p>";
        }
    }
    pdcomment();
    if (apimode === "minify") {
        if (apilang === "css") {
            apioutput = jsmin('', apisource, 3, 'css', true);
        } else if (apilang === "csv") {
            apioutput = csvmin(apisource, apicsvchar);
        } else if (apilang === "markup") {
            apioutput = markupmin(apisource, "", apihtml);
        } else if (apilang === "text") {
            apioutput = apisource;
        } else {
            apioutput = jsmin('', apisource, 3, 'javascript', false);
        }
        sizediff = function () {
            var a,
                b = 0,
                c = apisource,
                d = c.length,
                e = apisource.length,
                f = "",
                g = apioutput.length,
                h = e - g,
                i = "",
                j = "",
                k = ((h / e) * 100).toFixed(2) + "%",
                l = "";
            for (a = 0; a < d; a += 1) {
                if (c[a] === "\n") {
                    b += 1;
                }
            }
            f = apisource.length + b;
            i = f - g;
            j = f - e + 1;
            l = ((i / f) * 100).toFixed(2) + "%";
            return "<div id='doc'><table class='analysis' summary='Minification efficiency report'><caption>Minification efficiency report</caption><thead><tr><th colspan='2'>Output Size</th><th colspan='2'>Number of Lines From Input</th></tr></thead><tbody><tr><td colspan='2'>" + g + "</td><td colspan='2'>" + (b + 1) + "</td></tr><tr><th>Operating System</th><th>Input Size</th><th>Size Difference</th><th>Percentage of Decrease</th></tr><tr><th>Unix/Linux</th><td>" + e + "</td><td>" + h + "</td><td>" + k + "</td></tr><tr><th>Windows</th><td>" + f + "</td><td>" + i + "</td><td>" + l + "</td></tr></tbody></table></div>";
        };
        errorout = "";
        if (autotest === true) {
            return [apioutput, proctime() + auto + sizediff()];
        } else {
            return [apioutput, proctime() + sizediff()];
        }
    } else if (apimode === "beautify") {
        errorout = "";
        if (apilang === "css") {
            apioutput = cleanCSS(apisource, apiinsize, apiinchar, apicomments, true);
            apidiffout = css_summary();
        } else if (apilang === "csv") {
            apioutput = csvbeauty(apisource, apicsvchar);
            apidiffout = "";
        } else if (apilang === "markup") {
            apioutput = markup_beauty(apisource, apiinsize, apiinchar, "beautify", apicomments, apistyle, apihtml);
            apidiffout = markup_summary();
            if (apiinchar !== "\t") {
                apioutput = apioutput.replace(/\n[\t]* \/>/g, '');
            }
        } else if (apilang === "text") {
            apioutput = apisource;
            apidiffout = "";
        } else {
            apioutput = js_beautify(apisource, 4, " ", true, 1, 0, true, apiindent, false, apicomments);
            apidiffout = js_summary();
        }
        if (autotest === true && apilang !== "csv" && apilang !== "text") {
            return [apioutput, proctime() + auto + apidiffout];
        } else {
            return [apioutput, proctime() + apidiffout];
        }
    } else if (apimode === "diff") {
        if (apidiff === "" || apidiff === undefined) {
            return ['Diff source code is missing.', proctime()];
        }
        if (apilang === "css") {
            apioutput = jsmin('', apisource, 3, 'css', false);
            apioutput = cleanCSS(apioutput, apiinsize, apiinchar, apicomments, false);
            apidiffout = jsmin('', apidiff, 3, 'css', false);
            apidiffout = cleanCSS(apidiffout, apiinsize, apiinchar, apicomments, false);
        } else if (apilang === "csv") {
            apioutput = csvbeauty(apisource, apicsvchar);
            apidiffout = csvbeauty(apidiff, apicsvchar);
        } else if (apilang === "markup") {
            apioutput = markup_beauty(apisource, apiinsize, apiinchar, "diff", apicomments, apistyle, apihtml, apicontent).replace(/\n[\t]* \/>/g, '');
            apidiffout = markup_beauty(apidiff, apiinsize, apiinchar, "diff", apicomments, apistyle, apihtml, apicontent).replace(/\n[\t]* \/>/g, '');
        } else if (apilang === "text") {
            apioutput = apisource;
            apidiffout = apidiff;
        } else {
            apioutput = jsmin('', apisource, 3, 'javascript', false);
            apioutput = js_beautify(apioutput, 4, " ", false, 0, 0, true, apiindent, false, apicomments, apicontent);
            apidiffout = jsmin('', apidiff, 3, 'javascript', false);
            apidiffout = js_beautify(apidiffout, 4, " ", false, 0, 0, true, apiindent, false, apicomments, apicontent);
        }
        if (apiquote === true) {
            apioutput = apioutput.replace(/'/g, "\"");
            apidiffout = apidiffout.replace(/'/g, "\"");
        }
        if (apisemicolon === true) {
            apioutput = apioutput.replace(/;\n/g, "\n");
            apidiffout = apidiffout.replace(/;\n/g, "\n");
        }
        if (apisourcelabel === "" || spacetest.exec(apisourcelabel) !== null) {
            apisourcelabel = "Base Text";
        }
        if (apidifflabel === "" || spacetest.exec(apidifflabel) !== null) {
            apidifflabel = "New Text";
        }
        if (errorout === 1) {
            s = "";
        }
        
        a[1] = diffview(apioutput, apidiffout, apisourcelabel, apidifflabel, apicontext, (apidiffview=="inline"), apilang);
        a[0] = "<p><strong>Number of differences:</strong> <em>" + errorout + "</em> difference" + s + ".</p>";
        if (autotest === true) {
            return [a[1], proctime() + auto + a[0]];
        } else {
            return [a[1], proctime() + a[0]];
        }
    }
};
/*
if (typeof exports !== "string") {
    exports.api = function (x) {
        "use strict";
        return prettydiff(x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8], x[9], x[10], x[11], x[12], x[13], x[14], x[15], x[16], x[16], x[17], x[18]);
    };
}
*/ 
