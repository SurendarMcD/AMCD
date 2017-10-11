<%--
  ==============================================================================
  ACE  Initial Scan
  
  Judy Zhang 8/23/2010 
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                java.lang.*,
                java.util.Date,
                java.util.Calendar,
                java.text.SimpleDateFormat,
                com.mcd.accessmcd.ace.manager.ACEManager,
                com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
                javax.jcr.Session, 
                java.util.Enumeration,
                com.day.cq.security.*"%>
<html>

<head> 

<title>ACE Initial Scan </title>
<script Language="JavaScript">

function isValid() { 
    var myForm=document.acescanform;
    alert (myForm.scanURL.value);
    
    if (myForm.scanURL.value==null||myForm.scanURL.value =="")
    {
        alert ("Please enter a site URL.");
        return false;
    }
}

</script>

</head>
<body >

<table cellpadding="2" cellspacing="5" border=0 align="center" class="text">
    <tr>
        <td>

<%!

//    private OneTimeScanLogger log = OneTimeScanLogger.getInstance("InitialScan");
    private static int changeCount; 
    private static String expTime = "6";
    private static String[] exceptionPath= null; 
    private static String scanFileName ="pubscan.properties";
//    private static String logpath ="/app/mcd/cms/cq5_3/wcm2_auth_dev_53/crx-quickstart/server/files/";
//    private static String dateFormat ="EEE MMM dd HH:mm:ss zzz yyyy";
    private static String logpath ="/app/mcd/cms/cq5_3";
    private static String dateFormat ="dd.MM.yyyy HH:mm:ss";
    private static ACEManager aceManager; 


   public void emptyTree(Page rootPage , Session sen)
    {
    System.out.println("........empty tree start ......");  
    
    if (rootPage != null) {
        // code to retirieve the child pages of the selected page in the itertor object
        Iterator<Page> children = rootPage.listChildren();       
        try {
            while (children.hasNext()) {
                Page child = children.next(); 
                String pathtoinclude=child.getPath();
                String offTime = child.getProperties().get("offTime","");
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction","Deactivate");


//System.out.println("pathtoinclude :: "+ pathtoinclude+".......offTime :: "+offTime+"....lastReplicationAction  ::"+lastReplicationAction );

             
                if("Activate".equals(lastReplicationAction) && null != offTime ) {
                        int first = pathtoinclude.indexOf("/content/");

                        String jcrPath=pathtoinclude.substring(first+1)+"/jcr:content";

                    //clear offtime
                         javax.jcr.Node nd = sen.getRootNode();
                         javax.jcr.Node jcrNode = nd.getNode(jcrPath);
                        Calendar emptyDate = null;
                        jcrNode.setProperty("offTime",emptyDate );
                        jcrNode.save();

System.out.println("clear offTime for Page :: "+ pathtoinclude);
                
                }
        
                emptyTree(child,sen);
            }
        } catch(Exception e) {} 
        
    }

    System.out.println("***************** empty tree Finished *****************");
    }

   public void skipNodeOnly(Page rootPage , Session sen)
    {
    System.out.println("........skip Node only start ......");  
    
    if (rootPage != null) {
        try {
                Page child = rootPage ; 
                String pathtoinclude=child.getPath();
                String offTime = child.getProperties().get("offTime","");
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction","Deactivate");


//System.out.println("pathtoinclude :: "+ pathtoinclude+".......offTime :: "+offTime+"....lastReplicationAction  ::"+lastReplicationAction );

             
                if("Activate".equals(lastReplicationAction) && null != offTime ) {
                        int first = pathtoinclude.indexOf("/content/");

                        String jcrPath=pathtoinclude.substring(first+1)+"/jcr:content";

                    //clear offtime
                         javax.jcr.Node nd = sen.getRootNode();
                         javax.jcr.Node jcrNode = nd.getNode(jcrPath);
                        Calendar emptyDate = null;
                        jcrNode.setProperty("offTime",emptyDate );
                        jcrNode.save();

System.out.println("clear offTime for Page :: "+ pathtoinclude);
                
            }
        } catch(Exception e) {} 
        
    }

    System.out.println("***************** skip Node only Finished *****************");
    }


   public void emptyScan(String pghandle, Session sen)
    {
    System.out.println("........empty scan start ......");  
       try{
            Properties configProp = com.mcd.util.PropertiesLoader.loadProperties("pubscan.properties"); 
            Enumeration e = configProp.propertyNames();


            javax.jcr.Node nd = sen.getRootNode();
         
            // Iterating through all the keys and values available in config property file
            while(e.hasMoreElements()) 
            {
                String rootPageHandle = (String)e.nextElement();
//                String offTimeValue = configProp.getProperty(rootPageHandle);

                String handle = rootPageHandle;
                int first = handle.indexOf("/content/");
                String jcrPath=handle.substring(first+1)+"/jcr:content";
//                String jcrPath=handle +"/jcr:content";
    System.out.println("........jcrPath:: " + jcrPath);              
      
                javax.jcr.Node jcrNode = nd.getNode(jcrPath);
      
                if( jcrNode!=null && jcrNode.hasProperty("offTime"))
                {
                    //clear offtime
                        Calendar emptyDate = null;
                        jcrNode.setProperty("offTime",emptyDate );
                        jcrNode.save();

System.out.println("clear offTime for Page :: "+ jcrPath);
                    
                }else{
                      System.out.println("Page \""+ jcrPath+"\"not found.");
                }
                
            }//end while

        }catch(Exception e){
            System.out.println("Exception in reading properties file :: " + e.getMessage());
        }

    System.out.println("***************** empty Scan Finished *****************");
    }

   public void clearofftime(String pghandle, Session sen)
    {
    System.out.println("........clear off time for......"+ pghandle);                
       try{
            Properties configProp = com.mcd.util.PropertiesLoader.loadProperties("pubscan.properties"); 
            Enumeration e = configProp.propertyNames();


            javax.jcr.Node nd = sen.getRootNode();
         
            // Iterating through all the keys and values available in config property file
            while(e.hasMoreElements()) 
            {
                String rootPageHandle = (String)e.nextElement();
                String offTimeValue = configProp.getProperty(rootPageHandle);

                String handle = rootPageHandle;
                int first = handle.indexOf("/content/");
                String jcrPath=handle.substring(first+1)+"/jcr:content";
      
                javax.jcr.Node jcrNode = nd.getNode(jcrPath);
      
                if( jcrNode!=null && jcrNode.hasProperty("offTime"))
                {
                    //clear offtime
                        Calendar emptyDate = null;
                        jcrNode.setProperty("offTime",emptyDate );
                        jcrNode.save();

System.out.println("clear offTime for Page :: "+ rootPageHandle );
                    
                }else{
                      System.out.println("Page \""+ rootPageHandle +"\"not found.");
                }
                
            }//end while

        }catch(Exception e){
            System.out.println("Exception in reading properties file :: " + e.getMessage());
        }

    System.out.println("*****************clear offtime Finished *****************");
    }
     

    public void scanPubSite(String pghandle, Session sen)
    {
        try
        {
System.out.println("........scan site start ..........." );

            Properties configProp = com.mcd.util.PropertiesLoader.loadProperties("pubscan.properties"); 
            Enumeration e = configProp.propertyNames();


            javax.jcr.Node nd = sen.getRootNode();
         
            // Iterating through all the keys and values available in config property file
            while(e.hasMoreElements()) 
            {
                String rootPageHandle = (String)e.nextElement();
                String offTimeValue = configProp.getProperty(rootPageHandle);

                String handle = rootPageHandle;
                int first = handle.indexOf("/content/");
                String jcrPath=handle.substring(first+1)+"/jcr:content";
       
                javax.jcr.Node jcrNode = nd.getNode(jcrPath);
      
                if( jcrNode!=null) 
                {
//                        changeCount++;
                    //set offtime
                        Calendar realExpDate = null;
                        realExpDate = Calendar.getInstance();
                        SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
                        Date d = sdf.parse(offTimeValue );
                        realExpDate.setTime(d);
 
                        jcrNode.setProperty("offTime",realExpDate);
                        jcrNode.save();

System.out.println("set Page :: "+ rootPageHandle +" offTimeValue :: "+offTimeValue  );
                    
                }else{
//                    log.info("Page \""+ rootPageHandle +"\"not found.");
                      System.out.println("Page \""+ rootPageHandle +"\"not found.");
                }
                
            }//end while

        }catch(Exception e){
            System.out.println("Exception in reading properties file :: " + e.getMessage());
    //        log.info("Exception in reading properties file :: " + e.getMessage());
        }
  //      log.info("***************** One Time Scanner For Remaining US/HO Pages Finished *****************");    
//        cqlog.error("***************** One Time Scanner For Remaining US/HO Pages Finished *****************"); 
System.out.println("***************** One Time Publish Scanner Finished *****************");
    }   
    

   public void scanAuthSite(String pghandle, Session sen)
    {
 System.out.println("........scan Auth Site start ......");                
        
        Writer output = null;
        Writer output1 = null;
        changeCount = 0;

        try
        {
            // files made at the server to record the change 
            File file = new File(logpath + "onetimescanlog");
            File propFile = new File(logpath + "onetimescanprop");
            output = new BufferedWriter(new FileWriter(file));
            output1 = new BufferedWriter(new FileWriter(propFile));
            
             String rootPageHandle = pghandle;
             changeDate(rootPageHandle , expTime, output ,output1,sen);
             initialScan(rootPageHandle , expTime, output,output1,sen);
        }
        catch(Exception e)
        {
//            log.info("Exception in reading properties file :: " + e.getMessage());
        }
        finally
        {
           try{
           if(output!=null)
               output.close();
           if(output1!=null)    
               output1.close();
           }catch(Exception e2){
           }
        }
System.out.println("***************** One Time Author Scanner Finished *****************");
    }



   
  // Function used to iterate through the child pages of a particular node and set their off-time 
    public void initialScan(String currPage, String expirationPeriod, Writer output,Writer output1,Session sen)
    {
        try
        {
            
          javax.jcr.Node nd = sen.getRootNode();

          String handle = currPage;
          int first = handle.indexOf("/content/");
          String pgPath=handle.substring(first+1);
      
          javax.jcr.Node pgNode = nd.getNode(pgPath);

           //if nd page has child, do authOneTimeScanner again
           NodeIterator ndItor = pgNode.getNodes();
          
           if (ndItor!=null){
                while (ndItor.hasNext()) {
                    Node childNode = ndItor.nextNode();
                    String childPath = childNode.getPath();

                    if(childNode != null&& childPath.indexOf(":")< 0) {
                        int flag = 1;

//still need this for cq5????? this is to skip the whole site

                        if(exceptionPath != null)
                        {
                             for(int i = 0; i < exceptionPath.length; i++)
                            {
                                 if(childPath.equals(exceptionPath[i]))
                                 {
                                     flag = 0;
                                 }
                            } 
                        }
                        
                        
                        if(flag == 1)
                        {
                    
                           changeDate(childPath, expirationPeriod, output,output1,sen);
                            
                           if(childNode.hasNodes())
                            {
                                initialScan(childPath, expirationPeriod, output,output1,sen);
                             }
                        }
                      }
                    }   

                 }
           }catch(Exception e){
System.out.println("initialScan Exception  :::"+ e.getMessage());
                            
          }
 
            
    }

   
    // Sets the off-time of a particular page according to the requirement 
    public void changeDate(String currPage, String expPeriod, Writer output,Writer output1,Session sen)
    {
        SimpleDateFormat dateFormatter= new SimpleDateFormat(dateFormat);

        Date offDate = null;
        Date actDate = null;
        String newOffTime ="";
        String lastActivation ="";
        try
        {
         

   
          javax.jcr.Node nd = sen.getRootNode();

          String handle = currPage;
          int first = handle.indexOf("/content/");
          String jcrPath=handle.substring(first+1)+"/jcr:content";
      
          javax.jcr.Node jcrNode = nd.getNode(jcrPath);
          
//added 09/10.to set the dummy value,commented out for now

//           if( jcrNode!=null && jcrNode.hasProperty("offTime") && jcrNode.hasProperty("cq:lastReplicationAction")){
  //                      Calendar extOfftime = jcrNode.getProperty("offTime").getDate();
    //                    jcrNode.setProperty("oldOffTime", extOfftime );
      //                  jcrNode.save();
        //   }
                
      
//for testing only !!!
           if( jcrNode!=null && jcrNode.hasProperty("cq:lastReplicationAction"))
//in real case !!!
//           if( jcrNode!=null && !jcrNode.hasProperty("offTime") && jcrNode.hasProperty("cq:lastReplicationAction"))
            {
                String event = jcrNode.getProperty("cq:lastReplicationAction").getString();
                       
                if((event != null) && (event.equals("Activate")))
                {
               
                    changeCount++;
                    
                    // get the activation date 
                    actDate = jcrNode.getProperty("cq:lastReplicated").getDate().getTime();
                    
                    Calendar activationDate = Calendar.getInstance();
                    activationDate.setTime(actDate);
                    
                    lastActivation = dateFormatter.format(actDate);

System.out.println(currPage);
//System.out.println("     last activation ::"+actDate.toString() );                
                    
                    //set the the off time accordingly
                    Calendar currDate = Calendar.getInstance();
    
                    Calendar cal = Calendar.getInstance();
                    cal.add(Calendar.MONTH,-Integer.parseInt(expPeriod));
                    int diff = cal.getTime().compareTo(activationDate.getTime());

                    if(diff>0)
                    {
                        currDate.add(Calendar.DATE,14);
                        currDate.set(Calendar.SECOND,0);
    
                        offDate = currDate.getTime();

                        newOffTime = dateFormatter.format(offDate);
                    }
                    else
                    {
                        activationDate.add(Calendar.MONTH,Integer.parseInt(expPeriod));
                        activationDate.set(Calendar.SECOND,0);
    
                        offDate = activationDate.getTime();

                        newOffTime = dateFormatter.format(offDate);
                    }

                    if (aceManager.checkSkipNode(currPage)){
                            newOffTime = "";
                    }
/*
                    // Added if condition for skipping node for expiration : 04-09-2010                                                         
                    for (int i = 0; i < skipPageHandle.length; i++) 
                    {                           
                        if(skipPageHandle[i].equals(currPage)){                                                        
                            newOffTime = "";
                        }
                    }   
*/
                    //set offtime
                    if (jcrNode!=null && newOffTime!=null && newOffTime.trim().length()>0 && offDate!=null){
                                //set new exp date
                                Calendar realExpDate = null;
                                realExpDate = Calendar.getInstance();
                                realExpDate.setTime(offDate);
 
                                jcrNode.setProperty("offTime",realExpDate);
//add dummy value, 09/10, commneted out for now
//                        jcrNode.setProperty("oldOffTime", realExpDate);
                                jcrNode.save();


System.out.println("    New Off Time :: "+newOffTime.toString());

                    output.write(changeCount + ". " + currPage + "=" + lastActivation + "," + newOffTime + "\r");
                    output1.write(currPage + "=" + newOffTime + "\r");

                    }
                    

              }
             
            }

        }
        catch(Exception ce)
        {
//            log.info("Off time exception on page :: " + currPage.getHandle() + " :::: Exception :: " +ce.getMessage());
System.out.println("Off time exception on page :: " + currPage + " :::: Exception :: " +ce.getMessage());
        }
                
    }

%>
    
<% 
        try {
            Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
            

            String pmURL=request.getParameter("scanURL");
            if(pmURL==null)pmURL="";  

            Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(pmURL);        

            aceManager = new ACEManager(); 
            Enumeration allURLs = aceManager.getAllSiteKeys();

            while(allURLs.hasMoreElements()){
            
               String theURL = (String)allURLs.nextElement();
System.out.println("theURL ::"+theURL );                    
               
               if(theURL!=null&& !theURL.equals("")){
//               if(theURL!=null&& !theURL.equals("")&& theURL.equals(pmURL)){
                    String sitePageKey = aceManager.getACESitePageKey(theURL ,true); 
System.out.println("sitePageKey ::"+sitePageKey );                    
                    ACEConfigDataBean aceBean = aceManager.getACEConfigBean(sitePageKey);
               
                    dateFormat = aceBean.getDateFormat();
//                    logpath = ACEManager.serverFilesPath;
System.out.println("dateFormat ::"+dateFormat );                    
System.out.println("logpath ::"+logpath );                    
               }
            
            }

            
            String pmScanType=request.getParameter("scanAction");
            if (pmScanType!=null&& pmScanType.equals("Author")){
//                scanAuthSite(pmURL,jcrSession);
            }else if (pmScanType!=null && pmScanType.equals("Scan")){
//                scanPubSite(pmURL,jcrSession);
            }else if (pmScanType!=null && pmScanType.equals("Clear")){
//                emptyScan(pmURL,jcrSession);
//                emptyTree(rootPage ,jcrSession);
//                clearofftime(pmURL,jcrSession);
                skipNodeOnly(rootPage ,jcrSession);
            }

            
            String retString="<H1>ACE Initial Scan </H1><BR>"; 
            retString+="<FORM id=\"acescanform\" action=\"/content/utility/utility/_jcr_content.acescan.html\" method=\"get\" onSubmit=\"javascript:isValid();\">";
            retString+="<B>Scan Site URL:</B><INPUT name=\"scanURL\" value=\""+pmURL+"\"><BR>";
//            retString+="<B>Pick instance:</B><select name=\"scanAction\"><option>Author</option><option>Publish</option><option>Exclude</option></select><BR><BR>";
            retString+="<B>Pick instance:</B><select name=\"scanAction\"><option>Clear</option></select><BR><BR>"; 
            retString+="<BR><INPUT type='submit' value='submit' /><BR></FORM>";
            out.write(retString);
       

        }catch (Exception e) {
            out.write(e.getMessage()); 
            e.printStackTrace();
        }
%>

        </td>
    </tr>
</table>

</body>

</html>

