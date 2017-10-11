<%-- 

  Feature Story component.

 Author: Deepak Jain

--%><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page session="false" %><%
%><%@page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.Page, com.mcd.util.PropertiesLoader,
    java.util.Properties, java.util.Iterator,
    com.day.cq.wcm.api.PageFilter, java.text.ParseException,
    java.text.SimpleDateFormat, java.text.DateFormat,
    java.util.TreeMap,java.util.Date,java.util.Set,com.mcd.accessmcd.util.CommonUtil,
    com.day.cq.wcm.api.WCMMode"%>  

<%
    String storyType = properties.get("selectionType","");
    String headingText = properties.get("headingText","");
    String headingImage = properties.get("headingImage","");
    String[] storyData = (properties.containsKey("storyData"))? properties.get("storyData", String[].class) : null;
    String seeMoreNewsText = properties.get("seeMoreNewsTitle","See more News Releases");
    String seeMoreNewsLink = properties.get("seeMoreNewsLink","");
    String leftPadding = "";
    if("".equals(headingImage.trim())){
        leftPadding = "padding-left:0px;";
    }
    if(seeMoreNewsLink.startsWith("/content")){
        seeMoreNewsLink = seeMoreNewsLink + ".html";
    }
%>    
    
<div class="mid-section">
<%
    if("news".equals(storyType)){
        if(null != storyData){            
%>
        <div class="">
            <aside class="news-section">
                <h4 class="text-uppercase" style="<%=leftPadding%>background:transparent url('<%=headingImage%>') no-repeat 0 0"><%=headingText%></h4>
                <ul>
<%
                    try{
                        DateFormat storyDateFormat = new SimpleDateFormat("MMMMM dd yyyy");
                        DateFormat dateConvert = new SimpleDateFormat("MM/dd/yy");
                        Image featureImage = null;
                        for(int i=0; i<storyData.length; i++){
                            String pagePath = storyData[i].toString();
                            Page storyPage = pageManager.getPage(pagePath);
                            String headingTitle = storyPage.getProperties().get("featureImageTitle","");
                            String headingLink = storyPage.getPath()+".html";
                            String storyTempDate = storyPage.getProperties().get("featurePublishDate","");
                            String storyDate = "";
                            if(!"".equals(storyTempDate)){
                              Date storyDateObj  = (Date)dateConvert.parse(storyTempDate);
                              storyDate = storyDateFormat.format(storyDateObj);
                            }
                            featureImage = new Image((storyPage).getContentResource(),"featureImage");
                            if(featureImage.hasContent()){
                                featureImage.loadStyleData(currentStyle);
                                featureImage.setSelector(".img"); // use image script
                                // add design information if not default (i.e. for reference paras)
                                if (!currentDesign.equals(resourceDesign)) {
                                    featureImage.setSuffix(currentDesign.getId());
                                }
                            }
%>                    
                            <li>
                                <a href="<%=headingLink%>" style="color:#000;"><strong class="headline"><%=headingTitle%></strong></a>
                                <span class="date"><%=storyDate%></span>
<%
                                if(featureImage.getHref() != null && featureImage.getHref() != ""){
%>                                
                                    <a href="<%=headingLink%>"><img src="<%=featureImage.getHref()%>" alt="" class="img-responsive"></a>
<%
                                }
%>                                
                            </li>                            
<%
                        }
                    }
                    catch(Exception ex){
                        log.error("Exception in News Home Page Stories :: " + ex.getMessage());
                    }
%>                        
                </ul>
<%
                if(!"".equals(seeMoreNewsLink)){
%>                    
                    <div class="see-more"><a href="<%=seeMoreNewsLink%>"><strong><%=seeMoreNewsText%></strong></a></div>
<%
                }
%>                    
            </aside>
        </div>
<%
        }
    }
    else if("leadership".equals(storyType)){
        if(null != storyData){
%>
        <div class="">
            <aside class="leadership-section">
                <h4 class="text-uppercase" style="<%=leftPadding%>background:transparent url('<%=headingImage%>') no-repeat 0 0"><%=headingText%></h4>
<%
                try{
                    Image featureImage = null;
                    for(int i=0; i<storyData.length; i++){
                            String pagePath = storyData[i].toString();
                            Page storyPage = pageManager.getPage(pagePath);
                            String headingTitle = storyPage.getProperties().get("featureImageTitle","");
                            String headingLink = storyPage.getPath()+".html";
                            String storyAuthor = storyPage.getProperties().get("featureAuthorName","");
                            featureImage = new Image((storyPage).getContentResource(),"featureImage");
                            if(featureImage.hasContent()){
                                featureImage.loadStyleData(currentStyle);
                                featureImage.setSelector(".img"); // use image script
                                // add design information if not default (i.e. for reference paras)
                                if (!currentDesign.equals(resourceDesign)) {
                                    featureImage.setSuffix(currentDesign.getId());
                                }
                            }
%>                    
                            <p class="profile-deatils">
<%
                                if(featureImage.getHref() != null && featureImage.getHref() != ""){
%>                                
                                    <a href="<%=headingLink%>"><img src="<%=featureImage.getHref()%>" alt="" class="img-responsive"></a>
<%
                                }
%>                             
                                <a href="<%=headingLink%>"><%=headingTitle%></a>
                                <span class="author"><%=storyAuthor%></span>
                            </p> 
<%
                    }
                }
                catch(Exception ex){
                   log.error("Exception in Leadership Home Page Stories :: " + ex.getMessage()); 
                }
                if(!"".equals(seeMoreNewsLink)){
%>                    
                    <div class="see-more"><a href="<%=seeMoreNewsLink%>"><strong><%=seeMoreNewsText%></strong></a></div>
<%
                }
%>    
            </aside>
        </div>
<%
        }
    }
    else{
        if("progress".equals(storyType)){
%>
                 <div class="">
                    <aside class="progress-section">
                        <h4 class="text-uppercase" style="<%=leftPadding%>background:transparent url('<%=headingImage%>') no-repeat 0 0"><%=headingText%></h4>
                    </aside>
                </div>                
<%            
        }
        else{     
%>
        <h3>Please configure stories using dialog to render on the page.</h3>
<%        
        }
    }
%>    
</div>
<div style="clear:both"></div>