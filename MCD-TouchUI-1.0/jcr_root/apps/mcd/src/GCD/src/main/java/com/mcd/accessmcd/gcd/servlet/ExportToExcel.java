 /* GCD Export To Excel
* Servlet to generate excel sheet for export to excel functionality
*
* HCL
*
*/

package com.mcd.accessmcd.gcd.servlet;

import com.mcd.accessmcd.gcd.constants.GCDConstants;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.jcr.api.SlingRepository;
import java.io.*;
import java.util.*;
import com.day.commons.datasource.poolservice.DataSourcePool; 
import javax.jcr.Session;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.apache.sling.api.resource.ResourceResolver;   
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;   
import org.apache.sling.runmode.RunMode;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.apache.sling.scripting.core.ScriptHelper;
import org.osgi.framework.BundleContext;
import org.osgi.service.component.ComponentContext;
import com.mcd.accessmcd.gcd.facade.*;
import com.mcd.accessmcd.gcd.bean.*;
import com.mcd.accessmcd.ace.manager.ACEManager;
import jxl.WorkbookSettings;
import jxl.Workbook;
import jxl.SheetSettings;
import jxl.write.WritableSheet;
import jxl.write.WritableFont;
import jxl.write.WritableCellFormat;
import jxl.write.WriteException;
import jxl.write.Label;
import jxl.write.WritableWorkbook;
import jxl.write.WritableHyperlink;
import jxl.format.Alignment;
import jxl.format.VerticalAlignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="GCD Export To Excel Servlet"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/gcd/exporttoexcel"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")

public class ExportToExcel extends SlingAllMethodsServlet {

    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(ExportToExcel.class);
         
    /** @scr.reference */
    private SlingRepository repository;
    private BundleContext bundleContext;
    
    /** @scr.reference */ 
    private JcrResourceResolverFactory resolverFactory;
    
    protected Session session = null;
    private ResourceResolver resourceResolver = null;
    
    /**
     * This method is called when the bundle for this service is deployed in the CRX.
     * @param context
     * @throws Exception
     */
    protected void activate(ComponentContext ctx) throws Exception
    {
        bundleContext = ctx.getBundleContext();
    }
    public String rejectCheck(String expression,String param){ 
    
    for (int i = 0; i < expression.length(); i++){
    String c = "" + expression.charAt(i);   
 
    param = param.replace(c,"");
    }
    return(param.trim());
    }

    /**
     * The doGet method of the servlet. <br>
     *
     * This method is called when a form has its tag value method equals to post.
     * 
     * @param request the request send by the client to the server
     * @param response the response send by the server to the client
     * @throws ServletException if an error occurred
     * @throws IOException if an error occurred
     */
    @Override
    public void doGet(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
            
            //PrintWriter out = response.getWriter();
            Session session =null;
            ServletOutputStream sos = null;
            FileInputStream fis = null;
            BufferedInputStream bis = null;
            ByteArrayOutputStream baos  = null;
            try{
                session = repository.loginAdministrative(null);
                resourceResolver = resolverFactory.getResourceResolver(session); 
                ScriptHelper sling = new ScriptHelper(bundleContext, null);
                
                BasicSearch basicSearch=null;       
                ArrayList searchResult = null;
                ArrayList<String> headers = new ArrayList<String>();     
                AdvancedSearch advancedSearch = null;
                BasicSearchResult basicSearchResult = null;
                int sizeQueryResult = 0;
                
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
                String headerVmNodeNu = "";
                String headerPreferredMailCode = "";
                String headerAssistantPhone = "";
                String headerDevice1 = "Device 1";
                String headerDevice2 = "Device 2";
                String headerDevice3 = "Device 3";
                String headerDevice4 = "Device 4";
                String headerDevice5=  "Device 5";
                String headerDevice6 = "Device 6"; 
                String regex= "/[-!$%&^<>*()_+@|~\"\'`=\\#{}\\[\\]:;?,.\\/]";
                
                headerName = (request.getParameter("headerName")!=null)?(request.getParameter("headerName")):"";
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
                headerVmNodeNu = (request.getParameter("headerVmNodeNu")!=null)?(request.getParameter("headerVmNodeNu")):"";
                headerPreferredMailCode = (request.getParameter("headerPreferredMailCode")!=null)?(request.getParameter("headerPreferredMailCode")):"";
                headerAssistantPhone = (request.getParameter("headerAssistantPhone")!=null)?(request.getParameter("headerAssistantPhone")):"";
                
                headers.add(headerName);    
                headers.add(headerDevice1);
                headers.add(headerDevice2);
                headers.add(headerDevice3);
                headers.add(headerDevice4);
                headers.add(headerDevice5);
                headers.add(headerDevice6);     
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
                headerVmNodeNu= "Voice Mail Node #";
                headers.add(headerVmNodeNu);
                headers.add(headerPreferredMailCode);
                headers.add(headerAssistantPhone);
                
                IGCDFacade iGCDFacade= new GCDFacadeImpl();
                
                if(request.getParameter(GCDConstants.FORMACTION)!=null){
                    requestedForm=request.getParameter(GCDConstants.FORMACTION);
                }
                
                if(GCDConstants.ADVANCED_SEARCH_FORM.equals(requestedForm)){
                    advancedSearch = new AdvancedSearch();
                    countryName = request.getParameter(GCDConstants.SEARCH_COUNTRY);
                    firstName = request.getParameter(GCDConstants.ADVANCED_SEARCH_FIRST_NAME);
                    firstName= rejectCheck(regex,firstName);
                    lastName = request.getParameter(GCDConstants.ADVANCED_SEARCH_LAST_NAME);
                    lastName= rejectCheck(regex,lastName);
                    mi = request.getParameter(GCDConstants.ADVANCED_SEARCH_MI);
                    
                    countryName = countryName != null && countryName.length() != 0 ? countryName.trim().toUpperCase() + "%" : "";
                    countryName = rejectCheck(regex,countryName);
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
                    
                    searchResult = iGCDFacade.getSearchResult(advancedSearch,sling);   
                }     
                else if(GCDConstants.BASIC_SEARCH_FORM.equals(requestedForm)){
                    // populate the Advanced Search object
                    basicSearch=new BasicSearch();
                    countryName=request.getParameter(GCDConstants.SEARCH_COUNTRY);
                    firstName=request.getParameter(GCDConstants.BASIC_SEARCH_FIRST_NAME);
                    firstName= rejectCheck(regex,firstName);
                    lastName=request.getParameter(GCDConstants.BASIC_SEARCH_LAST_NAME);
                    lastName= rejectCheck(regex,lastName);
                    countryName= countryName != null && countryName.length() != 0 ? countryName.trim().toUpperCase() + "%" : "";
                    countryName= rejectCheck(regex,countryName);
                    firstName = firstName != null && firstName.length() != 0 ? firstName.trim().toUpperCase() + "%" : "";
                    lastName = lastName != null && lastName.length() != 0 ? lastName.trim().toUpperCase() + "%" : "";
                    
                    basicSearch.setCountry(countryName);
                    basicSearch.setLastName(lastName);
                    basicSearch.setFirstName(firstName);
                    
                    searchResult = iGCDFacade.getSearchResult(basicSearch,sling);
                } 
                
                if (searchResult!=null && headers!=null){
                    sizeQueryResult = searchResult.size();
                }
                ACEManager aceManager = new ACEManager();
                String serverPath = aceManager.getServerFilesPath();
                String fileName = serverPath + Integer.toString(sizeQueryResult) +"_Records.xls";
                WorkbookSettings workbookSettings = new WorkbookSettings();
                File exportToExcelFile = new File(fileName);
                WritableWorkbook exportWorkbook = Workbook.createWorkbook(exportToExcelFile, workbookSettings);
                WritableSheet exportWorkbookSheet = exportWorkbook.createSheet("Results",0);
                
                writeResultsSheet(exportWorkbookSheet,headers,sizeQueryResult);                
                createResultsRow(exportWorkbookSheet,searchResult,sizeQueryResult);
                
                exportWorkbook.write();
                exportWorkbook.close();
                   
                fis = new FileInputStream(fileName);
                try{
                    bis = new BufferedInputStream(fis);
                    baos = new ByteArrayOutputStream();
                    
                    int c = bis.read();
                    while (c != -1) {
                        baos.write(c);
                        c = bis.read();
                    }          
                }finally{
                    if(bis != null){
                        bis.close();
                        bis = null;
                    }           
                } 
                sos = response.getOutputStream(); 
                response.setContentType("application/xls");
                response.setHeader("Content-Disposition", "attachment; filename=Results.xls");
                sos.write(baos.toByteArray());
                sos.flush();
                
                if(exportToExcelFile.exists())
                    exportToExcelFile.delete();
                
            }   
            catch(Exception ex){
                log.error("******* Exception Occured in Export to Excel Servlet",ex);
            }
            finally{
                if(session!=null)session.logout();
                
                if(fis != null){
                    fis.close();    
                }
                if(baos != null){
                    baos.flush();  
                }
                if(bis != null){
                    bis.close();
                }
                if(sos != null){
                    sos.close();
                }
            }
    }
    
    private void writeResultsSheet(WritableSheet sheet, ArrayList<String> headers,int sizeQueryResult) throws WriteException,Exception{
  
        try
        {
            // Format the Font setDefaultColumnWidth 
            SheetSettings sheetSettings = new SheetSettings(sheet);
            sheetSettings.setDefaultColumnWidth(10000);
            
            WritableFont headingWritableFont = new WritableFont(WritableFont.ARIAL,9,WritableFont.BOLD);
            WritableCellFormat cellFormat = new WritableCellFormat(headingWritableFont);
            cellFormat.setWrap(true);
            cellFormat.setAlignment(Alignment.LEFT);
            cellFormat.setVerticalAlignment(VerticalAlignment.TOP);
            cellFormat.setShrinkToFit(true);
            cellFormat.setBorder(Border.ALL,BorderLineStyle.THIN);
                
            String totalRecords = Integer.toString(sizeQueryResult) + " record(s) found";
            Label totalRecordLabel = new Label(0,0,totalRecords,cellFormat);
            sheet.addCell(totalRecordLabel);
            
            cellFormat = new WritableCellFormat(headingWritableFont);
            cellFormat.setWrap(true);
            cellFormat.setAlignment(Alignment.LEFT);
            cellFormat.setVerticalAlignment(VerticalAlignment.TOP);
            cellFormat.setShrinkToFit(true);
            cellFormat.setBorder(Border.ALL,BorderLineStyle.THIN);
            cellFormat.setBackground(Colour.GRAY_25);            
                             
            int count = 0;
            if(sizeQueryResult > 0 ){
                Iterator headersItr = headers.iterator();
                while(headersItr.hasNext()){
                    String headerName = (String)headersItr.next();
                    Label label = new Label(count,1,headerName,cellFormat);
                    sheet.addCell(label);
                    sheet.setColumnView(count,20000);
                    count++;
                }
            }
            
        }
        catch(WriteException e){
            log.error("******* Exception Occured in Export to Excel Servlet writeResultsSheet Method",e);
        }
        catch(Exception ex){
            log.error("******* Exception Occured in Export to Excel Servlet writeResultsSheet Method",ex);
        }       

    } 
    
    public void createResultsRow(WritableSheet sheet, ArrayList searchResult,int sizeQueryResult){           
        try
        {
            WritableFont writableFont = new WritableFont(WritableFont.ARIAL,9, WritableFont.NO_BOLD);
            WritableCellFormat cellFormat = new WritableCellFormat(writableFont);
            cellFormat.setWrap(true);
            cellFormat.setAlignment(Alignment.LEFT);
            cellFormat.setVerticalAlignment(VerticalAlignment.TOP);
            cellFormat.setShrinkToFit(true);
            cellFormat.setBorder(Border.ALL,BorderLineStyle.THIN);
            
            if(sizeQueryResult > 0 ){
                for( int i=0; i<sizeQueryResult; i++ ){
                    BasicSearchResult basicSearchResult = (BasicSearchResult)searchResult.get(i);
                    int rowNumber = i + 2;
                    String lastName = basicSearchResult.getLastNm();
                    String firstName = "";
                    if(basicSearchResult.getFstNaAlias().length() == 0){
                        firstName = basicSearchResult.getFstNm() + "  " + basicSearchResult.getMidInitNa();
                    }
                    else{
                        firstName = basicSearchResult.getFstNaAlias().toUpperCase() + "  " + basicSearchResult.getMidInitNa();
                    }
                    String name = lastName + ", " + firstName;
                    Label label = new Label(0,rowNumber,name,cellFormat);
                    sheet.addCell(label);
                    
                    int device1NumberLength = 0;
                    String device1Number = "";
                    String device1DisplayLabel = "";
                    if (basicSearchResult.getDeviceID1() >0){ 
                        device1NumberLength = basicSearchResult.getDeviceNumber1().length();
                        if (device1NumberLength == 10){
                            device1Number = basicSearchResult.getDeviceNumber1();             
                            device1Number = "(" + device1Number.substring(0, 3) + ") " + device1Number.substring(3,6) + "-" + device1Number.substring(6);
                        } 
                        else{
                            device1Number = basicSearchResult.getDeviceNumber1();
                        }    
                        switch (basicSearchResult.getDeviceID1())
                        {
                            case 1:     device1DisplayLabel =  "Bus Phone: "; break;
                            case 2:     device1DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                            case 5:     device1DisplayLabel =  "Bus Fax: "; break;
                            case 6:     device1DisplayLabel =  "Other: "; break;        
                            default:    device1DisplayLabel =  "Invalid deviceid";break;
                        }                                                                                             
                    }
                    String device1Value = device1DisplayLabel + device1Number;
                    label = new Label(1,rowNumber,device1Value,cellFormat);
                    sheet.addCell(label);
                    
                    int device2NumberLength = 0;
                    String device2Number = "";
                    String device2DisplayLabel = "";
                    if (basicSearchResult.getDeviceID2() >0){ 
                        device2NumberLength = basicSearchResult.getDeviceNumber2().length();
                        if (device2NumberLength == 10){
                            device2Number = basicSearchResult.getDeviceNumber2();             
                            device2Number = "(" + device2Number.substring(0, 3) + ") " + device2Number.substring(3,6) + "-" + device2Number.substring(6);
                        } 
                        else{
                            device2Number = basicSearchResult.getDeviceNumber2();
                        }    
                        switch (basicSearchResult.getDeviceID2())
                        {
                            case 1:     device2DisplayLabel =  "Bus Phone: "; break;
                            case 2:     device2DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                            case 5:     device2DisplayLabel =  "Bus Fax: "; break;
                            case 6:     device2DisplayLabel =  "Other: "; break;        
                            default:    device2DisplayLabel =  "Invalid deviceid";break;
                        }                                                                                             
                    }
                    String device2Value = device2DisplayLabel + device2Number;
                    label = new Label(2,rowNumber,device2Value,cellFormat);
                    sheet.addCell(label);
                    
                    int device3NumberLength = 0;
                    String device3Number = "";
                    String device3DisplayLabel = "";
                    if (basicSearchResult.getDeviceID3() >0){ 
                        device3NumberLength = basicSearchResult.getDeviceNumber3().length();
                        if (device3NumberLength == 10){
                            device3Number = basicSearchResult.getDeviceNumber3();             
                            device3Number = "(" + device3Number.substring(0, 3) + ") " + device3Number.substring(3,6) + "-" + device3Number.substring(6);
                        } 
                        else{
                            device3Number = basicSearchResult.getDeviceNumber3();
                        }    
                        switch (basicSearchResult.getDeviceID3())
                        {
                            case 1:     device3DisplayLabel =  "Bus Phone: "; break;
                            case 2:     device3DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                            case 5:     device3DisplayLabel =  "Bus Fax: "; break;
                            case 6:     device3DisplayLabel =  "Other: "; break;        
                            default:    device3DisplayLabel =  "Invalid deviceid";break;
                        }                                                                                             
                    }
                    String device3Value = device3DisplayLabel + device3Number;
                    label = new Label(3,rowNumber,device3Value,cellFormat);
                    sheet.addCell(label);
                    
                    int device4NumberLength = 0;
                    String device4Number = "";
                    String device4DisplayLabel = "";
                    if (basicSearchResult.getDeviceID4() >0){ 
                        device4NumberLength = basicSearchResult.getDeviceNumber4().length();
                        if (device4NumberLength == 10){
                            device4Number = basicSearchResult.getDeviceNumber4();             
                            device4Number = "(" + device4Number.substring(0, 3) + ") " + device4Number.substring(3,6) + "-" + device4Number.substring(6);
                        } 
                        else{
                            device4Number = basicSearchResult.getDeviceNumber4();
                        }    
                        switch (basicSearchResult.getDeviceID4())
                        {
                            case 1:     device4DisplayLabel =  "Bus Phone: "; break;
                            case 2:     device4DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                            case 5:     device4DisplayLabel =  "Bus Fax: "; break;
                            case 6:     device4DisplayLabel =  "Other: "; break;        
                            default:    device4DisplayLabel =  "Invalid deviceid";break;
                        }                                                                                             
                    }
                    String device4Value = device4DisplayLabel + device4Number;
                    label = new Label(4,rowNumber,device4Value,cellFormat);
                    sheet.addCell(label);
                    
                    int device5NumberLength = 0;
                    String device5Number = "";
                    String device5DisplayLabel = "";
                    if (basicSearchResult.getDeviceID5() >0){ 
                        device5NumberLength = basicSearchResult.getDeviceNumber5().length();
                        if (device5NumberLength == 10){
                            device5Number = basicSearchResult.getDeviceNumber5();             
                            device5Number = "(" + device5Number.substring(0, 3) + ") " + device5Number.substring(3,6) + "-" + device5Number.substring(6);
                        } 
                        else{
                            device5Number = basicSearchResult.getDeviceNumber5();
                        }    
                        switch (basicSearchResult.getDeviceID5())
                        {
                            case 1:     device5DisplayLabel =  "Bus Phone: "; break;
                            case 2:     device5DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                            case 5:     device5DisplayLabel =  "Bus Fax: "; break;
                            case 6:     device5DisplayLabel =  "Other: "; break;        
                            default:    device5DisplayLabel =  "Invalid deviceid";break;
                        }                                                                                             
                    }
                    String device5Value = device5DisplayLabel + device5Number;
                    label = new Label(5,rowNumber,device5Value,cellFormat);
                    sheet.addCell(label);
                    
                    int device6NumberLength = 0;
                    String device6Number = "";
                    String device6DisplayLabel = "";
                    if (basicSearchResult.getDeviceID6() >0){ 
                        device6NumberLength = basicSearchResult.getDeviceNumber6().length();
                        if (device6NumberLength == 10){
                            device6Number = basicSearchResult.getDeviceNumber6();             
                            device6Number = "(" + device6Number.substring(0, 3) + ") " + device6Number.substring(3,6) + "-" + device6Number.substring(6);
                        } 
                        else{
                            device6Number = basicSearchResult.getDeviceNumber6();
                        }    
                        switch (basicSearchResult.getDeviceID6())
                        {
                            case 1:     device6DisplayLabel =  "Bus Phone: "; break;
                            case 2:     device6DisplayLabel =  "Bus Cell/Txt Msg: "; break;            
                            case 5:     device6DisplayLabel =  "Bus Fax: "; break;
                            case 6:     device6DisplayLabel =  "Other: "; break;        
                            default:    device6DisplayLabel =  "Invalid deviceid";break;
                        }                                                                                             
                    }
                    String device6Value = device6DisplayLabel + device6Number;
                    label = new Label(6,rowNumber,device6Value,cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(7,rowNumber,basicSearchResult.getBldgNa().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    String departmentName = "";
                    if( basicSearchResult.getDeptNu().length() != 0 && basicSearchResult.getDeptNa().length() != 0 ){
                        departmentName = basicSearchResult.getDeptNu() + "-" + basicSearchResult.getDeptNa().toUpperCase();
                    }
                    else{
                        departmentName = basicSearchResult.getDeptNu() + basicSearchResult.getDeptNa().toUpperCase();
                    }
                    label = new Label(8,rowNumber,departmentName,cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(9,rowNumber,basicSearchResult.getJobTitlDs().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(10,rowNumber,basicSearchResult.getEmail().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(11,rowNumber,basicSearchResult.getFstNm().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(12,rowNumber,basicSearchResult.getMidInitNa().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(13,rowNumber,basicSearchResult.getLastNm().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(14,rowNumber,basicSearchResult.getBusL1Ad().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(15,rowNumber,basicSearchResult.getBusL2Ad().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(16,rowNumber,basicSearchResult.getBusCityAd().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(17,rowNumber,basicSearchResult.getBusAbbrStAd().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(18,rowNumber,basicSearchResult.getBusPstlCd().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(19,rowNumber,basicSearchResult.getDeptNu(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(20,rowNumber,basicSearchResult.getMailBoxNu(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(21,rowNumber, basicSearchResult.getMailCd().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(22,rowNumber,basicSearchResult.getVmNodeNu().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(23,rowNumber,basicSearchResult.getPrefMailCd().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                    
                    label = new Label(24,rowNumber,basicSearchResult.getAdminOffcPhne().toUpperCase(),cellFormat);
                    sheet.addCell(label);
                }
            }
        }
        catch(Exception e){
            log.error("******* Exception Occured in Export to Excel Servlet createResultsRow Method",e);
        }
    }
} 