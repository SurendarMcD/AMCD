package com.mcd.util;

import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import javax.mail.Session;
import jxl.*;
import jxl.write.*;
import java.io.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.jcr.Node;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import org.apache.commons.mail.EmailAttachment;
import org.apache.sling.api.resource.ResourceResolver;
import com.mcd.accessmcd.mail.manager.EmailManager;
import com.mcd.accessmcd.mail.bo.EmailDataBean;
import org.apache.commons.mail.MultiPartEmail;
import com.day.cq.mailer.MailService;
import org.apache.sling.api.scripting.SlingScriptHelper;
public class MailNotification{

private static final Logger log = LoggerFactory.getLogger( MailNotification.class);
 

public void sendMail(String mailTo, ArrayList data,String notificationtype,String usertype,SlingScriptHelper sling)
{
    try{
            String fileAttachment="";
            String subject="";
            String bodyText="";
            String fileName="";
            String endText="\n\n****************************************************************************************\nThis is an auto generated mail. Please dont reply to this mail.";
            Date tdate=new Date();
            Properties properties = PropertiesLoader.loadProperties("common.properties");
            String logPath= properties.getProperty("canr_log_path");
            String reportPath= properties.getProperty("canr_report_path");
           if(usertype.equalsIgnoreCase("author") && notificationtype.equalsIgnoreCase("log"))
           
           {
   
             fileAttachment=this.getCANRlogs(logPath, data,usertype);
             fileName="Content_Author_Name_Replacement_Logs_"+tdate.toString()+".xls";
             subject="Author Name/Email Replacement Logs:"+tdate.toString();
             bodyText="Hi,\n\nPlease find the Content Author Name Replacement Utility Logs for Date "+tdate.toString()+endText;
           } 
           
           if(usertype.equalsIgnoreCase("owner") && notificationtype.equalsIgnoreCase("log"))
           
           {
   
             fileAttachment=this.getCANRlogs(logPath, data,usertype);
             fileName="Content_Author_Name_Replacement_Logs_"+tdate.toString()+".xls";
             subject="Author Name/Email Replacement Logs:"+tdate.toString();
             bodyText="Hi,\n\nPlease find the Content Author Name Replacement Utility Logs for Date "+tdate.toString()+endText;
           } 
           
           
           
           //User Report 
           if(usertype.equalsIgnoreCase("author") && notificationtype.equalsIgnoreCase("report"))
           
           {
   
             fileAttachment=this.getCANRreport(reportPath, data,usertype);
             fileName="Content_Author_Name_Replacement_Report_"+tdate.toString()+".xls";
             subject="Author Name/Email Replacement Report:"+tdate.toString();
             bodyText="Hi,\n\nPlease find the Content Author Name Replacement Utility Report for Date "+tdate.toString()+"\nYour action is required Please verify the attachment."+endText;  
           } 
            
            if(usertype.trim().equalsIgnoreCase("owner") && notificationtype.equalsIgnoreCase("report"))
           
           {
   
             fileAttachment=this.getCANRreport(reportPath, data,usertype);
             fileName="Content_Author_Name_Replacement_Report_"+tdate.toString()+".xls";
             subject="Author Name/Email Replacement Report:"+tdate.toString();
             bodyText="Hi,\n\nPlease find the Content Author Name Replacement Utility Report for Date "+tdate.toString()+"\nYour action is required. Please verify the attachment."+endText;  
           } 
                      
            
          EmailAttachment attchment=new EmailAttachment();
          attchment.setPath(fileAttachment);
          attchment.setName(fileName);
          MailService ms = (MailService) sling.getService(MailService.class); 
          MultiPartEmail email = new MultiPartEmail();
          email.setSubject(subject); 
          email.setMsg(bodyText); 
          email.addTo(mailTo);
          email.setFrom("cmsadmin@smtprelay.mcd.com");
          email.attach(attchment);
          ms.sendEmail(email); 

          
         
        }
        catch(Exception e){
            log.error("MailNotification Error generated:"+e.getMessage());
        }
}




public String getCANRlogs(String fileAttachment, ArrayList data,String usertype)
{
         try{
            WritableWorkbook workbook = Workbook.createWorkbook(new File(fileAttachment)); 

            WritableSheet sheet = workbook.createSheet("CANR_Log_File", 0); 
            
            WritableFont writableFont = new WritableFont(WritableFont.TIMES,11,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE, Colour.WHITE);
            WritableCellFormat cellFormat = new WritableCellFormat(writableFont);
            cellFormat.setWrap(true);
            cellFormat.setBackground(Colour.DARK_BLUE);

            WritableFont writableFont1= new WritableFont(WritableFont.TIMES,11,WritableFont.NO_BOLD);
            WritableCellFormat cellFormat1 = new WritableCellFormat(writableFont1);
            cellFormat1.setWrap(true);

            String head="";
            if(usertype.equalsIgnoreCase("author"))
            {
              head="S No,Page Title,Page URL,Previous Author Name,Previous Author Email,New Author Name,New Author Email,Activation Status";
            }

            if(usertype.equalsIgnoreCase("owner"))
            {
              head="S No,Page Title,Page URL,Previous Site Owner Name,Previous Site Owner Email,New Site Owner Name,New Site Owner Email,Activation Status";
            }
            String [] headings=head.split(",");

            String widths = "8,28,40,25,25,25,25,25";
            String [] colWidths = widths.split(",");
               
            for(int i=0;i<headings.length;i++)
            {
               
                Label label1 = new Label(i,0, headings[i], cellFormat);
                sheet.addCell(label1);
                sheet.setColumnView(i,Integer.parseInt(colWidths[i]));
            }
            

   

            
            for(int k=0; k<data.size(); k++) {

                  
              String [] elements=(String [])data.get(k);
             
                 for(int i=0;i<elements.length-1;i++)
                    {
                            Label label1 = new Label(i, k+1, elements[i], cellFormat1);
                            sheet.addCell(label1);
                            sheet.setColumnView(i,Integer.parseInt(colWidths[i]));

                    }
              
         
              }

           
            
            
            workbook.write();
            workbook.close();   
            }catch(Exception e){  log.error("CANR MailNotification Error generated::"+e.getMessage());}

  return fileAttachment;
}  



public String getCANRreport(String fileAttachment, ArrayList data,String usertype)
{
         try{
            WritableWorkbook workbook = Workbook.createWorkbook(new File(fileAttachment)); 
            WritableSheet sheet = workbook.createSheet("CANR_Report_File", 0); 
            
            WritableFont writableFont = new WritableFont(WritableFont.TIMES,11,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE, Colour.WHITE);
            WritableCellFormat cellFormat = new WritableCellFormat(writableFont);
            cellFormat.setWrap(true);
            cellFormat.setBackground(Colour.DARK_BLUE);

            WritableFont writableFont1= new WritableFont(WritableFont.TIMES,11,WritableFont.NO_BOLD);
            WritableCellFormat cellFormat1 = new WritableCellFormat(writableFont1);
            cellFormat1.setWrap(true);

            String head="";
            if(usertype.trim().equalsIgnoreCase("author"))
            {
              head="S No,Page Title,Page URL,Author Name,Author Email,Activation Link";
            }
            if(usertype.trim().equalsIgnoreCase("owner"))
            {
              head="S No,Page Title,Page URL,Site Owner Name,Site Owner Email,Activation Link";
            }
            String [] headings=head.split(",");

            String widths = "8,28,40,25,25,40,20,20,20,10";
            String [] colWidths = widths.split(",");
               
            for(int i=0;i<headings.length;i++)
            {
               
                Label label1 = new Label(i,0, headings[i], cellFormat);
                sheet.addCell(label1);
                sheet.setColumnView(i,Integer.parseInt(colWidths[i]));
            }
            

   

            
            for(int k=0; k<data.size(); k++) {

                  
              String [] elements=(String [])data.get(k);
             
                 for(int i=0;i<elements.length;i++)
                    {  
                    
                       
                           
                         
                            Label label1 = new Label(i, k+1, elements[i], cellFormat1);
                            sheet.addCell(label1);
                             

                            sheet.setColumnView(i,Integer.parseInt(colWidths[i]));
                          
                          
                    }
              
         
              }

            
            
            
            workbook.write();
            workbook.close();   
            }catch(Exception e){  log.error("CANR MailNotification Error generated:"+e.getMessage());}

  return fileAttachment;
}  


}         