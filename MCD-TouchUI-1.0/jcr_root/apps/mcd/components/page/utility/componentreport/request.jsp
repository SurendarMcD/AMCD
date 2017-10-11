   
<%-- Component Report
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
 
<%!
    public String childPagesList = "";
%>
     
<%

    final User user = slingRequest.getResourceResolver().adaptTo(User.class); //instantiate User object
    
  // Retrieve the Request Parameters and the Type of Report Requested   
  
    String path =  (request.getParameter("path")!= null) ? request.getParameter("path").toString().trim() : "";
    String childcheck=  (request.getParameter("child")!= null) ? request.getParameter("child").toString().trim() : "";
    String type =  (request.getParameter("type")!= null) ? request.getParameter("type").toString().trim() : "";
    String compSearch =  (request.getParameter("component")!= null) ? request.getParameter("component").toString().trim() : "";
 
 // Table to Display Output of the Utility
    
    String data = "<table id='rounded-corner'><thead id='tbhead'><tr><th scope='col' width='135px'>S No</th><th scope='col' width='180px'>Page Title </th><th scope='col' width='250px'>Page URL</th><th scope='col' width='150px'>Author</th><th scope='col' width='120px'>Activation Status</th> <th scope='col' width='250px'>Component Type</th> <th scope='col' width='550px'>Component Path</th><tr></thead><tbody id='tbbody'>";  

    int sno =1;
    String title = "";
    String url = "";
    String author ="";
    String status = "";
   
   
    Node globalPage = slingRequest.getResourceResolver().getResource(path + "/jcr:content").adaptTo(Node.class);
    String compName="";
    String compType="";
    String compPath="";
  
  // if Page Report is REquested
      
       if(type.equals("page"))
       {
       if(childcheck.equals("false"))    // If Child Pages not Checked
       {
        NodeIterator myChildren=globalPage.getNodes();
        title = globalPage.getProperty("jcr:title").getString();
        url =  path ;
        
        if(globalPage.hasProperty("authorName"))
          author = globalPage.getProperty("authorName").getString();
        
        if(globalPage.hasProperty("cq:lastReplicationAction"))
         {   
          status= globalPage.getProperty("cq:lastReplicationAction").getString(); 
          if(status.toLowerCase().equals("activate"))
          {
           status="Active";
          }
          else 
          if(status.toLowerCase().equals("deactivate"))
          {
           status="Deactive";
          }
          if(status.trim().toLowerCase().equals(""))
          {
           status="-";
          }
         }
        while(myChildren.hasNext())
        {
         Node child =   myChildren.nextNode();
         if(child.hasProperty("sling:resourceType"))
         {
         if(child.getProperty("sling:resourceType").getString().equals("mcd/components/content/parsys") || child.getProperty("sling:resourceType").getString().startsWith("/apps/mcd/components/content") || child.getProperty("sling:resourceType").getString().equals("foundation/components/iparsys"))
         {
          NodeIterator compNodes = child.getNodes();
          while(compNodes.hasNext())
          {
            Node comp = compNodes.nextNode();
            
            // Retrieve the properties of the Node
            
            compName = comp.getName();
            compType = comp.getProperty("sling:resourceType").getString();
            compPath = comp.getPath();//.substring(comp.getPath().indexOf("/jcr:content"),comp.getPath().length()) ;
            //compPath = compPath.replace("/jcr:content","");
            
            try
            {   
            if(compType != null)
            {
             Node cmp = slingRequest.getResourceResolver().getResource(compType).adaptTo(Node.class);
             if(cmp != null){
              if(cmp.hasProperty("jcr:title"))
             {
              compType = cmp.getProperty("jcr:title").getString();
             } }
             }
            }
            catch(Exception e)
            {
             log.error("Component Report : Page : " + e.getMessage());
            }
            // Add it to the Response
           data = data + "<tr><td>" + (sno++) + "</td><td>" + title + "</td><td>" + url + "</td><td>" + author + "</td><td>" + status + "</td><td>"  + compType + "</td><td>" + compPath + "</td><tr>";   
             
          }   
         }
         }
        } 
       }
      
       if(childcheck.equals("true"))    // if child pages is checked
       {
        Page rootPage = pageManager.getPage(path);
        childPagesList = rootPage.getPath();
        String pages =  getP(rootPage);  // Get the CSV list of the child pages
        String[] Inpage = pages.split(",");
         
        // Traverse the Array of PAges 
         
        for(int i = 0 ;i <Inpage.length ; i++)
        {
         try
         { 
          globalPage = slingRequest.getResourceResolver().getResource(Inpage[i] + "/jcr:content").adaptTo(Node.class);      
          
          NodeIterator myChildren=globalPage.getNodes();
          title = globalPage.getProperty("jcr:title").getString();
          url =  Inpage[i] ;
          
          // Retrieve the Properties of a Page
          
          if(globalPage.hasProperty("authorName"))
           author = globalPage.getProperty("authorName").getString();
               
          if(globalPage.hasProperty("cq:lastReplicationAction"))
          {   
           status= globalPage.getProperty("cq:lastReplicationAction").getString(); 
           if(status.toLowerCase().equals("activate"))
           {
            status="Active";
           }
           else 
           if(status.toLowerCase().equals("deactivate"))
           {
            status="Deactive";
           }
           if(status.trim().toLowerCase().equals(""))
           { 
            status="-";
           }
          }
          while(myChildren.hasNext())
          {
           Node child =   myChildren.nextNode();
           if(child.hasProperty("sling:resourceType"))
           {
           if(child.getProperty("sling:resourceType").getString().equals("mcd/components/content/parsys") || child.getProperty("sling:resourceType").getString().startsWith("/apps/mcd/components/content") || child.getProperty("sling:resourceType").getString().equals("foundation/components/iparsys"))
           {
            NodeIterator compNodes = child.getNodes();
            while(compNodes.hasNext())
            {
             Node comp = compNodes.nextNode();
             compName = comp.getName();
             compType = comp.getProperty("sling:resourceType").getString();
             compPath = comp.getPath();//.substring(comp.getPath().indexOf("/jcr:content"),comp.getPath().length()) ;
             //compPath = compPath.replace("/jcr:content","");
              
             if(compType != null)
             {
              Node cmp = slingRequest.getResourceResolver().getResource(compType).adaptTo(Node.class);
              if(cmp != null){
               if(cmp.hasProperty("jcr:title"))
               {
                compType = cmp.getProperty("jcr:title").getString();
                //out.println("Comp Name First :: " + compType + "<br>");
               }
              }
             }
            // Add it to Response
            //out.println("Comp Name First Child:: " + compType + "<br>");
            data = data + "<tr><td>" + (sno++) + "</td><td>" + title + "</td><td>" + url + "</td><td>" + author + "</td><td>" + status + "</td><td>"  + compType + "</td><td>" + compPath + "</td><tr>"; 
            }
           }
          } 
         } 
        } 
        catch(Exception e)
        {
         log.error("Page Report  : Pages(Child) :  " + e.getMessage());
        }
       }  
      } 
     }
     
    if(type.equals("comp"))
    {
        try
        {      
        Page rootPage = pageManager.getPage(path);
        childPagesList = rootPage.getPath();    
        String pages =    getP(rootPage);
        
        String[] Inpage = pages.split(",");
        
        for(int i = 0 ;i <Inpage.length ; i++)
        {
        
         globalPage = slingRequest.getResourceResolver().getResource(Inpage[i] + "/jcr:content").adaptTo(Node.class);      
         NodeIterator myChildren=globalPage.getNodes();
         title = globalPage.getProperty("jcr:title").getString();
         url =  Inpage[i] ;
         if(globalPage.hasProperty("authorName"))
           {
             author = globalPage.getProperty("authorName").getString();
           }
          else
          {
            author = "";
          }   
         if(globalPage.hasProperty("cq:lastReplicationAction"))
         {   
          status= globalPage.getProperty("cq:lastReplicationAction").getString(); 
          if(status.toLowerCase().equals("activate"))
          {
           status="Active";
          }else 
           if(status.toLowerCase().equals("deactivate"))
          {
           status="Deactive";
          }
          if(status.trim().toLowerCase().equals("")){status="-";}
         }
         while(myChildren.hasNext())
        {
         Node child =   myChildren.nextNode();
         if(child.hasProperty("sling:resourceType"))
         {
         if(child.getProperty("sling:resourceType").getString().equals("mcd/components/content/parsys") || child.getProperty("sling:resourceType").getString().equals("foundation/components/iparsys"))
         {
          NodeIterator compNodes = child.getNodes();
           while(compNodes.hasNext())
           {
            Node comp = compNodes.nextNode();
            if(comp.getProperty("sling:resourceType").getString().equals(compSearch) || compSearch.indexOf(comp.getProperty("sling:resourceType").getString()) >= 0)
            {
            compName = comp.getName();
            compType = comp.getProperty("sling:resourceType").getString();
            compPath = comp.getPath().substring(comp.getPath().indexOf("/jcr:content"),comp.getPath().length()) ;
            compPath = compPath.replace("/jcr:content","");
            try
            {   
            if(compType != null)
            {
             Node cmp = slingRequest.getResourceResolver().getResource(compType).adaptTo(Node.class);
             if(cmp != null){
              if(cmp.hasProperty("jcr:title"))
             {
              compType = cmp.getProperty("jcr:title").getString();
             } }
             }
            }
            catch(Exception e)
            {
             log.error("Component Report : Component : " + e.getMessage() );
            }
            data = data + "<tr><td>" + sno++ + "</td><td>" + title + "</td><td>" + url + "</td><td>" + author + "</td><td>" + status + "</td><td>"  + compType + "</td><td>" + compPath + "</td><tr>";
           }   
          }    
         }
         }
         } 
        
        }
        
        }
        catch(Exception e)
        {
        }
            
      
       } 
    
    
  %>

  <%!
    // Method to return the CSV list of all the child of a root Node
    
    String separator = "";
    public String getP(Page rootPage){
    if (rootPage != null){
        Iterator<Page> children = rootPage.listChildren();
        while (children.hasNext()){
            Page child = children.next();
            if(separator=="")separator=",";
            childPagesList+=separator;
            childPagesList+=child.getPath();
            
            getP(child);
        }
    }
     //log.error(" All Pages Path :: " + childPagesList);
     return childPagesList;
    }
 %>


  <% 
  // if No Record to Display

     if(sno == 1)
       data = "<div style='display:None;'>norecordfound</div>"; 
     data = data + "</tbody></table>";   
 
     out.println(data);  
     
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
      
  

  
                   