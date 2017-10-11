<%@ include file="/apps/mcd/global/global.jsp"%>
<%@page import = "com.mcd.accessmcd.dam.damUtil"%>  

<%@page import = "java.util.HashSet,
                  java.util.HashMap,
                  java.util.ArrayList,
                  java.util.Iterator,
                  java.util.Set,
                  java.net.URLDecoder,
                 javax.mail.Session,
                 javax.mail.Address,
                 javax.mail.internet.MimeMessage,
                 javax.mail.internet.InternetAddress,
                 javax.mail.internet.MimeBodyPart,
                 javax.mail.Multipart,
                 javax.mail.Transport,
                 javax.mail.Message,
                 javax.mail.MessagingException,
                 javax.mail.internet.MimeMultipart
                  "%>   
                  
<%@ page import="com.day.cq.security.User" %> 
<%@ page import="com.day.cq.security.Group" %>
<%@ page import="com.day.cq.security.UserManager,com.day.cq.security.Authorizable" %>
<%@ page import="com.day.cq.security.UserManagerFactory" %>     
<%@page import="org.apache.sling.jcr.api.SlingRepository"%>                     

<%!

    HashSet<String> assetCUG = new HashSet<String>();
    
    public HashSet getCUG(SlingHttpServletRequest slingRequest,String nodePath) throws RepositoryException
    {
            String node = nodePath.trim(); 
            boolean temp = false;
            //out.write(nodePath);
            
                             
               
            Node assetJcrNode = null;
            HashSet<String> assetCUG = new HashSet<String>();           
            
            try
            {          
              if(node.endsWith("/content/dam/accessmcd"))    
              {
                  //out.write("TESTddd");
                  //do nothing
              }  
              else
             {   
                 //out.write("11111");
                     
                 if(slingRequest.getResourceResolver().getResource(node+"/jcr:content") != null)
                 {    
                 assetJcrNode = slingRequest.getResourceResolver().getResource(node+"/jcr:content").adaptTo(Node.class);  
      //          HashSet<String> assetCUG = new HashSet<String>();
                              
                    if(assetJcrNode.hasProperty("cq:cugPrincipals"))
                    {                        
                        Value[] pageCUG = assetJcrNode.getProperty("cq:cugPrincipals").getValues();
                        for(int i=0;i<pageCUG.length;i++)
                        {
                            assetCUG.add(pageCUG[i].getString());
                        }                    
                    }
                    else
                    {
                     //out.write("22222");
                        //Node assetNode = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);  
                        Node parentNode = assetJcrNode.getParent().getParent();
                        assetCUG = getCUG(slingRequest,parentNode.getPath());
                        
                        
                    } 
                   }  
                   else
                   {
                    //out.write("NUll mil gya");
                     Node n = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);
                     assetCUG = getCUG(slingRequest,n.getParent().getPath());
                   } 
                               
               }              
            }
            catch(ValueFormatException e)
            {
                    try
                    {      
                        if(assetJcrNode.hasProperty("cq:cugPrincipals"))
                        {
                       
                            assetCUG.add(assetJcrNode.getProperty("cq:cugPrincipals").getString());        
                        
                        }                                            
                    }
                    catch(Exception ex)
                    {
                        e.printStackTrace();
                    } 
            }
            catch(Exception e)
            {
              //out.write("Null mila");
         
                 e.printStackTrace();
            }
            
            
        return assetCUG;             
    }
    
    
    public void sendMail(String senderEmail,String recipientEmail,String message) throws MessagingException
    {
        Properties props = System.getProperties();
        props.put("mail.host", "smtprelay.mcd.com");
        props.put("mail.transport.protocol", "smtp");
        
        javax.mail.Session mailSession = Session.getDefaultInstance(props, null);
        
        MimeMessage msg = new MimeMessage(mailSession);
        msg.setFrom(new InternetAddress(senderEmail));
        
        /*Address[] recipientAddress = new Address[recipientEmail.size()];
    
        for(int i=0;i<recipientEmail.size();i++)
        {
            recipientAddress[i] = new InternetAddress((String)recipientEmail.get(i));
        }*/
    
        
        msg.setRecipient(Message.RecipientType.TO,new InternetAddress(recipientEmail)); 
        //msg.setRecipients(Message.RecipientType.TO,recipientAddress); 
                      
        msg.setSubject("ACTION REQUIRED - Security group adjustment required","utf-8");
               
        MimeBodyPart messageBodyPart = new MimeBodyPart();
        Multipart multipart = new MimeMultipart();
        
        /*String html = "Hello,<br><br>I am trying to activate a page that is open to&nbsp;{" + pageGroups +"},"
                      +"&nbsp;but your asset&nbsp;" + assetTitle + "&nbsp;is not open to&nbsp;{" + missingGroups +"}.&nbsp;"
                      +"Please alter the security setting on your asset to include the missing group(s) or contact me to discuss how we can resolve this issue."
                      +"<br><br> Thank you.";*/
                      
                      
        messageBodyPart.setContent(message, "text/html");
        multipart.addBodyPart(messageBodyPart);
        msg.setContent(multipart); 
        Transport.send(msg);
  
    }
    
    
%>
<%

String rootPath = (String)request.getParameter("rootPath");
damUtil damUtilObject = new damUtil();
String errorMsg = "";
String sendEmail = "";



if( (!(rootPath != null)) || (!(rootPath.length() > 0)) )
{
    rootPath = "";
}   


if(rootPath.startsWith("/content/accessmcd"))
{
    HashSet<String> assetLinks = new HashSet<String>(); 
    HashSet<String> pageCUG = new HashSet<String>(); 
    HashMap<String,String> mismatchedAssets = new HashMap<String,String>();
    String asset = "";
    String missingGroups = "";
    String audienceGroups = "";
    String separator = "";
    String pageSeparator = "";
    String pageTitle = "";
    String pageAuthorEmail = "";    
    
    Node pageNode = slingRequest.getResourceResolver().getResource(rootPath+"/jcr:content").adaptTo(Node.class);  
    
    if(pageNode.hasProperty("jcr:title"))
    {
        pageTitle = pageNode.getProperty("jcr:title").getString();        
             
    }   
    if(pageNode.hasProperty("authorEmail"))
    {
        pageAuthorEmail = pageNode.getProperty("authorEmail").getString();        
             
    }   
    
    
    assetLinks = damUtilObject.getReferredAssets(resourceResolver,rootPath);    
    pageCUG = getCUG(slingRequest,rootPath.trim());  
 
    if(pageCUG.size()>0)
    {          
        Iterator<String> assetLink = assetLinks.iterator();
    
        while(assetLink.hasNext())
        {     
            asset = assetLink.next();
            String updatedLink = URLDecoder.decode(asset);  
           //out.println("TEST111"+updatedLink+"<br>" );
            //Node assetNode = slingRequest.getResourceResolver().getResource(updatedLink).adaptTo(Node.class);              
            assetCUG = getCUG(slingRequest,updatedLink);      
            
            //out.println("CUG Size"+assetCUG.size()+"<br>" );
            missingGroups = "";            
            separator = "";
            pageSeparator = "";
            audienceGroups = "";
            Iterator<String> pageItr = pageCUG.iterator();       
            while(pageItr.hasNext())
            {
                audienceGroups += pageSeparator;  
                //separator = "";             
                //out.println("TEST222222222"+updatedLink );

                String group = pageItr.next();
                audienceGroups += group;
                if(!assetCUG.contains(group))
                {        
                 // out.println("TEST"+updatedLink+"<br>" );       
                  missingGroups += separator; 
                  missingGroups += group;
                  mismatchedAssets.put(updatedLink,missingGroups);
                  separator = ",";
                }
                
                pageSeparator = ",";
            }
            
        }
        
     }   
    
     //out.println("Audience"+audienceGroups );
     //out.println("Size"+mismatchedAssets.size());    
    errorMsg = "The permissions for this page and some of the assets on it do not match."
    +"Please change the security settings on your page or contact the following asset owner(s) to resolve the issue.";
    
%>
        <form name=frmEmailAction method="GET" target="">
        <input type=hidden name="hidSendEmail" value="no" >
        <input type=hidden name="hidEmailsubject" value="<%=rootPath%>" >   
        
        <table width="90%" align="center" border="0"   cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <%=errorMsg%>
                </td>
                
            </tr> 
        </table>
        &nbsp;
        <table width="100%" align="center" style="margin-left:150px;">
            <tr>
                
                <td>
                    <u>USER</u>
                </td>
                <td>
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>    
                <td>
                    <u>ASSET</u>
                </td>
            </tr>
      
<%    
    
    Set<String> keys = mismatchedAssets.keySet();
    
    Iterator<String> keysItr = keys.iterator();
    String authemail = "";
    String assetTitle = "";
 
    while(keysItr.hasNext())
    {
        authemail = "";
      
        String key = keysItr.next();
      
   //     key=key.replaceAll("<p></p>","");
        
       //out.println("Key:"+key+"b" + key.length()); 
        if(slingRequest.getResourceResolver().getResource(key)!=null)    
         { 
            Node assetNode = slingRequest.getResourceResolver().getResource(key).adaptTo(Node.class);  
            
            Property primaryType = assetNode.getProperty("jcr:primaryType");
            String assetType  = primaryType.getString();
            if(assetType.equals("dam:Asset"))
            {
                Node assetMetaNode = slingRequest.getResourceResolver().getResource(key+"/jcr:content/metadata").adaptTo(Node.class); 
                
                if(assetMetaNode.hasProperty("dc:title"))
                {
                    assetTitle = assetMetaNode.getProperty("dc:title").getString();        
                                 
                }else
                {
                     assetTitle = assetNode.getName(); 
                }
                
                if(assetMetaNode.hasProperty("authemail"))
                {
                    authemail = assetMetaNode.getProperty("authemail").getString();        
                                 
                }  
                
           }else if(assetType.equals("sling:OrderedFolder"))
           {
               assetTitle = assetNode.getName();
           }
             
%>
        
         <tr>
        
               <td>            
                    <%= damUtilObject.getAssetOwnerName(slingRequest,key) %>
               </td>    
                <td>
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </td>          
               <td>            
                    <%=assetTitle%>
               </td>
           </tr>
            
<%     }
    }    
%> 

 </table>
</form>
        
<%        

}
else if(rootPath.startsWith("/content/dam/accessmcd"))
{          
        HashSet<String> assetReferences = new HashSet<String>();
        HashSet<String> referredCUG = new HashSet<String>();
        HashSet<String> referredPageCUG = new HashSet<String>();
        HashSet<String> assetCUG = new HashSet<String>();
        HashMap<String,String> mismatchedPages = new HashMap<String,String>();
        String referredPage = "";    
        String missingGroups = "";
        String audienceGroups = "";
        String separator = "";
        String assetSeparator = "";
        String assetTitle = "";
        String assetAuthEmail = "";
        

        Node damNode = slingRequest.getResourceResolver().getResource(rootPath).adaptTo(Node.class); 
        Property primaryType = damNode.getProperty("jcr:primaryType");
        String assetType  = primaryType.getString();
        if(assetType.equals("dam:Asset"))
        {
            Node damMetadataNode = slingRequest.getResourceResolver().getResource(rootPath+"/jcr:content/metadata").adaptTo(Node.class);       
            
            if(damMetadataNode.hasProperty("dc:title"))
            {
                assetTitle = damMetadataNode.getProperty("dc:title").getString();        
                             
            }else
            {
                 assetTitle = damNode.getName(); 
            }
            
            if(damMetadataNode.hasProperty("authemail"))
            {
                assetAuthEmail = damMetadataNode.getProperty("authemail").getString();        
                             
            }  
            
       }else if(assetType.equals("sling:OrderedFolder"))
       {
           assetTitle = damNode.getName();
       }
        
 
        assetCUG = getCUG(slingRequest,rootPath);                     
        assetReferences = damUtilObject.getAssetReferences(slingRequest,damNode.getPath());        
        Iterator<String> referItr = assetReferences.iterator();    
        
        Iterator<String> assetItr = assetCUG.iterator();    
        
        while(assetItr.hasNext())
        {
            audienceGroups += assetSeparator;
            audienceGroups += assetItr.next();
            assetSeparator = ",";
        }
           
        //out.println("Asset CUG"+audienceGroups);
           
        while(referItr.hasNext())
        {
            referredPage = referItr.next();                         
                        
            Node pageNode = slingRequest.getResourceResolver().getResource(referredPage  + "/jcr:content").adaptTo(Node.class);
                if(pageNode.hasProperty("cq:lastReplicationAction"))
                {
                        String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                        if(pageStatus.equals("Activate"))
                        {                                                                                                                                           
                            referredCUG = getCUG(slingRequest,referredPage);   

                            if(referredCUG.size()>0)
                            {                
                                Iterator<String> pageCUGItr = referredCUG.iterator();
                                missingGroups = "";
                                separator = "";

                                while(pageCUGItr.hasNext())
                                {     
                                    String group = pageCUGItr.next();          
                                    if(!assetCUG.contains(group))
                                    {         
                                        missingGroups += separator;    
                                        missingGroups += group;                                 
                                        mismatchedPages.put(referredPage,missingGroups);
                                        separator = ",";
                                    }
                                }  
                            } 
                        }
                }                
        }   
     
     
     //out.println("Size"+mismatchedPages.size());
     errorMsg = "You are attempting to activate an asset that is less restricted than one or more pages that refer to it."
                +" Some users may not be able to access these pages to see the assets."
                +" Please change the security groups on your page or contact the following page owner(s) to resolve this issue.";
     
%>
        <form name=frmEmailAction method="GET" target="">
        <input type=hidden name="hidSendEmail" value="no" >
        <input type=hidden name="hidEmailsubject" value="<%=rootPath%>" >   
        <table width="90%" align="center" border="0"   cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <%=errorMsg%>
            </td>
        </tr> 
        <table width="100%" align="center" style="margin-left:150px;">      
                
        <tr>
            <td>              
                <u>USER</u>
            </td>  
             <td>
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             </td>
              <td>
                 <u>PAGE</u>
              </td>
        </tr> 
        
                   
<%     
     
    Set<String> keys = mismatchedPages.keySet();
    
    Iterator<String> keysItr = keys.iterator();
    String authName = "";
    String authemail = "";
    String pageTitle = "";
    
    while(keysItr.hasNext())
    {
        authemail = "";
        String key = keysItr.next();
        //out.println("Key"+key+"<br>");     
        Node pageNode = slingRequest.getResourceResolver().getResource(key+"/jcr:content").adaptTo(Node.class);  
        
        if(pageNode.hasProperty("authorName"))
        {
            authName = pageNode.getProperty("authorName").getString();        
                         
        }   
        if(pageNode.hasProperty("authorEmail"))
        {
            authemail = pageNode.getProperty("authorEmail").getString();        
                         
        }   
        if(pageNode.hasProperty("jcr:title"))
        {
            pageTitle = pageNode.getProperty("jcr:title").getString();        
                         
        }   
%>
        
    <tr>
        <td>              
            <%= authName%>
        </td>
         <td>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          </td>                 
        <td >            
            <%=pageTitle%>
        </td>
    </tr>  

             
<%                            
       
    }    
%>  
</table>   
 </form>
<%     
     
}

if (request.getParameter("hidSendEmail")!=null)
{
    //out.println("TEST");
    sendEmail = request.getParameter("hidSendEmail");
    
    
}
String nodePath = "";
if (request.getParameter("hidEmailsubject")!=null)
{
    nodePath = request.getParameter("hidEmailsubject");
    //out.println("Root"+nodePath);
    
}

final User user = slingRequest.getResourceResolver().adaptTo(User.class);
String senderID = "";
String senderEmail = "";

SlingRepository repos= sling.getService(SlingRepository.class);  
UserManagerFactory fact =sling.getService(UserManagerFactory.class);


if (!(repos==null || fact==null)) {
         javax.jcr.Session session = null;
         try {
             //  create session from repository's method loginAdministrative 
             session = repos.loginAdministrative(null);
             final UserManager umgr = fact.createUserManager(session);
             if(umgr.hasAuthorizable(user.getID())){
                 Authorizable auth = umgr.get(user.getID());
                 // code to get sender ID             
                 senderID = user.getID();
                 // code to get sender email and full name
                 
                 // temp - 12/22
                 Node userProfileNode = (Node) session.getItem(user.getHomePath() + "/profile");

                

                 
                 if(userProfileNode.hasProperty("rep:email"))
                 {
                    senderEmail=senderEmail+userProfileNode.getProperty("rep:email").getValue().getString();
                 }
                 else if(userProfileNode.hasProperty("email"))
                     {
                        senderEmail=senderEmail+userProfileNode.getProperty("email").getValue().getString();
                     }
                     else
                     {
                         if(null!=user.getProperty("rep:e-mail"))  // added for the new Auto synched process
                         {
                         senderEmail=user.getProperty("rep:e-mail");
                         
                         out.println("SENDER EMAIL"+senderEmail);
                         
                         }
                     }                
             }
         } catch (RepositoryException e) {
         } finally {
             if (session!=null) {
                 session.logout();
             }
         }
}

if ( sendEmail !=null && sendEmail.equalsIgnoreCase("yes") ) 
{

    if(nodePath.startsWith("/content/accessmcd"))
    {
        //out.println("Root"+rootPath);
        HashSet<String> assetLinks = new HashSet<String>(); 
        HashSet<String> pageCUG = new HashSet<String>(); 
        HashMap<String,String> mismatchedAssets = new HashMap<String,String>();
        String asset = "";
        String missingGroups = "";
        String audienceGroups = "";
        String separator = "";
        String pageSeparator = "";
        String pageTitle = "";
        String pageAuthorEmail = "";    
        
        Node pageNode = slingRequest.getResourceResolver().getResource(nodePath+"/jcr:content").adaptTo(Node.class);  
        
        if(pageNode.hasProperty("jcr:title"))
        {
        pageTitle = pageNode.getProperty("jcr:title").getString();        
             
        }   
        if(pageNode.hasProperty("authorEmail"))
        {
        pageAuthorEmail = pageNode.getProperty("authorEmail").getString();        
             
        }           
        
        assetLinks = damUtilObject.getReferredAssets(resourceResolver,nodePath);    
        pageCUG = getCUG(slingRequest,nodePath.trim());  
     
        if(pageCUG.size()>0)
        {          
        Iterator<String> assetLink = assetLinks.iterator();
        
        while(assetLink.hasNext())
        {     
            asset = assetLink.next();
            String updatedLink = URLDecoder.decode(asset);  
            //out.println("TEST111"+updatedLink+"<br>" );
            //Node assetNode = slingRequest.getResourceResolver().getResource(updatedLink).adaptTo(Node.class);              
            assetCUG = getCUG(slingRequest,updatedLink);      
            
            //out.println("CUG Size"+assetCUG.size()+"<br>" );
            missingGroups = "";            
            separator = "";
            pageSeparator = "";
            audienceGroups = "";
            Iterator<String> pageItr = pageCUG.iterator();       
            while(pageItr.hasNext())
            {
            audienceGroups += pageSeparator;  
            //separator = "";             
            //out.println("TEST222222222"+updatedLink );

            String group = pageItr.next();
            audienceGroups += group;
            if(!assetCUG.contains(group))
            {        
              //out.println("TEST"+updatedLink+"<br>" );       
              missingGroups += separator; 
              missingGroups += group;
              mismatchedAssets.put(updatedLink,missingGroups);
              separator = ",";
            }
            
            pageSeparator = ",";
            }
            
        }
        
         }   
         
         //out.println("Audience"+audienceGroups );
         //out.println("Size"+mismatchedAssets.size());    

        Set<String> keys = mismatchedAssets.keySet();
        
        Iterator<String> keysItr = keys.iterator();
        String authemail = "";
        String authername="";
        while(keysItr.hasNext())
        {
        authemail = "";
        String key = keysItr.next();
        //out.println("Key"+key);     
        Node assetNode = slingRequest.getResourceResolver().getResource(key).adaptTo(Node.class);  
        Property primaryType = assetNode.getProperty("jcr:primaryType");
        String assetType  = primaryType.getString();
        if(assetType.equals("dam:Asset"))
        {        
            Node assetMetaNode = slingRequest.getResourceResolver().getResource(key+"/jcr:content/metadata").adaptTo(Node.class);  
            if(assetMetaNode.hasProperty("authemail"))
            {
                authemail = assetMetaNode.getProperty("authemail").getString();        
                authername =  assetMetaNode.getProperty("authname").getString();   
            }         
        }
        String assetTitle = assetNode.getName();        
        String value = mismatchedAssets.get(key);
        //out.println("Value"+value);
        
        //out.println("email"+authemail );
        
        String message = "Hello,<br><br>I am trying to activate a page  that is open to&nbsp;{" + audienceGroups +"},"
                  +"&nbsp;but your asset&nbsp;" + assetTitle + "&nbsp;is not open to&nbsp;{" + value +"}.&nbsp;"
                  +"Please alter the security setting on your asset to include the missing group(s) or contact me to discuss how we can resolve this issue."
                  +"<br><br> Thank you."+"<br><br> My contact information:&nbspName:&nbsp"+authername+"&nbspEmail:&nbsp"+authemail;
        
        sendMail(senderEmail,authemail,message);
        }    
        

    }

    else if(nodePath.startsWith("/content/dam/accessmcd"))
    {          
        HashSet<String> assetReferences = new HashSet<String>();
        HashSet<String> referredCUG = new HashSet<String>();
        HashSet<String> referredPageCUG = new HashSet<String>();
        HashSet<String> assetCUG = new HashSet<String>();
        HashMap<String,String> mismatchedPages = new HashMap<String,String>();
        String referredPage = "";    
        String missingGroups = "";
        String audienceGroups = "";
        String separator = "";
        String assetSeparator = "";
        String assetTitle = "";
        String assetAuthEmail = "";
        

        Node damNode = slingRequest.getResourceResolver().getResource(nodePath).adaptTo(Node.class); 
        Property primaryType = damNode.getProperty("jcr:primaryType");
        String assetType  = primaryType.getString();
        if(assetType.equals("dam:Asset"))
        {
            Node damMetadataNode = slingRequest.getResourceResolver().getResource(nodePath+"/jcr:content/metadata").adaptTo(Node.class);       
            
            if(damMetadataNode.hasProperty("dc:title"))
            {
                assetTitle = damMetadataNode.getProperty("dc:title").getString();        
                     
            }else
            {
                 assetTitle = damNode.getName(); 
            }
            
            if(damMetadataNode.hasProperty("authemail"))
            {
                assetAuthEmail = damMetadataNode.getProperty("authemail").getString();        
                     
            }                
        }else if(assetType.equals("sling:OrderedFolder"))
        {
          assetTitle = damNode.getName();    
        }
        
        assetCUG = getCUG(slingRequest,nodePath);                     
        assetReferences = damUtilObject.getAssetReferences(slingRequest,damNode.getPath());        
        Iterator<String> referItr = assetReferences.iterator();    
        
        Iterator<String> assetItr = assetCUG.iterator();    
        
        while(assetItr.hasNext())
        {
            audienceGroups += assetSeparator;
            audienceGroups += assetItr.next();
            assetSeparator = ",";
        }
           
        //out.println("Asset CUG"+audienceGroups);
           
        while(referItr.hasNext())
        {
            referredPage = referItr.next();                         
                        
            Node pageNode = slingRequest.getResourceResolver().getResource(referredPage  + "/jcr:content").adaptTo(Node.class);
                if(pageNode.hasProperty("cq:lastReplicationAction"))
                {
                        String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                        if(pageStatus.equals("Activate"))
                        {                                                                                                                                           
                            referredCUG = getCUG(slingRequest,referredPage);   

                            if(referredCUG.size()>0)
                            {                
                                Iterator<String> pageCUGItr = referredCUG.iterator();
                                missingGroups = "";
                                separator = "";

                                while(pageCUGItr.hasNext())
                                {     
                                    String group = pageCUGItr.next();          
                                    if(!assetCUG.contains(group))
                                    {         
                                        missingGroups += separator;    
                                        missingGroups += group;                                 
                                        mismatchedPages.put(referredPage,missingGroups);
                                        separator = ",";
                                    }
                                }  
                            } 
                        }
                }                
        }   
         
         
         //out.println("Size"+mismatchedPages.size());
         
         
        Set<String> keys = mismatchedPages.keySet();
        
        Iterator<String> keysItr = keys.iterator();
        String authemail = "";
        String pageTitle = "";
        
        while(keysItr.hasNext())
        {
        authemail = "";
        String key = keysItr.next();
        //out.println("Key"+key+"<br>");     
        Node pageNode = slingRequest.getResourceResolver().getResource(key+"/jcr:content").adaptTo(Node.class);  
        if(pageNode.hasProperty("authorEmail"))
        {
            authemail = pageNode.getProperty("authorEmail").getString();        
                 
        }   
        if(pageNode.hasProperty("jcr:title"))
        {
            pageTitle = pageNode.getProperty("jcr:title").getString();        
                 
        }   
              
              
        String value = mismatchedPages.get(key);
        //out.println("Value"+value+"<br>");
        
        //out.println("email"+authemail);
        
        String message = "Hello,<br><br>I am trying to activate an asset " + assetTitle +" that is open only to&nbsp;{" + audienceGroups +"},"
        +"&nbsp;but your page " + pageTitle +" referencing it is open to&nbsp;{" + value +"} as well.&nbsp;"
        +"Please alter the security setting on your page or contact me to discuss how we can resolve this issue."
        +"<br><br> Thank you.";
                
        sendMail(senderEmail,authemail,message);
        }    
    }
}

%>

<script>

function sendEmail(){
var myform = document.frmEmailAction;
myform.hidSendEmail.value = "yes";
myform.submit();
return true;

}
</script>