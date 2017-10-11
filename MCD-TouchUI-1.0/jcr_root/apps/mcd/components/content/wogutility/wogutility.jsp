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
# 
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
%><%@include file="/apps/mcd/global/global.jsp"%><% 
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects /><%
%>
<link rel="stylesheet" href="/wog/style/jquery-ui.css" />
<script type="text/javascript" src="/wog/script/jquery-1.7.2.min.js"></script>
<script src="/wog/script/jquery-ui.js"></script>
<style>
    .ui-progressbar {
        position: relative;
    }
    .progress-label {
        position: absolute;
        left: 50%;
        top: 10px;
        font-weight: bold;
        text-shadow: 1px 1px 0 #fff;
    }
</style>

<table border="0" width="100%" height="1000" cellspacing="0" cellpadding="0">
  <tr>
    <td width="20%" bgcolor="#BCD2EE" valign="top">&nbsp;
    
    
<%
    //hidden field to check if any change has been made in the zip file or not
    String flag = properties.get("flag", "0");

    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "file1";
    Download dld = new Download(resource);    
    
    if(dld.hasContent())
    {
        String href = Text.escape(dld.getHref(), '%', true);
        String title = dld.getTitle(true);
        
%>
    <div id="xlsupload"> 
        <p style="margin:3px 0px 0px 15px">
                <font face="Arial" size="2" color="#000000">
                     &raquo;&nbsp;
                    <a style="color:#000000;font-weight:bold;" href="<%= href%>" title="<%=title%>">Download Brand Facts</a><br><br>
                     &raquo;&nbsp;
                    <a style="color:#000000;font-weight:bold;" href="#" onclick="javascript:replicationJson();">Publish Brand Facts</a>
                    <div id="jsonreplicate" style="display:none;"></div>
                </font>
        </p>
        
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
        if(flag.equals("1")){
            JSONObject firstJSONObject; 
            JSONObject secondJSONObject = new JSONObject();
            JSONArray jArray = new JSONArray();
            
            Workbook w;
            Writer writer = null;
            InputStream is = null;
            
            try {
                w = Workbook.getWorkbook(dld.getData().getStream());
                Sheet sheet = w.getSheet(0);
                //out.println("Rows :: " + sheet.getRows());
                //out.println("Columns :: " + sheet.getColumns());
                for (int j = 1; j < sheet.getRows(); j++) {
                    firstJSONObject = new JSONObject();
                    for (int i = 0; i < sheet.getColumns(); i++) {
                        Cell cell = sheet.getCell(i,j);
                        CellType type = cell.getType();
                        if(!"".equalsIgnoreCase(sheet.getCell(i,0).getContents().trim())){
                            firstJSONObject.put("FactId",j);
                            firstJSONObject.put(sheet.getCell(i,0).getContents().replaceAll(" ",""),cell.getContents());
                            jArray.put(j,firstJSONObject);
                            //secondJSONObject.put(Integer.toString(j), firstJSONObject);
                        }
                    }
                }
                JSONObject thirdJSONObject = new JSONObject();
                thirdJSONObject.put("brandfacts",secondJSONObject);
                JSONArray jSecArray = new JSONArray();
                for(int i=0; i<jArray.length();i++){
                    if(jArray.isNull(i)){
                        //do nothing
                    }
                    else{
                        jSecArray.put(jArray.get(i));
                    }
                }
                String jsonText = jSecArray.toString(); 
                
                ACEManager aceManager = new ACEManager();
                String jsonFile = aceManager.getServerFilesPath() + "worldofgood.json";
                File file = new File(jsonFile);
                writer = new BufferedWriter(new FileWriter(file));
                writer.write(jsonText);
                
                if (writer != null) {
                    writer.close();
                }    
                
                is = new FileInputStream(file);
                String docRootPath = "/apps/mcd/docroot/wog";
                Node docRootNode = slingRequest.getResourceResolver().getResource(docRootPath).adaptTo(Node.class);
                String fileName = "worldofgood.json";
                String existFileName = docRootPath + "/" + fileName;
                Node jsonDocrootFile = null;
                if(docRootNode.hasNode(fileName))
                {
                    jsonDocrootFile = slingRequest.getResourceResolver().getResource(existFileName).adaptTo(Node.class);
                    jsonDocrootFile.remove();
                }
                jsonDocrootFile = docRootNode.addNode(fileName,"nt:file");
                        
                Node data = jsonDocrootFile.addNode("jcr:content","nt:resource");
                data.setProperty("jcr:data",is);
                data.setProperty("jcr:mimeType",new MimetypesFileTypeMap().getContentType(fileName));
                data.setProperty("jcr:lastModified",Calendar.getInstance());
                
                
                docRootNode.save();
                docRootNode.refresh(true);
                
                
                currentNode.setProperty("flag", "0");
                currentNode.save();
                currentNode.refresh(true); 
                
                if(file.exists())
                    //file.delete();
%>
                    <div id='progressbar'><div class='progress-label'>Loading...</div></div>
<%                    
                //out.println("<div id='progressbar'><div class='progress-label'>Loading...</div></div>");    
                //out.println("<div style='font-size:13px;font-weight:bold;font-family:Arial;'>Brand Facts have been generated successfully.</div>");     
            } 
            catch (BiffException e) {
                e.printStackTrace();
            }
            finally {
                try {
                    if (writer != null) {
                        writer.close();
                    }
                    if (is != null) {
                        is.close();
                    }
                } 
                catch (IOException e) {
                    e.printStackTrace();
                }
            }
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

    </td>
    

    
    <td width="20%" valign="top"></td>
    
  </tr>
</table>
<script>
  
    $(function() {
        var progressbar = $( "#progressbar" ),
        progressLabel = $( ".progress-label" );
        progressbar.progressbar({
        value: false,
        change: function() {
            progressLabel.text( progressbar.progressbar( "value" ) + "%" );
        },
        complete: function() {
            progressLabel.text("Brand Facts have been generated successfully.");
        }
        });
        function progress() {
            var val = progressbar.progressbar( "value" ) || 0;
            progressbar.progressbar( "value", val + 1 );
            if ( val < 99 ) {
                setTimeout( progress, 100 );
            }
        }
        setTimeout( progress, 3000 );
    });



    function replicationJson(){
        var loadingHTML = "<div style='margin-left:60px;margin-top:15px;'><object id='loaderImage' width='45' height='45' align='absmiddle'><param name='movie' value='/wog/images/loader.swf' /><param name='wmode' value='transparent' /><param name='bgcolor' value='#0000ffff'><embed src='/wog/images/loader.swf' width='45' height='45' wmode='transparent' bgcolor='#0000ffff' style='padding-left:6px;#padding-left:6px;'></embed></object></div>";
        $('#jsonreplicate').html("");
        $('#jsonreplicate').html(loadingHTML);
        $("#jsonreplicate").show();
        var replicationStatus = false;
        $.ajax({    
            url: "/mcd/wog/jsonreplicate",
            type: 'GET',
            cache: false,
            timeout : '20000',
            async:false, 
            error: function(){
                //alert("Error In Replicating JSON"); 
                return;   
            },
            success: function(data){
               replicationStatus = true;
            }
        });
        
        if(replicationStatus == true){
            var successHTML = "<div style='font-size:12px;margin-left:14px;margin-top:13px;margin-right:5px;'>Brand Facts have been published successfully.</div>";
            $("#jsonreplicate").show();
            $('#jsonreplicate').html(successHTML);
        }
    }
</script>
   