String.prototype.startsWith = function(str) {return (this.match("^"+str)==str)}

// -------------------------------------------------------------------
// hasOptions(obj)
//  Utility function to determine if a select object has an options array
// -------------------------------------------------------------------
function hasOptions(obj) {
    if (obj != null && obj.options != null) {
        return true;
    }
    return false;
}

// -------------------------------------------------------------------
// selectUnselectMatchingOptions(select_object,regex,select/unselect,true/false)
//  This is a general function used by the select functions below, to
//  avoid code duplication 
// -------------------------------------------------------------------
function selectUnselectMatchingOptions(obj, regex, which, only) {
    if (window.RegExp) {
        if (which == "select") { 
            var selected1 = true;
            var selected2 = false;
        } else {
            if (which == "unselect") {
                var selected1 = false;
                var selected2 = true;
            } else {
                return;
            }
        }
        var re = new RegExp(regex);
        if (!hasOptions(obj)) {
            return;
        }
        for (var i = 0; i < obj.options.length; i++) {
            if (re.test(obj.options[i].text)) {
                obj.options[i].selected = selected1;
            } else {
                if (only == true) {
                    obj.options[i].selected = selected2;
                }
            }
        }
    }
}
    
// -------------------------------------------------------------------
// selectMatchingOptions(select_object,regex)
//  This function selects all options that match the regular expression
//  passed in. Currently-selected options will not be changed.
// -------------------------------------------------------------------
function selectMatchingOptions(obj, regex) {
    selectUnselectMatchingOptions(obj, regex, "select", false);
}
// -------------------------------------------------------------------
// selectOnlyMatchingOptions(select_object,regex)
//  This function selects all options that match the regular expression
//  passed in. Selected options that don't match will be un-selected.
// -------------------------------------------------------------------
function selectOnlyMatchingOptions(obj, regex) {
    selectUnselectMatchingOptions(obj, regex, "select", true);
}
// -------------------------------------------------------------------
// unSelectMatchingOptions(select_object,regex)
//  This function Unselects all options that match the regular expression
//  passed in.
// -------------------------------------------------------------------
function unSelectMatchingOptions(obj, regex) {
    selectUnselectMatchingOptions(obj, regex, "unselect", false);
}
    
// -------------------------------------------------------------------
// sortSelect(select_object)
//   Pass this function a SELECT object and the options will be sorted
//   by their text (display) values
// -------------------------------------------------------------------
function sortSelect(obj) 
{
    
    var o = new Array();
    var objArr;
    if (!hasOptions(obj)) {
        return;
    }
    for (var i = 0; i < obj.options.length; i++) 
    {
        objArr = new Option(obj.options[i].text, obj.options[i].value, obj.options[i].defaultSelected, obj.options[i].selected);
        objArr.className = obj.options[i].className;
        o[o.length] = objArr;
    }
    if (o.length == 0) {
        return;
    }
    o = o.sort(function (a, b) {
        if ((a.text + "") < (b.text + "")) {
            return -1;
        }
        if ((a.text + "") > (b.text + "")) {
            return 1;
        }
        return 0;
    });
    for (var i = 0; i < o.length; i++) {
        obj.options[i] = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
        obj.options[i].className = o[i].className;
    }
}

// -------------------------------------------------------------------
// selectAllOptionsRight(select_object)
//  This function takes a select box and selects all options (in a
//  multiple select object). This is used when passing values between
//  two select boxes. Select all options in the right box before
//  submitting the form so the values will be sent to the server.
// -------------------------------------------------------------------
function selectAllOptionsRight(obj) {
    if (!hasOptions(obj)) {
        return;
    }
    for (var i = 0; i < obj.options.length; i++) {
        obj.options[i].selected = true;
    }
}
    
// -------------------------------------------------------------------
// moveSelectedOptionsLeft(select_object,select_object[,autosort(true/false)[,regex]])
//  This function moves options between select boxes. Works best with
//  multi-select boxes to create the common Windows control effect.
//  Passes all selected values from the first object to the second
//  object and re-sorts each box.
//  If a third argument of 'false' is passed, then the lists are not
//  sorted after the move.
//  If a fourth string argument is passed, this will function as a
//  Regular Expression to match against the TEXT or the options. If
//  the text of an option matches the pattern, it will NOT be moved.
//  It will be treated as an unmoveable option.
//  You can also put this into the <SELECT> object as follows:
//    onDblClick="moveSelectedOptionsLeft(this,this.form.target)
//  This way, when the user double-clicks on a value in one box, it
//  will be transferred to the other (in browsers that support the
//  onDblClick() event handler).
// -------------------------------------------------------------------
function moveSelectedOptionsLeft(from, to,msg) 
{    
    var selectedFlag = false;   
    // Unselect matching options, if required
    if (arguments.length > 3) 
    {
        var regex = arguments[3];
        if (regex != "") 
        {
            unSelectMatchingOptions(from, regex);
        }
    }
    // Move them over
    if (!hasOptions(from)) 
    {
        return;
    }
    for (var i = 0; i < from.options.length; i++) 
    {
        var o = from.options[i];
        if (o.selected) 
        {
            selectedFlag = true;
            if (!hasOptions(to)) 
            {
                var index = 0;
            } 
            else 
            {
                var index = to.options.length;
            }
            var class1 = o.className;
            var prevValue = o.value.split("^$^");
            if(prevValue[1] == prevValue[4])
            {
                o.value = prevValue[0]+'^$^'+prevValue[1]+'^$^'+prevValue[2]+'^$^N^$^'+prevValue[4];
            }
            else
            {
                o.value = prevValue[0]+'^$^'+prevValue[1]+'^$^'+prevValue[2]+'^$^Y^$^'+prevValue[4];
            }
            var objToBeMoved = new Option(o.text, o.value, false, false);
            objToBeMoved.className = class1;
            to.options[index] = objToBeMoved;
        }
    }
    
    if(!selectedFlag)
    {
        alert(msg);
        return false;
    } 
    
    // Delete them from original
    for (var i = (from.options.length - 1); i >= 0; i--) 
    {
        var o = from.options[i];
        if (o.selected) 
        {
            from.options[i] = null;
        }
    }
    if ((arguments.length < 3) || (arguments[2] == true)) 
    {
        //sortSelect(from);
        sortSelect(to);
    }
    from.selectedIndex = -1;
    to.selectedIndex = -1;
}

// -------------------------------------------------------------------
// moveAllOptionsLeft(select_object,select_object[,autosort(true/false)[,regex]])
//  Move all options from one select box to another.
// -------------------------------------------------------------------

function moveAllOptionsRight(from, to) {
    selectAllOptionsRight(from);
    if (arguments.length == 2) {
        moveSelectedOptionsLeft(from, to);
    } else {
        if (arguments.length == 3) {
            moveSelectedOptionsLeft(from, to, arguments[2]);
        } else {
            if (arguments.length == 4) {
                moveSelectedOptionsLeft(from, to, arguments[2], arguments[3]);
            }
        }
    }
}

// -------------------------------------------------------------------
// copyAllOptions(select_object,select_object[,autosort(true/false)])
//  Copy all options from one select box to another, instead of
//  removing items. Duplicates in the target list are not allowed.
// -------------------------------------------------------------------
function copyAllOptions(from, to) {
    selectAllOptionsLeft(from);
    if (arguments.length == 2) {
        copySelectedOptions(from, to);
    } else {
        if (arguments.length == 3) {
            copySelectedOptions(from, to, arguments[2]);
        }
    }
}

// -------------------------------------------------------------------
// swapOptions(select_object,option1,option2)
//  Swap positions of two options in a select list
// -------------------------------------------------------------------
function swapOptions(obj, i, j) {
    var o = obj.options;
    var i_selected = o[i].selected;
    var j_selected = o[j].selected;
    var temp = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
    temp.className = o[i].className;
    var temp2 = new Option(o[j].text, o[j].value, o[j].defaultSelected, o[j].selected);
    temp2.className = o[j].className;
    o[i] = temp2;
    o[j] = temp;
    o[i].selected = j_selected;
    o[j].selected = i_selected;
}
    
// -------------------------------------------------------------------
// copySelectedOptions(select_object,select_object[,autosort(true/false)])
//  This function copies options between select boxes instead of
//  moving items. Duplicates in the target list are not allowed.
// -------------------------------------------------------------------
function copySelectedOptions(from, to) {
    var options = new Object();
    if (hasOptions(to)) {
        for (var i = 0; i < to.options.length; i++) {
            options[to.options[i].value] = to.options[i].text;
        }
    }
    if (!hasOptions(from)) {
        return;
    }
    for (var i = 0; i < from.options.length; i++) {
        var o = from.options[i];
        if (o.selected) {
            if (options[o.value] == null || options[o.value] == "undefined" || options[o.value] != o.text) {
                if (!hasOptions(to)) {
                    var index = 0;
                } else {
                    var index = to.options.length;
                }
                to.options[index] = new Option(o.text, o.value, false, false);
            }
        }
    }
    if ((arguments.length < 3) || (arguments[2] == true)) {
        sortSelect(to);
    }
    from.selectedIndex = -1;
    to.selectedIndex = -1;
}


// -------------------------------------------------------------------
// moveOptionUp(select_object)
//  Move selected option in a select list up one
// -------------------------------------------------------------------
function moveOptionUp(obj,msg1,msg2) 
{
    var selectedCount = 0;
    for (var j = 0; j < obj.options.length; j++) 
    {
        var o = obj.options[j];
        if (o.selected) 
        {
            selectedCount = selectedCount + 1;
        }
    }
    if (selectedCount == 0) 
    {
        alert(msg1);
        return false;
    }
    if (selectedCount > 1) 
    {
        alert(msg2);
        return false;
    }
            
    if (!hasOptions(obj)) 
    {
        return;
    }
    
    for (i = 0; i < obj.options.length; i++) 
    {
        if (obj.options[i].selected) 
        {
            if (i != 0 && !obj.options[i - 1].selected) 
            {
                swapOptions(obj, i, i - 1);
                obj.options[i - 1].selected = true;
                break;
            }
        }
    }
}
    
// -------------------------------------------------------------------
// moveOptionDown(select_object)
//  Move selected option in a select list down one
// -------------------------------------------------------------------
function moveOptionDown(obj,msg1,msg2) 
{
    var selectedCount = 0;
    for (var j = 0; j < obj.options.length; j++) 
    {
        var o = obj.options[j];
        if (o.selected) 
        {
            selectedCount = selectedCount + 1;
        }
    }
    if (selectedCount == 0) 
    {
        alert(msg1);
        return false;
    }
    if (selectedCount > 1) 
    {
        alert(msg2);
        return false;
    }

    if (!hasOptions(obj)) 
    {
        return;
    }
    for (i = obj.options.length - 1; i >= 0; i--)
    {
        if (obj.options[i].selected) 
        {
            if (i != (obj.options.length - 1) && !obj.options[i + 1].selected) 
            {
                swapOptions(obj, i, i + 1);
                obj.options[i + 1].selected = true;
                break;
            }
        }
    }
}

// -------------------------------------------------------------------
// removeSelectedOptions(select_object)
//  Remove all selected options from a list
//  (Thanks to Gene Ninestein)
// -------------------------------------------------------------------
function removeSelectedOptions(from) {
    if (!hasOptions(from)) {
        return;
    }
    if (from.type == "select-one") {
        from.options[from.selectedIndex] = null;
    } else {
        for (var i = (from.options.length - 1); i >= 0; i--) {
            var o = from.options[i];
            if (o.selected) {
                from.options[i] = null;
            }
        }
    }
    from.selectedIndex = -1;
} 

// -------------------------------------------------------------------
// removeAllOptions(select_object)
//  Remove all options from a list
// -------------------------------------------------------------------
function removeAllOptions(from) {
    if (!hasOptions(from)) {
        return;
    }
    for (var i = (from.options.length - 1); i >= 0; i--) {
        from.options[i] = null;
    }
    from.selectedIndex = -1;
} 

// -------------------------------------------------------------------
// addOption(select_object,display_text,value,selected)
//  Add an option to a list
// -------------------------------------------------------------------
function addOption(obj, text, value, selected) {
    if (obj != null && obj.options != null) {
        obj.options[obj.options.length] = new Option(text, value);
    }
}

// -------------------------------------------------------------------
// getCookie(name)
//  Gets the cookie and takes the name as the input
// -------------------------------------------------------------------
function getCookie(name) {
    var start = document.cookie.indexOf(name + "=");
    var len = start + name.length + 1;
    if ((!start) && (name != document.cookie.substring(0, name.length))) {
        return null;
    }
    if (start == -1) {
        return null;
    }
    var end = document.cookie.indexOf(";", len);
    if (end == -1) {
        end = document.cookie.length;
    }
    return unescape(document.cookie.substring(len, end));
}

// -------------------------------------------------------------------
// deleteCookie(name, path, domain)
//  Deletes the cookie and accepts the names, path and domain as the input
// -------------------------------------------------------------------
function deleteCookie(name, path, domain) {
    if (getCookie(name)) {
        document.cookie = name + "=" + ((path) ? "; path=" + path : "") + ((domain) ? "; domain=" + domain : "") + "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

// -------------------------------------------------------------------
// mySiteAction(action)
// Calls this function based upon the action suc as save or cancel
// -------------------------------------------------------------------
function mySiteAction(action) 
{
    var flag = 1;
    if (action == "save") {
        document.siteListForm.save.value = '1';
        for (i = 0; i < document.siteListForm.siteId.length; i++) 
        {
            document.siteListForm.siteId[i].selected = true;
        }
        for (i = 0; i < document.siteListForm.siteId1.length; i++) 
        {
            document.siteListForm.siteId1[i].selected = true;
        }
        document.siteListForm.submit();
        return true;
    }
    if (action == "cancel") {
        var returnUrl = getCookie("returnUrl");
        window.location.href = returnUrl;
    }
}

// -------------------------------------------------------------------
// jumpPage(passForm)
// Ondblclick of the links in either of the select box, opens the link url in a new window
// -------------------------------------------------------------------
function jumpPage(basePath, passForm) 
{
    var id = null;
    var siteUrl = null;
    siteId = passForm.options[passForm.selectedIndex].value;
    
    if (siteId != "") 
    {
        siteUrl = trim(siteId.split("^$^")[2]);
    }
    
    if (siteUrl.indexOf("http") == -1) 
    {
        if (!siteUrl.startsWith("/")) 
        {
            siteUrl = "http://" + siteUrl;
        }
        else
        {
            siteUrl = basePath + siteUrl;
            siteUrl = siteUrl.replace("/content/", "/");
        }
    }
    
    window.open(siteUrl, "MySites", "location=yes,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,width=800,height=600");
} 
var w;  
function openAddEditPopUp(mode,view,URL,msg1,msg2) {
    $("#editLink").removeAttr("href");  
    $("#editLink").removeAttr("class");      
    $(".editActionLink").mcdColorbox({ iframe: true, innerWidth: 550, innerHeight: 280 });

    var bookMarkType = "";
    var siteID = "";
    var siteName = "";
    var oldSiteName = "";
    var siteURL = "";
    var sourceList = "";
    var class1 = '';

    if (mode == "Add") {
        bookMarkType = "personal";
        siteID = "0";
        siteName = "";
        siteURL = "";
        sourceList = "favorite";

    } else {
        if (mode == "Edit") {
            var obj = document.siteListForm.siteId;
            var selectedCount = 0;
            var selectedValue = "";
            for (var i = 0; i < obj.options.length; i++) {
                var o = obj.options[i];
                if (o.selected) {
                    selectedCount = selectedCount + 1;
                    selectedValue = o.value;
                }
            }
            var objGlobal = document.siteListForm.siteId1;
            var selectedCountGlobal = 0;
            for (var j = 0; j < objGlobal.options.length; j++) {
                var o = objGlobal.options[j];
                if (o.selected) {
                    selectedCountGlobal = selectedCountGlobal + 1;
                    selectedValue = o.value;
                }
            }
            if (selectedCount == 0 && selectedCountGlobal == 0) {
                alert(msg1);
                return false;
            }
            if ((selectedCount == 1 && selectedCountGlobal == 0) || (selectedCount == 0 && selectedCountGlobal == 1)) {
                selectedValue = selectedValue.replace(/&/g,"|");
                selectedValue = selectedValue.replace(/'/g,"&#39;");
                selectedValue = selectedValue.replace(/\+/g,"&#43;");
                selectedValue = selectedValue.replace(/"/g,"&quot;");
                
                siteID = selectedValue.split("^$^")[0];
                if (siteID == 0) 
                {
                    bookMarkType = "personal";
                    class1 = "personal";
                } 
                else 
                {
                    if (siteID != 0) 
                    {
                        bookMarkType = "global";
                        class1 = "global";
                    }
                }
                siteName = selectedValue.split("^$^")[1];
                siteURL = selectedValue.split("^$^")[2];
                oldSiteName = selectedValue.split("^$^")[4];
                if (selectedCount == 1) {
                    sourceList = "favorite";
                } else {
                    sourceList = "global";
                }
            } else {
                alert(msg2);
                return false;
            }
        }
    }
    
    if(w != null && "close" in w) 
    {
        w.close();
    }
    
    var link = URL + "?bookMarkType=" + bookMarkType + "&mode=" + mode + "&view=" + view + "&siteID=" + siteID + "&siteName=" + escape(siteName) + "&siteURL=" + siteURL + "&sourceList=" + sourceList + "&class=" + class1 + "&oldSiteName=" + escape(oldSiteName);

    $("#addLink").attr("href",link);
    $("#editLink").attr("href",link);     
    $("#editLink").attr("class","editActionLink");  
        
    $(".editActionLink").mcdColorbox({iframe: true, innerWidth: 550, innerHeight: 280}); 
     
    //w = window.open(URL + "?bookMarkType=" + bookMarkType + "&mode=" + mode + "&siteID=" + siteID + "&siteName=" + siteName + "&siteURL=" + siteURL + "&sourceList=" + sourceList + "&class=" + class1, "", "location=yes,menubar=no,toolbar=no,scrollbars=no,status=yes,width=550,height=235");
    //w.focus();
    return false;
}   

function deleteBookMark(msg1,msg2,msg3,msg4) {
    var obj = document.siteListForm.siteId;
    var objFromToBeDeleted;
    var selectedCount = 0;
    var selectedValue = "";
    var sourceList = "";
    var siteID = "";
    for (var i = 0; i < obj.options.length; i++) {
        var o = obj.options[i];
        if (o.selected) {
            selectedCount = selectedCount + 1;
            selectedValue = o.value;
        }
    }
    var objGlobal = document.siteListForm.siteId1;
    var selectedCountGlobal = 0;
    for (var j = 0; j < objGlobal.options.length; j++) {
        var o = objGlobal.options[j];
        if (o.selected) {
            selectedCountGlobal = selectedCountGlobal + 1;
            selectedValue = o.value;
        }
    }
    if (selectedCount == 0 && selectedCountGlobal == 0) {
        alert(msg1);
        return false;
    }
    if ((selectedCount == 1 && selectedCountGlobal == 0) || (selectedCount == 0 && selectedCountGlobal == 1)) {
        if (selectedCount == 1) {
            sourceList = "favorite";
            objFromToBeDeleted = obj;
        } else {
            sourceList = "global";
            objFromToBeDeleted = objGlobal;
        }
        siteID = selectedValue.split("^$^")[0];
        if (siteID == 0) {
            var r = confirm(msg2);
            if (r == true) {
                for (var i = 0; i < objFromToBeDeleted.options.length; i++) {
                    var o = objFromToBeDeleted.options[i];
                    if (o.selected) {
                        for (var j = (objFromToBeDeleted.options.length - 1); j >= 0; j--) {
                            var o = objFromToBeDeleted.options[j];
                            if (o.selected) {
                                objFromToBeDeleted.options[j] = null;
                            }
                        }
                    }
                }
            } else {
                return false;
            }
        } 
        else 
        {
            if (siteID != 0) 
            {
                if (sourceList == "global") 
                {
                    alert(msg3);
                    return false;
                } 
                else
                {
                    /*var r = confirm("The Global link will not be deleted from favorite List and will be\navailable in global bookmark list for future selection.");
                    if (r == true)
                    {*/
                        moveSelectedOptionsLeft(obj, objGlobal);
                    /*} 
                    else
                    {
                        return false;
                    }*/
                }
            }
        }
    } else {
        alert(msg4);
        return false;
    }
}
function deselectAll() {
    var objGlobal = document.siteListForm.siteId1;
    var objFavorite = document.siteListForm.siteId;
    for (var i = 0; i < objGlobal.options.length; i++) {
        objGlobal.options[i].selected = false;
    }
    for (var j = 0; j < objFavorite.options.length; j++) {
        objFavorite.options[j].selected = false;
    }
}

function trim(strTemp)
{
    return strTemp.replace(/^\s*/, "").replace(/\s*$/, ""); 
}

