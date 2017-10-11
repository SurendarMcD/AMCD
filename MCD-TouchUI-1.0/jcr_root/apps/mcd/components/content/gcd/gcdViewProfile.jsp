<%@include file="/libs/wcm/global.jsp"%> 
<%@ page session="false" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.ViewProfile" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.ExpandedSearchResult" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.DirectReports" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.GCDConstants" %>
<%@ page import="com.mcd.accessmcd.gcd.util.*" %>
<%@ page import="java.util.ResourceBundle,com.mcd.accessmcd.util.CommonUtil"%>
<%@ page import="com.mcd.accessmcd.common.helper.PropertyHelper"%>
<%@ page import="com.day.cq.i18n.I18n"%>


<%
    ArrayList groupList = null;
    ArrayList  allDirectReports = null;
    boolean franchaiseesFlag=false;
    ExpandedSearchResult expandedSearchResult=null;
    ArrayList allUserList=new ArrayList();
    IGCDFacade iGCDFacade=null;
    boolean showResult=false;
    boolean eidProvided = false;
    String iframeBorder=""; 
    String iframeScroll="";
    HttpSession session=null;
    String DisplayLabel = "";
    String UsOfficePhone="";
    CommonUtil commonUtil= new CommonUtil();  
    
    String loggedInEid = "";
    
     // Logged in user Details
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);  //instantiate User object
        
    if(user != null){ 
    loggedInEid  = user.getID();   
                   
    }   
    String advanceSearchPath =  properties.get("AdvanceSearchPath","");
    String returnPageLinkURL =  properties.get("cancelURL","");
    String Helppath = properties.get("helpPath","");
    String eid = request.getParameter(GCDConstants.UPDATE_ADMIN_EID_TAG);
   // Check if EID is blank
         try{
            if(eid==null)
            {
              showResult=false;  
              eidProvided =false;
            %>
           <font color="red"><b><%= langText.get("Please enter the valid EID") %></b></font>
          <%}   
            
    // else do the user search
       else{
            showResult=true;
            eidProvided = true;
            iGCDFacade= new GCDFacadeImpl();
            allUserList=iGCDFacade.selectProfileByEid(eid.toUpperCase(),sling);           
            for( int i=0; i<allUserList.size(); i++ )
            {
                expandedSearchResult = (ExpandedSearchResult)allUserList.get(i);
            }
           
            if(expandedSearchResult==null)
            {
              showResult=false;
            }
            }
            }  catch(Exception e)
            {
             showResult=false;
             log.error("View Profile : No Data From Database : " + e.getMessage());
            }     
  
  if(showResult == true && eidProvided == true)
  {               
%>
        <div id="gcdUserProfile">
        
            <table cellspacing="4" cellpadding="3" border="0" width="100%">
            <tbody>
            <tr height="5">
          
            
            <td background=""> 
            </td>
            </tr>
            
            <tr height="100%">
            <td>
                <table cellspacing="4" cellpadding="3" border="0" width="100%">
                <tbody>
                 
                <tr>
                <td width="100%" valign="top">
                    <table height="100%" cellspacing="4" cellpadding="3" border="0" width="100%">
                    <tbody>
                    <tr>
                    <td>
                        <table height="100%" cellspacing="4" cellpadding="3" border="0" width="100%">               
                        <tbody>
                        <tr height="1">
                     
                        <td nowrap="" height="10" width="100%"> 
                         
                        <table cellspacing="4" cellpadding="3" border="0" width="100%">
                        
                        <tbody>     
                            <tr>
                            <td class="" nowrap="" align="left" width="100%" valign="center">
                            </td>   
                            <td class="">
                            </td>
                            <td class="">
                            </td>
                            <td align="right" valign="top" style="width: 6px;">
                            </td>
                            </tr>
                            </tbody>
                            </table>
                    </td>
                    </tr>
                        <tr height="100%">
                       
                        <td class="gcdSkinBorder" width="100%" valign="top"  dir="ltr">
                        
                        <form name="viewUserProfile" method="post" action="">
                        <%-- Including GCD Header --%>
        
                            <table width="100%" align="center" cellpadding="3" cellspacing="4" style="padding-left:5px;" font-size="10pt">
                             
                            <%
                            // if EID is not null then show the details                 
                            if(showResult && expandedSearchResult!=null)
                            {  
                            %>                              
                            <tr>
                            <td colspan="1" class="gcdcontentlnkhd"></td>
                            </tr> 
                            <%
                            // if franchaiseesFlag is true then show the different view for user details
                             
                            if (franchaiseesFlag){
                            %>
                                    <%-- Name --%>
                                         
                                    <tr>
                                        <td class="gcdcontentlnkhd"><b><%= properties.get("name",langText.get("Name"))%></b></td>   
                                        <td class="gcdcontentlnkhd"><%= expandedSearchResult.getLastNm().toUpperCase()%>,<%= expandedSearchResult.getFstNm().toUpperCase() %> <%= expandedSearchResult.getMidInitNa().toUpperCase()%></td>
                                        </td>
                                    </tr>
                                    
                                    <%-- C/O --%>
                                    
                                    <tr>
                                        <td class="gcdcontentlnkhd"><b><%= properties.get("CO",langText.get("CO"))%></b></td>
                                        <td class="gcdcontentlnkhd"><%= expandedSearchResult.getOperCareOfNa() %></td>
                                    </tr>
                                    
                                    <%-- Address --%>   
                                    
                                    <tr>
                                        <td class="gcdcontentlnkhd"><b><%= properties.get("Address",langText.get("Address"))%></b></td>
                                        <td class="gcdcontentlnkhd"><%=expandedSearchResult.getOperStreAd()%>,<%= expandedSearchResult.getOperCityAd() %>,<%=expandedSearchResult.getOperStProvAd()%>,<%=expandedSearchResult.getOperZipCd()%>
                                        </td>
                                    </tr>
                                    
                                    <%-- Country --%>
                                    
                                    <tr>
                                        <td class="gcdcontentlnkhd"><b><%= properties.get("Country",langText.get("Country"))%></b></td>
                                        <td class="gcdcontentlnkhd"><%=expandedSearchResult.getCtryCd() %>
                                        </td>
                                    </tr>
                                    
                                    <%-- Phone --%>
                                    
                                    <%  
                                if( expandedSearchResult.getOperPhneAreaCd().length() > 0 && expandedSearchResult.getOperPhneXcngNu().length() > 0 && expandedSearchResult.getOperPhneLnNu().length() > 0 )
                                {
                                    %>      
                                    <tr height="2">
                                    <td><b><%= GCDConstants.SEARCH_RESULTS_OPER_PHNE_TAG %></b></td>
                                    <td>(<%= expandedSearchResult.getOperPhneAreaCd() %>) <%= expandedSearchResult.getOperPhneXcngNu() %>-<%= expandedSearchResult.getOperPhneLnNu() %></td>
                                    </tr>
                                
                                    <% 
                                }
                                else if (expandedSearchResult.getOperPhneAreaCd().length() == 0 && expandedSearchResult.getOperPhneXcngNu().length() > 0 && expandedSearchResult.getOperPhneLnNu().length() > 0)
                                {
                                    %>
                                    <tr height="2">
                                    <td><b><%= GCDConstants.SEARCH_RESULTS_OPER_PHNE_TAG %></b></td>
                                    <td><%= expandedSearchResult.getOperPhneXcngNu() %>-<%= expandedSearchResult.getOperPhneLnNu() %></td>
                                    </tr>
                                    <% 
                                }
                                else 
                                {
                                    %>
                                    <tr height="2">
                                    <td><b><%= GCDConstants.SEARCH_RESULTS_OPER_PHNE_TAG %></b></td>
                                    <td></td>
                                    </tr>
                                    <% 
                                }
                                    %>
                                 <tr>
                                        <td class="gcdcontentlnkhd"><b><%= properties.get("Phone",langText.get("Phone"))%></b></td>     
                                        <td class="gcdcontentlnkhd">(<%= expandedSearchResult.getOperPhneAreaCd() %>)&nbsp;<%= expandedSearchResult.getOperPhneXcngNu() %>-<%=expandedSearchResult.getOperPhneLnNu()%> </td>
                                        </td>
                                    </tr>
                            
                                    <%-- Mail Contact --%>
                                    
                                    <tr>
                                        <td class="gcdcontentlnkhd"><b><%= properties.get("MailContact",langText.get("Mail Contact"))%></b></td>
                                        <% String mailcontact=  expandedSearchResult.getOperMailCntcFl();
                                           String responseVal="N";
                                        if (mailcontact!= null && !mailcontact.equals("")){
                                            responseVal="Y";
                                        }
                                        %>
                                        <td class="gcdcontentlnkhd"><%= responseVal%>
                                        </td>
                                    </tr>
                                      
                                    <%-- VM Node --%> 
                                    
                                    <tr>
                                        <td class="gcdcontentlnkhd"><b><%= properties.get("VmNode",langText.get("Voice Mail Node"))%></b></td>
                                        <td class="gcdcontentlnkhd"><%= expandedSearchResult.getVmNodeNu() %>
                                        </td>
                                        
                                    </tr>
                                    
                                    <%-- Us Office Phone --%>
                                    
                                    <tr>
                                        <td class="gcdcontentlnkhd"><b><%= properties.get("UsOfficePhone",langText.get("UsOfficePhone"))%></b></td>
                                        <%
                                                String OUSofficephone =""; 
                                                int Numberlength=0;
                                        
                                               if ((expandedSearchResult.getUsOffcPhne()) != null)                                               
                                                 {                                                               
                                                    Numberlength = expandedSearchResult.getUsOffcPhne().length();                                                                   
                                                if (Numberlength==10)
                                                   {
                                                    OUSofficephone = "(" + expandedSearchResult.getUsOffcPhne().substring(0, 3) + ") " + expandedSearchResult.getUsOffcPhne() .substring(3,6) + "-" + expandedSearchResult.getUsOffcPhne() .substring(6);
                                                   } 
                                                 }                 
                                        %>
                                        <td class="gcdcontentlnkhd"><%= OUSofficephone %></td>
                                    </tr>
                            <%
                            }
                            else{
                          
                            // if franchaiseesFlag is false then show the normal view for user details
                            %>
                                <%-- Name, Country Code, State Site, Company Name --%>
                                <tr>
                                <td class="gcdcontentlnkhd"><b><%= properties.get("name",langText.get("Name"))%></b></td>    
                                  
                                <td class="gcdcontentlnkhd"><b><%= properties.get("countryCode",langText.get("Country Code"))%></b></td> 
                                <td class="gcdcontentlnkhd"><b><%= properties.get("stateSite",langText.get("State Site"))%></b></td>         
                                <td class="gcdcontentlnkhd" style="width: 200px;"><b><%= properties.get("companyName",langText.get("Company Name"))%></b></td>
                                </tr>
            
                                <tr>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getLastNm().toUpperCase()%>,<%= expandedSearchResult.getFstNm().toUpperCase()%> <%= expandedSearchResult.getMidInitNa().toUpperCase()%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getCtryCd().toUpperCase()%></td>      
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getSiteIdNu()%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getCoNm().toUpperCase()%></td>
                                </tr>
                                <%-- Company Name, Department, Title, Region --%>
                                
                                <tr>
                                <td class="gcdcontentlnkhd"><b><%= properties.get("email",langText.get("Email Address"))%></b></td> 
                                <td class="gcdcontentlnkhd"><b><%= properties.get("department",langText.get("Department"))%></b></td>
                                <td class="gcdcontentlnkhd"><b><%= properties.get("title",langText.get("Title"))%></b></td>
                                <td class="gcdcontentlnkhd" style="width: 200px;"><b><%= properties.get("region",langText.get("Region"))%></b></td>   
                                </tr>
                                
                                <tr>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getEmail().toUpperCase()%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getDeptNu().toUpperCase()%><%= expandedSearchResult.getDeptNa().toUpperCase()%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getJobTitlDs().toUpperCase()%></td>   
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getRegCd().toUpperCase()%><%= (expandedSearchResult.getRegCd().equals("")) ? "" : "-" %><%= expandedSearchResult.getRegNa().toUpperCase()%></td>             
                                </tr>
                                <%-- Manager, Manager Phone, Extension --%>
                                
                                <tr>
                                <td class="gcdcontentlnkhd"><b><%= properties.get("manager",langText.get("Manager"))%></b></td>
                                <td class="gcdcontentlnkhd"><b><%= properties.get("ManagerPhone",langText.get("Manager Phone"))%></b></td>
                                <td class="gcdcontentlnkhd"><b><%= properties.get("ManagerEmail",langText.get("Manager Email"))%></b></td>          
                                <%--<td class="gcdcontentlnkhd"><b><%= properties.get("extension","")%></b></td> --%>         
                                </tr>
                                <%
                                  String MgrBusinessphone = "";
                                  String CtryCd = "";
                                  CtryCd =  StringUtils.nullToEmptyString(expandedSearchResult.getCtryCd().toUpperCase());
                                  if ((expandedSearchResult.getMgrOffcPhne()) != null)
                                       {    
                                        int Numberlength=0;
                                        MgrBusinessphone  = expandedSearchResult.getMgrOffcPhne();
                                        if (MgrBusinessphone.length() > 0)  
                                          {
                                            Numberlength = expandedSearchResult.getMgrOffcPhne().length();                              
                                        if ((CtryCd.equals("US")) && (Numberlength==10))
                                                    {
                                                    MgrBusinessphone  = "(" + MgrBusinessphone .substring(0, 3) + ") " + MgrBusinessphone .substring(3,6) + "-" + MgrBusinessphone .substring(6);
                                                    } 
                                          }            
                    
                                       }
                                       String MgrEmail = "";             
                                       if ((expandedSearchResult.supgetEmail()) != null)                  
                                       {                 
                                    MgrEmail = expandedSearchResult.supgetEmail();
                                       } 
                                  %>
         
                                <tr>
                                <td class="gcdcontentlnkhd"><a href ="<%= commonUtil.getValidURL(currentPage.getPath()) %>?EID=<%= expandedSearchResult.getMgrEid() %> "><%= expandedSearchResult.getMgrLastNa().toUpperCase()%><%= (expandedSearchResult.getMgrLastNa().equals("")) ? "" : "," %><%= expandedSearchResult.getMgrFstNa().toUpperCase()%></a></td>
                                <td class="gcdcontentlnkhd"><%= MgrBusinessphone%></td> 
                                <td class="gcdcontentlnkhd"><%= MgrEmail%></td>                                                                
                                </tr>
                                
                                <tr>
                                <td class="gcdcontentlnkhd"><b><%= properties.get("DirectReport",langText.get("Direct Report(s)"))%></b></td>
                                <td class="gcdcontentlnkhd"><b><%= properties.get("DPhoneNo",langText.get("Office Phone"))%></b></td>       
                                <td class="gcdcontentlnkhd" style="width: 280px;"><b><%= properties.get("DEmail",langText.get("EMail"))%></b></td>
                                </tr>
        
                                 <%-- Display the direct reports  --%>
                                                                                 
                                 <%                          
                                     
                                        CtryCd =  StringUtils.nullToEmptyString(expandedSearchResult.getCtryCd().toUpperCase());
                                        if ((expandedSearchResult.getDirectReports()) != null)
                                       {
                                         allDirectReports = expandedSearchResult.getDirectReports();                                                                     
                                        for( int i=0; i<allDirectReports.size(); i++)
                                        {
                                         DirectReports directReports = new DirectReports();                                                                 
                                         directReports = (DirectReports)allDirectReports.get(i);
                                        String Businessphone = "";
                                        int Numberlength=0;
                                        Businessphone = StringUtils.nullToEmptyString(directReports.getOfficePhone());
                                        if (Businessphone.length() > 0) 
                                          {
                                            Numberlength = directReports.getOfficePhone().length();                             
                                                if ((CtryCd.equals("US")) && (Numberlength==10))
                                                   {
                                                    Businessphone = "(" + Businessphone.substring(0, 3) + ") " + Businessphone.substring(3,6) + "-" + Businessphone.substring(6);
                                                   } 
                                          }            
         
                                %>
                                            <tr>
                                            <td class="gcdcontentlnkhd"><a href ="<%= commonUtil.getValidURL(currentPage.getPath()) %>?EID=<%= directReports.getEID() %> "> <%= directReports.getName() %></a> </td>
                                            <td class="gcdcontentlnkhd" style="width: 185px;"> <%= Businessphone %> </td>
                                            <td class="gcdcontentlnkhd"> <%= directReports.getEmail() %> </td> 
                                            </tr>               
                                               <%               
                                        }                    
                                      }//if any direct reports
                                    %>                                                          
                                </table>
                                <%-- display page links --%>
                                <table class="gcddata" width="100%" align="center" cellpadding="3" cellspacing="4" style="padding-left:5px;">
                              
                                 
                                <%-- show page links --%>
                                <table class="gcdcontentlnkhd" width="100%" align="center" cellpadding="3" cellspacing="4" >
                                    <%-- Exit and AdvanceSearchLink --%>
               
                                    <tr>
                                    <td align="left">
                                    <%
                                     if(returnPageLinkURL.equals(""))
                                     {
                                    %> &nbsp;
                                      <a href="javascript:cancel()" class="contentlnk"><%= properties.get("ExitLinkLabel",langText.get("Cancel"))%></a>
                                    <%
                                      }
                                     else
                                      {
                                     %> &nbsp;
                                       <a href="<%= commonUtil.getValidURL(returnPageLinkURL) %>" class="contentlnk"><%= properties.get("ExitLinkLabel",langText.get("Cancel"))%></a>
                                     <%
                                      }
                                     %>
                                                                        
                                    &nbsp;&nbsp;&nbsp;
                                  <a href="<%= commonUtil.getValidURL(advanceSearchPath) %>" class="contentlnk"><%= properties.get("AdvanceSearchLinkLabel",langText.get("Advanced Search"))%></a>
                                  <%
                                    if(!Helppath.trim().equals(""))
                                    {
                                  %>
                                     &nbsp;&nbsp;&nbsp 
                                     <a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help2" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
                                  <%
                                     }   
                                  %>
                                     &nbsp;&nbsp;&nbsp; 
                                    <%
                                     if(loggedInEid.equalsIgnoreCase(eid))
                                     {
                                    %>
                                      <a  class="contentlnk" target="_blank" href="<%=commonUtil.getValidURL(properties.get("updateProfLink",GCDConstants.UPDATE_PROFILE_MPPM_LINK))  %>" ><%= properties.get("updateProf",langText.get("Update Profile in Global Account Manager"))%> </a>
                                    <%
                                     }
                                    %>
                                    </td> 
                                    </tr>
              
                                <%-- personal information --%>
            
                                <table class="gcddata" width="100%" align="center" cellpadding="3" cellspacing="4" style="padding-left:5px;">
                               
                                <%-- Preferred First Name, Office Location  --%>
           
                                <tr>
                                <td class="gcdcontentlnkhd" style="width: 185px;" ><%= properties.get("PreferredFirstName",langText.get("Preferred First Name"))%>
                                </td>
                                <td class="gcdcontentlnkhd" style="width: 185px;" ><%= expandedSearchResult.getFstNmAlias().toUpperCase() %>
                                </td>
                                <td class="gcdcontentlnkhd" style="padding-left: 3px;" ><%= properties.get("OfficeLocation",langText.get("Office Location"))%>
                                </td>
                                <td class="gcdcontentlnkhd" style="width: 185px;"><%= expandedSearchResult.getBldgNa().toUpperCase() %>
                                </td>
                                </tr>
            
                                <%-- OLD US Office Phone, Business Address1 --%>
                                <%-- Device 1 Lable/number --%>
                                <%--int deviceid=  expandedSearchResult.getDeviceID1(); --%>
                                                    
                                <%
                                int deviceid=0;
                                String sdeviceid="";
                                String Countrycd;                       
                                int Numberlength =0;
                                String Officephone = "";
        
                                if (expandedSearchResult.getDeviceID1()>0)                                               
                                   {                         
                                    deviceid = expandedSearchResult.getDeviceID1();                         
                                    Countrycd = expandedSearchResult.getCtryCd().toUpperCase();        
                                    Numberlength = expandedSearchResult.getDeviceNumber1().length();
                                    if ((Countrycd.equals("US")) && (Numberlength==10))
                                      {      
                                        sdeviceid = expandedSearchResult.getDeviceNumber1();
                                        sdeviceid = "(" + sdeviceid.substring(0, 3) + ") " + sdeviceid.substring(3,6) + "-" + sdeviceid.substring(6);
                                      } 
                                      else
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber1();                             
                                      }
                                      
                                     DisplayLabel = expandedSearchResult.getDeviceDescr1();
                                    if (deviceid==1) 
                                        {
                                    
                                           if(Officephone.length()==0)  Officephone = sdeviceid ;
                                        }
                                        }                                         
                                else
                                 {
                                  DisplayLabel="Phone 1";
                                 }                                                                   
                                %>
                              
                                <tr>
                                <td class="gcdcontentlnkhd" ><%= DisplayLabel %>                     
                                </td>
                                <td class="gcdcontentlnkhd" ><%= (StringUtils.nullToEmptyString(sdeviceid)) %> 
                                </td>
                                <td class="gcdcontentlnkhd"  style="padding-left: 3px;"><%= properties.get("BusinessAddress1",langText.get("Business Address 1"))%>
                                </td>
                                <td class="gcdcontentlnkhd" style="width: 185px;"><%= expandedSearchResult.getBusL1Ad().toUpperCase() %>
                                </td>
                                </tr>                       
                                <%
                                sdeviceid = "";
                                if (expandedSearchResult.getDeviceID2()>0)                                                 
                                   {
                                    deviceid = expandedSearchResult.getDeviceID2(); 
                                    Numberlength = expandedSearchResult.getDeviceNumber2().length();
                                    Countrycd = expandedSearchResult.getCtryCd().toUpperCase();
                                     
                                     if ((Countrycd.equals("US")) && (Numberlength==10))
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber2();
                                        sdeviceid = "(" + sdeviceid.substring(0, 3) + ") " + sdeviceid.substring(3,6) + "-" + sdeviceid.substring(6);
                                      } 
                       
                                     else 
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber2();
                                      }
                                      
                                    DisplayLabel = expandedSearchResult.getDeviceDescr2();
                                    if (deviceid==1) 
                                        {
                                           if(Officephone.length()==0)  Officephone = sdeviceid ;
                                        }
                                        }                                 
                                else {
                                  DisplayLabel="Phone 2";
                                     }                                                                   
                                %>
        
                                <tr>
                                <td class="gcdcontentlnkhd" ><%= DisplayLabel %> 
                                </td>
                                <td class="gcdcontentlnkhd"><%= (StringUtils.nullToEmptyString(sdeviceid)) %></td>  
                                <td class="gcdcontentlnkhd" style="padding-left: 3px;" ><%= properties.get("BusinessAddress2",langText.get("Business Address 2"))%> 
                                </td>
                                <td class="gcdcontentlnkhd"style="width: 185px;" ><%= expandedSearchResult.getBusL2Ad().toUpperCase() %>
                                </td>
                                </tr>
        
                                <%-- US Cell Number, Business City --%>
                                <%-- Device 3 Lable/number --%>
                                
                                <%--deviceid=  expandedSearchResult.getDeviceID3(); --%>
                                <%
                                sdeviceid = "";
                                if (expandedSearchResult.getDeviceID3()>0)                                             
                                   {
                                    deviceid = expandedSearchResult.getDeviceID3();
                                    Numberlength = expandedSearchResult.getDeviceNumber3().length();
                                    Countrycd = expandedSearchResult.getCtryCd().toUpperCase();    
                                    
                                     if ((Countrycd.equals("US")) && (Numberlength==10))
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber3();
                                        sdeviceid = "(" + sdeviceid.substring(0, 3) + ") " + sdeviceid.substring(3,6) + "-" + sdeviceid.substring(6);
                                      }  
                                      else
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber3();
                                      }
                                      
                                    DisplayLabel = expandedSearchResult.getDeviceDescr3();
                                      if (deviceid==1) 
                                        {
                                           if(Officephone.length()==0)  Officephone = sdeviceid ;
                                        }
                                        }                               
                                  else {
                                  DisplayLabel="Phone 3";
                                        }                                                                   
                                                    
                                %>
                                <tr>
                                <td class="gcdcontentlnkhd"><%= DisplayLabel %> 
                                </td>
                                <td class="gcdcontentlnkhd"><%= (StringUtils.nullToEmptyString(sdeviceid)) %>
                                </td>
                                <td class="gcdcontentlnkhd"  style="padding-left: 3px;"><%= properties.get("BusinessCity",langText.get("Business City"))%>
                                </td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getBusCityAd().toUpperCase() %>
                                </td>
                                </tr>
                                <%-- Us Fax Number, Business State --%>
                                <%-- Device 4 Lable/number --%>
                                <%--deviceid=  expandedSearchResult.getDeviceID4(); --%>
                                <%
                                
                                sdeviceid = "";
                                if (expandedSearchResult.getDeviceID4()>0)
                                   {
                                     deviceid = expandedSearchResult.getDeviceID4();
                                     Numberlength = expandedSearchResult.getDeviceNumber4().length();
                                     Countrycd = expandedSearchResult.getCtryCd().toUpperCase();    
                                    
                                     if ((Countrycd.equals("US")) && (Numberlength==10))
                                      { 
                                        sdeviceid = expandedSearchResult.getDeviceNumber4();
                                        sdeviceid = "(" + sdeviceid.substring(0, 3) + ") " + sdeviceid.substring(3,6) + "-" + sdeviceid.substring(6);
                                      } 
                                      else
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber4();
                                      }
                                      
                                    DisplayLabel = expandedSearchResult.getDeviceDescr4();
                                      if (deviceid==1) 
                                        {
                                           if(Officephone.length()==0)  Officephone = sdeviceid ;
                                        }
                                        }                           
                                else {
                                  DisplayLabel="Phone 4";
                                     }
        
                                %>
                                
                                <tr>
                                <td class="gcdcontentlnkhd"><%= DisplayLabel %> 
                                </td>
                                <td class="gcdcontentlnkhd"><%= (StringUtils.nullToEmptyString(sdeviceid)) %>
                                </td>
                                <td class="gcdcontentlnkhd"  style="padding-left: 3px;"><%= properties.get("BusinessState",langText.get("Business State"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getBusAbbrStAd().toUpperCase() %>
                                </td>
                                </tr>
                                <%-- International Office Phone, Business Post Code --%>
                                <%-- Device 5 Lable/number --%>
                                <%-- deviceid=  expandedSearchResult.getDeviceID5(); --%>
                                <%
                                
                                sdeviceid = "";
                                if (expandedSearchResult.getDeviceID5()>0)
                                   {    
                                     deviceid = expandedSearchResult.getDeviceID5();
                                     Numberlength = expandedSearchResult.getDeviceNumber5().length();
                                     Countrycd = expandedSearchResult.getCtryCd().toUpperCase();                             
                                                                
                                     if ((Countrycd.equals("US")) && (Numberlength==10))
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber5();
                                        sdeviceid = "(" + sdeviceid.substring(0, 3) + ") " + sdeviceid.substring(3,6) + "-" + sdeviceid.substring(6);
                                      }                   
                                     else
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber5();
                                      }
        
                                    DisplayLabel = expandedSearchResult.getDeviceDescr5();
                                    
                                     if (deviceid==1) 
                                        {
                                    
                                           if(Officephone.length()==0)  Officephone = sdeviceid ;
                                        }
                                     }                           
                                else {
                                      DisplayLabel="Phone 5";
                                     }        
                                
                                %>
                              
                                <tr>
                                <td class="gcdcontentlnkhd"><%= DisplayLabel %> 
                                </td>
                                <td class="gcdcontentlnkhd"><%=(StringUtils.nullToEmptyString(sdeviceid)) %>
                                </td>
                                <td class="gcdcontentlnkhd"  style="padding-left: 3px;"><%= properties.get("BusinessPostCode",langText.get("Business Post Code"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getBusPstlCd() %>
                                </td>
                                </tr>
                            
                                <%
                                 
                                 sdeviceid = "";                      
                                 if (expandedSearchResult.getDeviceID6()>0)
                                   {    
                                    deviceid = expandedSearchResult.getDeviceID5();
                                    Numberlength = expandedSearchResult.getDeviceNumber6().length();
                                     Countrycd = expandedSearchResult.getCtryCd().toUpperCase();
                                     if ((Countrycd.equals("US")) && (Numberlength==10))
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber6();
                                        sdeviceid = "(" + sdeviceid.substring(0, 3) + ") " + sdeviceid.substring(3,6) + "-" + sdeviceid.substring(6);
                                      } 
                                     else
                                      {
                                        sdeviceid = expandedSearchResult.getDeviceNumber6();
                                       
                                      }
                                                               
                                    DisplayLabel = expandedSearchResult.getDeviceDescr6();
                                    
                                    if (deviceid==1) 
                                        {
                                           if(Officephone.length()==0)  Officephone = sdeviceid ;
                                        }
                                        }                           
                                else {
                                  DisplayLabel="Phone 6";
                                     }          
                                %>
                                
                                <tr>
                                <td class="gcdcontentlnkhd"><%= DisplayLabel %> 
                                </td>
                                <td class="gcdcontentlnkhd"><%= (StringUtils.nullToEmptyString(sdeviceid)) %>
                                </td>
                                <td class="gcdcontentlnkhd"  style="padding-left: 3px;"><%= properties.get("BusinessCountry",langText.get("Business Country"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getBusCtryNu().toUpperCase() %>
                                </td>
                                </tr>
                                <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd"></td> 
                                <td class="gcdcontentlnkhd"  style="padding-left: 3px;"><%= properties.get("OfficeFloor",langText.get("Office Floor"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getOffcFlr() %>
                                </td>
                                </tr>
        
                                <%-- VM Node, Office Wing --%>
                                <tr>
                                <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd"></td> 
                                <td class="gcdcontentlnkhd" style="padding-left: 3px;"><%= properties.get("VmNode",langText.get("Voice Mail Node"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getVmNodeNu() %>  </td>
                                </tr> 
                                
                                <tr>  
                                <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd"></td>                  
                                <td class="gcdcontentlnkhd"  style="padding-left: 3px;"><%= properties.get("OfficeWing",langText.get("Office Wing"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getOffcWing() %>
                                </td>
                                </tr>
                                <%-- Office Location Number --%>
                                 
                                <tr>
                                <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd" style="padding-left: 3px;" ><%= properties.get("OfficeNumber",langText.get("Office Location Number"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getOffcNu()%>
                                </td>
                                </tr>
                                <%-- Mail Box Number --%>
                                 
                                <tr>
                                 <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd" style="padding-left: 3px;" ><%= properties.get("VoiceMailBoxNumber",langText.get("Voice Mail Box Number"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getMailBoxNu() %>
                                </td>
                                </tr>
                                <%-- Preferred Mail Code --%>
                                
                                <tr>
                                 <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd" style="padding-left: 3px;" ><%= properties.get("PreferredMailCode",langText.get("Preferred Mail Code"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getPreferredMailCd() %>
                                </td>
                                </tr>
            
                                <%-- Reg Office Dept Number --%>
                                
                                <tr>
                                <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd"></td>
                                <td class="gcdcontentlnkhd" style="padding-left: 3px;" ><%= properties.get("RegOfficeDeptNumber",langText.get("Reg Office Dept Number"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getRegOffcDeptNu()%>
                                </td> 
                                </tr>   
                           
                                <%-- assistant info --%>
                                <tr>
                                <td class="gcdcontentlnkhd"><%= properties.get("AssistantLastName",langText.get("Assistant Last Name"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getAdmnLastNm().toUpperCase()%>
                                </td>
                               </tr>
                                <%-- Assistant First Name --%> 
                                
                                <tr>
                                <td class="gcdcontentlnkhd"><%= properties.get("AssistantFirstName",langText.get("Assistant First Name"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getAdmnFstNm().toUpperCase()%>
                                </td>
                                </tr>
            
                                <%-- Assistant Phone --%>
                                
                                <tr>
                                <td class="gcdcontentlnkhd"><%= properties.get("AssistantPhone",langText.get("Assistant Phone"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getAdmnOffcPhne()%></td>
                                
                                </tr>
            
                                <%-- Assistant Phone Ext --%>
                                <tr>
                                <td class="gcdcontentlnkhd"><%= properties.get("AssistantPhoneExt",langText.get("Assistant PhoneExt"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getAdmnOffcPhneExt()%></td>
                               
                                </tr>
                               
                                <%-- comments --%>       
                                <tr>
                                <td class="gcdcontentlnkhd"><%= properties.get("Comment",langText.get("Comment"))%></td>
                                <td class="gcdcontentlnkhd"><%= expandedSearchResult.getCmnt()%></td>
                                </tr>
                                  
                                </table>
                            <%
                            } 
                           %>     
                            <%-- show page links --%>
                            <table class="gcddata" width="100%" align="center" cellpadding="3" cellspacing="4" >
                            <%-- Exit and AdvanceSearchLink --%>
                            <tr>
                             <td align="left">
                             <%
                               if(returnPageLinkURL.equals(""))
                               {
                             %> &nbsp;
                                <a href="javascript:cancel()" class="contentlnk"><%= properties.get("ExitLinkLabel",langText.get("Cancel"))%></a>
                             <%
                                }
                                else
                                {
                              %> &nbsp;  
                                  <a href="<%= commonUtil.getValidURL(returnPageLinkURL) %>" class="contentlnk"><%= properties.get("ExitLinkLabel",langText.get("Cancel"))%></a>
                              <%
                                 }
                              %>
                            &nbsp;&nbsp;&nbsp;
                            <a href="<%= commonUtil.getValidURL(advanceSearchPath) %>" class="contentlnk"><%= properties.get("AdvanceSearchLinkLabel",langText.get("Advanced Search"))%></a>
                            </a>
                           <%
                             if(!Helppath.trim().equals(""))
                             {
                            %>
                             &nbsp;&nbsp;&nbsp 
                            <a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help2" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
                            <%
                            }
                            %>
                            &nbsp;&nbsp;&nbsp;                  
                            <%
                            if(loggedInEid.equalsIgnoreCase(eid))
                            {
                            %>
                            <a  class="contentlnk" target="_blank" href="<%=commonUtil.getValidURL(properties.get("updateProfLink",GCDConstants.UPDATE_PROFILE_MPPM_LINK))  %>" ><%= properties.get("updateProf",langText.get("Update Profile in Global Account Manager"))%> </a>
                            <%
                            }
                            %>
                            </td>
                            </tr>
                            <%
                            } 
                            %>  
                              </table>
                           </form>
                          </td>
                        </tr>
                       
                        </table>
                                </td>
                            </tr>
                </table>
                    </td>
                </tr>
            </table>
            </td>
            </tr>
        </table>
        </div>  
  <%    
    }
   if(eidProvided == true && showResult == false )       
    {
  %>
     <div class="errorMsg"><%= GCDConstants.ERROR_GCD_DATABASE_ERROR %></div>
  <%  
    }
  %>        
            
 
                  