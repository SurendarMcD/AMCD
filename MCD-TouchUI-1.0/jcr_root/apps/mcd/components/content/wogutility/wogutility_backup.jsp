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
            java.util.*" %><%
%><%@include file="/apps/mcd/global/global.jsp"%><% 
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects /><%
%>
 
<table border="0" width="100%" height="530px" cellspacing="0" cellpadding="0">
  <tr>
    <td width="20%" bgcolor="#999966" valign="top">&nbsp;
    
    <div id="xlsupload">
<%
    //hidden field to check if any change has been made in the zip file or not
    String flag = properties.get("flag", "0");

    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "file";
    Download dld = new Download(resource);  
    if(dld.hasContent())
    {
        String href = Text.escape(dld.getHref(), '%', true);
        String title = dld.getTitle(true);
        
%>
        <p style="margin:3 0 0 20"><b>
                <font face="Arial" size="2" color="#000000">
                    &raquo;&nbsp;
                    <a style="color:#000000;font-weight:bold;" href="<%= href%>" title="<%=title%>">Download Sheet</a> <br>
                </font>
        </b></p>
        
    </div><div class="clear"></div>
    
    
    </td>
    
    <td width="100%" valign="top" style="padding:22px 10px 0 25px;">
      <div style="padding-bottom:20px">
            <img src="/libs/foundation/components/download/resources/xls.gif" />
            <font face="Arial" size="2" color="#000000">
                <a style="color:#000000;font-weight:bold;" href="<%= href%>" title="<%=title%>"><%= (dld.getInnerHtml() == null ? dld.getFileName() : dld.getInnerHtml())%></a>
            </font>
      </div>
      
<%   
        //ZipInputStream zip =  new ZipInputStream(dld.getData().getStream());
        JSONObject firstJSONObject; 
        JSONObject secondJSONObject;
        JSONObject fourthJSONObject = new JSONObject();
        Workbook w;
        
        try {
            w = Workbook.getWorkbook(dld.getData().getStream());
            // Get the first sheet
            Sheet sheet = w.getSheet(0);
            ArrayList categoryList = new ArrayList();
            
            for (int j = 1; j < sheet.getRows(); j++) {
                if(!"".equalsIgnoreCase(sheet.getCell(0,j).getContents().trim())){
                    categoryList.add(sheet.getCell(0,j).getContents());
                }
            }
            HashSet hs = new HashSet(); 
            hs.addAll(categoryList); 
            categoryList.clear(); 
            categoryList.addAll(hs);
            for(int a=0;a<categoryList.size();a++){
                //out.println("Category :: " + categoryList.get(a) + "<br>");
                Map rowMap = new HashMap();
                secondJSONObject = new JSONObject();
                for (int j = 1; j < sheet.getRows(); j++) {
                    firstJSONObject = new JSONObject();
                    Map columnMap = new HashMap();
                    for (int i = 0; i < sheet.getColumns(); i++) {
                        Cell cell = sheet.getCell(i,j);
                        CellType type = cell.getType();
                        if(!"".equalsIgnoreCase(cell.getContents().trim())){
                            //out.println("<font size='1'>"+ cell.getContents() + " <b>::</b></font>");
                            
                            columnMap.put(sheet.getCell(i,0).getContents(),cell.getContents());
                            if(cell.getContents().equals(categoryList.get(a).toString())){
                                secondJSONObject.put(Integer.toString(j),columnMap); 
                                fourthJSONObject.put(categoryList.get(a).toString(), secondJSONObject);
                            }
                            //firstJSONObject.put(Integer.toString(i),cell.getContents());
                            //fourthJSONObject.put(categoryList.get(a).toString(), m);
                        }
                    }
                    //rowMap.put(Integer.toString(j),columnMap);
                    //secondJSONObject.put(Integer.toString(j),columnMap); 
                }
                //fourthJSONObject.put(categoryList.get(a).toString(), secondJSONObject);
            }
            String jsonText = JSONObject.valueToString(fourthJSONObject); 
            //String jsonText = fourthJSONObject.toString();
            out.println("<font size='1'>{\" Brand Facts\" :"+jsonText+"}</font>"); 
        } 
        catch (BiffException e) {
            e.printStackTrace();
        }

    }//if xls file is available
    else
    {
%>
    </td>
    
    <td width="100%" valign="top" style="padding:0 10px 0 10px;">
<%
      if (WCMMode.fromRequest(request) == WCMMode.EDIT){
%>
      <br><div class="cq-file-placeholder <%= ddClassName %>" style="text-align: left;"></div>
<%
      }
    }
%>
</div>
    </td>
    
    
    
    <td width="20%" valign="top"></td>
    
  </tr>
</table>

