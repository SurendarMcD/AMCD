<%-- ########################################### 
 # DESCRIPTION: This is the View US Building component which will display the list of US Buildings.
 # Author: Sandeep Jain
 # Environment: 
 # 
 # INTERFACE 
 # Controller: 
 # Targets: 
 # Inputs:   
 # Outputs:      
 # 
 # UPDATE HISTORY       
 # 1.0  Sandeep Jain, 22-01-09, Initial Version 
 # 
 # Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
 ##############################################--%>
 

<%@ page session="false" contentType="text/html" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.BuildingDetails" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.GCDConstants" %> 
<%@ page import="com.mcd.accessmcd.common.helper.PropertyHelper,com.mcd.util.PropertiesLoader,java.util.Properties,com.mcd.accessmcd.util.CommonUtil"%>
<%@ page import="com.day.cq.i18n.I18n"%>
<%
       
    //Declaring the common variables
    ArrayList allBuildingDetails=null;
    ArrayList groupList = null;
    ArrayList groupPaths = new ArrayList();
    boolean adminFlag = false; 
    IGCDFacade iGCDFacade=null;
    HttpSession session=null;
    CommonUtil commonUtil = new CommonUtil(); 
    String cancelLinkURL=null;
         
    boolean dataFlag = true;     
    //Reading field labels from i18n nodes
    String usName=langText.get("Name");
    String usDescription=langText.get("Description");
    String usAddress=langText.get("Address");
    String usCity=langText.get("City");
    String usState=langText.get("State");
    String usPostalCode=langText.get("Postal Cd");
    String usCountryName=langText.get("Country Name");
    String usAddLinkLabel=langText.get("Add");
    String usCancelLinkLabel=langText.get("Cancel");
       
    //Fetching the dialog field values
    String usAddLink=properties.get("addLink","");
    String usCancelLink=properties.get("cancelLink","");  
    String Helppath = properties.get("helpPath","");  
    
  
    try{   
                // get GCDFacadeImpl Object
                iGCDFacade= new GCDFacadeImpl();
                allBuildingDetails=iGCDFacade.getUSBuildings(sling);
          /*      Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
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
         
%>


    <table width="100%" height="100%" cellpadding="0" cellspacing="5">
        <tr>
            <td>
                <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                    <tr height="100%" class="gcddata">
                                <td width="100%" valign="top" class="mcdSkinPortletBorder" style="padding:5px;" dir="ltr" >                 

                                    <form name="viewUSBuilding" method="post" action="">

                                            <table class="gcdcontentlnkhd" width="100%" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td colspan="8">
                                                                        <input type="hidden" name="<%= GCDConstants.FORMACTION %>" value=""/>
                                                        </td>
                                                    </tr>
                                                   
                                                    <tr>
                                                        <td colspan="8">
                                                             <%-- show page links --%>
                                                                <table class="gcdcontentlnkhd" width="100%" align="center" cellpadding="0" cellspacing="0">

                                                                    <%-- add and cancel links --%>
                                                                      <tr>
                                                                        <td align="left">
                                                                            <%
                                                                            if(!(usAddLink.trim()).equals(""))
                                                                            {
                                                                             %>
                                                                                <a   id ="add1" style = "display:none" href="<%=commonUtil.getValidURL(usAddLink)%>" class="contentlnk"><%=usAddLinkLabel%></a>&nbsp;&nbsp;&nbsp;
                                                                             <%
                                                                            }                                                                             
                                                                            if((usCancelLink.trim()).equals("")) 
                                                                            {                                                                
                                                                            %>
                                                                                <a href="javascript:cancel()" class="contentlnk"><%=usCancelLinkLabel%></a>
                                                                            <%     
                                                                            }
                                                                            else
                                                                            {
                                                                            %>
                                                                                <a href="<%=commonUtil.getValidURL(usCancelLink)%>" class="contentlnk"><%=usCancelLinkLabel%></a>
                                                                            <%
                                                                            }
                                                                            if(!(Helppath.trim()).equals("")) 
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
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                        <td>&nbsp;</td>
                                                    </tr>

                                                    <tr>
                                                        <%-- Name --%>
                                                        <td>
                                                            &nbsp;&nbsp;<b><%=usName%></b>
                                                        </td>
                                                        <%-- Description --%>
                                                        <td>
                                                            <b><%=usDescription%></b>
                                                        </td>
                                                        <%-- Address --%>
                                                        <td>
                                                            <b><%=usAddress%></b>
                                                        </td>
                                                        <%-- City --%>
                                                        <td>
                                                            <b><%=usCity%></b>
                                                        </td>
                                                        <%-- State --%>
                                                        <td>
                                                            <b><%=usState%></b>
                                                        </td>
                                                        <%-- Postal Cd --%>
                                                        <td>
                                                            <b><%=usPostalCode%></b>
                                                        </td>
                                                        <%-- Country Name --%>
                                                        <td>
                                                            <b><%=usCountryName%></b>
                                                        </td>       
                                                    </tr>
                                
                                                    <%
                                                      
                                                        if(allBuildingDetails.size()!=0)
                                                        {
                                                            // Iterating thorugh all the buildings
                                                            for( int i=0; i < allBuildingDetails.size(); i++)
                                                            {
                                                                BuildingDetails buildingdetails = (BuildingDetails)allBuildingDetails.get(i);   
                                        
                                                    %>

                                                    <tr>
                                                        <td> 
                                                            <%
                                                             if(!(usAddLink.trim()).equals(""))
                                                              {                                                                            
                                                            %>  
                                                            <img height="10" 
                                                            src="/content/dam/accessmcd/gcd/arrow_red_2.gif" width="10" border="0"/><a style="display:none;" href="<%=commonUtil.getValidURL(usAddLink)%>?<%= GCDConstants.BUILDING_RECORD_TXF %>=<%=buildingdetails.getBldgCd() %> " title="Click to edit" class="contentlnk buildinglink"  ><%= String.valueOf(buildingdetails.getBldgNa().toUpperCase())  %></a>
                                                            <span class='nobuildinglink'><%= String.valueOf(buildingdetails.getBldgNa().toUpperCase())%></span>
                                                            <%
                                                              }
                                                              else
                                                              {
                                                              %>  
                                                                  <img height="10" src="/content/dam/accessmcd/gcd/arrow_red_2.gif" width="10" border="0"/><%= String.valueOf(buildingdetails.getBldgNa().toUpperCase())%>
                                                              <%      
                                                              }  
                                                                                                                  
                                                            %>
                                                        </td>
                                            
                                                        <td>
                                                            <%= buildingdetails.getSiteDs().toUpperCase() %>
                                                        </td>
                                                    
                                                        <td>
                                                            <%= buildingdetails.getSiteL1Ad().toUpperCase() %>
                                                        </td>
                                                    
                                                        <td>
                                                            <%= buildingdetails.getSiteCityAd().toUpperCase() %>
                                                        </td>
                                                        
                                                        <td>
                                                            <%= buildingdetails.getSiteAbbrStAd().toUpperCase() %>
                                                        </td>
                                                    
                                                        <td>
                                                            <%= buildingdetails.getSitePstlCd().toUpperCase() %>
                                                        </td>
                                                    
                                                        <td>
                                                            <%= buildingdetails.getCtryCd().toUpperCase() %>
                                                        </td>       
                                                    </tr>
                    
                                                    <%
                                                        }   
                                                    }                                                   
                                                    %>
                    
                                                    <tr>
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                    </tr>

                                            </table>  

                                            <%-- show page links --%>
                                            <table class="gcdcontentlnkhd" width="100%" align="center" cellpadding="0" cellspacing="0">

                                                <%-- building names, add and cancel links --%>
            
                                                   <tr>
                                                        <td align="left">
                                                            <%
                                                             if(!(usAddLink.trim()).equals(""))
                                                            {
                                                            %>
                                                                <a  id ="add2" style = "display:none" href="<%=commonUtil.getValidURL(usAddLink)%>" class="contentlnk"><%=usAddLinkLabel%></a>&nbsp;&nbsp;&nbsp;          
                                                            <%
                                                            }
                                                            if((usCancelLink.trim()).equals("")) 
                                                            {                                                                
                                                            %>
                                                                <a href="javascript:cancel()" class="contentlnk"><%=usCancelLinkLabel%></a>
                                                            <%     
                                                            }
                                                            else
                                                            {
                                                            %>
                                                                <a href="<%=commonUtil.getValidURL(usCancelLink)%>" class="contentlnk"><%=usCancelLinkLabel%></a>
                                                            <%
                                                            }
                                                            if(!(Helppath.trim()).equals("")) 
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
       catch(Exception e)
       {  dataFlag = false;
    %>         
           <!-- // if the database is not available or connection is null then set the correct error message -->
            <div class="errorMsg"><%= GCDConstants.ERROR_GCD_DATABASE_ERROR %></div> 
            
    <%    
       }
       
    %>    


       <script type="text/javascript">
       
       
       if('<%= dataFlag  %>' == 'true')
       {
        $(function() {
      // put all your jQuery goodness in here.
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
                     $('#add1').show();$('#add2').show();
                     if('<%= !(usAddLink.trim()).equals("") %>' == 'true')
                      {
                       $('a.buildinglink').show();$('.nobuildinglink').hide();   
                      }
                      else
                      {
                       $('.nobuildinglink').show();
                      }
                     
                    } 
            }
        });        
      }); 
      }
       </script>
       
                                          