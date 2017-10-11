<%-- #############################################################################
# DESCRIPTION:  Skip To component helps to allow linking to sections on the same page
#
# Author: Deepali 
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
# 1.0  Deepali Goyal, 22-01-2010, Initial Version 
# 
# Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
###################################################################################--%>

<%@include file="/apps/mcd/global/global.jsp"%><%
%>

<%  
   //Retrieving values from the dialog
   String[] anchorLabel =(properties.containsKey("label"))?properties.get("label", String[].class):null;
   String[] anchor =(properties.containsKey("anchor"))?properties.get("anchor", String[].class):null;
   String dropdownLabel = properties.get("dropdownlabel", langText.get("Skip to"));
   String showLabel = "";
   
   String bottomPadding = properties.get("btmpadding","44");
   if(!"".equals(bottomPadding))
   {
      bottomPadding = "height: " + bottomPadding + "px;";
   }
%>
     
<%   
   if(anchorLabel != null && anchor!= null){
       int i = 0; 
%>         
          <div class="menu_wrap">
          <div class="dropdown_trigger dropdown_header" ><%=dropdownLabel %></div>
          <ul class="dropdown_body">
<% 
        for(i = 0; (anchorLabel.length-1) > i && (anchor.length-1) > i ; i++) {
            showLabel = anchorLabel[i].length() > 36 ? anchorLabel[i].substring(0,33) + "..." : anchorLabel[i];
%>
              <li class="dropdown_node"><a href="<%=anchor[i] %>"><%=showLabel %></a></li>
<%              
        }
        showLabel = anchorLabel[i].length() > 36 ? anchorLabel[i].substring(0,33) + "..." : anchorLabel[i];      
%>
              <li class="dropdown_last_node"><a href="<%=anchor[i] %>"><%=showLabel %></a></li>
                            
          </ul>             
        </div>             
<%  
   } 
   else {
%> 
  <%=langText.get("Please provide labels and the related anchor")%>     
      
<%
   }    
%>
    <div class="clear" style="<%=bottomPadding%>"></div>
    