
<%@include file="/apps/mcd/global/global.jsp"%>
<%@page session="false" %>
<%@page import="com.day.cq.wcm.api.WCMMode,com.mcd.accessmcd.util.CommonUtil"%>
<cq:includeClientLib categories="FeatureStoryEPs" /> 
<style>
.commentImg 
{
    color:#FFFFFF; 
    font-family: Arial,Helvetica,sans-serif !important;
    font-size: 10px;
    font-weight: bold;
    text-decoration: underline;
}
.commentImgIconExecution{
    background-image:url('<%=currentDesign.getPath()%>/images/commentCount.png');
    background-repeat:no-repeat;
    float:left;
    padding-right: 10px;
    padding-bottom: 2px;
    margin-top: 0px;
    margin-left: 5px !important;
    width:12px !important;
    height:18px !important;  
}

.commentImgIcon{
    background-image:url('<%=currentDesign.getPath()%>/images/commentCount.png');
    background-repeat:no-repeat;
    float:left;
    padding-right: 10px;
    margin-top: -3px;
    margin-left: -8px !important;
    width:12px !important;
    height:25px !important;  
}


</style>
<% if(properties.get("fsImage","").equals("") && (WCMMode.fromRequest(request)==WCMMode.EDIT)){ %>
    <b><%=langText.get("CONFIGURE_COMPONENT_MSG","",langText.get("Feature Story / Execution Priorities"))%></b>
<% }
else{

    String fs_width="400";  //main image width in px
    String fs_height="354"; //main image height in px
    String ep_width="200";   //thumbnail image width in px
    String ep_height="68";  //thumbnail image height in px 
    
    String featuredStoryURL=properties.get("fsURL","");
    String featuredStoryTitle=properties.get("fsTitle","");
    if(featuredStoryTitle.length()>50){
        featuredStoryTitle=featuredStoryTitle.substring(0,50);
    }
    String featuredStoryDescription=properties.get("fsDescription","");
    if(featuredStoryDescription.contains("\n"))
    {
        featuredStoryDescription=featuredStoryDescription.replace("\n","<br>");
    }
    String showCommentCount =  properties.get("showcommentcount","false");
    CommonUtil cutil=new CommonUtil();  
    boolean fs_flag = cutil.isInternalLink(featuredStoryURL);
    int fs_status = cutil.getPageStatus(featuredStoryURL,slingRequest);

       String[] epSmallURL=new String[6];  

    %>    
    <table id ="firstColumn" border="0" cellpadding="0" cellspacing="0">
        <tr><td valign="top">
                <div style="position:relative;">   
                    <div id="fsoverlay" style="margin-top:274px;width:400px;" > &nbsp;</div>
                    <div id="fsoverLayDiv" style="position:absolute;left:10px;right:10px;margin-top:280px;font-weight: bold;overflow:hidden;height:70px"> <h2 style="color:#ffffff;margin:0 0 5px !important" id="overLayHeading"><%=featuredStoryTitle%></h2>
                        <span id="fsoverLaySpan"><%=featuredStoryDescription%></span>
                    </div>
                <%if(fs_flag==false && featuredStoryURL!=""){%>
                        <a style="text-decoration:none;color:#FFFFFF;" href="<%=featuredStoryURL%>" target="_blank"><img onload="fsresize()" id="bigImage" src="<%= properties.get("fsImage","")%>" width="<%=fs_width%>" height="<%=fs_height%>"/></a>
                    <% }else if(fs_status==2){ %> 
                        <a style="text-decoration:none;color:#FFFFFF;" href="<%=cutil.getValidURL(featuredStoryURL)%>"><img onload="fsresize()" id="bigImage" src="<%= properties.get("fsImage","")%>" width="<%=fs_width%>" height="<%=fs_height%>"/></a>    
                    <% }else{ %>
                        <img onload="fsresize()" id="bigImage" src="<%= properties.get("fsImage","")%>" width="<%=fs_width%>" height="<%=fs_height%>"/>
                <%}%> 
                </div>
            </td>
            <td valign="top">
                <div>
                    <table cellspacing="0" cellpadding="0">
                        <%for(int i=1;i<6;i++)
                        {
                            String epURL=properties.get("ep"+i+"URL","");
                            String epTitle=properties.get("ep"+i+"Title","");
                            Boolean epFlag=cutil.isInternalLink(epURL);
                            int epStatus=cutil.getPageStatus(epURL,slingRequest);
                            String epSrc=properties.get("ep"+i+"Image","");
                            String putid= "putFSCommCountN"+i;
                            epSmallURL[i-1]=epURL;  
                            %>
                            <tr style="height:70px;">
                                <td valign="top" id="showimg<%=i%>">
                                     <%if(!epSrc.trim().equals("")){ %> 
                                         <div style="position:relative" id="small-image<%=i%>" >
                                                <% if(epTitle.trim()!=""){ %>
                                                    <div style="position: absolute;bottom:1px; text-align: center;" class="smallImageInfo">&nbsp;</div>   
                                                    <div class="sm-text" style="width:100%;text-align:center;position: absolute ;bottom:3px; overflow: hidden; height:auto;opacity:1 !important;"><%=epTitle.trim()%></div>                                               
                                                    
                                                <%}else{ %>
                                                    <div style="position: absolute;bottom:3px; text-align: center; " class="smallImageInfo"><div>&nbsp;</div></div>
                                                   
                                                <%}%>
                                                <% if(epFlag==false && epURL.trim()!=""){ %>
                                                    <a href="<%=epURL.trim()%>" target="_blank"><img id="smallImage" src='<%=epSrc.trim()%>' width="<%=ep_width%>" height="<%=ep_height%>"/></a>
                                                    <div id="<%=putid%>" style="display:block"></div>
                                                <% }else if(epStatus==2){ %>
                                                    <a href='<%=cutil.getValidURL(epURL)%>'><img id="smallImage" src='<%= epSrc.trim()%>' width="<%=ep_width%>" height="<%=ep_height%>"/></a>
                                                    <div id="<%=putid%>" style="display:block"></div>
                                                <% }else{
                                                
                                                 %>
                                                    <img id="smallImage" src="<%=epSrc.trim()%>" width="<%=ep_width%>" height="<%=ep_height%>"/>
                                                    <div id="<%=putid%>" style="display:block"></div>
                                                <%}%>
                                        <div>
                                   <%}%> 
                              </td>
                            </tr>  
                           
                   <%}//endfor loop%> 
    </table>
    </div>
    </td>
    </tr>
    </table>
    <div id="fses1html" style="display:none;"></div>
    <div id="fses2html" style="display:none;"></div>
    <div id="fses3html" style="display:none;"></div> 
    <div id="fses4html" style="display:none;"></div> 
    <div id="fses5html" style="display:none;"></div> 
    <div id="fses6html" style="display:none;"></div>        
        <div style="clear:both;"></div>
    <script>
       var showCommentCount = "<%=showCommentCount%>";
       if(showCommentCount == "true"){
           String.prototype.startsWith = function(prefix) {
                return this.indexOf(prefix) === 0;
            }
              
           var image1FSlink="<%=featuredStoryURL%>"+".html";
           var commentCountVal;
           var commentDiv; 
    
           if(image1FSlink.startsWith("/content")){
                $.ajax({
                    url: image1FSlink,
                    type: 'GET',    
                    timeout: 10000, 
                    cache: true,   
                    dataType: "html",
                    error: function(){
                         
                    },    
                    success: function(data){
                        var startIndex = data.indexOf("<!--pagecommentingstart-->");
                        var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                        var fs1Html = data.substring(startIndex,endIndex);
                        document.getElementById("fses1html").innerHTML = fs1Html;
                        commentDiv = $("#fses1html").find(".commentdiv").html();
                        commentCountVal = $("#fses1html").find(".commentCountNumber").html();
                        if(commentDiv==null || commentDiv==undefined){}
                        else
                        {
                            if(commentCountVal==null || commentCountVal==undefined)
                            {
                                var spanText="<%=langText.get("Add a Comment")%>";
                               
                                var slideInfo1HTML = "<div id='putFSCommCount'><div class='commentImgIcon'>&nbsp;</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=featuredStoryURL%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage1HTML = "<div id='putFSCommCount' style='margin-top:-5px;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=featuredStoryURL%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#fsoverLaySpan").append(slideInfo1HTML);    
                             
                            }
                             
                            else
                            {
                                var spanText;
                                if(commentCountVal>'1')
                                      spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                                else
                                     spanText= commentCountVal  + " "+"<%=langText.get("comment")%>";
                               
                                var slideInfo1HTML = "<div id='putFSCommCount' style='padding-top:5px;padding-left:10px;'><div class='commentImgIcon'>&nbsp;</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=featuredStoryURL%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage1HTML = "<div id='putFSCommCount' style='margin-top:-5px;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=featuredStoryURL%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";   
                                $("#fsoverLayDiv").append(slideInfo1HTML);    
                             
                            } 
                            var spanHeight = $("#fsoverLaySpan").height();
                            if(spanHeight >= 29 && spanHeight < 43){
                                $("#fsoverLayDiv").css("height","82px");
                                $("#fsoverLayDiv").css("margin-top","275px");
                            }
                            else if(spanHeight >= 43){
                                $("#fsoverLayDiv").css("height","97px");
                                $("#fsoverLayDiv").css("margin-top","254px");
                                $("#fsoverlay").css("height","100px");
                                $("#fsoverlay").css("margin-top","253px");
                            }
                         }  document.getElementById("fses1html").innerHTML="";
                     }
                });       
            }
            
            var imagesFSlink1="<%=cutil.getValidURL(epSmallURL[0])%>";
                              
            if(imagesFSlink1.startsWith("/content")){
                $.ajax({
                    url: imagesFSlink1,
                    type: 'GET',    
                    timeout: 10000, 
                    cache: true,  
                    dataType: "html", 
                    error: function(){
                       
                    },    
                    success: function(data){
                        var startIndex = data.indexOf("<!--pagecommentingstart-->");
                        var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                        var fs2HTML = data.substring(startIndex,endIndex);
                        document.getElementById("fses2html").innerHTML = fs2HTML;
                        commentDiv = $("#fses2html").find(".commentdiv").html();
                        commentCountVal = $("#fses2html").find(".commentCountNumber").html();
                        if(commentDiv==null || commentDiv==undefined){}
                        else
                        {
                            if(commentCountVal==null || commentCountVal==undefined)
                            {
                                 var spanText="<%=langText.get("Add a Comment")%>";
                                var slideInfo2HTML = "<div id='putFSCommCountN1' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[0])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage2HTML = "<div id='putFSCommCountN1' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[0])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image1 .sm-text").append(slideInfo2HTML);
                              
                            }
                             
                            else
                            {
                                var spanText;
                                if(commentCountVal>'1')
                                    spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                                else
                                   spanText= commentCountVal  + " "+"<%=langText.get("comment")%>";
                                var slideInfo2HTML = "<div id='putFSCommCountN1' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[0])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage2HTML = "<div id='putFSCommCountN1' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[0])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image1 .sm-text").append(slideInfo2HTML);
                            }
                            var spanHeight = $("#small-image1 .smallImageInfo").height();
                            if(spanHeight >= 14 && spanHeight < 29){
                                $("#small-image1 .smallImageInfo").css("height","35px");
                            }
                            else if(spanHeight >= 29){
                                $("#small-image1 .smallImageInfo").css("height","48px");
                            }  
                         }   document.getElementById("fses2html").innerHTML="";
                     }
                });
            }
            
            var imagesFSlink2="<%=cutil.getValidURL(epSmallURL[1])%>";                      
            if(imagesFSlink2.startsWith("/content")){
                $.ajax({
                    url: imagesFSlink2,
                    type: 'GET',    
                    timeout: 10000, 
                    cache: true,   
                    dataType: "html", 
                    error: function(){
                    },    
                    success: function(data){
                        var startIndex = data.indexOf("<!--pagecommentingstart-->");
                        var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                        var fs3HTML = data.substring(startIndex,endIndex);
                        document.getElementById("fses3html").innerHTML = fs3HTML;
                        commentDiv = $("#fses3html").find(".commentdiv").html();
                        commentCountVal = $("#fses3html").find(".commentCountNumber").html();
                        if(commentDiv==null || commentDiv==undefined){}
                        else
                        {
                            if(commentCountVal==null || commentCountVal==undefined)
                            {
                                var spanText="<%=langText.get("Add a Comment")%>";
                              
                                var slideInfo3HTML = "<div id='putFSCommCountN2' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[1])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage3HTML = "<div id='putFSCommCountN2' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[1])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image2 .sm-text").append(slideInfo3HTML);
                            }
                             
                            else
                            {
                                var spanText;
                                if(commentCountVal>'1')
                                     spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                                else
                                    spanText= commentCountVal  + " "+"<%=langText.get("comment")%>";
                                  
                                var slideInfo3HTML = "<div id='putFSCommCountN2' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[1])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage3HTML = "<div id='putFSCommCountN2' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[1])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image2 .sm-text").append(slideInfo3HTML);
                            }  
                            var spanHeight = $("#small-image2 .smallImageInfo").height();
                            if(spanHeight >= 14 && spanHeight < 29){
                                $("#small-image2 .smallImageInfo").css("height","35px");
                            }
                            else if(spanHeight >= 29){
                                $("#small-image2 .smallImageInfo").css("height","48px");
                            }
                         }  document.getElementById("fses3html").innerHTML=""; 
                     }
                });
           }
           
           var imagesFSlink3="<%=cutil.getValidURL(epSmallURL[2])%>";                       
           if(imagesFSlink3.startsWith("/content")){
                $.ajax({
                    url: imagesFSlink3,
                    type: 'GET',    
                    timeout: 10000, 
                    cache: true,  
                    dataType: "html",  
                    error: function(){
                       
                    },    
                    success: function(data){
                        var startIndex = data.indexOf("<!--pagecommentingstart-->");
                        var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                        var fs4HTML = data.substring(startIndex,endIndex);
                        document.getElementById("fses4html").innerHTML = fs4HTML;
                        commentDiv = $("#fses4html").find(".commentdiv").html();
                        commentCountVal = $("#fses4html").find(".commentCountNumber").html();
                        if(commentDiv==null || commentDiv==undefined){}
                        else
                        {
                            if(commentCountVal==null || commentCountVal==undefined)
                            {
                               var spanText="<%=langText.get("Add a Comment")%>";
                               
                                 var slideInfo4HTML = "<div id='putFSCommCountN3' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[2])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage4HTML = "<div id='putFSCommCountN3' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[2])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image3 .sm-text").append(slideInfo4HTML);
                            }
                             
                            else
                            {
                                var spanText;
                                if(commentCountVal>'1')
                                     spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                                else
                                     spanText= commentCountVal  + " "+"<%=langText.get("comment")%>";
                                   
                                var slideInfo4HTML = "<div id='putFSCommCountN3' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[2])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage4HTML = "<div id='putFSCommCountN3' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[2])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image3 .sm-text").append(slideInfo4HTML);
                            } 
                            var spanHeight = $("#small-image3 .smallImageInfo").height();
                            if(spanHeight >= 14 && spanHeight < 29){
                                $("#small-image3 .smallImageInfo").css("height","35px");
                            }
                            else if(spanHeight >= 29){
                                $("#small-image3 .smallImageInfo").css("height","48px");
                            }   
                         }   document.getElementById("fses4html").innerHTML="";
                     }
                });
            }
            
            var imagesFSlink4="<%=cutil.getValidURL(epSmallURL[3])%>";                       
            if(imagesFSlink4.startsWith("/content")){
                $.ajax({
                    url: imagesFSlink4,
                    type: 'GET',    
                    timeout: 10000, 
                    cache: true,
                    dataType: "html",    
                    error: function(){
                        
                    },    
                    success: function(data){
                  
                      
                      document.getElementById("fses5html").innerHTML = data;
                        var startIndex = data.indexOf("<!--pagecommentingstart-->");
                        var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                        var fs5HTML = data.substring(startIndex,endIndex);
                        document.getElementById("fses5html").innerHTML = fs5HTML;
                        commentDiv = $("#fses5html").find(".commentdiv").html();
                        commentCountVal = $("#fses5html").find(".commentCountNumber").html();
                        if(commentDiv==null || commentDiv==undefined){}
                        else
                        {
                            if(commentCountVal==null || commentCountVal==undefined)
                            {
                              var spanText="<%=langText.get("Add a Comment")%>";
                              
                                 var slideInfo5HTML = "<div id='putFSCommCountN4' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[3])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage5HTML = "<div id='putFSCommCountN4' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[3])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image4 .sm-text").append(slideInfo5HTML);
                            }
                             
                            else
                            {
                                var spanText;
                                if(commentCountVal>'1')
                                    spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                                else
                                     spanText= commentCountVal  + " "+"<%=langText.get("comment")%>";
                                 
                                 var slideInfo5HTML = "<div id='putFSCommCountN4' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[3])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage5HTML = "<div id='putFSCommCountN4' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[3])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image4 .sm-text").append(slideInfo5HTML);
                            }
                            var spanHeight = $("#small-image4 .smallImageInfo").height();
                            if(spanHeight >= 14 && spanHeight < 29){
                                $("#small-image4 .smallImageInfo").css("height","35px");
                            }
                            else if(spanHeight >= 29){
                                $("#small-image4 .smallImageInfo").css("height","48px");
                            }    
                         }  document.getElementById("fses5html").innerHTML=""; 
                     }
                });
            }
            
            var imagesFSlink5="<%=cutil.getValidURL(epSmallURL[4])%>";                       
            if(imagesFSlink5.startsWith("/content")){
                $.ajax({
                    url: imagesFSlink5,
                    type: 'GET',    
                    timeout: 10000, 
                    cache: true,  
                    dataType: "html",  
                    error: function(){
                       
                    },    
                    success: function(data){
                        var startIndex = data.indexOf("<!--pagecommentingstart-->");
                        var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                        var fs6HTML = data.substring(startIndex,endIndex);
                        document.getElementById("fses6html").innerHTML = fs6HTML;
                        commentDiv = $("#fses6html").find(".commentdiv").html();
                        commentCountVal = $("#fses6html").find(".commentCountNumber").html();
                        if(commentDiv==null || commentDiv==undefined){}
                        else
                        {
                            if(commentCountVal==null || commentCountVal==undefined)
                            {
                                var spanText="<%=langText.get("Add a Comment")%>";
                               
                                 var slideInfo6HTML = "<div id='putFSCommCountN5' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[4])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage6HTML = "<div id='putFSCommCountN5' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[4])%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image5 .sm-text").append(slideInfo6HTML);
                            }
                             
                            else
                            {
                                var spanText;
                                if(commentCountVal>'1')
                                     spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                                else
                                     spanText= commentCountVal + " "+"<%=langText.get("comment")%>";
                                   
                                var slideInfo6HTML = "<div id='putFSCommCountN5' style='text-align:left !important;'><div class='commentImgIconExecution'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[4])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                var slideImage6HTML = "<div id='putFSCommCountN5' style='margin-top:-5px;text-align:left !important;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#FFFFFF !important;' href='<%=cutil.getValidURL(epSmallURL[4])%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                                $("#small-image5 .sm-text").append(slideInfo6HTML);
                            } 
                            var spanHeight = $("#small-image5 .smallImageInfo").height();
                            if(spanHeight >= 14 && spanHeight < 29){
                                $("#small-image5 .smallImageInfo").css("height","35px");
                            }
                            else if(spanHeight >= 29){
                                $("#small-image5 .smallImageInfo").css("height","48px");
                            }   
                         }   document.getElementById("fses6html").innerHTML="";
                     }
                });
            }
        }
    </script>
<%}%>  