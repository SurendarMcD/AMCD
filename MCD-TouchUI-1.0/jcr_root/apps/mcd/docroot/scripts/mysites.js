String.prototype.startsWith = function(str) {return (this.match("^"+str)==str)}
// -------------------------------------------------------------------
// hasOptions(obj)
//  Utility function to determine if a select object has an options array
// -------------------------------------------------------------------
function hasOptions(obj) {
    if (obj!=null && obj.options!=null) { return true; }
    return false;
    }

// -------------------------------------------------------------------
// selectUnselectMatchingOptions(select_object,regex,select/unselect,true/false)
//  This is a general function used by the select functions below, to
//  avoid code duplication
// -------------------------------------------------------------------
function selectUnselectMatchingOptions(obj,regex,which,only) {
    if (window.RegExp) {
        if (which == "select") {
            var selected1=true;
            var selected2=false;
            }
        else if (which == "unselect") {
            var selected1=false;
            var selected2=true;
            }
        else {
            return;
            }
        var re = new RegExp(regex);
        if (!hasOptions(obj)) { return; }
        for (var i=0; i<obj.options.length; i++) {
            if (re.test(obj.options[i].text)) {
                obj.options[i].selected = selected1;
                }
            else {
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
function selectMatchingOptions(obj,regex) {
    selectUnselectMatchingOptions(obj,regex,"select",false);
    }
// -------------------------------------------------------------------
// selectOnlyMatchingOptions(select_object,regex)
//  This function selects all options that match the regular expression
//  passed in. Selected options that don't match will be un-selected.
// -------------------------------------------------------------------
function selectOnlyMatchingOptions(obj,regex) {
    selectUnselectMatchingOptions(obj,regex,"select",true);
    }
// -------------------------------------------------------------------
// unSelectMatchingOptions(select_object,regex)
//  This function Unselects all options that match the regular expression
//  passed in. 
// -------------------------------------------------------------------
function unSelectMatchingOptions(obj,regex) {
    selectUnselectMatchingOptions(obj,regex,"unselect",false);
    }
    
// -------------------------------------------------------------------
// sortSelect(select_object)
//   Pass this function a SELECT object and the options will be sorted
//   by their text (display) values
// -------------------------------------------------------------------
function sortSelect(obj) {
    var o = new Array();
    if (!hasOptions(obj)) { return; }
    for (var i=0; i<obj.options.length; i++) {
        o[o.length] = new Option( obj.options[i].text, obj.options[i].value, obj.options[i].defaultSelected, obj.options[i].selected) ;
        }
    if (o.length==0) { return; }
    o = o.sort( 
        function(a,b) { 
            if ((a.text+"") < (b.text+"")) { return -1; }
            if ((a.text+"") > (b.text+"")) { return 1; }
            return 0;
            } 
        );

    for (var i=0; i<o.length; i++) {
        obj.options[i] = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
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
    if (!hasOptions(obj)) { return; }
    for (var i=0; i<obj.options.length; i++) {
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
function moveSelectedOptionsLeft(from,to) {

        
    // Unselect matching options, if required
    if (arguments.length>3) {
        var regex = arguments[3];
        if (regex != "") {
            unSelectMatchingOptions(from,regex);
            }
        }
    // Move them over
        
    
        if (!hasOptions(from)) { return; }
        for (var i=0; i<from.options.length; i++) {
        var o = from.options[i];
        if (o.selected) {
            if (!hasOptions(to)) { var index = 0; } else { var index=to.options.length; }
            to.options[index] = new Option( o.text, o.value, false, false);
            }
        }
    // Delete them from original
    for (var i=(from.options.length-1); i>=0; i--) {
        var o = from.options[i];
        if (o.selected) {
            from.options[i] = null;
            }
        }

    if ((arguments.length<3) || (arguments[2]==true)) {
        sortSelect(from);
        sortSelect(to);
        }
    from.selectedIndex = -1;
    to.selectedIndex = -1;
//alert("to.options.length"+to.options.length);
    }

// -------------------------------------------------------------------
// moveAllOptionsLeft(select_object,select_object[,autosort(true/false)[,regex]])
//  Move all options from one select box to another.
// -------------------------------------------------------------------
function moveAllOptionsLeft(from,to) {
    selectAllOptionsLeft(from);
    if (arguments.length==2) {
        moveSelectedOptionsRight(from,to);
        }
    else if (arguments.length==3) {
        moveSelectedOptionsRight(from,to,arguments[2]);
        }
    else if (arguments.length==4) {
        moveSelectedOptionsRight(from,to,arguments[2],arguments[3]);
        }
    }


function moveAllOptionsRight(from,to) {
    selectAllOptionsRight(from);
    if (arguments.length==2) {
        moveSelectedOptionsLeft(from,to);
        }
    else if (arguments.length==3) {
        moveSelectedOptionsLeft(from,to,arguments[2]);
        }
    else if (arguments.length==4) {
        moveSelectedOptionsLeft(from,to,arguments[2],arguments[3]);
        }
    }

// -------------------------------------------------------------------
// copyAllOptions(select_object,select_object[,autosort(true/false)])
//  Copy all options from one select box to another, instead of
//  removing items. Duplicates in the target list are not allowed.
// -------------------------------------------------------------------
function copyAllOptions(from,to) {
    selectAllOptionsLeft(from);
    if (arguments.length==2) {
        copySelectedOptions(from,to);
        }
    else if (arguments.length==3) {
        copySelectedOptions(from,to,arguments[2]);
        }
    }

// -------------------------------------------------------------------
// swapOptions(select_object,option1,option2)
//  Swap positions of two options in a select list
// -------------------------------------------------------------------
function swapOptions(obj,i,j) {
    var o = obj.options;
    var i_selected = o[i].selected;
    var j_selected = o[j].selected;
    var temp = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
    var temp2= new Option(o[j].text, o[j].value, o[j].defaultSelected, o[j].selected);
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
function copySelectedOptions(from,to) {
    var options = new Object();
    if (hasOptions(to)) {
        for (var i=0; i<to.options.length; i++) {
            options[to.options[i].value] = to.options[i].text;
            }
        }
    if (!hasOptions(from)) { return; }
    for (var i=0; i<from.options.length; i++) {
        var o = from.options[i];
        if (o.selected) {
            if (options[o.value] == null || options[o.value] == "undefined" || options[o.value]!=o.text) {
                if (!hasOptions(to)) { var index = 0; } else { var index=to.options.length; }
                to.options[index] = new Option( o.text, o.value, false, false);
                }
            }
        }
    if ((arguments.length<3) || (arguments[2]==true)) {
        sortSelect(to);
        }
    from.selectedIndex = -1;
    to.selectedIndex = -1;
    }


// -------------------------------------------------------------------
// moveOptionUp(select_object)
//  Move selected option in a select list up one
// -------------------------------------------------------------------
function moveOptionUp(obj) {
    if (!hasOptions(obj)) { return; }
    //obj.options[32].selected = true;
    
    for (i=0; i<obj.options.length; i++) {
        if (obj.options[i].selected) {
            if (i != 0 && !obj.options[i-1].selected) {
                swapOptions(obj,i,i-1);
                obj.options[i-1].selected = true;
                break;
            }
        }
    }
}
    
// -------------------------------------------------------------------
// moveOptionDown(select_object)
//  Move selected option in a select list down one
// -------------------------------------------------------------------
function moveOptionDown(obj) {
    if (!hasOptions(obj)) { return; }
    
    for (i=obj.options.length-1; i>=0; i--) {
        if (obj.options[i].selected) {
            if (i != (obj.options.length-1) && ! obj.options[i+1].selected) {
                swapOptions(obj,i,i+1);
                obj.options[i+1].selected = true;
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
    if (!hasOptions(from)) { return; }
    if (from.type=="select-one") {
        from.options[from.selectedIndex] = null;
        }
    else {
        for (var i=(from.options.length-1); i>=0; i--) { 
            var o=from.options[i]; 
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
    if (!hasOptions(from)) { return; }
    for (var i=(from.options.length-1); i>=0; i--) { 
        from.options[i] = null; 
        } 
    from.selectedIndex = -1; 
    } 

// -------------------------------------------------------------------
// addOption(select_object,display_text,value,selected)
//  Add an option to a list
// -------------------------------------------------------------------
function addOption(obj,text,value,selected) {
    if (obj!=null && obj.options!=null) {
        obj.options[obj.options.length] = new Option(text, value, false, selected);
        }
    }

// -------------------------------------------------------------------
// getCookie(name)
//  Gets the cookie and takes the name as the input
// -------------------------------------------------------------------
function getCookie(name) {
    var start = document.cookie.indexOf(name+"=");
    var len = start+name.length+1;
    if ((!start) && (name != document.cookie.substring(0,name.length))) return null;
    if (start == -1) return null;
    var end = document.cookie.indexOf(";",len);
    if (end == -1) end = document.cookie.length;
    return unescape(document.cookie.substring(len,end));
}

// -------------------------------------------------------------------
// deleteCookie(name, path, domain)
//  Deletes the cookie and accepts the names, path and domain as the input
// -------------------------------------------------------------------
function deleteCookie(name, path, domain)
{
    if (getCookie(name))
    {
        document.cookie = name + "=" + 
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

// -------------------------------------------------------------------
// mySiteAction(action)
// Calls this function based upon the action suc as save or cancel
// -------------------------------------------------------------------
function mySiteAction(action) {
    var flag = 1;
    if (action == "save") {
        if (document.siteListForm.siteId.length != 0) {
            for (i=0; i < document.siteListForm.siteId.length; i++)  {
                document.siteListForm.siteId[i].selected = true;
            }
            document.siteListForm.submit();
            return true;
        } else {
            alert("Please select a site");
            return false;
        }
    }   
    if (action == "cancel") {
        var returnUrl = getCookie("returnUrl");
        window.location.href=returnUrl;
    }
    
}

// -------------------------------------------------------------------
// jumpPage(passForm)
// Ondblclick of the links in either of the select box, opens the link url in a new window
// -------------------------------------------------------------------
function jumpPage(passForm) {
    
    var id = null;
    var siteUrl = null;

    siteId = passForm.options[passForm.selectedIndex].value;
    
    if (siteId != "") {
        for(i=0; i<newSitesArray.length; i++) {
            var obj = new Object();
            obj = newSitesArray[i];
            id = obj.id;
            siteUrl = obj.url;
            if (id == siteId) {
                break;
            }
        }
    }
    if (siteUrl.indexOf("http") == -1) {
        siteUrl = "http://content.accessmcd.com" + siteUrl;
    }
    window.open(siteUrl,'MySites','location=yes,menubar=yes,toolbar=yes,scrollbars=yes,status=yes,width=800,height=600');
}
 
// Following functions are used for the admin functions
//
// -------------------------------------------------------------------
// validateSiteFields(passForm)
// Validate input site fields
// -------------------------------------------------------------------
function validateSiteFields(passForm, allEntityTypesArr,handle) 
{
    var validationStatus = true;
    var form = null;
    var checkAudTypeFlag = false;
    var obj;
    
    for(var i = 0 ; i < allEntityTypesArr.length ; i++)
    {
        obj = document.getElementById(allEntityTypesArr[i]+'AudType');
        for (j=0; j<obj.options.length; j++) 
        {
            if (obj.options[j].selected) 
            {
                checkAudTypeFlag = true;
                break;
            }
        }
    }
    
    if (passForm == "mySiteAddForm")
        form = document.mySiteAddForm;
    else 
        form = document.mySiteEditForm;
        
    var siteURI = trim(form.siteURI.value);
    var siteName = trim(form.siteName.value);
    if (siteName == null || siteName.length == 0) 
    {
        alert("please enter a site name");
        validationStatus = false;
        //return false;
    }
    else if (!checkAudTypeFlag) 
    {
        alert("Please select atleast one Audience Type.");
         validationStatus = false;
        //return false;
    }
    else if (siteURI == null || siteURI.length == 0) 
    {
        alert("please enter a url");
         validationStatus = false;
        //return false;
    }
    
    if(validationStatus == true){
        var siteNameOld = escape(form.siteNameOld.value);
        var siteName = escape(form.siteName.value);
        var userID = form.userID.value;
        var view = form.view.value;
        var siteURI = form.siteURI.value;
        var entityType = form.entityType.value;
        var entitySplit = entityType.split(",");
        var audType = "";
        for(t=0; t<entitySplit.length; t++){
            var entity = entitySplit[t];
            var entityID = entitySplit[t] + "AudType";
            var e = document.getElementById(entityID);
            if(e != null && e != "undefined"){
                var audTypeTemp = "";
                var tempSep = '';
                for (i = 0; i < e.options.length; i++) {
                    if (e.options[i].selected){
                        audTypeTemp += tempSep ;
                        audTypeTemp += e.options[i].value;
                        if(tempSep =='') tempSep =',';
                    }    
                } 
                
                if(trim(audTypeTemp) != ''){
                    var audSplit = audTypeTemp.split(",");
                    var sep = "";
                    for(a=0; a<audSplit.length; a++){
                        if(sep=='') sep = "&"+entity+"AudType=";
                        audType += sep;
                        audType += audSplit[a];
                        
                    }   
                }    
            }
        }
        actionURL = handle + "&siteNameOld="+siteNameOld+"&siteName="+siteName +"&userID="+userID+"&view="+view+audType+"&siteURI="+siteURI ;
        window.open(actionURL,"_self");  
        validationStatus = true;
        //return true;
    }  
}


// -------------------------------------------------------------------
// validateSiteAndSubmit(action)
// Validate delete sites action
// -------------------------------------------------------------------
function validateSiteAndSubmit(action) 
{
   var flag = 0;
   if(action == "delete") 
   {
        if(document.myForm.siteId)
        {
            document.myForm.action.value = 'deleteSite'; 
            //for only one site 
            if (document.myForm.siteId.value) 
            {
                if (document.myForm.siteId.checked) 
                    flag = 1;
            } 
            else 
            {
                for (var i=0; i<document.myForm.siteId.length; i++) 
                {
                    if (document.myForm.siteId[i].checked)
                    {
                        flag = 1;
                        break;
                    }
                }
            }
    
            if (flag == 0)
            {
                alert("Please check the checkbox(es)");
                return false;
            }
            document.myForm.submit();
        }
        else
        {
            alert("There are no sites to delete.");
            return false;
        }
    }
    return true;
}

function validateDeleteSiteIDs(action)
{
    var flag = 0;
    document.mySiteDeleteForm.action.value = 'confirmDeleteSite'; 
    
    if (document.mySiteDeleteForm.siteId.value) 
    {
        if (document.mySiteDeleteForm.siteId.checked) 
            flag = 1;
    } 
    else 
    {
        for (var i=0; i<document.mySiteDeleteForm.siteId.length; i++) 
        {
            if (document.mySiteDeleteForm.siteId[i].checked)
            {
                flag = 1;
                break;
            }
        }
    }

    if (flag == 0)
    {
        alert("Please check the checkbox(es)");
        return false;
    }
    document.mySiteDeleteForm.submit(); 
    return true;
}

function validateSiteAndSubmitUser(action) 
{
   var flag = 0;
   if(action == "delete") 
   {
        document.myForm.action.value = 'confirmDeleteUser'; 
        //for only one site  
        if (document.myForm.adminUserId.value) 
        {
            if (document.myForm.adminUserId.checked) 
                flag = 1;
        } 
        else 
        {
            for (var i=0; i<document.myForm.adminUserId.length; i++) 
            {
                if (document.myForm.adminUserId[i].checked) 
                {
                    flag = 1;
                    break;
                }
            }
        }
        if (flag == 0) 
        {
            alert("Please check the checkbox(es)");
            return false;
        } 
        else 
        {
            if(!confirm('Are you sure you want to delete the selected User(s) ?')) 
            {
                return false;
            }    
            document.myForm.submit();
        }
    }
    else if(action == "UpdateAll")
    {
        document.myForm.action.value = 'confirmEditAllUser';
        document.myForm.submit();
    }
    return true;
}

// -------------------------------------------------------------------
// checkAllSites()
// checkAll sites
// -------------------------------------------------------------------
function checkAllSites() 
{
    if (document.myForm.checkAllSiteId.checked == true) 
    { 
        if(document.myForm.siteId)
        {
            if (document.myForm.siteId.value) 
            {
                document.myForm.siteId.checked = true;
            }
            else
            {
                for (var i = 0; i < document.myForm.siteId.length; i++) 
                {
                    document.myForm.siteId[i].checked = true;
                }
            }
        }
    } 
    else 
    {
        if(document.myForm.siteId)
        {
            if (document.myForm.siteId.value) 
            {
                document.myForm.siteId.checked = false;
            }
            else
            {
                for (var i = 0; i < document.myForm.siteId.length; i++) 
                {
                    document.myForm.siteId[i].checked = false;
                }
            }
        }
    }
}

function checkAllDeletedSites() 
{
    if (document.mySiteDeleteForm.checkAllSiteId.checked == true) 
    { 
        if (document.mySiteDeleteForm.siteId) 
        {
            if (document.mySiteDeleteForm.siteId.value) 
            {
                document.mySiteDeleteForm.siteId.checked = true;
            }
            else
            {
                for (var i = 0; i < document.mySiteDeleteForm.siteId.length; i++) 
                {
                    document.mySiteDeleteForm.siteId[i].checked = true;
                }
            }
        }
    } 
    else 
    {
        if (document.mySiteDeleteForm.siteId) 
        {
            if (document.mySiteDeleteForm.siteId.value) 
            {
                document.mySiteDeleteForm.siteId.checked = false;
            }
            else
            {
                for (var i = 0; i < document.mySiteDeleteForm.siteId.length; i++) 
                {
                    document.mySiteDeleteForm.siteId[i].checked = false;
                }
            }
        }
    }
}

// -------------------------------------------------------------------
// mySiteAction(action, handle)
// showAll action for search function
// -------------------------------------------------------------------
function mySiteAction(action, handle) 
{    
    if (action == "go") 
    {
        document.mySiteSearchForm.action.value = 'search';
        var searchKeywords = trim(document.mySiteSearchForm.searchKeywords.value);
        
        if (searchKeywords == null || searchKeywords.length == 0) 
        {
            alert("please enter search keywords");
            return false;
        }
        /*else if(!IsalphaNumericValidate(searchKeywords))
        {
            alert('Please enter only alphanumeric Site Name.');
            return false;
        }*/
        else
        {
            document.mySiteSearchForm.submit();
        }
    }
    if (action == "showAll") 
    {
        //document.mySiteSearchForm.action=handle;
        //document.mySiteSearchForm.action.value = 'viewAdminSites';
        document.getElementById('action').value='viewAdminSites';
        //document.mySiteSearchForm.action=handle.replace("content", "");
        //document.mySiteSearchForm.action=handle.replace('\/content', '');
        document.mySiteSearchForm.submit();
    }
}


// -------------------------------------------------------------------
// gotoSite(siteUrl)
// display a site in a new window
// -------------------------------------------------------------------
function gotoSite(basePath, siteUrl)
{
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
    //window.open(siteUrl, 'MySites', 'location=yes,menubar=yes,toolbar=yes,scrollbars=yes,status=yes,width=800,height=600');
}


// -------------------------------------------------------------------
// validateUserFields(passForm)
// Validate input user fields
// -------------------------------------------------------------------
function validateUserFields(passForm) {
    var form = null;
   
    if (passForm == "mySiteAddForm")
        form = document.mySiteAddForm;
    else 
        form = document.mySiteEditForm;

    var userId = trim(form.userId.value);

    if (userId == null || userId.length == 0) 
    {
        alert("please enter a userId");
        return false;
    }
    if(!IsalphaNumericValidate(userId))
    {
        alert('Please enter only alphanumeric User Name.');
        return false;
    }

    form.submit();
    return true;
}

// -------------------------------------------------------------------
// validateUserAndSubmit(action)
// Validate delete users action
// -------------------------------------------------------------------
function validateUserAndSubmit(action) {
   var flag = 0;
   if(action == "delete") {
        
        //for only one site 
        if (document.myForm.adminUserId.value) {
            if (document.myForm.adminUserId.checked) 
                flag = 1;
        } else {
            for (var i=0; i<document.myForm.adminUserId.length; i++) {
                if (document.myForm.adminUserId[i].checked) {
                    flag = 1;
                    break;
                }
            }
        }

        if (flag == 0) {
            alert("Please check the checkbox(es)");
            return false;
        } else {
            if(!confirm('Are you sure you want to delete the selected User(s) ?')) {
              return false;
            }    
            document.myForm.submit();
        }
    }
    return true;
}


// -------------------------------------------------------------------
// checkAllUsers()
// checkAll users
// -------------------------------------------------------------------
function checkAllUsers() {

    if (document.myForm.checkAllUserId.checked == true) {
        for (var i = 0; i < document.myForm.adminUserId.length; i++) {
            document.myForm.adminUserId[i].checked = true;
        }
    } else {
        for (var i = 0; i < document.myForm.adminUserId.length; i++) {
            document.myForm.adminUserId[i].checked = false;
        }
    }
}
// -------------------------------------------------------------------
// trim(str)
// trim str
// -------------------------------------------------------------------
function trim(strTemp)
{
   return strTemp.replace(/^\s*/, "").replace(/\s*$/, ""); 
}

// -------------------------------------------------------------------
// startsWidth(str)
// startsWidth check
// -------------------------------------------------------------------
String.prototype.startsWith = function(s) { return this.indexOf(s)==0; }

function IsalphaNumericValidate(alphanumericChar)
{   
    if(trim(alphanumericChar).length == 0 || alphanumericChar.search(/[^a-zA-Z0-9 ]/g) != -1 )  
    {       
        return false;   
    }
    else
        return true;
}