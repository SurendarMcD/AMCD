<%--
  ==============================================================================

  Download component

  Draws a download link with icons.
 ==============================================================================
--%><%@ page import="com.day.cq.wcm.foundation.Download,
        com.day.cq.wcm.api.components.DropTarget,
        com.day.cq.wcm.api.WCMMode,
        com.day.cq.wcm.commons.WCMUtils,
        com.day.text.Text,
        com.mcd.cq.util.search.SearchGroup,
        org.apache.commons.lang.StringEscapeUtils,
        java.util.Map" %><%
%><%@include file="/apps/mcd/global/global.jsp"%>
<%!
//added to retrieve the size of the file test
public String getFileSize(long size)
{
     String unit = "";
     double d = 0.0d;     
     if (size < 1024) {
      d = (double)size;
        unit = "bytes";
     } 
     else if (size < 1048576) {
        d = (double)size / 1024;           
        unit = "KB";
     } 
     else {
        d = (double)size/1048576;
        unit = "MB";
     }
     size = Math.round(d);
     return size+" "+unit;    
}    
%>
<% 
    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "file";    
    Download dld = new Download(resource);     
    String altTitle = properties.get("altTitle",""); // alt title    
    if (dld.hasContent()) {
        dld.addCssClass(ddClassName);
        // code to retrieve the size of the image //
        javax.jcr.Property propData = dld.getData();        
        long uploadedFileLength = propData.getLength();   
        String fileSize = getFileSize(uploadedFileLength);
        String iconPath = dld.getIconPath();        
        String title = dld.getTitle(true);
        String href = dld.getHref();
        //String href = Text.escape(dld.getHref(), '%', true);
        //Judy added the following
        String metaGroups = getAllGroup(currentNode);    
        String tmpGroup=SearchGroup.searchGroup(metaGroups);
        if (tmpGroup!=null && tmpGroup.trim().length()>0 && href.indexOf("/content/dam")<0){
                String orghref = dld.getHref();
                int st = orghref.lastIndexOf(".");
                String temphref = orghref.substring(0,st)+ "."+tmpGroup+"."+orghref.substring(st+1); 
                href = Text.escape(temphref,'%',true);        
        }
        else{
                href = Text.escape(href, '%', true);
        }
        //end
        %>
        <div id="download">
            <span class="icon"><img src="<%= iconPath %>" alt="*"></span>
            <a href="<%= href%>"  title="<%=title%>"<%
                Map<String,String> attrs = dld.getAttributes();
            if ( attrs!= null ) {
                for (Map.Entry e : attrs.entrySet()) {
                    out.print(StringEscapeUtils.escapeHtml(e.getKey().toString()));
                    out.print("=\"");
                    out.print(StringEscapeUtils.escapeHtml(e.getValue().toString()));
                    out.print("\"");   
                }
            }%> 
            ><%=(!altTitle.equals("") ? altTitle : dld.getFileName())%>&nbsp;                
              <font style="font-family: Arial;font-size: 11px;">
                  (<%=fileSize %>)             
              </font>
        </a><br>            
                <div style="overflow: hidden; width: 100%;"><small><%= dld.getDescription()%></small></div>
        </div><div class="clear"></div><%
    } else if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><img src="/libs/cq/ui/resources/0.gif" class="cq-file-placeholder <%= ddClassName %>" alt=""><%
    }
%>