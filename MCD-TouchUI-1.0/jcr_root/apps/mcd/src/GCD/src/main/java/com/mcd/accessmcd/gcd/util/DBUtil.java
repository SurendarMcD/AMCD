package com.mcd.accessmcd.gcd.util;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.sql.DataSource;
import com.day.commons.datasource.poolservice.DataSourceNotFoundException;
import com.day.commons.datasource.poolservice.DataSourcePool;
import java.sql.Connection;
import java.sql.SQLException;
import org.apache.sling.api.scripting.SlingScriptHelper;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import javax.mail.event.TransportListener;
import javax.mail.event.TransportEvent;
import com.mcd.accessmcd.ace.manager.ACEMailManager;
import java.io.StringWriter;

public  class DBUtil {
    private static final Logger log = LoggerFactory.getLogger(DBUtil.class);   

    /** @scr.reference policy="static" */
    private DataSourcePool dataSourceService;
    private static ACEMailManager mailConfigProp;
    public DBUtil(SlingScriptHelper sling)
    {
       dataSourceService=sling.getService(DataSourcePool.class);
    } 
    public DBUtil()
    {
    
    } 
    public DataSource getDataSource(String dataSourceName)
     {      
        DataSource dataSource = null; 
        try {
             dataSource = (DataSource) dataSourceService.getDataSource(dataSourceName); 
              //dataSource = (DataSource) dataSourceService.getDataSource(GCDConstants.DATA_SOURCE);
            } catch (DataSourceNotFoundException e){ 
              log.error("Unable to find datasource {}.", dataSourceName, e);  
            }     
            
            return dataSource;   
                                       
      }
          
          
     public  Connection getConnection(String dataSourceName)
     {      
        DataSource dataSource = null; 


         Connection con=null;
        try {
              dataSource = (DataSource) dataSourceService.getDataSource(dataSourceName); 
              con=dataSource.getConnection();
              log.error("****** GCD Connection DBUTIL ******" + con);  
            } catch (DataSourceNotFoundException e){ 
              log.error("Unable to find datasource {}.", dataSourceName, e);  
            } catch(SQLException e)
            {
              log.error("Unable to create connection{}.", dataSourceName, e);  
            }    
            
           return con;   
                                       
      }
  public static void sendExceptionMail(Exception e)
    {
        mailConfigProp = new ACEMailManager("en");
         StringWriter sw = new StringWriter();
        try
        {
           log.error("Inside Send Exception Mail");
            //e.printStackTrace(new PrintWriter(sw));
           sendExceptionEmail(mailConfigProp.getValueForKey("toExceptionGCDAddress"), 
            mailConfigProp.getValueForKey("exceptionSubText"), mailConfigProp.getValueForKey("exceptionBodyText"), 
            mailConfigProp.getValueForKey("mailServer"), 
            mailConfigProp.getValueForKey("fromGCDAddress"),
            mailConfigProp.getValueForKey("fromGCDAddressPersonal")); 
        }
        catch(Exception ex)
        {
            log.error("Inside Send Exception Mail"+ex.getMessage());
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

       public static void sendExceptionEmail(String toAddress, String subject, String bodyText, String mailServer, String fromAddress, String fromAddressPersonal) throws Exception
    {
        try
        {
            Properties properties = new Properties();
            properties.put("mail.smtp.host", mailServer);
            Session session = Session.getDefaultInstance(properties, null);
            Message msg = new MimeMessage(session);
            InternetAddress addressFrom = new InternetAddress(fromAddress, fromAddressPersonal);
            msg.setFrom(addressFrom);
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
            log.error("bodyText:---"+bodyText);
            msg.setSubject(subject);
                msg.setContent(bodyText, "text/html");  
                Transport.send(msg);
            log.error("Exception mail sent.");
        }
        catch(Exception messagingexception)
        {
            log.error("Exception in mail sent."+messagingexception);
        }
    }                                                  
                          
}
