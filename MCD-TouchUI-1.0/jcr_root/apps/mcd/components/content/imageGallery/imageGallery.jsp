<%@ page import="java.util.ArrayList,java.util.List" %>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<div>
        
        <!-- Begin Page specific script -->
        
    <script type="text/javascript">
    $(document).ready(function(){
        $(("a[rel='<%=currentNode.getName()%>']")).mcdColorbox({rel:"<%=currentNode.getName()%>"});
    })
    </script>   

       <%              
       try{
        // relname is used for grouping all images of a gallery 
        String imageRelName=currentNode.getName();
        
        // Retrieving path of gallery from dialog        
        String galleryPath = properties.get("path", "");
        // Retrieving height of thumbnail images from dialog , if not set default value is 70px
        String imageHeight=properties.get("height", "90");
        // Retrieving width of thumbnail images from dialog , if not set default value is 70px
        String imageWidth=properties.get("width", "124");      
        // Retrieving Description of gallery from dialog
        String galleryDescription = properties.get("gallerydesc", "");  
        String imageKey = "";
        String imageValue = "";
        Map<String, String> imageMap = new LinkedHashMap<String, String>();   
        long thumbHeight = 0;
        long thumbWidth = 0;
        String bottomPadding = properties.get("btmpadding","");
        if(!"".equals(bottomPadding))
        {
            bottomPadding = "padding-bottom:" + bottomPadding + "px;";
        }
        
        if(!"".equals(galleryPath))   
        {               
            String thumbnailPath1 = galleryPath + "/Thumbnails";
            try
            {
              Resource root = slingRequest.getResourceResolver().getResource(galleryPath);
             if(root != null)
             {
              Node rootNode = root.adaptTo(Node.class);       
           
              // Creating list of image names in a gallery
               if(rootNode !=null)
              {            
                //out.println("<br> rootNode is not null <br>");
                NodeIterator children = rootNode.getNodes();
                 while (children.hasNext()) { 
                     Node node = children.nextNode();
                     if(node != null) {   
                         String name =node.getName(); 
                         if(! ( name.equals("jcr:content") || name.equals("Thumbnails") ))
                         {   
                             if(rootNode.hasNode("Thumbnails"))
                             {
                                 Resource thumbRoot = slingRequest.getResourceResolver().getResource(thumbnailPath1);
                                 Node thumbRootNode = thumbRoot.adaptTo(Node.class);
                            
                                if(null != thumbRootNode)     
                                { 
                                    
                                         if(thumbRootNode.hasNode(name))
                                         {
                                             Node thumbNode = thumbRootNode.getNode(name);
                                             imageValue = thumbNode.getPath();
                                             if(thumbWidth==0 || thumbHeight==0)
                                             {
                                                 Node thumbnailData = slingRequest.getResourceResolver().getResource(imageValue + "/jcr:content/metadata").adaptTo(Node.class);
                                                 thumbWidth = (thumbnailData.hasProperty("tiff:ImageWidth"))? Long.parseLong(thumbnailData.getProperty("tiff:ImageWidth").getString()) : 0; 
                                                 thumbHeight = (thumbnailData.hasProperty("tiff:ImageLength"))? Long.parseLong(thumbnailData.getProperty("tiff:ImageLength").getString()) : 0; 
                                             }
                                         }
                                         else
                                         {
                                             imageValue = node.getPath();  
                                         }
                                      
                                       imageKey = node.getPath();  
                                 }
                              }
                              else
                              {
                                  imageValue = node.getPath();
                                  imageKey = node.getPath();                                  
                              }
                              if(node.getPrimaryNodeType().getName().equals("dam:Asset")){
                                  imageMap.put(imageKey , imageValue ); 
                              }
                          }    
                     }
                 }
            }
            }
            else
            {
             %>
             <div style="">
             <%=langText.get("Please provide a valid image gallery path")%>
             </div>
             <%
            }
           }
            catch(Exception e)
            {
             log.error("ERROR" + e.getMessage());
            }
            if(thumbWidth==0 || thumbHeight==0)
            {
                thumbHeight = Long.parseLong(imageHeight);
                thumbWidth = Long.parseLong(imageWidth);
            }
            
            %>    
            
            <div id="content_offset">
<div class="article">
    <div class="image_gallery">   
     <% 
        Set imageSet=imageMap.entrySet();
        //out.println("<br> imageSet created <br>");
        
        //Move next key and value of Map by iterator
        Iterator imageItr=imageSet.iterator();
        //out.println("<br> imageItr created <br>");

        while(imageItr.hasNext())
        {   
            
            //    out.println("<br> iterating through imageItr <br>");
                
            // key=value separator this by Map.Entry to get key and value
            Map.Entry innerImageMap =(Map.Entry)imageItr.next();
    
            //out.println("<br> innerImageMap entry created <br> "+innerImageMap );        
        
            // getKey is used to get key of Map
            String bigImage=(String)innerImageMap.getKey();
            
           // out.println("<br> bigImage created <br>");  
            
            // getValue is used to get value of key in Map
            String thumbnailImage=(String)innerImageMap.getValue();
            
            //out.println("<br> thumbnailImage created <br>");  
            
            String metadataPath = bigImage+"/jcr:content/metadata";
            Resource metadata = slingRequest.getResourceResolver().getResource(metadataPath);
            Node metadataNode = metadata.adaptTo(Node.class);
            
            //out.println("<br> metadataNode created <br>");  
            
             //Retrieving title and description for each image from dam
            String imageTitle = (metadataNode.hasProperty("dc:title"))? metadataNode.getProperty("dc:title").getString() : ""; 

            //out.println("<br> imageTitle created <br>");  
            String imageDescription = (metadataNode.hasProperty("dc:description"))? metadataNode.getProperty("dc:description").getString() : "";
            
            //out.println("<br> imageDescription created <br>");  
        %>
       
           <a  href="<%=bigImage%>" rel="<%=imageRelName %>" title="<%=imageDescription %>"  ><img src="<%=thumbnailImage%>" alt="<%=imageTitle %>" width="<%=thumbWidth%>px" height="<%=thumbHeight%>px" /></a>
         
        <%  
        }
        %>
           <div class="caption">
                <%=galleryDescription %>
           </div>
       </div>
       <div class="clear"></div>
</div>
</div>
<div class="module_spacing" style="<%=bottomPadding%>"></div>
<div class="clear"></div>
    <%
        }
        else
        {
    %>
        <div style="">
        <%=langText.get("Please provide image gallery path")%>
         
        </div>
    <%
        }
        }// end of try
        catch(Exception e){
            out.println("<br><br> Error:"+e);
        }
    %>

</div>  

