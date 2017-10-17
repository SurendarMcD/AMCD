<%-- #############################################################################
# DESCRIPTION:  Accordion component helps to provide a show/hide feature
#               for the description of some headings 
#
# Author: HCL 
# Environment: 
# 
# INTERFACE  
# Controller: 
# Targets: 
# Inputs: global.jsp
#                    
# Outputs:      
#  
# UPDATE HISTORY       
# 1.0  Karan Aggarwal, 22-02-2010, Initial Version 
# 
# Copyright (c) 2010 HCL Technologies Ltd. All rights reserved. 
###################################################################################--%>

<%@ page import="java.util.ArrayList,java.util.List,
                 org.apache.sling.commons.json.*,
                 org.apache.sling.api.resource.ValueMap" %> 
<%@include file="/apps/mcd/global/global.jsp"%>  

<%
    String templateName = currentPage.getTemplate().getName();
    if(templateName.equalsIgnoreCase("g2g")){
%>
        <cq:includeClientLib js="accessmcd.responsivecss" />
        <script>
            $.noConflict();
        </script>

<%   
    }
    String bottomPadding = properties.get("btmpadding","20");
	bottomPadding = bottomPadding + "px;";
    String sectionTitleActiveColor = properties.get("sectionTitleColor","");
	String sectionTitleInactiveColor = properties.get("sectionTitleColorInactive","");
/* GBS Changes */
	String subtitlemarginTop = properties.get("marginTop","0");
	String subtitlepaddingLeft = properties.get("paddingLeft","0");
	String subtitlebtmpadding = properties.get("bottompadding","0");
	String paragraphtop = properties.get("paragraphTop","0");
	String paragraphleft = properties.get("paragraphpaddingLeft","0");
	boolean separatorbtwnsubsection = properties.get("separatorbtwnsubsection",false);
	boolean arrowcheck=properties.get("arrowcheck",false);
	boolean expandcheck=properties.get("expandcheck",false);
	String headerBGColorDisplay="";
	String headerBGColor = properties.get("headerBGColor","");
	if(!"".equals(headerBGColor)){
    headerBGColorDisplay = "background-color:#" + headerBGColor + "!important;";
    }

%>
	<style>
        .panel-default .panel-heading.active{
        	<%= headerBGColorDisplay%>
        }        
    </style>
<!-- GBS Changes END! -->
<% if(!"".equals(sectionTitleActiveColor.trim())){
        %>
<style>
        .excontainer.mid-year-conversation .panel-heading.active h4{
            color: #<%=sectionTitleActiveColor%> !important;
        }  
    </style>

<%    
    }
    if(!"".equals(sectionTitleInactiveColor.trim())){
%>

	<style>
    .excontainer.mid-year-conversation .panel-heading h4{
        color: #<%=sectionTitleInactiveColor%>  !important;
    } 

</style> 
<%    
    }
    String subSectionBGColor = properties.get("subBGColor","");
    if(!"".equals(subSectionBGColor.trim())){
%>
    <style>
        .acc-sub-section{
            background: #<%=subSectionBGColor%> !important;
        }
    </style>
<%    
    }
    String subTitleColor = properties.get("subTitleColor","");
    if(!"".equals(subTitleColor.trim())){
%>
    <style>
        .acc-sub-heading {
            color: #<%=subTitleColor%>  !important;
        }
    </style>
<%    
    }

    String[] accordianData = (properties.containsKey("expandableData"))? properties.get("expandableData", String[].class) : null;
    String imagePadding = "";
    if(null != accordianData){
%>    

        <section class="callouts-container" style="padding-bottom:<%=bottomPadding%>">
            <div class="excontainer mid-year-conversation">
                <div class=" accordian-container">
                    <% if (expandcheck) { %>
                    <a class="waves-effect waves-light btn expand-btn" onClick="expandAll();" style="margin: 10px 0px;padding: 5px 10px;color: #fff;">Expand All</a>
                    <a class="waves-effect waves-light btn collapse-btn" onClick="collapseAll();" style="display:none;margin: 10px 0px;padding: 5px 10px;color: #fff;">Collapse All</a>
                    <% } %>
                    <div id="accordion" role="tablist" aria-multiselectable="true">

<%  
                            for(int i=0; i<accordianData.length; i++){
                                String jsonData = accordianData[i];
                                JSONObject jsonObject = new JSONObject(jsonData);
                                String question = jsonObject.getString("question");
    						    String collapseTarget = question.replaceAll("[^a-zA-Z]+", "").toLowerCase();
                                String collapseClass = "";
                                String activeClass = "";
                                if(i == 0){
                                    collapseClass = "in";
                                    activeClass = "active";
                                }

%>    

                                <div class="panel panel-default">

                                    <div class="panel-heading <%=activeClass%>" style="<%= headerBGColor%>"role="tab" id="headingOne<%=collapseTarget%>" data-parent="#accordion" aria-expanded="true" data-toggle="collapse" data-target="#<%=collapseTarget%>" aria-controls="<%=collapseTarget%>">
                                        <h4 class="panel-title"><%=question%> </h4>
                                    </div>
                                    <div id="<%=collapseTarget%>" class="panel-collapse collapse <%=collapseClass%>" role="tabpanel" aria-labelledby="headingOne<%=collapseTarget%>">
<%
                                    JSONArray questionsArray = jsonObject.getJSONArray("./subQuestions");
                                    for(int q = 0; q < questionsArray.length(); q++) {          
                                        JSONObject quesObject = questionsArray.getJSONObject(q);          
                                        String subQuestion = quesObject.getString("subQues");
                                        String imagePath = quesObject.getString("imagePath");             
                                        String text = quesObject.getString("text");
%> 

                                        <div class="acc-sub-section">
<%
                                            if(!"".equals(imagePath.trim())){
%>                                        
                                                <img src="<%=imagePath%>" alt="" class="img-responsive acc-icon">
<%
                                            }
                                            else{
                                                imagePadding = "padding-left:10px !important;";                                                
                                            }
%>                                            
                                            <div class="acc-sub-content" style="<%=imagePadding%>">
<%
                                                if(!"".equals(subQuestion.trim())){
%>                                                
                                                <h5 class="acc-sub-heading"><%=subQuestion%></h5>
                                                <!-- GBS Changes -->
                                                <style>
                                                .acc-sub-heading{padding-left:<%= subtitlepaddingLeft%>px;}
                                                .acc-sub-heading {margin-top:<%= subtitlemarginTop%>px;}
                                                .acc-sub-section:last-child{padding-bottom:<%= subtitlebtmpadding%>px;}
                                                .acc-sub-section p {padding-left:<%= paragraphleft%>px;}
                                                .acc-sub-section p {padding-top:<%= paragraphtop%>px;}

                                                </style>
<%
                                                } 
%>                                             
                                                <!-- GBS Changes END! -->
                                                <%=text%>
                                            </div>
                                        </div>                              
<%
                                }
%>
                                    </div>
                                </div>                                
<%                                
                            }
%>                                
                    </div>
                </div>
            </div>
        </section>
<%
    }
    else{        
%>
        <h2>Please enter data in dialog.</h2>
<%
    }
%>
<!-- GBS Changes -->
<% if (arrowcheck) { %>
<style>
	.panel-default .panel-heading{
        background-image:url('/apps/mcd/components/content/expandableContent/images/right_arrow_accordion.png');
        background-repeat:no-repeat;
        background-position: 98% 50%;
        background-size: 10px;
    }
    .panel-default .panel-heading.active{
        background-image:url('/apps/mcd/components/content/expandableContent/images/down_arrow_accordion.png') !important;
        background-repeat:no-repeat;
        background-position: 98% 50%;
        background-size: 20px;
    }
    .panel-default .collapsed{
        background-image:url('/apps/mcd/components/content/expandableContent/images/right_arrow_accordion.png') !important;
        background-repeat:no-repeat;
        background-position: 98% 50%;
        background-size: 10px;
    }

  </style>

<% } %>
<% if(separatorbtwnsubsection) { %>
<style>
	.acc-sub-section{background:#e6e6e6;margin-top: 10px;}
    .acc-sub-section:first-child{margin-top: 10px;} 
    </style>
<% }else{ %>
<style>

    .acc-sub-section{background:#e6e6e6;margin-top: 0px;}
 	.acc-sub-section:first-child{margin-top: 10px;} 
    </style>

<% } %>

<script>
	$(document).ready(function(){
		$('.panel').children('.panel-heading').removeClass('active');	
        $('.panel').children('.panel-collapse').removeClass('in');

    });

	var expandAllFlag=0;

    $('.excontainer.mid-year-conversation .panel-heading').click(function(event) {
        if(expandAllFlag==0){
			$(this).parent('.panel').siblings().children('.panel-heading').removeClass('active');
        }
        if($(this).hasClass('active')){
			$(this).removeClass('active'); 
        }
        else{
            $(this).addClass('active'); 
        }
        if(expandAllFlag==1){
			checkAllTabs();
        }

    });

//Code to expand and collapse accordian on click of Expand all collapse all button
    function expandAll(){
        $('.panel').children('.panel-heading').addClass('active');
		$('.panel').children('.panel-collapse').addClass('in').css("height","auto");
        $('.expand-btn').css("display","none");
        $('.collapse-btn').css("display","inline-block");
        expandAllFlag=1;
    }
    function collapseAll(){
		$('.panel').children('.panel-heading').removeClass('active');
        $('.panel').children('.panel-collapse').removeClass('in');
        $('.collapse-btn').css("display","none");
        $('.expand-btn').css("display","inline-block");
        expandAllFlag=0;
    } 

    function checkAllTabs(){

        var openTabCount=0;
		$(".panel .panel-heading").each(function(index){
            if($(this).hasClass("active")){
				openTabCount++;
            }
        });
        if(openTabCount == 0){

			$('.collapse-btn').css("display","none");
        	$('.expand-btn').css("display","inline-block");
            expandAllFlag=0;
        }
    }s
</script>
<!-- GBS Changes END!-->