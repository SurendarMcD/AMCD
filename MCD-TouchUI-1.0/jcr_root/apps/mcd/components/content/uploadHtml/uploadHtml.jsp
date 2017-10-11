<%-- #############################################################################
# DESCRIPTION:  HTML Import component helps in displaying a third party html with
#               proper behavior and styling.
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
# 1.0  Karan Aggarwal, 03-05-2010, Initial Version 
# 
# Copyright (c) 2010 HCL Technologies Ltd. All rights reserved. 
###################################################################################--%>

<%@ page import=" com.day.cq.wcm.foundation.Download,
    com.day.cq.wcm.api.WCMMode,
    com.day.cq.wcm.api.components.DropTarget,
    org.apache.sling.api.resource.Resource,
    java.io.InputStream,
    java.io.IOException,
    java.io.BufferedReader,
    java.io.InputStreamReader" %><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
    
    String html_text = properties.get("html_text","");
    
    //drop target css class = dd prefix + name of the drop target in the edit config 
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "file";    
    //creating the object of the zip file uploaded
    Download dld = new Download(resource);
    
    InputStream is = null; 
    StringBuilder sb = new StringBuilder();
    String line;  
    // extracting the zip file and copying its content to the docroot folder
    if(dld.hasContent())
    {
      try 
      {
        is = dld.getData().getStream(); 

        // Here BufferedInputStream is added for fast reading.
        BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
        while ((line = reader.readLine()) != null) { 
          sb.append(line).append("\n"); 
        }
            
      } catch (IOException e) {
         log.error("Exception In Import Utility :" + e);
      }
      catch (Exception e) {
         log.error("Exception In Import Utility:" + e);
      }
      finally {
         is.close(); 
      }
%>
      <div id="import_html">
           <%=sb.toString()%>
      </div>
<%              
    }
    else if(!"".equals(html_text))
    {
%>
      <div id="import_html">
            <%=html_text%>
      </div>
<%          
    }
    else if (WCMMode.fromRequest(request) == WCMMode.EDIT)
    {
        %><img src="/libs/cq/ui/resources/0.gif" class="cq-file-placeholder <%= ddClassName %>" alt=""><%
    } 
%>   