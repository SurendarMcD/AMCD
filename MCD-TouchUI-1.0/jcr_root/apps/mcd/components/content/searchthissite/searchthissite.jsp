<%--
 
  Site Header component        
  
  Includes settings for Site Logo and Site Search 
  
  Erik Wannebo 12/16/2010

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
<table width="100%"><tr><td align=left>
<%
Image image= new Image(resource,"image");

String searchText= properties.get("searchtext",langText.get("Search this site"));
  
%>
 <style>
 .logo {clear:both;}
 </style>       

    <div class="logo_t">   
    <%    
    
      if(image.hasContent())
            {
            
                String imageLink = properties.get("imageLink","");
                String alt = properties.get("altText","");
                String imgWidth = properties.get("imageSize","1.0");
                String width="auto";
                Layer layer = image.getLayer(true,true,true);
                width= (layer.getWidth()*Double.parseDouble(imgWidth))+"px";
                //layer.resize(
                //image.addAttribute("width",width.replace("px",""));                
                 
                if(!imageLink.equals(""))
                {
                    if (imageLink.startsWith("/"))
                        imageLink=imageLink.concat(".html");
                %>
                    <a  href="<%=imageLink %>">
                <%
                }
               
                // code to load the image styles//
                image.loadStyleData(currentStyle);                
                image.setSelector(".sizedimg"); // use sized image script, to allow for resizing
                if(image.getAlt().startsWith("/content/")){
                    image.setAlt(" ");  
                }else{
                    //set title to alt text, to get tooltip matching alt
                    image.setTitle(image.getAlt());
                }
                
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
            %><img src="/libs/cq/ui/resources/0.gif" class="cq-text-placeholder" alt=""><%
            }   
            
       %>   
       </a>  
    </div>    

</td>
<td align="right" valign="bottom">
<!-- search form -->

<form action="https://search.accessmcd.com/mcdSearch/Search" name="SearchForm" method="GET">
<input name="mkt" type="hidden" value="us" />
<input name="SearchSiteURL"  type="hidden" value="<%=currentPage.getPath() %>" />

    <table width="200" border="0" cellspacing="0" cellpadding="0">

          <tr> 
          <!-- search graphic -->
          <td colspan="2" align="left" valign="bottom"><font class="siteSearchText"><%=searchText%></font></td></tr>
          <!-- /search graphic -->
          <!-- search field -->
          <tr>
             <td align="left" valign="middle"> 
                <input name="qt" type="text" style="width:180px;" class="SearchInput">
             </td>
              <td align="left" valign="middle">
              <%
   // Image searchimage= new Image(resource,"searchimage");
   // if(searchimage.hasContent())
   //         {
   //         searchimage.setAlt("Search");
   //         searchimage.setSelector(".img"); // use image script
   //         searchimage.draw(out);
   //         }
    %><input type="submit" class="siteSearchGo" alt="Search" value=""></td>
         </tr>
     
    

         
     
      </table>
  </form>

<!-- /search form -->     

</td></tr></table>