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
                
<%

    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "flash";
    String videoHref = "";//To store path of video to be embedded
    String extUrl =  properties.get("externalUrl", "");      
    Download videoObject = new Download(resource);//object of the file uploaded in the dialog
    String videoPath = properties.get("videoPath","");
    if (videoObject.hasContent()) {
        videoObject.addCssClass(ddClassName);
        videoHref = Text.escape(videoObject.getHref(), '%', true); //Get the path of video uploaded       
    }
    else if(!"".equals(videoPath))
    {
        videoHref = videoPath;//If external URL is given get the video from the externam URL
    }
    else if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><div class="cq-flash-placeholder <%= ddClassName %>" style="text-align: left;"></div><%
    } 
    String width = properties.get("width", "500");//Get the width enetered in the dialog
    String height = properties.get("height", "300");//Get the height enetered in the dialog
    String akamaiImg = properties.get("akamaiImg", "");
    String bottomPadding = properties.get("btmpadding","0");
    if(!"".equals(bottomPadding))
    {
        bottomPadding = "padding-bottom: "+bottomPadding+"px;";
    }
     
    String altImageHref = "/images/0.gif";//To store alternate image
    Image altImage = new Image(resource,"stillimage");
    if(altImage.hasContent())
    {
        altImage.setSelector(".img");
        altImageHref = altImage.getHref();//Get path of the external image uploaded
    }
    else if(!"".equals(akamaiImg))
        altImageHref = akamaiImg;
    String shareLink = request.getScheme() + "://" + request.getServerName() + currentPage.getPath() + ".html";
    String backgroundColor =  properties.get("bgColor", "");  
     
    if(!"".equals(backgroundColor))
        backgroundColor = "background-color:#" + backgroundColor + ";" ;
    
if(!"".equals(videoHref))
{
   
    String showAsPopup = properties.get("showpopup", "no");
    if("no".equals(showAsPopup) )
    {
%> 
        <table cellspacing="0" cellpadding="0" width="100%">
          <tr height="100%">
            <td width="50%">    
              <table align="right" cellspacing="0" cellpadding="0" height="100%" width="100%">  
                <tr height="240px">
                    <td width="100%" valign="top" align="center">

                        <!--Code for rendering video--> 
                        
                        <div id="<%=currentNode.getName()%>_videoplayer" style="<%=backgroundColor%> ">
                            <object width="<%=width%>" height="<%=height%>">
                                <param name="allowfullscreen" value="true">
                                <param name="wmode" value="opaque"> 
                                <param name="allowscriptaccess" value="always">
                                <param name="movie" value="/swf/McDVideoPlayer.swf">
                                <param name="flashvars" value="videoPath=<%=videoHref%>&amp;imagePath=<%=altImageHref%>&amp;shareLink=<%=shareLink%>">
                                <embed src="/swf/McDVideoPlayer.swf" 
                                    flashvars="videoPath=<%=videoHref%>&amp;imagePath=<%=altImageHref%>&amp;shareLink=<%=shareLink%>"
                                    type="application/x-shockwave-flash" 
                                    allowfullscreen="true" 
                                    scale="noscale" 
                                    wmode="opaque" 
                                    allowscriptaccess="always" 
                                    width="<%=width%>" height="<%=height%>">
                            </object>
                        </div>
                                        
                    </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
<%
    }
    else {
        String title = properties.get("title", "");
        String linkText = properties.get("linktext", "");
        String description = properties.get("videodescription","");
        %>
        <div class="article_preview">
        <%
        Image thumbImage = new Image(resource,"thumbimage");
        String thumbImageHref = "";
        if(thumbImage.hasContent())
        {
            thumbImage.setSelector(".img");
%>
            <br>
            <a class="article_preview_image <%=currentNode.getName()%>_video" href="<%=currentPage.getPath()%>.embeddedvideo.html?path=<%=videoHref%>&imagePath=<%=altImageHref%>&link=<%=currentPage.getPath()%>.html&width=<%=width%>&height=<%=height%>" title="<%=title%>"><% thumbImage.draw(out); %></a>
<%
                 
        }
%>
        <script type="text/javascript" language="javascript">        
            $(document).ready(function() { 
                $("a.<%=currentNode.getName()%>_video").mcdColorbox({ iframe: true, innerWidth: 550, innerHeight: 320});                    
            });
        </script>
        
            <h3><%=title%></h3>
            <p class="preview"><%=description%></p>
            <p>
                <a class="preview linkcolor <%=currentNode.getName()%>_video" href="<%=currentPage.getPath()%>.embeddedvideo.html?path=<%=videoHref%>&imagePath=<%=altImageHref%>&link=<%=currentPage.getPath()%>.html&width=<%=width%>&height=<%=height%>" title="<%=title%>"><%=linkText%></a>
            </p>
        </div>
        <div class="clear"></div>    
<%
    }  
}
else if(!"".equals(extUrl))
{
    String title = properties.get("title", "");
    String linkText = properties.get("linktext", "");
    String description = properties.get("videodescription","");
    String anchorClass = "";
    if(!extUrl.startsWith("/content"))        
            if(!bumperEncryption.isBumperLink(extUrl)) 
                anchorClass = "external";
    %>
    <div class="article_preview">
    <%
    Image thumbImage = new Image(resource,"thumbimage");
    String thumbImageHref = "";
    if(thumbImage.hasContent())
    {
        thumbImage.setSelector(".img");
        %><a class="article_preview_image <%=anchorClass %>" target="_blank" href="<%=extUrl%>" ><% thumbImage.draw(out); %></a><%                   
    }
%>
    
    
        <h3><%=title%></h3>
        <p class="preview"><%=description%></p>
        <p>         
             <a class="preview linkcolor <%=anchorClass %>" target="_blank" href="<%=extUrl%>"><%=linkText%></a>
        </p>
    </div>
    <div class="clear"></div>    
<%

}
%> 
    <div class="module_spacing" style="<%=bottomPadding%>"></div>