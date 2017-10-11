var availableKeywords = new Array();
var wogCategories = '[';


String.prototype.trimAll = function() {  
    return this.replace(/\s+/g,"");  
}
String.prototype.replaceAll = function(token, newToken, ignoreCase) {
    var str, i = -1, _token;
    if((str = this.toString()) && typeof token === "string") {
        _token = ignoreCase === true? token.toLowerCase() : undefined;
        while((i = (
            _token !== undefined? 
                str.toLowerCase().indexOf(
                            _token, 
                            i >= 0? i + newToken.length : 0
                ) : str.indexOf(
                            token,
                            i >= 0? i + newToken.length : 0
                )
        )) !== -1 ) {
            str = str.substring(0, i)
                    .concat(newToken)
                    .concat(str.substring(i + token.length));
        }
    }
    return str;
};
function eliminateDuplicates(arr) {
  var i,
  len=arr.length,
  out=[],
  obj={};

  for (i=0;i<len;i++) {
    obj[arr[i]]=0;
  }
  for (i in obj) {
    out.push(i);
  }
  return out;
}

function validateQuery(q){
    var regex = /^[^a-zA-Z0-9]+$/
    if(q.match(regex)){
        return false;
    }
    else{
        return true;
    }

}
function submitBrandFacts(){
        //alert("Submit Brand Facts");
        var q = $("#search").val();
        if(validateQuery(q)){
            //alert("Test Match :: " + validateQuery(q));
            var sel = document.getElementById('selectBox');
            var opt = sel.options[sel.selectedIndex];
            var factsCategory = opt.value;
            var loadingHTML = "<div class='loadingclass'><img src='/images/ajax-loader.gif'></div>";
            $('#results').html("");
            $('#results').html(loadingHTML);
            $(".description").show();
            $.ajax({    
            url: "/apps/mcd/docroot/wog/worldofgood.json",
            type: 'GET',
            dataType: 'json',
            timeout : '20000', 
            error: function(){
                //alert("Error"); 
                return;   
            },
            success: function(data){
                var jsonData = data;
                var searchHTML = "";
                var resultCount = 1;
                //alert(q.trimAll());
                if(q.trimAll() == "Enterkeywordsortexttosearch"){
                    if(factsCategory.trimAll() == "SelectCategories"){
                        for(i=0; i<jsonData.length; i++){
                            var factId = jsonData[i].FactId;
                            var title = jsonData[i].Title;
                            var description = jsonData[i].Description;
                            var keywords = jsonData[i].Keywords;
                            var share = jsonData[i].Share;
                            var shareTitle = jsonData[i].ShareTitle;

                            var shareURL = jsonData[i].ShareURL;
                            if(title == undefined || description == undefined){
                                //do nothing
                            }
                            else{ 
                                searchHTML += "<div style='display:none;' id='"+ factId +"_sharetitle'>" + shareTitle + "</div>";
                                searchHTML += "<div style='display:none;' id='"+ factId +"_shareurl'>" + shareURL + "</div>";
                                searchHTML += "<h2 id='"+ factId +"_title'>" + resultCount + ". " + title;
                                if(share.toLowerCase() == "yes" && shareURL != "" && shareTitle != ""){
                                    var shareId = "";
                                    var shareHTML  = "<div style='float:right'>";
                                                    shareHTML += "<a href='#' onclick=javascript:shareFacebook('"+factId+"');><img style='margin-right:8px;border:none;' title='Facebook' align='absMiddle' src='/wog/images/share_facebook.png'></a>";
                                                    shareHTML += "<a href='#' onclick=javascript:shareTwitter('"+factId+"');><img style='margin-right:8px;border:none;' title='Twitter' align='absMiddle' src='/wog/images/share_twitter.png'></a>";
                                                    shareHTML += "<a href='#' onclick=javascript:shareLinkedIn('"+factId+"');><img style='margin-right:8px;border:none;' title='LinkedIn' align='absMiddle' src='/wog/images/share_linked_in.png'></a>";
                                                    shareHTML += "<a href='#' class='shareEmailAction popup-with-form' id='shareemail_"+factId+"' onclick=javascript:shareEmail('"+factId+"');><img style='border:none;' title='E-mail' align='absMiddle' src='/wog/images/share_email.png'></a>";
                                                    shareHTML += "</div>";
                                    searchHTML += shareHTML;                                
                                }
                                searchHTML += "</h2>";
                                var descLength = 572;
                                if(description.indexOf("<a") > 0){
                                    descLength = 612;
                                }
                                if(description.length > descLength){
                                    searchHTML += "<p>" + description + "</p>";
                                    searchHTML += "<div class='showmore'>Show More</div>";
                                }
                                else{
                                    searchHTML += "<p>" + description + "</p>";
                                }                
                                resultCount++;
                            }    
                        }
                    }
                    else{
                        for(i=0; i<jsonData.length; i++){
                            var factId = jsonData[i].FactId;
                            var category = jsonData[i].Category;
                            var title = jsonData[i].Title;
                            var description = jsonData[i].Description;
                            var keywords = jsonData[i].Keywords;
                            var share = jsonData[i].Share;
                            var shareTitle = jsonData[i].ShareTitle;
                            var shareURL = jsonData[i].ShareURL;
                            if(category == undefined || title == undefined || description == undefined){
                                //do nothing
                            }
                            else{
                                if(category.trimAll().toLowerCase().search(factsCategory.trimAll().toLowerCase()) >= 0){
                                    searchHTML += "<div style='display:none;' id='"+ factId +"_sharetitle'>" + shareTitle + "</div>";
                                    searchHTML += "<div style='display:none;' id='"+ factId +"_shareurl'>" + shareURL + "</div>";
                                    searchHTML += "<h2 id='"+ factId +"_title'>" + resultCount + ". " + title;
                                    if(share.toLowerCase() == "yes" && shareURL != "" && shareTitle != ""){
                                        var shareId = "";
                                        var shareHTML  = "<div style='float:right'>";
                                                        shareHTML += "<a href='#' onclick=javascript:shareFacebook('"+factId+"');><img style='margin-right:8px;border:none;' title='Facebook' align='absMiddle' src='/wog/images/share_facebook.png'></a>";
                                                        shareHTML += "<a href='#' onclick=javascript:shareTwitter('"+factId+"');><img style='margin-right:8px;border:none;' title='Twitter' align='absMiddle' src='/wog/images/share_twitter.png'></a>";
                                                        shareHTML += "<a href='#' onclick=javascript:shareLinkedIn('"+factId+"');><img style='margin-right:8px;border:none;' title='LinkedIn' align='absMiddle' src='/wog/images/share_linked_in.png'></a>";
                                                        shareHTML += "<a href='#' class='shareEmailAction popup-with-form' id='shareemail_"+factId+"' onclick=javascript:shareEmail('"+factId+"');><img style='border:none;' title='E-mail' align='absMiddle' src='/wog/images/share_email.png'></a>";
                                                        shareHTML += "</div>";
                                        searchHTML += shareHTML;                                
                                    }
                                    searchHTML += "</h2>";
                                    var descLength = 572;
                                    if(description.indexOf("<a") > 0){
                                        descLength = 612;
                                    }
                                    if(description.length > descLength){
                                        searchHTML += "<p>" + description + "</p>";
                                        searchHTML += "<div class='showmore'>Show More</div>";
                                    }
                                    else{
                                        searchHTML += "<p>" + description + "</p>";
                                    }                
                                    resultCount++;
                                }
                            }
                        }
                    }
                }
                else if(q.trimAll() != ""){
                    var tempQuery = q.replace(/[^a-zA-Z ]/g, "")
                    var tempQ = tempQuery.replace(/ +/g, " ");
                    var query = tempQ.replaceAll(" ","^");
                    var querySplit = query.split("^");
                    var tempQueryValue = "";
                    var querySeparator = "";
                    for(s=0; s<querySplit.length; s++){
                        if(querySplit[s].length > 0 && validateQuery(querySplit[s])){
                            tempQueryValue += querySeparator; 
                            tempQueryValue += querySplit[s];
                            if (querySeparator == "") querySeparator = "|";
                        }
                    }
                    var queryValue = new RegExp(tempQueryValue,"i");
                    if(factsCategory.trimAll() == "SelectCategories"){
                        for(i=0; i<jsonData.length; i++){
                            var factId = jsonData[i].FactId;
                            var title = jsonData[i].Title;
                            var description = jsonData[i].Description;
                            var keywords = jsonData[i].Keywords;
                            var share = jsonData[i].Share;
                            var shareTitle = jsonData[i].ShareTitle;
                            var shareURL = jsonData[i].ShareURL;
                            if(title == undefined || description == undefined){
                                //do nothing
                            }
                            else{
                                if(keywords == undefined){
                                    if(title.search(queryValue) >= 0 || description.search(queryValue) >= 0 ){
                                        searchHTML += "<div style='display:none;' id='"+ factId +"_sharetitle'>" + shareTitle + "</div>";
                                        searchHTML += "<div style='display:none;' id='"+ factId +"_shareurl'>" + shareURL + "</div>";
                                        searchHTML += "<h2 id='"+ factId +"_title'>" + resultCount + ". " + title;
                                        if(share.toLowerCase() == "yes" && shareURL != "" && shareTitle != ""){
                                            var shareId = "";
                                            var shareHTML  = "<div style='float:right'>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareFacebook('"+factId+"');><img style='margin-right:8px;border:none;' title='Facebook' align='absMiddle' src='/wog/images/share_facebook.png'></a>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareTwitter('"+factId+"');><img style='margin-right:8px;border:none;' title='Twitter' align='absMiddle' src='/wog/images/share_twitter.png'></a>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareLinkedIn('"+factId+"');><img style='margin-right:8px;border:none;' title='LinkedIn' align='absMiddle' src='/wog/images/share_linked_in.png'></a>";
                                                            shareHTML += "<a href='#' class='shareEmailAction popup-with-form' id='shareemail_"+factId+"' onclick=javascript:shareEmail('"+factId+"');><img style='border:none;' title='E-mail' align='absMiddle' src='/wog/images/share_email.png'></a>";
                                                            shareHTML += "</div>";
                                            searchHTML += shareHTML;                                
                                        }
                                        searchHTML += "</h2>";
                                        var descLength = 572;
                                        if(description.indexOf("<a") > 0){
                                            descLength = 612;
                                        }
                                        if(description.length > descLength){
                                            searchHTML += "<p>" + description + "</p>";
                                            searchHTML += "<div class='showmore'>Show More</div>";
                                        }
                                        else{
                                            searchHTML += "<p>" + description + "</p>";
                                        }                
                                        resultCount++;
                                    }
                                }
                                else{
                                    if(title.search(queryValue) >= 0 || description.search(queryValue) >= 0 || keywords.search(queryValue) >= 0 ){
                                        searchHTML += "<div style='display:none;' id='"+ factId +"_sharetitle'>" + shareTitle + "</div>";
                                        searchHTML += "<div style='display:none;' id='"+ factId +"_shareurl'>" + shareURL + "</div>";
                                        searchHTML += "<h2 id='"+ factId +"_title'>" + resultCount + ". " + title;
                                        if(share.toLowerCase() == "yes" && shareURL != "" && shareTitle != ""){
                                            var shareId = "";
                                            var shareHTML  = "<div style='float:right'>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareFacebook('"+factId+"');><img style='margin-right:8px;border:none;' title='Facebook' align='absMiddle' src='/wog/images/share_facebook.png'></a>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareTwitter('"+factId+"');><img style='margin-right:8px;border:none;' title='Twitter' align='absMiddle' src='/wog/images/share_twitter.png'></a>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareLinkedIn('"+factId+"');><img style='margin-right:8px;border:none;' title='LinkedIn' align='absMiddle' src='/wog/images/share_linked_in.png'></a>";
                                                            shareHTML += "<a href='#' class='shareEmailAction popup-with-form' id='shareemail_"+factId+"' onclick=javascript:shareEmail('"+factId+"');><img style='border:none;' title='E-mail' align='absMiddle' src='/wog/images/share_email.png'></a>";
                                                            shareHTML += "</div>";
                                            searchHTML += shareHTML;                                
                                        }
                                        searchHTML += "</h2>";
                                        var descLength = 572;
                                        if(description.indexOf("<a") > 0){
                                            descLength = 612;
                                        }
                                        if(description.length > descLength){
                                            searchHTML += "<p>" + description + "</p>";
                                            searchHTML += "<div class='showmore'>Show More</div>";
                                        }
                                        else{
                                            searchHTML += "<p>" + description + "</p>";
                                        }                
                                        resultCount++;
                                    }
                                }
                            }    
                        }
                    }
                    else{
                        for(i=0; i<jsonData.length; i++){
                            var factId = jsonData[i].FactId;
                            var category = jsonData[i].Category;
                            var title = jsonData[i].Title;
                            var description = jsonData[i].Description;
                            var keywords = jsonData[i].Keywords;
                            var share = jsonData[i].Share;
                            var shareTitle = jsonData[i].ShareTitle;
                            var shareURL = jsonData[i].ShareURL;
                            if(category == undefined || title == undefined || description == undefined){
                                //do nothing
                            }
                            else{
                                if(keywords == undefined){
                                    if((category.trimAll().toLowerCase().search(factsCategory.trimAll().toLowerCase()) >= 0) && ( 
                                    title.search(queryValue) >= 0 || description.search(queryValue) >= 0 )){
                                        searchHTML += "<div style='display:none;' id='"+ factId +"_sharetitle'>" + shareTitle + "</div>";
                                        searchHTML += "<div style='display:none;' id='"+ factId +"_shareurl'>" + shareURL + "</div>";
                                        searchHTML += "<h2 id='"+ factId +"_title'>" + resultCount + ". " + title;
                                        if(share.toLowerCase() == "yes" && shareURL != "" && shareTitle != ""){
                                            var shareId = "";
                                            var shareHTML  = "<div style='float:right'>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareFacebook('"+factId+"');><img style='margin-right:8px;border:none;' title='Facebook' align='absMiddle' src='/wog/images/share_facebook.png'></a>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareTwitter('"+factId+"');><img style='margin-right:8px;border:none;' title='Twitter' align='absMiddle' src='/wog/images/share_twitter.png'></a>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareLinkedIn('"+factId+"');><img style='margin-right:8px;border:none;' title='LinkedIn' align='absMiddle' src='/wog/images/share_linked_in.png'></a>";
                                                            shareHTML += "<a href='#' class='shareEmailAction popup-with-form' id='shareemail_"+factId+"' onclick=javascript:shareEmail('"+factId+"');><img style='border:none;' title='E-mail' align='absMiddle' src='/wog/images/share_email.png'></a>";
                                                            shareHTML += "</div>";
                                            searchHTML += shareHTML;                                
                                        }
                                        searchHTML += "</h2>";
                                        var descLength = 572;
                                        if(description.indexOf("<a") > 0){
                                            descLength = 612;
                                        }
                                        if(description.length > descLength){
                                            searchHTML += "<p>" + description + "</p>";
                                            searchHTML += "<div class='showmore'>Show More</div>";
                                        }
                                        else{
                                            searchHTML += "<p>" + description + "</p>";
                                        }                
                                        resultCount++;
                                    }
                                }
                                else{
                                    if((category.trimAll().toLowerCase().search(factsCategory.trimAll().toLowerCase()) >= 0) && ( 
                                    title.search(queryValue) >= 0 || description.search(queryValue) >= 0 || keywords.search(queryValue) >= 0 )){
                                        searchHTML += "<div style='display:none;' id='"+ factId +"_sharetitle'>" + shareTitle + "</div>";
                                        searchHTML += "<div style='display:none;' id='"+ factId +"_shareurl'>" + shareURL + "</div>";
                                        searchHTML += "<h2 id='"+ factId +"_title'>" + resultCount + ". " + title;
                                        if(share.toLowerCase() == "yes" && shareURL != "" && shareTitle != ""){
                                            var shareId = "";
                                            var shareHTML  = "<div style='float:right'>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareFacebook('"+factId+"');><img style='margin-right:8px;border:none;' title='Facebook' align='absMiddle' src='/wog/images/share_facebook.png'></a>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareTwitter('"+factId+"');><img style='margin-right:8px;border:none;' title='Twitter' align='absMiddle' src='/wog/images/share_twitter.png'></a>";
                                                            shareHTML += "<a href='#' onclick=javascript:shareLinkedIn('"+factId+"');><img style='margin-right:8px;border:none;' title='LinkedIn' align='absMiddle' src='/wog/images/share_linked_in.png'></a>";
                                                            shareHTML += "<a href='#' class='shareEmailAction popup-with-form' id='shareemail_"+factId+"' onclick=javascript:shareEmail('"+factId+"');><img style='border:none;' title='E-mail' align='absMiddle' src='/wog/images/share_email.png'></a>";
                                                            shareHTML += "</div>";
                                            searchHTML += shareHTML;                                
                                        }
                                        searchHTML += "</h2>";
                                        var descLength = 572;
                                        if(description.indexOf("<a") > 0){
                                            descLength = 612;
                                        }
                                        if(description.length > descLength){
                                            searchHTML += "<p>" + description + "</p>";
                                            searchHTML += "<div class='showmore'>Show More</div>";
                                        }
                                        else{
                                            searchHTML += "<p>" + description + "</p>";
                                        }                
                                        resultCount++;
                                    }
                                }
                                
                            }
                        }
                    }
                }
                if(searchHTML.trimAll() == ""){
                    searchHTML = "<div style='margin-top:10px;font-size:18px;color:#DC291E;'>Sorry, we didn't find any results for <font color='#162252'>" + q +"</font>.Please try with different keyword or text.</div>";
                }
                $('#results').html(searchHTML);
                $(".showmore").click(function(){    
                    if($(this).html()=="Show More"){
                        $(".content").html($(this).prev().html());
                        var getHeight = $(".content").height() + 20;
                        $(this).prev().animate({height:getHeight});
                        $(this).html("Show Less");
                    } else{
                        $(this).prev().animate({height:44});
                        $(this).html("Show More");
                    }       
                });
               //highlightme();
               var highlightHTML = $('#results').html();
               //alert(highlightHTML);
            }
        });
    }
    else{
        var loadingHTML = "<div style='margin-top:10px;font-size:18px;color:#DC291E;'>Wild card search is not allowed.Please try with keyword or text with wild cards.</div>";
        $('#results').html("");
        $('#results').html(loadingHTML);
        $(".description").show();
    }
}

function showBrandsFacts(){
    var wogQuery = getParameterByName("wogquery");
    var loadingHTML = "<div class='loadingclass'><img src='/images/ajax-loader.gif'></div>";
    $('#results').html("");
    $('#results').html(loadingHTML);
    $(".description").show();
    $.ajax({    
        url: "/apps/mcd/docroot/wog/worldofgood.json",
        type: 'GET',
        dataType: 'json',
        timeout : '20000', 
        error: function(){
            //alert("Error In Retrieving Image Gallery Data"); 
            return;   
        },
        success: function(data){
            var jsonData = data;
            var searchHTML = "";
            var resultCount = 1;
            var separator = "";
            var tags = "";
            if(wogQuery != ""){
                var tempQuery = wogQuery.replace(/[^a-zA-Z ]/g, "")
                var tempQ = tempQuery.replace(/ +/g, " ");
                var query = tempQ.replaceAll(" ","^");
                var querySplit = query.split("^");
                var tempQueryValue = "";
                var querySeparator = "";
                for(s=0; s<querySplit.length; s++){
                    tempQueryValue += querySeparator; 
                    tempQueryValue += querySplit[s];
                    if (querySeparator == "") querySeparator = "|";
                }
                var queryValue = new RegExp(tempQueryValue,"i");
                for(i=0; i<jsonData.length; i++){
                    var factId = jsonData[i].FactId;
                    var title = jsonData[i].Title;
                    var description = jsonData[i].Description;
                    var keywords = jsonData[i].Keywords;
                    var share = jsonData[i].Share;
                    var shareTitle = jsonData[i].ShareTitle;
                    var shareURL = jsonData[i].ShareURL;
                    tags += separator;
                    tags += keywords;
                    if (separator == "") separator = ",";
                    if(title == undefined || description == undefined){
                        //do nothing
                    }
                    else{
                        if(keywords == undefined){
                           if(title.search(queryValue) >= 0 || description.search(queryValue) >= 0 ){
                                searchHTML += "<div style='display:none;' id='"+ factId +"_sharetitle'>" + shareTitle + "</div>";
                                searchHTML += "<div style='display:none;' id='"+ factId +"_shareurl'>" + shareURL + "</div>";
                                searchHTML += "<h2 id='"+ factId +"_title'>" + resultCount + ". " + title;
                                if(share.toLowerCase() == "yes" && shareURL != "" && shareTitle != ""){
                                    var shareId = "";
                                    var shareHTML  = "<div style='float:right'>";
                                                    shareHTML += "<a href='#' onclick=javascript:shareFacebook('"+factId+"');><img style='margin-right:8px;border:none;' title='Facebook' align='absMiddle' src='/wog/images/share_facebook.png'></a>";
                                                    shareHTML += "<a href='#' onclick=javascript:shareTwitter('"+factId+"');><img style='margin-right:8px;border:none;' title='Twitter' align='absMiddle' src='/wog/images/share_twitter.png'></a>";
                                                    shareHTML += "<a href='#' onclick=javascript:shareLinkedIn('"+factId+"');><img style='margin-right:8px;border:none;' title='LinkedIn' align='absMiddle' src='/wog/images/share_linked_in.png'></a>";
                                                    shareHTML += "<a href='#' class='shareEmailAction popup-with-form' id='shareemail_"+factId+"' onclick=javascript:shareEmail('"+factId+"');> <img style='border:none;' title='E-mail' align='absMiddle' src='/wog/images/share_email.png'></a>";
                                                    shareHTML += "</div>";
                                    searchHTML += shareHTML;                                
                                }
                                searchHTML += "</h2>";
                                var descLength = 572;
                                if(description.indexOf("<a") > 0){
                                    descLength = 612;
                                }
                                if(description.length > descLength){
                                    searchHTML += "<p>" + description + "</p>";
                                    searchHTML += "<div class='showmore'>Show More</div>";
                                }
                                else{
                                    searchHTML += "<p>" + description + "</p>";
                                }                
                                resultCount++;
                            } 
                        }
                        else{
                            if(title.search(queryValue) >= 0 || description.search(queryValue) >= 0 || keywords.search(queryValue) >= 0 ){
                                searchHTML += "<div style='display:none;' id='"+ factId +"_sharetitle'>" + shareTitle + "</div>";
                                searchHTML += "<div style='display:none;' id='"+ factId +"_shareurl'>" + shareURL + "</div>";
                                searchHTML += "<h2 id='"+ factId +"_title'>" + resultCount + ". " + title;
                                if(share.toLowerCase() == "yes" && shareURL != "" && shareTitle != ""){
                                    var shareId = "";
                                    var shareHTML  = "<div style='float:right'>";
                                                    shareHTML += "<a href='#' onclick=javascript:shareFacebook('"+factId+"');><img style='margin-right:8px;border:none;' title='Facebook' align='absMiddle' src='/wog/images/share_facebook.png'></a>";
                                                    shareHTML += "<a href='#' onclick=javascript:shareTwitter('"+factId+"');><img style='margin-right:8px;border:none;' title='Twitter' align='absMiddle' src='/wog/images/share_twitter.png'></a>";
                                                    shareHTML += "<a href='#' onclick=javascript:shareLinkedIn('"+factId+"');><img style='margin-right:8px;border:none;' title='LinkedIn' align='absMiddle' src='/wog/images/share_linked_in.png'></a>";
                                                    shareHTML += "<a href='#' class='shareEmailAction popup-with-form' id='shareemail_"+factId+"' onclick=javascript:shareEmail('"+factId+"');><img style='margin-right:8px;border:none;' title='E-mail' align='absMiddle' src='/wog/images/share_email.png'></a>";
                                                    shareHTML += "</div>";
                                    searchHTML += shareHTML;                                
                                }
                                searchHTML += "</h2>";
                                var descLength = 572;
                                if(description.indexOf("<a") > 0){
                                    descLength = 612;
                                }
                                if(description.length > descLength){
                                    searchHTML += "<p>" + description + "</p>";
                                    searchHTML += "<div class='showmore'>Show More</div>";
                                }
                                else{
                                    searchHTML += "<p>" + description + "</p>";
                                }                
                                resultCount++;
                            }
                        }
                        
                    }    
                }
            }
            else{
                for(i=0; i<jsonData.length; i++){
                    var factId = jsonData[i].FactId;
                    var title = jsonData[i].Title;
                    var description = jsonData[i].Description;
                    var keywords = jsonData[i].Keywords;
                    var share = jsonData[i].Share;
                    var shareTitle = jsonData[i].ShareTitle;
                    //alert(title);



                    var shareURL = jsonData[i].ShareURL;
                    tags += separator;
                    tags += keywords;
                    if (separator == "") separator = ",";
                    if(title == undefined || description == undefined){
                        //do nothing
                    }


                    else{
                        searchHTML += "<div style='display:none;' id='"+ factId +"_sharetitle'>" + shareTitle + "</div>";
                        searchHTML += "<div style='display:none;' id='"+ factId +"_shareurl'>" + shareURL + "</div>";
                        searchHTML += "<h2 id='"+ factId +"_title'>" + resultCount + ". " + title;

                        if(share.toLowerCase() == "yes" && shareURL != "" && shareTitle != ""){
                            var shareId = "";
                            var shareHTML  = "<div style='float:right'>";
                                            shareHTML += "<a href='#' onclick=javascript:shareFacebook('"+factId+"');><img style='margin-right:8px;border:none;' title='Facebook' align='absMiddle' src='/wog/images/share_facebook.png'></a>";
                                            shareHTML += "<a href='#' onclick=javascript:shareTwitter('"+factId+"');><img style='margin-right:8px;border:none;' title='Twitter' align='absMiddle' src='/wog/images/share_twitter.png'></a>";
                                            shareHTML += "<a href='#' style='text-decoration:none;' onclick=javascript:shareLinkedIn('"+factId+"');><img style='margin-right:8px;border:none;' title='LinkedIn' align='absMiddle' src='/wog/images/share_linked_in.png'></a>";
                                            shareHTML += "<a class='shareEmailAction' id='shareemail_"+factId+"' href=javascript:shareEmail('"+factId+"');><img style='border:none;' title='E-mail' align='absMiddle' src='/wog/images/share_email.png'></a>";
                                            shareHTML += "</div>";
                            searchHTML += shareHTML;                                
                        }

                        searchHTML += "</h2>";
                        var descLength = 572;
                        if(description.indexOf("<a") > 0){
                            descLength = 612;
                        }
                        if(description.length > descLength){
                            searchHTML += "<p id='"+ resultCount +"_answer'>" + description + "</p>";
                            searchHTML += "<div class='showmore'>Show More</div>";
                        }
                        else{
                            searchHTML += "<p id='"+ resultCount +"_answer'>" + description + "</p>";
                        }
                        resultCount++;  
                    }
                }
            }
            var splitArray = tags.split(",");
            var removeDuplicates = eliminateDuplicates(splitArray);
            for(s=0; s<removeDuplicates.length; s++){
                availableKeywords[s] = removeDuplicates[s];
            }
            availableKeywords.sort();
            if(searchHTML.trimAll() == ""){
                searchHTML = "<div style='margin-top:10px;font-size:18px;color:#DC291E;'>Sorry, we didn't find any results.</div>";
            }
            $('#results').html(searchHTML);
            $(".showmore").click(function(){    
                if($(this).html()=="Show More"){
                    $(".content").html($(this).prev().html());
                    var getHeight = $(".content").height() + 20;
                    $(this).prev().animate({height:getHeight});
                    $(this).html("Show Less");
                } else{
                    $(this).prev().animate({height:44});
                    $(this).html("Show More");
                }       
            });
        }
    });
}

function wogCategory(wogURL){
    $.ajax({    
        url: wogURL,
        type: 'GET',
        dataType: 'json',
        timeout : '20000', 
        error: function(){
            //alert("Error In Retrieving Image Gallery Data"); 
            return;   
        },
        success: function(data){
            var wogData = data;
            
            var firstSep = "";
            var categories = "";
            for(i=0; i<wogData.length; i++){
                if(wogData[i].Category != undefined){
                    categories += firstSep;
                    categories += wogData[i].Category;
                    if(firstSep == "") firstSep = ',';
                }
            }
            var splitArray = categories.split(",").sort();
            var finalCategories = eliminateDuplicates(splitArray);
            var separator = "";
            for(i=0; i<finalCategories.length; i++){
                var category = finalCategories[i];
                wogCategories += separator;
                wogCategories += '{';
                wogCategories += '"text":';
                wogCategories += '"'+category+'"';
                wogCategories += ',';
                wogCategories += '"value":';
                wogCategories += '"'+category+'"';
                wogCategories += '}';
                if(separator == "") separator = ',';

            }
            wogCategories += ']';
        }
    });
}

function highlightme(){
    var str = $("#search").val();
    var strarray = str.split(" ");
    void($('#result').highlight(strarray)); //pass string array to function
}
      
function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
function shareEmail(elemId){
    var emailURL = $("#emailaction").val() + "?factId="+elemId;
    $.fancybox.open({
        href : emailURL,
        type : 'iframe',
        padding : 5,
        width: 610,
        height:450
    });

}


function shareFacebook(elemId){





var shareTitle = $("#"+elemId+"_sharetitle").html(); 
var shareURL = $("#"+elemId+"_shareurl").html();

var title_fb = $("#"+elemId+"_title").html();
var index= title_fb.indexOf("<");
var fb_var=  title_fb.indexOf(".");
 var par_fb=fb_var+1;



    var finalTitle=title_fb.substring(par_fb,index);



    var useragent = navigator.userAgent;

    /*if(useragent.indexOf('iPhone OS 4') != -1 || useragent.indexOf('iPhone OS 5') != -1 || useragent.indexOf('iPhone OS 6') != -1 || useragent.indexOf('iPhone OS 7') != -1) {
        window.open('http://m.facebook.com/sharer.php?&u='+encodeURIComponent(shareURL)+'&p[images][0]=http://www.aboutmcdonalds.com/content/dam/AboutMcDonalds/common_share_arches_image.jpg','facebooksharedialog','width=626,height=436, top='+($(window).height()/2 - 225) +', left='+($(window).width()/2 - 220 )+', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');   
        return false;
    }
    else{
        window.open('http://www.facebook.com/sharer.php?s=100&p[summary]='+encodeURIComponent(shareTitle)+'&p[url]='+shareURL+'&p[images][0]=http://www.aboutmcdonalds.com/content/dam/AboutMcDonalds/common_share_arches_image.jpg','facebooksharedialog','width=626,height=436, top='+($(window).height()/2 - 225) +', left='+($(window).width()/2 - 220 )+', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');   
        return false;
    }  */  
   /* window.open(
        'http://www.facebook.com/sharer.php?s=100&p[title]='+encodeURIComponent(titleHTML.substring(titleHTML.indexOf(".")+1))+'&p[summary]='+encodeURIComponent(answerHTML)+'&p[url]=http://www.aboutmcdonalds.com', 
        'facebook-share-dialog', 
        'width=626,height=436');*/
    //window.open('http://www.facebook.com/sharer.php?m2w&s=100&p[url]='+shareURL+'&p[title]='+encodeURIComponent(shareTitle)+'&p[images][0]=http://www.aboutmcdonalds.com/content/dam/AboutMcDonalds/wog_share_arches_image.jpg','facebooksharedialog','width=626,height=436, top='+($(window).height()/2 - 225) +', left='+($(window).width()/2 - 220 )+', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');   



// window.open('http://www.facebook.com/sharer.php?m2w&s=100&p[summary]='+encodeURIComponent(shareTitle)+'&p[url]='+shareURL+'&p[images][0]=http://www.aboutmcdonalds.com/content/dam/AboutMcDonalds/wog_share_arches_image.jpg','facebooksharedialog','width=626,height=436, top='+($(window).height()/2 - 225) +', left='+($(window).width()/2 - 220 )+', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');     




window.open('https://www.facebook.com/dialog/feed?app_id=2309869772&display=popup&caption='+encodeURIComponent(finalTitle)+'&link='+shareURL+'&redirect_uri=https://www.facebook.com/&picture=http://www.aboutmcdonalds.com/content/dam/AboutMcDonalds/wog_share_arches_image.jpg','facebooksharedialog','width=626,height=436, top='+($(window).height()/2 - 225) +', left='+($(window).width()/2 - 220 )+', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');

    return false;    
  

}

function shareTwitter(elemId){
    var shareTitle = $("#"+elemId+"_sharetitle").html(); 
    var shareURL = $("#"+elemId+"_shareurl").html(); 
    //window.open('http://www.addtoany.com/add_to/twitter?linkurl='+encodeURIComponent(shareURL)+'&linkname='+encodeURIComponent(shareTitle),'twitter', 'height=450, width=550, top='+($(window).height()/2 - 225) +', left='+$(window).width()/2 +', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0'); 
    //window.open('http://twitter.com/share?url=' + shareTitle + '&text=' + shareURL, 'twitterwindow', 'height=450, width=550, top='+($(window).height()/2 - 225) +', left='+($(window).width()/2 - 220 )+', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');
    //var twtLink = 'http://twitter.com/home?status=' + encodeURIComponent(shareTitle + ' ' + shareURL);
    //window.open(twtLink,'twitter', 'height=450, width=550, top='+($(window).height()/2 - 225) +', left='+($(window).width()/2 - 220 )+', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');
    window.open( "http://twitter.com/share?url="+encodeURIComponent(shareURL.trimAll())+"&text="+encodeURIComponent(shareTitle)+ "&count=none&dnt=false",'twitterwindow', 'height=450, width=550, top='+($(window).height()/2 - 225) +', left='+($(window).width()/2 - 220 )+', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');

    
}
function shareLinkedIn(elemId){
    var shareTitle = $("#"+elemId+"_sharetitle").html(); 
    var shareURL = $("#"+elemId+"_shareurl").html(); 
    window.open("http://www.linkedin.com/shareArticle?mini=true&url="+encodeURIComponent(shareURL.trimAll())+"&title="+encodeURIComponent(shareTitle+' '+shareURL.trimAll()),'linkedinwindow', 'height=450, width=550, top='+($(window).height()/2 - 225) +', left='+($(window).width()/2 - 220 )+', toolbar=0, location=0, menubar=0, directories=0, scrollbars=0');    
}


$(document).ready(function(){       
    showBrandsFacts();
    $("#search").autocomplete({
        source: availableKeywords
    });

    
    //$("#search").autocomplete(availableKeywords);



    var Input = $('input[name=wogsearchbox]');
    var default_value = Input.val();

    Input.focus(function() {
        if(Input.val() == default_value) Input.val("");
    }).blur(function(){
        if(Input.val().length == 0) Input.val(default_value);
    });

    
});