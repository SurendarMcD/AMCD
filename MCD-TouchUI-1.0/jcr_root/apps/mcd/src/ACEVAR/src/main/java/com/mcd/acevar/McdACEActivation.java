//ACE Var Listener 
//Judy Zhang, 08/17/2010

package com.mcd.acevar;


import javax.jcr.*;
import javax.jcr.observation.EventIterator;
import javax.jcr.observation.EventListener;

import org.apache.sling.jcr.api.SlingRepository;
import org.osgi.service.component.ComponentContext;

import java.util.*;
import com.mcd.accessmcd.ace.manager.ACEManager;
import com.mcd.accessmcd.ace.bo.ACEConfigDataBean;


/**
 * @scr.component immediate="true" metatype="no"
 
 * scr.service interface="javax.jcr.observation.EventListener"

 * @scr.property name="service.description" value="ACE Listener"

 * @scr.property name="service.vendor" value="Judy Zhang"
 
 */


//comment out scr.service interface="javax.jcr.observation.EventListener"

 
public class McdACEActivation implements EventListener
{
    /** @scr.reference */
    private SlingRepository repository;
    private static Session observationSession;
    private static final String EVENT_ROOT = "/";

     /** 
      * @scr.property label="PCI DataSource" description="Please enter PCI DataSource" valueRef="DEFAULT_PCI_DS" 
      */  
     public static final String PCI_DS = "com.mcd.acevar.PCI_DS";  
     public static final String DEFAULT_PCI_DS = "stgpci";    

     /** 
      * @scr.property label="PCI Default Publish Domain" description="Please enter PCI Default Publish Domain" valueRef="DEFAULT_PUB_DOMAIN" 
      */  
     public static final String PCI_DOMAIN= "com.mcd.acevar.PCI_DOMAIN";  
     public static final String DEFAULT_PUB_DOMAIN = "https://www1.accessmcd.com";     
     
    //    
//    scr.property cardinality="2" name ="DOMAIN_LIST" label="Publish Domain" description="Please enter other PCI publish domain list" valueRef="PUB_DOMAIN_LIST" 
//      
//     public static final String[] PUB_DOMAIN_LIST = {"/accessmcd/apmea/au|http://mcdeagsun107a:4215"};  

     public String mytest="";  
     public String[] testArray= null;
      
    
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
    

    /**
     * This method release session of CRX if alive.
     * 
     * @param SlingRepository   
     */ 
    protected void unbindRepository(SlingRepository repository)
    {
        //logs out the session when repository unbinds 
        if (observationSession.isLive())
                    observationSession.logout();        
        observationSession = null;
    }

    /**
     * This method activate the listener from context.
     * 
     * @param ComponentContext
     */
    protected void activate(ComponentContext componentContext) 
    {
        try
        {
            /*
             * If observationSession is null than get session
             */
            if(observationSession==null)
                observationSession = repository.loginAdministrative(null);
            
            /*
             * Add listener on CRX Repositiry
             */
            observationSession.getWorkspace().getObservationManager().addEventListener(this, getAllTypes(), 
            EVENT_ROOT, true, null, null, true);
            
         Object ds = componentContext.getProperties().get(PCI_DS);  
         if (ds!= null){  
                mytest= ds.toString();  
System.out.println("activate::PCI_DATASOURCE ::"+ds.toString() );             
         }
         
         Object pd = componentContext.getProperties().get(PCI_DOMAIN);  
         if (pd!= null){  
                 //hostDomain = pd.toString();  
System.out.println("activate::PCI hostDomain  ::"+pd.toString() );             
         }
            
//         Object pdl = componentContext.getProperties().get("PUB_DOMAIN_LIST");  
//         if (pdl!= null){  
//                 testArray = pdl;   
//System.out.println("activate::PCI hostDomain  list::"+pdl.toString() );             
//         }

        } 
        catch (RepositoryException re)
        {
        }
        catch (Exception e)
        {
        }
    }

    
    
    /**
     * This method return all the possible event type.
     */
    private static int getAllTypes() 
    {
        return javax.jcr.observation.Event.NODE_ADDED | javax.jcr.observation.Event.NODE_REMOVED | 
        javax.jcr.observation.Event.PROPERTY_ADDED | javax.jcr.observation.Event.PROPERTY_CHANGED | 
        javax.jcr.observation.Event.PROPERTY_REMOVED;
    }
     /**
     * This method id called a new event node is added/deleted or an event node resp.
     * its properties are modified.
     *
     * @param events  jcr events
     */
    public void onEvent(EventIterator events) 
    {
        while (events.hasNext()) 
        {           
            final javax.jcr.observation.Event event = events.nextEvent();
            try 
            {
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
        
            if (event.getPath().toString().startsWith("/var/audit/com.day.cq.replication/content/accessmcd") && 
               (type.equals("NODE_ADDED") || type.equals("NODE_REMOVED"))) 
            {   
                
                if (observationSession == null)
                        observationSession = repository.loginAdministrative(null);      
                        
                        Node rootNode = observationSession.getRootNode();
                        String pageUrl = event.getPath().toString();
                        String pageModUrl = pageUrl.substring(1);       
                        
                        Node node = rootNode.getNode(pageModUrl);
                        String path = node.getPath();
                        Property prop = node.getProperty("cq:type");
                        
                        if(prop.getString().equalsIgnoreCase("Activate")){
                            setACEDate(path);
                        }
                        
            } 
            else 
            {
                
            }
        } catch (Exception ex)
        {
                        
        }
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
        if (observationSession.getWorkspace().getObservationManager() != null) 
        {
            observationSession.getWorkspace().getObservationManager().removeEventListener(this);
        }
        // logout from the session if the session is not null and is alive
        if (observationSession != null && observationSession.isLive()) 
        {
            observationSession.logout();
                observationSession = null;
        }
    }
    
    
    public boolean setACEDate(String handle){
           
            boolean result = true;
            
            
                if (observationSession!=null){
                    try{

System.out.println("setACEDate:::PCI_DATASOURCE ::"+ mytest );             
                    
                        Node nd = observationSession.getRootNode();

                        int last= handle.lastIndexOf("/");
                        int first = handle.indexOf("/content/");
                        
                        String jcrPath=handle.substring(first+1,last)+"/jcr:content";
                        Node jcrNode = nd.getNode(jcrPath);
                        
                        
                        if (jcrNode!=null){ 

                            
                            Calendar currentDate = null;

                            String thePg = handle.substring(first,last);
System.out.println("ACE listener::"+ thePg);
                            //get exp period
                            //String expPeriod = getPropertyValue(thePg);
                            String expPeriod ="6";
                            ACEManager aceManager = new ACEManager(); 

                            if (aceManager.checkSkipNode(thePg)){
System.out.println("pg is skipped");
                                return true;   
                            }
                             
                            
                            String sitePageKey = aceManager.getACESitePageKey(thePg,true); 
                            ACEConfigDataBean aceBean = aceManager.getACEConfigBean(sitePageKey);
                            if( aceBean.getExpirePeriod() !=null && !aceBean.getExpirePeriod().equals(""))
                                expPeriod = aceBean.getExpirePeriod();
                            
System.out.println("expPeriod is :: " + expPeriod);
                        
                            //get current time
                            currentDate = Calendar.getInstance();
//System.out.println("ACE listener::  currentDate is " + currentDate.getTime());

                            // add exp period (default:six months) to the current time
                            currentDate.add(Calendar.MONTH,Integer.parseInt(expPeriod));
                            currentDate.set(Calendar.SECOND,0);
                            
//                            if (!jcrNode.hasProperty("offTime")|| jcrNode.getProperty("offTime").getDate()==null){
                            //offTime is empty, reset offtime, oldofftime and activate                                  
                                
                                jcrNode.setProperty("offTime", currentDate);
                                //add old offtime,09/10/2010
                                //jcrNode.setProperty("oldOffTime", currentDate);
                                //jcrNode.save();
                                observationSession.save();
System.out.println("ACE listener ----"+jcrPath+"----- set new offtime to :: " + currentDate.getTime());


/*                                    
                            }
    
 // if need dummy values for check                      
           //set new off time for nd page if page is activated
           //case 1: no "offtime" set, ==> act +x
           //case 2: has "offtime" set, page active, offitme == oldofftime ===> act +x
           //case 3: has "offtime" set, page active, offtime != oldofftime ===> offtime
           //case 4: has "offtime" set, page not active ===> offtime

                            else{
                            //offtime has value 
                            Calendar newOffTime =  jcrNode.getProperty("offTime").getDate();

                            // check if page is active or not, 09/10/2010
                                boolean isPageActive = false;
                                if (jcrNode.hasProperty("cq:lastReplicationAction")){
                                    String pgStatus = jcrNode.getProperty("cq:lastReplicationAction").getString();
                                    if (pgStatus!=null&& pgStatus.equals("Activate")){
                                        isPageActive = true;
                                    }
                                }
                             if (isPageActive){
                                 Calendar oldOffTime =  null;
                                 if (jcrNode.hasProperty("oldOffTime")&& jcrNode.getProperty("oldOffTime").getDate()!=null){
                                        oldOffTime = jcrNode.getProperty("oldOffTime").getDate();
                                 }
                                 
                                 if (newOffTime.equals(oldOffTime)){

                                     //reset offtime to activation + x month,activate page
                                     jcrNode.setProperty("offTime", currentDate);
                                     jcrNode.setProperty("oldOffTime", currentDate);
                                        jcrNode.save();
                                System.out.println("ACE listener,case 2::  set offtime to ::  " + currentDate.getTime());
                                 }else{
                                     jcrNode.setProperty("oldOffTime", newOffTime);
                                     jcrNode.save();
                                    System.out.println("ACE listener,case 3");
                                 }
                             }else{
                                 jcrNode.setProperty("oldOffTime", newOffTime);
                                 jcrNode.save();
                                System.out.println("ACE listener,case 4 ");
                                 
                             }
                            }
*/                          

                        }
                        
                        
                        }catch(Exception e){
                             result = false;
                             System.out.println("ACE listener:: set time error ::: " +e.toString());
                        }
                }else{
                    result = false;
                }
     
          return result;
    }

/* 
    public String getPropertyValue(String handle)
    {

        String rt ="6";

        ACEManager aceManager = new ACEManager(); 
        String sitePageKey = aceManager.getACESitePageKey(handle ,true); 
        ACEConfigDataBean aceBean = aceManager.getACEConfigBean(sitePageKey);
        if( aceBean.getExpirePeriod() !=null && !aceBean.getExpirePeriod().equals(""))
            rt = aceBean.getExpirePeriod();

        return rt;
    }
    

    public String substringBetween(String str,String start,String end){
        String retString="";
        int startIndex=str.indexOf(start);
        if(startIndex>-1){
            startIndex+=start.length();
            int endIndex=str.indexOf(end);
            if(endIndex>startIndex){
                retString=str.substring(startIndex,endIndex);
            }
        }
        return retString;  
    }

*/ 
}
