<%-- ########################################### 
 # DESCRIPTION: DMC Document Paragraph
 #  
 # Environment:   
 #  
 # UPDATE HISTORY       
 # 1.0  Sandeep Maheshwari Initial Version
 # 2.0  Judy Zhang 
 ##############################################--%>
<%@ page import="com.day.text.Text,
        com.day.cq.wcm.api.PageFilter,
        com.day.cq.wcm.api.NameConstants,
        org.apache.commons.lang.StringEscapeUtils,
        com.day.cq.wcm.api.Page,
        java.net.URLDecoder,java.io.*,
        com.day.cq.wcm.api.WCMMode" %>    
<%@include file="/apps/mcd/global/global.jsp"%> 

<% 
    String docName = properties.get("documentName", "DMC Document");   // Document Name    
    String docURL = properties.get("documentURL", "");     // URL
    String fontColor = properties.get("foregroundColor", "000000");    //fontcolor
    String bgColor = properties.get("backgroundColor", "");  //bgcolor 
    String docIcon = properties.get("documentIcon", "");    // Icon
    String showDocIcon = properties.get("showDocIcon", "no");   // Show the Icon 
    String docDesc = properties.get("documentDesc", "");// Document Description
    String docSize = properties.get("documentSize", "");// Document Size
%>

<%
//judy , comment out this to show original DMC compoent image, 09/26/2012
if((docURL.equals("")) && (WCMMode.fromRequest(request) == WCMMode.EDIT)) {

System.out.println("search dmc.....docURL::" + docURL);
System.out.println("search dmc.....mode::" + WCMMode.fromRequest(request));

    %>
    <img src="/libs/cq/ui/widgets/themes/default/placeholders/title.png" alt="">
    
    <div id="div_dmcComp">
        <table width="100%" border="0" bgcolor="<%= bgColor %>" cellpadding="0" cellspacing="0">
            <!-- new row in two cell table -->
            <tr>
<%                        
            if(docURL==null || docURL.equals("")){
              log.error("**********langtextdmc******** "); 
%>            
               <tr>
                    <td class="dmc">
                    <%=langText.get("Please provide inputs for Search DMC.")%>
                       </td>
                </tr>
        </table>
    </div>
    
<%
            }
    
//} else {
} else if (!(docURL.equals(""))){
    try {
            if(!docSize.equals("")){
                if(docSize.indexOf(".")>-1)docSize = docSize.substring(0,docSize.indexOf("."));
                long size = Long.parseLong(docSize);
                String unit = "";
                double d = 0.0d;  
                
                if (size < 1024) {
                    d = (double)size;
                    unit = "KB";
                } 
                else {
                    d = (double)size / 1024;           
                    unit = "MB";
                }
                size = Math.round(d);
                docSize = size+" "+unit;
            }
    //[GA|END] 
    
        // Image from component path
        String path = "/apps/mcd/docroot/images";
        String ext = docURL.substring(docURL.lastIndexOf(".") + 1).toLowerCase();
        path = "/var/dam/accessmcd/dmc/";    
        docIcon = path + ext + ".gif";
        
        
        Resource root = slingRequest.getResourceResolver().getResource(docIcon);
        if(root==null)
        {
            docIcon = path + "default.gif"; 
        }
            
        /*if (ext.equals("doc") || ext.equals("docx")) {
            docIcon = "/doc.gif";
        }
        else if (ext.equals("xls") || ext.equals("xlsx")) {
            docIcon = "/xls.gif";
        }
        else if (ext.equals("pdf")){
            docIcon = "/pdf.gif";
        }
        else if (ext.equals("zip")){
            docIcon = "/zip.gif";
        }
        else if (ext.equals("ppt") || ext.equals("pptx")){
            docIcon = "/ppt.gif";
        }
        else if (ext.equals("eps")){
            docIcon = "/eps.gif";
        }
        else if (ext.equals("gif")){
            docIcon = "/gif.gif";
        }
        else if (ext.equals("jpg")){
            docIcon = "/jpg.gif";
        }
        else if (ext.equals("tif")){
            docIcon = "/tif.gif";
        }
        else if (ext.equals("txt")){
            docIcon = "/txt.gif";
        }
        else if (ext.equals("wmv") || ext.equals("flv")){
            docIcon = "/wmv.gif";
        }
        else if (ext.equals("mpp") || ext.equals("mppx")){
            docIcon = "/mpp.gif";
        }
        else{
            docIcon = "/default.gif";
        }
        
        docIcon = path + docIcon;*/
        log.error("########################################component mid");
    %>
    <div id="div_dmcComp">
        <table width="100%" border="0" bgcolor="<%= bgColor %>" cellpadding="0" cellspacing="0">
            <!-- new row in two cell table -->
            <tr>
                <td class="dmc">
                    <a href="#" onclick="window.open('<%=docURL%>', '', 'status=yes,location=no,toolbar=no,menubar=yes,scrollbars=yes,resizable=yes');return false;" style="text-decoration:none;">
                    <% if (showDocIcon.equalsIgnoreCase("yes")) { %><img src="<%=docIcon%>" border="0"><% }%>
                    <!--  decoding the encoded document name  -->
                    <!-- span style="text-decoration:underline;"><%=URLDecoder.decode(docName)%></span></a -->
                    <% if (docSize!=null && docSize.length()>0){ %> 
                       <span style="text-decoration:underline;"><%=URLDecoder.decode(docName)%>
                        <font style="font-family: Arial;font-size: 11px;text-decoration:underline;">
                       &nbsp;(<%=URLDecoder.decode(docSize)%>)
                        </font>
                       </a></span>
                    <%}else{%>
                       <span style="text-decoration:underline;"><%=URLDecoder.decode(docName)%></span></a>
                    <%}%>
                 </td>
             </tr>
            <% if (docDesc != null && docDesc.trim().length() >0) { %>
                <tr>
                    <td class="dmc">
                        <font color="#<%=fontColor %>">
                            <!--  decoding the encoded document description -->
                            <%= URLDecoder.decode(docDesc) %>
                        </font>
                    </td>
                </tr>
            <% } %>   
            <% 
            
            if(docURL==null || docURL.equals("")){  log.error("**********langtextdmc******** ");  %>
               <tr>
                    <td class="dmc">
                    <%=langText.get("Please provide inputs for Search DMC.")%>
                       </td>
                </tr>
            <% } %>    
        </table>
    </div>
    <%
    } 
    catch (Exception e) 
    {   
        log.error("Exception in DMC component while displaying : " + e.getMessage());
    }
 
}
%>