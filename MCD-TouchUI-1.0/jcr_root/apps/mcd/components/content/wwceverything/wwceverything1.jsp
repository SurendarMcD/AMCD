<%--
 
  Everything component        
  
  Combines the text and the image component with various aligment and styling options

--%><%@ page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat, 
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService,
    org.apache.commons.lang.StringEscapeUtils,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.WCMMode,
    org.apache.sling.api.resource.ResourceUtil,
    org.apache.sling.api.resource.ValueMap,
    com.day.image.Layer,
    com.day.cq.wcm.foundation.Download,
    com.day.text.Text,
    java.util.Random" %><%
%>
<%@include file="/apps/mcd/global/global.jsp"%>

<%!
public String getRandom(){
    //note a single Random object is reused here
    Random randomGenerator = new Random();
    int randomInt = randomGenerator.nextInt(10000);    
    return String.valueOf(randomInt);
}
%>

<%!
    //Function used for rendering text
    public String renderText(String currentNodeName, boolean isRichText, String text, String imageAlignment, ValueMap properties)
    {  
        int topPaddingText =properties.get("paddingTopText",5);
        int rightPaddingText =properties.get("paddingRightText",5);
        int bottomPaddingText =properties.get("paddingBottomText",5);
        int leftPaddingText =properties.get("paddingLeftText",5);
        String paddingStyle="padding: "+topPaddingText+"px "+rightPaddingText+"px "+bottomPaddingText+"px "+leftPaddingText+"px;";
        

        String openDiv="";
        String closeDiv="";
        StringBuffer textContent = new StringBuffer(); 
        if (imageAlignment.contains("top"))//image is top aligned so text will come in the next table row     
            openDiv="<tr><td class='EverythingComponenttext' valign='top' >";
        if (imageAlignment.contains("bottom"))
            openDiv="<td class='EverythingComponenttext' valign='top' >";

       openDiv+="<div id='text"+currentNodeName+"' class='everythingText' style='"+paddingStyle+"'>";
       textContent.append(openDiv);//rendering text
       if (isRichText) {
           textContent.append(text);
       }
       else {//out of box code for text 
           TextFormat fmt = new TextFormat();
           fmt.setTagUlOpen("<ul>");
           fmt.setTagOlOpen("<ol start=\"%s\">");
           textContent.append(fmt.format(text));
       }
       closeDiv="</div></td>";
       if (imageAlignment.contains("bottom"))
           closeDiv+="</tr>";

       textContent.append(closeDiv);
       return textContent.toString();
       
    }
%>

<%
Page parentPage = currentPage.getAbsoluteParent(1);

    String randomNumber = getRandom();
    //randomNumber=currentNode.getName(); 
    //Out of box code to intialize classname
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";
    String ddClassNameFile = DropTarget.CSS_CLASS_PREFIX + "file";
    String cssClass="";
    Boolean bottomShow=false;//To check whether image is to be bottom aligned or not
    String imageAlignment =properties.get("imagePosition", "");//To get the alignment of image
    //Padding to be included in the component
    int leftPadding =properties.get("paddingLeft",0);
    int rightPadding =properties.get("paddingRight",0);
    int topPadding =properties.get("paddingTop",0);
    int bottomPadding =properties.get("paddingBottom",0);
       //Margin to be included in the component
    int leftMargin =properties.get("marginLeft",0);
    int rightMargin =properties.get("marginRight",0);
    int topMargin =properties.get("marginTop",0);
    int bottomMargin =properties.get("marginBottom",0);

    int leftPaddingImage =properties.get("paddingLeftImage",0);
    int rightPaddingImage =properties.get("paddingRightImage",0);
    int topPaddingImage =properties.get("paddingTopImage",0);
    int bottomPaddingImage =properties.get("paddingBottomImage",0);

    int topPaddingText =properties.get("paddingTopText",5);
    int rightPaddingText =properties.get("paddingRightText",5);
    int bottomPaddingText =properties.get("paddingBottomText",5);
    int leftPaddingText =properties.get("paddingLeftText",5);
    
    int topPaddingTitle =properties.get("paddingTopTitle",10);
    int rightPaddingTitle =properties.get("paddingRightTitle",10);
    int bottomPaddingTitle =properties.get("paddingBottomTitle",10);
    int leftPaddingTitle =properties.get("paddingLeftTitle",10);
 

    String imgWidth = properties.get("imageSize","1.0");
    boolean createThumbnail=properties.get("createThumbnail",false);

    //String cornerRounding=properties.get("cornerRounding","0");
    boolean includeCorner=properties.get("includeCorner",false);
    //boolean includeCorner=false;
    //if(cornerRounding!=null && !cornerRounding.equals("0"))includeCorner=true;
    int roundingFactor = 3 * 4;
    //if(includeCorner) {
    //  roundingFactor = Integer.valueOf(cornerRounding).intValue()*4;
    //}
    
    String imageLink = properties.get("imageLink","");
    String anchorClass="";
     //imageLink = bumperEncryption.getBumperLink(imageLink, parentPage.getName());
    //commented 7/22 ECW to stop external link warning
    // if(!( imageLink.startsWith("/content") || imageLink.startsWith("javascript:")  )) 
    //    if(!bumperEncryption.isBumperLink(imageLink)) 
    //            anchorClass = "class='external'"; 
    String captionAlignment = properties.get("captionAlignment","");
    //String textAlign = properties.get("textAlign","");
    String textColor = properties.get("textColor","");
    String backgroundColor = properties.get("backgroundColor","");
    String anchor = properties.get("anchor","");
    String borderSize = properties.get("borderSize","0");
    String borderColor = properties.get("borderColor","");
    if(!borderColor.equals("")){
        borderColor+="border";
    }else{
        if(!borderSize.equals("0"))borderColor+="sitecolor0border";//default to black (sitecolor0)
    }
    String borderTitleColor = properties.get("borderTitleColor","");
    String borderTitleAlign = properties.get("borderTitleAlign","");
    String paragraphTitle = properties.get("paragraphTitle","");
    String mainTitle =properties.get("title", "");//To enter the title for the component
    String titleAlign =properties.get("titleAlign", "");//To select the alignment of title
    //String titleFontSize =properties.get("titleFontSize", "");
    String separatorColor =properties.get("separatorColor", "");
    String titleColor =properties.get("titleColor", "");
    String titleBackgroundColor =properties.get("titleBackgroundColor", "");
    String titleType =properties.get("titleType", "");
    String separatorWidth=properties.get("separatorWidth", "");
    String width="auto";
    String imagePosition = "";
 
    String akamaiImagePath =properties.get("akamaiImage", "");
    String imagePath="";
    if(imageAlignment.toLowerCase().contains("left"))
        imagePosition="left";
    else if(imageAlignment.toLowerCase().contains("right"))
        imagePosition="right";
    else if(imageAlignment.toLowerCase().contains("top") || imageAlignment.toLowerCase().contains("bottom"))
        imagePosition="center";
    
    bottomShow = imageAlignment.contains("bottom");
    
    if(imageAlignment.equals(""))bottomShow=true; //added default for in-place editing of new paragraph
    
    

     
    //out of box code for rendering image
    Image img = new Image(resource, "image");
    final DiffInfo diffInfo = resource.adaptTo(DiffInfo.class);
    final Image diffImg = (diffInfo == null || diffInfo.getContent() == null ? null : new Image(diffInfo.getContent(), "image"));
    final DiffService diffService = (diffInfo == null ? null : sling.getService(DiffService.class));

    //variables intialized for rendering text
    boolean isRichText= false;
    String text = "";

    //For attaching uploaded file with the image
    Download dld = new Download(resource);
    //not sure this working correctly--seems to be affecting background color, too
    /*if(!textColor.equals(""))
    {//included to add custom text color in the p tag of rich text editor
%> 
    <!--style type="text/css">
    #text<%=currentNode.getName()%> p
    {
    color:#<%=textColor%>
    }
    </style-->
<%   
      }
    */
     
     %>
       <%
       String borderstyle1="";
       String borderstyle2="";
       if(includeCorner){ 
       //IE re-render the rounded corners if they are tag-level styles, rather than classes 
           borderstyle1="overflow:hidden;BORDER-STYLE: solid;BORDER-WIDTH: "+borderSize+"px;";
           borderstyle2="overflow:hidden;BORDER-STYLE: solid;BORDER-WIDTH: "+borderSize+"px "+borderSize+"px 0px "+borderSize+"px;";
           borderstyle2+="margin: -"+borderSize+"px;";
          
          %>
           <STYLE>
               .everythingmainchecked<%= randomNumber%>{
                -webkit-border-radius: <%=roundingFactor %>px; 
                -moz-border-radius: <%=roundingFactor %>px;
                z-index: 10;
                }
               .everyThingHeaderRounded<%= randomNumber%>{
                z-index: 20;
                -webkit-border-top-right-radius: <%=roundingFactor %>px; 
                -webkit-border-top-left-radius: <%=roundingFactor %>px; 
                -moz-border-radius-topright: <%=roundingFactor %>px;  
                -moz-border-radius-topleft: <%=roundingFactor %>px;  
                }
            </STYLE> 
            <%
            }
            %>
    <div id="everythingcontainer_<%=randomNumber%>" style="padding:<%=topPadding %>px <%=rightPadding %>px <%=bottomPadding %>px <%=leftPadding %>px;margin:<%=topMargin %>px <%=rightMargin %>px <%=bottomMargin %>px <%=leftMargin %>px" >
      <%if(includeCorner){  
          %>
 
            <div class="everythingmainchecked<%= randomNumber%> <%=backgroundColor%> <%=borderColor %>" id="everythingmain<%=randomNumber %>" style="<%=borderstyle1 %>">
      <% } else { %>
            <div class="everythingmain <%=backgroundColor%> <%=borderColor %>" id="everythingmain" style="overflow:hidden; border-width:<%=borderSize %>px;border-style:solid;">
      <% }%>
      <%
        if (!anchor.equals("")) {
      %>
            <a name="<%=anchor%>" ><div style="display:none;"><%=anchor%></div></a>
      <%
        }
        if(!mainTitle.trim().equalsIgnoreCase("")) {
            String titleColorClass="style='";
            titleColorClass+="padding:0px;";
            //String titleColorClass="";
            //titleColorClass="style='";
            
            String titleStyle="text-align:"+titleAlign+"; ";
            //titleStyle+="padding:"+topPaddingText+"px "+rightPaddingText+"px "+bottomPaddingText+"px "+leftPaddingText+"px; ";
            titleStyle+="padding:"+topPaddingTitle+"px "+rightPaddingTitle+"px "+bottomPaddingTitle+"px "+leftPaddingTitle+"px; ";
            
            if(!titleColor.equals("default"))titleColorClass+="color:"+titleColor;
            titleColorClass+="'";
      %>
         <% if(includeCorner){ %>
            <div id="EverythingParagradiv<%=randomNumber %>" class="
            <%
            if(!titleBackgroundColor.equals("")){
            titleStyle+=borderstyle2;
            %>
                everyThingHeaderRounded<%= randomNumber%>  <%=titleBackgroundColor %>
            <%
            }
            %>
            <%=borderColor %> <%=titleType %> " style="<%=titleStyle %>">
               <span class="<%=titleType %>" <%=titleColorClass%>><%=mainTitle %></span>              
             </div>
         <% }else { %>                 
            <div class="<%=titleType %> <%=titleBackgroundColor %>" style="<%=titleStyle %>"><span <%=titleColorClass%>><%=mainTitle %></span></div>
         <% }%>
      <%
        }

        if(!separatorWidth.trim().equalsIgnoreCase("")&& !separatorWidth.trim().equalsIgnoreCase("0")) { 
      %>
            <div id="EverythingSeparator" class="<%=separatorColor %> seperator<%= randomNumber%>" style="height:<%=separatorWidth%>px; " ></div>           
      <%
        }
        if (properties.get("text", "").length() > 0) {
            text = properties.get("text", String.class);
            //text = bumperEncryption.getBumperRichLink(text);
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
      %>
           <img src="/libs/cq/ui/resources/0.gif" class="cq-text-placeholder <%= ddClassName %>" alt="">
      <%
        }
      %>
        <table class="everythingtable" cellspacing="0" cellpadding="0"> 
          <tr>
          <%
            //If image is bottom Aligned
            if(bottomShow && !text.equals("")) {
                out.println(renderText(currentNode.getName(),isRichText,text,imageAlignment,properties));
            }
            //Out of box code for rendering image
            if (img.hasContent() || WCMMode.fromRequest(request) == WCMMode.EDIT ||!(akamaiImagePath.equals("")))
            {
                if(img.hasContent())
                {
                       //try/catch added 3/4/11 ECW
                       try{
                           Layer layer = img.getLayer(true,true,true);
                           if(layer!=null){
                               width= (layer.getWidth()*Double.parseDouble(imgWidth))+"px";
                               img.addAttribute("width",width.replace("px",""));
                           }
                       }catch(Exception e){
                           out.println(e.getMessage());
                       }
                }
                
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
                if (bottomShow)
                {
                %>
                    <tr>
                <%
                }
                if(imageAlignment.equalsIgnoreCase("left") || imageAlignment.equalsIgnoreCase("right"))
                {
                %>
                    <td valign="top" class="EverythingComponenttextandImage">
                    <div id="<%= cssClass %><%=currentNode.getName() %>" class="<%= cssClass %>" style="float:<%=imageAlignment %>">
                <%
                }//if it is left or right aligned the text should wrap
                else 
                {
                %>
                    <td align="<%=imagePosition%>" valign="top" style="text-align:<%=imagePosition%>; ">
                    <div  style="width:100%; " align="<%=imagePosition%>">
                    <div id="<%= cssClass %><%=currentNode.getName() %>" class="<%= cssClass %>" style="width:<%=width %>">
                    
                <%
                }
                img.addAttribute("style","padding:"+topPaddingImage+"px "+rightPaddingImage+"px "+bottomPaddingImage+"px "+leftPaddingImage+"px ");
                img.loadStyleData(currentStyle);
                // add design information if not default (i.e. for reference paras)
                if (!currentDesign.equals(resourceDesign)) {
                    img.setSuffix(currentDesign.getId());
                } 
                img.addCssClass(ddClassName);
                img.setSelector(".parentsizedimg");
                //if no alt text is specified by user, CQ sets alt to img path
                if(img.getAlt().startsWith("/content/")){
                    img.setAlt(" ");  
                }else{
                    //set title to alt text, to get tooltip matching alt
                    img.setTitle(img.getAlt());
                }

                %><%
                if(akamaiImagePath.equals(""))
                {
                    imagePath=img.getResource() != null ? img.getHref() : "";
                }
                else
                {
                    imagePath=akamaiImagePath;
                }
                
                if(createThumbnail)
                {
                %>
                    <a href="#" onClick="window.open('<%=imagePath %>', 'imagepopwin','height=300,width=600,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no,resizable=yes');return false">
                <%
                }
                else if(!imageLink.equals(""))
                {
                    if (imageLink.startsWith("/"))
                        imageLink=imageLink.concat(".html");
                %>
                    <a <%=anchorClass %> href="<%=imageLink %>">
                <%
                }
                else if(dld.hasContent())
                {
                    String href = Text.escape(dld.getHref(), '%', true);
                %>
                    <a href="<%=href %>" target="_new">
                <%
                }
                if(akamaiImagePath.equals(""))
                    img.draw(out);
                else
                    out.println("<img src='"+akamaiImagePath+"' onload='changeSize(this,\""+imgWidth+"\")' />");
                
                %></a><br><%
                
                
                String desc =properties.get("captionText", String.class);
               /* if ( desc.length() > 0 ) {
                    desc = img.getDescription(true);
                } */
                
                if ( diffInfo != null ) {
                    final String other = (diffImg == null ? "" : diffImg.getDescription(true));
                    final String diffOutput = DiffInfo.getDiffOutput(diffService, diffInfo, desc, false, other);
                    if ( diffOutput != null ) {
                        desc = diffOutput;
                    }
                }
                if(null!=desc)
                {
                if (desc.length() > 0) {            
                    %><div class="imagecaption" style="text-align:<%=captionAlignment %>"><%= desc.toString()%></div><%
                }}
                %>
                    </div>
                    
                <%
                if(!imageAlignment.equalsIgnoreCase("left") && !imageAlignment.equalsIgnoreCase("right"))
                {
                %>
                    </div></td>
                <%
                }//to accomadate wrapping in case of left or right alignment of image
                if (imageAlignment.contains("top"))
                {
                %>
                    </tr>
                <%
                }
                %>
            <%
            }
            //If image is not bottom Aligned
            if(!bottomShow && !text.equals("")) {
                out.println(renderText(currentNode.getName(),isRichText,text,imageAlignment,properties));
            } 
          %>
          </tr>
        </table>
        </div>
    </div>
    <!--div class="clear"></div-->
<%if(includeCorner){ 
%>
<SCRIPT type=text/javascript>

    // For Rounded corners of Border Title 
    DD_roundies.addRule("#everythingmain<%=randomNumber %>",'<%=roundingFactor %>px',true);
    DD_roundies.addRule("#EverythingParagradiv<%=randomNumber %>",'<%=roundingFactor %>px <%=roundingFactor %>px 0px 0px',true);

    if(<%=includeCorner %>) {
        if ( $.browser.msie && $.browser.version=='8.0'){
             $(".seperator<%=randomNumber %>").css("margin-top","<%=Integer.parseInt(borderSize) + 3%>px");
        } else {
             $(".seperator<%=randomNumber %>").css("margin-top","<%=borderSize %>px");
        }
    }

</SCRIPT>
<%
}
%>  