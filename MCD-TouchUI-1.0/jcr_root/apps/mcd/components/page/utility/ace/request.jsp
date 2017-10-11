   
<%-- Component Report
     Author : Nitin Sharma

--%>
<%@include file="/apps/mcd/global/global.jsp"%>
  
<%@ page import="java.util.ArrayList,
        java.util.Iterator, com.day.cq.security.privileges.*,
        java.util.Date,
        com.day.cq.wcm.api.PageFilter,
        javax.jcr.Binary,javax.jcr.Node,javax.jcr.Session,org.apache.sling.jcr.api.SlingRepository,
        org.apache.sling.api.scripting.SlingScriptHelper,
        com.day.cq.security.User,com.mcd.accessmcd.util.CommonUtil,com.day.cq.security.Group,
        java.util.ListIterator,java.util.Collection,java.text.SimpleDateFormat,java.util.Calendar

       "%>
 
<%!
    public String childPagesList = "";
%>
     
<%

    final User user = slingRequest.getResourceResolver().adaptTo(User.class); //instantiate User object
    
  // Retrieve the Request Parameters and the Type of Report Requested   
  
    String path =  (request.getParameter("path")!= null) ? request.getParameter("path").toString().trim() : "";
    String month =  (request.getParameter("time")!= null) ? request.getParameter("time").toString().trim() : "";
    int mon = Integer.parseInt(month);
    
 // Table to Display Output of the Utility
    
    String data = "<table id='rounded-corner'><thead id='tbhead'><tr><th scope='col' width='135px'>S No</th><th scope='col' width='180px'>Page Title </th><th scope='col' width='250px'>Page URL</th><th scope='col' width='150px'>Author</th><th scope='col' width='120px'>Activation Status</th> <th scope='col' width='250px'>Previous Off Time</th> <th scope='col' width='550px'>New Off Time</th><tr></thead><tbody id='tbbody'>";  

    int sno =1;
    String title = "";
    String url = "";
    String author ="";
    String status = "";
   
   Node parentPage;
    Node globalPage = slingRequest.getResourceResolver().getResource(path + "/jcr:content").adaptTo(Node.class);
    String preoff="";
    String newoff="";
    Date pre,ned;
  
  // if Page Report is REquested
      
      
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
          parentPage = slingRequest.getResourceResolver().getResource(Inpage[i]).adaptTo(Node.class);
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
            if(globalPage.hasProperty("offTime"))
            {               
            // to change the offtime by the number of months specified by the user               
               preoff= globalPage.getProperty("offTime").getString();   
               Date offtimeDate = globalPage.getProperty("offTime").getDate().getTime();                                               
               
               SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
               pre = df.parse(preoff);                              
               preoff = pre.toString();   
               
               Calendar cal = Calendar.getInstance();
               Date currentTime = cal.getTime();               
               if(offtimeDate.after(currentTime))
               {                                               
                       cal.setTime(pre);  
                       cal.set(Calendar.MONTH, (cal.get(Calendar.MONTH)+mon));  
                       pre = cal.getTime();  
                       newoff = pre.toString();
                      
                       try
                       {
                            Property p = globalPage.setProperty("offTime",cal);  
                            p = globalPage.setProperty("offTimimg",cal);  
                            globalPage.save();
                       }   
                       catch(Exception w){
                           out.println(w.getMessage());
                       }
               }      
               else
               {
                        newoff = "";
               }
             
            }
           else
            {              
              preoff= "";
              newoff= "";
            }    
           }
           else 
           if(status.toLowerCase().equals("deactivate"))
           {
            status="Deactive";            
            if(globalPage.hasProperty("offTime"))
            {               
            // to change the offtime by the number of months specified by the user               
               preoff= globalPage.getProperty("offTime").getString();
               SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
               pre = df.parse(preoff);
               preoff = pre.toString();                               
               newoff = "";                                            
            }
           else
            {              
              preoff= "";
              newoff= "";
            }
           }
           if(status.trim().toLowerCase().equals(""))
           { 
            status="-";
           }
          }
           
            // Add it to Response
            //out.println("Comp Name First Child:: " + compType + "<br>");
            data = data + "<tr><td>" + (sno++) + "</td><td>" + title + "</td><td>" + url + "</td><td>" + author + "</td><td>" + status + "</td><td>"  + preoff+ "</td><td>" + newoff + "</td><tr>"; 
            }
         
          
        catch(Exception e)
        {
         log.error("Page Report  : Pages(Child) :  " + e.getMessage());
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
width:960px;
margin-left :205px;
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
      
  

  
                   