
<%-- ########################################### 
 # DESCRIPTION: This is the Advance Search component which will perform the functionality of Advance Search.
 # Author: Nitin Sharma
 # 
 # 
 ##############################################--%>
 

<%@ page session="false" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.RegionNameResult" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.BuildingDetails" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.CountryDetails" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.AdvanceSearchParameter" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.DepartmentNameResult" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.GCDConstants" %>
<%@ page import="com.mcd.accessmcd.common.helper.PropertyHelper"%>
<%@ page import="com.mcd.accessmcd.gcd.util.CacheUtil,com.mcd.accessmcd.util.CommonUtil"%>
<%@ page import="com.opensymphony.oscache.base.NeedsRefreshException"%>
<%@ page import="com.opensymphony.oscache.general.GeneralCacheAdministrator"%>
<%@ page import="com.mcd.accessmcd.common.helper.PropertyHelper,com.mcd.util.PropertiesLoader,java.util.Properties"%>
<%@ page import="com.day.cq.i18n.I18n"%>
  

<%  // Declaring the request level variables
     String formAction=null;
     String country=null;
     String combodeptname = null;
     String enterdeptname = null;
    
     IGCDFacade iGCDFacade=null;
     AdvanceSearchParameter advanceSearchParameters=null;
    
     ArrayList allCountryNames=null;
     ArrayList allDepartmentNamesByNumber=null;
     ArrayList allDepartmentNumbers=null;
     ArrayList allStateCodes=null;
     ArrayList allRegionNames=null;
     ArrayList allRegionCodes=null;
     ArrayList allCompanyNames=null;
     ArrayList allJobTitles=null;
     ArrayList allPrefMailCodes=null;
     ArrayList allVmBoxNu=null;
     ArrayList allLocation=null;
     
     String infoText="";
     String submitButtonURL= null;
     
     String helpLink="";
     String helpHeight="";
     String helpWidth="";
     String iframeBorder="";
     String iframeScroll="";
     
     String returnPageLinkURL =null;
     String Helppath = properties.get("helpPath","");
     // Get the Labels from i18n node     
     String advlastName=langText.get("Last Name");
     String advCountry=langText.get("Country");
     String advfirstName=langText.get("First Name");
     String advmiddleName=langText.get("Middle Name");
     String advdeptName=langText.get("Department Name");
     String advdeptNameContains=langText.get("OR Dept Name Contains");
     String advdeptNum=langText.get("Department Number");
     String advState=langText.get("State");
     String advregionName=langText.get("Region Name");
     String advregionCode=langText.get("Region Code");
     String advcompanyName=langText.get("Company Name");
     String advjobTitle=langText.get("Job Title");
     String advpreferredMailCode=langText.get("Preferred Mail Code");
     String advvmNodeNum=langText.get("VM Node Number");
     String advLocation=langText.get("Location");
     String advPhoneNum=langText.get("Phone Number");
     String advPhoneExt=langText.get("OR Phone Number Extension");               
       
     CommonUtil commonUtil = new CommonUtil();  
            
     formAction=request.getParameter(GCDConstants.FORMACTION);
     country=request.getParameter(GCDConstants.SEARCH_COUNTRY);      
    
     submitButtonURL = properties.get("SubmitButtonURL","").toString();
     returnPageLinkURL = properties.get("ReturnPageLinkURL","").toString();
        
     int temp1 =0;   
   

        // get GCDFacadeImpl Object
        try
        {
    
        iGCDFacade= new GCDFacadeImpl();
   
        // get AdvanceSearchParameters Object
    
        advanceSearchParameters=iGCDFacade.getAdvanceSearchParameters(sling);
    
        // Country Names
        
        allCountryNames = iGCDFacade.getActiveCountries(sling);
    
        allCountryNames = advanceSearchParameters.getAllCountryNames();
    
        // Department Names by Numbers
    
        allDepartmentNamesByNumber = advanceSearchParameters.getAllDepartmentNamesByNumber();
    
        // Department Numbers
    
        allDepartmentNumbers = advanceSearchParameters.getAllDepartmentNumbers();
    
        // State Codes
    
        allStateCodes = advanceSearchParameters.getAllStateCodes();
    
        // Region Names
    
        allRegionNames = advanceSearchParameters.getAllRegionNames();
    
        // Region Codes
   
        allRegionCodes=advanceSearchParameters.getAllRegionCodes();
    
        // Company Names
    
        allCompanyNames=advanceSearchParameters.getAllCompanyNames();
    
        // job title
    
        allJobTitles=advanceSearchParameters.getAllJobTitles();
    
        // Preferred mail codes
    
        allPrefMailCodes=advanceSearchParameters.getAllPrefMailCodes();
    
        // VM Box Numbers
    
        allVmBoxNu=advanceSearchParameters.getAllVmBoxNu();
    
            
        // Locations
        
         allLocation=advanceSearchParameters.getAllLocation();
        
       }
       catch(Exception e)
       {
        temp1= 1;
        log.error(" ERROR FROM DATABASE : " + e.getMessage());
       }
 try
 {  
 if(temp1 == 0)
 {    
%>
            
            <table width="100%" height="100%" cellpadding="0" cellspacing="5">
                
            <tr>
            <td>
                    
                <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                
                        
                <tr height="100%">
                <td width="100%" valign="top" class="gcdSkinBorder" style="padding:5px;" dir="ltr" >
                            
                    <form name="frmAdvanceSearch" method="get" target="_self" action="<%= commonUtil.getValidURL(submitButtonURL) %>">
            
                        <table  align="left" >
            
                        <tr>
                            <td colspan="2"><input type="hidden" name="<%= GCDConstants.FORMACTION %>" value="<%=GCDConstants.ADVANCED_SEARCH_FORM%>"/></td>
                        </tr>
                        
                        <%-- submit button --%>
            
                        <tr>
                        <td>
                        <INPUT TYPE="IMAGE" height="11" src="/content/dam/accessmcd/gcd/banner_search_button.gif" width="10" border="0" />&nbsp;<a href="#" class="contentlnk" onclick="javascript:validateAdvForm()">
                        <%=properties.get("SubmitButtonName","Submit")%>
                        </a>
                        </td>
                        </tr>
                
                        <%-- basic search link --%> 
                        <td colspan="1" align="left">
                       <%
                         if(returnPageLinkURL.equals(""))
                         {
                        %>   
                          <img height="10" src="/images/arrow_red_2.gif" width="10" border="0" />&nbsp;<a href="javascript:cancel()" class="contentlnk"><%=properties.get("ReturnPageLinkName","Cancel")%></a>
                        <%
                         }
                         else
                         {
                        %>
                          <img height="10" src="/images/arrow_red_2.gif" width="10" border="0" />&nbsp;<a href="<%= commonUtil.getValidURL(returnPageLinkURL) %>" class="contentlnk"><%=properties.get("ReturnPageLinkName","Cancel")%></a>
                        <%
                         }
                        %>
                        </td>
                        <tr>
                        <td>
                         <%
                         if(!Helppath.trim().equals(""))
                         {
                         %>    
                           <img height="10" src="/images/arrow_red_2.gif" width="10" border="0" />&nbsp;<a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help2" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
                         <%
                          }   
                         %> 
                        </td>
                        </tr>
             
                        <tr>
                        <td colspan="2" class="red"><b></b></td>
                        </tr>
            
                        <%-- error text --%>
                        
                        <tr>
                        <td colspan="2"class="gcderrormessage"><b><%= infoText %></b></td>
                        </tr>
            
            
                        <%-- country --%>
                        
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advCountry%>
                        </td>
                
                
                        <td >   
                        <select name="<%= GCDConstants.SEARCH_COUNTRY %>" >
                       <option >US</option>
                       
            
                        </select>
                        </td>
                        </tr>
            
                        <%-- last name --%>
                        
                        <tr>
                        <td class="gcdcontentlnkhd">
                        <%=advlastName%>
                        </td>
                        <td>
                        <input class="gcdcontentlnkhd" type="text" id="<%= GCDConstants.ADVANCED_SEARCH_LAST_NAME %>" name="<%= GCDConstants.ADVANCED_SEARCH_LAST_NAME %>"  maxlength="20"/>
                        </td>
                        </tr>
            
                        <%-- first name --%>
                        
                        <tr>
                        <td class="gcdcontentlnkhd">
                        <%=advfirstName%>
                        </td>
                        <td height="5">
                        <input class="gcdcontentlnkhd" type="text" id="<%= GCDConstants.ADVANCED_SEARCH_FIRST_NAME %>" name="<%= GCDConstants.ADVANCED_SEARCH_FIRST_NAME %>" value="" maxlength="15"/>
                        </td>
                        </tr>
            
                        <%-- mi  --%>
                        
                        <tr>
                        <td class="gcdcontentlnkhd">
                        <%=advmiddleName%>
                        </td>
                        <td>
                        <input class="gcdcontentlnkhd" type="text" id="<%= GCDConstants.ADVANCED_SEARCH_MI %>" name="<%= GCDConstants.ADVANCED_SEARCH_MI %>" value="" maxlength="1"/>
                        </td>
                        </tr>
            
                        <%-- department name --%>
                        
                        <tr>
                            <td height="5" class="gcdcontentlnkhd">
                                <%=advdeptName%>
                            </td>               
                            <td>
                                <select id="<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME %>"   onfocus = "selectOther('<%= GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME %>')"  name="<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME %>" >
                                    <option></option>
                                <% 
                                    if(allDepartmentNumbers != null)
                                    {
                                        for( int i=0; i<allDepartmentNumbers.size(); i++)
                                        {
                                
                                            DepartmentNameResult departmentNameResult = new DepartmentNameResult();
                                            departmentNameResult = (DepartmentNameResult)allDepartmentNumbers.get(i);
                                %>
                                        <option value="<%= departmentNameResult.getDeptNa() %>"><%= departmentNameResult.getDeptNa()+ " - " + departmentNameResult.getDeptNu() %></option>
                                <%
                                        } 
                                   }
                                %>
                                </select>
                            </td>               
                            
                            <%-- Enter New Department Number --%>   
                            <td height="5" class="gcdcontentlnkhd">
                                <%=advdeptNameContains%>
                            </td>                               
                            <td height="5">     
                                <input class="gcdcontentlnkhd" type="text"   onfocus = "selectOther('<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME %>')" id="<%= GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME %>"  name="<%= GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME %>" maxlength="25"/>
                            </td>
                        </tr>
                        
            
                        <%-- department number --%>
                        
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advdeptNum%>
                        </td>
                
                        <td>
                        <select id="<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER %>"  name="<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER %>" >
                        <option></option>
                        <% 
                        if(allDepartmentNamesByNumber != null)
                        {
                         for( int i=0; i<allDepartmentNamesByNumber.size(); i++)
                         {
                        
                            DepartmentNameResult departmentNameResult = new DepartmentNameResult();
                            departmentNameResult = (DepartmentNameResult)allDepartmentNamesByNumber.get(i);
                        %>
                         <option value="<%= departmentNameResult.getDeptNu()%>"><%= departmentNameResult.getDeptNu() + " - " + departmentNameResult.getDeptNa()%></option>
                        <%
                         }
                        }  
                        %>
                        </select>
                        </td>
                        </tr>
            
                        <%-- state --%>
                        
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advState%>
                        </td>
                
                        <td>
                        <select id="<%= GCDConstants.ADVANCED_SEARCH_STATE %>" name="<%= GCDConstants.ADVANCED_SEARCH_STATE %>" >
                        <option></option>
                        <% 
                        if(allStateCodes != null)
                        {
                         for( int i=0; i<allStateCodes.size(); i++)
                         {
                        
                        %>
                         <option><%= allStateCodes.get(i) %></option>
                        <%
                         }
                        }  
                        %>
                        </select>
                        </td>
                        </tr>
            
                        <%-- region name  --%>
            
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advregionName%>
                        </td>
                
                
                        <td>
                        <select id="<%= GCDConstants.ADVANCED_SEARCH_REGION_NAME %>"  name="<%= GCDConstants.ADVANCED_SEARCH_REGION_NAME %>" >
                        <option></option>
                        <% 
                        if(allRegionNames != null)
                        { 
                         for( int i=0; i<allRegionNames.size(); i++)
                         {
                        
                            RegionNameResult regionNameResult = new RegionNameResult();
                            regionNameResult = (RegionNameResult)allRegionNames.get(i);
                        %>
                         <option value="<%=regionNameResult.getRegNa()%>"><%= regionNameResult.getRegNa() + " " + " - " + " " + regionNameResult.getRegCd() %></option>
                        
                        <%
                         } 
                        }
                        %>
                        </select>
                        </td>
                        </tr>
            
                        <%-- region code SSV modifed so it will use the region name when searching to yield correct results.--%>
                        
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advregionCode%>
                        </td>
                
                        <td>
                        <select id="<%= GCDConstants.ADVANCED_SEARCH_REGION_CODE %>"  name="<%= GCDConstants.ADVANCED_SEARCH_REGION_CODE %>" >
                        <option></option>
                        <% 
                        if(allRegionCodes != null)
                        {
                         for( int i=0; i<allRegionCodes.size(); i++)
                         {
                        
                            RegionNameResult regionNameResult = new RegionNameResult();
                            regionNameResult = (RegionNameResult)allRegionCodes.get(i);
                        %>
                         <option value="<%=regionNameResult.getRegCd() + regionNameResult.getRegNa()%>"><%= regionNameResult.getRegCd() + " " + " - " + " " + regionNameResult.getRegNa() %></option>
                        
                        <%
                         } 
                        } 
                        %>
                        </select>
                        </td>
                        </tr>
                
                        <%-- company name --%>
            
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advcompanyName%>
                        </td>
                    
                        <td>
                        <select id="<%= GCDConstants.ADVANCED_SEARCH_COMPANY_NAME %>"  name="<%= GCDConstants.ADVANCED_SEARCH_COMPANY_NAME %>">
                        <option></option>
                        <% 
                        if(allCompanyNames != null)
                        { 
                         for( int i=0; i<allCompanyNames.size(); i++)
                         {
                        %>
                         <option><%= allCompanyNames.get(i) %></option>
                        <%
                         } 
                        }
                        %>
                        </select>
                        </td>
                        </tr>
                        
                        <%-- Job Title --%>
            
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advjobTitle%>
                        </td>
                        
                        <td>
                        <select id="<%= GCDConstants.ADVANCED_SEARCH_JOB_TITLE %>" name="<%= GCDConstants.ADVANCED_SEARCH_JOB_TITLE %>" >
                        <option></option>
                        <% 
                        if(allJobTitles != null)
                        {
                         for( int i=0; i<allJobTitles.size(); i++)
                         {
                        %>
                         <option><%= allJobTitles.get(i) %></option>
                        <%
                         }
                        } 
                        %>
                        </select>
                        </td>
                        </tr>
                        
                        <%-- Preferred Mail Code --%>
                        
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advpreferredMailCode%>
                        </td>
                        
                        <td>
                        <select id="<%= GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE %>"  name="<%= GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE %>">
                        <option></option>
                        <% 
                        if(allPrefMailCodes != null)
                        {
                         for( Iterator itr=allPrefMailCodes.iterator(); itr.hasNext();)
                         {
                        %>
                         <option><%= (String)itr.next() %></option>
                        <%
                         }
                        }  
                        %>
                        </select>
                        </td>
                        </tr>
            
                        <%-- VM Node Number --%>
                        
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advvmNodeNum%>
                        </td>
                        
                        <td>
                        <select id="<%= GCDConstants.ADVANCED_SEARCH_VM_NODE_NU %>"  name="<%= GCDConstants.ADVANCED_SEARCH_VM_NODE_NU %>" >
                        <option></option>
                        <% 
                        if(allVmBoxNu != null)
                        {
                         for( int i=0; i<allVmBoxNu.size(); i++)
                         {
                        %>
                         <option><%= allVmBoxNu.get(i) %></option>
                        <%
                         }
                        }  
                        %>
                        </select>
                        </td>
                        </tr>
            
                        <%-- Location --%>
                        
                        <tr>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advLocation%>
                        </td>
                    
                        <td>
                        <select id="<%= GCDConstants.ADVANCED_SEARCH_BUILDING_NAME %>" name="<%= GCDConstants.ADVANCED_SEARCH_BUILDING_NAME %>" >
                        <option></option>
                        <% 
                        if(allLocation != null)
                        {
                         for( int i=0; i<allLocation.size(); i++){
                        %>
                        <%--may be useful if including site id option value="<%=buildingDetailsResults.getBldgNa()%>"><%= buildingDetailsResults.getBldgNa() + " " + " - " + " " + buildingDetailsResults.getSiteId() %></option--%>                                    
                         <option><%= allLocation.get(i) %></option> 
                        <%
                         } 
                        }
                        %>
                        </select>
                        </td>
                        </tr>   
                         
                        <%-- Phone Number --%>
                        
                        <tr>
                        <td class="gcdcontentlnkhd">
                        <%=advPhoneNum%>
                        </td>
                        <td height="5">
                        <input class="gcdcontentlnkhd" type="text" id="<%= GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER %>"  name="<%= GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER %>" value=""   onfocus = "selectOther('<%= GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT %>')" maxlength="10"/>
                        </td>    
                        <%-- </tr> --%>
                        
                        <%-- Extension --%>
                        
                        <%-- </tr> --%>
                        <td height="5" class="gcdcontentlnkhd">
                        <%=advPhoneExt%>
                        </td> 
                        
                        <td height="5"> 
                        <input class="gcdcontentlnkhd" type="text" id="<%= GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT %>"  name="<%= GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT %>"  onfocus = "selectOther('<%= GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER %>')"  value="" maxlength="4"/>
                        </td>
                        </tr>
                               
                        <%--  button --%>
            
                        <tr>
                        <td>
                        <INPUT TYPE="IMAGE" height="11" src="/content/dam/accessmcd/gcd/banner_search_button.gif" width="10" border="0" />&nbsp;<a href="#" class="contentlnk" onclick="javascript:validateAdvForm()"><%=properties.get("SubmitButtonName","Submit")%>
                        </a>
                        </td>
                        </tr>
            
                        <%-- basic search link --%>
                        
                        <tr>
                        <td colspan="1" align="left">           
                        <%
                         if(returnPageLinkURL.equals(""))
                         {
                        %>   
                         <img height="10" src="/images/arrow_red_2.gif" width="10" border="0" />&nbsp;<a href="javascript:cancel()" class="contentlnk"><%=properties.get("ReturnPageLinkName","Cancel")%></a>
                        <%
                         }
                         else
                         {
                        %>
                         <img height="10" src="/images/arrow_red_2.gif" width="10" border="0" />&nbsp;<a href="<%= commonUtil.getValidURL(returnPageLinkURL) %>" class="contentlnk"><%=properties.get("ReturnPageLinkName","Cancel")%></a>
                        <%
                         }
                        %>
                        </td>
                        </tr>
                        <tr>
                        <td>
                         <%
                         if(!Helppath.trim().equals(""))
                         {
                         %>
                          
                          <img height="10" src="/images/arrow_red_2.gif" width="10" border="0" />&nbsp;<a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help2" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
                        
                           
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
   else
    {
  %>
     <div class="errorMsg"><%= GCDConstants.ERROR_GCD_DATABASE_ERROR %></div>
   <%  
    }
 }
 catch(Exception e)
 {
  %>
     <div class="errorMsg"><%= GCDConstants.ERROR_GCD_DATABASE_ERROR %></div>
   <% 
 }   
%>  




<script type="text/javascript">

function validateAdvForm()
{
  if( (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_LAST_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_FIRST_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_MI %>').val()) == '')
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER %>').val()) == '')
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_STATE %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_REGION_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_REGION_CODE %>').val()) == '')  
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_COMPANY_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_JOB_TITLE %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE %>').val()) == '')  
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_VM_NODE_NU %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_BUILDING_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER %>').val()) == '')  
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT %>').val()) == '')
     )
  { 
       alert("Please Provide a value");
  }     
  else 
   if( (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_LAST_NAME %>').val()).length < 2) && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_FIRST_NAME %>').val()).length < 2) && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_MI %>').val()) == '')
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER %>').val()) == '')
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_STATE %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_REGION_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_REGION_CODE %>').val()) == '')  
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_COMPANY_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_JOB_TITLE %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE %>').val()) == '')  
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_VM_NODE_NU %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_BUILDING_NAME %>').val()) == '') && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER %>').val()) == '')  
     && (jQuery.trim($('#<%= GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT %>').val()) == '')
     )
    {
     alert('Please enter atleast 2 characters for First Name or Last Name');
    } 
   else
   {
    document.frmAdvanceSearch.submit();
 //   document.frmAdvanceSearch.reset();
   } 
 }     
   
function selectOther(id)
{
  $('#' + id).val('');   
}   


    $(document).ready(function() {
        $('input[type="text"]').each(function(){
            $(this).attr('rel','');
            $(this).attr('value','');
        });
        /*$('input[type="select"]').each(function(){
            $(this).attr('rel','');
            $(this).attr('value','');
            var elementID = $(this).attr('id');
            $('#'+elementID+' option:eq(0)').attr('selected','selected');
        });*/
        
    });

</script>                                       