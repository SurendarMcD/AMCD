<%--
  ==============================================================================
  Top Navigation globbing JSP

  Draws Top navigaton
  this component will render the child pages of the particular page
  Also  it can move upto 7 level of navigation.
 ==============================================================================
--%> 
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="java.util.ArrayList,java.util.Iterator,com.day.cq.wcm.api.PageFilter,
    com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat, 
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService"%>
        
<%!
    // Declaring Constants & Global Variables //
    static final int START_LEVEL=1;
    int navLevel = 0;
    int navEndLevel=0;

// this method takes the value of the rootpage, absParentLevel,currentpage value for getting the 
// root folder for the navigaton & will return the root handle for the navigation.
public String getPath(String rootPage,String absParentLevel,Page currentPage)
{
    // declaring variable //    
    String startPage="";
    StringBuffer outStream = new StringBuffer("");
    int parentLevel=0;
    
    // checking if the absolute parent is not given in the dialog 
    // then the rootpage path will be mentioned //
    try{
        if(!absParentLevel.equals(""))
         {
            parentLevel=Integer.parseInt(absParentLevel);
            startPage=currentPage.getAbsoluteParent(parentLevel).getPath();
        }
        else{
            startPage=rootPage; 
        }
    }
    catch(Exception ex)
    {
        outStream.append("No Child page exist for parent level mentioned at dialog");
        return startPage;
    }
    return startPage;
}
    
    
// this method return the child pages for the page //
// also it set the UI for all the pages //    
public String iterChild(Page rootPage,String navSelectedPath,HttpServletRequest request, String designPage,boolean isTopNode)
{ 
    
    // Declaring & nitializing variables //
    String whiteRow=  "";
    StringBuffer outStream = new StringBuffer("");
    // calling navspacer method //
    String spacing = "";
    String childPath="";
    String title="";
    int i = 0;  
    String childLaunchType = "_self";    
    // code to retirieve the child pages of the selected page in the itertor object //
    Iterator<Page> myChildren = rootPage.listChildren(new PageFilter(request));
        
    // loop to render the child page //
     while(myChildren.hasNext()){
               // retrieving the value of the page from the list //
              Page child =  (Page) myChildren.next();
             
               if (child!=null) {
                       
                        // Check page should come in top navigation.
                        String[] hideInNav = child.getProperties().get("hideinnav",String[].class ); 
                        String hide = "no";
                        if(hideInNav != null)
                        {
                           if(hideInNav.length > 0){
                                for(int len=0;len<hideInNav.length;len++){
                                    String val = hideInNav[len];
                                    if(val.equalsIgnoreCase("top")){
                                        hide = "yes";
                                    }
                                }
                            }                         
                        }         
                        if(hide.equalsIgnoreCase("yes")){
                            continue;
                        }
               
               
                       // code to get the child path & the titleto be shown on the html page //
                       childPath = child.getPath();
                       title = child.getNavigationTitle();
                       if (title == null || title.equals("")) {
                           title = child.getPageTitle();
                       }
                       if (title == null || title.equals("")) {
                           title = child.getTitle();
                       }
                       if (title == null || title.equals("")) {
                           title = child.getName();
                       }
                       
                       childLaunchType = child.getProperties().get("launchType","_self");             
                       outStream.append("<li><a href=\"" + childPath+ ".html\" target=\""+childLaunchType+"\">"+ title + "</a></li>");   
                }
                isTopNode = false;
      }
    // return the html code as string //
    return outStream.toString();
}

// this method return the boolean true if child exist or false if not exist //
public String getLastChildPath(Page startPage,HttpServletRequest request)
{
    String childPath ="";
    Page child = null;
    
    // code to retirieve the child pages of the selected page in the itertor object //
    Iterator<Page> myChildren = startPage.listChildren(new PageFilter(request));
    
    // loop to render the child page //
     while(myChildren.hasNext()){
          // retrieving the value of the page from the list //
          child =  (Page) myChildren.next();
              
           if (child!=null) {
               
                    // Check page should come in top navigation.
                    String[] hideInNav = child.getProperties().get("hideinnav",String[].class ); 
                    String hide = "no";
                    if(hideInNav != null)
                    {
                       if(hideInNav.length > 0){
                            for(int len=0;len<hideInNav.length;len++){
                                String val = hideInNav[len];
                                if(val.equalsIgnoreCase("top")){
                                    hide = "yes";
                                }
                            }
                        }                         
                    }                 
                    if(hide.equalsIgnoreCase("yes")){
                        continue;
                    }
                    childPath = child.getPath();
           
           }
   }
   return childPath;
}


%>
 

<div id="abc">

 <ul id="menu-item"> 
 
    <%
    // Variable Declarations //
    // variable for starting the navigaton level//
    int startLevel = START_LEVEL;
    
    // for storing the html of left nav //
    String streamOutput="";
    // for storing start page handle //
    String startPageHandle="";
    // storing the current design page path //
    String designPath= request.getParameter("designPath");
    if(designPath==null)
        designPath = "";
    String rootPage = "";
    String absParentLevel = "";
    String navStoplevel = "";
    String altText = "a";
    

    // code for retrieving the values of the node or dialog //
    rootPage = request.getParameter("rootPage");
    if(rootPage==null)
        rootPage = "";
        
    absParentLevel = request.getParameter("absParentLevel"); 
    if(absParentLevel==null)    
        absParentLevel = "";
        
    navStoplevel = "1";
    if(navStoplevel == null)
        navStoplevel = "";
    
    String roundCorners = request.getParameter("roundCorners");            
    if(roundCorners==null)
        roundCorners = "false";
        
    try{
        
                               
    // checking if the dialog has values or not as these //
    // are the minimum requirement for the link navigation to render //
    if(rootPage.equals("")&& absParentLevel.equals(""))
    {
        out.println("<li>Please enter the values in dialog box</li>");
    }
    else
    {  
        // calling method-getPath() to retrieive the root path of the pages //
        // this method will return the path of the root folder from where the navigation will work //
        startPageHandle=getPath(rootPage,absParentLevel,currentPage);
        // converting the String val to Integer //
        navLevel=Integer.parseInt(navStoplevel);
        navEndLevel=navLevel+START_LEVEL;
        navLevel=navLevel-START_LEVEL;
    
        // code to calculate the final stop level for the navigation //
        if(absParentLevel.equals(""))
        {
               String levelVal[]=rootPage.split("/");
               // array length has been subtracted by 2 as it starts with 1 & legnth has 1 more value//
               navLevel=navLevel+levelVal.length-2;
        }else
        {
            navLevel=navLevel+Integer.parseInt(absParentLevel);
        }
        
        
        // calling the get children method to retrieve all the child pages//
        // of the given root folder. and implementing the logic for the CSS //
        
        if (!startPageHandle.equals(""))
        {          
                    // Declaring & nitializing variables //
                    String whiteRow=  "";
                    StringBuffer outStream = new StringBuffer("");
                    // calling navspacer method //
                    String spacing = "";
                    String childPath="";
                    String title="";
                    String className = "";   
                    String dispTopNavImg = request.getParameter("dispTopNavImg");
                    if(dispTopNavImg == null)
                        dispTopNavImg  = "";
                                            
                    Page startPage = pageManager.getPage(startPageHandle);
                    String navSelectedPath = currentPage.getPath();
                    String designPage = designPath;
                        
                    // code to retirieve the child pages of the selected page in the itertor object //
                    Iterator<Page> myChildren = startPage.listChildren(new PageFilter(request));
                    
                    int counter = 0;
                    String roundCornerClass = "";
                    boolean flag = false;

                    //added for last tab rounded corner issue
                    String lastChildPath = getLastChildPath(startPage,request);
                                        
                    // loop to render the child page //
                     while(myChildren.hasNext()){
                               // retrieving the value of the page from the list //
                              Page child =  (Page) myChildren.next();
                              className = "";   
                              flag = false;           
                             
                               if (child!=null) {
                               
                                        // Check page should come in top navigation.
                                        String[] hideInNav = child.getProperties().get("hideinnav",String[].class ); 
                                        String hide = "no";
                                        if(hideInNav != null)
                                        {
                                           if(hideInNav.length > 0){
                                                for(int len=0;len<hideInNav.length;len++){
                                                    String val = hideInNav[len];
                                                    if(val.equalsIgnoreCase("top")){
                                                        hide = "yes";
                                                    }
                                                }
                                            }                         
                                        }                 
                                        if(hide.equalsIgnoreCase("yes")){
                                            continue;
                                        }
                               
                                       // code to get the child path & the titleto be shown on the html page //
                                       childPath = child.getPath();
                                       title = child.getNavigationTitle();
                                       if (title == null || title.equals("")) {
                                           title = child.getPageTitle();
                                       }
                                       if (title == null || title.equals("")) {
                                           title = child.getTitle();
                                       }
                                       if (title == null || title.equals("")) {
                                           title = child.getName();
                                       }
                                       
                                       String cssNavSelectedPath = navSelectedPath+"/";                    
                                       String cssChildPath = childPath+"/";
                                                              
                                       if (cssNavSelectedPath.startsWith(cssChildPath)) {
                                            className = "active";  
                                            flag = true;                 
                                       }
                                                                                                                                                           
                                       if(counter==0 && roundCorners.equalsIgnoreCase("true") && !lastChildPath.equals(childPath)){
                                            className  = "left_side";  
                                             if (flag) {
                                                className = "left_side_active";                   
                                             }  
                                       }
                                       else if(roundCorners.equalsIgnoreCase("true") && lastChildPath.equals(childPath) && counter==0){
                                           className  = "both_side";  
                                             if (flag) {
                                                className = "both_side_active";                   
                                             }
                                       } 
                                       
                                       else if(roundCorners.equalsIgnoreCase("true") && lastChildPath.equals(childPath) && counter!=0){
                                            className  = "right_side";  
                                            if (flag) {
                                                className = "right_side_active";                   
                                             }  
                                       } 
                                       
                                       Resource topNavResource = slingRequest.getResourceResolver().getResource(child.getPath()+"/jcr:content/topnavimage");
                                       Image image = null;
                                       
                                       if(topNavResource != null)
                                       {
                                            Node imageNode = (topNavResource != null)? topNavResource.adaptTo(Node.class):null;
                                            image = new Image(topNavResource);
                                             
                                       }
                                        String childHTML =  iterChild(child,navSelectedPath,request,designPage,false);
                                        String launchType=child.getProperties().get("launchType","_self");
                                        
                                        if(childHTML.equals("")){
                                            out.println("<li class='"+className+"'><a href="+childPath+".html target="+launchType+">");
                                           
                                                if (image!=null && image.hasContent())
                                                 {
                                                    image.setSelector(".img");  
                                                    image.addCssClass("topnav_icons");
                                                    image.setAlt(altText);
                                                    image.draw(out);
                                                 }
                                                 if(dispTopNavImg.equals("") || dispTopNavImg.equals("yes")){
                                                   out.println(title); 
                                                 }  
                                                 
                                                 //out.println("<img src=\"/apps/mcd/docroot/images/g2g/downArrow.png\" class=\"downarrow\" />");                                                                                                 
                                                 out.println("</a></li>");
                                        }
                                        
                                        else{ 
                                           out.println("<li class='"+className+"' style=\"position:relative;z-index:1000;word-wrap: break-word; \"><a href=\"" + childPath+ ".html\" target=\""+launchType+"\">");
                                            
                                            
                                            if (image!=null && image.hasContent())
                                             {
                                                image.setSelector(".img");  
                                                image.addCssClass("topnav_icons");             
                                                image.setAlt(altText);
                                                image.draw(out);                                            
                                             } 
                                             if(dispTopNavImg.equals("") || dispTopNavImg.equals("yes")){
                                                   out.println(title);
                                             }
                                             out.println("<span class=\"darrow\"></span>");         
                                                    
                                                                                               
                                            out.println("</a>");
                                             // code to retirieve the child pages of the selected page in the itertor object //
                                            out.println("<ul class=\"sub-menu\" style=\"left:0;\">");                 
                                            out.println(childHTML);
                                            out.println("</ul>");
                                            out.println("</li>"); 
                                        }                       
                                }
                                counter++;               
                      }
        }
        else
        {
            out.println("<li>No Child page exist for parent level mentioned at dialog</li>");
        }
        //out.println(streamOutput);
     }
    }
    catch(Exception e){
        out.println("<li>Please enter correct information.</li>");
    }
   
    %>
     </ul> 
     <div style="clear:left;"></div>
<div>
