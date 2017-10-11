<%@include file="/apps/mcd/components/page/global/sitecolors.jsp"%>
<%@page import="com.mcd.accessmcd.common.Constants,
com.mcd.accessmcd.util.CommonUtil,org.apache.commons.lang.StringEscapeUtils;"%>

<script type="text/javascript" src="/etc/designs/mcd/accessmcd/corelibs/core/js/jquery-1.9.0.js"></script>
<script src="/etc/designs/mcd/accessmcd/corelibs/components/content/js/jquery.flexisel.js"></script>

<cq:includeClientLib categories="trending"/> 

<style>
    #tagbox {
        margin-left: 200px;
        width: 25%;
    }
    
    /*** Navigation ***/


.nbs-flexisel-nav-left {
    left: 0px !important;
}
.nbs-flexisel-nav-right {
    right: -10px !important;
}



    
    
    
</style>
<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache"); 
    CommonUtil commonUtil = new CommonUtil();
    int items = 0;
    String []audienceType = Constants.AUDIENCE_TYPE_LIST;
    String displayType = "horizontal";
    String headingText = "";
    String textColor = "";
    String hoverColor = "";
    String trendingItems = "";
    
    if(null != request.getParameter("displayoption")){
        displayType = request.getParameter("displayoption");
        //out.println("<b>Display Type :: </b>" + displayType + "<br><br>");
    }
    if(null != request.getParameter("headingtext")){
        headingText = request.getParameter("headingtext");
        if(("".equals(headingText.trim()))&& displayType.equals("horizontal")){
             headingText = "TRENDING";            
        }
        //out.println("<b>Heading Text :: </b>" + headingText + "<br><br>");
    }
    if(null != request.getParameter("textcolor")){
        textColor = request.getParameter("textcolor");
        //out.println("<b>Text Color :: </b>" + textColor + "<br><br>");
    }
    if(null != request.getParameter("hovercolor")){
        hoverColor = request.getParameter("hovercolor");
        //out.println("<b>Hover Color :: </b>" + hoverColor + "<br><br>");
    }
    if(null != request.getParameter("trendingitems")){
        trendingItems = request.getParameter("trendingitems");
        //out.println("<b>Trending Items :: </b>" + trendingItems + "<br><br>");
    }
%>
<style>
    #flexiselDemo1, #flexiselDemo2, #flexiselDemo3 {
        background: none repeat scroll 0 0 #DEDEDE !important; 
    }
    
    .preview{
        display: block !important;
    }
</style> 

<table border="1" cellpadding="10">   
    <tr>
        <th style="font-size:13px;"> Audience Type </th>
        <th width="1000" style="font-size:13px;"> Layout </th>
    </tr>
<%
    for(int a=0;a<audienceType.length;a++){
%>
    <tr>
        <td style="font-size:12px;"><%=audienceType[a]%></td>
        <td>
<%         
        if(displayType.equals("textcloud")){
            if(!"".equals(trendingItems)){
                String[] trendingItemValues = trendingItems.split("\\^");
                if(trendingItemValues.length > 0){
%>
                    <div id="tagbox">
<%
                    if(headingText.length()!= 0)
                    {
%>                    
                        <div class="tagHdBlack"><div class="tagHeading"><%=headingText%></div></div>    
<%
                    }
%>                        
                        
                          
                            <ul class="<%=textColor%> tagcloud">
<%                
                                        items = trendingItemValues.length;
                                        for(int i=0; i<trendingItemValues.length; i++){
                                            String[] trendingData = trendingItemValues[i].split("\\|");
                                            String keyword = trendingData[0];
                                            String fontSize = trendingData[1];
                                            String link = trendingData[2];
                                            String groups = trendingData[3];
                                            String newWindow = trendingData[4];
                                            String targetOpen = "_self";
                                            if("true".equals(newWindow)){
                                                targetOpen = "_blank";
                                            }
                                            if(groups != null && !"".equals(groups)){
                                                if(groups.contains(audienceType[a])){
                                                    if(link.startsWith("/content/accessmcd")){
                                                        Node pageNode = slingRequest.getResourceResolver().getResource(link + "/jcr:content").adaptTo(Node.class);
                                                        if(pageNode.hasProperty("cq:lastReplicationAction")){
                                                            String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                                                            if(pageStatus.equals("Activate")){
%>    
                                                                <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                                                    <a href="<%=commonUtil.getValidURL(link)%>" target="<%=targetOpen%>">
                                                                        <%=keyword%>
                                                                    </a>
                                                                </li>                              
<%
                                                            }
                                                        }
                                                    }
                                                    else{
%>
                                                        <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                                            <a href="<%=commonUtil.getValidURL(link)%>" target="<%=targetOpen%>">
                                                                <%=keyword%>
                                                            </a>
                                                        </li>                                                   
<%                                            
                                                    }
                                                }
                                            }
                                        }
%>                             
                            </ul>
                    </div>  
<%            
                }
            }
        }        
        else if(displayType.equals("horizontal")){
            if(!"".equals(trendingItems)){
                String[] trendingItemValues = trendingItems.split("\\^");
                if(trendingItemValues.length > 0){
%>
                    <div class="trendingData">  
                        <div class="float_left">
                            <ul class="<%=textColor%> flexiselDemo<%=(a+1)%> list_item" id="flexiselDemo1">
<%                
                                items = trendingItemValues.length;
                                for(int i=0; i<trendingItemValues.length; i++){
                                                                    
                                    String[] trendingData = trendingItemValues[i].split("\\|");
                                    String keyword = trendingData[0];
                                    String fontSize = trendingData[1];
                                    //String fontSize = "";
                                    String link = trendingData[2];
                                    String groups = trendingData[3];
                                    String newWindow = trendingData[4];  
                                    String targetOpen = "_self";
                                    if("true".equals(newWindow)){
                                        targetOpen = "_blank";
                                    }
                                    if(groups != null && !"".equals(groups)){
                                        if(groups.contains(audienceType[a])){
                                            if(link.startsWith("/content/accessmcd")){
                                                Node pageNode = slingRequest.getResourceResolver().getResource(link + "/jcr:content").adaptTo(Node.class);
                                                if(pageNode.hasProperty("cq:lastReplicationAction")){
                                                    String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                                                    if(pageStatus.equals("Activate")){
%>    
                                                        <li id="<%=hoverColor%>" title="<%=keyword%>">
                                                            <a href="<%=commonUtil.getValidURL(link)%>" target="<%=targetOpen%>">
<%
                                                            if(keyword.length()>19){ 
%>                                                        
                                                                <%=keyword.substring(0,16).trim()%>...    
<%
                                                            }
                                                            else{
%>
                                                                <%=keyword%>
<%                                                            
                                                            }
%>                                                        
                                                            </a>
                                                        </li>                              
<%
                                                    }
                                                }
                                            }
                                            else{
%>
                                                <li id="<%=hoverColor%>" title="<%=keyword%>">
                                                    <a href="<%=commonUtil.getValidURL(link)%>" target="<%=targetOpen%>">
<%
                                                    if(keyword.length()>19){ 
%>                                                        
                                                        <%=keyword.substring(0,16).trim()%>...    
<%
                                                    }
                                                    else{
%>
                                                        <%=keyword%>
<%                                                            
                                                    }
%>                                                        
                                                    </a>
                                                </li>                                                   
<%                                            
                                            }
                                        }
                                    }
                                }
%>
                            </ul>
                        </div>
                    </div>  
<%                
                }
            }
        }
%>                        
        </td>
    </tr>
<%
    }
%>

<script>

    $(document).ready(function(){  

        for(var i=1;i<=9;i++)
        {
            var divId = ".flexiselDemo"+i;
            var liTag = ".flexiselDemo"+i+" li";
            var trendingItems = $(liTag).length; 
            if(trendingItems > 0)
            { 
                var compWidth = $("#flexiselDemo1").width();
                compWidth = compWidth + 123 + 20; 
                var paraWidth = $(".trending").parent().parent().width();   
                var items = <%=items%>;
                if(trendingItems > 5){    
                    $(divId).flexisel();                          
                    $(divId).css("padding-left","0px");
                    $(divId).parent().find(".nbs-flexisel-nav-left").css('opacity', '0.5');
                }
                else{                                                   
                    $(divId).flexisel({
                        visibleItems: trendingItems 
                    }); 
                    $(divId).parent().find(".nbs-flexisel-nav-left").css("display","none");
                    $(divId).parent().find(".nbs-flexisel-nav-right").css("display","none");                    
                }                               
            } 
        
        }        
        var heading = decodeURI(encodeURI("<%=headingText%>"));
        
        $(".trendingData .float_left").prepend('<div class="float_left trending_text" style="width:123px !important">'+heading+'</div>');
        var heading = "<%=headingText%>";
        if(heading.indexOf("Trending Now")==0 || heading.indexOf("TRENDING NOW")==0)
        {
            $(".trending_text").css("text-align","left");
        }
        $(".nbs-flexisel-container").css("position","absolute");
        $(".nbs-flexisel-container").css("margin-left","143px");
       
    });
          
</script>

</table>