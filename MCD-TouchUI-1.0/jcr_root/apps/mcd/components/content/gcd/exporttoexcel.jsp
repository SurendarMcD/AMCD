<%-- ########################################### 
 # DESCRIPTION: This is the Export TO Excel component which will Export the data to an excel file
 # Author: Nitin Sharma
 # application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
 # vnd.ms-excel
 # Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
 ##############################################--%>
 
       
<%-- Including the global header file --%>
       
  
    
<%@ include file="/apps/mcd/global/global.jsp" %> 

<%@ page import="com.day.cq.cms.designer.*" %>
<%@ page session="false" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.*" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.*" %>
<%@ page import="com.mcd.util.*" %>
<%@ page import="java.util.ResourceBundle"%>
<%@ page import="com.mcdexchange.nl.*"%>   
   
<%
  
    response.reset();
    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    response.setHeader("Content-type","application/xls");
    response.setHeader("Content-disposition","inline; filename=Results.xls");
   
    
    try
    {

     //Declaring the common variables 
    BasicSearch basicSearch=null;       
    ArrayList searchResult=null;
    ArrayList headers= new ArrayList();     
    AdvancedSearch advancedSearch=null;
    BasicSearchResult basicSearchResult=null;
    boolean displayResult=false;
    int sizeQueryResult=0;
    String infoText="";
    

    String formAction = "";
    String requestedForm = ""; 
    String countryName = "";
    String firstName = "";
    String lastName = "";
    String mi = "";
    String departmentName = "";
    String departmentNumber = "";
    String state = "";
    String companyName = "";
    String jobTitle = "";
    String regionName = "";
    String regionCode = "";
    String regionCodeDesc = "";
    String prefMailCode = "";
    String vmNodeNu = "";
    String buildingName = "";
    String phoneNuExt = "";
    String phoneNumber = "";
    
    String headerName = "";
    String headerOfficePhone = "";
    String headerOfficeLocation = "";
    String headerDepartment = "";
    String headerTitle = "";
    String headerEmail = "";
    String headerFirstName = "";
    String headerMi = "";
    String headerLastName = "";
    String headerAddress1 = "";
    String headerAddress2 = "";     
    String headerCity = "";
    String headerState = "";
    String headerPostalCode = "";
    String headerDepartmentNum = "";
    String headerMailBoxNu = "";
    String headerMailCode = "";
    String headerUsOfficeCell = "";
    String headerVmNodeNu = "";
    String headerPreferredMailCode = "";
    String headerAssistantPhone = "";
    String headerDevice1 = "Device 1";
    String headerDevice2 = "Device 2";
    String headerDevice3 = "Device 3";
    String headerDevice4 = "Device 4";
    String headerDevice5=  "Device 5";
    String headerDevice6 = "Device 6"; 
    
    headerName = (request.getParameter("headerName")!=null)?(request.getParameter("headerName")):"";
    headerOfficePhone = (request.getParameter("headerOfficePhone")!=null)?(request.getParameter("headerOfficePhone")):"";
    headerOfficeLocation = (request.getParameter("headerOfficeLocation")!=null)?(request.getParameter("headerOfficeLocation")):"";
    headerDepartment = (request.getParameter("headerDepartment")!=null)?(request.getParameter("headerDepartment")):"";
    headerTitle = (request.getParameter("headerTitle")!=null)?(request.getParameter("headerTitle")):"";
    headerEmail = (request.getParameter("headerEmail")!=null)?(request.getParameter("headerEmail")):"";
    headerFirstName = (request.getParameter("headerFirstName")!=null)?(request.getParameter("headerFirstName")):"";
    headerMi = (request.getParameter("headerMi")!=null)?(request.getParameter("headerMi")):"";
    headerLastName = (request.getParameter("headerLastName")!=null)?(request.getParameter("headerLastName")):"";
    headerAddress1 = (request.getParameter("headerAddress1")!=null)?(request.getParameter("headerAddress1")):"";
    headerAddress2 = (request.getParameter("headerAddress2")!=null)?(request.getParameter("headerAddress2")):"";        
    headerCity = (request.getParameter("headerCity")!=null)?(request.getParameter("headerCity")):"";
    headerState = (request.getParameter("headerState")!=null)?(request.getParameter("headerState")):"";
    headerPostalCode = (request.getParameter("headerPostalCode")!=null)?(request.getParameter("headerPostalCode")):"";
    headerDepartmentNum = (request.getParameter("headerDepartmentNum")!=null)?(request.getParameter("headerDepartmentNum")):"";
    headerMailBoxNu = (request.getParameter("headerMailBoxNu")!=null)?(request.getParameter("headerMailBoxNu")):"";
    headerMailCode = (request.getParameter("headerMailCode")!=null)?(request.getParameter("headerMailCode")):"";
    headerUsOfficeCell = (request.getParameter("headerUsOfficeCell")!=null)?(request.getParameter("headerUsOfficeCell")):"";
    headerVmNodeNu = (request.getParameter("headerVmNodeNu")!=null)?(request.getParameter("headerVmNodeNu")):"";
    headerPreferredMailCode = (request.getParameter("headerPreferredMailCode")!=null)?(request.getParameter("headerPreferredMailCode")):"";
    headerAssistantPhone = (request.getParameter("headerAssistantPhone")!=null)?(request.getParameter("headerAssistantPhone")):"";
    
    //headerMailCode = "Mail Box Nu";

    headers.add(headerName);    
    headers.add(headerDevice1);
    headers.add(headerDevice2);
    headers.add(headerDevice3);
    headers.add(headerDevice4);
    headers.add(headerDevice5);
    headers.add(headerDevice6);     
    //headers.add(headerOfficePhone);
    headers.add(headerOfficeLocation);
    headers.add(headerDepartment);
    headers.add(headerTitle);
    headers.add(headerEmail);
    headers.add(headerFirstName);
    headers.add(headerMi);
    headers.add(headerLastName);
    headers.add(headerAddress1);
    headers.add(headerAddress2);
    headers.add(headerCity);
    headers.add(headerState);
    headers.add(headerPostalCode);
    headers.add(headerDepartmentNum);
    headers.add(headerMailBoxNu);
    headers.add(headerMailCode);        
    //headers.add(headerUsOfficeCell);
    //headerVmNodeNu= "VM Node #";
    
    //SSV modified E8
    headerVmNodeNu= "Voice Mail Node #";
    //SSV modified E8
    
    headers.add(headerVmNodeNu);
    headers.add(headerPreferredMailCode);
    headers.add(headerAssistantPhone);
    
    
    IGCDFacade iGCDFacade= new GCDFacadeImpl();
            
    if(request.getParameter(GCDConstants.FORMACTION)!=null)
    {
        requestedForm=request.getParameter(GCDConstants.FORMACTION);
    }

    if(GCDConstants.ADVANCED_SEARCH_FORM.equals(requestedForm))
    {
        advancedSearch=new AdvancedSearch();
        countryName=request.getParameter(GCDConstants.SEARCH_COUNTRY);
        firstName=request.getParameter(GCDConstants.ADVANCED_SEARCH_FIRST_NAME);
        lastName=request.getParameter(GCDConstants.ADVANCED_SEARCH_LAST_NAME);
        mi=request.getParameter(GCDConstants.ADVANCED_SEARCH_MI);
        
        countryName = countryName != null && countryName.length() != 0 ? countryName.trim().toUpperCase() + "%" : "";
        firstName = firstName != null && firstName.length() != 0 ? firstName.trim().toUpperCase() + "%" : "";
        lastName = lastName != null && lastName.length() != 0 ? lastName.trim().toUpperCase() + "%" : "";
        mi=mi != null && mi.length() != 0 ? mi.trim().toUpperCase() + "%" : "";
        
        departmentName = request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME).toUpperCase();
        departmentNumber = request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER).toUpperCase();
        state = request.getParameter(GCDConstants.ADVANCED_SEARCH_STATE).toUpperCase();
        companyName = request.getParameter(GCDConstants.ADVANCED_SEARCH_COMPANY_NAME).toUpperCase();
        jobTitle = request.getParameter(GCDConstants.ADVANCED_SEARCH_JOB_TITLE).toUpperCase();
        regionName = request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_NAME).toUpperCase();
        regionCode = request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_CODE).toUpperCase();
                
        regionCodeDesc = request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_CODE_DESC).toUpperCase();     
        
        prefMailCode = request.getParameter(GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE).toUpperCase();
        vmNodeNu = request.getParameter(GCDConstants.ADVANCED_SEARCH_VM_NODE_NU).toUpperCase();
        //buildingName = request.getParameter(GCDConstants.ADVANCED_SEARCH_BUILDING_NAME).toUpperCase();
        buildingName = request.getParameter(GCDConstants.ADVANCED_SEARCH_BUILDING_NAME);
        
        
        phoneNuExt = request.getParameter(GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT);
         
        phoneNumber = request.getParameter(GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER);
        
        advancedSearch.setCountry(countryName);
        advancedSearch.setLastName(lastName);
        advancedSearch.setFirstName(firstName);
        advancedSearch.setMi(mi);           
        advancedSearch.setDepartment(departmentName);
        advancedSearch.setDepartmentNumber(departmentNumber);
        advancedSearch.setState(state);
        advancedSearch.setCompanyName(companyName);
        advancedSearch.setJobTitle(jobTitle);
        advancedSearch.setRegNa(regionName);
        advancedSearch.setRegCd(regionCode);
        advancedSearch.setRegCdDesc(regionCodeDesc);
        advancedSearch.setPrefMailCd(prefMailCode);
        advancedSearch.setVmNodeNu(vmNodeNu);
        advancedSearch.setBuildingNa(buildingName);
        advancedSearch.setPhoneNuExt(phoneNuExt);
        advancedSearch.setCountry(request.getParameter(GCDConstants.SEARCH_COUNTRY).toUpperCase());
        advancedSearch.setZoneCd("");
        advancedSearch.setPhoneNumber(phoneNumber);
       
        searchResult=iGCDFacade.getSearchResult(advancedSearch,sling);   
          
    }     
    else if(GCDConstants.BASIC_SEARCH_FORM.equals(requestedForm))    
    {
        // populate the Advanced Search object
        basicSearch=new BasicSearch();
        
        countryName=request.getParameter(GCDConstants.SEARCH_COUNTRY);
        firstName=request.getParameter(GCDConstants.BASIC_SEARCH_FIRST_NAME);
        lastName=request.getParameter(GCDConstants.BASIC_SEARCH_LAST_NAME);
        
        
        countryName = countryName != null && countryName.length() != 0 ? countryName.trim().toUpperCase() + "%" : "";
        firstName = firstName != null && firstName.length() != 0 ? firstName.trim().toUpperCase() + "%" : "";
        lastName = lastName != null && lastName.length() != 0 ? lastName.trim().toUpperCase() + "%" : "";
        
        
        basicSearch.setCountry(countryName);
        basicSearch.setLastName(lastName);
        basicSearch.setFirstName(firstName);
   
        searchResult=iGCDFacade.getSearchResult(basicSearch,sling);
    } 
        
        
    
    //HttpSession session=request.getSession(false);
    
    if (searchResult!=null && headers!=null)
    {
        //searchResult=(ArrayList)session.getAttribute(GCDConstants.SEARCH_RESULT_RESULTS+"export2Excel");
        //headers=(ArrayList)session.getAttribute(GCDConstants.SEARCH_RESULT_HEADERS);
        sizeQueryResult = searchResult.size();
        displayResult=true;
    }
        

    
%>
<%
    if(displayResult)
    {
%>

 
<table width="100%" cellpadding="0" cellspacing="1" border="1">
<tr>
        <td><b><%= sizeQueryResult %> record(s) found</b></td>
</tr>
<%-- headers --%>
    <tr>
<% 
    if(  sizeQueryResult > 0 )
    {
    Iterator headersItr = headers.iterator();
    while(headersItr.hasNext())
        {   
%>  

        <td ><b><%=headersItr.next() %></b></td>
        

<% 
        }
    }
%>
</tr>


<%-- results --%>

<%
for( int i=0; i<sizeQueryResult; i++ )
{    

//log.error("going into the loop");

basicSearchResult = (BasicSearchResult)searchResult.get(i);
                        
         
%>
    <tr>
        <td><%= basicSearchResult.getLastNm() %>, <%= ( basicSearchResult.getFstNaAlias().length() == 0 ) ? basicSearchResult.getFstNm() : "<i>"+basicSearchResult.getFstNaAlias().toUpperCase()+" &nbsp;</i>" %> <%= basicSearchResult.getMidInitNa() %></td>  
        
        <%--<td><%= basicSearchResult.getUsOffcPhne().toUpperCase() %></td> --%>
            
        <%
        
        //log.error("Before variable declartion");
        int Numberlength = 0;
        String sdevicenumber = "";
        String DisplayLabel = "";
        //log.error("Before deviceid 1 Test");              
        
        if (basicSearchResult.getDeviceID1() >0)
           { 
        
             Numberlength = basicSearchResult.getDeviceNumber1().length();
              if (Numberlength==10)
                  {
                   sdevicenumber = basicSearchResult.getDeviceNumber1();             
                   sdevicenumber = "(" + sdevicenumber .substring(0, 3) + ") " + sdevicenumber .substring(3,6) + "-" + sdevicenumber .substring(6);
              } 
               else
                 
             {
               sdevicenumber = basicSearchResult.getDeviceNumber1();
              
              }    
                   switch (basicSearchResult.getDeviceID1())
                {
                        case 1:     DisplayLabel =  "Bus Phone: "; break;
                        case 2:     DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                        case 5:     DisplayLabel =  "Bus Fax: "; break;
                        case 6:     DisplayLabel =  "Other: "; break;        
                        default:    DisplayLabel =  "Invalid deviceid";break;
                        }                                                                                             
                                                 
              
            }
            
            //log.error("Device1 from the excel " + DisplayLabel + StringUtils.nullToEmptyString(sdevicenumber));     
              
          %>
              
        <td><%= DisplayLabel + sdevicenumber %></td>   
        
        <%
        
        Numberlength = 0;
        sdevicenumber = "";
        DisplayLabel = "";
                
    
        
        if (basicSearchResult.getDeviceID2() >0)
           { 
            Numberlength = basicSearchResult.getDeviceNumber2().length();
             
              if (Numberlength==10)
                  {
                   sdevicenumber = basicSearchResult.getDeviceNumber2();             
                   sdevicenumber = "(" + sdevicenumber .substring(0, 3) + ") " + sdevicenumber .substring(3,6) + "-" + sdevicenumber .substring(6);
               
               }
               
               else
               
                  { sdevicenumber = basicSearchResult.getDeviceNumber2();
              
              }    
                   switch (basicSearchResult.getDeviceID2())
                {
                        case 1:     DisplayLabel =  "Bus Phone: "; break;
                        case 2:     DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                        case 5:     DisplayLabel =  "Bus Fax: "; break;
                        case 6:     DisplayLabel =  "Other: "; break;        
                        default:    DisplayLabel =  "Invalid deviceid";break;
                     }                                             
                         
                    
            }     
              
          %>
              
              
         
          
        <td><%= DisplayLabel + sdevicenumber %></td>  
        
        <%
        
         Numberlength = 0;
         sdevicenumber = "";
         DisplayLabel = "";     
        
          if (basicSearchResult.getDeviceID3() >0)
           { 
              Numberlength = basicSearchResult.getDeviceNumber3().length();
             
              if (Numberlength==10)
                  {
                   sdevicenumber = basicSearchResult.getDeviceNumber3();             
                   sdevicenumber = "(" + sdevicenumber .substring(0, 3) + ") " + sdevicenumber .substring(3,6) + "-" + sdevicenumber .substring(6);
               }
        
            else
               {       
               sdevicenumber = basicSearchResult.getDeviceNumber3();
              
                }
                   switch (basicSearchResult.getDeviceID3())
                {
                        case 1:     DisplayLabel =  "Bus Phone: "; break;
                        case 2:     DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                        case 5:     DisplayLabel =  "Bus Fax: "; break;
                        case 6:     DisplayLabel =  "Other: "; break;        
                        default:    DisplayLabel =  "Invalid deviceid";break;
                     }                                             
                                                  
                         
              
            }     
              
          %>
              
              
    
        <td><%= DisplayLabel + sdevicenumber %></td>  
        
        <%
        
        Numberlength = 0;
        sdevicenumber = "";
        DisplayLabel = "";      
        
           if (basicSearchResult.getDeviceID4() >0)
           { 
        
             Numberlength = basicSearchResult.getDeviceNumber4().length();
              if (Numberlength==10)
                  {
                   sdevicenumber = basicSearchResult.getDeviceNumber4();             
                   sdevicenumber = "(" + sdevicenumber .substring(0, 3) + ") " + sdevicenumber .substring(3,6) + "-" + sdevicenumber .substring(6);
               }
               
               else
               { sdevicenumber = basicSearchResult.getDeviceNumber4();
              
               }
                   switch (basicSearchResult.getDeviceID4())
                {
                        case 1:     DisplayLabel =  "Bus Phone: ";break;
                        case 2:     DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                        case 5:     DisplayLabel =  "Bus Fax: "; break;
                        case 6:     DisplayLabel =  "Other: "; break;        
                        default:    DisplayLabel =  "Invalid deviceid";break;
                     }                                             
             
             
            }     
              
          %>
              
             
    
        <td><%= DisplayLabel + sdevicenumber %></td>
            
        <%
        
        Numberlength = 0;
        sdevicenumber = "";
        DisplayLabel = "";      
        
          if (basicSearchResult.getDeviceID5() >0)
           { 
        
             Numberlength = basicSearchResult.getDeviceNumber5().length();
              if (Numberlength==10)
                  {
                   sdevicenumber = basicSearchResult.getDeviceNumber5();             
                   sdevicenumber = "(" + sdevicenumber .substring(0, 3) + ") " + sdevicenumber .substring(3,6) + "-" + sdevicenumber .substring(6);
               
               }
               
               else
               
               {
               
                 sdevicenumber = basicSearchResult.getDeviceNumber5();
              
                    }      
               
                        switch (basicSearchResult.getDeviceID5())
                {
                        case 1:     DisplayLabel =  "Bus Phone: "; break;
                        case 2:     DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                        case 5:     DisplayLabel =  "Bus Fax: "; break;
                        case 6:     DisplayLabel =  "Other: "; break;        
                        default:    DisplayLabel =  "Invalid deviceid";break;
                     }                                                                                                
             
          
              
            }     
              
          %>
              
              
         
        <td><%= DisplayLabel + sdevicenumber %></td> 
        
        <%
        
        Numberlength = 0;
        sdevicenumber = "";
        DisplayLabel = "";
        
        //log.error("prior to the six device if statment");
        //log.error("sixth device length:" + basicSearchResult.getDeviceID6());
        //log.error("six number: " +  basicSearchResult.getDeviceNumber6());
    
        if (basicSearchResult.getDeviceID6() >0)
           { 
             Numberlength = basicSearchResult.getDeviceNumber6().length();
             //log.error("6th device length: " + Numberlength);
             //log.error("6th device id: " + basicSearchResult.getDeviceID6());
             
              if (Numberlength==10)
                  {
                   sdevicenumber = basicSearchResult.getDeviceNumber6();             
                   sdevicenumber = "(" + sdevicenumber .substring(0, 3) + ") " + sdevicenumber .substring(3,6) + "-" + sdevicenumber .substring(6);
               
               }
               
               else
               
                 {
               
               
                   sdevicenumber = basicSearchResult.getDeviceNumber6();
               
              } 
                       
               //log.error("the six formatted number: " + sdevicenumber);
                   switch (basicSearchResult.getDeviceID6())
                {
                        case 1:     DisplayLabel =  "Bus Phone: "; break;
                        case 2:     DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                        case 5:     DisplayLabel =  "Bus Fax: "; break;
                        case 6:     DisplayLabel =  "Other: "; break;        
                        default:    DisplayLabel =  "Invalid deviceid";break;
                     }                                                                                        
                 
          
            }
            
            //log.error("After the end of the six device statment");      
              
          %>
              
             
        
        <td><%= DisplayLabel + sdevicenumber %></td> 
        
        <td><%= basicSearchResult.getBldgNa().toUpperCase() %></td> 

<%  
        if( basicSearchResult.getDeptNu().length() != 0 && basicSearchResult.getDeptNa().length() != 0 )
        {
%>      
        <td><%= basicSearchResult.getDeptNu() %>-<%= basicSearchResult.getDeptNa().toUpperCase() %></td>
<% 
        }
        else
        {
%>
        <td><%= basicSearchResult.getDeptNu() %><%= basicSearchResult.getDeptNa().toUpperCase() %></td>
<% 
        }
%>

        <td><%= basicSearchResult.getJobTitlDs().toUpperCase() %></td>
        <td><%= basicSearchResult.getEmail().toUpperCase() %></td>
        <td><%= basicSearchResult.getFstNm().toUpperCase() %></td>
        <td><%= basicSearchResult.getMidInitNa().toUpperCase() %></td>
        <td><%= basicSearchResult.getLastNm().toUpperCase() %></td>
        
        <td><%= basicSearchResult.getBusL1Ad().toUpperCase() %></td>
        <td><%= basicSearchResult.getBusL2Ad().toUpperCase() %></td>
        <td><%= basicSearchResult.getBusCityAd().toUpperCase() %></td>
        <td><%= basicSearchResult.getBusAbbrStAd().toUpperCase() %></td>
        <td><%= basicSearchResult.getBusPstlCd().toUpperCase() %></td>
        <td><%= basicSearchResult.getDeptNu() %></td>
        <td><%= basicSearchResult.getMailBoxNu() %></td>    
        <td><%= basicSearchResult.getMailCd().toUpperCase() %></td> 
        

    
        <%--<td><%= basicSearchResult.getUsCellPhne().toUpperCase() %></td> --%>
        
        <td><%= basicSearchResult.getVmNodeNu().toUpperCase() %></td>
        <td><%= basicSearchResult.getPrefMailCd().toUpperCase() %></td>
        <td><%= basicSearchResult.getAdminOffcPhne().toUpperCase() %></td>

    </tr>
    <%
}
%>


    
 


</table>
    <% 
    }
   }
   catch(Exception e) 
   {
    log.error("Could Not Create Excel" + e.getMessage());
   }
%>   

   