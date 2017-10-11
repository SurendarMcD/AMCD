package com.mcd.cq.util.search;
/*
 * A listener to request indexing of activated DAM Assets
 * Jan 24, 2014 Erik Wannebo
 */
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

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory; 

import  com.day.cq.security.*;
import com.day.crx.JcrConstants;
import java.text.SimpleDateFormat;
import org.apache.sling.commons.osgi.OsgiUtil;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.GetMethod;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import javax.servlet.Servlet;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Properties({
    @Property( name="service.description",value="Ultraseek Listener"),
    @Property( name="service.vendor",value="MCD"),
    @Property( name = "ultraseekServer", value="Ultraseek Server"),
    @Property( name = "indexServer", value="CQ Publish Server server/port")
})

@SuppressWarnings("serial")

  
public class McdUltraseekVar implements EventListener
{
   //private static final Logger log = LoggerFactory.getLogger(McdUltraseekVar.class);
   

    @Reference
    private SlingRepository repository;

   
    private static Session observationSession;

    private static final String EVENT_ROOT="/var/audit/com.day.cq.replication/content/dam/accessmcd";
 
    
    public String urlstr = "";
    public String indexserver = "";

  
    
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
        if (observationSession!=null && observationSession.isLive())
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
            observationSession.getWorkspace().getObservationManager().addEventListener(this, getAllTypes(), EVENT_ROOT, true, null, null, true);

            configure(componentContext.getProperties());
        } 
        catch (RepositoryException re)
        {
        }
        catch (Exception e)
        {
        }
    }

    
   protected void configure(Dictionary<?, ?> properties) {

    
    this.urlstr= OsgiUtil.toString(properties.get("ultraseekServer"), "");
    this.indexserver = OsgiUtil.toString(properties.get("indexServer"), "");
    
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
     System.out.println("Ultraseek Listener: doActionOnEvent");

      if (observationSession == null)
        observationSession = this.repository.loginAdministrative(null);

      Node rootNode = observationSession.getRootNode();
      String pageUrl = event.getPath().toString();
      String pageModUrl = pageUrl.substring(1);

      Node node = rootNode.getNode(pageModUrl);

      String name = node.getName();
      String path = node.getPath();

      javax.jcr.Property prop = node.getProperty("cq:type");

      System.out.println("........posting to Ultraseek ,path:: " + path);
      boolean test = sendUltraseekAddURLMessage(path);
      System.out.println("........posting to Ultraseek ,result :: " + test);
    }
    catch (Exception rootNode)
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

        if (observationSession != null && observationSession.isLive()) 
        {
            observationSession.logout();
                observationSession = null;
        }
    }



public boolean sendUltraseekAddURLMessage(String handle)
  {
    System.out.println("indexserver: "+indexserver );
    if ((indexserver != null) && (indexserver != ""))
    {

      String actionURL = "/help/addurlgo.html";
      

      int last = handle.lastIndexOf("/");
      //int first = handle.indexOf("/content/") + "/content/".length();
      int first = handle.indexOf("/content/");
      handle = handle.substring(first, last);
      if(indexserver.endsWith("/"))indexserver=indexserver.substring(0,indexserver.length()-1);
      String addURL = indexserver + handle ; 
      addURL=java.net.URLEncoder.encode(addURL);
      System.out.println("encoded url:"+addURL);
      try
      {
        Thread.sleep(10000L);
      }
      catch (InterruptedException localInterruptedException) {
      }
      String s1 = sendHttpMessage(actionURL, addURL);

      return true;
    }

    System.out.println("SpiderServer not configured.");
    return false;
  }

  private String sendHttpMessage(String s,  String addURL)
  {
    String prot = "http";

    String userName = "admin";
    String passWord = "admin";
    try {
      int i;
      String retstr = sendGetRequest(urlstr + s + "?url=" + addURL);
      return retstr; 
     
      
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }
    return "";
  }
  
  public String sendGetRequest(String url)
    throws Exception
    
  {
    HttpClient client = new HttpClient();
    HttpMethod method = new GetMethod(url);
    System.out.println("Ultraseek Agent: url:"+url);
    try {
      String str1;
      int state = client.executeMethod(method);
      int retrycnt = 0;
      while (state == 302) {
        if (retrycnt >= 20)
          break;
        Header locationHeader = method.getResponseHeader("location");
        String location = "";
        if (locationHeader != null) {
          location = locationHeader.getValue();
        }

        state = client.executeMethod(method);
        ++retrycnt;
      }
      BufferedReader sbr = new BufferedReader(new InputStreamReader(method.getResponseBodyAsStream()));
      String curLine = null;
      StringBuffer sb = new StringBuffer();
      while ((curLine = sbr.readLine()) != null)
        sb.append(curLine);

      return sb.toString();
    } catch (Exception e) {
    }
    finally {
      method.releaseConnection();
    }
    return "";
  }


  public String substringBetween(String str, String start, String end)
  {
    String retString = "";
    int startIndex = str.indexOf(start);
    if (startIndex > -1) {
      startIndex += start.length();
      int endIndex = str.indexOf(end);
      if (endIndex > startIndex)
        retString = str.substring(startIndex, endIndex);
    }

    return retString;
  }

} 

