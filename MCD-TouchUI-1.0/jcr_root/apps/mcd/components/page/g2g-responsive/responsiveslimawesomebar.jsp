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
%>

<%
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object 
    String mcdAudience = "CorpEmployees";
    if(user != null) {   
        mcdAudience = user.getProperty("rep:mcdAudience");
        if(mcdAudience == null || "null".equals(mcdAudience) || mcdAudience.equals("")) 
            mcdAudience = "CorpEmployees" ;
    } 
    
    String[] requestUrl = request.getRequestURI().split("\\."); 
    String view = "corp";
    String path = globalPath;
    try {
        view = requestUrl[3]; 
        path = prop.getProperty(view);
    
    } 
    catch(Exception e) { 
        log.error("slimawesome.jsp Error " + e.getMessage()); 
    }
    if(path ==  null){
        path = globalPath;
    }
    if(view.equals("null")){
        view="corp";
    }
    String feedbackViewType = "";
    try {
        feedbackViewType = prop.getProperty(view + "FeedbackView");     
    } 
    catch(Exception e) { 
        log.error("slimawesome.jsp Error " + e.getMessage());
    }
    if(feedbackViewType==null){
        feedbackViewType="FeedbackView";
    }
    
    String nodePath = path + "/jcr:content/awesomebarpara";
    String viewPath = path + ".html";
    String template = requestUrl[4];
    
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
    try{
        if(null!=res){
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
    } 
    catch(Exception e){
        log.error("Exception - Awesome Bar : Jsp exception created before image render "+e.getMessage());
    }


%>
<!------------User Action Links-------------------->

<%
    if(linksLength > 0){
        int i=0;
%>
    <div class="ribbon">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <ul class="text-right">
                        <li><span id="user"><%=mcdAudienceText %></span></li>
                        <!------------View Switcher-------------------->
<%
                        if (!"".equals(viewLink)) {
                            Page viewPage = pageManager.getPage(viewLink);
                            if(viewPage != null) { 
                                Iterator<Page> myChildren = viewPage.listChildren(new PageFilter(request));  
                                String redirectTarget = "";
                                if(myChildren.hasNext()){
                            
%>   
                                    <li class="pos-relative">
                                        <a href="javascript:void(0)" id="mrkt-View"><%=viewSwitcherText%></a>
                                        <div class="top-subNav">
                                            <ul class="text-left"> 
<%
                                                while(myChildren.hasNext()){
                                                    Page child =  (Page) myChildren.next(); 
                                                    if(child!=null){
                                                        // Node childNode = slingRequest.getResourceResolver().getResource(child.getPath()+"/jcr:content").adaptTo(Node.class);
                                                        redirectTarget = child.getProperties().get("redirectTarget",child.getPath()); 
                                                        String title=child.getTitle();
                                                        if(prop.getProperty(view)!=null){
                                                            if(redirectTarget.startsWith(prop.getProperty(view))){
                                                                title="<b>"+title+"</b>";
                                                            }
                                                        }
                                                        redirectTarget = redirectTarget.startsWith("/content")? redirectTarget.replaceAll("/content/","/") + ".html" : redirectTarget;                         
%>
                                                        <li><a href="javascript:switchview('<%=redirectTarget%>');"><%=title%></a></li>
<%
                                                    }
                                                }
%>                                                        
                                            </ul>
                                        </div> 
                                    </li>
                                    
<%    
                                }
                            }
                        }
%>       
                        <!------------End View Switcher-------------------->     
<%
                        for(i=0; i<linksData.length ; i++){ 
%>          
                            <%=getLinkHtml(linksData[i].getString(), emailHoverText, getLinkHoverText, bookmarksHoverText, currentDesign.getPath(), language, view, mcdAudience, feedbackViewType,request,"UpperRight") %> 
<%
                        }
%> 
                    </ul>
                </div>
            </div>
        </div> 
    </div><!--end ribbon-->
<% 
    }
    else{
%>
        <%= langText.get("Please enter some value in dialog box.") %><%
    }
%>
<!------------End User Action Links--------------------> 


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
<%
    if("g2g-responsive".equalsIgnoreCase(template)){
%>    
    <!--SLIDE MENU MOBILE HEADER STARTS HERE-->
    <div class="mobile-header">
        <div class="cd-dropdown-wrapper mobile-only pull-left">
            <a href="#" class="cd-dropdown-trigger pull-left"></a>
            <nav class="cd-dropdown">
                <h2 id="mobileMenuHeading" style="display:none;">AccessMcD</h2>
                <ul class="cd-dropdown-content" id="mnav">
                    <li class="new-searchbox-mobile-li" style=margin-right:22px;">
                        <!--Mobile Search-->
                        <div class="topSearch new-searchbox-mobile">
                            <form name="searchForm1" id="searchForm1" method="GET" action="javascript:validatesearchMobile('<%=searchLink %>','<%=language %>','<%=view %>','<%=inthe %>')">
                                <div class="form-group">
                                    <div class="pos-relative text-box select_code">
                                        <span class="glyphicon glyphicon-triangle-bottom sugBox" aria-hidden="true"></span>
                                        <input type="text" value="" id="txt_search" placeholder="<%= searchLabel %>">
                                        <span class="searchoption1" style="display:none;"><%=viewSearchTxt %></span>
                                        <div id="search-criteria" class="search-criteria">
                                            <div class="text-left">
                                                <li id="view"><%=viewSearchTxt %><span style="display:none;" class="searchoption"><%=viewSearchTxt %></span></li>
                                                <li id="all"><%=mcdSearchTxt %><span style="display:none;" class="searchoption"><%=mcdSearchTxt %></span></li>
                                                <li id="site" style="border-bottom:none;"><%=siteSearchTxt %><span style="display:none;" class="searchoption"><%=siteSearchTxt %></span></li>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div align="center"  style="color: #fff; display: none;clear:both;font-size: 12px;margin-top:20px;"  id="searchalert1">
                                    <%= langText.get("Please enter keyword(s) to search") %>
                                </div>
                                <input type="hidden" id="viewLang" name="la" value="<%=language %>" />    
                                <input type="hidden" name="mkt" value="<%=view %>" />  
                                <input type="hidden" id="selSites" name="selSites" value="default" />
                                <input type="hidden" id="inthe" name="inthe" value="63072000" />
                                <input type="hidden" id="SearchSiteURL" name="SearchSiteURL" value="default" />
                            </form>
                        </div>
                    </li>
                </ul>
                <!-- .cd-dropdown-content -->
            </nav>
            <!-- .cd-dropdown -->
        </div>
        <!-- .cd-dropdown-wrapper -->
        <!---    Code new for mega dd   -->
        <!--Start mobile header and new Menu code here -->
        <div class="pull-left" id="mobileLogo">
             <a href="<%=viewPath%>">
<%
                Resource logoResourceMobile = slingRequest.getResourceResolver().getResource(nodePath + "/logoimg");
                Image imageMobile = null;
                if(logoResourceMobile != null){
                    Node imageNode = (logoResourceMobile != null)? logoResourceMobile.adaptTo(Node.class):null;
                    imageMobile = new Image(logoResourceMobile);
                }
                if (imageMobile!=null && imageMobile.hasContent()){
                    imageMobile.setSelector(".img"); 
                    imageMobile.setAlt(" ");
                    imageMobile.addAttribute("class","img-responsive");
                    imageMobile.draw(out); 
                } 
                else{
%>
                    <img src="/images/accessmcd.gif" alt=" " title=""> 
<%
                }  
%> 
            </a>            
        </div>
        <div class="clearfix"></div>
    </div>
    <!--SLIDE MENU MOBILE HEADER END HERE-->
<%
    }
    else{
%>    
    <!--mobile header-->
    <div class="mobile-header">
        <a href="#" id="mobileMenu" class="pull-left"></a>
        <div class="mobile-subNav">
            <!--Mobile Search Start-->
            <div class="topSearch">
                <form name="searchForm1" id="searchForm1" method="GET" action="javascript:validatesearchMobile('<%=searchLink %>','<%=language %>','<%=view %>','<%=inthe %>')">
                    <div class="form-group">                                
                        <div class="pos-relative text-box select_code">
                            <span class="glyphicon glyphicon-triangle-bottom sugBox" aria-hidden="true"></span>
                            <input type="text" value="" id="txt_search" placeholder="<%= searchLabel %>">
                            <span class="searchoption1" style="display:none;"><%=viewSearchTxt %></span>
                            <div id="search-criteria" class="search-criteria">
                                <ul class="text-left">
                                    <li id="view"><%=viewSearchTxt %><span style="display:none;" class="searchoption"><%=viewSearchTxt %></span></li>
                                    <li id="all"><%=mcdSearchTxt %><span style="display:none;" class="searchoption"><%=mcdSearchTxt %></span></li>
                                    <li id="site" style="border-bottom:none;"><%=siteSearchTxt %><span style="display:none;" class="searchoption"><%=siteSearchTxt %></span></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div align="center"  style="color: #fff; display: none;clear:both;font-size: 12px;margin-top:20px;"  id="searchalert1">
                                <%= langText.get("Please enter keyword(s) to search") %>
                    </div>
                    <input type="hidden" id="viewLang" name="la" value="<%=language %>" />    
                    <input type="hidden" name="mkt" value="<%=view %>" />  
                    <input type="hidden" id="selSites" name="selSites" value="default" />
                    <input type="hidden" id="inthe" name="inthe" value="63072000" />
                    <input type="hidden" id="SearchSiteURL" name="SearchSiteURL" value="default" />
                </form>
            </div>
            <!--Mobile Search End-->
            <!--Mobile Navigation Start-->
            <ul id="mnav"></ul>
            <div id="mextralinks"></div>
            <!--Mobile Navigation End-->
        </div>
        <div class="pull-left" id="mobileLogo">
             <a href="<%=viewPath%>">
<%
                Resource logoResourceMobile = slingRequest.getResourceResolver().getResource(nodePath + "/logoimg");
                Image imageMobile = null;
                if(logoResourceMobile != null){
                    Node imageNode = (logoResourceMobile != null)? logoResourceMobile.adaptTo(Node.class):null;
                    imageMobile = new Image(logoResourceMobile);
                }
                if (imageMobile!=null && imageMobile.hasContent()){
                    imageMobile.setSelector(".img"); 
                    imageMobile.setAlt(" ");
                    imageMobile.addAttribute("class","img-responsive");
                    imageMobile.draw(out); 
                } 
                else{
%>
                    <img src="/images/accessmcd.gif" alt=" " title=""> 
<%
                }      
%> 
            </a>
        </div>
        <div class="clearfix"></div>
    </div>
    <!--mobile header end--> 
<%
    }
%>
    <div class="container header desktop-header">
        <div class="row">
            <div class="col-md-3 col-sm-3">
                <a href="<%=viewPath%>">
<%
                    Resource logoResource = slingRequest.getResourceResolver().getResource(nodePath + "/logoimg");
                    Image image = null;
                    if(logoResource != null){
                        Node imageNode = (logoResource != null)? logoResource.adaptTo(Node.class):null;
                        image = new Image(logoResource);
                    }
                    if (image!=null && image.hasContent()){
                        image.setSelector(".img"); 
                        image.setAlt(" ");
                        image.addAttribute("class","img-responsive");
                        image.draw(out); 
                    } 
                    else{
%>
                        <img src="/images/accessmcd.gif" alt=" " title=""> 
<%
                    }  
                
%> 
                </a>
            </div>
            <div class="col-md-9 col-sm-9">
                <div class="row">
                    <div class="col-md-3 col-sm-3 topSearch">
                        <form name="searchForm" id="searchForm" method="GET" action="javascript:validatesearchDesktop('<%=searchLink %>','<%=language %>','<%=view %>','<%=inthe %>')" class="form-inline">
                            <div class="form-group">
                                <label for="q"><%= searchLabel %></label>
                                <div class="pos-relative text-box select_code">
                                    <span class="glyphicon glyphicon-triangle-bottom sugBox" aria-hidden="true"></span>
                                    <input type="text" value="" id="txt_search">
                                    <span class="searchoption1" style="display:none;"><%=viewSearchTxt %></span>
                                    <div id="search-criteria" class="search-criteria">
                                        <ul class="text-left">
                                            <li id="view"><%=viewSearchTxt %><span style="display:none;" class="searchoption"><%=viewSearchTxt %></span></li>
                                            <li id="all"><%=mcdSearchTxt %><span style="display:none;" class="searchoption"><%=mcdSearchTxt %></span></li>
                                            <li id="site" style="border-bottom:none;"><%=siteSearchTxt %><span style="display:none;" class="searchoption"><%=siteSearchTxt %></span></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div align="center" style="color: rgb(153, 0, 0); display: none;clear:both;" id="searchalert" font-size: 10px;>
                                <%= langText.get("Please enter keyword(s) to search") %>
                            </div>
                            <input type="hidden" id="viewLang" name="la" value="<%=language %>" />    
                            <input type="hidden" name="mkt" value="<%=view %>" />  
                            <input type="hidden" id="selSites" name="selSites" value="default" />
                            <input type="hidden" id="inthe" name="inthe" value="63072000" />
                            <input type="hidden" id="SearchSiteURL" name="SearchSiteURL" value="default" /> 
                        </form>
                    </div>
                    <!--main navigation start--><div class="col-md-9 col-sm-9 menuWrapper"></div><!--main navigation end-->
                </div>
            </div>
        </div>
    </div>
    <div style="clear: both; height: 0px;" ></div>    
<%!    
    // Method to retrieve html for different links
    public String getLinkHtml(String linksData, String emailHoverText, String getLinkHoverText, String bookmarksHoverText, String currentDesignPath, String language, String view, String mcdAudience, String feedbackViewType,HttpServletRequest request, String position){
        StringBuffer outStream = new StringBuffer("");  
        String[] links = linksData.split("\\|");
        
        //out.print("Heloooooooooooooo");
        CommonUtil commonUtil = new CommonUtil(); 
        if(links.length>1 && (!"".equals(links[0]))){      
            if(links.length>4 && position.equals(links[4])){
                if("help".equals(links[0]) && links.length > 2 ){   
                    if(links[2].startsWith("mailto")){
                        links[2] = links[2];
                        outStream.append("<li><a href='" + links[2] + "' >" + links[1] + "</a></li>");
                    }
                    else{
                        outStream.append("<li><a href='" + links[2] + "' onClick=\"NewPrintWindow(this.href,'name',800,600,'yes','yes');return false;\">" + links[1] + "</a></li>");
                    }
                } 
                else if("account".equals(links[0]) && links.length > 2 ){ 
                    outStream.append("<li><a href='" + links[2] + "' >" + links[1] + "</a></li>");
                } 
                else if("feedback".equals(links[0]) && links.length > 2 ){
                    if(links[2].startsWith("mailto")){
                        links[2] = links[2];
                        outStream.append("<li id='feedbackLink'><a href='" + links[2] + "' >" + links[1] + "</a></li>");
                    }
                    else{
                        String seperator = "?";
                        seperator = links[2].indexOf("?") != -1 ? "&" : "?";
                        outStream.append("<li id='feedbackLink'><a target='new' href='" + links[2] + seperator + "pre_q2_ftxt=userID&pre_q1_ftxt=userName&pre_q4_ftxt=" + mcdAudience + "&pre_q5_ftxt=" + feedbackViewType.replaceAll(" ","%20") + "&pre_q3_ftxt=userEmail' >" + links[1] + "</a></li>");
                    }
                }
                else if("share".equals(links[0]) && links.length > 1 ){ 
                    outStream.append("<li><div id='share'>");
                    outStream.append("<div class='socialsharing share'><a href='#'>" + links[1] + "</a></div>");
                    outStream.append("<div id='share_spacer'></div>");
                    outStream.append("<div class='alt' id='share_flyout' style='display: none; top: 30px; left: 26px;'>");
                    outStream.append("<a class='shareEmailAction' title='" + emailHoverText + "' href='javascript:void(0)' ><img alt='" + emailHoverText + "' src='" + currentDesignPath + "/images/action_send.gif'></a>");
                    outStream.append("<a class='shareGetAction' title='" + getLinkHoverText + "' href=\"javascript:DisplayAlert('AlertBox',100,500)\" ><img alt='" + getLinkHoverText + "' src='" + currentDesignPath + "/images/action_link.gif'></a>");
                    //     outStream.append("<a class='sharebookmarksAction' title='" + bookmarksHoverText + "' href='javascript:void(0)' ><img alt='" + bookmarksHoverText + "' src='" + currentDesignPath + "/images/action_register.gif'></a>");
                    outStream.append("</div>");
                    outStream.append("</div></li>");                
                } 
                else if("search".equals(links[0]) && links.length > 2 ){
                    outStream.append("<li><a href='" + links[2] + "?vpHandle=/accessmcd/global&avcol=default&selSites=default&qt=&ql=a&la=" + language + "&mkt=" + view + "' >" + links[1] + "</a></li>");  
                } 
                else if("bookmark".equals(links[0]) && links.length > 1 ){
                    outStream.append("<li id='li_mysite'>"); 
                    outStream.append("<a id='mySiteLinksList' href='javascript:void(0)' >" + links[1] + "</a>");
                    outStream.append("<div class='top-subNavBookmark'><ul id='bookmarksList'> </ul></div>");
                    outStream.append("</li>"); 
                } 
                else if("print".equals(links[0]) && links.length > 1 ) {
                    outStream.append("<li><a class='printLink' onclick=\"NewPrintWindow(this.href,'name',945,600,'yes','no');return false;\" href='javascript:void(0)'>" + links[1] + "</a></li>"); 
                }  
                else if("other".equals(links[0]) && links.length > 2 && links[3].equals("false") ){ 
                    if(links[1].equalsIgnoreCase("Search History") || links[1].equalsIgnoreCase("Historique de recherche")){
                        outStream.append("<li><a href='" + commonUtil.getValidURL(links[2],mcdAudience)+"?nocache=y" + "' >" + links[1] + "</a></li>");
                    }
                    else{
                        outStream.append("<li><a href='" + commonUtil.getValidURL(links[2],mcdAudience) + "' >" + links[1] + "</a></li>");
                    }
                }
                else if("other".equals(links[0]) && links.length > 2 && links[3].equals("true") ) { 
                    if(commonUtil.isInternalLink(links[2],request)){
                        outStream.append("<li><a href='javascript:openLink(\" "  + commonUtil.getValidURL(links[2],mcdAudience) + "\");' >" + links[1] + "</a></li>");
                    }
                    else{
                        outStream.append("<li><a href='javascript:openLink(\" "  + commonUtil.getValidURL(links[2]) + "\");' >" + links[1] + "</a></li>");
                    } 
                }    
            } 
        }      
        // return the html code as string //  
        return outStream.toString();
    
    }

%>