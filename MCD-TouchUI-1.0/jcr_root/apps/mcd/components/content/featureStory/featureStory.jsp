<%-- 

  Feature Story component.

 Author: Deepak Jain

--%><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page session="false" %><%
%><%@page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.Page, com.mcd.util.PropertiesLoader,
    java.util.Properties, java.util.Iterator,
    com.day.cq.wcm.api.PageFilter, java.text.ParseException,
    java.text.SimpleDateFormat, java.text.DateFormat,
    java.util.TreeMap,java.util.Date,java.util.Set,com.mcd.accessmcd.util.CommonUtil,
    com.day.cq.wcm.api.WCMMode"%>  
<style>
.commentImg 
{
    color:#004276 !important; 
    font-family: Arial,Helvetica,sans-serif !important;
    font-size: 10px;
    font-weight: bold !important;
    text-decoration: underline;
}
.commentImgIcon{
    background-image:url('<%=currentDesign.getPath()%>/images/commentCount.png');
    background-repeat:no-repeat;
    float:left;
    margin-left:-8px !important;
    margin-top:-3px;
    width:12px !important;
}
.commentImgIconThumb{
    background-image:url('<%=currentDesign.getPath()%>/images/commentCount.png');
    background-repeat:no-repeat;
    float:left;
    margin-left:-2px !important;
    margin-top:-3px;
    width:12px !important;
}  
</style>
<%   

if ((properties.get("selectionType","").equals("")) && (WCMMode.fromRequest(request)==WCMMode.EDIT)){

%>    

<b><%= langText.get("FEATURE_STORY_SELECTION_TYPE") %></b> 

<%

}else{
    String viewPastStoriesLink=properties.get("viewPastStoriesLink","#");
    
    CommonUtil commonUtil = new CommonUtil();         
    viewPastStoriesLink = commonUtil.getValidURL(viewPastStoriesLink);
    
    String viewPastStoriesTitle=properties.get("viewPastStoriesTitle","VIEW PAST STORIES");
    String navFunctionality=properties.get("navigationFunctionality","");
    
    Image featureStoryArticle1Image=new Image(resource);
    Image featureStoryArticle2Image=new Image(resource);
    Image featureStoryArticle3Image=new Image(resource); 
   
    String featureStoryArticle1Title="";
    String featureStoryArticle2Title="";
    String featureStoryArticle3Title="";
   
    String featureStoryArticle1Teaser="";
    String featureStoryArticle2Teaser="";
    String featureStoryArticle3Teaser="";
    
    String featureStoryArticle1Link="";
    String featureStoryArticle2Link="";
    String featureStoryArticle3Link=""; 
    
    int playSpeed=(int)Integer.parseInt(properties.get("playSpeed","10000")); 
    int transitionTime=(int)Integer.parseInt(properties.get("transitionTime","2000"));
    Page [] featureStoryPage=new Page[3];
    String showCommentCount =  properties.get("showcommentcount","false");
    
    String selectionType=properties.get("selectionType","");   
    if(selectionType.equals("manual")){
       
        featureStoryArticle1Link=properties.get("link1","");
        featureStoryArticle2Link=properties.get("link2","");
        featureStoryArticle3Link=properties.get("link3","");        

        if(featureStoryArticle1Link.startsWith("/content"))
            featureStoryPage[0]=pageManager.getPage(featureStoryArticle1Link);                         

        if(featureStoryArticle2Link.startsWith("/content"))
            featureStoryPage[1]=pageManager.getPage(featureStoryArticle2Link);

        if(featureStoryArticle3Link.startsWith("/content"))
            featureStoryPage[2]=pageManager.getPage(featureStoryArticle3Link);
        
        if(featureStoryPage[0]!=null){
            featureStoryArticle1Title=(!(properties.get("title1","")).equals(""))?properties.get("title1",""):featureStoryPage[0].getProperties().get("featureImageTitle","");          
            featureStoryArticle1Teaser=(!(properties.get("teaser1","")).equals(""))?properties.get("teaser1",""):featureStoryPage[0].getProperties().get("featureImageText","");
        }
        else{
            featureStoryArticle1Title=properties.get("title1","");
            featureStoryArticle1Teaser=properties.get("teaser1","");
        }
        
        if(featureStoryPage[1]!=null){ 
            featureStoryArticle2Title=(!(properties.get("title2","")).equals(""))?properties.get("title2",""):featureStoryPage[1].getProperties().get("featureImageTitle","");          
            featureStoryArticle2Teaser=(!(properties.get("teaser2","")).equals(""))?properties.get("teaser2",""):featureStoryPage[1].getProperties().get("featureImageText","");
        }
        else{
            featureStoryArticle2Title=properties.get("title2","");
            featureStoryArticle2Teaser=properties.get("teaser2","");
        }
        
        if(featureStoryPage[2]!=null){
            featureStoryArticle3Title=(!(properties.get("title3","")).equals(""))?properties.get("title3",""):featureStoryPage[2].getProperties().get("featureImageTitle","");          
            featureStoryArticle3Teaser=(!(properties.get("teaser3","")).equals(""))?properties.get("teaser3",""):featureStoryPage[2].getProperties().get("featureImageText","");
        }
        else{
            featureStoryArticle3Title=properties.get("title3","");
            featureStoryArticle3Teaser=properties.get("teaser3","");
        }
        
        featureStoryArticle1Image = new Image(resource,"image1");
        if(!featureStoryArticle1Image.hasContent()){     
                if(featureStoryPage[0]!=null){
                   featureStoryArticle1Image=new Image(featureStoryPage[0].getContentResource(),"featureImage");                  
                  }
        }
        
        featureStoryArticle2Image = new Image(resource,"image2");
        if(!featureStoryArticle2Image.hasContent()){     
            if(featureStoryPage[1]!=null){
                featureStoryArticle2Image=new Image(featureStoryPage[1].getContentResource(),"featureImage");
            }
        }  
        
        featureStoryArticle3Image = new Image(resource,"image3");     
        if(!featureStoryArticle3Image.hasContent()){                
            if(featureStoryPage[2]!=null){     
            featureStoryArticle3Image=new Image(featureStoryPage[2].getContentResource(),"featureImage");
            }
        }
        
        featureStoryArticle1Link = commonUtil.getValidURL(featureStoryArticle1Link);
        featureStoryArticle2Link = commonUtil.getValidURL(featureStoryArticle2Link);
        featureStoryArticle3Link = commonUtil.getValidURL(featureStoryArticle3Link); 
        
    }
    
    else{         
        String featurePageLink="";
        
        if((currentPage.getPath()).indexOf(prop.getProperty("us"))!=-1){
            featurePageLink=prop.getProperty("featureStory_us");
        }
        else if((currentPage.getPath()).indexOf(prop.getProperty("au"))!=-1){
            featurePageLink=prop.getProperty("featureStory_au");
        } 
        else if((currentPage.getPath()).indexOf(prop.getProperty("nz"))!=-1){
            featurePageLink=prop.getProperty("featureStory_nz");
        }
        else{
            featurePageLink=prop.getProperty("featureStory_default");  
        }                         
        
        Page autoPage=pageManager.getPage(featurePageLink);  
        if(autoPage!=null){
            Iterator<Page> myChildren = autoPage.listChildren(new PageFilter(request));   
            TreeMap<Date,Page> pageMap=new TreeMap<Date,Page>();
            DateFormat formatter = new SimpleDateFormat("MM/dd/yy");                 
            
            while(myChildren.hasNext()){
                Page child =  (Page) myChildren.next();
                String dateValue=child.getProperties().get("featurePublishDate","");
                if(!(dateValue.equals(""))){        
                    try{
                        Date date=(Date)formatter.parse(dateValue);
                        pageMap.put(date,child);
                    }
                    catch(ParseException pe){
                        log.error("Error in parsing Date");
                    }        
                } 
            }
        
            Set mapSet=pageMap.descendingKeySet();
            int count=0;        
            for (Iterator i = mapSet.iterator(); i.hasNext();) {
                Date key = (Date) i.next();        
                featureStoryPage[count]= (Page)pageMap.get(key);   
                if(count==2) 
                    break;
                count++;
            }
        
            if(featureStoryPage[0]!=null){
                featureStoryArticle1Link=featureStoryPage[0].getPath();
                featureStoryArticle1Link = commonUtil.getValidURL(featureStoryArticle1Link);
                featureStoryArticle1Title=featureStoryPage[0].getProperties().get("featureImageTitle","");
                featureStoryArticle1Teaser=featureStoryPage[0].getProperties().get("featureImageText","");         
                featureStoryArticle1Image=new Image(featureStoryPage[0].getContentResource(),"featureImage");
              
            }
            
            if(featureStoryPage[1]!=null){
                featureStoryArticle2Link=featureStoryPage[1].getPath();
                featureStoryArticle2Link = commonUtil.getValidURL(featureStoryArticle2Link);
                featureStoryArticle2Title=featureStoryPage[1].getProperties().get("featureImageTitle","");
                featureStoryArticle2Teaser=featureStoryPage[1].getProperties().get("featureImageText","");
                featureStoryArticle2Image=new Image(featureStoryPage[1].getContentResource(),"featureImage");
            }
            
            if(featureStoryPage[2]!=null){
                featureStoryArticle3Link=featureStoryPage[2].getPath();
                featureStoryArticle3Link = commonUtil.getValidURL(featureStoryArticle3Link);
                featureStoryArticle3Title=featureStoryPage[2].getProperties().get("featureImageTitle","");                
                featureStoryArticle3Teaser=featureStoryPage[2].getProperties().get("featureImageText","");                 
                featureStoryArticle3Image=new Image(featureStoryPage[2].getContentResource(),"featureImage");
            }
        }    
    }
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";            
    
    Image drawImage1 = drawImage(featureStoryArticle1Image,ddClassName,currentDesign, resourceDesign, currentStyle);    
    //String imagePath1=drawImage1.getPath()+"/file";      
    String imagePath1=drawImage1.getSrc();      
    
    Image drawImage2 = drawImage(featureStoryArticle2Image,ddClassName,currentDesign, resourceDesign, currentStyle);    
    //String imagePath2=drawImage2.getPath()+"/file";   
    String imagePath2=drawImage2.getSrc();
    
    Image drawImage3 = drawImage(featureStoryArticle3Image,ddClassName,currentDesign, resourceDesign, currentStyle);        
    //String imagePath3=drawImage3.getPath()+"/file";
    String imagePath3=drawImage3.getSrc();
    
    if(featureStoryArticle1Title.length()>39)
        featureStoryArticle1Title=featureStoryArticle1Title.substring(0,38)+"...";
    
    if(featureStoryArticle2Title.length()>39)
        featureStoryArticle2Title=featureStoryArticle2Title.substring(0,38)+"...";    
    
    if(featureStoryArticle3Title.length()>39)
        featureStoryArticle3Title=featureStoryArticle3Title.substring(0,38)+"...";
    
    if(featureStoryArticle1Teaser.length()>104)
        featureStoryArticle1Teaser=featureStoryArticle1Teaser.substring(0,103)+"...";
    
    if(featureStoryArticle2Teaser.length()>104)
        featureStoryArticle2Teaser=featureStoryArticle2Teaser.substring(0,103)+"...";    
    
    if(featureStoryArticle3Teaser.length()>104)
        featureStoryArticle3Teaser=featureStoryArticle3Teaser.substring(0,103)+"...";
    
    if((!(drawImage1.hasContent())||!(drawImage2.hasContent())||!(drawImage3.hasContent()))&&(selectionType.equals("manual"))){
    %>
    
     <%if( WCMMode.fromRequest(request)==WCMMode.EDIT){%>
           <b><%= langText.get("FEATURE_STORY_DETAILS") %></b>
    
     <%}%> 
    <%
    }
    
    else if((!(drawImage1.hasContent())||!(drawImage2.hasContent())||!(drawImage3.hasContent()))&&(selectionType.equals("automatic"))){
    %>
    
        <%if( WCMMode.fromRequest(request)==WCMMode.EDIT){%>
                <b>Please make sure that the images and the other fields details are filled in properly and there are at least 3 feature story articles in the hierarchy.</b>        
         <%}%>
         
    <%
    }
    
    else{
    %> 
         
   <!-- Image Slideshow Section Start From Here -->
        <table id="slideShow" cellpadding="0" cellspacing="0" border="0" >
                    <tr valign="top">
                        <td rowspan="2" width="431" height="360px" valign="top">
                            <div id="slide-img" style="position:relative;">
                                 <div>
                                    <div id="slide-info"></div>                                    
                                    
                                 <img src="<%=imagePath1%>" height="360px" width="420px"/>                                 
                                 </div>                                 
                                 <div id="slide-info1" style="display:none; text-align:left;">
                                     <h2><%=featureStoryArticle1Title%></h2><br />
                                     <%=featureStoryArticle1Teaser%> <a href="<%=featureStoryArticle1Link%>.html"></a>
                                 </div>
                                  
                                 <div id="slide-info2"  style="display:none;">                                    
                                    <h2><%=featureStoryArticle2Title%></h2><br />
                                    <%=featureStoryArticle2Teaser%> <a href="<%=featureStoryArticle2Link%>.html"></a>
                                 </div>
                                 
                                 <div id="slide-info3" style="display:none; text-align:left;">
                                     <h2><%=featureStoryArticle3Title%></h2><br />
                                     <%=featureStoryArticle3Teaser%> <a href="<%=featureStoryArticle3Link%>.html"></a>
                                 </div>
                            </div>
                        <%if(!navFunctionality.equals("disable")){%>
                        <div class="carousel">
                            <ul>
                                <li class="icon selected" id="dot1"><img src="/images/spacer.png" width="1" height="20" alt="" /></li>
                                <li class="icon" id="dot2"><img src="/images/spacer.png" width="1" height="20" alt="" /></li>
                                <li class="icon" id="dot3"><img src="/images/spacer.png" width="1" height="20" alt="" /></li> 
                            </ul>
                        </div>
                        <%
                        }
                        else{  
                        %>
                        <div class="carousel" style="display:none;">
                            <ul>
                                <li class="icon selected" id="dot1"><img src="/images/spacer.png" width="1" height="20" alt="" /></li>
                                <li class="icon" id="dot2"><img src="/images/spacer.png" width="1" height="20" alt="" /></li>
                                <li class="icon" id="dot3"><img src="/images/spacer.png" width="1" height="20" alt="" /></li> 
                            </ul>
                        </div>
                        <%}%> 
                    </td>
                </tr>
                <tr valign="top" align="right">
                    <td style="padding-top:4px;">
                            
                        <div id="slide-img1" style="position:relative">
                            <div class="thumb-info" style="position:absolute;bottom:0px;left:5px;text-align:left;"><div></div></div>
                            <%if(!featureStoryArticle1Link.trim().equals("#") && !featureStoryArticle1Link.trim().equals("") ){%>
                                
                                <a href="javascript:openLink('<%=featureStoryArticle1Link%>')"> <img src="<%=imagePath1%>" class="slideImg" width="183px" height="157px"/></a>
                                
                            <%}else{%>
                                
                                <a href="#"> <img src="<%=imagePath1%>" class="slideImg" width="183px" height="157px"/></a>
                                
                            <%}%>
                        </div> 
                            
                        <div id="slide-img2" style="position:relative">
                            <div class="thumb-info" style="position:absolute;bottom:0px;left:5px;text-align:left;"><div></div></div>
                            <%if(!featureStoryArticle2Link.trim().equals("#") && !featureStoryArticle2Link.trim().equals("") ){%>
                                
                                <a href="javascript:openLink('<%=featureStoryArticle2Link%>')"> <img src="<%=imagePath2%>" class="slideImg" width="183px" height="157px"/></a>
                            <%}else{%>
                                
                                <a href="#"> <img src="<%=imagePath2%>"  class="slideImg" width="183px" height="157px"/></a>                              
                                
                            <%}%>
                        </div>
                            
                        <div id="slide-img3" style="position:relative">
                            <div class="thumb-info" style="position:absolute;bottom:0px;left:5px;text-align:left;"><div></div></div>
                        <%if(!featureStoryArticle3Link.trim().equals("#") && !featureStoryArticle3Link.trim().equals("") ){%>
                            
                            <a href="javascript:openLink('<%=featureStoryArticle3Link%>')"><img src="<%=imagePath3%>" class="slideImg" width="183px" height="157px"/></a>
                           
                        <%}else{%>
                            
                            <a href="#"><img src="<%=imagePath3%>"  class="slideImg" width="183px" height="157px"/></a> 
                            
                        <%}%>
                        </div>
                        <%if(!viewPastStoriesLink.trim().equals("#") && !viewPastStoriesLink.trim().equals("")){%>
                            <div class="slidelink"><a href="javascript:openLink('<%=viewPastStoriesLink%>')"><%=viewPastStoriesTitle%></a></div> 
                        <%}else{%>
                            <div class="slidelink"><a href="#"><%=viewPastStoriesTitle%></a></div> 
                        <%}%>
                    </td> 
                </tr>
                   
        </table> 
<div id="fs1html" style="display:none;"></div>
<div id="fs2html" style="display:none;"></div>
<div id="fs3html" style="display:none;"></div>        
        <div style="clear:both;"></div>
        <!-- Image Slideshow Section Ends Here -->  
  
<script type="text/javascript"> 
     
    var currentSlideImg=1;
    var transitionTime=<%= playSpeed%>; 
    var fadeTime=<%=transitionTime%>;
    var isRunning=false;
    var mainImageLink="";  
    var image1Link="<%=featureStoryArticle1Link%>";
    var image2Link="<%=featureStoryArticle2Link%>";
    var image3Link="<%=featureStoryArticle3Link%>";
   
    // Setup Slide Show
    
      
    $('#slide-img1').hide();
    $('#slide-img1 .thumb-info div').html($('#slide-info1 h2').html());
    $('#slide-img2 .thumb-info div').html($('#slide-info2 h2').html());
    $('#slide-img3 .thumb-info div').html($('#slide-info3 h2').html()); 
    
    $('#slide-info').html($('#slide-info1').html());  
         
    mainImageLink=image1Link;
    $('#dot1').click(function(){    
        currentSlideImg=0;
        slideShow();
          
    });    
    
    $('#dot2').click(function(){    
        currentSlideImg=1;
        slideShow();     
       
    });    
   
    $('#dot3').click(function(){    
        currentSlideImg=2;    
        slideShow(); 
       
    });      
    
    if(!isRunning && transitionTime>0)
        var timeIntervalIdFeatureStory=window.setInterval(slideShow,transitionTime);
    // For slide show functionality
    $('.slideImg').click(function(){        
        
        if(isRunning)
            return;
            
        var slideImgId=$(this).parent().attr('id');
        
        var link="";    
        if(slideImgId=="slide-img1"){
            link=$('#slide-info1 a').attr('href');
        }
        if(slideImgId=="slide-img2"){
            link=$('#slide-info2 a').attr('href');
        }
        if(slideImgId=="slide-img3"){
            link=$('#slide-info3 a').attr('href');
        }
        
        if(link!=""){
            window.location=link;
        }
    });
    $('.thumb-info').mouseout(function(){
        $(this).hide();
    });
        
    $('.slideImg').mouseover(function(){            
        $('.thumb-info',$(this).parent().parent()).show();
                
    });
    
    $('.slideImg').mouseout(function(){        
        $('.thumb-info',$(this).parent().parent()).hide();
        $('.thumb-info').mouseover(function(){         
           $(this).show();
    });    
    });
    $('#slide-img img').click(function(){
        openLink(mainImageLink);         
    });   
    $('#slide-img img').mouseover(function(){
        $(this).css("cursor","pointer");
    });              
    $('#slide-img img').mouseout(function(){
        $(this).css("cursor","default");
    });   
  
    
 
          
</script> 
<%
        }
%>

<script>
String.prototype.startsWith = function(prefix) {
    return this.indexOf(prefix) === 0;
}  
$(document).ready(function(){
    var showCommentCount = "<%=showCommentCount%>";
    if(showCommentCount == "true"){
        var commentCountVal;
        var commentDiv;
        var image1Link="<%=featureStoryArticle1Link%>";
        var image2Link="<%=featureStoryArticle2Link%>";
        var image3Link="<%=featureStoryArticle3Link%>";
        if(image1Link.startsWith("/content")){
            $.ajax({
            url: image1Link,
            type: 'GET',    
            timeout: 10000, 
            cache: true,
            dataType: "html",
            error: function(){
                //window.location.reload();    
            },    
            success: function(data){
                var startIndex = data.indexOf("<!--pagecommentingstart-->");
                var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                var c1Html = data.substring(startIndex,endIndex);
                document.getElementById("fs1html").innerHTML = c1Html;
                commentDiv = $("#fs1html").find(".commentdiv").html();
                commentCountVal = $("#fs1html").find(".commentCountNumber").html();
                if(commentDiv==null || commentDiv==undefined){}
                else
                {
                    if(commentCountVal==null || commentCountVal==undefined)
                    {
                        //alert("Inside Comment Count Value Null");
                        var spanText="<%=langText.get("Add a Comment")%>";
                        
                        var slideInfo1HTML = "<div id='putCommCount1'><div class='commentImgIcon'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle1Link%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                        var slideImage1HTML = "<div id='putCommCount1' style='margin-top:-5px;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle1Link%>#formDiv' class='commentImg'>"+spanText+"</a></div>"
                        $("#slide-info1").append(slideInfo1HTML);    
                        $("#slide-img1 .thumb-info").append(slideImage1HTML);   
                        $('#slide-info').html($('#slide-info1').html());  
                    }
                     
                    else
                    {
                        var spanText;
                        if(commentCountVal>'1')
                             spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                        else
                             spanText= commentCountVal  + " "+"<%=langText.get("comment")%>";
                        var slideInfo1HTML = "<div id='putCommCount1'><div class='commentImgIcon'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle1Link%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                        var slideImage1HTML = "<div id='putCommCount1' style='margin-top:-5px;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle1Link%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>"
                        $("#slide-info1").append(slideInfo1HTML);
                        $("#slide-img1 .thumb-info").append(slideImage1HTML); 
                        $('#slide-info').html($('#slide-info1').html()); 
                    }  
                 }  
                 document.getElementById("fs1html").innerHTML = "";
             }
            });       
        }        
        if(image2Link.startsWith("/content")){        
            $.ajax({
            url: image2Link,
            type: 'GET',    
            timeout: 10000, 
            cache: true,
            dataType: "html",  
            error: function(){
               // window.location.reload();    
            },    
            success: function(data){
                var startIndex = data.indexOf("<!--pagecommentingstart-->");
                var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                var c2Html = data.substring(startIndex,endIndex);
                document.getElementById("fs2html").innerHTML = c2Html;
                commentDiv = $("#fs2html").find(".commentdiv").html();
                commentCountVal = $("#fs2html").find(".commentCountNumber").html();
                if(commentDiv==null || commentDiv==undefined){}
                else
                {
                    if(commentCountVal==null || commentCountVal==undefined)
                    {
                         var spanText="<%=langText.get("Add a Comment")%>";
                        var slideInfo2HTML = "<div id='putCommCount2'><div class='commentImgIcon'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle2Link%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                        var slideImage2HTML = "<div id='putCommCount2' style='margin-top:-5px;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle2Link%>#formDiv' class='commentImg'>"+spanText+"</a></div>"
                        $("#slide-info2").append(slideInfo2HTML);
                        $("#slide-img2 .thumb-info").append(slideImage2HTML); 
                    }
                    else
                    {
                        var spanText;
                        if(commentCountVal>'1')
                             spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                        else
                            spanText= commentCountVal  + " "+"<%=langText.get("comment")%>";
                     
                    var slideInfo2HTML = "<div id='putCommCount2'><div class='commentImgIcon'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle2Link%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>";
                    var slideImage2HTML = "<div id='putCommCount2' style='margin-top:-5px;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle2Link%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>"
                        $("#slide-info2").append(slideInfo2HTML);
                        $("#slide-img2 .thumb-info").append(slideImage2HTML); 
                    }   
               } 
               document.getElementById("fs2html").innerHTML = "";
             }
            });
        }
        if(image3Link.startsWith("/content")){        
            $.ajax({
            url: image3Link,
            type: 'GET',    
            timeout: 10000, 
            cache: true,
            dataType: "html",   
            error: function(){
               // window.location.reload();    
            },    
            success: function(data){
                var startIndex = data.indexOf("<!--pagecommentingstart-->");
                var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                var c3Html = data.substring(startIndex,endIndex);
                document.getElementById("fs3html").innerHTML = c3Html;
                commentDiv = $("#fs3html").find(".commentdiv").html();
                commentCountVal = $("#fs3html").find(".commentCountNumber").html();
                if(commentDiv==null || commentDiv==undefined){}
                else
                {
                    if(commentCountVal==null || commentCountVal==undefined)
                    {
                         var spanText="<%=langText.get("Add a Comment")%>";
                        var slideInfo3HTML = "<div id='putCommCount3'><div class='commentImgIcon'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle3Link%>#formDiv' class='commentImg'>"+spanText+"</a></div>";
                        var slideImage3HTML = "<div id='putCommCount3' style='margin-top:-5px;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle3Link%>#formDiv' class='commentImg'>"+spanText+"</a></div>"
                        $("#slide-info3").append(slideInfo3HTML);
                        $("#slide-img3 .thumb-info").append(slideImage3HTML); 
                    }
                    else
                    {
                        var spanText;
                        if(commentCountVal>'1')
                            spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                        else
                             spanText= commentCountVal  + " "+"<%=langText.get("comment")%>";
                     
                    var slideInfo3HTML = "<div id='putCommCount3'><div class='commentImgIcon'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle3Link%>#commentSecDiv' class='commentImg'><b>"+spanText+"</b></a></div>";
                    var slideImage3HTML = "<div id='putCommCount3' style='margin-top:-5px;'><div class='commentImgIconThumb'>&nbsp</div><a style='font-size:10px;color:#004276;font-weight:bold !important;' href='<%=featureStoryArticle3Link%>#commentSecDiv' class='commentImg'>"+spanText+"</a></div>"
                        $("#slide-info3").append(slideInfo3HTML);
                        $("#slide-img3 .thumb-info").append(slideImage3HTML);
                    }  
                 }  
                 document.getElementById("fs3html").innerHTML = "";
             }
            });
        }
    }    
})
        
</script>                            

 

<%        
    }  
%>           
<%!
   public Image drawImage(Image image, String ddClassName, Design currentDesign, Design resourceDesign, Style currentStyle){
       image.addCssClass(ddClassName);
       image.loadStyleData(currentStyle);
       image.setSelector(".img");
       if (!currentDesign.equals(resourceDesign)) {
            image.setSuffix(currentDesign.getId());
         }     
       return image;       
   }
%>