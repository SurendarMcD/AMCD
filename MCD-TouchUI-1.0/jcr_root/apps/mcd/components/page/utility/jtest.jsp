<%--
  ==============================================================================
  Judy's Utility Page
  1. list tags
  
  Judy Zhang 7/12/2011 
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
                javax.jcr.Session, 
                java.util.Enumeration,
                com.day.cq.security.util.SecurityUtil,
                com.day.cq.security.*"%>
<html>

<head> 

<title> Judy Utility Page </title>
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
    private static String logpath ="/app/mcd/cms/fs05/wcm1_auth_prod/crx-quickstart/server/files/";
    
    private static String dateFormat ="dd.MM.yyyy HH:mm:ss";
    
    private String td(String val){
            return "<TD>"+val+"</TD>";
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

    System.out.println("***************** empty Scan Finished *****************");
    }
     

    public void scanPubSite(String pghandle, Session sen)
    {
        try
        {

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
    

   public void listTags(javax.servlet.jsp.JspWriter output1 , String pghandle, Session sen)
    {
System.out.println("***************** List Tags Start *****************");
        
        Writer output2 = null;

        try
        {
            File tagFile = new File(logpath + "mytags");
            output2 = new BufferedWriter(new FileWriter(tagFile));
            
             String rootPageHandle = pghandle;
             changeCount=0;

             output1.println("<TABLE align=\"center\" border=1>");
             output1.println("<TR>");
             output1.println(td("<B>#</b>"));
             output1.println(td("<B>Page URL </b>"));
             output1.println(td("<B>Tags</b>"));
             output1.println("</TR>"); 
             
             output2.write("============="+pghandle+"============="+"\r");
             
             

             getTagFromPage(rootPageHandle ,output1 ,output2, sen);
             initialScan(rootPageHandle , output1 ,output2,sen);

             output2.write("============= End of Getting Tags ============="+"\r");

        }
        catch(Exception e)
        {
//            log.info("Exception in reading properties file :: " + e.getMessage());
        }
        finally
        {
           try{
           if(output2!=null)    
               output2.close();
           }catch(Exception e2){
           }
        }
System.out.println("***************** List Tags Finished *****************");
    }

//    public void initialScan(String currPage, Writer output1,Session sen)
    public void initialScan(String currPage, javax.servlet.jsp.JspWriter output1 ,Writer output2, Session sen)
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
                    
                           getTagFromPage(childPath, output1,output2,sen);
                            
                           if(childNode.hasNodes())
                            {
                                initialScan(childPath, output1,output2,sen);
                             }
                        }
                      }
                    }   

                 }
           }catch(Exception e){
System.out.println("listtags initialScan Exception  :::"+ e.getMessage());
                            
          }
 
            
    }

   


    public void getTagFromPage(String currPage, javax.servlet.jsp.JspWriter output1,Writer output2, Session sen)
    {

        String myTag ="";
        
        try
        {
   
          javax.jcr.Node nd = sen.getRootNode();

          String handle = currPage;
          int first = handle.indexOf("/content/");
          String jcrPath=handle.substring(first+1)+"/jcr:content";
      
          javax.jcr.Node jcrNode = nd.getNode(jcrPath);
          
          //test
           StringBuffer temp = new StringBuffer();

            Value[] myVals=null;
                if (jcrNode!=null && jcrNode.hasProperty("cq:tags") && jcrNode.getProperty("cq:tags")!=null)
                {

                        try {
                            myVals=jcrNode.getProperty("cq:tags").getValues();
                            
                        }catch (ValueFormatException e){
                            myVals= new Value[1];
                            myVals[0] = jcrNode.getProperty("cq:tags").getValue();
                        }
                    
                        for (int i=0; i<myVals.length ;i++ ){
                            temp.append(myVals[i].getString()+"|");
                        }
                }
                     
          
          //end test
          
      
                       
                if((temp!= null) )
                {
                    changeCount++;

                    //output.write(changeCount + " " + currPage + " " + myTag + "\r");
                    output2.write(changeCount + " " + currPage + " " + temp.toString()+ "\r");
                    
                    output1.println("<TR>");
                    output1.println(td(Integer.toString(changeCount)));
                    output1.println(td(currPage));
                    output1.println(td(temp.toString()));
                    output1.println("</TR>");


                    }
                    

             


        }
        catch(Exception ce)
        {
System.out.println("Off time exception on page :: " + currPage + " :::: Exception :: " +ce.getMessage());
        }
                
    }
%>
    
<% 
        try {
            Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
            
            

            String pmURL=request.getParameter("scanURL");
            
            String pmScanType=request.getParameter("scanAction");
            if (pmScanType!=null&& pmScanType.equals("ListTags")&& pmURL!=null){
                listTags(out, pmURL,jcrSession);
            }else if (pmScanType!=null && pmScanType.equals("CheckNode")){
                scanPubSite(pmURL,jcrSession);
            }else if (pmScanType!=null && pmScanType.equals("Publish")){
                scanPubSite(pmURL,jcrSession);
            }else if (pmScanType!=null && pmScanType.equals("Clear")){
                emptyScan(pmURL,jcrSession);
            }
            

            
            String retString="<H1> Judy's Utility Page </H1><BR>"; 
            retString+="<FORM id=\"acescanform\" action=\"/content/utility/utility/_jcr_content.jtest.html\" method=\"get\" onSubmit=\"javascript:isValPlease ;\">";
            retString+="<B>Please enter Site URL:</B><INPUT name=\"scanURL\" value=\""+pmURL+"\"><BR>";
            retString+="<B>I would like to :</B><select name=\"scanAction\"><option>ListTags</option><option>FindNode</option><option>Clear</option></select><BR><BR>";
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


