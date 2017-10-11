 /* Component Report Export To Excel
* Servlet to generate excel sheet for export to excel functionality
*
* HCL
*
*/

package com.mcd.componentreport;


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
import javax.jcr.Node;
import javax.jcr.NodeIterator;
import com.day.cq.wcm.api.*;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.apache.sling.api.resource.ResourceResolver;   
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;   
import org.apache.sling.runmode.RunMode;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.apache.sling.scripting.core.ScriptHelper;
import org.osgi.framework.BundleContext;
import org.osgi.service.component.ComponentContext;
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
    @Property( name="service.description",value="Export To Excel Servlet"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/compreport/exporttoexcel"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")

public class ExportReportToExcel extends SlingAllMethodsServlet {

    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(ExportReportToExcel.class);
         
    @Reference
    private SlingRepository repository;

    private BundleContext bundleContext;
    
    @Reference 
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
    String childPagesList = "";

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
                PageManager pageManager = resourceResolver.adaptTo(PageManager.class);
                
                String pageReportPath = "";
                String includeChildPage = "";
                String pageReportType = "";
                String compPagePath = "";
                String compPath = "";
                String compReportType = "";
                if(null != request.getParameter("pagereportpath")){
                    pageReportPath = request.getParameter("pagereportpath");
                }
                
                if(null != request.getParameter("childpage")){
                    includeChildPage = request.getParameter("childpage");
                }
                
                if(null != request.getParameter("pagereporttype")){
                    pageReportType = request.getParameter("pagereporttype");
                }
                
                if(null != request.getParameter("comppagepath")){
                    compPagePath = request.getParameter("comppagepath");
                }
                
                if(null != request.getParameter("comppath")){
                    compPath = request.getParameter("comppath");
                }
                
                if(null != request.getParameter("compreporttype")){
                    compReportType = request.getParameter("compreporttype");
                }
                /*out.println("Page Path :: " + pagePath);
                out.println("Include Child :: " + includeChildPage);
                out.println("Report Type :: " + reportType);
                out.println("Comp Path :: " + compPath);*/
                
                
                 
                ACEManager aceManager = new ACEManager();
                String serverPath = aceManager.getServerFilesPath();
                Random randomGenerator = new Random();
                int randomInt = randomGenerator.nextInt(100);
                String fileName = serverPath + Integer.toString(randomInt) + "_ComponentReport.xls";
                WorkbookSettings workbookSettings = new WorkbookSettings();
                File exportToExcelFile = new File(fileName);
                WritableWorkbook exportWorkbook = Workbook.createWorkbook(exportToExcelFile, workbookSettings);
                WritableSheet exportWorkbookSheet = exportWorkbook.createSheet("Components Report",0);
                
                writeResultsSheet(exportWorkbookSheet);  
                if("page".equalsIgnoreCase(pageReportType)){
                    log.error("******* Page Path ******* " + pageReportPath);
                    log.error("******* Include Child ******* " + includeChildPage);
                    log.error("******** Report Type ******** " + pageReportType);
                    
                    createResultsRow(exportWorkbookSheet,pageReportPath,includeChildPage,pageReportType,resourceResolver,pageManager);
                }
                else if("comp".equalsIgnoreCase(compReportType)){
                    log.error("******* Page Path ******* " + compPagePath);
                    log.error("******** Report Type ******** " + compReportType);
                    log.error("******** Comp Path ********* " + compPath);
                    createResultsRow(exportWorkbookSheet,compPagePath,compPath,compReportType,resourceResolver,pageManager);
                }
                
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
                response.setHeader("Content-Disposition","attachment;filename=ComponentReport.xls");
                sos.write(baos.toByteArray());
                sos.flush();
                
                if(exportToExcelFile.exists())
                    exportToExcelFile.delete();
                
            }   
            catch(Exception ex){
                log.error("******* Exception Occured in Component Report Export to Excel Servlet",ex);
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
    
    private void writeResultsSheet(WritableSheet sheet) throws WriteException,Exception{
  
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
                
            cellFormat = new WritableCellFormat(headingWritableFont);
            cellFormat.setWrap(true);
            cellFormat.setAlignment(Alignment.LEFT);
            cellFormat.setVerticalAlignment(VerticalAlignment.TOP);
            cellFormat.setShrinkToFit(true);
            cellFormat.setBorder(Border.ALL,BorderLineStyle.THIN);
            cellFormat.setBackground(Colour.GRAY_25);            
            
            Label label1 = new Label(0,0,"Page Title",cellFormat);
            sheet.addCell(label1);
            sheet.setColumnView(0,20000);
            
            Label label2 = new Label(1,0,"Page URL",cellFormat);
            sheet.addCell(label2);
            sheet.setColumnView(1,20000);
            
            Label label3 = new Label(2,0,"Author",cellFormat);
            sheet.setColumnView(2,10000);
            sheet.addCell(label3);
            
            Label label4 = new Label(3,0,"Activation Status",cellFormat);
            sheet.setColumnView(3,10000);
            sheet.addCell(label4);
            
            Label label5 = new Label(4,0,"Component Type",cellFormat);
            sheet.addCell(label5);
            sheet.setColumnView(4,20000);
            
            Label label6 = new Label(5,0,"Component Path",cellFormat);
            sheet.addCell(label6);
            sheet.setColumnView(5,20000);
                             
        }
        catch(WriteException e){
            log.error("******* Exception Occured in Export to Excel Servlet writeResultsSheet Method",e);
        }
        catch(Exception ex){
            log.error("******* Exception Occured in Export to Excel Servlet writeResultsSheet Method",ex);
        }       

    } 
    
    public void createResultsRow(WritableSheet sheet,String pagePath,String childOrCompValue,String reportType,ResourceResolver resourceResolver,PageManager pageManager){           
        try
        {
            WritableFont writableFont = new WritableFont(WritableFont.ARIAL,9, WritableFont.NO_BOLD);
            WritableCellFormat cellFormat = new WritableCellFormat(writableFont);
            cellFormat.setWrap(true);
            cellFormat.setAlignment(Alignment.LEFT);
            cellFormat.setVerticalAlignment(VerticalAlignment.TOP);
            cellFormat.setShrinkToFit(true);
            cellFormat.setBorder(Border.ALL,BorderLineStyle.THIN);
            
            
            
            String title = "";
            String url = "";
            String author ="";
            String status = "";
            String compName="";
            String compType="";
            String compPath="";
            
            if(reportType.equals("page")){
                if(childOrCompValue.equals("false")){
                    Node globalPage = resourceResolver.getResource(pagePath + "/jcr:content").adaptTo(Node.class);
                    NodeIterator myChildren = globalPage.getNodes();
                    title = globalPage.getProperty("jcr:title").getString();
                    url =  pagePath ;
                    
                    if(globalPage.hasProperty("authorName")){
                        author = globalPage.getProperty("authorName").getString();
                    }
                    if(globalPage.hasProperty("cq:lastReplicationAction")){   
                        status= globalPage.getProperty("cq:lastReplicationAction").getString(); 
                        if(status.toLowerCase().equals("activate")){
                            status = "Active";
                        }
                        else if(status.toLowerCase().equals("deactivate")){
                            status = "Deactive";
                        }
                        if(status.trim().toLowerCase().equals("")){
                            status = "-";
                        }
                    }
                    int rowNumber = 1;
                    while(myChildren.hasNext()){
                        Node child =   myChildren.nextNode();
                        if(child.hasProperty("sling:resourceType")){
                            if(child.getProperty("sling:resourceType").getString().equals("mcd/components/content/parsys") || child.getProperty("sling:resourceType").getString().startsWith("/apps/mcd/components/content") || child.getProperty("sling:resourceType").getString().equals("foundation/components/iparsys")){
                                NodeIterator compNodes = child.getNodes();
                                while(compNodes.hasNext()){
                                    Node comp = compNodes.nextNode();
                                    compName = comp.getName();
                                    compType = comp.getProperty("sling:resourceType").getString();
                                    compPath = comp.getPath();//.substring(comp.getPath().indexOf("/jcr:content"),comp.getPath().length()) ;
                                    //compPath = compPath.replace("/jcr:content","");
                                    
                                    try{   
                                        if(compType != null){
                                            Node cmp = resourceResolver.getResource(compType).adaptTo(Node.class);
                                            if(cmp != null){
                                                if(cmp.hasProperty("jcr:title")){
                                                    compType = cmp.getProperty("jcr:title").getString();
                                                } 
                                            }
                                        }
                                    }
                                    catch(Exception e){
                                        log.error("Component Report : Page : " + e.getMessage());
                                    }
                                                                        
                                    Label titleLabel = new Label(0,rowNumber,title,cellFormat);
                                    sheet.addCell(titleLabel);
                                    
                                    Label urlLabel = new Label(1,rowNumber,url,cellFormat);
                                    sheet.addCell(urlLabel);
                                    
                                    Label authorLabel = new Label(2,rowNumber,author,cellFormat);
                                    sheet.addCell(authorLabel);
                                    
                                    Label statusLabel = new Label(3,rowNumber,status,cellFormat);
                                    sheet.addCell(statusLabel);
                                    
                                    Label compTypeLabel = new Label(4,rowNumber,compType,cellFormat);
                                    sheet.addCell(compTypeLabel);
                                    
                                    Label compPathLabel = new Label(5,rowNumber,compPath,cellFormat);
                                    sheet.addCell(compPathLabel);
                                    
                                    rowNumber++;
                                }   
                            }
                        }
                    } 
                }
                
                if(childOrCompValue.equals("true")){
                    Page rootPage = pageManager.getPage(pagePath);
                    childPagesList = rootPage.getPath();
                    String pages = getP(rootPage);  // Get the CSV list of the child pages
                    log.error("Pages List :: " + pages);
                    String[] Inpage = pages.split(",");
                    
                    // Traverse the Array of PAges 
                    int childPageRow = 1;
                    for(int i = 0 ;i <Inpage.length ; i++){
                        try{ 
                            //log.error("Inpage[i] Page Path :: " + Inpage[i]);
                            Node globalPage = resourceResolver.getResource(Inpage[i] + "/jcr:content").adaptTo(Node.class);
                            //log.error("Global Node Path :: " + globalPage.getPath());      
                            NodeIterator myChildren = globalPage.getNodes();
                            title = globalPage.getProperty("jcr:title").getString();
                            url =  Inpage[i] ;
                            
                            if(globalPage.hasProperty("authorName")){
                                author = globalPage.getProperty("authorName").getString();
                            }
                            
                            if(globalPage.hasProperty("cq:lastReplicationAction")){   
                                status= globalPage.getProperty("cq:lastReplicationAction").getString(); 
                                if(status.toLowerCase().equals("activate")){
                                    status = "Active";
                                }
                                else if(status.toLowerCase().equals("deactivate")){
                                    status = "Deactive";
                                }
                                if(status.trim().toLowerCase().equals("")){ 
                                    status = "-";
                                }
                            }
                            
                            //log.error("****** Start Child Page Row ******" + childPageRow);
                            while(myChildren.hasNext()){
                                Node child =   myChildren.nextNode();
                                if(child.hasProperty("sling:resourceType")){
                                    if(child.getProperty("sling:resourceType").getString().startsWith("mcd/components/content") || child.getProperty("sling:resourceType").getString().startsWith("/apps/mcd/components/content") || child.getProperty("sling:resourceType").getString().equals("mcd/components/content/parsys") || child.getProperty("sling:resourceType").getString().equals("/apps/mcd/components/content/parsys") || child.getProperty("sling:resourceType").getString().equals("foundation/components/iparsys")){
                                        NodeIterator compNodes = child.getNodes();
                                        while(compNodes.hasNext()){
                                            Node comp = compNodes.nextNode();
                                            compName = comp.getName();
                                            compType = comp.getProperty("sling:resourceType").getString();
                                            //log.error("Comp Type :: " + compType);
                                            //compPath = comp.getPath().substring(comp.getPath().indexOf("/jcr:content"),comp.getPath().length()) ;
                                            //compPath = compPath.replace("/jcr:content","");
                                            compPath = comp.getPath();
                                             
                                            if(compType != null){
                                                Node cmp = resourceResolver.getResource(compType).adaptTo(Node.class);
                                                if(cmp != null){
                                                    if(cmp.hasProperty("jcr:title")){
                                                        compType = cmp.getProperty("jcr:title").getString();
                                                        log.error("Comp Name :: " + compType);
                                                    }
                                                }
                                            }
                                            Label titleLabel = new Label(0,childPageRow,title,cellFormat);
                                            sheet.addCell(titleLabel);
                                            
                                            Label urlLabel = new Label(1,childPageRow,url,cellFormat);
                                            sheet.addCell(urlLabel);
                                            
                                            Label authorLabel = new Label(2,childPageRow,author,cellFormat);
                                            sheet.addCell(authorLabel);
                                            
                                            Label statusLabel = new Label(3,childPageRow,status,cellFormat);
                                            sheet.addCell(statusLabel);
                                            
                                            Label compTypeLabel = new Label(4,childPageRow,compType,cellFormat);
                                            sheet.addCell(compTypeLabel);
                                            
                                            Label compPathLabel = new Label(5,childPageRow,compPath,cellFormat);
                                            sheet.addCell(compPathLabel);
                                            
                                            childPageRow++;
                                        }  
                                        
                                        
                                        //log.error("****** Next Child Page Row ******" + childPageRow);
                                    }
                                } 
                            } 
                        } 
                        catch(Exception e){
                            log.error("Page Report  : Pages(Child) :  " + e);
                        }
                    }  
                } 
            }
            
            if(reportType.equals("comp")){
                try{      
                    Page rootPage = pageManager.getPage(pagePath);
                    childPagesList = rootPage.getPath(); 
                    String pages = getP(rootPage);
                    String[] Inpage = pages.split(",");
                    
                    int compPageRow = 1;
                    for(int i = 0 ;i <Inpage.length ; i++){
                        Node globalPage = resourceResolver.getResource(Inpage[i] + "/jcr:content").adaptTo(Node.class);      
                        NodeIterator myChildren = globalPage.getNodes();
                        title = globalPage.getProperty("jcr:title").getString();
                        url =  Inpage[i] ;
                        if(globalPage.hasProperty("authorName")){
                            author = globalPage.getProperty("authorName").getString();
                        }
                        else{
                            author = "";
                        }   
                        if(globalPage.hasProperty("cq:lastReplicationAction")){   
                            status= globalPage.getProperty("cq:lastReplicationAction").getString(); 
                            if(status.toLowerCase().equals("activate")){
                                status = "Active";
                            }
                            else if(status.toLowerCase().equals("deactivate")){
                                status = "Deactive";
                            }
                            if(status.trim().toLowerCase().equals("")){status="-";}
                        }
                        
                        while(myChildren.hasNext()){
                            Node child = myChildren.nextNode();
                            if(child.hasProperty("sling:resourceType")){
                                if(child.getProperty("sling:resourceType").getString().equals("mcd/components/content/parsys") || child.getProperty("sling:resourceType").getString().equals("foundation/components/iparsys")){
                                    NodeIterator compNodes = child.getNodes();
                                    while(compNodes.hasNext()){
                                        Node comp = compNodes.nextNode();
                                        if(comp.getProperty("sling:resourceType").getString().equals(childOrCompValue) || childOrCompValue.indexOf(comp.getProperty("sling:resourceType").getString()) >= 0){
                                            compName = comp.getName();
                                            compType = comp.getProperty("sling:resourceType").getString();
                                            compPath = comp.getPath().substring(comp.getPath().indexOf("/jcr:content"),comp.getPath().length()) ;
                                            compPath = compPath.replace("/jcr:content","");
                                            try{   
                                                if(compType != null){
                                                    Node cmp = resourceResolver.getResource(compType).adaptTo(Node.class);
                                                    if(cmp != null){
                                                        if(cmp.hasProperty("jcr:title")){
                                                            compType = cmp.getProperty("jcr:title").getString();
                                                        } 
                                                    }
                                                }
                                            }
                                            catch(Exception e){
                                                log.error("Component Report : Component : " + e.getMessage() );
                                            }
                                            
                                            Label titleLabel = new Label(0,compPageRow,title,cellFormat);
                                            sheet.addCell(titleLabel);
                                            
                                            Label urlLabel = new Label(1,compPageRow,url,cellFormat);
                                            sheet.addCell(urlLabel);
                                            
                                            Label authorLabel = new Label(2,compPageRow,author,cellFormat);
                                            sheet.addCell(authorLabel);
                                            
                                            Label statusLabel = new Label(3,compPageRow,status,cellFormat);
                                            sheet.addCell(statusLabel);
                                            
                                            Label compTypeLabel = new Label(4,compPageRow,compType,cellFormat);
                                            sheet.addCell(compTypeLabel);
                                            
                                            Label compPathLabel = new Label(5,compPageRow,compPath,cellFormat);
                                            sheet.addCell(compPathLabel);
                                            
                                            compPageRow++;
                                        }   
                                    }    
                                }
                            }
                        } 
                    
                    }
                }
                catch(Exception e){
                    log.error("******* Exception Occured in Component Report Method Export to Excel Servlet createResultsRow",e);
                }
            } 
            
        }
        catch(Exception e){
            log.error("******* Exception Occured in Component Report Export to Excel Servlet createResultsRow Method",e);
        }
    }
    
    String separator = "";
    public String getP(Page rootPage){
    if (rootPage != null){
        Iterator<Page> children = rootPage.listChildren();
        while (children.hasNext()){
            Page child = children.next();
            if(separator=="")separator=",";
            childPagesList+=separator;
            childPagesList+=child.getPath();
            getP(child);
        }
    }
     //log.error(" All Pages Path :: " + childPagesList);
     return childPagesList;
    }
    protected void bindRepository(org.apache.sling.jcr.api.SlingRepository repository)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.repository = repository;
            
    }   
    protected void unbindRepository(org.apache.sling.jcr.api.SlingRepository repository)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        repository = null;
    }

   	protected void bindResolverFactory(JcrResourceResolverFactory resolverFactory)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.resolverFactory = resolverFactory;
            
    }   
    protected void unbindResolverFactory(JcrResourceResolverFactory resolverFactory)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        resolverFactory = null;
    } 
} 