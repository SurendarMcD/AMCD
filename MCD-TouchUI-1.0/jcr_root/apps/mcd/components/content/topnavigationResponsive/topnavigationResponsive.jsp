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
    
    // code for retrieving the values of the node or dialog //   
    rootPage = properties.get("listroot","");    
    absParentLevel = properties.get("parentLevel","");
    navStoplevel = "1";
    
    
    
%> 
     <div id="rootPath" style="display:none;"><%=rootPage%></div>
     <div id="absParentLevel" style="display:none;"><%=absParentLevel%></div>
     <div class="new-desktop-menu"><div id="div_topnav"></div>
     <div style="clear:left;"></div></div>
<%
    //to protect against 'empty' components which might be in Production
    if(!rootPage.equals("") || !absParentLevel.equals("") || WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.EDIT || WCMMode.fromRequest(request) == WCMMode.PREVIEW){
        boolean checkDesign = designPath.contains("g2g_rwd");  //Added for RWD Implementation    
%>    
        <script>
            var roundCorners = '<%=roundCorners%>';
            var designPath = '<%=designPath%>';
            var rootPage = '<%=rootPage%>';
            var absParentLevel = '<%=absParentLevel%>';
            var navStoplevel = '<%=navStoplevel%>';
            
            var currentPage = '<%=currentPage.getPath()%>';
            var glob = "topnavigationglob";
            
            var parameter = "designPath="+designPath;
            parameter += "&roundCorners="+roundCorners;
            parameter +=  "&rootPage="+rootPage;
            parameter += "&absParentLevel="+absParentLevel;
            parameter += "&navStoplevel="+navStoplevel;
            
            var url = currentPage+"."+glob+".html?"+ parameter;
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
                            loadMenu("<%=roundCorners %>"); 
                        }      
                    }
                });
            }
            loadTopNav(url,0); 
            
            function setTopNavWidth(){
                if($(window).innerWidth() < 1024){
                   $('#nav ul li').each(function(){
                       //$(this).width($(window).width());
                       $('#nav').css('width','100%');
                       $('a',$(this)).css('font-size','12px');
                   })
                } 
                else{
                   //$(this).css('width', 'auto');
                   $('a',$(this)).css('font-size','12px'); 
                }
            }
            
            $(window).resize(function(){
                setTopNavWidth();
            })
            
            $(window).load(function(){
                setTopNavWidth();
            })
            
            $(document).ready(function(){
                setTopNavWidth();
            })
            
        </script>         
<%
    }
%>  
 