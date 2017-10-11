<%@include file="/apps/mcd/global/global.jsp"%>      
<%@ page import="com.day.cq.security.User,
                com.day.cq.wcm.api.WCMMode,
                com.mcd.accessmcd.util.CommonUtil"%> 
                
<cq:includeClientLib categories="trending"/> 

<style>
    #flexiselDemo1, #flexiselDemo2, #flexiselDemo3 {  
        background: none repeat scroll 0 0 #DEDEDE !important; 
    }
    
</style>

<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache"); 
    
    CommonUtil commonUtil = new CommonUtil();
    String displayType = properties.get("displayOption","horizontal");
    String heading = "";
    String keyword = "";
    String fontSize = "";   
    String link = "";
    String groups = "";
    String newWindow = "false";
    String target= "_self";
    String textColor = "";
    String hoverColor = "";
    String[] trendingData = properties.get("trendingItem",String[].class);
    WCMMode wcmMode= WCMMode.fromRequest(request);  
    int items = 0;
    boolean wcmModeDisabled = false;   
    
    if(!displayType.equals("textcloud"))
    {              
                heading = properties.get("heading","");
                if(heading.trim().equals(""))
                {
                    heading = "TRENDING";
                }          
    }   
     
     
    if(null!=trendingData){
        items = trendingData.length;        
    }
    else{
        if (wcmMode == WCMMode.EDIT){
%>
            <div id="new">
                <div id="trendingNoData"><%=langText.get("Please enter data in Trending Now component.")%></div>  
            </div>
<% 
        } 
    }
    
    if (wcmMode == WCMMode.DISABLED)
    {
        wcmModeDisabled = true;
    }
    
    
%>
<div class="tritems">
</div>
<script>
    /*$(document).ready(function(){  
    
        var currentPage_Path = '<%=currentPage.getPath()%>';
        var items = 0;
        items = <%=items%>;
        
        if(<%=items%> > 0)
        {
            getUserDetailsTrend(currentPage_Path);
            
        } 
      
    });*/

    var currentPage_Path = '<%=currentPage.getPath()%>';
    var items = 0;
    items = <%=items%>;
    
    if(<%=items%> > 0){
        getUserDetailsTrend(currentPage_Path);
    } 
    
    function getUserDetailsTrend(currentPage_Path) 
    {
         if(!getUserInfoObject(currentPage_Path)){
             setTimeout(function(){getUserDetailsTrend(currentPage_Path)},25);
             return;
         }
        
       var audienceType = UserInfoObject.mcdAudience;       
       var alias = UserInfoObject.alias;       
      
       var url = currentPage_Path + '.trendingGlob.'+alias+'.html';              
       $.ajax({
            url: url,
            type: 'GET',    
            timeout: 10000, 
            data: '', 
            dataType : "html",
            cache: true,   
            error: function(){
              //alert("ERROR");
               //getUserDetailsTrend(currentPage_Path);
               return;
            },    
            success: function(data){                                      
                    if(data.indexOf("HTTP 500")>-1){
                        getUserDetailsTrend(currentPage_Path);
                    }else{
                            $(".tritems").append(data);
                            var displayType = "<%=displayType%>";   
                            if(displayType.indexOf("textcloud") == 0)
                            {
                                var children = $("ul.tagcloud").children().html();
                                if(children == undefined)
                                {                                    
                                   $("#tagbox").css("display","none");
                                   $("#tagbox").css("border-color","#ffffff");                                   
                                   
                                }           
                            }
                            else
                            {
                                $(".trending").css("margin-top","-10px");                                   
                                var children = $("#flexiselDemo1").children().html();
                                if(children == undefined)
                                {            
                                   $(".trendingData").css("display","none");
                                   $(".trendingData").css("background-color","#ffffff");                                   
                                                                                
                                }else
                                {
                                    var numItems = $("#flexiselDemo1 li").length;
                                    var paraWidth = $(".trending").parent().parent().width();  
                                    //alert("LIs" + numItems);
                                    if(numItems > 0)
                                    {                      
                                        if(numItems > 5)
                                        {
                                            //alert("More than 5");
                                            //$(".trending").css("width",paraWidth);   
                                            $("#flexiselDemo1").flexisel()
                                            //alert("1");
                                            //$(".nbs-flexisel-container").css("width",paraWidth-225); 
                                            //$("#flexiselDemo1").css("padding-left","0px");
                                            //$(".nbs-flexisel-nav-left").css('opacity', '0.5');              
                                        }
                                        else
                                        {            
                                            $("#flexiselDemo1").flexisel({
                                                visibleItems: numItems
                                            }); 
                                            $(".nbs-flexisel-nav-left").css("display","none");
                                            $(".nbs-flexisel-nav-right").css("display","none");
                                        }                               

                                        var heading = decodeURI(encodeURI("<%=heading%>"));
                                        
                                        $(".trendingData .float_left").prepend('<div class="float_left trending_text" style="width:123px !important">'+heading+'</div>');
                                        
                                        if(heading.indexOf("Trending Now")==0 || heading.indexOf("TRENDING NOW")==0)
                                        {
                                            $(".trending_text").css("text-align","left");
                                        }
                                        
                                        $(".nbs-flexisel-container").css("position","absolute");
                                        $(".nbs-flexisel-container").css("margin-left","143px");
                                    
                                    }
                                    if(numItems == 0){                                    
                                        $(".trendingData").css("display","none");
                                    }
                                }
                        }                                       
                    }
            }
        });                
    }
    
    
          
</script>

