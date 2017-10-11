package com.mcd.accessmcd.redx;

import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;
import java.lang.Runnable;
import java.text.*;
import java.util.*;
import javax.jcr.*;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.apache.sling.api.resource.ResourceResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.scripting.core.ScriptHelper;
import com.day.cq.jcrclustersupport.ClusterAware;
import com.day.cq.search.Query;
import com.day.cq.search.PredicateGroup;
import com.day.cq.search.result.SearchResult;
import com.day.cq.search.result.Hit;
import com.day.cq.search.QueryBuilder;
import com.day.cq.jcrclustersupport.ClusterAware;
import org.apache.sling.api.resource.*;
import org.apache.commons.mail.HtmlEmail;
import com.day.cq.mailer.MailService;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;

@Component(immediate=true)
@Service(value = Runnable.class)
@Properties({
    @Property( name="scheduler.expression",value="0 0 5 * * ?"),
    @Property(name="scheduler.concurrent", boolValue=false)
})

public class REDXNotification implements Runnable{

    private static final Logger log = LoggerFactory.getLogger(REDXNotification.class);

    @Reference
    private SlingRepository repository;

	@Reference
    private JcrResourceResolverFactory resolverFactory;
    
    private static Session observationSession;

    BundleContext bc = Activator.getBundleContext();
   

    public void run() {
        startScheduler();
        System.out.println("***** REDX Scheduler Finished ******");
        log.error("***** REDX Scheduler Finished ******");
    }

    public void startScheduler(){
    
        try{
                System.out.println("***** REDX Scheduler Started*****");
            	log.error("***** REDX Scheduler Started*****");
                if (observationSession == null)
                    observationSession = repository.loginAdministrative(null);  
                
                ResourceResolver resourceResolver = resolverFactory.getResourceResolver(observationSession); 
                ScriptHelper redxSling = new ScriptHelper(bc,null); 
                
                Map<String, String> map = new HashMap<String, String>();
                QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
                
                //create query description as hash map (simplest way, same as form post)
                map.put("path", "/var/dam/accessmcd");
                map.put("type", "nt:file");
                map.put("1_property","jcr:created");
                
                map.put("daterange.property", "jcr:created");
                        
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                long daysecs = 24*60*60*1000;
                int daycount = 2;
                String startdate = sdf.format((new Date()).getTime()+((1-daycount)*daysecs));
                //System.out.println("Start Date :: " + startdate);
                
                map.put("daterange.lowerBound", startdate);
                //map.put("rangeproperty.upperOperation", "xs:dateTime('2011-03-15T00:00:00.000Z')");
                           
                map.put("orderby", "@jcr:created");
                map.put("orderby.sort", "desc");
                
                // can be done in map or with Query methods
                //map.put("p.offset", "0"); // same as query.setStart(0) below
                map.put("p.limit", "-1"); // same as query.setHitsPerPage(20) below
                
                Query query = builder.createQuery(PredicateGroup.create(map), observationSession);
                //query.setStart(0);
                //query.setHitsPerPage(20);
                
                SearchResult result = query.getResult();
                 
                // paging metadata
                int hitsPerPage = result.getHits().size(); // 20 (set above) or lower
                long totalMatches = result.getTotalMatches();
                long offset = result.getStartIndex();
                long numberOfPages = totalMatches / 20;
         
                // iterating over the results
                ArrayList exceptionList = new ArrayList();
                int count = 1;
                for (Hit hit : result.getHits()) {
                    String path = hit.getPath();
                    ValueMap properties1 = hit.getProperties();
                    /*for(Map.Entry<String, Object> e : properties1.entrySet()) {
                        String key = e.getKey();
                        Object value = e.getValue();
                    }
                    out.println("<hr>");*/
                    String createdDate = properties1.get("jcr:lastModified","");
                    try{
                        Node rootNode = resourceResolver.getResource(path.replaceAll("/var","/content")).adaptTo(Node.class);
                    }   
                    catch(Exception ex1){
                        count++;
                        exceptionList.add(path.replaceAll("/var","/content"));
                        System.out.println("Path :: " + path.replaceAll("/var","/content"));
                        continue;
                    } 
                } 
                if(exceptionList.size() > 0){
                    Boolean emailSend = sendREDXNotifiction(exceptionList,redxSling);
                    if(emailSend){
                        System.out.println("***** REDX Email Notification Sent Successfully *****");
                    }
                }
           }catch(Exception e){
                   
           }finally{
                
                if (observationSession.isLive())
                    observationSession.logout();        
                observationSession = null;
           }
    
    }

    public boolean sendREDXNotifiction(ArrayList exceptionList,ScriptHelper sling){
        boolean flag=false;
        try
        {
            MailService mailService = sling.getService(MailService.class);
            HtmlEmail email = new HtmlEmail();
            
            StringBuffer stringbuffer = new StringBuffer();
            stringbuffer.append("<p>The assets listed below have to be reviewed as these are not processed completely.<br/></p><p><strong>ACTION IS REQUIRED NOW:</strong><ul><li>Use the list below to identify the un processed assets.</li><li>Review the assets for relevance and make any necessary changes.</li><li>After the assets are deleted from /var/dam, Please upload assets again into dam </li></ul></p>");
            stringbuffer.append("<p>NOTE: If no action is taken assets will remain into repository in unprocessed state.</p>");
            stringbuffer.append("<br><strong>ASSETS TO REVIEW:</strong>");
            stringbuffer.append("<ul>");
            for(int i = 0; i < exceptionList.size(); i++){
                stringbuffer.append("<li>"+(String)exceptionList.get(i)+"</li>");
            }
            stringbuffer.append("</ul>");
            
            /*for(int i = 0; i < arraylist.size(); i++){
                email.addTo((String)arraylist.get(i));
            }*/
            email.addTo("digvijay.tomar@us.mcd.com");
            email.setFrom("noreply@us.mcd.com");
            email.setSubject("ACTION REQUIRED - DAM RED X Issue");
            email.setHtmlMsg(stringbuffer.toString());
             
            mailService.sendEmail(email);
            flag=true;  // setting true for successful sending the mail // 
        }
        catch(Exception messagingexception)
        {
            log.error("Exception caught DAM REDX EmailNotification sendEmail::::" + messagingexception); 
            flag=false;
            
        }
        return flag;
    }
    
    protected void unbindRepository(SlingRepository repository) {
        log.info("No Repository is bound or Repository is unbound in ClusterService");
        if (observationSession.isLive())
                    observationSession.logout();        
        observationSession = null;

        this.repository = null;
    }

    /**
     * This method create session with CRX and add listener event with all the
     * possible types.
     * 
     * @param SlingRepository    
     */ 
    protected void bindRepository(SlingRepository repository){       
            this.repository = repository;
    }
    
    protected void bindJcrResourceResolverFactory(JcrResourceResolverFactory jcrresourceresolverfactory){
        this.resolverFactory = jcrresourceresolverfactory;
    }

    protected void unbindJcrResourceResolverFactory(JcrResourceResolverFactory jcrresourceresolverfactory){
        if(resolverFactory == jcrresourceresolverfactory){
            this.resolverFactory = null; 
        }
    }

   

}     