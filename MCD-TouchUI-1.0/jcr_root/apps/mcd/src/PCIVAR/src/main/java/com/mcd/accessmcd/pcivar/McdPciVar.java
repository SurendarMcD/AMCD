package com.mcd.accessmcd.pcivar;

import javax.jcr.*;

import org.apache.sling.jcr.api.SlingRepository;
import org.osgi.service.component.ComponentContext;
import javax.jcr.observation.EventIterator;
import javax.jcr.observation.EventListener;
 
 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.*;

import com.day.commons.datasource.poolservice.DataSourceNotFoundException; 
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory; 

import  com.day.cq.security.*;
import com.day.crx.JcrConstants;
import java.text.SimpleDateFormat;
import org.apache.sling.commons.osgi.OsgiUtil;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service
@Properties({
    @Property( name="service.description",value="PCI Listener"),
    @Property( name="service.vendor",value="MCD"),
    @Property( name="pciDefaultDomain",label="PCI Default Domain",description=""),
    @Property( name="pciDomainMap",label="PCI Domain Map", cardinality=10, description="Mapping of paths to domains"),
    @Property( name="pciDatasource", label="PCI Datasource", description="")
})


public class McdPciVar implements EventListener
{
   private static final Logger log = LoggerFactory.getLogger(McdPciVar.class);
   
    @Reference
    private com.day.commons.datasource.poolservice.DataSourcePool dataSourceService;

    @Reference
    private com.day.cq.security.UserManagerFactory userManagerFactory;
    
    @Reference
    private SlingRepository repository;

   
    private static Session observationSession;
    //wei- commented the following line based on Erik's suggestion.
   // private static final String EVENT_ROOT = "/";
    private static final String EVENT_ROOT="/var/audit/com.day.cq.replication/content/accessmcd";
    private static UserManager umgr;


    //added domain mapping , 11/15/2010, JZ


    //dev
    public String PCI_DEFAULT_DOMAIN = "";
    private String hostDomain = PCI_DEFAULT_DOMAIN;
    private String PCI_DATASOURCE="";
    private HashMap<String,String> PCI_DOMAINS=new HashMap<String, String>();
    /*
    static{
        PCI_DOMAINS.put("/accessmcd/apmea/au","https://www-dev.accessmcd.com");
    }
    */
     /*
*/
/*
    //stg
    public static final String PCI_DEFAULT_DOMAIN = "https://52pub.int.accessmcd.com";
    private static String hostDomain = PCI_DEFAULT_DOMAIN;
    private static String PCI_DATASOURCE="stgpci";
    private static HashMap<String,String> PCI_DOMAINS=new HashMap<String, String>();
    static{
        PCI_DOMAINS.put("/accessmcd/apmea/au","http://mcdeagsun107b:4218");
    }


    
    //prd
    public static String PCI_DEFAULT_DOMAIN = "https://www.accessmcd.com";
    private static String hostDomain = PCI_DEFAULT_DOMAIN;
    private static String PCI_DATASOURCE="prodpci";
    private static HashMap<String,String> PCI_DOMAINS=new HashMap<String, String>();
    static{
        PCI_DOMAINS.put("/accessmcd/apmea/au","https://mcsource.mcdonalds.com.au");
    }
 
*/

    //private static String[] DEFAULT_GRPS = {"DEFAULT-Employee","DEFAULT-Crew","DEFAULT-Franchisee_Restaurant_Manager","DEFAULT-Owner_Operator","DEFAULT-McOpCo_Restaurant_Manager","DEFAULT-Suppliers_Vendors"};
    private static HashMap<String,String> PCI_AUD_IDS=new HashMap<String,String>();
    

    static{
        PCI_AUD_IDS.put("DEFAULT-Employee","1");
        PCI_AUD_IDS.put("DEFAULT-Crew","2");
        PCI_AUD_IDS.put("DEFAULT-Franchisee_Restaurant_Manager","3");
        PCI_AUD_IDS.put("DEFAULT-Owner_Operator","4");
        PCI_AUD_IDS.put("DEFAULT-McOpCo_Restaurant_Manager","5");
        PCI_AUD_IDS.put("DEFAULT-Suppliers_Vendors","6");
        
        //add two new groups, judy , 09/2012
        PCI_AUD_IDS.put("default-agency","7");
        PCI_AUD_IDS.put("default-franchisee_office_staff","8");
        

    }
    
    
    public static final String PCI_INSERT_QUERY = "INSERT INTO PCI_ACTV (ID,REQ_TYP,URI,CAT_ID,IMG_URL,MEDIA_URL,ALT_URL,AUD_IDS,VIEW_CD,TITLE,DS,LNCH_TYP,PUBL_DT,EID,FIRST_NA,LAST_NA,MAIL_AD,ISRT_DT) VALUES (SEQ_PCI_ACTV.NEXTVAL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE)";

    
	/**
     * This method activate the listener from context.
     * 
     * @param ComponentContext
     */
    protected void activate(ComponentContext componentContext) 
    {

        try
        {
            System.out.println("PCIVAR:activate1"); 
            /*
             * If observationSession is null than get session
             */
            if(observationSession==null)
                observationSession = repository.loginAdministrative(null);

            /*
             * Add listener on CRX Repositiry
             */
            observationSession.getWorkspace().getObservationManager().addEventListener(this, getAllTypes(), EVENT_ROOT, true, null, null, true);
            System.out.println("PCIVAR:activate2");
            configure(componentContext.getProperties());
            System.out.println("PCIVAR:activate3");
        } 
        catch (RepositoryException re)
        {
        }
        catch (Exception e)
        {
        }
    }

    
   protected void configure(Dictionary<?, ?> properties) {
    
    System.out.println("PCIVAR:configure");
    
    this.PCI_DEFAULT_DOMAIN = OsgiUtil.toString(properties.get("pciDefaultDomain"), "");
    System.out.println("PCIVAR:configure00");
    this.hostDomain = PCI_DEFAULT_DOMAIN;
    this.PCI_DATASOURCE=OsgiUtil.toString(properties.get("pciDatasource"), "");
    //System.out.println("getting pcidomains");
    System.out.println("PCIVAR:configure1");
    String[] pcidomains= OsgiUtil.toStringArray(properties.get("pciDomainMap"));
    System.out.println("pcidomains.length:"+pcidomains.length);
    System.out.println("PCIVAR:configure2");
    for(int ix=0;ix<pcidomains.length;ix++){
        String pathdomain=pcidomains[ix];
        ArrayList listdomains=processMultipleValues(pathdomain);
        String path=(String)listdomains.get(0);
        String domain=(String)listdomains.get(1);
        //System.out.println("adding:"+path+","+domain);
        this.PCI_DOMAINS.put(path,domain);

    }
    System.out.println("PCIVAR:configure3");
  }
    
    /**
     * This method return all the possible event type.
     */
    private static int getAllTypes() 
    {
        //wei - commented out the following lines based by Erik's suggestion.
        //return javax.jcr.observation.Event.NODE_ADDED | javax.jcr.observation.Event.NODE_REMOVED | 
       // javax.jcr.observation.Event.PROPERTY_ADDED | javax.jcr.observation.Event.PROPERTY_CHANGED | 
        //javax.jcr.observation.Event.PROPERTY_REMOVED;
        return javax.jcr.observation.Event.NODE_ADDED | javax.jcr.observation.Event.NODE_REMOVED;
    }
     /**
     * This method id called a new event node is added/deleted or an event node resp.
     * its properties are modified.
     *
     * @param events  jcr events
     */
    public void onEvent(EventIterator events) 
    {
        System.out.println("PCIVAR:onEvent1");
        while (events.hasNext()) 
        {           
            final javax.jcr.observation.Event event = events.nextEvent();
            try 
            {
                System.out.println("PCIVAR:onEvent2");  
                switch (event.getType())
                {
                    case javax.jcr.observation.Event.NODE_ADDED:doActionOnEvent(event, "NODE_ADDED");break;
                    case javax.jcr.observation.Event.NODE_REMOVED:doActionOnEvent(event, "NODE_REMOVED");break;
                    case javax.jcr.observation.Event.PROPERTY_CHANGED:doActionOnEvent(event, "PROPERTY_CHANGED");break;
                    case javax.jcr.observation.Event.PROPERTY_ADDED:doActionOnEvent(event, "PROPERTY_ADDED");break;
                    case javax.jcr.observation.Event.PROPERTY_REMOVED:doActionOnEvent(event, "PROPERTY_REMOVED");break;
                    default:
                }
            } catch (Exception re) {
                        
            }
        }
    }
    
    
    public void doActionOnEvent(javax.jcr.observation.Event event, String type) 
    {
        try 
        {   
            //if (event.getPath().toString().startsWith("/var/audit/com.day.cq.replication/content/accessmcd") && (type.equals("NODE_ADDED") || type.equals("NODE_REMOVED"))) 
            //{ 
            System.out.print("PCIVAR:doActionOnEvent");  
                if (observationSession == null)
                        observationSession = repository.loginAdministrative(null);  
                        umgr = userManagerFactory.createUserManager(observationSession);
                        
                        Node rootNode = observationSession.getRootNode();
                        String pageUrl = event.getPath().toString();

                        //updated for multiple domains, JZ, 11/23/2010
                        hostDomain = "";
                        Iterator my_domain_it = PCI_DOMAINS.keySet().iterator();
                           
                        while(my_domain_it.hasNext()){        
                            String my_domain_key = (String)(my_domain_it.next());
                            //System.out.println("my_domain_key:"+my_domain_key);
                            if(pageUrl.indexOf(my_domain_key)>0){
                                hostDomain = (String)PCI_DOMAINS.get(my_domain_key);
                            }       
                        }
                        if(hostDomain.equals(""))hostDomain = PCI_DEFAULT_DOMAIN;
                        
//System.out.print("PCI hostdomain  --------------" + hostDomain);                            


                        String pageModUrl = pageUrl.substring(1);       
                        
                        Node node = rootNode.getNode(pageModUrl);
                        
                        String path = node.getPath();

                        javax.jcr.Property prop = node.getProperty("cq:type");
                        boolean test = false;

                        
                        if(prop.getString().equalsIgnoreCase("Delete")){
                            System.out.print(path+ "::::: DELETE ::::PCI");                         
                            test = sendDeactivateMessage(path);
                        }else{
                             if(processTransportMessage(path))
                             {
                                  if(prop.getString().equalsIgnoreCase("Activate")){
                                        System.out.print(" :::: ACTIVATE ::::");                          
                                        int last= path.lastIndexOf("/");
                                        int first = path.indexOf("/content/");
//                                        int lgth = "/content".length();
                                        
                                        String pciPath=path.substring(first+1,last)+"/jcr:content/pci";
                                        Node pciNode = rootNode.getNode(pciPath);
                                        System.out.print("path::::::"+pciPath);
                                        // default values
                                        String p="";
                                        if (pciNode.hasProperty("PublishToPCI") && pciNode.getProperty("PublishToPCI")!=null)
                                            p=pciNode.getProperty("PublishToPCI").getString();
                                        String s="";
                                        if (pciNode.hasProperty("SentToPCI") && pciNode.getProperty("SentToPCI")!=null)
                                            s=pciNode.getProperty("SentToPCI").getString();
                                        
                                    //   System.out.println("pciPath=" + pciPath + " s=" + s + " path=" + path);    
                                       if (p!=null&& p.equalsIgnoreCase("yes"))
                                                test = sendActivateMessage(path);
                                       else if(p!=null&& p.equals("")&& s.equalsIgnoreCase("yes"))
                                                test = sendDeactivateMessage(path);
                                       
                                           
                                    }else if(prop.getString().equalsIgnoreCase("Deactivate")){
                                        //System.out.print(" :::: DEACTIVATE :::::");   
                                        test = sendDeactivateMessage(path);
                                    }

                             }else{
                                 System.out.println(":::: no need to process ::: PCI "+path);
                             }
                        }
                        
                        System.out.println("........PCI process results ...." + test);

                        
          /*  } 
            else 
            {
                
            }*/
        } catch (Exception ex)
        {
                System.out.println("........PCI process exception ...." + ex);
                        
        }
    }

     protected ArrayList processMultipleValues(String s)
        {
            ArrayList arraylist = new ArrayList();
            if(s == null || s.trim().equals(""))
                return arraylist;
            for(StringTokenizer stringtokenizer = new StringTokenizer(s, "|"); stringtokenizer.hasMoreTokens(); arraylist.add(stringtokenizer.nextToken()));
            return arraylist;
        }
    
    protected boolean processTransportMessage(String handle)
    {
    //System.out.println("process transport message");
    if (handle==null || handle.equals(""))
        return false;

    Node nd = null;
    //judy, need to change this
    String mediaDirPrefix="/media/dir";

    if (observationSession!=null){
       try{
        
            nd = observationSession.getRootNode();

            int last= handle.lastIndexOf("/");
            int first = handle.indexOf("/content/");
            int lgth = "/content".length();
            String pageHandle=handle.substring(first+lgth,last);
            
            String jcrPath=handle.substring(first+1,last)+"/jcr:content/pci";
            Node jcrNode = nd.getNode(jcrPath);
            
            if (jcrNode == null) return false;

            // default values
            String p="";
            if (jcrNode.hasProperty("PublishToPCI") && jcrNode.getProperty("PublishToPCI")!=null)
                p=jcrNode.getProperty("PublishToPCI").getString();
            String s="";
            if (jcrNode.hasProperty("SentToPCI") && jcrNode.getProperty("SentToPCI")!=null)
                s=jcrNode.getProperty("SentToPCI").getString();

            System.out.println("PublishToPCI ...." + p);
            //System.out.println("SentToPCI ...." + s);
            
            if(pageHandle.startsWith(mediaDirPrefix))return false;//don't process pages in the media dirs

            //wei - commented the following line
            //ArrayList publishToPCI = processMultipleValues(p);
            boolean previouslySentToPCI=true; //assume to be true by default
            if(s!=null){
                if(s.equals("")){
                    previouslySentToPCI=false;
                }
            }

          //  System.out.println("previouslySentToPCI ...." + previouslySentToPCI);
            //wei - checking if publish to PCI equals to yes
            if(previouslySentToPCI || (p.equals("yes"))) {
            //if(previouslySentToPCI || (publishToPCI.size()>0  && publishToPCI.get(0).toString().equals("yes"))) {
                return true;
            }
        }
        catch(Exception e)
        {
            return false;
        }
      }
     return false;
    }
    
    /**
     * This method removes the type of CRXEventListener and logouts
     * from the available session.
     * 
     * @throws Exception if any error occurs while removing listener or logging
     *         out of the session.
     */
    protected void deactivate(ComponentContext componentContext) throws RepositoryException 
    {               
        // remove the listener if the observationManager is not null
//        if (observationSession.getWorkspace().getObservationManager() != null) 
  //      {
    //        observationSession.getWorkspace().getObservationManager().removeEventListener(this);
      //  }
        // logout from the session if the session is not null and is alive
        if (observationSession != null && observationSession.isLive()) 
        {
            observationSession.logout();
                observationSession = null;
        }
    }


    public String getCUG(Node currentNode){
        StringBuffer temp = new StringBuffer();
        try{
            
            Node nd = observationSession.getRootNode();

            String handle = currentNode.getPath();
            int first = handle.indexOf("/content/");

            String jcrPath=handle.substring(first+1)+"/jcr:content";
            
            Node jcrNode = nd.getNode(jcrPath);
            
            if (jcrNode == null) 
            {
                System.out.println("Node not found for CUG info.");
                return "";
            }

            // default values
            String cugEnalbed="false";
            if (jcrNode.hasProperty("cq:cugEnabled") && jcrNode.getProperty("cq:cugEnabled")!=null)
                cugEnalbed=jcrNode.getProperty("cq:cugEnabled").getString();

            //System.out.println("CUG enabled :: " + cugEnalbed);

            Value[] cugs=null;
            if (cugEnalbed.equalsIgnoreCase("true")){
//                String cugPrinciples="";
                if (jcrNode.hasProperty("cq:cugPrincipals") && jcrNode.getProperty("cq:cugPrincipals")!=null)
                {

                        try {
                            cugs=jcrNode.getProperty("cq:cugPrincipals").getValues();
                            
                        }catch (ValueFormatException e){
                            cugs = new Value[1];
                            cugs[0] = jcrNode.getProperty("cq:cugPrincipals").getValue();
                        }
                    
                        for (int i=0; i<cugs.length ;i++ ){
                            temp.append(cugs[i].getString()+"|");
                        }
                }
                     
            }

            //System.out.println("CUG principles :: " + temp);

        }catch(Exception e){e.printStackTrace();}

            
        return temp.toString();
        }

    public boolean hasReadAccess(Node currentNode) 
    {
                    try{
//                        Node root = observationSession.getRootNode();
                        com.day.crx.CRXSession session = (com.day.crx.CRXSession)currentNode.getSession();
                            String path = currentNode.getPath();
                            session.checkPermission(path, "read");
                            if(currentNode.hasNode(JcrConstants.JCR_CONTENT)) {
                                String contentNodePath = path + "/" + "jcr:content";
                                session.checkPermission(contentNodePath, "read");
                            }
                      }catch(Exception  e){
                               System.out.println("hasReadAccess Path not found Exception " + e.getMessage());
                              
                            return false;
                              
                    }
             return true;
        
    }
    
    


    public boolean sendActivateMessage(String handle)
    {
    System.out.println("sending activate message...");
        if (handle==null || handle.equals(""))
            return false;

    
        Node nd = null;
        if (observationSession!=null){
        

        Connection connection = null;
        PreparedStatement pstmt = null;
//        DateFormat publishDateFormat=new SimpleDateFormat("MM/dd/yyyy h:mma");

        
        try { 
            nd = observationSession.getRootNode();

            int last= handle.lastIndexOf("/");
            int first = handle.indexOf("/content/");
            int lgth = "/content".length();
            String pageHandle=handle.substring(first+lgth,last);
            
            String docURL=hostDomain+pageHandle+".html";

            String jcrPath=handle.substring(first+1,last)+"/jcr:content";
            Node jcrNode = nd.getNode(jcrPath);
            
            if (jcrNode==null) return false;

            
            String imageURL = "";
            String mediaURL = "";
            String altURL = "";
            String audienceIDs= "";

//          String mediaDirPrefix=getConfigValue(config,"MediaDir");
            String mediaDirPrefix="MediaDir";
            String mediaDirPrefixNoContent=mediaDirPrefix;
            if(mediaDirPrefixNoContent.startsWith("/content/")){
                mediaDirPrefixNoContent=mediaDirPrefixNoContent.substring(8);
            }
                
            // default values
            String defaultDocTitle="";
            if (jcrNode.hasProperty("jcr:title") && jcrNode.getProperty("jcr:title")!=null)
                defaultDocTitle=jcrNode.getProperty("jcr:title").getString();
                
            String defaultDescription="";
            if (jcrNode.hasProperty("jcr:description") && jcrNode.getProperty("jcr:description")!=null)
                defaultDescription=jcrNode.getProperty("jcr:description").getString();
           
            if (jcrNode.hasProperty("redirectTarget") && jcrNode.getProperty("redirectTarget")!=null){
                altURL=jcrNode.getProperty("redirectTarget").getString();
                //System.out.println("altURL:"+altURL);
                if(altURL.startsWith("/content/")){
                    altURL=hostDomain+altURL.substring("/content".length());
                    if(!altURL.endsWith(".html") && !altURL.endsWith(".htm"))
                        altURL=altURL+".html";
                }
           }
           
        boolean getParent = true;
        ArrayList arraylist = new ArrayList();
        String thePath = handle.substring(first+1,last)+"/";
    
        while (getParent){
            int lastSlash = thePath.lastIndexOf("/");
            if(lastSlash>0)thePath=thePath.substring(0,lastSlash);           
            Node theNode = nd.getNode(thePath);
            arraylist = processMultipleValues(getCUG(theNode));
            if (arraylist.size()>0 || thePath.length()< 10 ){ 
                getParent = false;
            }

        }
        
        String strComma="";
        for(int i = 0; i < arraylist.size(); i++){
            String audID=(String)arraylist.get(i);
            if(PCI_AUD_IDS.get(audID)!=null){
                audienceIDs += strComma + (String)PCI_AUD_IDS.get(audID);
                strComma=",";                   
            }
        }

        
//set default
        if (audienceIDs.trim().length()<1)
            audienceIDs = "1";
        
            //************* POST TO PCI
            String eid = "";
            
            if (jcrNode.hasProperty("cq:lastModifiedBy") && jcrNode.getProperty("cq:lastModifiedBy")!=null)
               eid = jcrNode.getProperty("cq:lastModifiedBy").getString();
            System.out.print("IDDDDDDDDDD"+eid);
            String authorEID=eid;
            String authorFirstName="";
            String authorLastName="";
            String authorEmail="";
            

            if (umgr.get(eid) !=null ){
                User user = (User)umgr.get(eid);
//Judy, profile doesn't work with new auto create
//              if (user.getProfile().getGivenName()!=null)
    //              authorFirstName=user.getProfile().getGivenName();
        //      if (user.getProfile().getFamilyName()!=null)
            //      authorLastName=user.getProfile().getFamilyName();
                //    authorEmail=user.getProfile().getPrimaryMail();

//              if (user.getProperty("rep:fullname")!=null)
  //                auto_fullname=user.getProperty("rep:fullname");
                
                if (user.getProperty("familyName")!=null)
                    authorLastName=user.getProperty("familyName");

                if (user.getProperty("givenName")!=null)
                    authorFirstName=user.getProperty("givenName");

                if (user.getProperty("rep:e-mail")!=null)
                    authorEmail =user.getProperty("rep:e-mail");
                 System.out.println(authorEmail);
            }

            
            //System.out.println("authorEID ...." + authorEID);
            //System.out.println("authorFirstName ...." + authorFirstName);
            //System.out.println("authorLastName ...." + authorLastName);
            //System.out.println("authorEmail ...." + authorEmail);

            String pciPath=jcrPath+"/pci";
            Node pciNode = nd.getNode(pciPath);
            
            if (pciNode == null) return false;

            //imageURL = hostDomain + pageHandle + "/jcr:content/PCIImage/jcr:content";
            String pciImagePath=pciPath+"/PCIImage";
            Node pciImageNode=null;
            try{
                pciImageNode=nd.getNode(pciImagePath);
            }catch(Exception e){
//              System.out.println("PCIImage is null");
            }
            //only send imageURL if an image exists
            if(pciImageNode!=null)
            {
                imageURL = pageHandle + "/_jcr_content/pci/PCIImage";
            }else if (pciNode.hasProperty("PCIImageFile")&& pciNode.getProperty("PCIImageFile")!=null){
                    imageURL = pciNode.getProperty("PCIImageFile").getString();
            }
            //System.out.println("PCIImage :: " + imageURL);
            
            //wei - Todo: change the following logic
            //Iterator pci = jcrNode.getNodes("entry*");
                        
            Iterator pci = pciNode.getNodes("entry*");
  
            //get DB connection
            if(pci.hasNext()){
                System.out.println("getting data connection for "+PCI_DATASOURCE);
                final DataSource dataSource = (DataSource)dataSourceService.getDataSource(PCI_DATASOURCE);
                connection = dataSource.getConnection(); 
                //judy, still need this?
                connection.setAutoCommit(false);
                pstmt = connection.prepareStatement(PCI_INSERT_QUERY);
               
            }
                
            while (pci.hasNext()){
               
                Node ndi = (Node)pci.next();
                String category="";
                
                if (!ndi.hasProperty("Category")) return false;
                
                if (ndi.getProperty("Category")!=null)
                    category=ndi.getProperty("Category").getString();
                if(category.endsWith("*")){//a Top Story Category
                    category=category.substring(0,category.length()-1);
                }
               
                String title="";
                if (ndi.hasProperty("Title") && ndi.getProperty("Title")!=null)
                    title=ndi.getProperty("Title").getString();
                if(title.equals(""))title=defaultDocTitle;
                
                String description="";
                if (ndi.hasProperty("Description") && ndi.getProperty("Description")!=null)
                    description=ndi.getProperty("Description").getString();
                if(description.equals(""))description=defaultDescription;
                
              //System.out.println("category ...." + category);
              //System.out.println("title ...." + title);
              //System.out.println("description ...." + description);

                Value[] views=null;
                String[] viewsStrArr=null;
                
                if (ndi.hasProperty("View") && ndi.getProperty("View")!=null){
                    
                    try {
                        views=ndi.getProperty("View").getValues();
                        for (int i=0; i<views.length; i++) {
                            viewsStrArr[i] = views[i].getString();         
                        }
                        
                    }catch (ValueFormatException e){
                
                      String viewsStr = ndi.getProperty("View").getValue().getString();
                      viewsStrArr = viewsStr.split(",");
                   }
                }
                 //System.out.println("viewsStrArr length=");
                 //System.out.println("viewsStrArr length=" + viewsStrArr.length);
                
                    
                    for (int a=0;a< viewsStrArr.length;a++){
                       String view = viewsStrArr[a];
                           
                       if(view!=null && !view.equals("")){
                        //displaytype , 02/2010
                        //displayType can be '','newwin', 'shownav', or both 
                        //'' = 0
                        //'shownav' = 1
                        //'newwin' = 2
                        // 'newwin' & 'shownav' = 3
                    
                        String displayType="0";
                        int displayTypeNum=0; // default
                        if (ndi.hasProperty("DisplayType") && ndi.getProperty("DisplayType")!=null){
                            try {
                                  Value[] displayTypeValues=ndi.getProperty("DisplayType").getValues();

                                  for(int ix=0;ix<displayTypeValues.length;ix++){
                                          String displayValue=displayTypeValues[ix].getString();
                                          if(displayValue.equals("shownav")){
                                                 displayTypeNum+=1;
                                          }
                                          if(displayValue.equals("newwin")){
                                                 displayTypeNum+=2;
                                          }
                                   }//end for

                              }catch (ValueFormatException e){
                                 //wei - commented out the following block, pass in value like shownav,newwin
                                 /*  String displayValue = ndi.getProperty( "DisplayType").getString();
                                   if(displayValue.equals("shownav")){
                                         displayType="1";
                                   }
                                   if(displayValue.equals("newwin")){
                                         displayType="2";
                                   }
                                   */
                                   String displayValueStr = ndi.getProperty("DisplayType").getString();
                                   String[] temp;
                                   temp = displayValueStr.split(",");
                                   for (int i=0; i<temp.length; i++) {
                                       if(temp[i].equals("shownav")){
                                           displayTypeNum+=1;
                                       }
                                       if(temp[i].equals("newwin")){
                                           displayTypeNum+=2;
                                       }
                                   }
                            }//end try
                            displayType=Integer.toString(displayTypeNum);    
                        }//end if
                                    
                        //publishDate
                        java.util.Date publishDate=new java.util.Date();
                        String publishDateStr = "";
                                           
                        try {
                            if (ndi.hasProperty("PublishDate") && ndi.getProperty("PublishDate")!=null)
                                publishDate=ndi.getProperty("PublishDate").getDate().getTime();
                        } catch (Exception e) {
                            //wei - adding following block - convert String to Date
                            if (ndi.hasProperty("PublishDate") && ndi.getProperty("PublishDate")!=null)
                                publishDateStr = ndi.getProperty("PublishDate").getString();
                                //System.out.println("publishDateStr=" + publishDateStr);
                                //SimpleDateFormat formatter = new SimpleDateFormat("E MMM dd yyyy HH:mm:ss Z");
                                SimpleDateFormat formatter = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss z");
                               //SimpleDateFormat formatter = new SimpleDateFormat("E MMM dd yyyy HH:mm:ss");
                                
                                formatter.setTimeZone(TimeZone.getTimeZone("UTC"));  

                                //java.util.Calendar cal = Calendar.getInstance(new SimpleTimeZone(6, "GMT"));
                                //java.util.Calendar cal = Calendar.getInstance();
                                //formatter.setCalendar(cal);
                                
                                //formatter.setTimeZone(TimeZone.getTimeZone("UTC"));  

                                publishDate = formatter.parse(publishDateStr);
                                //System.out.println("publishDate=" + publishDate.toString());
                        }
                  
                        java.sql.Timestamp pubSQLDat=new java.sql.Timestamp(publishDate.getTime());

                        //System.out.println("view ...." + view);
                        //System.out.println("displayType ...." + displayType);
                        //System.out.println("pubSQLDat ...." + pubSQLDat.toString());
                        
                        pstmt.setString(1,"A");
                        pstmt.setString(2,docURL.trim());
                        pstmt.setInt(3,Integer.valueOf(category).intValue());
                        pstmt.setString(4,imageURL.trim());
                        pstmt.setString(5,mediaURL.trim());
                        pstmt.setString(6,altURL.trim());
                        pstmt.setString(7,audienceIDs.trim());
                        pstmt.setString(8,view);
                        pstmt.setString(9,title);
                        pstmt.setString(10,description);
                        pstmt.setString(11,displayType);
                        pstmt.setTimestamp(12,pubSQLDat);
                        pstmt.setString(13,authorEID);
                        pstmt.setString(14,authorFirstName);
                        pstmt.setString(15,authorLastName);
                        pstmt.setString(16,authorEmail);
                        
                        pstmt.executeUpdate();
                        connection.commit();
                        System.out.print("Committeddd   ");
                    }//end if view
            }//end while views
 
                    pciNode.setProperty("SentToPCI", "yes");
                    observationSession.save();
 System.out.print("11111111111111");
            }//end while pci                
       
        }catch (DataSourceNotFoundException e ){
            System.out.println("A:: PCI Datasource not found ::" + e.getMessage());
          System.out.print("222222222222");
        }catch (SQLException e){
            System.out.println("A:: getConnection():SQLException  Message:" + e.getMessage());
         System.out.print("333333333333333333");
        }catch (Exception e){
             System.out.println("A:: Exception  Message:" + e.getMessage()); System.out.print("33333333333333333");
        }finally{
           try{
               if (pstmt != null )System.out.print("44444444444");
                   pstmt.close();
               if (connection != null)System.out.print("55555555555555555");
                   connection.close();
           }catch(Exception e){System.out.print("6666666666666666");
             System.out.println("A:: cleanup :SQLException  Message:" + e.getMessage());
           }
        }

       
                return true;
        }else{ System.out.print("falseeeeeeeeeeeeeeeeeeeee");
            return false;
        }
         
    }
    
    
    public boolean sendDeactivateMessage(String handle)
{
//System.out.println("sending deactivate message...");
    Node nd = null;
    if (observationSession!=null){

    Connection connection = null;
    PreparedStatement pstmt = null;
    
    try { 
            nd = observationSession.getRootNode();

            int last= handle.lastIndexOf("/");
            int first = handle.indexOf("/content/");
            String pageHandle=handle.substring(first + "/content".length(),last);

        String docURL=hostDomain+pageHandle+".html";
        String jcrPath=handle.substring(first+1,last)+"/jcr:content/pci";
        Node jcrNode = nd.getNode(jcrPath);

        final DataSource dataSource = (DataSource)dataSourceService.getDataSource(PCI_DATASOURCE);
        connection = dataSource.getConnection(); 
        connection.setAutoCommit(false);
        pstmt = connection.prepareStatement(PCI_INSERT_QUERY);

        Date publishDate = new Date();
        java.sql.Time pubSQLDat=new java.sql.Time(publishDate.getTime());

        pstmt.setString(1,"D");
        pstmt.setString(2,docURL.trim());
        pstmt.setInt(3,0);
        pstmt.setString(4,"");
        pstmt.setString(5,"");
        pstmt.setString(6,"");
        pstmt.setString(7,"");
        pstmt.setString(8,"");
        pstmt.setString(9,"");
        pstmt.setString(10,"");
        pstmt.setString(11,"");
        pstmt.setTime(12, pubSQLDat);
        pstmt.setString(13,"");
        pstmt.setString(14,"");
        pstmt.setString(15,"");
        pstmt.setString(16,"");
        pstmt.executeUpdate();
        connection.commit();
 
        jcrNode.setProperty("SentToPCI", "");
        observationSession.save();

    }catch (DataSourceNotFoundException e ){
     System.out.println("Deactive:: PCI Datasource not found ::" + e.getMessage());
    }catch (SQLException e){
         System.out.println("Deactive:: getConnection():SQLException  Message:" + e.getMessage());
    }catch (Exception e){
         System.out.println("Deactive:: Exception  Message:" + e.getMessage());
    }finally{
       try{
           if (pstmt != null )
               pstmt.close();
           if (connection != null)
               connection.close(); 
       }catch(SQLException e){
         System.out.println("Deactive:: cleanup :SQLException  Message:" + e.getMessage());
       }
    }

            return true;
    }else{
        return false;
    }
} 

	/**
     * This method create session with CRX and add listener event with all the
     * possible types.
     * 
     * @param SlingRepository   
     */ 
    protected void bindRepository(SlingRepository repository)
    {       
            System.out.println("PCIVAR:bindRepository"); 
            
            this.repository = repository;
            
            
    }
    

    /**
     * This method release session of CRX if alive.
     * 
     * @param SlingRepository   
     */ 
    protected void unbindRepository(SlingRepository repository)
    {
        //logs out the session when repository unbinds 
        if (observationSession!=null && observationSession.isLive())
                    observationSession.logout();        
        observationSession = null;

        repository = null;
    }

    protected void bindDataSourceService(com.day.commons.datasource.poolservice.DataSourcePool dataSourceService)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.dataSourceService = dataSourceService;

    }   
    protected void unbindDataSourceService(com.day.commons.datasource.poolservice.DataSourcePool dataSourceService)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        dataSourceService = null;
    }
	protected void bindUserManagerFactory(UserManagerFactory userManagerFactory)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.userManagerFactory = userManagerFactory;
            
    }   
    protected void unbindUserManagerFactory(UserManagerFactory userManagerFactory)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        userManagerFactory = null;
    }


} 

 