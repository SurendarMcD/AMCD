<%@ page import="com.day.cq.wcm.foundation.Download,
        com.day.cq.wcm.api.components.DropTarget,
        com.day.cq.wcm.api.WCMMode,
        com.day.text.Text,
        com.day.cq.wcm.foundation.Paragraph,
        org.apache.commons.lang.StringEscapeUtils,
        com.day.cq.wcm.api.components.Toolbar,
        java.util.Map,com.day.cq.wcm.foundation.Image" %><%
%> 
<%@include file="/apps/mcd/global/global.jsp"%>
  
<style>
    video {
        width: 100%;
    }
</style>             
<%

    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "flash";
    String videoHref = "";//To store path of video to be embedded
    String extUrl =  properties.get("externalUrl", "");      
    Download videoObject = new Download(resource);//object of the file uploaded in the dialog
    String videoPath = properties.get("videoPath","");
    if (videoObject.hasContent()){
        videoObject.addCssClass(ddClassName);
        videoHref = Text.escape(videoObject.getHref(), '%', true); //Get the path of video uploaded       
    }
    else if(!"".equals(videoPath)){
        videoHref = videoPath;//If external URL is given get the video from the externam URL
    }
    else if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><div class="cq-flash-placeholder <%= ddClassName %>" style="text-align: left;"></div><%
    } 
    String width = properties.get("width", "100");//Get the width enetered in the dialog
    if(!"".equals(width)){
        width = "width:"+width+"%;height:auto;";
    }
    String bottomPadding = properties.get("btmpadding","0");
    if(!"".equals(bottomPadding)){
        bottomPadding = "padding-bottom: "+bottomPadding+"px;";
    }
     
    String altImageHref = "/images/0.gif";//To store alternate image
    Image altImage = new Image(resource,"stillimage");
    if(altImage.hasContent()){
        altImage.setSelector(".img");
        altImageHref = altImage.getHref();//Get path of the external image uploaded
    }
    
    String eventCategory = properties.get("event",currentPage.getTitle());
        
    if(!"".equals(videoHref)){
%>
        <video style="<%=width%>" id="<%=currentNode.getName()%>" data-gacode="<%=videoHref%>" poster="<%=altImageHref%>" controls="controls"> 
           <source src="<%=videoHref%>" type="video/mp4"> 
        </video>        
<%        
    }
%> 
    <div class="module_spacing" style="<%=bottomPadding%>"></div>
    
    
<script type="text/javascript" language="javascript">        
            $(document).on('click', '#<%=currentNode.getName()%>', function (e) {
                var video = $(this).get(0);
                if (video.paused === false) {
                    video.pause();
                } else {
                    video.play();
                }
            
                return false;
            });
            $("#<%=currentNode.getName()%>").click(function(){ 
                var ga_code = $(this).attr('data-gacode'); 
                if(typeof ga_code != "undefined" && ga_code != "NA" && ga_code != "") {
                    _gaq.push(['_trackEvent', ga_code , 'click', "<%=eventCategory%>"]);
                }
            });
</script>     