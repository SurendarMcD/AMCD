<%--
  ==============================================================================

  Top Navigation component

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
    com.day.cq.wcm.foundation.DiffService,
    com.day.cq.wcm.api.WCMMode"%>
 
<%
    //To check whether round corners should be included or not //
    String roundCorners=properties.get("checkRoundCorners","false");
    String designPath=currentDesign.getPath();
    String rootPage = "";
    String absParentLevel = "";
    String navStoplevel = "";
    String dispTopNavImg = "";
    
    // code for retrieving the values of the node or dialog //   
    rootPage = properties.get("listroot","");    
    absParentLevel = properties.get("parentLevel","");
    navStoplevel = "1";
    dispTopNavImg = properties.get("dispTopNavImg","no");
    
%>
<style>

    #rwd_logo_t
    {
        display: none;
    }

</style>
 <!-- Top Nav -->
 
     <div id="div_topnav"></div> 
     <div style="clear:left;"></div>
     
    
<%
//to protect against 'empty' components which might be in Production
if(!rootPage.equals("")
|| !absParentLevel.equals("")
|| WCMMode.fromRequest(request) == WCMMode.DESIGN 
|| WCMMode.fromRequest(request) == WCMMode.EDIT 
|| WCMMode.fromRequest(request) == WCMMode.PREVIEW
) {

        boolean checkDesign = designPath.contains("g2g_rwd");  //Added for RWD Implementation
        
        
%>    
<script>
   
var roundCorners = '<%=roundCorners%>';
var designPath = '<%=designPath%>';
var rootPage = '<%=rootPage%>';
var absParentLevel = '<%=absParentLevel%>';
var navStoplevel = '<%=navStoplevel%>';
var dispTopNavImg ='<%=dispTopNavImg%>';

var currentPage = '<%=currentPage.getPath()%>';
var glob = "topnavigationglob";

var parameter = "designPath="+designPath;
parameter += "&roundCorners="+roundCorners;
parameter +=  "&rootPage="+rootPage;
parameter += "&absParentLevel="+absParentLevel;
parameter += "&navStoplevel="+navStoplevel;
parameter += "&dispTopNavImg="+dispTopNavImg;

var url = currentPage+"."+glob+".html?"+ parameter;

var checkDesign = '<%=checkDesign%>'; //Added for RWD Implementation


function loadTopNav(url,retry){
    $.ajax({
        url: url,
        type: 'GET',    
        timeout: 6000, 
        data: '', 
        cache: false,   
        error: function(){
          if(retry<5)loadTopNav(url,retry+1); 
        },    
        success: function(xml){                                   
            
            if(document.getElementById('div_topnav')!=null){
               
                    document.getElementById('div_topnav').innerHTML = xml;  
                    
                    //Added for RWD Implementation
                    //START
                        if(checkDesign.match('true'))
                        {          
                            $('#menu-item').slicknav();
                            $('.slicknav_menu').wrap( "<div class='RWDNEW'></div>" );
                            
                            var logoHTML = $('.logo_t').html();
                            
                            $('.RWDNEW').append( "<div id='rwd_logo_t'>" + logoHTML + "</div>" );
                            /*$('#rwd_logo_t').css('float','left');
                            $('#rwd_logo_t').css('position','absolute');
                            $('#rwd_logo_t').css('top','0');*/
                        } 
                    //END
                    
                    loadMenu("<%=roundCorners %>"); 

            }      
        }
    });
}
loadTopNav(url,0);
              
</script>         
<%
}
%>  



<script>
$(document).ready(function(){});
</script>  
            
    