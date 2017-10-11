<%--
 
  Text-Image component

  Combines the text and the image component 

--%><%@ page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat,
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService,
    org.apache.commons.lang.StringEscapeUtils,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.WCMMode,
    org.apache.sling.api.resource.ResourceUtil,
    org.apache.sling.api.resource.ValueMap,
    java.util.Random"%><%
%><%@include file="/apps/mcd/global/global.jsp"%>
<style>
.image_left{
float:none;
}   
</style>  
<%!
public String getRandom(){
    //note a single Random object is reused here
    Random randomGenerator = new Random();
    int randomInt = randomGenerator.nextInt(10000);    
    return String.valueOf(randomInt);
}
%>

<%  
    String randomNumber = getRandom();
    //Out of box code to intialize classname
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";
    String cssClass="";
    Boolean bottomShow=false;//To check whther image is to be bottom aligned or not
    String imageAlignment =properties.get("cq:cssClass", "");//To get the alignment of image
    //To select the font to be used for the title ie. heading1,2 or 3
    String headingTitle =properties.get("heading", "");
    String mainTitle =properties.get("title", "");//To enter the title for the component
    String titleAlign =properties.get("titleAlign", "");//To select the alignment of title
    //To store the color of the theme to be used for background and round corners
    String themeColor=properties.get("themecolor", "");
    themeColor=themeColor.equalsIgnoreCase("No Color")?"":themeColor;
    //To check whether round corners should be included or not
    Boolean roundCorners=properties.get("checkRoundCorners", false);
    //To check whether text should be inline aligned or not
    Boolean textInlineAlign=properties.get("inlineAlign", false);
    //Padding to be included in the component
    int leftPadding =properties.get("paddingLeft",0);
    int rightPadding =properties.get("paddingRight",0);
    int topPadding =properties.get("paddingTop",0);
    int bottomPadding =properties.get("paddingBottom",0);
    //Getting padding to be included between text and image
    int txtImgPadding =properties.get("paddingTxtImg",5);
    //Padding to be applied for the title
    int titlePadding =properties.get("paddingTitle",0);
    String titlePaddingStyle=(titlePadding==0)?"":"padding-bottom:"+titlePadding+"px";
    String paddingStyle="";//Type of padding to be applied
    String centerAlign=(imageAlignment.equalsIgnoreCase("image_bottom") ||imageAlignment.equalsIgnoreCase("image_top"))?
    properties.get("centerAlign",""):"";//for center alignment of image
    
    if(imageAlignment.equalsIgnoreCase("image_bottom")||imageAlignment.equalsIgnoreCase("image_top"))
    {
        bottomShow =imageAlignment.equalsIgnoreCase("image_bottom")?true:false;
        paddingStyle=imageAlignment.equalsIgnoreCase("image_bottom")?"padding-top:"+txtImgPadding:"padding-bottom:"+txtImgPadding;
    }
    else if(imageAlignment.equalsIgnoreCase("image_left")||imageAlignment.equalsIgnoreCase("image_right"))
    {
        paddingStyle=imageAlignment.equalsIgnoreCase("image_left")?"padding-right:"+txtImgPadding:"padding-left:"+txtImgPadding;   
    }
    if (textInlineAlign)
    {
        textInlineAlign=(imageAlignment.equalsIgnoreCase("image_left")||imageAlignment.equalsIgnoreCase("image_right"))?true:false;
    }
    
    //out of box code for rendering image
    Image img = new Image(resource, "image");
    final DiffInfo diffInfo = resource.adaptTo(DiffInfo.class);
    final Image diffImg = (diffInfo == null || diffInfo.getContent() == null ? null : new Image(diffInfo.getContent(), "image"));
    final DiffService diffService = (diffInfo == null ? null : sling.getService(DiffService.class));
    //variables intialized for rendering text
    boolean isRichText= false;
    String text = "";
    
%>
    <div id="textimagecontainer" style="padding:<%=topPadding %>px <%=rightPadding %>px <%=bottomPadding%>px <%=leftPadding %>px">
        <%
        if(roundCorners)
        {
        %>
            <div class="textimageRoundCorner" >
                <b class="roundcorner<%=themeColor %>" id="textimagetop0<%=themeColor %>">
                <b class="roundcorner<%=themeColor %>1" id="textimagetop1<%=themeColor %>"><b></b></b>
                <b class="roundcorner<%=themeColor %>2" id="textimagetop2<%=themeColor %>"><b></b></b>
                <b class="roundcorner<%=themeColor %>3" id="textimagetop3<%=themeColor %>"></b>
                <b class="roundcorner<%=themeColor %>4" id="textimagetop4<%=themeColor %>"></b>
                <b class="roundcorner<%=themeColor %>5" id="textimagetop5<%=themeColor %>"></b></b>
            </div>
        <%
        }
        %>
            <div class="textimagemain<%=themeColor %>" id="textimagemain<%=themeColor %>" >
        <%
            if(!headingTitle.trim().equalsIgnoreCase("") && !((imageAlignment.equalsIgnoreCase("image_left_inline") || imageAlignment.equalsIgnoreCase("image_right_inline"))&& (img.hasContent() || WCMMode.fromRequest(request) == WCMMode.EDIT) ))
            {
            %>
                <div class="<%=headingTitle %>" style="text-align: <%=titleAlign %>; <%=titlePaddingStyle %>"> <%=mainTitle %></div>
            <%
            }
                  
            
                if (properties.get("text", "").length() > 0)
                {
                    text = properties.get("text", String.class);
                    isRichText = properties.get("textIsRich", "false").equals("true");
                    if ( diffInfo != null )
                    {
                        final ValueMap map = ResourceUtil.getValueMap(diffInfo.getContent());
                        final String diffOutput = DiffInfo.getDiffOutput(diffService, diffInfo, text, isRichText, map.get("text", ""));
                        if ( diffOutput != null )
                        {
                            text = diffOutput;
                            isRichText = true;
                        }
                    }
                    %><%
                } else if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
                    %><img src="/libs/cq/ui/resources/0.gif" class="cq-text-placeholder <%= ddClassName %>" alt=""><%
                }
              //If image is bottom Aligned 
            if(bottomShow && !text.equals(""))
            {
                out.println(renderText(currentNode.getName()+randomNumber,isRichText,text));
            }
            if( (imageAlignment.equalsIgnoreCase("image_right_inline")||imageAlignment.equalsIgnoreCase("image_left_inline")) && !headingTitle.trim().equalsIgnoreCase(""))
            {//For title inline align
            %>  
            <div id="titleImageInline<%=currentNode.getName()+randomNumber %>" style="<%=titlePaddingStyle %>;overflow:hidden;text-align: <%=titleAlign %>;"> 
            <%  
            }
              
              //Out of box code for rendering image
            if (img.hasContent() || WCMMode.fromRequest(request) == WCMMode.EDIT)
            {
                cssClass = "image ";
                if ( diffInfo != null )
                {
                    if ( diffInfo.getType() == DiffInfo.TYPE.ADDED ) {
                        cssClass += "imageAdded ";
                    } else if ( diffInfo.getType() == DiffInfo.TYPE.REMOVED ) {
                        cssClass += "imageRemoved ";
                    } else {
                        final String path1 = (img.getResource() != null ? img.getHref() : "");
                        final String path2 = (diffImg != null && diffImg.getResource() != null ? diffImg.getHref() : "");
                        if ( !path1.equals(path2) ) {
                            if ( path1.length() == 0 ) {
                                img.addCssClass("imageRemoved");
                            } else if ( path2.length() == 0 ) {
                                img.addCssClass("imageAdded");
                            } else {
                                int pos = path2.indexOf("jcr:frozenNode/");
                                if ( pos == -1
                                     || !path1.endsWith(path2.substring(pos+14))
                                     || img.getLastModified().compareTo(diffImg.getLastModified()) != 0 ) {    
                                    img.addCssClass("imageChanged");
                                }
                            }
                        } else if ( img.getLastModified().compareTo(diffImg.getLastModified()) !=  0 ) {
                            img.addCssClass("imageChanged");                
                        }
                    }
                }
            %>
                <div id="<%= cssClass %><%=currentNode.getName()+randomNumber %>" class="<%= cssClass %> <%= properties.get("cq:cssClass", "") %>" style="<%=paddingStyle %>px; <%=centerAlign %>">
            <%
                img.loadStyleData(currentStyle);
                // add design information if not default (i.e. for reference paras)
                if (!currentDesign.equals(resourceDesign)) {
                    img.setSuffix(currentDesign.getId());
                }
                img.addCssClass(ddClassName);
                img.setSelector(".img");
                String title = img.getTitle();
                if ( title.length() > 0 ) {
                    title = img.getTitle(true);
                }
                if ( diffInfo != null ) {
                    final String other = (diffImg == null ? "" : diffImg.getTitle(true));
                    final String diffOutput = DiffInfo.getDiffOutput(diffService, diffInfo, title, false, other);
                    if ( diffOutput != null ) {
                        title = diffOutput;
                    }
                }
                //if (title.length() > 0) {
                    %><!--<strong><%= title %></strong><br>--><%
                //}
                %><%
                
                if(imageAlignment.equalsIgnoreCase("image_right_inline"))
                {
                   out.println("<span style='position:relative;' class='"+headingTitle+"'>"+mainTitle+"</span>"); 
                }
                img.draw(out);
                if(imageAlignment.equalsIgnoreCase("image_left_inline"))
                {
                    out.println("<span style='position:relative;' class='"+headingTitle+"'>"+mainTitle+"</span>");
                }
                %><br><%
                String desc = img.getDescription();
                if ( desc.length() > 0 ) {
                    desc = img.getDescription(true);
                }
                if ( diffInfo != null ) {
                    final String other = (diffImg == null ? "" : diffImg.getDescription(true));
                    final String diffOutput = DiffInfo.getDiffOutput(diffService, diffInfo, desc, false, other);
                    if ( diffOutput != null ) {
                        desc = diffOutput;
                    }
                }
                if (desc.length() > 0) {            
                    %><small><%= desc %></small><%
                }
                %></div>
            <%
            }
            if( (imageAlignment.equalsIgnoreCase("image_right_inline")||imageAlignment.equalsIgnoreCase("image_left_inline")) && !headingTitle.trim().equalsIgnoreCase(""))
            {//For title inline align
                
                %>
            </div>
                <%
            }
              
          //If image is not bottom Aligned
            if(!bottomShow && !text.equals(""))
            {
                out.println(renderText(currentNode.getName()+randomNumber,isRichText,text));
            }  
            
    %>
        </div>
    <% 
        if(roundCorners)
        {
        %>
            <div class="textimageRoundCorner" >
                <b class="roundcorner<%=themeColor %>" id="textimagebottom0<%=themeColor %>">
                <b class="roundcorner<%=themeColor %>5" id="textimagebottom5<%=themeColor %>"></b>
                <b class="roundcorner<%=themeColor %>4" id="textimagebottom4<%=themeColor %>"></b>
                <b class="roundcorner<%=themeColor %>3" id="textimagebottom3<%=themeColor %>"></b>
                <b class="roundcorner<%=themeColor %>2" id="textimagebottom2<%=themeColor %>"><b></b></b>
                <b class="roundcorner<%=themeColor %>1" id="textimagebottom1<%=themeColor %>"><b></b></b></b>
            </div>
        <%
        }
    %>
    </div>
    <div class="clear"></div>

<script>

    var inlineAlign=<%=textInlineAlign %>;//script used for inline alignment of text
    if(inlineAlign)
    {
        var img = document.getElementById('image <%=currentNode.getName()+randomNumber%>');
        if(img)
        var imageHeight = img.scrollHeight;//get image height
        var text = document.getElementById('text<%=currentNode.getName()+randomNumber%>');
        if(text)
        var textHeight = text.scrollHeight;//get height of text
        var padding;
        if(imageHeight>textHeight)
        { 
        padding= (imageHeight- textHeight)/2;//get padding to be applied
        }
        else
        padding=0;
        if(text)
        text.style.paddingTop = padding+'px';//apply padding to text
    }

    
$('#titleImageInline<%=currentNode.getName()+randomNumber %> img').load(function(){
//$(function(){ 
var imageAlignment='<%=imageAlignment%>';
if(imageAlignment=='image_right_inline' || imageAlignment=='image_left_inline')
{   
    var spanDiv=$('#titleImageInline<%=currentNode.getName()+randomNumber %> span');//added for the inline alignment of image and text
    var imgDiv=$('#titleImageInline<%=currentNode.getName()+randomNumber %> img');
   
    if(imgDiv != null)
    {         
        var imgHeight=imgDiv.height();
        var spanHeight=spanDiv.height();

   //     alert(imgHeight);
   //     alert(spanHeight);
            
        if(imgHeight>spanHeight)
        {    
            var bottom=(imgHeight-spanHeight)/2;            
            spanDiv.css('bottom',bottom+"px");                       
        }
        else
        {   
            spanDiv.css('bottom',bottom);
        }
    }
    else
    {  
        spanDiv.css('bottom',bottom);
    }
}
});

</script>

<%!
    //Function used for rendering text
    public String renderText(String currentNodeName, boolean isRichText, String text)
    {  
       StringBuffer textContent = new StringBuffer(); 
       textContent.append("\n\r<div id='text"+currentNodeName+"' class='text'>");//rendering text
       if (isRichText) {
           textContent.append(text);
       }
       else {//out of box code for text 
           TextFormat fmt = new TextFormat();
           fmt.setTagUlOpen("<ul>");
           fmt.setTagOlOpen("<ol start=\"%s\">");
           textContent.append(fmt.format(text));
       }
       textContent.append("\n\r</div>");
       return textContent.toString();
    }
%>

