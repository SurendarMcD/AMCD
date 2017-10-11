<%@include file="/apps/mcd/global/global.jsp"%> 

<%@ page import="java.util.*,
                 javax.mail.*,
                 javax.mail.internet.*,
                 javax.activation.*,
                 javax.servlet.http.*,
                 javax.mail.Session,
                 jxl.*,
                 jxl.write.*,
                 java.io.*"%> 
<%
   
//File testFile= new File() 
String serverFilesPath = "/app/mcd/cms/wcm1_auth_stg/crx-quickstart/server/files/";
String fileAttachment= serverFilesPath +"output.xls";
out.println(fileAttachment);
   
WritableWorkbook workbook = Workbook.createWorkbook(new File(serverFilesPath+"output.xls")); 
WritableSheet sheet = workbook.createSheet("First Sheet", 0); 

Label label1 = new Label(0, 0, "Author Name");
sheet.addCell(label1); 

Label label2 = new Label(1, 0, "Author Email");
sheet.addCell(label2);

Label label3 = new Label(2, 0, "Page Title");
sheet.addCell(label3);

Label label4 = new Label(3, 0, "Page URL");
sheet.addCell(label4);

Label label5 = new Label(4, 0, "Activation Status");
sheet.addCell(label5);

Label label6 = new Label(5, 0, "Activate/Deactivate Content");
sheet.addCell(label6);

//inserting row
Label label7 = new Label(0, 1, "Neha Bansal");
sheet.addCell(label7);

Label label8 = new Label(1, 1, "neha.bansal@us.mcd.com");
sheet.addCell(label8);

Label label9 = new Label(2, 1,"Testpage");
sheet.addCell(label9);

Label label10 = new Label(3, 1,"/content/accessmcd/corp");
sheet.addCell(label10);

Label label11 = new Label(4, 1,"Activated");
sheet.addCell(label11);

Label label12 = new Label(5, 1,"https://author.accessmcd.com/libs/wcm/core/content/accessmcd/corp");
sheet.addCell(label12);

 
workbook.write();
workbook.close(); 

out.println("***********File created******");


Properties props = System.getProperties();
props.put("mail.host", "smtprelay.mcd.com");
props.put("mail.transport.protocol", "smtp");
Session mailSession = Session.getDefaultInstance(props, null);

MimeMessage msg = new MimeMessage(mailSession);
msg.setFrom(new InternetAddress("subodh.kumar@us.mcd.com"));
msg.setRecipient(Message.RecipientType.TO,new InternetAddress("subodh_kumar@hcl.com")); 
msg.setSubject("TEST MAIL ATTACHMENT");
    
msg.setText("TEST MAIL from STAGING"); 

MimeBodyPart messageBodyPart = new MimeBodyPart();

messageBodyPart.setText("Please do not reply to this email.<BR>Hi");
Multipart multipart = new MimeMultipart();
multipart.addBodyPart(messageBodyPart);

messageBodyPart = new MimeBodyPart();
DataSource source = new FileDataSource(fileAttachment);
messageBodyPart.setDataHandler(new DataHandler(source));
messageBodyPart.setFileName("output.xls"); 
multipart.addBodyPart(messageBodyPart);
msg.setContent(multipart);


/* MimeBodyPart messageBodyPart = new MimeBodyPart();
Multipart multipart = new MimeMultipart();
multipart.addBodyPart(messageBodyPart);

messageBodyPart = new MimeBodyPart();
DataSource source = new FileDataSource(serverFilesPath+"output.xls");
messageBodyPart.setDataHandler(new DataHandler(source));
messageBodyPart.setFileName(serverFilesPath+"output.xls");
multipart.addBodyPart(messageBodyPart);
msg.setContent(multipart); 
  msg.setHeader("X-mailer", "MailNotification v1.0");                 
msg.saveChanges();
*/
Transport.send(msg);
out.println("Mail was sent to ");    


%> 

         



