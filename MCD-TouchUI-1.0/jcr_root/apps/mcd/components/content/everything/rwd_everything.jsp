
<%--
  
  Responsive JSP of Everything component         
  
  Combines the text and the image component with various aligment and styling options 
  
  
  

--%>
<%@ page import="com.day.cq.wcm.foundation.Image,
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
    com.mcd.cq.util.search.SearchGroup,
    org.apache.commons.lang.StringEscapeUtils,
    java.util.Map,
    com.day.text.Text" %><%
%>
<%@include file="/apps/mcd/global/global.jsp"%>




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

    boolean includeCorner=properties.get("includeCorner",false);
/* GBS Change for out bg color for everything component */
	boolean gbsbackground=properties.get("bgimagecolor",false);

    String imageLink = properties.get("imageLink","");
    String newWindow=properties.get("imageNewWindow","");
    String anchorClass="";
    String captionAlignment = properties.get("captionAlignment","");
    String textColor = properties.get("textColor","");
    String backgroundColor = properties.get("backgroundColor","FFFFFF");
    String backgroundStyle = "background: #"+backgroundColor+" !important;"; 
    String anchor = properties.get("anchor","");
    String borderSize = properties.get("borderSize","0");
    String borderColor = properties.get("borderColor","");
    if(!borderColor.equals("")){
        borderColor+="border";
    }else{
        if(!borderSize.equals("0"))borderColor+="sitecolor0border";//default to black (sitecolor0)
    }
    String paragraphTitle = properties.get("paragraphTitle","");
    String mainTitle =properties.get("title", "");//To enter the title for the component
    String titleAlign =properties.get("titleAlign", "");//To select the alignment of title
    String separatorColor =properties.get("separatorColor", "");
    String borderTitleColor = properties.get("borderTitleColor","");
    String borderTitleAlign = properties.get("borderTitleAlign","");
    String titleColor = properties.get("titleColor", "000000");
    String titleBackgroundColor =properties.get("titleBackgroundColor", "FFFFFF");
    String titleBackgroundStyle = "color: #"+titleColor+"; background: #"+titleBackgroundColor+";";
    String titleType =properties.get("titleType", "");
    String separatorWidth=properties.get("separatorWidth", "");
    String width="auto";
    String imagePosition = "";
    String rightBorderColor = properties.get("rightbordercolor", ""); 
    String rightBorderSize = properties.get("rightBorderSize", ""); 
    String rightBorder = "";
    if(!"".equals(rightBorderColor) && !"".equals(rightBorderSize)){
        rightBorder = "border-right:"+rightBorderSize+"px solid #"+rightBorderColor+" !important;";
    }

    boolean createThumbnail=properties.get("createThumbnail",false);

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
    String fileLink = properties.get("file","");
    %>



    <%
       String borderstyle1="";
       String borderstyle2="";
           //IE re-render the rounded corners if they are tag-level styles, rather than classes 
           borderstyle1="overflow:hidden; BORDER-STYLE: solid; BORDER-WIDTH: "+borderSize+"px;";
           borderstyle2="overflow:hidden; BORDER-STYLE: solid;BORDER-WIDTH: "+borderSize+"px "+borderSize+"px 0px "+borderSize+"px;";
           borderstyle2+="margin: -"+borderSize+"px;";
    %>

    <!-- <div id="everythingcontainer" class="<% if(includeCorner){ %>everythingrounded<%}%>" style="margin:<%=topMargin %>px <%=rightMargin %>px <%=bottomMargin %>px <%=leftMargin %>px" > -->
<!-- GBS Change for out bg color for everything component -->
	<div id="everythingcontainer" class="<% if(gbsbackground){ %>everything-bg <%}%><% if(includeCorner){ %>everythingrounded<%}%>" style="padding:<%=topPadding %>px <%=rightPadding %>px <%=bottomPadding %>px <%=leftPadding %>px; margin:<%=topMargin %>px <%=rightMargin %>px <%=bottomMargin %>px <%=leftMargin %>px" > 

            <div class="everythingmainchecked &nbsp; <%=borderColor %> &nbsp; <% if(includeCorner){ %>everythingrounded<%}%>" id="everythingmain" style="<%=borderstyle1%><%=rightBorder%>">
      <%
        if (!anchor.equals("")) {
      %>
           <%--<a name="<%=anchor%>" ><div style="display:none;"><%=anchor%></div></a>--%>
            <div id="<%=anchor%>" style="height:0px;">&nbsp;</div> 
      <%
        }
        if(!mainTitle.trim().equalsIgnoreCase("")) {
            String titleColorClass="";

            String titleStyle="text-align:"+titleAlign+"; ";

            String titlePadding="padding:"+topPaddingTitle+"px "+rightPaddingTitle+"px "+bottomPaddingTitle+"px "+leftPaddingTitle+"px; border: none;";
            
            if(!titleColor.equals("default"))
                titleColorClass+="color:"+titleColor;      
    %>
                <div id="EverythingParagradiv" class="<%=titleBackgroundColor %> &nbsp; <%=borderColor %> &nbsp; <%=titleType %> &nbsp; <% if(includeCorner){ %>everythingroundedtitle<%}else{%>everythingtitle<%}%>" style="border: none; <%=titleStyle %>">
                <div class="<%=titleType %>" style="<%=titleColorClass%>"><div class="titleText" style="<%=titlePadding%>"><%=mainTitle %></div></div>    
            </div>
      <%
        }

        if(!separatorWidth.trim().equalsIgnoreCase("")&& !separatorWidth.trim().equalsIgnoreCase("0")) { 
        %>
            <div id="EverythingSeparator" class="<%=separatorColor %> seperator" style="height:<%=separatorWidth%>px;" ></div>           
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
        } else if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
      %>
           <img src="/libs/cq/ui/resources/0.gif" class="cq-text-placeholder <%= ddClassName %>" alt="">
      <%
        }
        
        if(!titleBackgroundColor.equals("FFFFFF") && !backgroundColor.equals("FFFFFF"))
            {                    
     %>
                <div class="everythingtable <%=backgroundColor%> &nbsp; <% if(includeCorner){ %>everythingroundedcornertable<%}%>">
      <%
            }
            else
            {
      %>
               <div class="everythingtable <%=backgroundColor%> &nbsp; <% if(includeCorner){ %>everythingroundedtable<%}%>">
      <%
            } 
      %>
                  
        <!-- <table cellspacing="0" cellpadding="0"> -->
        
          <!-- <tr> -->
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
                               //img.addAttribute("width",width.replace("px",""));
                           }
                       }catch(Exception e){
                           out.println(e.getMessage());
                       }
                }
                
                cssClass = "image evrimg";
                if(bottomPaddingImage==0)
                {
                cssClass = "evrimg";
                } 
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
                    <!-- <tr> -->
                <%
                }
                if(imageAlignment.equalsIgnoreCase("left") || imageAlignment.equalsIgnoreCase("right"))
                {
                %>
                    <!-- <td valign="top" class="EverythingComponenttextandImage"> -->
                    <!-- <div id="<%= cssClass %><%=currentNode.getName() %>" class="<%= cssClass %> rwdevrimg" style="float:<%=imageAlignment %>"> -->
                    <div id="<%= cssClass %><%=currentNode.getName() %>" class="<%= cssClass %> rwdevrimg" align="<%=imageAlignment %>" style="float:<%=imageAlignment %>">
                     
                <%
                }//if it is left or right aligned the text should wrap
                else 
                {
                %>
                    <!-- <td align="<%=imagePosition%>" valign="top" style="text-align:<%=imagePosition%>; "> -->
                    <div  style="width:100%; " align="<%=imagePosition%>">
                    <div id="<%= cssClass %><%=currentNode.getName() %>" class="<%= cssClass %>">
                    
                <%
                }
                img.addAttribute("style","padding:"+topPaddingImage+"px "+rightPaddingImage+"px "+bottomPaddingImage+"px "+leftPaddingImage+"px ");
                img.loadStyleData(currentStyle);
                // add design information if not default (i.e. for reference paras)
                if (!currentDesign.equals(resourceDesign)) {
                    img.setSuffix(currentDesign.getId());
                } 
                img.addCssClass(ddClassName);
                img.addCssClass("img-responsive");
                if(img.hasContent())
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

                if (createThumbnail) {
                    %>
                        <a href="#" onClick="window.open('<%=imagePath %>', 'imagepopwin','height=300,width=600,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no,resizable=yes');return false">
                    <%
                } else if(!imageLink.equals("")) {
                    if (imageLink.startsWith("/")&&!imageLink.startsWith("/content/dam"))
                        imageLink=imageLink.concat(".html");
                    if(newWindow.equals("")) {
                    %>
                        <a <%=anchorClass %> href="<%=imageLink %>">
                    <%  
                    }else{
                    %>
                        <a <%=anchorClass %> href="#" onClick="javascript:window.open('<%=imageLink%>');">     
                    <%
                    }
                } else if(dld.hasContent()) {
                    javax.jcr.Property propData = dld.getData();
                    String href = dld.getHref();
                    String metaGroups = getAllGroup(currentNode);    
                    String tmpGroup=SearchGroup.searchGroup(metaGroups);
                    if (tmpGroup!=null && tmpGroup.trim().length()>0 && href.indexOf("/content/dam")<0){
                        String orghref = dld.getHref();
                        int st = orghref.lastIndexOf(".");
                        String temphref = orghref.substring(0,st)+ "."+tmpGroup+"."+orghref.substring(st+1); 
                        href = Text.escape(temphref,'%',true);        
                    } else {
                        href = Text.escape(href, '%', true);
                    }
                    %>
                    <a href="<%=href%>" target="_new">
                    <%
                }
                
                if(akamaiImagePath.equals(""))
                    img.draw(out);
                else
                    out.println("<img src='"+akamaiImagePath+"' onload='changeSize(this,\""+imgWidth+"\")' />");
                 
                %></a><%   
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
                    </div>
                    <!-- </td> -->
                <%
                }//to accomadate wrapping in case of left or right alignment of image
                if (imageAlignment.contains("top"))
                {
                %>
                    <!-- </tr> -->
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
         <!-- </tr> -->
        <!-- </table> -->
        </div>
        </div>
    </div>