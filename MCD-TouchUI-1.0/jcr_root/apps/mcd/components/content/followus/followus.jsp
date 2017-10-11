<%-- Follow us component. Author : Nitin Sharma--%>

<%@include file="/apps/mcd/global/global.jsp"%>    
<%
%>
<%@ page session="false"%>
<%@ page import="com.mcd.accessmcd.util.CommonUtil,
                 com.day.cq.security.User,
                 com.day.cq.wcm.api.WCMMode"%>
<%
    CommonUtil commonUtil = new CommonUtil();   
    // Text to be Displayed eg . Follow Us 
    String text =  properties.get("text","");   
    // URL to be linked with the text
    String link =  properties.get("link","");  
   //Default alignment with the paragraph
    String align =  properties.get("align","right");   
    
    // Fetch social media data from the Multi Field widget
    String[] smdata = (properties.containsKey("followusdata"))? properties.get("followusdata", String[].class) : null; 
        
  %>
<div class="followUs">
          <div align="<%= align %>">
                    <%  // Check the link for the text is provided or not
                             if(link.trim().equals(""))
                             {                                   
                    %>
                                   <!-- render as normal text -->
                                   <%= text %>&nbsp;
                           <%
                             }
                             else
                             {
                           %>
                                    <!--render as Link-->
                                    <a href="<%= commonUtil.getValidURL(link) %>" target="_blank">
                                    <%=text %></a>&nbsp;&nbsp;
                            <%
                             }
                            %>
                               <%  // Show data in specified format if data exist.
                                       if(smdata != null)
                                       {
                                              for(int i =0 ; i < smdata.length ; i++) 
                                               {
                                                      //split the item data
                                                      String[] followitem = smdata[i].split("\\|");
                                     %>
                                                      <a href="<%= commonUtil.getValidURL(followitem[1])%>" target="_blank"><b></b>
                                                      <img src="<%= followitem[0] %>"></img></a>
                                              <%}
                                        }
                                        else
                                        {
                                                 if (WCMMode.fromRequest(request) == WCMMode.EDIT)
                                                  {
                                                      out.println(langText.get("CONFIGURE_COMPONENT_MSG","",langText.get("Follow us")));
                                                  }
                                        }  %>
          </div>
</div>