<%-- #############################################################################
# DESCRIPTION:  Flash Utility Component is used to upload assets of flash
#
# Author: Deepali 
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
# 1.0  Deepali Goyal, 05-05-2010, Initial Version 
# 
# Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
###################################################################################--%>

<%@page session="false"
        contentType="text/html"
        pageEncoding="utf-8"
        import="java.util.Iterator,
            javax.jcr.Node,
            org.apache.jackrabbit.util.Text,
            com.day.cq.wcm.foundation.Download,
            com.day.cq.wcm.api.components.DropTarget,
            com.day.cq.wcm.api.WCMMode,
            com.day.cq.wcm.commons.WCMUtils,
            java.util.zip.ZipInputStream,
            java.util.zip.ZipEntry,
            java.util.Calendar,
            javax.activation.MimetypesFileTypeMap,
            java.io.FileInputStream,
            java.io.InputStream,
            java.io.File,
            java.io.FileOutputStream,
            java.io.IOException,
            java.io.FileNotFoundException,
            jxl.*,
            jxl.read.biff.BiffException,
            org.apache.sling.commons.json.*,
            org.apache.sling.commons.json.JSONException,
            org.apache.sling.commons.json.io.JSONWriter,
            java.util.*,
            java.io.*,
            com.mcd.accessmcd.ace.manager.ACEManager" %><%
%><%@include file="/apps/mcd/global/global.jsp"%>
  
<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0">

<!--[if lt IE 9]>
    <script src="/wog/script/html5.js"></script>
<![endif]-->

<!--[if lt IE 9]>
    <script src="/wog/script/css3-mediaqueries.js"></script>
<![endif]-->
<link type="text/css" rel="stylesheet" href="/wog/style/style.css" />
<!--[if IE 7]>
    <script type="text/javascript">
        var ieCss="";
        try
        {
            if(document.documentMode==7){
                ieCss="ie7.css";
                
            } 
        } catch(exception)
        {
            ieCss="ie7.css";
        }
        document.writeln('<link rel="stylesheet" type="text/css" href="/wog/style/' + ieCss + '">');
    </script>
<![endif]--> 
<!--[if IE 8]>
    <script type="text/javascript">
        var ieCss="";
        try
        {
            if(document.documentMode==7){
                ieCss="ie7.css";
                
            } 
        } catch(exception)
        {
            ieCss="ie7.css";
        }
        document.writeln('<link rel="stylesheet" type="text/css" href="/wog/style/' + ieCss + '">');
    </script>
<![endif]--> 
<link rel="stylesheet" type="text/css" href="/wog/style/magnific-popup.css">
<link type="text/css" rel="stylesheet" href="/wog/style/media_queries.css" />
<link type="text/css" rel="stylesheet" href="/wog/style/jquery-ui.css" />

<script type="text/javascript" src="/wog/script/jquery-1.10.1.min.js"></script>
<script type="text/javascript" src="/wog/script/jquery.fancybox.js"></script>
<link rel="stylesheet" type="text/css" href="/wog/style/jquery.fancybox.css" media="screen" />
<script type="text/javascript" src="/wog/script/jquery-ui.js"></script>

<script src="/wog/script/common.js"></script>


<style>
#search_description{
    margin:10px auto;
    text-align:justify;
}
.showmore{
    mar gin:10px 0px 35px 0px;
    margin:10px auto;
    font-weight:bold;
}

.highlight{ background-color:yellow; }

.fancybox-custom .fancybox-skin {
            box-shadow: 0 0 50px #222;
        }

</style>


<%
    String[] category = (properties.containsKey("menucategory"))? properties.get("menucategory", String[].class) : null;         
    if(category != null){
%>
<input type="hidden" name="emailaction" id="emailaction" value='<%=currentPage.getPath().replaceAll("/content","")%>.emailaction.html' />
<div class="wrapper">
  <form method="GET" action="javascript:submitBrandFacts();" >
    <div class="searchwrapper">
      <div class="selectarea ie7selectarea">
        <select id="selectBox" class="selmenu">
          <option>Select Categories</option>
<%
            if(null != category){
                for(int i=0; i<category.length; i++){
                    String categoryItem = category[i];
%>          
                    <option value="<%=categoryItem%>"><%=categoryItem%></option>
<%
                }
            }
%>        
        </select>
      </div>
      
      <div class="inputarea">
        <%--<input type="text" name="wogsearchbox" value="Enter keywords or text to search"  onfocus="this.value='';" onblur=" if(this.value.trimAll()==''){this.value='Enter keywords or text to search'; }" id="search" class="searchbox" />--%>
        <input type="text" name="wogsearchbox" value="Enter keywords or text to search"  id="search" class="searchbox" />
      </div>
      
      <div class="go_btn">
        <input type="submit" value="Go" id="searchbtn" class="search_btn" />
      </div>
      
      <div class="clear"></div>
   
    </div>
  </form>

    <p id="description"></p>
    <div id="results" class="description"></div>
    <div class="content"></div>
</div>
<%
    }
    else{
%>
     <div><b>Please provide brand facts categories in dialog.</b></div>
<%    
    }
%>
<script>
    $(document).ready(function(){
        wogCategory('/apps/mcd/docroot/wog/worldofgood.json');
    });
</script>
