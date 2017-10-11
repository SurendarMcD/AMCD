<%@ page contentType="application/vnd.ms-excel"%>
<%@ page import="java.util.Calendar,
        java.util.Locale,
        java.text.SimpleDateFormat,
        java.util.Iterator,
        com.day.cq.dam.api.*,
        org.apache.jackrabbit.util.Text,
        com.mcd.accessmcd.ace.manager.ACEManager,
        java.text.DecimalFormat,
        org.apache.sling.api.resource.ResourceResolver,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
        java.util.Collection,
        com.mcd.accessmcd.dam.damUtil,
        com.day.cq.wcm.commons.ReferenceSearch,org.apache.sling.api.SlingHttpServletRequest,
        java.util.*"%>
                                
<%@include file="/apps/mcd/global/global.jsp" %>

<style type="text/css">
body{
    font-family: verdana,sans-serif,arial;
    font-size:14px;
}
h3{
    text-align:center;
    text-decoration:underline;
    font-size:20px;
    /*color: #005ACC;*/
}
input.formbutton
{  
   font-family:verdana,sans-serif;
   font-weight:bold;
   color:#FFFFFF;
   background-color:#0077BB;
}
table.pagetable {
    border-width: 1px 1px 1px 1px;
    border-spacing: 0px;
    border-style: solid solid solid solid;
    border-color: black black black black;
    border-collapse: collapse;
}
table.dampagetable {
    border-width: 1px 1px 1px 1px;
    border-spacing: 0px;
    border-style: solid solid solid solid;
    border-color: black black black black;
    border-collapse: collapse;
}
table.pagetable th {
    font-weight:bold;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: solid solid solid solid;
    background-color: #EEEEEE;
    color: #802A2A;
    font-size: 12px;
}
table.dampagetable th {
    font-weight:bold;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: solid solid solid solid;
    background-color: #EEEEEE;
    color: #802A2A;
    font-size: 12px;
}
table.pagetable td {
    font-size: 11px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: dotted dotted dotted dotted;
}
table.dampagetable td {
    font-size: 11px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: dotted dotted dotted dotted;
}
.nowrap{
    white-space:nowrap;
}
.rightAlign{
    text-align:right;
}
.error
{
 border:1px solid red;
}
</style>
<%!
int count;
Node metadataNode;

damUtil dam = new damUtil();

/* Returns the Date String in requested Display Format */

public String displayDateAs(String displayFormat, long displayDate){        
    //Default Display Format
    if("".equals(displayFormat)){
        displayFormat = "dd/MM/yyyy HH:mm:ss";
    }    
    SimpleDateFormat sdf =new SimpleDateFormat(displayFormat,Locale.US);
    return sdf.format(displayDate);   
}

public HashSet getCUG(SlingHttpServletRequest slingRequest,String nodePath) throws RepositoryException
{
            String node = nodePath.trim(); 
            boolean temp = false;               
            Node assetJcrNode = null;
            HashSet<String> assetCUG = new HashSet<String>();                     
            try
            {                         
                 if(slingRequest.getResourceResolver().getResource(node+"/jcr:content") != null)
                 {    
                 assetJcrNode = slingRequest.getResourceResolver().getResource(node+"/jcr:content").adaptTo(Node.class);  
  
                    if(assetJcrNode.hasProperty("cq:cugPrincipals"))
                    {
                        temp = true;
                        Value[] pageCUG = assetJcrNode.getProperty("cq:cugPrincipals").getValues();
                        for(int i=0;i<pageCUG.length;i++)
                        {
                            assetCUG.add(pageCUG[i].getString());
                        }                    
                    }
                    else
                    {
                        Node parentNode = assetJcrNode.getParent().getParent();
                        assetCUG = getCUG(slingRequest,parentNode.getPath());                
                    } 
                   }  
                   else
                   {
                     Node n = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);
                     assetCUG = getCUG(slingRequest,n.getParent().getPath());
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
                 e.printStackTrace();
            }
            return assetCUG;             
}

public String getCugenabled(SlingHttpServletRequest slingRequest,String nodepath) throws RepositoryException
{
            String node = nodepath.trim(); 
            boolean temp = false;               
            Node assetJcrNode = null;
            String pageCUG = "";
            try
            {                         
                 if(slingRequest.getResourceResolver().getResource(node+"/jcr:content") != null)
                 {    
                 assetJcrNode = slingRequest.getResourceResolver().getResource(node+"/jcr:content").adaptTo(Node.class);  
  
                        if(assetJcrNode.hasProperty("cq:cugEnabled"))
                        {
                            temp = true;
                            pageCUG = assetJcrNode.getProperty("cq:cugEnabled").getString();                    
                        }
                        else
                        {
                            Node parentNode = assetJcrNode.getParent().getParent();
                            pageCUG = getCugenabled(slingRequest,parentNode.getPath());
                              
                        } 
                   }  
                   else
                   {
                     Node n = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);
                     pageCUG = getCugenabled(slingRequest,n.getParent().getPath());
                   }          
            }
            catch(Exception e)
            {
                 e.printStackTrace();
            }
            
            
        return pageCUG;             
}

    
public String damdrawChildTree (Node rootNode, HttpServletRequest request, Node metadataNode, ResourceResolver resourceResolver, SlingHttpServletRequest slingRequest,String repStatus , String reference)throws RepositoryException
{
    StringBuffer outBuffer = new StringBuffer("");
                           
   

    if (rootNode != null) 
    {  
        // code to retirieve the child pages of the selected page in the itertor object
       if(rootNode.isNodeType("sling:OrderedFolder"))
       {
           Iterator<Node> damchildren = rootNode.getNodes();    

              try 
              { 
                  while (damchildren.hasNext()) 
                   {
                       Node damchild = damchildren.next();
                       DamManager damManager = resourceResolver.adaptTo(DamManager.class);
                       Session session = slingRequest.getResourceResolver().adaptTo(Session.class);

                      
                    if((damchild.isNodeType("dam:Asset"))&&(damchild.getPath().indexOf("/jcr:content")==-1)) {                         
                           Node jcrNode = slingRequest.getResourceResolver().getResource(damchild.getPath()+"/jcr:content").adaptTo(Node.class);
                           metadataNode = slingRequest.getResourceResolver().getResource(damchild.getPath()+"/jcr:content/metadata").adaptTo(Node.class);
                           long tm_creation = -1L;
                           long tm_lastReplicated = -1L; 
                           String lastReplicated = "";
                           String lastReplicationAction ="";
                           String pageAuthor = "";
                           String contentAuthorEmail = "";
                           String pathtoinclude ="";
                           String assetUrl="";
                           String assetURL = "";
                           String pagelink = "";
                           String cugs = "";
                           String description = "";
                           String cugEnabled = "";
                           String creationdate = "";
                           String siteowner = "";
                           String siteowneremail = ""; 
                           String referredPage = "";
 
                           
                           /*fetching the properties lastReplicated and lastReplicationAction*/
                           if(jcrNode.hasProperty("cq:lastReplicated")){
                                 lastReplicated = jcrNode.getProperty("cq:lastReplicated").getString();
                           }
                           if(jcrNode.hasProperty("cq:lastReplicationAction")){
                               if(jcrNode.getProperty("cq:lastReplicationAction").getString()!=null){
                                 lastReplicationAction = jcrNode.getProperty("cq:lastReplicationAction").getString();                
                               }  
                            }
                            /*end of fetching the properties lastReplicated and lastReplicationAction*/     
                           //outBuffer.append(lastReplicationAction);
                            
                           ACEManager aceManager = new ACEManager();
                           ACEConfigDataBean aceBean = aceManager.getACEConfigBean(aceManager.getACESitePageKey(damchild.getPath(),true));    
                           String domainAdd = aceBean.getPubDomainAdd();//"https://www1-int.accessmcd.com";
                           String dateFormat = aceBean.getDateFormat();//"MM.dd.yyyy HH:mm:ss";  
                          //outBuffer.append(dateFormat);
                           
                           /*Generating table for only activated assets*/
                           if(repStatus.equals(lastReplicationAction) && reference.equals("all"))
                           {                                          
                             //fetching path of the asset                              
                             assetUrl = jcrNode.getPath();  
                             int m = assetUrl.lastIndexOf("/jcr:content");       
                             assetURL= "https://author.accessmcd.com"+assetUrl.substring(0,m);
                               
                             //fetching title of the asset
                             String pageTitle="";
                             if(metadataNode.hasProperty("dc:title"))
                             {
                               pageTitle = metadataNode.getProperty("dc:title").getString();
                             } 
                             else
                             {
                               if (pageTitle == null || pageTitle.equals("")) 
                                pageTitle = damchild.getName();
                             }
                             //end of fetching Asset title
                            
                            //fetching properties Name and Email address of Asset author, Content author and Siteowner    
                             if(metadataNode.hasProperty("authname")){
                                    pageAuthor = metadataNode.getProperty("authname").getString();
                             }
                            // outBuffer.append(pageAuthor);
                             if(metadataNode.hasProperty("authemail")){     
                                    contentAuthorEmail = metadataNode.getProperty("authemail").getString();
                             }
                             //end of fetching properties Name and Email address
                             if(metadataNode.hasProperty("siteownername")){
                                    siteowner = metadataNode.getProperty("siteownername").getString();
                             }
                             
                             if(metadataNode.hasProperty("siteowneremail")){     
                                    siteowneremail = metadataNode.getProperty("siteowneremail").getString();
                             }
                             
                            //fetching the description of the asset
                             if(metadataNode.hasProperty("dc:description")){
                                    description = metadataNode.getProperty("dc:description").getString();
                             }
                             
                             //fetching the description of the asset
                             if(metadataNode.hasProperty("dc:description")){
                                    description = metadataNode.getProperty("dc:description").getString();
                             }
                             
                          // To get the Domain Address and Date Format for the Page / Site
                             if(jcrNode.hasProperty("cq:lastReplicated"))
                               {
                                    if(jcrNode.getProperty("cq:lastReplicated").getDate()!=null)
                                    {
                                        Calendar cal_lastReplicated = jcrNode.getProperty("cq:lastReplicated").getDate();
                                        tm_lastReplicated = cal_lastReplicated.getTimeInMillis();
                                        lastReplicated = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_lastReplicated);
                                     }
                                }
                               
                              //get the references of the DAM assets
                              String refPath = damchild.getPath();
                              HashSet<String> resurl = new HashSet<String>();
                              ArrayList<String> resUrl = new ArrayList<String>();
                              resurl = dam.getAssetReferences(slingRequest,refPath);
                              Iterator<String> referItr = resurl.iterator();
                              while(referItr.hasNext())
                                {
                                 referredPage = referItr.next();
                                 resUrl.add("https://www.accessmcd.com"+referredPage+".html");
                                }       
                                pagelink = resUrl.toString().replace("[","").replace("]","");
                                //check if Cug enabled or not  
                                cugEnabled = getCugenabled(slingRequest,damchild.getPath());                
                               
                               //get the cug groups
                                HashSet<String> cug = new HashSet<String>();              
                                cug = getCUG(slingRequest,damchild.getPath());
                                cugs = cug.toString().replace("[","").replace("]","");
                               
                                // get the creation time of the assets
                                if(damchild.hasProperty("jcr:created"))
                                {
                                    if(damchild.getProperty("jcr:created").getDate()!=null)
                                    {
                                        Calendar cal_creation = damchild.getProperty("jcr:created").getDate();
                                        tm_creation = cal_creation.getTimeInMillis();
                                        creationdate = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_creation);
                                     }
                                }
                                             
                                if(!"".equalsIgnoreCase(pageAuthor.trim()))
                                    {      
                                    outBuffer.append("<tr>");
                                    outBuffer.append("<td>" + ++count +"</td>");
                                    outBuffer.append("<td style=\"white-space:normal\"><a href='"+ assetURL +"'>"+ assetURL +"</a></td>");
                                   
                                    outBuffer.append("<td>"+ pageTitle +"</td>");
                                    outBuffer.append("<td>"+ description +"</td>");
                                    outBuffer.append("<td>"+ pageAuthor +"</td>");
                                    outBuffer.append("<td>"+contentAuthorEmail+ "</td>");
                                    outBuffer.append("<td>"+ siteowner+"</td>");
                                    outBuffer.append("<td>"+siteowneremail+ "</td>");
                                    outBuffer.append("<td class='nowrap'>"+ creationdate + "</td>"); 
                                    outBuffer.append("<td class='nowrap'>"+ lastReplicated + "</td>"); 
                                   //  outBuffer.append("<td class='nowrap'>"+ tm_lastReplicated + "</td>"); 
                                    outBuffer.append("<td style = \"white-space:normal\">");
                                    for(String ref : pagelink.split(",")){
                                    outBuffer.append("<a href='"+ ref +"'>" + ref + "</a>");
                                    }
                                    outBuffer.append("</td>");
                                    outBuffer.append("<td>"+ cugEnabled +"</td>");
                                    outBuffer.append("<td>"+ cugs +"</td>");
                                    outBuffer.append("</tr>"); 
                                    }
                           } 
                           if(repStatus.equals(lastReplicationAction) && reference.equals("referenced"))
                           {                                          
                             //fetching path of the asset                              
                             assetUrl = jcrNode.getPath();  
                             int m = assetUrl.lastIndexOf("/jcr:content");       
                             assetURL= "https://author.accessmcd.com"+assetUrl.substring(0,m);
                               
                             //fetching title of the asset
                             String pageTitle="";
                             if(metadataNode.hasProperty("dc:title"))
                             {
                               pageTitle = metadataNode.getProperty("dc:title").getString();
                             } 
                             else
                             {
                               if (pageTitle == null || pageTitle.equals("")) 
                                pageTitle = damchild.getName();
                             }
                             //end of fetching Asset title
                            
                            //fetching properties Name and Email address of Asset author, Content author and Siteowner    
                             if(metadataNode.hasProperty("authname")){
                                    pageAuthor = metadataNode.getProperty("authname").getString();
                             }
                            // outBuffer.append(pageAuthor);
                             if(metadataNode.hasProperty("authemail")){     
                                    contentAuthorEmail = metadataNode.getProperty("authemail").getString();
                             }
                             //end of fetching properties Name and Email address
                             if(metadataNode.hasProperty("siteownername")){
                                    siteowner = metadataNode.getProperty("siteownername").getString();
                             }
                             
                             if(metadataNode.hasProperty("siteowneremail")){     
                                    siteowneremail = metadataNode.getProperty("siteowneremail").getString();
                             }
                             
                            //fetching the description of the asset
                             if(metadataNode.hasProperty("dc:description")){
                                    description = metadataNode.getProperty("dc:description").getString();
                             }
                             
                             //fetching the description of the asset
                             if(metadataNode.hasProperty("dc:description")){
                                    description = metadataNode.getProperty("dc:description").getString();
                             }
                             
                          // To get the Domain Address and Date Format for the Page / Site
                             if(jcrNode.hasProperty("cq:lastReplicated"))
                               {
                                    if(jcrNode.getProperty("cq:lastReplicated").getDate()!=null)
                                    {
                                        Calendar cal_lastReplicated = jcrNode.getProperty("cq:lastReplicated").getDate();
                                        tm_lastReplicated = cal_lastReplicated.getTimeInMillis();
                                        lastReplicated = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_lastReplicated);
                                     }
                                }
                               
                              //get the references of the DAM assets
                              String refPath = damchild.getPath();
                              HashSet<String> resurl = new HashSet<String>();
                              ArrayList<String> resUrl = new ArrayList<String>();
                              resurl = dam.getAssetReferences(slingRequest,refPath);
                              Iterator<String> referItr = resurl.iterator();
                              while(referItr.hasNext())
                                {
                                 referredPage = referItr.next();
                                 resUrl.add("https://www.accessmcd.com"+referredPage+".html");
                                }       
                                pagelink = resUrl.toString().replace("[","").replace("]","");
                                //check if Cug enabled or not  
                                cugEnabled = getCugenabled(slingRequest,damchild.getPath());                
                               
                               //get the cug groups
                                HashSet<String> cug = new HashSet<String>();              
                                cug = getCUG(slingRequest,damchild.getPath());
                                cugs = cug.toString().replace("[","").replace("]","");
                               
                                // get the creation time of the assets
                                if(damchild.hasProperty("jcr:created"))
                                {
                                    if(damchild.getProperty("jcr:created").getDate()!=null)
                                    {
                                        Calendar cal_creation = damchild.getProperty("jcr:created").getDate();
                                        tm_creation = cal_creation.getTimeInMillis();
                                        creationdate = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_creation);
                                     }
                                }
                                             
                                if(!"".equalsIgnoreCase(pageAuthor.trim())&& (!"".equals(pagelink)))
                                    {      
                                    outBuffer.append("<tr>");
                                    outBuffer.append("<td>" + ++count +"</td>");
                                    outBuffer.append("<td style=\"white-space:normal\"><a href='"+ assetURL +"'>"+ assetURL +"</a></td>");
                                   
                                    outBuffer.append("<td>"+ pageTitle +"</td>");
                                    outBuffer.append("<td>"+ description +"</td>");
                                    outBuffer.append("<td>"+ pageAuthor +"</td>");
                                    outBuffer.append("<td>"+contentAuthorEmail+ "</td>");
                                    outBuffer.append("<td>"+ siteowner+"</td>");
                                    outBuffer.append("<td>"+siteowneremail+ "</td>");
                                    outBuffer.append("<td class='nowrap'>"+ creationdate + "</td>"); 
                                    outBuffer.append("<td class='nowrap'>"+ lastReplicated + "</td>"); 
                                   //  outBuffer.append("<td class='nowrap'>"+ tm_lastReplicated + "</td>"); 
                                    outBuffer.append("<td style = \"white-space:normal\">");
                                    for(String ref : pagelink.split(",")){
                                    outBuffer.append("<a href='"+ ref +"'>" + ref + "</a>");
                                    }
                                    outBuffer.append("</td>");
                                    outBuffer.append("<td>"+ cugEnabled +"</td>");
                                    outBuffer.append("<td>"+ cugs +"</td>");
                                    outBuffer.append("</tr>"); 
                                    }
                           } 
                           if(repStatus.equals(lastReplicationAction) && reference.equals("nonreferenced"))
                           {                                          
                             //fetching path of the asset                              
                             assetUrl = jcrNode.getPath();  
                             int m = assetUrl.lastIndexOf("/jcr:content");       
                             assetURL= "https://author.accessmcd.com"+assetUrl.substring(0,m);
                               
                             //fetching title of the asset
                             String pageTitle="";
                             if(metadataNode.hasProperty("dc:title"))
                             {
                               pageTitle = metadataNode.getProperty("dc:title").getString();
                             } 
                             else
                             {
                               if (pageTitle == null || pageTitle.equals("")) 
                                pageTitle = damchild.getName();
                             }
                             //end of fetching Asset title
                            
                            //fetching properties Name and Email address of Asset author, Content author and Siteowner    
                             if(metadataNode.hasProperty("authname")){
                                    pageAuthor = metadataNode.getProperty("authname").getString();
                             }
                            // outBuffer.append(pageAuthor);
                             if(metadataNode.hasProperty("authemail")){     
                                    contentAuthorEmail = metadataNode.getProperty("authemail").getString();
                             }
                             //end of fetching properties Name and Email address
                             if(metadataNode.hasProperty("siteownername")){
                                    siteowner = metadataNode.getProperty("siteownername").getString();
                             }
                             
                             if(metadataNode.hasProperty("siteowneremail")){     
                                    siteowneremail = metadataNode.getProperty("siteowneremail").getString();
                             }
                             
                            //fetching the description of the asset
                             if(metadataNode.hasProperty("dc:description")){
                                    description = metadataNode.getProperty("dc:description").getString();
                             }
                             
                             //fetching the description of the asset
                             if(metadataNode.hasProperty("dc:description")){
                                    description = metadataNode.getProperty("dc:description").getString();
                             }
                             
                          // To get the Domain Address and Date Format for the Page / Site
                             if(jcrNode.hasProperty("cq:lastReplicated"))
                               {
                                    if(jcrNode.getProperty("cq:lastReplicated").getDate()!=null)
                                    {
                                        Calendar cal_lastReplicated = jcrNode.getProperty("cq:lastReplicated").getDate();
                                        tm_lastReplicated = cal_lastReplicated.getTimeInMillis();
                                        lastReplicated = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_lastReplicated);
                                     }
                                }
                               
                              //get the references of the DAM assets
                              String refPath = damchild.getPath();
                              HashSet<String> resurl = new HashSet<String>();
                              ArrayList<String> resUrl = new ArrayList<String>();
                              resurl = dam.getAssetReferences(slingRequest,refPath);
                              Iterator<String> referItr = resurl.iterator();
                              while(referItr.hasNext())
                                {
                                 referredPage = referItr.next();
                                 resUrl.add("https://www.accessmcd.com"+referredPage+".html");
                                }       
                                pagelink = resUrl.toString().replace("[","").replace("]","");
                                //check if Cug enabled or not  
                                cugEnabled = getCugenabled(slingRequest,damchild.getPath());                
                               
                               //get the cug groups
                                HashSet<String> cug = new HashSet<String>();              
                                cug = getCUG(slingRequest,damchild.getPath());
                                cugs = cug.toString().replace("[","").replace("]","");
                               
                                // get the creation time of the assets
                                if(damchild.hasProperty("jcr:created"))
                                {
                                    if(damchild.getProperty("jcr:created").getDate()!=null)
                                    {
                                        Calendar cal_creation = damchild.getProperty("jcr:created").getDate();
                                        tm_creation = cal_creation.getTimeInMillis();
                                        creationdate = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_creation);
                                     }
                                }
                                             
                                if(!"".equalsIgnoreCase(pageAuthor.trim())&& ("".equals(pagelink)))
                                    {      
                                    outBuffer.append("<tr>");
                                    outBuffer.append("<td>" + ++count +"</td>");
                                    outBuffer.append("<td style=\"white-space:normal\"><a href='"+ assetURL +"'>"+ assetURL +"</a></td>");
                                   
                                    outBuffer.append("<td>"+ pageTitle +"</td>");
                                    outBuffer.append("<td>"+ description +"</td>");
                                    outBuffer.append("<td>"+ pageAuthor +"</td>");
                                    outBuffer.append("<td>"+contentAuthorEmail+ "</td>");
                                    outBuffer.append("<td>"+ siteowner+"</td>");
                                    outBuffer.append("<td>"+siteowneremail+ "</td>");
                                    outBuffer.append("<td class='nowrap'>"+ creationdate + "</td>"); 
                                    outBuffer.append("<td class='nowrap'>"+ lastReplicated + "</td>"); 
                                   //  outBuffer.append("<td class='nowrap'>"+ tm_lastReplicated + "</td>"); 
                                    outBuffer.append("<td style = \"white-space:normal\">");
                                    for(String ref : pagelink.split(",")){
                                    outBuffer.append("<a href='"+ ref +"'>" + ref + "</a>");
                                    }
                                    outBuffer.append("</td>");
                                    outBuffer.append("<td>"+ cugEnabled +"</td>");
                                    outBuffer.append("<td>"+ cugs +"</td>");
                                    outBuffer.append("</tr>"); 
                                    }
                           }  
                      } 
                      outBuffer.append(damdrawChildTree(damchild,request,metadataNode,resourceResolver,slingRequest,repStatus,reference)); 
                 }
                            
                          
                           
                 }catch(Exception e){}
                 
              }
      }
     // return the html code as string //
    return outBuffer.toString();
}
%>


<%
    String errMsg = "";
    String rootPath = (String)request.getParameter("rootPath");

    if( (!(rootPath != null)) || (!(rootPath.length() > 0)) )
    {
        rootPath = "";        
    }
    String assetref= (String)request.getParameter("assetref");
    if( assetref== null ){
        assetref= "";        
    }
   String repStatus = request.getParameter("repstatus");

%>
<%

    String hidAction = (String) request.getParameter("hidAction");

    
          count=0;
          Calendar cal_lastcutdate = Calendar.getInstance();
          long tm_lastcutdate = cal_lastcutdate.getTimeInMillis();
          String lastcutdate = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_lastcutdate);        
        
               
                    if(rootPath.startsWith("/content/dam"))       
                    {   
                            response.setHeader("Content-Disposition", "attachment; filename=\"AccessMCD-DAMReferencesReport.xls\"");                        
                            Node damNode = slingRequest.getResourceResolver().getResource(rootPath).adaptTo(Node.class); 
                            out.println("Asset References under<b>"+rootPath+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss]<br><br>");

            %>
                     <table class="pagetable" width="100%" cellpadding="0" cellspacing="1" border="1">
                        <tr>
                        <th>S.No</th>
                        <th>DAM Content</th>
                        <th>Asset Title</th>
                        <th>Asset Description</th>
                        <th>Content Author Name</th>
                        <th>Content Author Email</th>
                        <th>Site Owner Name</th>
                        <th>Site Owner Email</th>
                        <th>Creation Date</th>
                        <th>Last Replication Date</th>   
                        <th>Page Link </th> 
                        <th>CUG Enabled</th> 
                        <th>CUG Groups</th>    
                        
            <%             
                       
                        out.println(damdrawChildTree(damNode,request,metadataNode,resourceResolver,slingRequest,repStatus,assetref));
            %> 
            </tr>          
            </table>
<% } %>            