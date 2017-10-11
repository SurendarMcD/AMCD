 <%
//  response.setContentType("application/json");%> 
   
<%-- Follow us component.
     Author : Nitin Sharma

--%> 
<%@include file="/apps/mcd/global/global.jsp"%>

<%@ page import="java.util.ArrayList,
        java.util.Iterator, com.day.cq.security.privileges.*,
        java.util.Date,com.mcd.util.MailNotification,
        com.day.cq.wcm.api.PageFilter,
        javax.jcr.Binary,javax.jcr.Node,javax.jcr.Session,org.apache.sling.jcr.api.SlingRepository,
        org.apache.sling.api.scripting.SlingScriptHelper,
        com.day.cq.security.User,com.mcd.accessmcd.util.CommonUtil,com.day.cq.security.Group,
        java.util.ListIterator,java.util.Collection

       "%>
       
 
 
 
       
<%
final User user = slingRequest.getResourceResolver().adaptTo(User.class); //instantiate User object
String allowedGroups= prop.getProperty("canr_allowed_usergroup"); 
String contextpath=request.getRequestURL().toString().substring(0,request.getRequestURL().toString().indexOf(request.getRequestURI()));
boolean allowed=false;
Group aowgroup = null;
Iterator usergroups=user.memberOf();
 while(usergroups.hasNext())
   { 
                    Group group = (Group)usergroups.next(); 
                    String groupName=group.getName();
 
                   if(allowedGroups.contains(","))
                   {
                       String [] allgps=allowedGroups.split(",");
                       boolean skip=false;
                       for(String gp:allgps)
                       {
                            if(groupName.trim().equalsIgnoreCase(gp))
                             {
                                allowed=true;skip=true;aowgroup = group ;
                                break;
                             }
                               
                       }
                       
                       if(allowed==true && skip==true){break;}
                       
                   }else
                   {
                   
                    if(groupName.trim().equalsIgnoreCase(allowedGroups))
                     {
                                   
                                   allowed=true;aowgroup = group ;  
                                   break;
                     }
                   }
                    
   }      

 //Allow administrator to access the utility

 if(slingRequest.getUserPrincipal().getName().equals("admin")){
  allowed=true;
  }
  
  
  if(allowed)  
  {
    /* To retrieve the list of all the meber of AOW Group
  
    */  
   ArrayList mem = new ArrayList();
   if(aowgroup!=null)
   {   
   Iterator members = aowgroup.members();
  
    while(members.hasNext())
    {
     User a = (User)members.next();
     if(a.getProperty("rep:email")!= null)
     {
      String email = a.getProperty("rep:email");
      mem.add(email);
     }
    } 
   }
  String usertype = (request.getParameter("usertype")!= null) ? request.getParameter("usertype").toString().trim() : "author";
  String username = (request.getParameter("username")!= null) ? request.getParameter("username").toString().trim() : "";
  String useremail =  (request.getParameter("useremail")!= null) ? request.getParameter("useremail").toString().trim() : "";

  String nusername =  (request.getParameter("nusername")!= null) ? request.getParameter("nusername").toString().trim() : "";
  String nuseremail =  (request.getParameter("nuseremail")!= null) ? request.getParameter("nuseremail").toString().trim() : "";
  
  String path =  (request.getParameter("path")!= null) ? request.getParameter("path").toString().trim() : "";
  
  String reppages =  (request.getParameter("pages")!= null) ? request.getParameter("pages").toString().trim() : "";
  
  String replace =  (request.getParameter("replace")!= null) ? request.getParameter("replace").toString().trim() : "false";
  
  String check =  (request.getParameter("check")!= null) ? request.getParameter("check") : "true";
  


  String usernamelabel= usertype.equalsIgnoreCase("owner")?"Site Owner Name":"Author Name";
  String useremaillabel= usertype.equalsIgnoreCase("owner")?"Site Owner Email":"Author Email";
  String aname=usertype.equalsIgnoreCase("owner")?"siteOwnerName":"authorName";
  String amail = usertype.equalsIgnoreCase("owner")?"siteOwnerEmail":"authorEmail";
  String filename="report";  
  
 int count =0; 
 String [] a=new String[5000];
 String data ="";
 int k=0;
 int pageinlevel=0;
 CommonUtil cutil=new CommonUtil();  
 String [] element = new String[9] ;
 String [] reportelement = new String[6] ;
 String ptitle,purl,act,pauth,pmail,nauth,nmail;
 ptitle = "";
 purl = "";
 act = "";
 pauth = "";
 pmail = "";
 nauth = "";
 nmail = "";
 

 ArrayList userdata = new ArrayList();
 ArrayList reportdata = new ArrayList();
 
 String currentuseremail = "";
 String userhomePath=user.getHomePath();
            
 if(slingRequest.getResourceResolver().getResource(userhomePath+"/profile")!=null){
           Node userNode = slingRequest.getResourceResolver().getResource(userhomePath+"/profile").adaptTo(Node.class);
           if(userNode.hasProperty("email")){
               currentuseremail=userNode.getProperty("email").getString();
           }    
 }  
 
 String defaultuseremail=prop.getProperty("canr_defaultusers");
 
 
 //Replace User Request for Author
 
    if(replace.equals("true") && usertype.trim().equalsIgnoreCase("author"))  
    {

     String [] rpage = reppages.split(",");
     for(int i = 0 ; i < rpage.length ; i++)
     {

      try
      {
     
          Node pageNode = resourceResolver.getResource(rpage[i]+"/jcr:content").adaptTo(Node.class); 
          pauth = username;
          pmail =  useremail;
          if(pageNode.hasProperty("authorName"))
          {   
            pauth= pageNode.getProperty("authorName").getString(); 

          }

          if(pageNode.hasProperty("authorEmail"))
          {   
            pmail= pageNode.getProperty("authorEmail").getString(); 

          }
              
          if(!nusername.trim().equals(""))
            {
              Property p1 = pageNode.setProperty(aname,nusername);
            }
          else
            {
              nusername = pauth;     
            }
          if(!nuseremail.trim().equals(""))
            {
              Property p2 = pageNode.setProperty(amail,nuseremail);       
            }
          else
            {
             nuseremail = pmail;
            }    
          pageNode.save(); 
          
          
          username=nusername;
          useremail=nuseremail;
         
         // Add the page data into an Array
         
         purl = rpage[i];
         nauth =nusername;
         nmail =nuseremail;
         if(pageNode.hasProperty("cq:lastReplicationAction"))
          {   
           act= pageNode.getProperty("cq:lastReplicationAction").getString(); 
           if(act.toLowerCase().equals("activate")){
                 act="Active";
              }else if(act.toLowerCase().equals("deactivate")){
                  act="Deactive";
               }if(act.trim().toLowerCase().equals("")){act="-";}
          }
         if(pageNode.hasProperty("jcr:title"))
         {   
          ptitle= pageNode.getProperty("jcr:title").getString(); 
         }  

         element[0] = ""+(i+1);  //S No
         element[1] = ptitle;    //Page Title
         element[2] = purl;      //Page URL 
         element[3] = pauth;     //Previous user
         element[4] = pmail;     //Previous Mail   
         element[5] = nauth;     //New User Name
         element[6] = nmail;     //New User Email   
         element[7] = act;       //Activation Status
         element[8] = contextpath+purl+".html";     //Action URL
         
         reportelement[0] = ""+(i+1);  //S No
         reportelement[1] = ptitle;    //Page Title
         reportelement[2] = purl;      //Page URL 
         reportelement[3] = nauth;     //New User Name
         reportelement[4] = nmail;     //New User Email   
         reportelement[5] = contextpath+purl+".html";     //Action URL
         
        
         userdata.add(element);
         element=new String[9];
      
         reportdata.add(reportelement);
         reportelement=new String[6];
      
      }
      catch(Exception e)  
      {
          out.println("Exception:"+e.getMessage());
      }
     } 
     
        

     String notificationtype="log";
    //send mail notification with logs to default user and currentl logged in user.
    // String default_users=currentuseremail+","+defaultuseremail; 
     if(userdata.size()>0)
     {
       if(mem!=null)
       {
       Iterator itr = mem.iterator();
        while(itr.hasNext())
        {
         sendUserNotification(itr.next().toString(),userdata,notificationtype,usertype,sling);
        }
         sendUserNotification(currentuseremail,userdata,notificationtype,usertype,sling);
         sendUserNotification(defaultuseremail,userdata,notificationtype,usertype,sling);
       }
     }
     //
     
     notificationtype="report";
     if(reportdata.size()>0)
     { 
         
         sendUserNotification(nuseremail,reportdata,notificationtype,usertype,sling);
     }
    }
  
 //Replace User Request for Site Owner
 
    if(replace.equals("true") && usertype.trim().equalsIgnoreCase("owner"))  
    {

     String [] rpage = reppages.split(",");
     for(int i = 0 ; i < rpage.length ; i++)
     {

      try
      {
     
              Node pageNode = resourceResolver.getResource(rpage[i]+"/jcr:content").adaptTo(Node.class); 
              String siteownerrootpage="";
          
               pauth = username;
          pmail =  useremail;
          if(pageNode.hasProperty("siteOwnerName"))
          {   
            pauth= pageNode.getProperty("siteOwnerName").getString(); 

          }

          if(pageNode.hasProperty("siteOwnerEmail"))
          {   
            pmail= pageNode.getProperty("siteOwnerEmail").getString(); 

          }
              
          if(!nusername.trim().equals(""))
            {
              Property p1 = pageNode.setProperty("siteOwnerName",nusername);
            }
          else
            {
              nusername = pauth;     
            }
          if(!nuseremail.trim().equals(""))
            {
              Property p2 = pageNode.setProperty("siteOwnerEmail",nuseremail);       
            }
          else
            {
             nuseremail = pmail;
            }      
              purl = rpage[i];
              nauth = nusername;
              nmail = nuseremail;
                 if(pageNode.hasProperty("cq:lastReplicationAction"))
                  {   
                       act= pageNode.getProperty("cq:lastReplicationAction").getString(); 
                                  if(act.toLowerCase().equals("activate")){
                                         act="Active";
                                      }else if(act.toLowerCase().equals("deactivate")){
                                          act="Deactive";
                                       }if(act.trim().toLowerCase().equals("")){act="-";}
                  }
         if(pageNode.hasProperty("jcr:title"))
         {   
          ptitle= pageNode.getProperty("jcr:title").getString(); 
         }  

        // cutil.setSiteOwner(rpage[i],username,nusername,nuseremail,slingRequest.getResourceResolver());
         pageNode.save();
         username=nusername;
         useremail=nuseremail;
        
         element[0] = ""+(i+1);  //S No
         element[1] = ptitle;    //Page Title
         element[2] = purl;      //Page URL 
        
         element[3] = pauth;     //Previous user
         element[4] = pmail;     //Previous Mail   
        
         element[5] = nauth;     //New User Name
         element[6] = nmail;     //New User Email   
         element[7] = act;       //Activation Status
         element[8] = contextpath+purl + ".html";     //Action URL
         
         
         reportelement[0] = ""+(i+1);  //S No
         reportelement[1] = ptitle;    //Page Title
         reportelement[2] = purl;      //Page URL 
         reportelement[3] = nauth;     //New User Name
         reportelement[4] = nmail;     //New User Email   
         reportelement[5] = contextpath+purl+".html";     //Action URL
         
         userdata.add(element);
         element=new String[9];
     
         reportdata.add(reportelement);
         reportelement=new String[6];
      
       
      }
      catch(Exception e)  
      {
          out.println("Exception:"+e.getMessage());
      }
     } 


     String notificationtype="log";
    
    
     if(userdata.size()>0)
     {
      //send mail notification with logs to default user and currentl logged in user.
      Iterator itr = mem.iterator();
        while(itr.hasNext())
        {
         sendUserNotification(itr.next().toString(),userdata,notificationtype,usertype,sling);
        }   
      sendUserNotification(currentuseremail,userdata,notificationtype,usertype,sling);
      sendUserNotification(defaultuseremail,userdata,notificationtype,usertype,sling);
     }
     //
     notificationtype="report";
     if(reportdata.size()>0)
     {
         sendUserNotification(nuseremail,reportdata,notificationtype,usertype,sling);
     }


    }
  

//Below code display the pages for Site Owner or Author owned page based on the request parameter.


  
  
    Session session=null;
    Session session1=null;
    try
    {
      
     ArrayList page_data=new ArrayList();
     if(replace.equals("true"))
     {
        String [] rpages=reppages.split(",");
        for(int n=0;n<rpages.length;n++)
        {
         page_data.add(rpages[n]);
        
        }
    
     }
     else{
      Page globalPage= pageManager.getPage(path);
       int dep = 10;
      Iterator<Page> myChildren0 = globalPage.listChildren(new PageFilter(request));  
       while(myChildren0.hasNext()){
          Page child =  (Page) myChildren0.next();
         // a[k++]=child.getPath();
           page_data.add(child.getPath());
           k++;
        }

        pageinlevel=k;
        int start=0;

        for(int n=1;n<=dep;n++){
         int pages=0;
    
         for(int m=start;m<start+pageinlevel;m++) {
              globalPage=pageManager.getPage(page_data.get(m).toString());
              Iterator<Page> myChildren = globalPage.listChildren(new PageFilter(request));  
              while(myChildren.hasNext()){
                Page child =  (Page) myChildren.next();
               // a[k++]=child.getPath();
                page_data.add(child.getPath());k++;
                pages++;
        
               }
          } 
    
         start=k-pages;    pageinlevel=pages;
       }
        
      }
     
       
       SlingRepository repos=null;
       repos= sling.getService(SlingRepository.class); 
       session=repos.loginAdministrative(null); 
  
       String nameValue="";
       String mailValue="";
       String pageTitle ="";
       String status = "";
       String paths= page_data.get(0).toString() + ","; 
       data = "<table id='rounded-corner'><thead id='tbhead'><tr><th scope='col' width='45px'>S No</th><th scope='col' width='180px'>"+usernamelabel+"</th><th scope='col' width='250px'>"+useremaillabel+"</th><th scope='col' width='250px'>Page URL</th><th scope='col' width='220px'>Page Title</th> <th scope='col' width='150px'>Activation Status</th> <th scope='col'width='85px' ><input  type='checkbox' name='rpcbox' checked onclick='checkfiles();'>&nbsp; Replace</th></tr></thead><tbody id='tbbody'>";  

  
      
       for(int m=0;m<page_data.size();m++) {
             nameValue= ""; 
             mailValue = "" ;
             status = "--" ; 
             pageTitle = "--";
             
             if(page_data.get(m)!=null) {

              if(slingRequest.getResourceResolver().getResource(page_data.get(m).toString()+"/jcr:content")!=null){                   
                   Node pageNode = slingRequest.getResourceResolver().getResource(page_data.get(m).toString()+"/jcr:content").adaptTo(Node.class);
        
       
            
                 
            if(usertype.trim().equalsIgnoreCase("owner")) {
             //ArrayList ownerdata= cutil.getSiteOwner(a[m],slingRequest.getResourceResolver());
            
                          if(pageNode.hasProperty("siteOwnerName") && pageNode.hasProperty("siteOwnerEmail"))
                                {
                        
                                    String siteOwnerName= pageNode.getProperty("siteOwnerName").getString(); 
                                    String siteOwnerEmail= pageNode.getProperty("siteOwnerEmail").getString(); 
                                     
                                    
                                          nameValue=siteOwnerName;
                                          mailValue = siteOwnerEmail;           
                              
                         }
                   
                       
       
        }else
        {
        if(pageNode.hasProperty(aname)){
        nameValue= pageNode.getProperty(aname).getString(); 
        }
        
         if(pageNode.hasProperty(amail))
        {  
         mailValue = pageNode.getProperty(amail).getString(); 
        }
       
        }
       
        
        
        if(pageNode.hasProperty("cq:lastReplicationAction"))
        {   
         status= pageNode.getProperty("cq:lastReplicationAction").getString(); 
                                    if(status.toLowerCase().equals("activate")){ status="Active";
                                      }else if(status.toLowerCase().equals("deactivate")){
                                          status="Deactive";
                                       }if(status.trim().toLowerCase().equals("")){status="-";}
        }
         if(pageNode.hasProperty("jcr:title"))
        {   
         pageTitle= pageNode.getProperty("jcr:title").getString(); 
        }
        
     
     //if(!username.trim().equals("") && !useremail.trim().equals("")) 
     {
        if((nameValue.equalsIgnoreCase(username)) || (mailValue.equalsIgnoreCase(useremail))) 
        {
         count++;
         if(m >0){
           paths = paths +page_data.get(m).toString() + "," ;
        }     
        
             String cbox="";
            
            session1 = slingRequest.getResourceResolver().adaptTo(Session.class);
            if(hasWriteAccess(page_data.get(m).toString(),session1))
             {
               cbox="<input name='files' type='checkbox' onclick='uncheck();' checked value='" +page_data.get(m).toString() + "'>";
             }else{
        
              cbox="access denied";
            } 
  

         data = data + "<tr><td width='45px'>" + (count) + "</td><td width='180px'>" + nameValue + "</td><td width='250px'>" + mailValue  + "</td><td width='250px'>" + page_data.get(m).toString() + "</td><td width='220px'>" + pageTitle + "</td><td width='150px'>" + status + "</td><td width='85px'>"+cbox+"</td> </tr>";
  
        }
      }
      
   
      
      
       
      }
      }    
      }
        
     }  
     catch(Exception e)
     {
      log.error("CANR Utility Exception:::::"+e.getMessage());
     }
     finally{
         /*if(session!=null)
            session.logout();

        if(session1!=null)
        session1.logout();*/
    } 
     if(count==0)
      data = "<div style='display:none'>norecordfound</div>"; 
    else 
    {
   %>
   <script>
   $(document).ready(function(){   

    $("#rounded-corner tr").hover(function(){
        $(this).css("background-color","#D0DAFD");
    },function(){
        $(this).css("background-color","#E8EDFF");

    });
});


</script>


<style>
#rounded-corner tbody tr:hover td {
background:none repeat scroll 0 0 #D0DAFD;
}


#rounded-corner {
border-collapse:collapse;
font-family:"Lucida Sans Unicode","Lucida Grande",Sans-Serif;
font-size:12px;
text-align:left;
width:100%;
}

#rounded-corner th {
background:none repeat scroll 0 0 #B9C9FE;
color:#003399;
font-size:13px;
font-weight:normal;
padding:8px;
}

#rounded-corner tr {
background:none repeat scroll 0 0 #E8EDFF;
}

#rounded-corner tr td{
border-top:1px solid #FFFFFF;
color:#666699;
padding:8px;
}

</style>
      
   
   <% 
   
   
      data = data + "</tbody></table>";   
    } 
    out.println(data);
}else
{
    out.println("<div style='display:none'>norecordfound</div>");
}    
   
  %>   
 
  

<%!
public void sendUserNotification(String usermail,ArrayList data,String notificationtype,String usertype,SlingScriptHelper sling)
{
        MailNotification o=new MailNotification();
        o.sendMail(usermail,data,notificationtype,usertype,sling);
}

          
public boolean hasWriteAccess(String path,Session session) throws RepositoryException {

  try {
             session.checkPermission(path+"/jcr:content", session.ACTION_SET_PROPERTY);
  
           
      } catch(java.security.AccessControlException e) {
        return false;
      }
  return true;
}


%>
 
                   