<%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  
  with Day.

  ==============================================================================

  Logo component

  Includes an image from the design and draws a link to the home page.

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat,
    com.day.cq.wcm.foundation.Download,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.components.EditConfig,
    org.apache.sling.api.resource.ResourceUtil,
    com.day.cq.wcm.api.WCMMode,
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService,
    com.day.image.Layer" %>
<%
    
    
                   
 final DiffInfo diffInfo = resource.adaptTo(DiffInfo.class);
    final Image diffImg = (diffInfo == null || diffInfo.getContent() == null ? null : new Image(diffInfo.getContent(), "image"));
    final DiffService diffService = (diffInfo == null ? null : sling.getService(DiffService.class));
   
   
    String home = "";
    //long absParent = properties.get("absParent", 2L);
    String absParent = properties.get("absParent","").trim();
    
    if(!"".equals(absParent)){
        long labsParent = Long.parseLong(absParent);
        home =currentPage.getAbsoluteParent((int)labsParent).getPath()+".html";
    }
    
    //Text.getAbsoluteParent(currentPage.getPath(), (int) absParent);
    
    
    //Resource res = currentStyle.getDefiningResource("imageReference");
    Image image = new Image(resource,"image");
    
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";  
    
    
      
    %>
 <style>
 
 .logo {clear:both;}
 </style>       
<div class="clear">  
    <div class="logo_t">
   <%
       if(!"".equals(home)){
       
   %>    
    <a href="<%=home%>">
    <%    
    }
      if(image.hasContent())
            {
            
                //String imgWidth = properties.get("maxWidth","165");
                
                String alt = properties.get("altText","");
                // code to load the image styles//
                image.loadStyleData(currentStyle);
               // out.println("imgWidth "+imgWidth )  ;          
                
                image.setSelector(".img"); // use image script
                image.setAlt(alt);
                // add design information if not default (i.e. for reference paras)
                if (!currentDesign.equals(resourceDesign)) {
                     image.setSuffix(currentDesign.getId());
                }
                // code to get the image size.
                    Layer layer1 = image.getLayer(true,true,true);
                   // int widthImg= (int)(layer1.getWidth()*Double.parseDouble(imgWidth));
                    
                    
                   // image.addAttribute("width",Integer.toString(widthImg)); 
                    %><% image.draw(out); %><%
            }  
            else if(WCMMode.fromRequest(request) == WCMMode.EDIT){
            %><img src="/libs/cq/ui/resources/0.gif" class="cq-text-placeholder <%= ddClassName %>" alt=""><%
            }   
             
        if(!"".equals(home)){
       %>     
         </a>    
        <%
        }
    
    
    %>
    </div>  
    
</div>

<div style="clear:both;"></div>