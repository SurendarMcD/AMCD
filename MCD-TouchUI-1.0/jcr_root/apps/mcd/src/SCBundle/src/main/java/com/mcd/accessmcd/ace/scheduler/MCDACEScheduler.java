package com.mcd.accessmcd.ace.scheduler; 

//import com.mcd.accessmcd.ace.scheduler.Activator; 
import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;

import java.lang.Runnable;
import java.text.*;
import java.lang.*;
import java.util.*;
import java.io.*;

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
//import jxl.write.VerticalAlignment;
import java.net.URL;
import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;  
import javax.jcr.*;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.api.scripting.SlingScriptHelper;
import com.day.cq.replication.*;
import com.mcd.accessmcd.ace.manager.ACEMailManager;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.apache.sling.api.resource.ResourceResolver;
import com.mcd.accessmcd.ace.exceptions.NoMembersInGroup;
import com.mcd.accessmcd.ace.manager.ACEManager;
import com.mcd.accessmcd.ace.bo.ACEConfigDataBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.scripting.core.ScriptHelper;
import com.day.cq.jcrclustersupport.ClusterAware;
import com.day.cq.security.*;  
import com.day.cq.search.Query;
import com.day.cq.search.PredicateGroup;
import com.day.cq.search.result.SearchResult;
import com.day.cq.search.result.Hit;
import com.day.cq.search.QueryBuilder;
import com.day.cq.jcrclustersupport.ClusterAware;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;

@Component(immediate=true,metatype=false)
@Service(value = Runnable.class)
@Properties({
    @Property( name="service.description",value="ACE Scheduler"),
    @Property( name="service.vendor",value="MCD"),
    @Property( name="scheduler.period",longValue = 30),
    @Property( name="scheduler.expression",value="* * * * * ?",label="Expression",description="cron format"),
    @Property(name="scheduler.concurrent", boolValue=false)
})

 
 
public class MCDACEScheduler implements Runnable,ClusterAware{

    private static final Logger log = LoggerFactory.getLogger(MCDACEScheduler.class);
    
    /** @scr.reference */
    private SlingRepository repository;

    /** @scr.reference */
    private com.day.cq.security.UserManagerFactory uFactory;
    
    /** @scr.reference */
    private com.day.cq.replication.Replicator rep;
    
    /** @scr.reference */
    private JcrResourceResolverFactory resolverFactory;
    
    private static Session observationSession;

    BundleContext bc = Activator.getBundleContext();

    private WorkbookSettings workbookSettings = null; 
    private File offtimeFile = null;
    private WritableWorkbook offtimeWorkbook = null;
    private WritableSheet offtimeWorkbookSheet = null;
    private File expiredPagesFile = null;
    private WritableWorkbook expiredPagesWorkbook = null;
    private WritableSheet expiredPagesWorkbookSheet = null;
    
    private String dateFormat = "MM.dd.yyyy HH:mm:ss"; 
    boolean isMaster = false;
    //ArrayList treePageList = new ArrayList();
     
    private int i = 1;
    private int j = 1;
    private int offTimeFlag = 0;
    private int expirationFlag = 0;
    private String authPath = "put author path here"; 
    private static String serverPath ="put server path here";
    private Date currentDate =  null;   
    private long currentDatemillisec = 0;
    private String lang ="en";
    private ACEMailManager mailConfigProp = null;
    private ACEMailManager mailConfigPropFR = null;
    private ACEManager aceManager =null;
    private String treeRootPage = "/content/accessmcd";
    private String toEmail = "";
    private String ccEmail = "";
    
    String pageAuthor = "";
    String pageAuthorEmail = "";
    String siteOwnerName = "";
    String siteOwnerEmail = "";
    String nextPageAuthor = "";
    HashMap authorsMap = new HashMap();
    HashMap authorsFilterdMap = new HashMap();
    HashMap authorsInfoMap = new HashMap();
    String pageDateFormat = "";
    String pageAuthorDomain = "";
    String pagePublishDomain = "";
    String pageLanguage = "";
    
//added 10/29/2010
    private static UserManager umgr =null;
    
//judy added AOW map, 08/06/2012

    private static String default_admin_group = "ACE-Admins";
    
    private static Map<String,String> hMap=new HashMap<String,String>();

    static {
        hMap.put("/content/accessmcd/corp", "CORP-A-Admin");
        hMap.put("/content/accessmcd/apmea/apmeahome", "CORP-A-Admin");
        hMap.put("/content/accessmcd/eu", "CORP-A-Admin");
        hMap.put("/content/accessmcd/na/us", "US-A-Admin");
        hMap.put("/content/accessmcd/na/mcweb", "CA-A-Admin");
        hMap.put("/content/accessmcd/apmea/nz", "NZ-A-Admin");
        hMap.put("/content/accessmcd/apmea/au", "AU-A-Admin");
    }    
     
    
    public MCDACEScheduler(){
    }
    

    public void run() {
           
               //System.out.println("*********** Run resolverFactory ********"+ resolverFactory); 
               this.currentDate =  new Date();
               this.currentDatemillisec = currentDate.getTime();
               if(isMaster){
                   startScheduler();
               }
               else{
                    log.info("********** This is slave instance MCDACESchedular schedular will not start from here *********");
                }
               log.info("[ApacheCacheInvalidator .run] scheduler finish");
            

    }

    public void test(Date ddd,String testURL,String testToEmail,String testCCEmail, SlingScriptHelper sss){
            if (ddd!=null && sss!=null && testURL!=null){
               this.currentDate =  ddd;
               this.toEmail = testToEmail;
               this.ccEmail = testCCEmail;
               this.currentDatemillisec = currentDate.getTime();
               this.treeRootPage = testURL;
               this.repository = sss.getService(SlingRepository.class);
               this.rep = sss.getService(Replicator.class);
               this.uFactory = sss.getService(UserManagerFactory.class);
               this.resolverFactory = sss.getService(JcrResourceResolverFactory.class);
               startScheduler();
            }   
 
    }

    public void startScheduler(){
    
        try{
                System.out.println("*********** Inside Start Scheduler Method ********");
                if (observationSession == null)
                    observationSession = repository.loginAdministrative(null);  
                 
                
                //System.out.println("*********** resolverFactory ********"+ resolverFactory);
                ResourceResolver resourceResolver = resolverFactory.getResourceResolver(observationSession); 
                umgr = uFactory.createUserManager(observationSession);  
                PageManager pageManager = resourceResolver.adaptTo(PageManager.class); 
                
                aceManager = new ACEManager();
                ScriptHelper mySling = new ScriptHelper(bc,null); 
                System.out.println("***** Tree Start Page ***** " + treeRootPage);
                Page treeStartPage = pageManager.getPage(treeRootPage);
                authorsMap = scanTree(treeStartPage,pageManager);
                //System.out.println("****** Size of HashMap ******** " + authorsMap);
                
                /*Code to get separated list based on expiration days
                * This will return separate list for lesss than equal to 4 days
                * and separate list for 14,10,7 days for same author.
                */
                authorsFilterdMap = getListByExpireDays(authorsMap,pageManager,mySling);
                //System.out.println("****** Size of Filtered HashMap ******** " + authorsFilterdMap);
                /*Iterator authorsItr1 = authorsFilterdMap.entrySet().iterator();
                while(authorsItr1.hasNext()) {
                    Map.Entry authorsPair = (Map.Entry)authorsItr1.next();
                    String auhtorInfo = authorsPair.getKey().toString();
                    String authorName = auhtorInfo.substring(0,auhtorInfo.indexOf("|"));
                    String authorEmail = auhtorInfo.substring(auhtorInfo.indexOf("|")+1,auhtorInfo.indexOf("^"));
                    //System.out.println("** Author Name ** " + authorName + " ** Author Email ** " +authorEmail);
                    ArrayList authorsPageList = (ArrayList)authorsPair.getValue();
                    
                }    */
                /*ArrayList authorGroupList = scanTree(treeStartPage,pageManager);
                System.out.println("*********** Author Group Size Before **********" + authorGroupList.size());  
                //treePageList = new ArrayList();
                HashSet authorHS = new HashSet();
                authorHS.addAll(authorGroupList);
                authorGroupList.clear();
                authorGroupList.addAll(authorHS); 
                System.out.println("*********** Author Group Size After **********" + authorGroupList.size());  
                
                for(int i=0; i<authorGroupList.size(); i++){
                    String authorName = authorGroupList.get(i).toString();
                    String queryStr = authorName.substring(authorName.indexOf("|")+1);
                    
                    Map<String, String> map = new HashMap<String, String>();
                    map.put("group.1_fulltext", queryStr );
                    map.put("path","/content/accessmcd");
                    
                    QueryBuilder builder= resourceResolver.adaptTo(QueryBuilder.class);
                    Query query = builder.createQuery(PredicateGroup.create(map), observationSession);                
                    query.setHitsPerPage(1000);
                    SearchResult result = query.getResult();
                    ArrayList authorsPageList = new ArrayList();
                    
                    if(result.getTotalMatches()>0){  
                        for (Hit hit : result.getHits()){     
                            String pagePath = hit.getNode().getParent().getPath();
                            //System.out.println("** Author ** digvijay.singh@us.mcd.com" + pagePath);
                            Page tempPage = pageManager.getPage(pagePath);
                            if(tempPage != null){
                                String tempEmail = tempPage.getProperties().get("authorEmail","").trim().toLowerCase();
                                if(queryStr.equalsIgnoreCase(tempEmail)){
                                    //if ((null!=pagePath && (!pagePath.equals("/content/accessmcd")))){
                                        //System.out.println("Page Path :: "+ pagePath);
                                        authorsPageList.add(pagePath);
                                    //}
                                }
                            } 
                        } 
                        HashSet authorHS1 = new HashSet();
                        authorHS1.addAll(authorsPageList);
                        authorsPageList.clear();
                        authorsPageList.addAll(authorHS1);
                        
                        authorsMap.put(authorName,authorsPageList);  
                    }
                    
                }*/
               
                //System.out.println("****** Authors Map Size ******" + authorsMap.size()); 
                Iterator authorsItr = authorsFilterdMap.entrySet().iterator();
                 while(authorsItr.hasNext()) {
                    Map.Entry authorsPair = (Map.Entry)authorsItr.next();
                    String auhtorInfo = authorsPair.getKey().toString();
                    /*String authorName = auhtorInfo.substring(0,auhtorInfo.indexOf("|"));
                    String authorEmail = auhtorInfo.substring(auhtorInfo.indexOf("|")+1);*/
                    String authorName = auhtorInfo.substring(0,auhtorInfo.indexOf("|"));
                    String authorEmail = auhtorInfo.substring(auhtorInfo.indexOf("|")+1,auhtorInfo.indexOf("^"));
                    //System.out.println("** Author Name ** " + authorName + " ** Author Email ** " +authorEmail);
                    ArrayList authorsPageList = (ArrayList)authorsPair.getValue();
                    //System.out.println("Authors Page List :: " + authorsPageList);
                    
                    //delete duplicates
                    HashSet hs = new HashSet(); 
                    hs.addAll(authorsPageList ); 
                    authorsPageList.clear(); 
                    authorsPageList.addAll(hs);
                    //System.out.println("page number :: new ---"+ authorsPageList.size());
                    
                    pagePublishDomain = "https://www1-int.accessmcd.com";
                    lang = "en";
                    
                    
                    offTimeFlag = 0;
                    expirationFlag = 0;
                    i =1;
                    j= 1; 
                    
                    serverPath = aceManager.getServerFilesPath();
                    ContentExpirationLogger.setFile(serverPath +"contentExp.log");  
                    mailConfigProp = new ACEMailManager(lang);
                    //checkStatus(authorsPageList,pageManager,mySling);
                    ArrayList emailLang = getEmailLanguage(authorsPageList,pageManager,mySling);
                    String offTimeBodyText = "";
                    String expirationBodyText = "";
                    if(emailLang.size() > 1){
                        for(int em=0; em<emailLang.size(); em++ ){
                            String emailLanguage = emailLang.get(em).toString();
                            ACEMailManager mailProp = new ACEMailManager(emailLanguage);
                            offTimeBodyText += mailProp.getValueForKey("offTimeBodyText") + "\n\n";
                            expirationBodyText += mailProp.getValueForKey("expirationBodyText") + "\n\n";
                            if("fr".equalsIgnoreCase(emailLanguage))
                                System.out.println("***** Email Language *****" + emailLang.get(em).toString() + emailLang.size());
                        }
                    }
                    else if(emailLang.size() == 1){
                        String emailLanguage = emailLang.get(0).toString();
                        ACEMailManager mailProp = new ACEMailManager(emailLanguage);
                        offTimeBodyText = mailProp.getValueForKey("offTimeBodyText");
                        expirationBodyText = mailProp.getValueForKey("expirationBodyText");
                    }
                    else{
                        offTimeBodyText = mailConfigProp.getValueForKey("offTimeBodyText");
                        expirationBodyText = mailConfigProp.getValueForKey("expirationBodyText");
                    }
                    
                    ArrayList siteOwnerArr = getSiteOwnerEmail(authorsPageList,pageManager);
                    //System.out.println("Site Owner Original List :: "+siteOwnerArr);
                    HashSet siteOwnerHS = new HashSet();
                    siteOwnerHS.addAll(siteOwnerArr);
                    siteOwnerArr.clear();
                    siteOwnerArr.addAll(siteOwnerHS);
                    //System.out.println("Site Owner Compiled List :: "+siteOwnerArr);
                    
                    String filename1 = serverPath +"ace_offtime.xls";
                    String filename2 = serverPath + "ace_deactivated.xls";
                    
                    String worksheet_title = authorName;
                    
                    workbookSettings = new WorkbookSettings();
                    
                    offtimeFile = new File(filename1);
                    offtimeWorkbook = Workbook.createWorkbook(offtimeFile, workbookSettings);
                    offtimeWorkbookSheet = offtimeWorkbook.createSheet(worksheet_title, 0);
                    
                    expiredPagesFile = new File(filename2);
                    expiredPagesWorkbook = Workbook.createWorkbook(expiredPagesFile, workbookSettings);
                    expiredPagesWorkbookSheet = expiredPagesWorkbook.createSheet(worksheet_title , 0);
                    
                    
                    //create sheet and the first row(header) for OffTime notification file
                    writeDataSheet(offtimeWorkbookSheet, "Date of Expiration");
                    //create sheet and the first row(header) for Deactivation notification file
                    writeDataSheet(expiredPagesWorkbookSheet, "Date of Deactivation");
                    
                    ArrayList aowMembersList = checkStatus(authorsPageList,pageManager,mySling);
                    //System.out.println("******** !!!!!!!!!!!!! **********");
                    //closing the OffTime notification file
                    if(offTimeFlag == 1){
                        offtimeWorkbook.write();
                    }
                    offtimeWorkbook.close();
                    //closing the Deactivation notification file
                    if(expirationFlag == 1){
                       expiredPagesWorkbook.write();
                    }
                    expiredPagesWorkbook.close();
                    /*for(int l=0; l<aowMembersList.size(); l++){
                        System.out.println("**** AOW Members ****" + aowMembersList.get(l).toString());
                    }*/
                    try{
                        //creating an object for MailNotifivcation
                        MailNotification mailNotification = new MailNotification();
                        //System.out.println("***** AOW Member List ***** " + aowMembersList);
                        if(aowMembersList.size() > 0 ){
                            for(int l=0; l<aowMembersList.size(); l++){
                                if(!"".equals(aowMembersList.get(l).toString().trim())){
                                    siteOwnerArr.add(aowMembersList.get(l).toString());
                                }    
                            }
                        }    
                        
                        /*for(int l=0; l<siteOwnerArr.size(); l++){
                             System.out.println("**** Site Owners ****" + siteOwnerArr.get(l).toString());
                        }*/
                       System.out.println("******************* List For *******************" + authorsPageList); 
                       System.out.println("Owner List :: " + siteOwnerArr);
                       System.out.println("Author List :: " + authorEmail);
                       System.out.println("******************************************************"); 
                       System.out.println("******************************************************"); 
                       System.out.println("******************************************************"); 
                       System.out.println("******************************************************"); 
                       
                       
                       ArrayList<String> ownerArr = null;
                       ArrayList<String> authorArr = null;
                       System.out.println("***** To Email Address *****" + toEmail);
                       System.out.println("***** CC Email Address *****" + ccEmail);
                       if(toEmail.trim() != "" && ccEmail.trim()!=""){
                           ownerArr = getArrayListfromStr(toEmail);
                           authorArr = getArrayListfromStr(ccEmail);    
                       }
                       else{
						   ownerArr = getArrayListfromStr("digvijay.tomar@us.mcd.com");
                           authorArr = getArrayListfromStr("digvijay.tomar@us.mcd.com");

                           //ownerArr = siteOwnerArr;
                           //authorArr = getArrayListfromStr(authorEmail);
                       }
                       
                        //send mail for off time notification if atleast one entry is made 
                        //for 14, 10, 7 or 
                        //less than 7 days in the file
                         
                        if(offTimeFlag == 1){
                            mailNotification.sendMail("SUMIT.SINGHAL@US.MCD.COM,Digvijay.Tomar@us.mcd.com", authorArr ,ownerArr , 
                            mailConfigProp.getValueForKey("mailServer"), 
                            mailConfigProp.getValueForKey("offTimeSubject"), 
                            offTimeBodyText , 
                            mailConfigProp.getValueForKey("fromAddress"), 
                            filename1, worksheet_title +"_cq5ace_expiring.xls",
                            mailConfigProp.getValueForKey("fromAddressPersonal"));
                        }  
                        
                        //send mail for deactivated pages even if atleast one entry is 
                        //made in the file
                        if(expirationFlag == 1){
                            mailNotification.sendMail("SUMIT.SINGHAL@US.MCD.COM,Digvijay.Tomar@us.mcd.com", authorArr ,ownerArr , 
                            mailConfigProp.getValueForKey("mailServer"), 
                            mailConfigProp.getValueForKey("expirationSubject")+"_"+authorName, 
                            expirationBodyText , 
                            mailConfigProp.getValueForKey("fromAddress"), 
                            filename2, worksheet_title +"_cq5ace_deactivating.xls",
                            mailConfigProp.getValueForKey("fromAddressPersonal"));
                        }
                    
                    }catch(Exception em){
                        ContentExpirationLogger.info("Exception sending scheduler notification:: " + 
                        em.getMessage());
                        System.out.println("Exception sending scheduler notification:: " + 
                        em.getMessage());
                        sendExceptionMail(em);  
                    }
             
    
                    if(offtimeFile.exists())
                        offtimeFile.delete();
                    
                    if(expiredPagesFile.exists())
                        expiredPagesFile.delete();
                    
                }//end while
           }catch(Exception e){
                   ContentExpirationLogger.info("Exception in MCDACEScheduler " + e.getMessage());
                   System.out.println("Exception in MCDACEScheduler " + e.getMessage());
                   System.out.println("Sending Exception Email " );
                   sendExceptionMail(e);  
           }finally{
                System.out.println("------------------ scheduler end ----------------" );
                try{
                if(offtimeFile!=null && offtimeFile.exists())
                    offtimeFile.delete();
                
                if(expiredPagesFile!=null && expiredPagesFile.exists())
                    expiredPagesFile.delete();
                    
                }catch(Exception e){
                       System.out.println("Exception when close workbook sheet");
                }
                if (observationSession.isLive())
                    observationSession.logout();        
                observationSession = null;
           }
    
    }

    //Function that creates sheet and the first row(header) for OffTime notification file
    private void writeDataSheet(WritableSheet sheet, String columnName) throws WriteException,Exception
    {

        try
        {
            // Format the Font setDefaultColumnWidth 
            SheetSettings sheetSettings = new SheetSettings(sheet);
            sheetSettings.setDefaultColumnWidth(10000);
            
            WritableFont headingWritableFont = new WritableFont(WritableFont.ARIAL,11, 
            WritableFont.BOLD);
            WritableCellFormat cellFormat = new WritableCellFormat(headingWritableFont);
            cellFormat.setWrap(true);
            
            // Creates Label
            Label label = new Label(0,0,columnName,cellFormat);
            sheet.addCell(label);   
             
            // Creates Label
            label = new Label(1,0,mailConfigProp.getValueForKey("daysLeft"), cellFormat);
            sheet.addCell(label);

            // Creates Label
            label = new Label(2,0,mailConfigProp.getValueForKey("pageTitle"),cellFormat);
            sheet.addCell(label);               

            // Creates Label
            label = new Label(3,0,mailConfigProp.getValueForKey("authorName"),cellFormat);
            sheet.addCell(label);
            
            label = new Label(4,0,mailConfigProp.getValueForKey("siteOwnerName"),cellFormat);
            sheet.addCell(label);
            
            // Creates Label
            label = new Label(5,0,mailConfigProp.getValueForKey("reviewUpdateContent"),cellFormat);
            sheet.addCell(label);
            
            // Creates Label
          //  label =  new Label(6,0,mailConfigProp.getValueForKey("activateDeactivateContent"),cellFormat);
          //  sheet.addCell(label);
             
            //setting the column width for all the columns
            sheet.setColumnView(0,20000);
            sheet.setColumnView(1,10000);
            sheet.setColumnView(2,20000); 
            sheet.setColumnView(3,20000);
            sheet.setColumnView(4,20000);
            sheet.setColumnView(5,40000);
            //sheet.setColumnView(6,50000);
        }
        catch(WriteException e) 
        {
            ContentExpirationLogger.info(e.getMessage());
            sendExceptionMail(e);
        }
        catch(Exception ex)
        {
            ContentExpirationLogger.info(ex.getMessage());
            sendExceptionMail(ex);
        }       

    }

    //send exception mail
    public void sendExceptionMail(Exception e)
    {
        StringWriter sw = new StringWriter();
        try
        {
            MailNotification mailNotification = new MailNotification();
            
            e.printStackTrace(new PrintWriter(sw));
            mailNotification.sendExceptionEmail(mailConfigProp.getValueForKey("toExceptionAddress"), 
            mailConfigProp.getValueForKey("exceptionSubject"), sw.toString(), 
            mailConfigProp.getValueForKey("mailServer"), 
            mailConfigProp.getValueForKey("fromAddress"),
            mailConfigProp.getValueForKey("fromAddressPersonal")); 
        }
        catch(Exception ex)
        {
            ContentExpirationLogger.info(ex.getMessage());
        }
        finally{
            try{
                if (sw!=null)
                    sw.close();
            }
            catch(Exception eio){
                System.out.println("Error to close stringwriter ---"+eio.getMessage());
            }
        }
    }


    public void createRow(Node jcrNode, WritableSheet sheet, int row, String diffDays, String date,PageManager pageManager,String authPath)
    {           
        try
        {
            WritableFont writableFont = new WritableFont(WritableFont.TIMES,11, WritableFont.NO_BOLD);
            WritableCellFormat cellFormat = new WritableCellFormat(writableFont);
            cellFormat.setWrap(true);
            //cellFormat.setVerticalAlignment(VerticalAlignment.TOP);
            
            //Expiration or deactivation date ,0                      
            Label label = new Label(0,row,date,cellFormat);
            sheet.addCell(label);
            
            //Days left ,1
            label = new Label(1,row,diffDays,cellFormat);
            sheet.addCell(label);           
            
            //TitleText for the page (jcr:title or pageTitle),2
            String pgTitle = (jcrNode.hasProperty("jcr:title")) ?  jcrNode.getProperty("jcr:title").getString():"";
            label = new Label(2,row,pgTitle ,cellFormat);
            sheet.addCell(label);
            
            //Author of the page,3
            String pgAuthor = (jcrNode.hasProperty("authorName")) ?  jcrNode.getProperty("authorName").getString():"";
            /*String pgAuthor = (jcrNode.hasProperty("cq:lastModifiedBy")) ? jcrNode.getProperty("cq:lastModifiedBy").getString():"";
            try{
                // changed 10/29, from eid to name
                if (umgr.get(pgAuthor) !=null ){
                    User user = (User)umgr.get(pgAuthor);
                    if(user.getProperty("rep:fullname") != null) {
                        pgAuthor = user.getProperty("rep:fullname");
                    }
                    else{
                        pgAuthor = user.getName();
                    }
                }
            }catch(Exception e){
                System.out.println("CQ5 exception :"+ e.getMessage());
                String tmpid = pgAuthor;
                pgAuthor = (jcrNode.hasProperty("authorName")) ?  jcrNode.getProperty("authorName").getString():tmpid;
            }  */
            
            
            //System.out.println("author of the page: "+ pgAuthor);      
            label = new Label(3,row,pgAuthor ,cellFormat);
            sheet.addCell(label);           
            
            //Site Owner of the page,4
            String pgOwner = (jcrNode.hasProperty("siteOwnerName")) ?  jcrNode.getProperty("siteOwnerName").getString():"";
            if("".equals(pgOwner)){
                String owPagePath = jcrNode.getPath().substring(0,jcrNode.getPath().lastIndexOf("/"));
                //System.out.println("Owner Page Path :: " + owPagePath);
                Page owPage = pageManager.getPage(owPagePath);
//                pgOwner = getSiteOwnerName(owPage);
//judy, fix siteowner issue
                pgOwner = getSiteOwnerInfo(owPage,"siteOwnerName" );
            }  
            
            
            //System.out.println("Page Owner :: "+ pgOwner);      
            label = new Label(4,row,pgOwner ,cellFormat);
            sheet.addCell(label);
            
            //Path,5
            int index = jcrNode.getPath().lastIndexOf("/");
            String path = jcrNode.getPath().substring(0,index);
            int lst = path.lastIndexOf("/");
            String treePath = authPath  + "/libs/wcm/core/content/siteadmin.html#" + path.substring(0,lst);
            String pgPath = authPath + path ;
            
            label = new Label(5,row,pgPath + ".html",cellFormat);
            sheet.addCell(label);           
            
            //Creating Link for path
            WritableHyperlink link = new WritableHyperlink(5,row,new URL(pgPath + ".html"));
            sheet.addHyperlink(link);
            
            //ShowTree Link,6
            //label = new Label(6,row, treePath ,cellFormat); 
           // sheet.addCell(label);                       
            
           // WritableHyperlink treelink = new WritableHyperlink(6,row,new URL(treePath ));
           // sheet.addHyperlink(treelink);
        
        }
        catch(Exception e)
        {
            System.out.println("Excel exception::" + e.getMessage());
            ContentExpirationLogger.info(e.getMessage());
            sendExceptionMail(e);
        }
    }   
    

    //Function that checks the OffTime and makes respective entries in the notification files
    public ArrayList checkStatus(ArrayList authorsPageList,PageManager pageManager,ScriptHelper mySling)
    {       
        ArrayList aowList = new ArrayList();
        try
        {   
            Node rootNode = observationSession.getRootNode();
            //System.out.println("***** authorsPageList.size() ******" + authorsPageList.size());
            for(int p=0; p<authorsPageList.size(); p++){
                String path = authorsPageList.get(p).toString();
                
                if (aceManager.checkSkipNode(path)){
                    //System.out.println("checkStatus .......pg is skipped .." + path);
                    return aowList;   
                }
        
                Node jcrNode= rootNode.getNode(path.substring(1)+"/jcr:content");
                //System.out.println("***** Node Path ******" + jcrNode.getPath());
                if(jcrNode!=null && jcrNode.hasProperty("offTime") && jcrNode.getProperty("offTime")!=null){
                    String pgSts=
                    jcrNode.hasProperty("cq:lastReplicationAction")?
                    jcrNode.getProperty("cq:lastReplicationAction").getString():"";
                    //System.out.println("******** Inside Check Status Function ******** " + pgSts);
                    if(pgSts.equals("Activate") && jcrNode.hasProperty("offTime"))
                    {                       
                        //get OffTime date
                        Date offtimeDate = jcrNode.getProperty("offTime").getDate().getTime();
                        //System.out.println("path ::"+ path ); 
                        //System.out.println("     offtimeDate ::"+ offtimeDate ); 
                        
                        Calendar deactivateCal = Calendar.getInstance(); 
                        deactivateCal.setTime(offtimeDate);
                    
                        //add 90 days to the current time 
                        deactivateCal.add(Calendar.DATE,90);
                        Date deactivationDate = deactivateCal.getTime();
                        //System.out.println("     deactivationDate ::"+ deactivationDate );
                        ACEConfigDataBean aceBean = null; 
                        try{
                            String sitePageKey = aceManager.getACESitePageKey(path,true); 
                            aceBean = aceManager.getACEConfigBean(sitePageKey,mySling,observationSession); 
                        }catch(Exception eo){
                            System.out.println(eo.getMessage()+ "  ...... site skipped");
                            continue;
                        }
                        
                        dateFormat = aceBean.getDateFormat();
                        authPath = aceBean.getAuthDomainAdd();
                        
                        SimpleDateFormat formatter = new SimpleDateFormat(dateFormat);
                        
                        //last event time
                        long offtimeMillisec = offtimeDate.getTime();
                        
                        //days left for Expiration
                        long diffDays = (offtimeMillisec - currentDatemillisec) / (24 * 60 * 60 * 1000);
                        
                        //Checks if the page is activated and page has already expired 
                        //move the activation check outside
                        //if(pgSts.equals("Activate") && currentDatemillisec > offtimeMillisec) 
                        if(currentDatemillisec > offtimeMillisec)
                        {
                            long deactivationDays =
                            (deactivationDate.getTime() - currentDatemillisec) / (24 * 60 * 60 * 1000);
                            long expiryDays =
                            (currentDatemillisec - offtimeMillisec) / (24 * 60 * 60 * 1000);
                            
                            System.out.println("Pg expired for "+expiryDays  +
                                                ", will be deactivated after " + deactivationDays  );
                        
                            //Checks if 7 days are left for deactivation
                            if(deactivationDays == 7)
                            {
                                ContentExpirationLogger.info(path +
                                " will be deactivated in 7 days, exp date :: " + 
                                offtimeDate.toString());
                                
                                createRow(jcrNode, expiredPagesWorkbookSheet, 
                                j++, Long.toString(deactivationDays) 
                                + " " +  "days", formatter.format(deactivationDate),pageManager,authPath);
                                       
                                expirationFlag = 1;
                                System.out.println("      expiredPagesWorkbookSheet updated" );
                            }
                            //checks if page has been expired for more than 90 days
                            else if(expiryDays > 90)
                            {
                                ContentExpirationLogger.info(path + " deactivated, exp Date :: " + 
                                offtimeDate.toString());
                                //deactivates the page
                                deactivatePage(path);
                                System.out.println("    page expired > 90 days, deactivated");                     
                            }
                            else if(deactivationDays <= 4)
                            {
                                //judy , updated 08/06/2012
                                String sGroup = default_admin_group;
                                for (Map.Entry<String,String> entry : hMap.entrySet())
                                {
                                    String sPath = entry.getKey();
                                    if (path.indexOf(sPath)>-1 ){
                                        sGroup = entry.getValue();
                                    }
                                }
                                System.out.println("AOW Admin is when Deactivation Days :: "+ sGroup);
                                ArrayList tempList = aceManager.getAOWList(mySling,observationSession,sGroup);
                                for(int t=0; t<tempList.size(); t++){
                                    aowList.add(tempList.get(t).toString());
                                }
                                
                                
                            }
                        }
                        //checks if the page is activated but is reaching expiration soon
                        //move the activation check outside
                        //                else if(pgSts.equals("Activate") && diffDays >= 0 && diffDays <= 14)
                        //                else if(diffDays >= 0 && diffDays <= 14)
                        // don't include 0 days, fixed 10/14/2010
                        else if(diffDays > 0 && diffDays <= 14)
                        {
                            ContentExpirationLogger.info(path + " will be expired in " + 
                            diffDays + " days ,exp Date ::" + offtimeDate.toString());
                            
                            
                            createRow(jcrNode, offtimeWorkbookSheet, i++, Long.toString(diffDays) 
                            + " " + "days", formatter.format(offtimeDate),pageManager,authPath);  
                            
                            System.out.println("      Pg will expire in " + diffDays +" days" );
                            System.out.println("      offtimeWorkbookSheet updated" );
                            
                            if(diffDays == 14 || diffDays == 10 || diffDays <= 7){
                                offTimeFlag = 1;
                                if(diffDays <= 4){
                                    //judy , updated 08/06/2012
                                    String sGroup = default_admin_group;
                                    for (Map.Entry<String,String> entry : hMap.entrySet())
                                    {
                                        String sPath = entry.getKey();
                                        if (path.indexOf(sPath)>-1 ){
                                            sGroup = entry.getValue();
                                        }
                                    }
                                    //System.out.println("***** Path for AOW GROUP is ***** " + path);
                                    //System.out.println("***** AOW Admin is when Diff Days less than 4 ***** "+ sGroup);
                                    ArrayList tempList = aceManager.getAOWList(mySling,observationSession,sGroup);
                                    for(int t=0; t<tempList.size(); t++){
                                        aowList.add(tempList.get(t).toString());
                                    }
                                }    
                            }    
                        }
                    }  
                }
            }              
        }
        catch(Exception e)
        {
            ContentExpirationLogger.info(e.getMessage());
            System.out.println(e.getMessage());
            sendExceptionMail(e);
        }
        if(aowList.size() > 0){
            HashSet authorHS = new HashSet();
            authorHS.addAll(aowList);
            aowList.clear();
            aowList.addAll(authorHS); 
        }
        return aowList;       
    }
    
    public HashMap scanTree(Page rootPage,PageManager pageManager){
        if (rootPage != null) {
            // code to retirieve the child pages of the selected page in the itertor object
            Iterator<Page> children = rootPage.listChildren();       
           try {
                Node rootNode = observationSession.getRootNode();
                while (children.hasNext()) {
                    Page childPage = children.next();
                    if(!aceManager.checkSkipNode(childPage.getPath())){
                        
                        Node jcrNode= rootNode.getNode(childPage.getPath().substring(1)+"/jcr:content"); 
                        if(jcrNode!=null && jcrNode.hasProperty("offTime") && jcrNode.getProperty("offTime")!=null){
                            
                            String pgSts=jcrNode.hasProperty("cq:lastReplicationAction")?jcrNode.getProperty("cq:lastReplicationAction").getString():"";
                            if(pgSts.equalsIgnoreCase("Activate") && jcrNode.hasProperty("offTime")){             
                                
                                Date offtimeDate = jcrNode.getProperty("offTime").getDate().getTime();
                                                                
                                Calendar deactivateCal = Calendar.getInstance(); 
                                deactivateCal.setTime(offtimeDate);
                            
                                //add 90 days to the current time 
                                deactivateCal.add(Calendar.DATE,90);
                                Date deactivationDate = deactivateCal.getTime();
                                long offtimeMillisec = offtimeDate.getTime();
                                long diffDays = (offtimeMillisec - currentDatemillisec) / (24 * 60 * 60 * 1000);
                                long deactivationDays = 0;
                                long expiryDays = 0 ;
                                if(currentDatemillisec > offtimeMillisec){
                                   deactivationDays = (deactivationDate.getTime() - currentDatemillisec) / (24 * 60 * 60 * 1000);
                                   expiryDays = (currentDatemillisec - offtimeMillisec) / (24 * 60 * 60 * 1000);
                                } 
                                
                                if(deactivationDays == 7 || (diffDays > 0 && diffDays <= 14)){
                                    pageAuthor = childPage.getProperties().get("authorName","");
                                    if(!"".equals(pageAuthor.trim())){
                                        String pageAuthorEmail = childPage.getProperties().get("authorEmail","");
                                        String authorInfo = pageAuthor.trim().toLowerCase() + "|" + pageAuthorEmail.trim().toLowerCase();
                                        ArrayList treePageList = new ArrayList();
                                        if (authorsInfoMap.get(authorInfo)!=null)
                                            treePageList = (ArrayList)authorsInfoMap.get(authorInfo);
                                        
                                        treePageList.add(childPage.getPath());
                                        authorsInfoMap.put(authorInfo,treePageList);
                                    }    
                                }
                            }
                        }
                    }
                    scanTree(childPage,pageManager);
                }
            } 
            catch(Exception ex){
                System.out.println(ex);
            }
            finally {} 
        }
        return authorsInfoMap;
    }
    public HashMap getListByExpireDays(HashMap authorsMap,PageManager pageManager,ScriptHelper mySling){
        HashMap filteredAuthorMap = new HashMap();
        try{
            Node rootNode = observationSession.getRootNode();
            Iterator authorsItr = authorsMap.entrySet().iterator();
            while(authorsItr.hasNext()) {
                Map.Entry authorsPair = (Map.Entry)authorsItr.next();
                String auhtorInfo = authorsPair.getKey().toString();
                String authorName = auhtorInfo.substring(0,auhtorInfo.indexOf("|"));
                String authorEmail = auhtorInfo.substring(auhtorInfo.indexOf("|")+1);
                //System.out.println("** getListByExpireDays Author Name ** " + auhtorInfo);
                //System.out.println("getListByExpireDays Authors Page List :: " + authorsPageList);
                ArrayList authorsPageList = (ArrayList)authorsPair.getValue();
                ArrayList filteredListFourDays = new ArrayList();
                ArrayList filteredListRemDays = new ArrayList();
                for(int i=0; i<authorsPageList.size(); i++){
                    String path = authorsPageList.get(i).toString();
                    Node jcrNode= rootNode.getNode(path.substring(1)+"/jcr:content");
                    if(jcrNode!=null && jcrNode.hasProperty("offTime") && jcrNode.getProperty("offTime")!=null){   
                        Date offtimeDate = jcrNode.getProperty("offTime").getDate().getTime();
                        long offtimeMillisec = offtimeDate.getTime();
                        
                        //days left for Expiration
                        long diffDays = (offtimeMillisec - currentDatemillisec) / (24 * 60 * 60 * 1000);     
                        if(diffDays <= 4){
                            filteredListFourDays.add(path);
                        }
                        else{
                            filteredListRemDays.add(path);
                        }
                    }     
                }
                /*Put List in Authors HashMap*/
                if(filteredListRemDays.size() > 0){
                    String authorInfoRemDays = auhtorInfo + "^remdays";
                    filteredAuthorMap.put(authorInfoRemDays,filteredListRemDays);
                }
                if(filteredListFourDays.size() > 0){
                    String authorInfoFourDays = auhtorInfo + "^fourdays";
                    filteredAuthorMap.put(authorInfoFourDays,filteredListFourDays);
                }
                
            }
        }
        catch(Exception ex){
            System.out.println(ex);
        }
        return filteredAuthorMap;
    }
    public ArrayList getSiteOwnerEmail(ArrayList authorsPageList,PageManager pageManger){
        ArrayList siteOwnerList = new ArrayList();
        String tempListPath = "";
        String pagePath = "";
        String tempSiteOwnerEmail = "";
        try{
            for(int s=0; s<authorsPageList.size(); s++){
                String listPath = authorsPageList.get(s).toString();
                tempListPath = listPath;
                //sumit fix nullpointer exception 
               
                if(!"".equals(listPath) && null != listPath){
                    Page siteOwnerPage = pageManger.getPage(listPath);
                    //pagePath = siteOwnerPage.getPath();
                    String siteOwnerEmail = siteOwnerPage.getProperties().get("siteOwnerEmail","");
                    tempSiteOwnerEmail = siteOwnerEmail;
                    if("".equalsIgnoreCase(tempSiteOwnerEmail.trim()))
                    {
                    //   siteOwnerEmail = siteOwnerEmailReverseLoop(siteOwnerPage);
                        //judy fix siteowner issue
                        tempSiteOwnerEmail = getSiteOwnerInfo(siteOwnerPage,"siteOwnerEmail");
                        
                        
                    }
                }
                    if(!"".equals(tempSiteOwnerEmail)){
                        siteOwnerList.add(tempSiteOwnerEmail);
                    } 
                    
            }
        }
        catch(Exception ex){
            System.out.println("***** Exception in List Path ***** " + tempListPath);
            //System.out.println("***** Exception in Page Path ***** " + pagePath);
            System.out.println("***** Exception in Site Owner Email Address ***** " + tempSiteOwnerEmail);
            System.out.println("***** Exception in Site Owner Email ***** " + ex.getMessage());
            sendExceptionMail(ex); 
        }
        return siteOwnerList;         
    }
    public String siteOwnerEmailReverseLoop(Page siteOwnerPage){
        String siteOwnerEmail = "";
        if(null != siteOwnerPage){

            Page parentPage = siteOwnerPage.getParent();
            if(null != parentPage){
                siteOwnerEmail = parentPage.getProperties().get("siteOwnerEmail","");
                if(!"/content/accessmcd".equalsIgnoreCase(parentPage.getPath())){
                    if("".equals(siteOwnerEmail.trim())){
                        Page topParentPage = parentPage.getParent();
                        siteOwnerEmailReverseLoop(topParentPage);    
                    }
                }
            }
        }
        return siteOwnerEmail;
    }


        public String getSiteOwnerInfo(Page siteOwnerPage, String sInfo){
        String siteOwnerInfo = "";
        try{

        if(siteOwnerPage!=null ){
                siteOwnerInfo = siteOwnerPage.getProperties().get(sInfo,"");
         }       


        if("".equals(siteOwnerInfo.trim())){
            Page parentPage = siteOwnerPage.getParent();
            if(parentPage!=null&&!parentPage.equals("/content/accessmcd")){
                siteOwnerInfo = getSiteOwnerInfo(parentPage,sInfo );
            }

        }

        }catch(Exception e){
             System.out.println("Exception in get siteowner info");
        }    
  
        return siteOwnerInfo;
    }


    public String getSiteOwnerName(Page siteOwnerPage){

        String siteOwnerName = "";
        if(null != siteOwnerPage){
            Page parentPage = siteOwnerPage.getParent();
            if(null != parentPage){
                siteOwnerName = parentPage.getProperties().get("siteOwnerName","");
                if(!"/content/accessmcd".equalsIgnoreCase(parentPage.getPath())){
                    if("".equals(siteOwnerName.trim())){
                        Page topParentPage = parentPage.getParent();
                        getSiteOwnerName(topParentPage);    
                    }
                }
            }
        }
        return siteOwnerName;
    }
    
    public ArrayList getEmailLanguage(ArrayList authorsPageList,PageManager pageManager,ScriptHelper mySling){
        ArrayList emailList = new ArrayList();
        ACEConfigDataBean aceBean = null;
        for(int e=0; e<authorsPageList.size(); e++){
            String sitePageKey = "";
            String listPath = authorsPageList.get(e).toString();
            try{
                sitePageKey = aceManager.getACESitePageKey(listPath ,true); 
                aceBean = aceManager.getACEConfigBean(sitePageKey,mySling,observationSession); 
            }catch(Exception eo){
                System.out.println(eo.getMessage()+ "  ...... site skipped");
                continue;
            }

            if(aceBean == null ||sitePageKey.equals(""))
                continue;
            
            if (aceBean.getLanguage()!=null && aceBean.getLanguage().length()>0){
                String lang = aceBean.getLanguage();
                emailList.add(lang);
            }
            aceBean = null;
        }
        HashSet emailLangHS = new HashSet();
        emailLangHS.addAll(emailList);
        emailList.clear();
        emailList.addAll(emailLangHS);
        return emailList;
    }
    
    /* Function to iterate through all the child pages recursively */
    public void scanChildPages(Node theNode)
    {       
        try
        {
            NodeIterator ndItor = theNode.getNodes();
            if (ndItor!=null){
                while (ndItor.hasNext()){
                    Node childNode = ndItor.nextNode();
    
                    if(childNode != null&& childNode.getPath().indexOf(":")< 0) {
                         //checkStatus(childNode);                  
                         scanChildPages(childNode);
                  }
                }
            }
        }
        catch(Exception e)
        {
              ContentExpirationLogger.info(e.getMessage());
              System.out.println(e.getMessage());
              sendExceptionMail(e);
        }       
    }
    
    public void deactivatePage(String pg)
    { 

        try
        {
           if (observationSession!=null) 
               rep.replicate(observationSession,
               com.day.cq.replication.ReplicationActionType.DEACTIVATE, 
               pg);
        }
        catch(Exception e)
        {
              ContentExpirationLogger.info(e.getMessage());
              System.out.println("error to deactivate pg");
              sendExceptionMail(e); 
        }       
    }
   
     public ArrayList<String> getArrayListfromStr(String instr){
     
         ArrayList<String>  myArr = new ArrayList<String>();
         StringTokenizer tokens = new StringTokenizer(instr,",");
         while(tokens.hasMoreTokens()) {
               myArr.add(tokens.nextToken());
         }    
         return myArr; 
     }

    public void unbindRepository() {
        log.info("No Repository is bound or Repository is unbound in ClusterService");
        if (observationSession.isLive())
                    observationSession.logout();        
        observationSession = null;
    }

    /**
     * This method create session with CRX and add listener event with all the
     * possible types.
     * 
     * @param SlingRepository    
     */ 
    protected void bindRepository(SlingRepository repository)
    {       
            this.repository = repository;
            
    }
    
    protected void bindJcrResourceResolverFactory(JcrResourceResolverFactory jcrresourceresolverfactory)
    {
        //System.out.println("****** jcrresourceresolverfactory *******" + jcrresourceresolverfactory);
        this.resolverFactory = jcrresourceresolverfactory;
        //System.out.println("****** this.resolverFactory *******" + this.resolverFactory);
    }

    protected void unbindJcrResourceResolverFactory(JcrResourceResolverFactory jcrresourceresolverfactory)
    {
        if(resolverFactory == jcrresourceresolverfactory)
        {
            this.resolverFactory = null; 
        }
    }
    
    public void bindRepository(String repositoryId, String clusterId, boolean isMaster) {
        //log.error("Bound to Repository {} Node {} (Cluster: {})",new Object[] { (isMaster ? "Master" : "Slave"), repositoryId, clusterId });
        //log.error("******* Is Master Value ********" + isMaster);
        this.isMaster = isMaster;
    }
    
   

}          