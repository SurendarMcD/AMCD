<%@ page import="java.util.ArrayList,java.util.Iterator,com.day.cq.wcm.api.*,
    com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat, 
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService"%>                                                            
<%@include file="/apps/mcd/global/global.jsp" %>


<%!
public Page getPath(Page rootPage,String absParentLevel,Page currentPage){
    // declaring variable //    
    Page startPage = null;
    int parentLevel=0;
    
    // checking if the absolute parent is not given in the dialog 
    // then the rootpage path will be mentioned //
    try{
        if(!absParentLevel.equals("")){
            parentLevel = Integer.parseInt(absParentLevel);
            startPage = currentPage.getAbsoluteParent(parentLevel);
        }
        else{
            startPage = rootPage; 
        }
    }
    catch(Exception ex){
        return startPage;
    }
    return startPage;
}

/* To render the Page Report Table */
public String drawChildTree (Page rootPage, HttpServletRequest request){
    StringBuffer outBuffer = new StringBuffer("");
    if (rootPage != null) {
        // code to retirieve the child pages of the selected page in the itertor object
        Iterator<Page> children = rootPage.listChildren();       
        try {
            while (children.hasNext()) {
                Page child = children.next();               
                String pageURL ="";
                
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
                if("no".equalsIgnoreCase(hide)){
                    String pageTitle = child.getNavigationTitle();
                    if (pageTitle == null || pageTitle.equals("")) {
                        pageTitle = child.getPageTitle();
                    }
                    if (pageTitle == null || pageTitle.equals("")) {
                        pageTitle = child.getTitle();
                    }
                    if (pageTitle == null || pageTitle.equals("")) {
                        pageTitle = child.getName();
                    }
                    String pathtoinclude = child.getPath();                        
                    pageURL = pathtoinclude + ".html";
                    
                    
                    Iterator<Page> childCheck = child.listChildren(); 
                    if(childCheck.hasNext()){
                        Page childCheckPage = childCheck.next();
                        String hideChild = "no";
                        String[] hideInNavChild = childCheckPage.getProperties().get("hideinnav",String[].class ); 
                        if(hideInNavChild != null)
                        {
                           if(hideInNavChild.length > 0){
                                for(int len=0;len<hideInNavChild.length;len++){
                                    String val = hideInNavChild[len];
                                    if(val.equalsIgnoreCase("top")){
                                        hideChild = "yes";
                                    }
                                }
                            }                         
                        } 
                        //outBuffer.append(pageTitle + " :: " + hideChild + "<br>");
                        if("no".equalsIgnoreCase(hideChild)){
                            outBuffer.append("<li class='has-children'>");
                            outBuffer.append("<a>"+pageTitle+"</a>"); 
                            outBuffer.append("<ul class='cd-secondary-dropdown is-hidden'>");
                            outBuffer.append("<li class='go-back'><a href='#' id='mobileSubMenuHeading'>"+pageTitle+"</a></li>");
                            outBuffer.append(drawChildTree(child,request));
                            outBuffer.append("</ul>");
                        }
                        else if("yes".equalsIgnoreCase(hideChild)){
                            outBuffer.append("<li>"); 
                            outBuffer.append("<a href='"+pageURL+"'>"+pageTitle+"</a>"); 
                        }
                    }
                    else{
                       outBuffer.append("<li>"); 
                       outBuffer.append("<a href='"+pageURL+"'>"+pageTitle+"</a>"); 
                    }                 
                    if(childCheck.hasNext()){
                        
                    }
                    outBuffer.append("</li>");
                }
            }
        } finally {         
             
        }
    }
    // return the html code as string //
    return outBuffer.toString();
}
%>

<%
    String rootPath = (String) request.getParameter("rootPath");
    if( (!(rootPath != null)) || (!(rootPath.length() > 0)) ){
        rootPath = "";
    }
    String absParentLevel = request.getParameter("absParentLevel"); 
    if(absParentLevel==null)    
        absParentLevel = "";
    
    Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(rootPath);    
    Page absParentLevelPage = getPath(rootPage,absParentLevel,currentPage);
    String topNavLinksHTML = drawChildTree(absParentLevelPage,request);
    //out.println(topNavLinksHTML);
%> 

{
   "topNavLinks" : "<%=topNavLinksHTML%>"
}                      