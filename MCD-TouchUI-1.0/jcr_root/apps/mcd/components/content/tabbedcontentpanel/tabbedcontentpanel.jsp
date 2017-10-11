    <%-- #############################################################################
# DESCRIPTION:  Tabbed Content Panel component
#
# Author: Saurabh 
# Environment: 
# 
# INTERFACE  
# Controller: 
# Targets: 
# Inputs:
#                    
# Outputs:      
# 
# UPDATE HISTORY       
# 1.0  Saurabh Batra, 18-02-2010, Initial Version 
# 
# Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
###################################################################################--%>
<%@ page import="com.day.cq.wcm.foundation.Download,
        com.day.cq.wcm.api.components.DropTarget,
        com.day.cq.wcm.api.WCMMode,
        com.day.text.Text,
        com.day.cq.wcm.foundation.Paragraph,
        org.apache.commons.lang.StringEscapeUtils,
        com.day.cq.wcm.api.components.Toolbar,
        java.util.Map,com.day.cq.wcm.foundation.Image,java.util.LinkedHashMap,
        java.util.Iterator,java.util.List,java.util.Map,java.util.Set" %><%
%>
<%@include file="/apps/mcd/global/global.jsp"%>


<script type="text/javascript">
   $(document).ready(function(){ 
      $('#tab_<%=currentNode.getName()%>_<%=currentNode.getParent().getName()%>').tabs();
     //$('.tabid1').click( function() { $('div.accordion').fadeOut(0).fadeIn(0); });          
     //$('.tabid2').click( function() { $('div.accordion').fadeOut(0).fadeIn(0); });  
     //$('.tabid3').click( function() { $('div.accordion').fadeOut(0).fadeIn(0); }); 
     //$('.tabid4').click( function() { $('div.accordion').fadeOut(0).fadeIn(0); }); 
     //$('.tabid5').click( function() { $('div.accordion').fadeOut(0).fadeIn(0); }); 
});
</script> 

<!--[if IE7]>
.tabbedcontentpanel .ui-tabs-panel {
    top: 0px !important;
    left: 0px !important;    
    margin: 0 0 0 0px !important;
}
<![endif]-->
  
<!--[if IE 8]> 
<style>

.wide-ui-tabs-panel {
    -moz-border-radius: 0.5em;
    -webkit-border-radius: 0.5em;
    -moz-border-radius-topleft: 0em;
    -webkit-border-top-left-radius: 0em;  
}

.tabbedcontentpanel {
    position: relative !important;
}

.tabbedcontentpanel .ui-tabs-panel {
    top: 33px !important;
    left: 0px !important;    
    margin: 0 0 0 0px !important;
}    
    
.ui-tabs-hide {
    display: none !important;
}

.ui-tabs-nav {
    z-index: 1 !important;
}

.tabbedcontentpanel .ui-tabs-panel {
    z-index: 2 !important;
}
</style>
<![endif]-->

<style>
.ui-tabs-panel {
    -moz-border-radius: 0.5em; 
    -webkit-border-radius: 0.5em;
    -moz-border-radius-topleft: 0em;    
    -webkit-border-top-left-radius: 0em;    
}
</style>


<%
String tabType=properties.get("tabType","normal");
String ulStyle=(tabType.equals("wide"))?" class='wide-ui-tabs-nav'":"";
String divStyle=(tabType.equals("wide"))?" wide-ui-tabs-panel\" ":"\" style='overflow:hidden;'";
//divStyle=(tabType.equals("wide"))?"\" class='wide-ui-tabs-panel'":"\" style='overflow:hidden;'";           
boolean displayFirstTab=properties.get("displayFirstTab",true);    
String bottomPadding = properties.get("btmpadding","");
if(!"".equals(bottomPadding))                   
{ 
    bottomPadding = "height:" + bottomPadding + "px;";
} 

LinkedHashMap titles=new LinkedHashMap();
for (int index=0;index<5;index++)
{
    if(null!=properties.get("tabTitle"+index))
    {
        titles.put("tabTitle"+index,properties.get("tabTitle"+index));
    }
}
int numTitles=titles.size();

if(numTitles==0)
{
    out.println(langText.get("Please enter tab title in dialog"));
}
else
{
if(tabType.equals("normal"))
{
%>
    <div id="tab_<%=currentNode.getName()%>_<%=currentNode.getParent().getName()%>" class="white_tabs">
<%
}
else
{
%>  
    <div id="tab_<%=currentNode.getName()%>_<%=currentNode.getParent().getName()%>"  class="wide-tabs">
<%
}


Set titleValues=titles.entrySet();
Iterator titleItr=titleValues.iterator();
int index=0;
int tabCount = 1;
for (int i=0;i<2;i++)
{
    if(i==0)
    {
        out.println("<ul"+ulStyle+">");
    }
    while(titleItr.hasNext())
    {
        Map.Entry e=(Map.Entry)titleItr.next();
        if(i==0)
        {
            String aid = "tabid"+tabCount;
            out.println("<li><a id="+aid+" class="+aid+" href='#tab"+currentNode.getName()+e.getKey()+"' ><span>"+e.getValue()+"</span></a></li>");
        }  
        else
        {
            String parPath = currentNode.getName()+e.getKey();
%>
    <div id="tab<%=currentNode.getName()+e.getKey() %>" class="tab<%=currentNode.getName()+e.getKey() %> <%=divStyle %>>
           <cq:include path="<%=parPath %>" resourceType="foundation/components/parsys" />       
    </div>          
<%
        }
        tabCount++;
    }
    if(i==0)
    {
        out.println("</ul>");
        titleItr=titleValues.iterator();
    }
}

%>
</div>

 <div class="tabs_spacer" style="<%=bottomPadding%>;"></div>
 <div style="clear:both"></div>

<%
   
if (WCMMode.fromRequest(request) != WCMMode.DESIGN)
{   
%>
    <script>
    $('#tab_<%=currentNode.getName()%>_<%=currentNode.getParent().getName()%>').each(function(i) {

      var currentTag="";

    $("#tab_<%=currentNode.getName()%>_<%=currentNode.getParent().getName()%> li a").click(function(){
        
        tagSelected($(this));
       
    });

     function tagSelected(selectedTag)
     {
        currentTag=selectedTag;
        
        if(currentTag.parents('li').hasClass('ui-tabs-selected') )
        {  
            var rtValue = checkcqdiv($('.ytb-text').attr('class'),'<%=WCMMode.fromRequest(request) %>');
        }
        else
        {  
        $('#tab_<%=currentNode.getName()%>_<%=currentNode.getParent().getName()%> li').each(function(i) {
        if($(this).hasClass('first-tab-selected')){
            $(this).removeClass('first-tab-selected');
          
        }
        });

           $('.ui-tabs #tabtabbedcontentpaneltabTitle0').removeClass('ui-tabs-hide');
           currentTag.parent().addClass('ui-tabs-selected').siblings().removeClass('ui-tabs-selected');   

            setTimeout ( "tagSelected(currentTag);", 2000 );
        }

     } 
    });     
    </script>
<%
}
%>
<script>

var mode= "";

$(function(){
var displayFirstTab='<%=displayFirstTab%>';

if(displayFirstTab=='false' && '<%=WCMMode.fromRequest(request)%>'!='DESIGN')
{    
    <%
    titleItr=titleValues.iterator();
    Map.Entry e=(Map.Entry)titleItr.next();
    String divHide="tab"+currentNode.getName()+e.getKey();
    
    %>
 $('.<%=divHide %>').addClass('ui-tabs-hide');
 
}else{
    $('#tab_<%=currentNode.getName()%>_<%=currentNode.getParent().getName()%> li:first').addClass('first-tab-selected');






}





mode='<%=WCMMode.fromRequest(request)%>';

if(mode=='EDIT')
{
    var clickVar = checkcqdiv($('.ytb-text').attr('class'),mode);
}
});

function checkcqdiv(val, mode)
{
    
    if(mode=='EDIT')
    { 
        if(val)
        {
       
          $('.cq-editbar').each(function(itr){
          var left=$(this).css('left').replace("px","");
          var top=$(this).css('top').replace("px","");
          var class1=$(this).attr('class');          
          if(class1.indexOf("tabbedcontentpanel")>-1 )
          {

              if(left<=1 || top <=1 )
              {
                $(this).css('display','none');
              }
              else if($(this).css('display')=='none')
              {
                $(this).css('display','block');
              }
            
          }
          });//Code to eliminate the editbar that hangs on the top left corner in Tab component
          
          $('.cq-editrollover-insert-container').each(function(i){
                   var width=$(this).css('width');
                   if(width=='0px')
                   {
                      $(this).css('display','none');
                   }
                   else
                   {
                       $(this).css('display','block');
                   }
                   
                   });
              return true;    
        } 
        else
        { 
         setTimeout ( "var clickVar1 = checkcqdiv($('.ytb-text').attr('class'),mode);if(clickVar1){$('#tabid2').triggerHandler('click'); $('#tabid1').triggerHandler('click');}", 2000 );
        }
        return false;
        
    }
}
<!-- DD_roundies.addRule(".wide-ui-tabs-panel",'0em 0.5em 0.5em ',true); -->
  
  
</script> 
<% 
}
%>     