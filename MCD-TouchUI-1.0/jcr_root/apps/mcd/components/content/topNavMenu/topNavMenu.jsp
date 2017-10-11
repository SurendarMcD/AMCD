<%--

  Top Navigation Menu Bar component.

  Menu Bar component

--%><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page session="false" %><%
%>
<div id="topNavMenuBar"></div>
<script type="text/javascript">
var topNavRetries=0;
function getTopNavigationBar(currentPage_Path) 
    {
         if(!getUserInfoObject(currentPage_Path)){
             setTimeout(function(){getTopNavigationBar(currentPage_Path)},25);
             return;
         }
       if(topNavRetries>5){
           $("#topNavMenuBar").html("Error Loading Menu. Please Refresh Page.");
           return;
       } 
       var audienceType=UserInfoObject.alias;
       var view = UserInfoObject.view;
       var glob = "topNavMenuGlob." + audienceType +topNavRetries+ "." + view;
       var url = UserInfoObject.viewPath + '.'+glob+'.html';
       $.ajax({
            url: url,
            type: 'GET',    
            timeout: 10000, 
            data: '', 
            dataType : "html",
            cache: true,   
            error: function(){
               topNavRetries++;
               getTopNavigationBar(currentPage_Path);
               return;
            },    
            success: function(data){                                      
                    if(data.indexOf("HTTP 500")>-1){
                        topNavRetries++;
                        getTopNavigationBar(currentPage_Path);
                    }else{
                        $("#topNavMenuBar").html(data);
                        setMenu();
                    }
            }
        });                       
    }

    getTopNavigationBar('<%=currentPage.getPath()%>');
    
    
</script>