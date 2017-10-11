<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.BuildingDetails" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.GCDConstants" %>
<%@ page import="com.day.cq.security.*,com.mcd.accessmcd.usermanagement.user.manager.UserMaintenanceManager" %>
<%@ page import="com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean" %>  
  
<%
    String addLinkLabel = properties.get("intlbldaddlinklabel","Add");
    String tempAddLinkURL = properties.get("intlbldaddurl","");
    String cancelLinkLabel = properties.get("intlbldcancellabel","Cancel");
    String cancelLinkURL = properties.get("intlbldcancelurl","");
    String Helppath = properties.get("helpPath","");  
    if(!"".equals(cancelLinkURL.trim())){
        if(cancelLinkURL.startsWith("/content")){
            cancelLinkURL = cancelLinkURL.replaceAll("/content","")+".html";
        }    
    }
    else{
     //   cancelLinkURL  = "http://www.accessmcd.com";
    }
     
    ArrayList allBuildingDetails = null;
    IGCDFacade iGCDFacade = null;
    ArrayList groupList = null;
    ArrayList groupPaths = new ArrayList();
    CommonUtil commonUtil = new CommonUtil(); 
    boolean adminFlag = false;
    boolean dataFlag = true;
    
    try{
        iGCDFacade = new GCDFacadeImpl();
        allBuildingDetails = iGCDFacade.getIntlBuildings(sling);
        
     /*   Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
        final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
        UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
        User loggedInUser = slingRequest.getResourceResolver().adaptTo(User.class);
        ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());
        UserMaintenanceManager umManager = new UserMaintenanceManager(sling, bundle, jcrSession, uMgr, resourceResolver);
        String loggedInUserID = loggedInUser.getID();
        groupList = umManager.getUserGroupsDetails(loggedInUserID);
        GroupDataBean grpBean = null; 
        if(groupList.size() > 0){
            for(int i=0; i<groupList.size(); i++){
                grpBean = (GroupDataBean)groupList.get(i);
                groupPaths.add(grpBean.getGroupHandle());
            }
        }   
        if(groupPaths !=null && groupPaths.size() > 0){
            String[] gcdAdminGroup = GCDConstants.GCD_ADMIN_GROUP.split(",");
            if(gcdAdminGroup.length > 0){
                for(int g=0; g<gcdAdminGroup.length; g++){
                    if(groupPaths.contains(gcdAdminGroup[g])){
                        adminFlag = true;
                        break;
                    }
                }
            }
        }*/
        
        if(allBuildingDetails != null && allBuildingDetails.size() > 0){
%>
            <table width="100%" height="100%" cellpadding="0" cellspacing="5">
                <tr>
                    <td>
                        <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                            <tr height="100%">
                                <td width="100%" valign="top" class="gcdSkinBorder" style="padding:5px;" dir="ltr" >                    
                                    <form name="viewIntlBuilding" method="get" action="">
                                        <table class="gcdcontentlnkhd" width="100%" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td colspan="2">
                                                    <input type="hidden" name="<%= GCDConstants.FORMACTION %>" value=""/>
                                                </td>
                                            </tr>
            
                                            <tr>
                                                <td colspan="8">
                                                    <%-- show page links --%>
                                                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                                                        <%-- add and cancel links --%>
                                                        <tr>
                                                            <td align="left" colspan="3">
<%
                                                                   String addLinkURL = "";
                                                                    if(!"".equals(tempAddLinkURL.trim())){
                                                                        addLinkURL = tempAddLinkURL.replaceAll("/content","")+".html";
                                                                    }
                                                                    else{
                                                                        addLinkURL = "#";
                                                                    }
%>
                                                                    <a id = "add1" style="display:none" href="<%=addLinkURL%>" class="contentlnk"><%=addLinkLabel%></a>                                                                    
<%                                                            
                                                                 if(!cancelLinkURL.equals(""))
                                                                {
%>
                                                                 &nbsp;&nbsp;&nbsp;
                                                                 <a href="<%=cancelLinkURL%>" class="contentlnk"><%=cancelLinkLabel%></a>
<%
                                                                 }
                                                                 else
                                                                {
%>                                                               &nbsp;&nbsp;&nbsp;
                                                                 <a href="javascript:cancel()" class="contentlnk"><%=cancelLinkLabel%></a>
                                                 
<%                                                               }
                                                                   if(!"".equals(Helppath.trim()))
                                                                    {
%>
                                                                    &nbsp;&nbsp;&nbsp;
                                                                    <a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help1" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
<%    
                                                                    }   
                                                                                                              
%>
                                                                   
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
            
                                            <tr>
                                                <td colspan="3">&nbsp;</td>
                                            </tr>
            
                                            <tr>
                                                <td colspan="3">
                                                    <%=langText.get("Click on the first letter of a country name to go directly to that country")%> 
                                                </td> 
                                            </tr>
            
                                            <tr style="background-color:#DDDDDD;">
                                                <td width="10%"></td>
                                                <td colspan="80%">
                                                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td width="4%"><a href="#AnchorA" class="contentlnk">A</a></td>
                                                            <td width="4%"><a href="#AnchorB" class="contentlnk">B</a></td>
                                                            <td width="4%"><a href="#AnchorC" class="contentlnk">C</a></td>    
                                                            
                                                                    
                                                            <td width="4%"><a href="#AnchorD" class="contentlnk">D</a></td>
                                                            <td width="4%"><a href="#AnchorE" class="contentlnk">E</a></td>
                                                            <td width="4%"><a href="#AnchorF" class="contentlnk">F</a></td>            
                                                            
                                                            
                                                            <td width="4%"><a href="#AnchorG" class="contentlnk">G</a></td>
                                                            <td width="4%"><a href="#AnchorH" class="contentlnk">H</a></td>
                                                            <td width="4%"><a href="#AnchorI" class="contentlnk">I</a></td>                                                                                                                       
                                                            
                                                            
                                                            <td width="4%"><a href="#AnchorJ" class="contentlnk">J</a></td>
                                                            <td width="4%"><a href="#AnchorK" class="contentlnk">K</a></td>
                                                            <td width="4%"><a href="#AnchorL" class="contentlnk">L</a></td>
                                                            
                                                                                                                                                                                   
                                                            <td width="4%"><a href="#AnchorM" class="contentlnk">M</a></td>
                                                            <td width="4%"><a href="#AnchorN" class="contentlnk">N</a></td>
                                                            <td width="4%"><a href="#AnchorO" class="contentlnk">O</a></td>      
                                                            
                                                                                                                                                                              
                                                            <td width="4%"><a href="#AnchorP" class="contentlnk">P</a></td>
                                                            <td width="4%"><a href="#AnchorQ" class="contentlnk">Q</a></td>
                                                            <td width="4%"><a href="#AnchorR" class="contentlnk">R</a></td>                                                                                                                       
                                                            
                                                            
                                                            <td width="4%"><a href="#AnchorS" class="contentlnk">S</a></td>
                                                            <td width="4%"><a href="#AnchorT" class="contentlnk">T</a></td>
                                                            <td width="4%"><a href="#AnchorU" class="contentlnk">U</a></td>                                                                                                                        
                                                            
                                                            
                                                            <td width="4%"><a href="#AnchorV" class="contentlnk">V</a></td>
                                                            <td width="4%"><a href="#AnchorW" class="contentlnk">W</a></td>
                                                            <td width="4%"><a href="#AnchorX" class="contentlnk">X</a></td>                                                                                                                        
                                                            
                                                            
                                                            <td width="4%"><a href="#AnchorY" class="contentlnk">Y</a></td>
                                                            <td width="4%"><a href="#AnchorZ" class="contentlnk">Z</a></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td width="10%"></td>
                                            </tr>
            
                                            <tr>
                                                <td width="10%">&nbsp;</td>
                                                <td width="33%">&nbsp;</td>
                                                <td>&nbsp;</td>
                                            </tr>
<%
                                            // Iterating thorugh all the buildings
                                            for( int i=0; i < allBuildingDetails.size(); i++ ){
                                                BuildingDetails buildingdetails = (BuildingDetails)allBuildingDetails.get(i);
                                                BuildingDetails buildingdetailsAnchor = null;
                                                if(i == allBuildingDetails.size()-1){
                                                    buildingdetailsAnchor = (BuildingDetails)allBuildingDetails.get(i);
                                                }
                                                else{
                                                    buildingdetailsAnchor = (BuildingDetails)allBuildingDetails.get(i+1);
                                                }
                                                addLinkURL = "";
                                                if(!"".equals(tempAddLinkURL.trim())){
                                                    addLinkURL = tempAddLinkURL.replaceAll("/content","")+".html?"+GCDConstants.BUILDING_RECORD_TXF+"="+buildingdetails.getBldgCd();
                                                }
                                                else{
                                                    addLinkURL = "#";
                                                }
                                                int count = i;
                                                String tempAnchor = "Anchor"+buildingdetailsAnchor.getBldgNa().toUpperCase().substring(0,1);
                                                String finalAnchor = "Anchor"+buildingdetails.getBldgNa().toUpperCase().substring(0,1);
                                                if(finalAnchor.equalsIgnoreCase(tempAnchor)){
                                                    count = i;
                                                }
                                                else{
                                                    count = 0;
                                                }
                                                //out.println("tempAnchor :: " + tempAnchor);
                                                //out.println("finalAnchor :: " + finalAnchor + "<br>");
%>                                    
                                            <tr>
                                                <td width="15%" ><a name="Anchor<%=buildingdetails.getBldgNa().toUpperCase().substring(0,1)%>"></a></td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            
                                            <tr>
<%
                                                // if Admin flag is true then show link on the building name else remove the link
                                               
%>
                                                    <td width="15%" ><b><%=langText.get("INTL Name")%></b></td>
                                                    <td>
                                                        <a href="<%=addLinkURL%>" title="Click to edit" class="contentlnk buildinglink" style="display:none"><%= String.valueOf(buildingdetails.getBldgNa().toUpperCase())%></a>
                                                        <span class="nolink"><%= buildingdetails.getBldgNa().toUpperCase()%></span>
                                                    </td>

                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%-- Site Id --%>
                                            <tr>
                                                <td width="15%" ><b><%=langText.get("INTL Site ID Number")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSiteId()%></td>
                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%-- Description --%>
                                            <tr>
                                                <td width="15%" ><b><%=langText.get("INTL Description")%></b></td >
                                                <td class="contentlnk"><%= buildingdetails.getSiteDs().toUpperCase() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%-- Address --%>
                                            <tr>
                                                <td width="15%" ><b><%=langText.get("INTL Address")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSiteL1Ad().toUpperCase() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            
                                            <%-- Address 2 --%>
                                            <tr>
                                                <td width="15%" ><b><%=langText.get("INTL Address 2")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSiteL2Ad().toUpperCase() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%-- Address 3 --%>
                                            <tr>
                                                <td width="15%" class="contentlnk"><b><%=langText.get("INTL Address 3")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSiteL3Ad().toUpperCase() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            
                                            <%-- Address 4 --%>
                                            <tr>
                                                <td width="15%" class="contentlnk"><b><%=langText.get("INTL Address 4")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSiteL4Ad().toUpperCase() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%-- City --%>
                                            <tr>
                                                <td width="15%" class="contentlnk"><b><%=langText.get("INTL City")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSiteCityAd().toUpperCase() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%-- State --%>
                                            <tr>
                                                <td width="15%" class="contentlnk"><b><%=langText.get("INTL State")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSiteAbbrStAd().toUpperCase() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            
                                            <%-- Postal Code --%>
                                            <tr>
                                                <td width="15%" class="contentlnk"><b><%=langText.get("INTL Postal Code")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSitePstlCd().toUpperCase() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%-- Intl Postal Code --%>
                                            <tr>
                                                <td width="15%" class="contentlnk"><b><%=langText.get("INTL Postal Code Intl")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSiteIntlPstlCd().toUpperCase() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            
                                            <%-- Courier Code --%>
                                            <tr>
                                                <td width="15%" ><b><%=langText.get("INTL Courier Code")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSiteCourierCd()%></td>
                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%-- Country Name --%>
                                            <tr>
                                                <td width="15%" class="contentlnk"><b><%=langText.get("INTL Country Name")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getCtryCd().toUpperCase() %>-<%= buildingdetails.getSiteCtryNa() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%-- Intl Phone Number --%>
                                            <tr>
                                                <td width="15%" class="contentlnk"><b><%=langText.get("INTL Phone Number")%></b></td>
                                                <td class="contentlnk"><%= buildingdetails.getSitePhneNu() %></td>
                                                <td>&nbsp;</td>
                                            </tr>
            
                                            <%--<tr>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                            </tr>--%>
            
<%
                                            }// FOR LOOP ENDS HERE
%> 
                                            <tr>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                            </tr>
                                        </table>
            
                                        <%-- show page links --%>
                                        <table width="100%" align="center" cellpadding="0" cellspacing="0">
                                            <%-- add and cancel links --%>
                                            <tr>
                                                <td align="left" colspan="3">
<%
                                                       addLinkURL = "";
                                                        if(!"".equals(tempAddLinkURL.trim())){
                                                            addLinkURL = tempAddLinkURL.replaceAll("/content","")+".html";
                                                        }
                                                        else{
                                                            addLinkURL = "#";
                                                        }
%>
                                                        <a id="add2" style = "display:none" href="<%=addLinkURL%>" class="contentlnk"><%=addLinkLabel%></a>
                                                      
<%
                                                   if(!cancelLinkURL.equals(""))
                                                    {
%>
                                                     &nbsp;&nbsp;&nbsp;
                                                     <a href="<%=cancelLinkURL%>" class="contentlnk"><%=cancelLinkLabel%></a>
<%
                                                     }
                                                    else
                                                    {
%>                                                   &nbsp;&nbsp;&nbsp; 
                                                     <a href="javascript:cancel()" class="contentlnk"><%=cancelLinkLabel%></a>
                                                 
<%                                                   }
                                                         if(!"".equals(Helppath.trim()))
                                                                    {
                                                                    
%>
                                                                    &nbsp;&nbsp;&nbsp;
                                                                    <a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help1" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
<%    
                                                                    }
                                                             

%>
                                                </td>
                                            </tr>
                                        </table>
                                    </form>
                                </td>
                            </tr>
                        </table>     
                    </td> 
                </tr>   
            </table>  
<%
        }
    }
    catch(Exception ex){ 
        dataFlag = false;
        out.println("<h3 style='color:red;'>" + GCDConstants.ERROR_GCD_DATABASE_ERROR +"</h3>");
        log.error("",ex);
    }        
%>





       <script type="text/javascript">
       
       
       if('<%= dataFlag  %>' == 'true')
       {
        $(function() {
        var url = '<%=  currentPage.getPath() %>' + '.Access.html?getdata-1'
        $.ajax({
            url: url,
            type: 'GET',    
            timeout: 10000, 
            data: '', 
            dataType : "json",
            error: function(){
               return;
            },    
            success: function(result){                                      
                    if(result.allow == 'true')
                    {
                     $('#add1').show();$('#add2').show(); $('.nolink').hide();
                     $('a.buildinglink').show();
                       
                    } 
                    else
                    {
                      $('.nolink').show();
                    }
            }
        });        
      }); 
      }
       </script>
     