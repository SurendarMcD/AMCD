<%-- ########################################### 
# DESCRIPTION: Graphical Menu Component
#  
# Environment: 
# 
# UPDATE HISTORY       
# 1.0  Sandeep Maheshwari Initial Version
#
##############################################--%>
<%@ page import="com.day.cq.wcm.foundation.Image,
                 com.day.cq.wcm.foundation.TextFormat,
                 com.day.cq.wcm.foundation.Download,
                 com.day.cq.wcm.api.components.DropTarget,
                 com.day.cq.wcm.api.components.EditConfig,
                 org.apache.sling.api.resource.ResourceUtil,
                 com.day.cq.wcm.api.WCMMode,
                 com.day.cq.wcm.foundation.DiffInfo,
                 com.day.cq.wcm.foundation.DiffService,
                 java.awt.image.BufferedImage,
                 java.io.ByteArrayInputStream,
                 java.io.ByteArrayOutputStream,
                 java.io.InputStream,
                 javax.imageio.ImageIO,
                 java.util.Calendar,
                 com.day.image.Layer"%>

<%@include file="/apps/mcd/global/global.jsp"%>

<%!
    public InputStream getInputStream(Image image,int width) throws Exception{
        InputStream inputStream = null;
        ByteArrayOutputStream byteArrayOutputStream = null;
        BufferedImage bufferedImage = null;
        Layer layer = null;    
        
        try{    
            if(image!=null){
                layer = image.getLayer(true, true, true);
            }
            if(layer==null){
                return null;    
            }
        
            // Get the original size of the image 
            int srcWidth = layer.getWidth();
            int srcHeight = layer.getHeight();
            
            // Computing height in same ratio as of selected width
            double resizeRatio = (double)width/(double)srcWidth;
            int height =(int)(srcHeight*resizeRatio);
            
            // resizing the image through the layer
            layer.resize(width,height);
            
            // convert layer into bufferedimage
            bufferedImage = layer.getImage();
            final String extension = "png";
            
            // bytearryoutputstream
            byteArrayOutputStream = new ByteArrayOutputStream();
            
            ImageIO.write(bufferedImage, extension, byteArrayOutputStream);
            byte[] bytes = byteArrayOutputStream.toByteArray();
            inputStream = new ByteArrayInputStream(bytes);
        }
        
        finally{
            try {
                if (byteArrayOutputStream != null) {
                    byteArrayOutputStream.close();
                    byteArrayOutputStream = null;
                }
                if(bufferedImage!=null){
                    bufferedImage.flush();
                    bufferedImage = null;
                }
            } catch (Exception ex) {
                System.out.println("[graphicalmenu.jsp] exception occured: "+ex.getMessage());
            }     
        }
        return inputStream ;
    } 
%>

<%
    //file
    String finalPath = "";
    String fileName = "";
    String existFileName = "";    
    Node file=null;
    Node currNode = null;
    Node node = null;
    String exception = "";    
    final DiffInfo diffInfo = resource.adaptTo(DiffInfo.class);
    final Image diffImg = (diffInfo == null || diffInfo.getContent() == null ? null : new Image(diffInfo.getContent(), "image"));
    final DiffService diffService = (diffInfo == null ? null : sling.getService(DiffService.class));
    
    //title_border
    String title = properties.get("title", "");
    String titleType =properties.get("titleType", "");
    String titleColor = properties.get("titleColor", "#000000");
    String titleBackgroundColor =properties.get("titleBackgroundColor", "FFFFFF");
    String titleBackgroundStyle = "color: #"+titleColor+"; background: #"+titleBackgroundColor+";";
    String titleAlign =properties.get("titleAlign", "");
    String altText = properties.get("alt", "");    // alt text
    boolean includeCorner=properties.get("includeCorner",false);
    String rounded = "";
    if(!includeCorner) {
        rounded = "roundedNo";
    } else {
        rounded = "roundedYes";
    }
    String borderSize = properties.get("borderSize","0");
    String borderColor = properties.get("borderColor","");
    if(!borderColor.equals("")){
        borderColor+="border";
    }else{
        if(!borderSize.equals("0"))borderColor+="sitecolor0border";//default to black (sitecolor0)
    }
    String borderstyle = "overflow:hidden; border-width: "+borderSize+"px; border-style: solid;";
    String separatorWidth=properties.get("separatorWidth", "");
    String separatorColor =properties.get("separatorColor", "");

    //Dialog - Layout
    String componentWidth = properties.get("compWidth", "auto");
    if (componentWidth != "auto") {
        componentWidth = componentWidth+"px !important";
    }
    String componentAlign = properties.get("align", "topAlign");
    int width = 0;
    String size = properties.get("size","");    // size
    size = size.trim();
    if(size.contains("x")){
        int splitSize = size.indexOf("x");
        size = size.substring(0, splitSize);
    } else if (size.contains("X")){
        int splitSize = size.indexOf("X");
        size = size.substring(0, splitSize);
    }
    String imageWidth = size+"px;";
    String imageName = "image"+size;
    String backgroundColor = properties.get("backgroundColor","");

    //Dialog - Advanced
    int leftPadding =properties.get("paddingLeft",0);
    int rightPadding =properties.get("paddingRight",0);
    int topPadding =properties.get("paddingTop",0);
    int bottomPadding =properties.get("paddingBottom",0);

    int leftMargin =properties.get("marginLeft",0);
    int rightMargin =properties.get("marginRight",0);
    int topMargin =properties.get("marginTop",0);
    int bottomMargin =properties.get("marginBottom",0);

    int leftPaddingImage =properties.get("paddingLeftImage",5);
    int rightPaddingImage =properties.get("paddingRightImage",5);
    int topPaddingImage =properties.get("paddingTopImage",5);
    int bottomPaddingImage =properties.get("paddingBottomImage",5);

    int topPaddingText =properties.get("paddingTopText",5);
    int rightPaddingText =properties.get("paddingRightText",5);
    int bottomPaddingText =properties.get("paddingBottomText",5);
    int leftPaddingText =properties.get("paddingLeftText",5);
    
    int topPaddingTitle =properties.get("paddingTopTitle",10);
    int rightPaddingTitle =properties.get("paddingRightTitle",10);
    int bottomPaddingTitle =properties.get("paddingBottomTitle",10);
    int leftPaddingTitle =properties.get("paddingLeftTitle",10);
    
    String componentPadding = "padding: "+topPadding+"px "+rightPadding+"px "+bottomPadding+"px "+leftPadding+"px;";
    String componentMargin = "margin: "+topMargin+"px "+rightMargin+"px "+bottomMargin+"px "+leftMargin+"px;";
    String imagePadding = "padding: "+topPaddingImage+"px "+rightPaddingImage+"px "+bottomPaddingImage+"px "+leftPaddingImage+"px;";
    String textPadding = "padding: "+topPaddingText+"px "+rightPaddingText+"px "+bottomPaddingText+"px "+leftPaddingText+"px;";
    String titlePadding = "padding: "+topPaddingTitle+"px "+rightPaddingTitle+"px "+bottomPaddingTitle+"px "+leftPaddingTitle+"px;";
    
    //variables intialized for rendering text
    boolean isRichText= false;
    String text = "";
    
    //drop target css class = dd prefix + name of the drop target in the edit config 
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";   
    
    Image image = null; 
    
    /* updated: 02/21/2011
    * New Object reference declared to differentiate between the original image and the resized Image being referred from repository    
    */
    Image resizedImage = null; 
    
    InputStream inputStream = null;
    try {  
        image = new Image(resource,"image");        
        if (image.hasContent() && WCMMode.fromRequest(request) == WCMMode.EDIT) {   
            if(size.length()>1){
                width = Integer.parseInt(size);
            }
        
            if(width!=0){               
                inputStream = getInputStream(image,width);
                fileName="file";  
                          
                try {
                    existFileName = currentNode.getPath() + "/" + imageName + "/file";  
                    file = slingRequest.getResourceResolver().getResource(existFileName).adaptTo(Node.class);
                    node = currentNode.getNode(imageName);
                } catch(Exception e) {
                    exception += e.getMessage();
                }
                
                if(node!=null){
                    node.remove();
                    currentNode.save();
                    currentNode.refresh(true);
                }
            
                currNode = currentNode.addNode(imageName,"nt:unstructured");
                currNode.setProperty("imageRotate","0");
                currNode.setProperty("sling:resourceType","mcd/components/content/graphicalmenu");
                file = currNode.addNode(fileName,"nt:file");
                Node data = file.addNode("jcr:content","nt:resource");
                data.setProperty("jcr:data",inputStream);
                data.setProperty("jcr:mimeType",image.getMimeType());
                data.setProperty("jcr:lastModified",Calendar.getInstance());
                currentNode.save();
                currentNode.refresh(true);         
            }
        }
        //image = new Image(resource,imageName);
        // updated: 02/21/2011
        resizedImage = new Image(resource,imageName);
    
        if( (image.hasContent()) && (resizedImage.hasContent()) ) {
            log.error("Inside the condition *************************************************** "); 
            resizedImage.setSelector(".img"); // updated: 02/21/2011
            resizedImage.setAlt(altText); // updated: 02/21/2011
            resizedImage.setTitle(altText); // updated 07/06/2011 
        }
        %>
            
<div id="div_graphicalMenu" class="graphicalMenu <%=rounded%> &nbsp; <%=backgroundColor%> &nbsp; <%=componentAlign%> &nbsp; <%=borderColor%>" style="width: <%=componentWidth%>; <%=componentPadding%> <%=componentMargin%> <%=borderstyle%>">
    
    <% if(!title.trim().equalsIgnoreCase("")) { %>
            <div class="graphicalMenuTitle <%=titleBackgroundColor %> &nbsp; <%=titleType %>" style="<%=titlePadding%> color: <%=titleColor%>; text-align:<%=titleAlign%>">
                <%=title%>
            </div>
            
            <% if((!separatorWidth.trim().equalsIgnoreCase("")) && (!separatorWidth.trim().equalsIgnoreCase("0"))) { %>
                <div class="<%=separatorColor %> seperator" style="height:<%=separatorWidth%>px;" ></div>           
            <% } %>
    <% } %>

            <div class="image" style="<%=imagePadding%> width: <%=imageWidth%>">
                <%
                if(WCMMode.fromRequest(request) == WCMMode.EDIT){              
                    log.error("Image Source: ************************************ : " + resizedImage.getSrc()); // updated: 02/21/2011
                    resizedImage.setSrc(resizedImage.getSrc()+"/"+Math.random()+".png"); // updated: 02/21/2011
                    log.error("Image source after suffixing Math.random() : ************************: " + resizedImage.getSrc()); // updated: 02/21/2011
                } 
        
                resizedImage.draw(out); // updated: 02/21/2011
                %>
            </div>
        <% 
        if (properties.get("text", "").length() > 0){
            text = properties.get("text", String.class);
            isRichText = properties.get("textIsRich", "false").equals("true");
    
            if ( diffInfo != null ) {
                final ValueMap map = ResourceUtil.getValueMap(diffInfo.getContent());
                final String diffOutput = DiffInfo.getDiffOutput(diffService, diffInfo, text, isRichText, map.get("text", ""));
                if ( diffOutput != null ) {
                    text = diffOutput;
                    isRichText = true;
                }
            }
        %>
        <div class="graphicalMenuText" style="<%=textPadding%>">
            <%
            if (isRichText) {
                %><%= text %><%
            } else {
                TextFormat fmt = new TextFormat();
                fmt.setTagUlOpen("<ul>");
                fmt.setTagOlOpen("<ol start=\"%s\">");
                %><%= fmt.format(text) %><%
            }
            %>
        </div>
        <%
        }
    } catch(Exception e) { 
        exception += e.getMessage();
        %>
        <div><%=exception %></div>
        <%
        System.out.println("[graphicalmenu.jsp] exception occured: "+exception);
    } finally {
        try{
            if (inputStream != null) {
                inputStream.close();
                inputStream = null;
            }
        } catch (Exception ex) {
            System.out.println("[graphicalmenu.jsp] exception occured: "+ex.getMessage());
        }   
    }   
    %>
</div>