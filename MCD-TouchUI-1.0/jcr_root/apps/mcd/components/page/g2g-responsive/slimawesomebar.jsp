<%-- ################################################################################ 
 # DESCRIPTION: Render the basic structure of awesome bar based on view and audience type
 #  
 # Environment: 
 #  
 # UPDATE HISTORY       
 # 1.0  Deepali Goyal Initial Version 
 #
 #####################################################################################--%>  
 
<%@ page import="java.util.Iterator, 
        com.day.cq.wcm.foundation.Image,
        com.day.cq.wcm.api.PageFilter,
        com.mcd.accessmcd.util.CommonUtil,
        com.day.cq.security.User" %><%    
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%   
        //response.setHeader("Cache-Control","no-cache");       
        //response.setHeader("Dispatcher", "no-cache");        
%>


<%
final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object 
String mcdAudience = "CorpEmployees";
if(user != null) {   
        
    mcdAudience = user.getProperty("rep:mcdAudience");
    
    if(mcdAudience == null || "null".equals(mcdAudience) || mcdAudience.equals("")) 
            mcdAudience = "CorpEmployees" ;
           
} 


%>
<%!    
    // Method to retrieve html for different links
    public String getLinkHtml(String linksData, String emailHoverText, String getLinkHoverText, String bookmarksHoverText, String currentDesignPath, String language, String view, String mcdAudience, String feedbackViewType,HttpServletRequest request, String position){
        StringBuffer outStream = new StringBuffer("");  
        String[] links = linksData.split("\\|");

        //out.print("Heloooooooooooooo");
                  CommonUtil commonUtil = new CommonUtil(); 
        if(links.length>1 && (!"".equals(links[0]))) {      
            if(links.length>4 && position.equals(links[4])) {

 if("help".equals(links[0]) && links.length > 2 ) {   
                   if(links[2].startsWith("mailto")){
                       links[2] = links[2];
                       outStream.append("<li><a href='" + links[2] + "' >" + links[1] + "</a></li>");
                   }else{
                     outStream.append("<li><a href='" + links[2] + "' onClick=\"NewPrintWindow(this.href,'name',800,600,'yes','yes');return false;\">" + links[1] + "</a></li>");
                     }
                                
               
            } else if("account".equals(links[0]) && links.length > 2 ) { 
                outStream.append("<li><a href='" + links[2] + "' >" + links[1] + "</a></li>");
            } else if("feedback".equals(links[0]) && links.length > 2 ) {
                if(links[2].startsWith("mailto")){
                   links[2] = links[2];
                   outStream.append("<li id='feedbackLink'><a href='" + links[2] + "' >" + links[1] + "</a></li>");
                   }else{
                String seperator = "?";
                seperator = links[2].indexOf("?") != -1 ? "&" : "?";
                outStream.append("<li id='feedbackLink'><a target='new' href='" + links[2] + seperator + "pre_q2_ftxt=userID&pre_q1_ftxt=userName&pre_q4_ftxt=" + mcdAudience + "&pre_q5_ftxt=" + feedbackViewType.replaceAll(" ","%20") + "&pre_q3_ftxt=userEmail' >" + links[1] + "</a></li>");
                }
             }else if("share".equals(links[0]) && links.length > 1 ) { 
                outStream.append("<li><div id='share'>");
                outStream.append("<div class='socialsharing share'><a href='#'>" + links[1] + "</a></div>");
                outStream.append("<div id='share_spacer'></div>");
                outStream.append("<div class='alt' id='share_flyout' style='display: none; top: 30px; left: 26px;'>");
                outStream.append("<a class='shareEmailAction' title='" + emailHoverText + "' href='javascript:void(0)' ><img alt='" + emailHoverText + "' src='" + currentDesignPath + "/images/action_send.gif'></a>");
                outStream.append("<a class='shareGetAction' title='" + getLinkHoverText + "' href=\"javascript:DisplayAlert('AlertBox',100,500)\" ><img alt='" + getLinkHoverText + "' src='" + currentDesignPath + "/images/action_link.gif'></a>");
           //     outStream.append("<a class='sharebookmarksAction' title='" + bookmarksHoverText + "' href='javascript:void(0)' ><img alt='" + bookmarksHoverText + "' src='" + currentDesignPath + "/images/action_register.gif'></a>");
                outStream.append("</div>");
                outStream.append("</div></li>");                
            } else if("search".equals(links[0]) && links.length > 2 ) {
                outStream.append("<li><a href='" + links[2] + "?vpHandle=/accessmcd/global&avcol=default&selSites=default&qt=&ql=a&la=" + language + "&mkt=" + view + "' >" + links[1] + "</a></li>");  
            } else if("bookmark".equals(links[0]) && links.length > 1 ) {
                outStream.append("<li id='li_mysite'>"); 
                outStream.append("<a id='mySiteLinksList' href='javascript:void(0)' >" + links[1] + "</a>");
                outStream.append("<ul id='bookmarksList'> </ul>");
                outStream.append("</li>"); 
            } else if("print".equals(links[0]) && links.length > 1 ) {
                outStream.append("<li><a class='printLink' onclick=\"NewPrintWindow(this.href,'name',945,600,'yes','no');return false;\" href='javascript:void(0)'>" + links[1] + "</a></li>"); 
            }  
             else if("other".equals(links[0]) && links.length > 2 && links[3].equals("false") ) { 
                if(links[1].equalsIgnoreCase("Search History") || links[1].equalsIgnoreCase("Historique de recherche")){
                outStream.append("<li><a href='" + commonUtil.getValidURL(links[2],mcdAudience)+"?nocache=y" + "' >" + links[1] + "</a></li>");
                }else{
                outStream.append("<li><a href='" + commonUtil.getValidURL(links[2],mcdAudience) + "' >" + links[1] + "</a></li>");
                }
                
        }
        else if("other".equals(links[0]) && links.length > 2 && links[3].equals("true") ) { 
        //     outStream.append("<li><a href='"  + commonUtil.getValidURL(links[2],mcdAudience) + "'  target='_blank' >" + links[1] + "</a></li>");
         
                 if(commonUtil.isInternalLink(links[2],request))
                 {
                   outStream.append("<li><a href='javascript:openLink(\" "  + commonUtil.getValidURL(links[2],mcdAudience) + "\");' >" + links[1] + "</a></li>");

                 }
                 else 
                 {
                   outStream.append("<li><a href='javascript:openLink(\" "  + commonUtil.getValidURL(links[2]) + "\");' >" + links[1] + "</a></li>");
                 } 
        }    
            } }      
        // return the html code as string //  
        return outStream.toString();
        
    }

%>
<%
String[] requestUrl = request.getRequestURI().split("\\."); 

String view = "corp";
String path = globalPath;
try {
    view = requestUrl[3]; 
    
    path = prop.getProperty(view);
   
} catch(Exception e) { 
    log.error("slimawesome.jsp Error " + e.getMessage()); 
}
if(path ==  null) path = globalPath;
if(view.equals("null"))view="corp";
String feedbackViewType = "";
try {
    feedbackViewType = prop.getProperty(view + "FeedbackView");     
} catch(Exception e) { 
    log.error("slimawesome.jsp Error " + e.getMessage());
}
if(feedbackViewType==null)feedbackViewType="FeedbackView";

String nodePath = path + "/jcr:content/awesomebarpara";
String viewPath = path + ".html";

//retrieve view based language. Used in search parameters
String language = prop.getProperty(view+"Language");  
if(language ==  null) language = "en";

Resource res = slingRequest.getResourceResolver().getResource(nodePath);

Value[] linksData = null;

String viewLink = "";
int linksLength = 0;
Node userlinksNode;
String viewSearchTxt = "" ; 
String mcdSearchTxt = "" ; 
String siteSearchTxt = "" ; 
String searchLabel = "";
String searchLink = "";
String emailHoverText = "";
String viewSwitcherText="";
String getLinkHoverText = "";
String bookmarksHoverText = "";
String mcdAudienceText = "";
try {
    if(null!=res) {
    userlinksNode =res.adaptTo(Node.class);
    linksData = userlinksNode.getProperty("links").getValues();
    
    viewLink = userlinksNode.hasProperty("viewLink") ? userlinksNode.getProperty("viewLink").getString() : "" ;
    
    linksLength = linksData.length; 
     
    viewSearchTxt = userlinksNode.hasProperty("viewSearchText") ? userlinksNode.getProperty("viewSearchText").getString() : "" ; 
    mcdSearchTxt = userlinksNode.hasProperty("mcdSearchText") ? userlinksNode.getProperty("mcdSearchText").getString() : "" ; 
    siteSearchTxt = userlinksNode.hasProperty("siteSearchText") ? userlinksNode.getProperty("siteSearchText").getString() : "" ; 
    searchLabel = userlinksNode.hasProperty("searchLabel") ? userlinksNode.getProperty("searchLabel").getString() : langText.get("in") ;  
    viewSwitcherText = userlinksNode.hasProperty("viewSwitcherText") ? userlinksNode.getProperty("viewSwitcherText").getString() : "" ;    
    searchLink = userlinksNode.hasProperty("searchLink") ? userlinksNode.getProperty("searchLink").getString() : "" ;
    if(searchLink.indexOf("http") == -1 || searchLink.indexOf("https") == -1) {
         searchLink = searchLink + ".html";
         searchLink = searchLink.replaceAll("/content/","/"); 
    }
    emailHoverText = userlinksNode.hasProperty("emailHoverText") ? userlinksNode.getProperty("emailHoverText").getString() : "" ;
    getLinkHoverText = userlinksNode.hasProperty("getLinkHoverText") ? userlinksNode.getProperty("getLinkHoverText").getString() : "" ;
 //   bookmarksHoverText = userlinksNode.hasProperty("bookmarksHoverText") ? userlinksNode.getProperty("bookmarksHoverText").getString() : "" ;
    mcdAudienceText = userlinksNode.hasProperty(mcdAudience) ? userlinksNode.getProperty(mcdAudience).getString() : mcdAudience ;
    }
} catch(Exception e){
    log.error("Exception - Awesome Bar : Jsp exception created before image render "+e.getMessage());
}


%>
<!------------User Action Links-------------------->




  <%
        if(linksLength > 0) 
        {
            int i=0;
            %>
<div id="wrapToplinks">
           <div class="leftLinks"> 
            <ul id="topLeftLinks">
                  <li ><span id="user"><%=mcdAudienceText %></span>
                  </li>
                <%
            for(i=0; i<linksData.length; i++)
            { 

            %>          
                 <%=getLinkHtml(linksData[i].getString(), emailHoverText, getLinkHoverText, bookmarksHoverText, currentDesign.getPath(), language, view, mcdAudience, feedbackViewType,request,"UpperLeft") %> 
            <%}
            %> 

            </ul></div>
            <!------------View Switcher-------------------->
            <div class="rightLinks">
             <ul id="topRightLinks">   
           <%
                
               if (!"".equals(viewLink)) {
                  
                   Page viewPage = pageManager.getPage(viewLink);
                   if(viewPage != null) { 
                       Iterator<Page> myChildren = viewPage.listChildren(new PageFilter(request));  
                       String redirectTarget = "";
                       
                       
                       if(myChildren.hasNext()){
                       
                       %>   
                                                       
                                 
                                 <li class="viewSwitcher" id ="switcher" style="cursor:pointer">
                                   <a href="javascript:void(0)"> 
                                     <span>
                                            <%=viewSwitcherText%> 
                                     </span>
                              
                               
                                    </a>
                              
                              <ul id="dropdownList" style="display: none; width: auto; "> 
                                                           
                            <%
                                 while(myChildren.hasNext()){
                                   
                                    
                                    Page child =  (Page) myChildren.next(); 
                                  
                                   if(child!=null){
                                   // Node childNode = slingRequest.getResourceResolver().getResource(child.getPath()+"/jcr:content").adaptTo(Node.class);
                                    redirectTarget = child.getProperties().get("redirectTarget",child.getPath()); 
                                   
                                      
                                   String title=child.getTitle();
                                   if(prop.getProperty(view)!=null)
                                    {
                                    
                                       if(redirectTarget.startsWith(prop.getProperty(view)))
                                       {
                                         title="<b>"+title+"</b>";
                                           
                                       }
                                    }
                                    //out.println(prop.getProperty(view) + " :: " +redirectTarget + "<br>"); 
                                    redirectTarget = redirectTarget.startsWith("/content")? redirectTarget.replaceAll("/content/","/") + ".html" : redirectTarget;                         
                                    
                                    
                            
                            %>
                                   <li><a href="javascript:switchview('<%=redirectTarget%>');"><%=title%></a></li>
                            <%
                                 
                                 }
                                 }
                            %>                                                        
                            </ul> 
                         </li>

                       <%    
                       }
                   }
               }
           %>       
           
          
              <!------------End View Switcher-------------------->     
              

            <%
            for(i=0; i<linksData.length ; i++)
            { 

            %>          
                 <%=getLinkHtml(linksData[i].getString(), emailHoverText, getLinkHoverText, bookmarksHoverText, currentDesign.getPath(), language, view, mcdAudience, feedbackViewType,request,"UpperRight") %> 
                    
            <%}
            %> 

            </ul>

            <div style="clear: both; " ></div> 
           



</div>
<div style="clear: both;" ></div> 
</div>
            <% 
        }
        else
        {
            %><%= langText.get("Please enter some value in dialog box.") %><%
        }
%>

    
<!------------End User Action Links--------------------> 


<!------------Logo-------------------->

<div class="logo"> <a href="<%=viewPath%>">
<%
    Resource logoResource = slingRequest.getResourceResolver().getResource(nodePath + "/logoimg");
    Image image = null;
    if(logoResource != null)
    {
        Node imageNode = (logoResource != null)? logoResource.adaptTo(Node.class):null;
        image = new Image(logoResource);
    }
    if (image!=null && image.hasContent()) {
        image.setSelector(".img"); 
        image.setAlt(" ");
        image.draw(out); 
    } else
    {
        %>
        <img src="/images/accessmcd.gif" alt=" " title=""> 
        <%
    }  
    
%> <%
%>
</a></div>      
<!------------End Logo-------------------->
                
<!------------Search-------------------->
<%
//Search images from DAM
//String viewSearchImgHref = "/dam/accessmcd/g2g/" + view + "/searchview.jpg"; 
String searchMSG=langText.get("SEARCH_VALIDATION_MESSAGE","",""); 
String viewSearchImgHref = "/dam/accessmcd/awesome_bar/" + view + "/searchview.jpg"; 
String allSearchImgHref = "/dam/accessmcd/awesome_bar/" + view + "/searchmcd.png";
String siteSearchImgHref = "/dam/accessmcd/awesome_bar/" + view + "/searchsite.jpg";   
String inthe="63072000";
%>      
<div style='display:none;' id='viewSearch' > <%=viewSearchTxt %> </div> 
<div style='display:none;' id='mcdSearch' > <%=mcdSearchTxt%> </div> 
<div style='display:none;' id='siteSearch' > <%=siteSearchTxt %> </div>  

<div class="searched_wrapper">

    <form name="searchForm" id="searchForm" action="javascript:validatesearch('<%=searchLink %>','<%=language %>','<%=view %>','<%=inthe %>')">   
        
        <div>
            <div style="float:left; border:1px solid #999; background:#fff ; border-radius:2px; height:32px; ">
                <div style="float:left;"><input type="text" value="" id="txt_search" class="searchbox" /></div>
                <%
            if(view.equals("canada_en") || view.equals("canada_fr")){
            %>
                <div style="float:left; font-size:12px; padding:9px 0px 9px 0px"><%= searchLabel %></div>
                
                <%
            }else{%>
                <div style="float:left; font-size:12px; padding:9px 0px 9px 0px"><strong><%= searchLabel %></strong></div>
                
                <%}%>
                <div style="float:left;">
                    <div class="select_code">
                        
                        <span class="searchfield"><img src="<%=viewSearchImgHref%>" title="<%=viewSearchTxt %>" border="0" /></span>
                        <span class="search_arrow"><img src="/images/customSelect-arrow.gif" border="0"/></span>
                        <span class="searchoption"><%=viewSearchTxt %></span>
                        
                        
                    </div>
                    <div class="select_box">
                        <ul class="option">
                            <li id="view">
                                <span class="searchfield"><img  src="<%=viewSearchImgHref %>" title="<%=viewSearchTxt %>" border="0" /></span>
                                <span  class="searchoption"><%=viewSearchTxt %></span>
                            </li>
                            <li id="all">
                                <span class="searchfield"><img src="<%=allSearchImgHref %>" title="<%=mcdSearchTxt %>" border="0" /></span>
                                <span  class="searchoption"><%=mcdSearchTxt %></span></li>
                            <li id="site">
                                <span class="searchfield"><img src="<%=siteSearchImgHref %>" title="<%=siteSearchTxt %>" border="0" /></span>
                                <span  class="searchoption"><%=siteSearchTxt %></span></li>
                        </ul>
                    </div>  
                </div>
                <div class="clear"></div>
            </div>
            
            <div style="float:left; margin: 0 0 0 2px;"><input type="submit" value="<%= langText.get("GO") %>" id="searchbtn" class="search_btn"  onclick ="javascript:{$('#searchForm').submit();}"/></div>

         
      
            <div align="center" style="color: rgb(153, 0, 0); display: none;clear:both;" id="searchalert">
                <%= langText.get("Please enter keyword(s) to search") %>
            </div>
            <input type="hidden" id="viewLang" name="la" value="<%=language %>" />    
            <input type="hidden" name="mkt" value="<%=view %>" />  
            <input type="hidden" id="selSites" name="selSites" value="default" />
            <input type="hidden" id="inthe" name="inthe" value="63072000" />
            <input type="hidden" id="SearchSiteURL" name="SearchSiteURL" value="default" />    
        
        </div>
        
    </form>
    <div class="clearboth"></div>
        <ul id="searchLinks">
            <%
            for(int i=0; i<linksData.length; i++)
            { 

            %>          
                 <%=getLinkHtml(linksData[i].getString(), emailHoverText, getLinkHoverText, bookmarksHoverText, currentDesign.getPath(), language, view, mcdAudience, feedbackViewType,request,"BottomRight") %> 
             <%}
            %> 
        </ul>

 </div>








<!------------End Search Block-------------------->


 <div style="clear: both; height: 0px;" ></div>    
