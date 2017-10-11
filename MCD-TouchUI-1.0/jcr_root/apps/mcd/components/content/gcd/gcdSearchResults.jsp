<%-- ########################################### 
 # DESCRIPTION: This is the  Search Result component which will bring out the result based on the type of Search action being performed.
 # Author: Nitin Sharma
 # Environment: 
  
 ##############################################--%>
   
       
<%@ page session="false" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.BasicSearchResult" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.AdvancedSearch" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.BasicSearch" %>
<%@ page import="com.mcd.accessmcd.gcd.dao.UserProfileDAO" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.GCDConstants,com.mcd.accessmcd.util.CommonUtil" %>
<%@ page import="com.mcdexchange.nl.*"%>
<%@ page import="com.mcd.accessmcd.common.helper.PropertyHelper"%>
 <%@ page import="com.day.cq.i18n.I18n"%>
 
       

<%
    ArrayList searchResult=new ArrayList(); 
    BasicSearch basicSearch=null;        
    AdvancedSearch advancedSearch=null;
    BasicSearchResult basicSearchResult=null; 
    int sizeQueryResult=0;
    String infoText="";   
    CommonUtil commonUtil = new CommonUtil();  
   // TranslationUtil translationutil = new TranslationUtil();        
    String helpLink="";
    String helpHeight="";
    String helpWidth="";
    String iframeBorder="";
    String iframeScroll="";
    HttpSession session=request.getSession(true);
    boolean australia_flag=false;
    
    String formAction = "";
    String requestedForm = ""; 
    String countryName = "";
    String firstName = "";
    String lastName = "";
    String mi = "";
    String countryNameUpd = "";
    String firstNameUpd = "";
    String lastNameUpd = "";
    String miUpd = "";
    String departmentName = "";
    String departmentNumber = "";
    String state = "";
    String companyName = "";
    String jobTitle = "";
    String regionName = "";
    String regionCode = "";
    String regioncodedescvalue = "";
    String prefMailCode = "";
    String vmNodeNu = "";
    String buildingName = "";
    String phoneNuExt = "";
    String phoneNumber = "";
    
    String headerName ="" ;
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
    String link1URL="";
    String link1Name="";
    String link2URL="";
    String link2Name="";
    String link3URL="";
    String link3Name=""; 
    String profileLink="";
    //SSV added to display 6 devices.
    String headerdevice1 ="";
    String headerdevice2="";
    String headerdevice3="";
    String headerdevice4="";
    String headerdevice5="";
    String headerdevice6="";
    
    
    String Helppath = properties.get("helpPath","");
       
       
    //Newly added field for searching
    String enterdeptname = "";
    String enterdeptnameUpd = ""; 
    String SelectedDept = ""; 
    String SelectedDeptUpd = "";    
    int temp1 = 0;
    try{
       
        link1URL= properties.get("link1URL","").toString();
        if(link1URL.startsWith("/content")){
            link1URL=link1URL+".html";
        }
        link1Name= properties.get("link1Name","").toString();
        link2URL= properties.get("link2URL","").toString();
        if(link2URL.startsWith("/content")){
            link2URL=link2URL+".html";
        }     
        link2Name= properties.get("link2Name",langText.get("Advanced Search"));
        link3URL= properties.get("link3URL","").toString();
        if(link3URL.startsWith("/content")){
            link3URL=link3URL+".html";
        }
        link3Name=properties.get("link3Name",langText.get("Export To Excel"));
             
        profileLink=properties.get("profileLink","");
        // get header values from the dialog and set it to the respective variables
     
        headerName =langText.get("Name");      
        headerOfficePhone = langText.get("Office Phone"); 
        headerOfficeLocation = langText.get("Office / Location"); 
        headerDepartment = langText.get("Department"); 
        headerTitle = langText.get("Title");
        headerEmail = langText.get("Email");
        headerFirstName = langText.get("First Name");
        headerMi = langText.get("MI");
        headerLastName = langText.get("Last Name");
        headerAddress1 = langText.get("Address 1");
        headerAddress2 = langText.get("Address 2");       
        headerCity = langText.get("City");
        headerState = langText.get("State");
        headerPostalCode = langText.get("Postal Code");
        headerDepartmentNum = langText.get("Department Num");
   
        //SSV modified E7
        headerMailBoxNu = langText.get("Mail Box #");
        //SSV End E7
        
        headerMailCode = langText.get("Mail Code");
        headerUsOfficeCell = langText.get("Us Office Cell");
        
        //SSV modified E8
       
        headerVmNodeNu = langText.get("Voice Mail Node #");
        //SSV end E8
        
        headerPreferredMailCode = langText.get("Preferred Mail Code");
        headerAssistantPhone = langText.get("Assistant Phone");
        headerdevice1 = langText.get("Device1");
        headerdevice2 = langText.get("Device2");
        headerdevice3 = langText.get("Device3");
        headerdevice4 = langText.get("Device4");
        headerdevice5 = langText.get("Device5");
        headerdevice6 = langText.get("Device6");

        // get GCDFacadeImpl Object
       
        IGCDFacade iGCDFacade= new GCDFacadeImpl();
      
        //log.error("displaying value for FormAction" + " " + GCDConstants.FORMACTION);     
        if(request.getParameter(GCDConstants.FORMACTION)!=null)
        {
            requestedForm=request.getParameter(GCDConstants.FORMACTION);   
        }                
          
        if(GCDConstants.ADVANCED_SEARCH_FORM.equals(requestedForm))
        {
        
          log.error("For Advance Searchss");
           
            advancedSearch=new AdvancedSearch();
            
            if(request.getParameter(GCDConstants.SEARCH_COUNTRY)!=null){
                countryName=request.getParameter(GCDConstants.SEARCH_COUNTRY);
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_FIRST_NAME)!=null){ 
               firstName=request.getParameter(GCDConstants.ADVANCED_SEARCH_FIRST_NAME);
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_LAST_NAME)!=null){    
                lastName=request.getParameter(GCDConstants.ADVANCED_SEARCH_LAST_NAME);
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_MI)!=null){    
                mi=request.getParameter(GCDConstants.ADVANCED_SEARCH_MI);
            }    
                       
            countryNameUpd = countryName != null && countryName.length() != 0 ? countryName.trim().toUpperCase() + "%" : "";
            firstNameUpd = firstName != null && firstName.length() != 0 ? firstName.trim().toUpperCase() + "%" : "";
            lastNameUpd = lastName != null && lastName.length() != 0 ? lastName.trim().toUpperCase() + "%" : "";
            miUpd=mi != null && mi.length() != 0 ? mi.trim().toUpperCase() + "%" : "";          
           
            /*if ((request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME)!=null) && (request.getParameter(GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME)!=null)){                   
                if(request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME)!=null){
                    SelectedDept=request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME).toUpperCase();
                    SelectedDeptUpd = SelectedDept != null && SelectedDept.length() != 0 ? SelectedDept.trim().toUpperCase() + "%" : "";
                }      
            }  
            else{
                if (request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME)!=null){
                    SelectedDept =  request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME).toUpperCase();
                    SelectedDeptUpd = SelectedDept != null && SelectedDept.length() != 0 ? SelectedDept.trim().toUpperCase() + "%" : "";
                }     
                else{ 
                    if(request.getParameter(GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME)!=null){
                        log.error("***************************2");
                        SelectedDept =  request.getParameter(GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME).toUpperCase();
                        SelectedDeptUpd = SelectedDept != null && SelectedDept.length() != 0 ? "%" + SelectedDept.trim().toUpperCase() + "%" : "";            
                    }                            
                }     
            } */  
            
            if ((request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME ).length() !=0) && (request.getParameter(GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME).length() !=0)){                   
                SelectedDept=request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME).toUpperCase();
                SelectedDeptUpd = SelectedDept != null && SelectedDept.length() != 0 ? SelectedDept.trim().toUpperCase() + "%" : "";
            } 
            else{
                if (request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME).length() !=0){
                    SelectedDept =  request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME).toUpperCase();
                    SelectedDeptUpd = SelectedDept != null && SelectedDept.length() != 0 ? SelectedDept.trim().toUpperCase() + "%" : "";
                }
                else{
                    SelectedDept =  request.getParameter(GCDConstants.ADVANCED_SEARCH_NEWDEPT_NAME).toUpperCase();
                    SelectedDeptUpd = SelectedDept != null && SelectedDept.length() != 0 ? "%" + SelectedDept.trim().toUpperCase() + "%" : "";
                }     
            }  
            
            departmentName = SelectedDeptUpd;  
            log.error("***************************" + departmentName );
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER)!=null){
                departmentNumber = request.getParameter(GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER).toUpperCase();
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_STATE)!=null){    
                state = request.getParameter(GCDConstants.ADVANCED_SEARCH_STATE).toUpperCase();
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_COMPANY_NAME)!=null){    
                companyName = request.getParameter(GCDConstants.ADVANCED_SEARCH_COMPANY_NAME).toUpperCase();
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_JOB_TITLE)!=null){
                jobTitle = request.getParameter(GCDConstants.ADVANCED_SEARCH_JOB_TITLE).toUpperCase();
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_NAME)!=null){    
                regionName = request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_NAME).toUpperCase();
            }     
           
            int regioncodedesc = request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_CODE).length();
            if (regioncodedesc > 0 ){                       
                regionCode = request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_CODE).substring(0,2).toUpperCase();
            }   
            else{    
              regionCode = request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_CODE).toUpperCase(); 
            }
            
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE)!=null){   
                prefMailCode = request.getParameter(GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE).toUpperCase();
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_VM_NODE_NU)!=null){    
                vmNodeNu = request.getParameter(GCDConstants.ADVANCED_SEARCH_VM_NODE_NU).toUpperCase();
            }

            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_BUILDING_NAME)!=null){
                 buildingName = request.getParameter(GCDConstants.ADVANCED_SEARCH_BUILDING_NAME);
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT)!=null){
                phoneNuExt = request.getParameter(GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT);
            }
            if(request.getParameter(GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER)!=null){    
                phoneNumber = request.getParameter(GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER);
            }
                       
            advancedSearch.setCountry(countryNameUpd);
            advancedSearch.setLastName(lastNameUpd);
            advancedSearch.setFirstName(firstNameUpd);
            advancedSearch.setMi(miUpd);
            advancedSearch.setDepartment(SelectedDeptUpd);
          
            advancedSearch.setDepartmentNumber(departmentNumber);
            advancedSearch.setState(state);
            advancedSearch.setCompanyName(companyName);
            advancedSearch.setJobTitle(jobTitle);
            advancedSearch.setRegNa(regionName); 
               
            if (regioncodedesc > 0 ){
                advancedSearch.setRegCd(request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_CODE).toUpperCase().substring(0,2));
                advancedSearch.setRegCdDesc(request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_CODE).toUpperCase().substring(2,regioncodedesc));
                regioncodedescvalue = advancedSearch.getRegCdDesc();
            } 
            else{                 
                advancedSearch.setRegCd(request.getParameter(GCDConstants.ADVANCED_SEARCH_REGION_CODE).toUpperCase());
            }
            advancedSearch.setPrefMailCd(prefMailCode);
            advancedSearch.setVmNodeNu(vmNodeNu);
            advancedSearch.setBuildingNa(buildingName);
            advancedSearch.setPhoneNuExt(phoneNuExt.toUpperCase());
            advancedSearch.setPhoneNumber(phoneNumber);
            advancedSearch.setCountry(countryName.toUpperCase());
            advancedSearch.setZoneCd("");
            
             try {
                    searchResult = iGCDFacade.getSearchResult(advancedSearch,sling);  
             }
              catch(Exception e)
              {      
                temp1 =1;
                log.error("Error Retreiving results from Advance Search " + e.getMessage());
              }    
            formAction = GCDConstants.ADVANCED_SEARCH_FORM;
          
        } 
        else if(GCDConstants.BASIC_SEARCH_FORM.equals(requestedForm))
        {  
           // populate the Advanced Search object 
            basicSearch=new BasicSearch();
            if(request.getParameter(GCDConstants.SEARCH_COUNTRY)!=null){
                countryName=request.getParameter(GCDConstants.SEARCH_COUNTRY);
            }
            if(request.getParameter(GCDConstants.BASIC_SEARCH_FIRST_NAME)!=null){       
                firstName=request.getParameter(GCDConstants.BASIC_SEARCH_FIRST_NAME);  
            }
            if(request.getParameter(GCDConstants.BASIC_SEARCH_LAST_NAME)!=null){    
                lastName=request.getParameter(GCDConstants.BASIC_SEARCH_LAST_NAME); 
            }        
           countryNameUpd = countryName != null && countryName.length() != 0 ? countryName.trim().toUpperCase() + "%" : "";
            firstNameUpd = firstName != null && firstName.length() != 0 ? firstName.trim().toUpperCase() + "%" : "";
            lastNameUpd = lastName != null && lastName.length() != 0 ? lastName.trim().toUpperCase() + "%" : "";
                    
            basicSearch.setCountry(countryNameUpd);
            basicSearch.setLastName(lastNameUpd);
            basicSearch.setFirstName(firstNameUpd);
               
           try
           {    
            searchResult=iGCDFacade.getSearchResult(basicSearch,sling);
           }
           catch(Exception e)
           { 
             log.error("ERROR While Fetching results " + e.getMessage());
             temp1 =1;
           } 
            formAction = GCDConstants.BASIC_SEARCH_FORM;  
        }
        
        if(session.getAttribute(GCDConstants.HELP_LINK)!=null){
            helpLink=(String)session.getAttribute(GCDConstants.HELP_LINK); 
        }
        if(session.getAttribute(GCDConstants.HELP_HEIGHT)!=null){
            helpHeight=(String)session.getAttribute(GCDConstants.HELP_HEIGHT);
        }
        if(session.getAttribute(GCDConstants.HELP_WIDTH)!=null){
            helpWidth=(String)session.getAttribute(GCDConstants.HELP_WIDTH);
        }
        if(session.getAttribute(GCDConstants.HELP_IFRAMEBORDER)!=null){
            iframeBorder=(String)session.getAttribute(GCDConstants.HELP_IFRAMEBORDER);
        }
        if(session.getAttribute(GCDConstants.HELP_IFRAMESCROLL)!=null){
            iframeScroll=(String)session.getAttribute(GCDConstants.HELP_IFRAMESCROLL);
        }               
        if(searchResult!=null){
            sizeQueryResult = searchResult.size();
        }    
    }
    catch(Exception e){ 
    temp1=1;
    log.error("ERROR IN SEARCH RESULTS : " + e.getMessage());
       // infoText = translationutil.getTranslate(cqReq_Ticket, cqReq_Handle, "GCD_DATABASE_ERROR");
    } 
              
    boolean adminFlag = false;  
    boolean franchiseeFlag = false;  
    //String actionPath = resource.getPath()+".exporttoexcel.html?"+GCDConstants.FORMACTION+"="+formAction+"&"+GCDConstants.SEARCH_COUNTRY+"="+countryName+"&"+GCDConstants.BASIC_SEARCH_FIRST_NAME+"="+firstName+"&"+GCDConstants.BASIC_SEARCH_LAST_NAME+"="+lastName+"&"+GCDConstants.ADVANCED_SEARCH_FIRST_NAME+"="+firstName+"&"+GCDConstants.ADVANCED_SEARCH_LAST_NAME+"="+lastName+"&"+GCDConstants.ADVANCED_SEARCH_MI+"="+mi+"&"+GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME+"="+departmentName+"&"+GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER+"="+departmentNumber+"&"+GCDConstants.ADVANCED_SEARCH_STATE+"="+state+"&"+GCDConstants.ADVANCED_SEARCH_COMPANY_NAME+"="+companyName+"&"+GCDConstants.ADVANCED_SEARCH_JOB_TITLE+"="+jobTitle+"&"+GCDConstants.ADVANCED_SEARCH_REGION_NAME+"="+regionName+"&"+GCDConstants.ADVANCED_SEARCH_REGION_CODE+"="+regionCode+"&"+GCDConstants.ADVANCED_SEARCH_REGION_CODE_DESC+"="+regioncodedescvalue+"&"+GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE+"="+prefMailCode+"&"+GCDConstants.ADVANCED_SEARCH_VM_NODE_NU+"="+vmNodeNu+"&"+GCDConstants.ADVANCED_SEARCH_BUILDING_NAME+"="+buildingName+"&"+GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT+"="+phoneNuExt+"&"+GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER+"="+phoneNumber+"&headerName="+headerName+"&headerdevice1="+headerdevice1+"&headerdevice2="+headerdevice2+"&headerdevice3="+headerdevice3+"&headerdevice4="+headerdevice4+"&headerdevice5="+headerdevice5+"&headerdevice6="+headerdevice6+"&headerOfficeLocation="+headerOfficeLocation+"&headerDepartment="+headerDepartment+"&headerTitle="+headerTitle+"&headerEmail="+headerEmail+"&headerFirstName="+headerFirstName+"&headerMi="+headerMi+"&headerLastName="+headerLastName+"&headerAddress1="+headerAddress1+"&headerAddress2="+headerAddress2+"&headerCity="+headerCity+"&headerState="+headerState+"&headerPostalCode="+headerPostalCode+"&headerDepartmentNum="+headerDepartmentNum+"&headerMailBoxNu="+headerMailBoxNu+"&headerMailCode="+headerMailCode+"&headerVmNodeNu="+headerVmNodeNu+"&headerPreferredMailCode="+headerPreferredMailCode+"&headerAssistantPhone="+headerAssistantPhone;
    String actionPath = "/mcd/gcd/exporttoexcel?"+GCDConstants.FORMACTION+"="+formAction+"&"+GCDConstants.SEARCH_COUNTRY+"="+countryName+"&"+GCDConstants.BASIC_SEARCH_FIRST_NAME+"="+firstName+"&"+GCDConstants.BASIC_SEARCH_LAST_NAME+"="+lastName+"&"+GCDConstants.ADVANCED_SEARCH_FIRST_NAME+"="+firstName+"&"+GCDConstants.ADVANCED_SEARCH_LAST_NAME+"="+lastName+"&"+GCDConstants.ADVANCED_SEARCH_MI+"="+mi+"&"+GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME+"="+departmentName+"&"+GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER+"="+departmentNumber+"&"+GCDConstants.ADVANCED_SEARCH_STATE+"="+state+"&"+GCDConstants.ADVANCED_SEARCH_COMPANY_NAME+"="+companyName+"&"+GCDConstants.ADVANCED_SEARCH_JOB_TITLE+"="+jobTitle+"&"+GCDConstants.ADVANCED_SEARCH_REGION_NAME+"="+regionName+"&"+GCDConstants.ADVANCED_SEARCH_REGION_CODE+"="+regionCode+"&"+GCDConstants.ADVANCED_SEARCH_REGION_CODE_DESC+"="+regioncodedescvalue+"&"+GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE+"="+prefMailCode+"&"+GCDConstants.ADVANCED_SEARCH_VM_NODE_NU+"="+vmNodeNu+"&"+GCDConstants.ADVANCED_SEARCH_BUILDING_NAME+"="+buildingName+"&"+GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT+"="+phoneNuExt+"&"+GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER+"="+phoneNumber+"&headerName="+headerName+"&headerdevice1="+headerdevice1+"&headerdevice2="+headerdevice2+"&headerdevice3="+headerdevice3+"&headerdevice4="+headerdevice4+"&headerdevice5="+headerdevice5+"&headerdevice6="+headerdevice6+"&headerOfficeLocation="+headerOfficeLocation+"&headerDepartment="+headerDepartment+"&headerTitle="+headerTitle+"&headerEmail="+headerEmail+"&headerFirstName="+headerFirstName+"&headerMi="+headerMi+"&headerLastName="+headerLastName+"&headerAddress1="+headerAddress1+"&headerAddress2="+headerAddress2+"&headerCity="+headerCity+"&headerState="+headerState+"&headerPostalCode="+headerPostalCode+"&headerDepartmentNum="+headerDepartmentNum+"&headerMailBoxNu="+headerMailBoxNu+"&headerMailCode="+headerMailCode+"&headerVmNodeNu="+headerVmNodeNu+"&headerPreferredMailCode="+headerPreferredMailCode+"&headerAssistantPhone="+headerAssistantPhone;
    
    if(temp1 == 0) 
    {
%>        
          
        <form id="ExportToExcelFrm" method="get" action="<%= actionPath%>">            
                                      
            <input type="hidden" name="<%= GCDConstants.FORMACTION%>" value="<%=formAction %>" />   
            <input type="hidden" name="<%= GCDConstants.SEARCH_COUNTRY%>" value="<%=countryName %>" /> 
            <input type="hidden" name="<%= GCDConstants.BASIC_SEARCH_FIRST_NAME %>" value="<%=firstName %>" />
            <input type="hidden" name="<%= GCDConstants.BASIC_SEARCH_LAST_NAME %>" value="<%=lastName%>" /> 
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_FIRST_NAME %>" value="<%=firstName %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_LAST_NAME %>" value="<%=lastName%>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_MI %>" value="<%=mi %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NAME %>" value="<%=departmentName %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_DEPARTMENT_NUMBER %>" value="<%=departmentNumber %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_STATE %>" value="<%=state %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_COMPANY_NAME %>" value="<%=companyName%>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_JOB_TITLE%>" value="<%=jobTitle %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_REGION_NAME %>" value="<%=regionName%>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_REGION_CODE %>" value="<%=regionCode %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_REGION_CODE_DESC %>" value="<%=regioncodedescvalue %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_PREF_MAIL_CODE %>" value="<%=prefMailCode %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_VM_NODE_NU %>" value="<%=vmNodeNu %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_BUILDING_NAME %>" value="<%=buildingName %>" />
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_PHONE_NU_EXT %>" value="<%=phoneNuExt %>" /> 
            <input type="hidden" name="<%= GCDConstants.ADVANCED_SEARCH_PHONE_NUMBER %>" value="<%=phoneNumber %>" />  
                        
            <input type="hidden" name="headerName" value="<%=headerName %>" />
            <input type="hidden" name="headerdevice1" value="<%=headerdevice1 %>" />    
            <input type="hidden" name="headerdevice2" value="<%=headerdevice2 %>" />    
            <input type="hidden" name="headerdevice3" value="<%=headerdevice3 %>" />    
            <input type="hidden" name="headerdevice4" value="<%=headerdevice4 %>" />    
            <input type="hidden" name="headerdevice5" value="<%=headerdevice5 %>" />    
            <input type="hidden" name="headerdevice6" value="<%=headerdevice6 %>" />    
            
            <%--<input type="hidden" name="headerOfficePhone" value="<%=headerOfficePhone %>" />    --%>
            <input type="hidden" name="headerOfficeLocation" value="<%=headerOfficeLocation %>" />  
            <input type="hidden" name="headerDepartment" value="<%=headerDepartment %>" />  
            <input type="hidden" name="headerTitle" value="<%=headerTitle %>" />    
            <input type="hidden" name="headerEmail" value="<%=headerEmail %>" />    
            <input type="hidden" name="headerFirstName" value="<%=headerFirstName %>" />    
            <input type="hidden" name="headerMi" value="<%=headerMi %>" />  
            <input type="hidden" name="headerLastName" value="<%=headerLastName %>" />  
            <input type="hidden" name="headerAddress1" value="<%=headerAddress1 %>" />  
            <input type="hidden" name="headerAddress2" value="<%=headerAddress2 %>" />  
            <input type="hidden" name="headerCity" value="<%=headerCity %>" />  
            <input type="hidden" name="headerState" value="<%=headerState %>" />    
            <input type="hidden" name="headerPostalCode" value="<%=headerPostalCode %>" />  
            <input type="hidden" name="headerDepartmentNum" value="<%=headerDepartmentNum %>" />    
            <input type="hidden" name="headerMailBoxNu" value="<%=headerMailBoxNu %>" />    
            <input type="hidden" name="headerMailCode" value="<%=headerMailCode %>" />          
            <input type="hidden" name="headerVmNodeNu" value="<%=headerVmNodeNu %>" />  
            <input type="hidden" name="headerPreferredMailCode" value="<%=headerPreferredMailCode %>" />    
            <input type="hidden" name="headerAssistantPhone" value="<%=headerAssistantPhone %>" />      
                    
        </form>    
         
        <table width="100%" height="100%" cellpadding="0" cellspacing="5"> 
            
            <tr>
            <td> 
                
               <table width="100%" height="100%" cellpadding="0" cellspacing="0">
               <tr height="100%">
                <td width="100%" valign="top" class="gcdSkinBorder" style="padding:5px;" >
        
        
                    <table class="gcdcontentlnkhd" width="100%" cellpadding="0" cellspacing="0" >
                    <tr>
                    <td colspan="7">
                    <input type="hidden" name="<%= GCDConstants.FORMACTION %>" value="" />
                    </td>
                    </tr>
                    <td colspan="7">
                    
                    </td>
                    </tr>
            
                    <%-- link page URls --%>
                    <tr>
                    <td colspan="7">
            
                    <table width="100%"  cellpadding="0" cellspacing="0">  
        
        
                        <tr>
                        <td align="left">
                         <% if(link2URL!=""){%>
                        <a href="<%= link2URL%>" class="contentlnk" ><%= link2Name%></a> 
                        <%}%>
                                     
                        <%
                        if(sizeQueryResult>0){
                        %>
                        &nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="document.getElementById('ExportToExcelFrm').submit();" class="contentlnk"><%=link3Name%></a>                 
                        <%}%> 
                        
                         <%
                         if(!Helppath.trim().equals(""))
                         {
                         %>
                          &nbsp;&nbsp;&nbsp 
                          <a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help2" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
                         <%
                          }   
                         %> 
                        </td> 
                        </tr> 
                    </table>   
              
                    </td> 
                    </tr>
              
                    <tr height="10">
                    <td colspan="7">
                    </td>
                    </tr>   
                    <tr>
                    <td colspan="7"class="gcdcontentlnkhd"><b><%= infoText %></b></td>
                    </tr>
                    <tr>
            
                    <tr>
                    <td colspan="7"><b><%= sizeQueryResult %> record(s) found</b></td>
                    </tr>
                    <tr>
                    <td>&nbsp;</td>
                    </tr>
            
                    <%-- headers --%>
                    <% 
                    if( sizeQueryResult > 0 )
                    {
                    %>  
                    <tr class="tableheaders">
                    
                    <%-- Name --%>
                      <td style="white-space:nowrap;"><b><%= headerName%></b></td>
                 
                    <%-- Office Phone --%>
                      <td style="white-space:nowrap;"><b><%= headerOfficePhone%></b></td>
                    
                    <%-- Office / Location --%>
                      <td style=""><b><%= headerOfficeLocation%></b></td>
                    
                    <%-- Department --%>
                      <td style="width:100px;"><b><%= headerDepartment%></b></td>
                    
                    <%-- Job Title --%>
                      <td style=""><b><%= headerTitle%></b></td>
                    
                    <%-- Email --%>
                       <td style="border-right:1px solid;"><b><%= headerEmail%></b></td> 
                   
                    </tr>
                 <%
                  }
                 %> 
              
                   <%-- results --%>
                 <%
                   String tempCss = "";         
                   for( int i=0; i<sizeQueryResult; i++ )
                    {
                     basicSearchResult = (BasicSearchResult)searchResult.get(i);
                     if(i == (sizeQueryResult-1)){
                         tempCss = "border-bottom:1px solid;"; 
                     }
                     
                 %>
            
                    <%-- Full name of the user with the link --%> 
                   
                    <tr class ="trbg<%= i%2 %>">
                      <td  style="white-space:nowrap;<%=tempCss%>" height="5" >  
                     <%
                       if(!profileLink.equals(""))
                       {
                     %>  
                       <img height="10" src="/images/arrow_red_2.gif" width="10" border="0"/>  
                       <a href="<%= commonUtil.getValidURL(profileLink)%>?<%= GCDConstants.UPDATE_ADMIN_EID_TAG %>=<%=basicSearchResult.getEid() %>&<%= GCDConstants.OPER_ID_NU_TAG %>=<%=basicSearchResult.getOperIdNu() %>"
                        class="contentlnk" title="<%= basicSearchResult.getLastNm() + ", " + basicSearchResult.getFstNm() + " " + basicSearchResult.getMidInitNa() %>">
                         <%= basicSearchResult.getLastNm() %>, <%= ( basicSearchResult.getFstNaAlias().length() == 0 ) ? basicSearchResult.getFstNm() : "<i>"+basicSearchResult.getFstNaAlias().toUpperCase()+" &nbsp;</i>" %> <%= basicSearchResult.getMidInitNa() %>
                       </a> 
                     <%
                       }
                       else
                       {
                     %> 
                        <img height="10" src="/images/arrow_red_2.gif" width="10" border="0"/>  <%= basicSearchResult.getLastNm() %>, <%= ( basicSearchResult.getFstNaAlias().length() == 0 ) ? basicSearchResult.getFstNm() : "<i>"+basicSearchResult.getFstNaAlias().toUpperCase()+" &nbsp;</i>" %> <%= basicSearchResult.getMidInitNa() %>
                     <%
                       }
                     %>  
                      </td>
                        
                    <%-- Office Phone --%>
                  <% 
                      //String CtryCd = "";
                      //CtryCd =  StringUtils.nullToEmptyString(basicSearchResult.getCtryCd().toUpperCase());
                      //log.error("The value of i is: " + i);
                      String Businessphone = "";
                      int Numberlength=0;
                      Businessphone = StringUtils.nullToEmptyString(basicSearchResult.getBusinessPhone());
                      if (Businessphone.length() > 0) 
                          {
                            Numberlength = basicSearchResult.getBusinessPhone().length();
                            //log.error("Displaying the length from gcdsearch:" + Numberlength);
                            //if ((Countrycd.equals("US")) && (Numberlength==10))
                            if (Numberlength==10)
                            {
                             Businessphone = "(" + Businessphone.substring(0, 3) + ") " + Businessphone.substring(3,6) + "-" + Businessphone.substring(6);
                            } 
                           }            
                     
                   %>     
                    
                         
                     <td style="white-space:nowrap;<%=tempCss%>"><%= Businessphone %></td> 
                    
                     <%-- Office / Location --%>
                         
                     <td style="<%=tempCss%>"><%= basicSearchResult.getBldgNa().toUpperCase() %></td> 
        
                     <%-- Department --%>
                    
                   <%  
                    if( basicSearchResult.getDeptNu().length() != 0 && basicSearchResult.getDeptNa().length() != 0 )
                    {
                   %>      
                    
                     <td style="width:100px;<%=tempCss%>"><%= basicSearchResult.getDeptNu() %>-<%= basicSearchResult.getDeptNa().toUpperCase() %></td>
                   <% 
                    }
                   else
                    {
                   %>
                     <td style="width:100px;<%=tempCss%>"><%= basicSearchResult.getDeptNu() %><%= basicSearchResult.getDeptNa().toUpperCase() %></td>
                   <% 
                    }
                   %>
        
                    <%-- Job Title --%>
                    
                    <td style="<%=tempCss%>"><%= basicSearchResult.getJobTitlDs().toUpperCase() %></td>
                    
                    <%-- Email --%>
                    
                    <td style="border-right:1px solid;<%=tempCss%>"><%= basicSearchResult.getEmail().toUpperCase() %></td>
        
                    </tr>
                <%
                    //log.error("Displayed one record");
                 }
                %>
            
                    <tr>
                    <td colspan="7">
                    </td>
                    </tr>
        
                    <tr>
                    <td> &nbsp;</td>
                    </tr>     
                    <tr>
                    <td colspan="7">
                    
                    <%-- link page URls --%> 
            
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td align="left">
                        <% if(link2URL!=""){%>
                        <a href="<%= link2URL%>" class="contentlnk" ><%= link2Name%></a>            
                        <%}%>
                      
                        <%
                        if(sizeQueryResult>0){
                        %>
                        &nbsp;&nbsp;&nbsp;
                        <a href="#" onclick="document.getElementById('ExportToExcelFrm').submit();" class="contentlnk"><%=link3Name%></a>                 
                        <%}%>  
                       <%
                         if(!Helppath.trim().equals(""))
                         {
                        %>
                          &nbsp;&nbsp;&nbsp 
                          <a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help2" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
                         <%
                          }   
                         %>
                        </td>
                        </tr>  
                    </table>
            
                    </td>
                    </tr>   
        
                    </table>
                      
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
     %>          
             
  <script>
      $(document).ready(function() {
      $("td:empty").html("&nbsp;");
    });
  </script>
  
                  