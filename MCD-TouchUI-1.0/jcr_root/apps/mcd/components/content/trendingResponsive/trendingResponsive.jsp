<%@include file="/apps/mcd/global/global.jsp"%>      
<%@ page import="com.day.cq.security.User,
                com.day.cq.wcm.api.WCMMode,
                com.mcd.accessmcd.util.CommonUtil"%> 
                
<cq:includeClientLib categories="trendingRes"/> 

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
                <div id="trendingNoData" style="font-weight:bold;"><%=langText.get("Please enter data in Trending Now component.")%></div>  
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
      
       var url = currentPage_Path + '.trendingGlobRes.'+alias+'.html';              
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
                    }
            }
        });                
    }
    
    
          
</script>

