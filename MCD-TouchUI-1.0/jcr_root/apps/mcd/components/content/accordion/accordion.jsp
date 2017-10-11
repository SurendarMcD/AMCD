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

<%@ page import="java.util.ArrayList,java.util.List,com.day.cq.wcm.api.WCMMode" %> 
<%@include file="/apps/mcd/global/global.jsp"%>
<%    
    //Retrieve the value of the accordion data
    String[] accordianData = (properties.containsKey("accordiandata"))? properties.get("accordiandata", String[].class) : null;
    String accordionId = properties.get("accordionId","");
    String bottomPadding = properties.get("btmpadding","0");
    if(!"".equals(bottomPadding))
    {
        bottomPadding = "padding-bottom:" + bottomPadding + "px;";
    }
%>

<%-- Start of Accordion Div --%> 
    <div id="accordion_top" class="acc_main_rounded accordion_top">
        <div id="accordion_bottom">
            <div id="accordion">
            <div id="acc_<%=currentNode.getName()%>_<%=currentNode.getParent().getName()%>">
<%
    if(null != accordianData)
    {
        for(int i=0; i<accordianData.length; i++)
        {
            String[] accordianItem = accordianData[i].split("\\|");//split the item data
            //display the heading text of the accordion item
            if(accordianItem.length>1 && (!"".equals(accordianItem[0])))
            {
                String accQues=accordianItem[0];
                accQues=accQues.replaceAll("\\(pipeseparator\\)","|");
            %>
                <h4>
                    <a href="#" class="active_widget"><%=accQues%></a>
                </h4>
            <%
            } 
            %>
                <div>
                    <div class="active_segment"  >
            <%
                //check for the description of the item
                if(accordianItem.length>1 && (!"".equals(accordianItem[1])))
                {
                    /*Commented HCL-11/19/2010
                    String accDetail = bumperEncryption.getBumperRichLink(accordianItem[1]);//for bumper implementation
                    */
                    String accDetail = accordianItem[1];
                    accDetail=accDetail.replaceAll("\\(pipeseparator\\)","|");                    
                %>
                            <%=accDetail%>
                <%
                }
                
            %>
                    </div>
                </div>
            <%
        }
    }
    else
    {
        %><div id="accNoData">
        <%= langText.get("Please enter some value in dialog box.") %>
        <%
    }
%>
            </div>
            </div>
        </div>
    </div>
<%-- End of Accordion Div --%>

    <div class="accordion_spacer" style="<%=bottomPadding%>"></div>

<SCRIPT type=text/javascript>
$('#acc_<%=currentNode.getName()%>_<%=currentNode.getParent().getName()%>').accordion({ active: 0, autoHeight: false });
</SCRIPT> 


<%
    if(WCMMode.fromRequest(request) == WCMMode.EDIT || WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.PREVIEW){
%>    

	<style>
        .ui-accordion-header-icon{
            left: auto !important;
            top: 0% !important;
        }
	</style>
<%
    }
%>


