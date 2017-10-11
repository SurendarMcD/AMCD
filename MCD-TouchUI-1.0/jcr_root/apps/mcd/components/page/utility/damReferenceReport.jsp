<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<%@include file="/apps/mcd/global/global.jsp"%>  
<%@ page import="java.util.Calendar,
        java.util.Locale,
        java.text.SimpleDateFormat,
        java.util.Iterator,
        java.lang.System.*,
        org.apache.jackrabbit.util.Text,
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
        com.day.cq.security.*,
        java.util.*,
        org.apache.sling.commons.json.JSONObject,
        java.net.URISyntaxException,
        java.net.URL,
        java.io.InputStream,
        java.io.BufferedReader,
        java.io.InputStreamReader,
        java.nio.charset.Charset,
        java.io.Reader,
        java.io.Writer,
        java.text.DecimalFormat,
        java.io.IOException,
        com.day.cq.dam.api.*,
        org.apache.sling.commons.json.JSONArray,
        org.apache.sling.commons.json.JSONException,
        org.apache.sling.api.resource.ResourceResolver,
        java.net.URLConnection,
        java.net.HttpURLConnection,
        com.mcd.accessmcd.dam.damUtil"%>

<HEAD>
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>    
<TITLE> DAM Report Utility </TITLE>
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
table.pagetable th {
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
.nowrap{
    white-space:nowrap;
}
.rightAlign{
    text-align:right;
}

font.error
{
    color: #ce0000;
    font-size:13px;
}
table.pagetable.td p { 
   display: block;
    margin-top: 1em;
    margin-bottom: 1em;
    margin-left: 0;
    margin-right: 0;
}
 #ajaxSpinnerImage {
          display: none;
     }
</style>
</HEAD>

<BODY>
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
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);
    String errMsg = "";
    String rootPath = (String)request.getParameter("rootPath");

    if( (!(rootPath != null)) || (!(rootPath.length() > 0)) )
    {
        rootPath = "";        
    }


%>
<a name="top"></a>
<div style="width:100%;padding-top:5px;">
<img  src='/images/accessmcd.gif' />
</div>

<form id="report" name="report" action="#" style="margin-top: -45px;">
<table border=0 width="100%"  style="margin-top:10px"><tr><td align="right"><font size="2" color="red">Logged In User:&nbsp;<b><%=user.getName()%></b></font></td></tr> </table>


<input type="hidden" name="hidAction" value="Clear"/>

<h3>DAM Asset References Report Utility</h3>
<br>
    <p style="margin-top:-20px;text-align:center;">
       <i>The Report Utility will only list the pages that are in the activated state.</i>
    </p>           
<hr style="margin-top:-8px;">
<br><b>
&nbsp;Enter the path of a DAM folder:&nbsp;&nbsp;</b>
<input type="text" name="rootPath" id="rootpath" value='<%=rootPath %>' size="40px"></input>    
<br>
<label style="font-size:12px"> &nbsp;The path should start with "/content/dam/accessmcd".</label> <br>
<label style="font-size:12px;color:#808080;"> &nbsp;<b>Note:</b> Please dont append .html to the path entered </label> <br>
<br>
<b>&nbsp;Select Type of Assets:&nbsp;&nbsp;</b>
<input type="radio" class="radio-button" name="repstatus" value="Activate">Activated Assets
<input type="radio" class="radio-button" name="repstatus" value="Deactivate">Deactivated Assets
<br>
<br>
   <b>&nbsp;Select Asset Reference Type:&nbsp;&nbsp;</b>
        <select id="assetref" name="assetref">
            <option value="noval">Please select Asset Reference</option>
            <option value="all">All</option>
            <option value="referenced">Referenced Asset</option>
            <option value="nonreferenced">Non Referenced Asset</option>
          </select> 
          <br>
        <label style="font-size:12px"> &nbsp;Show assets on the basis of selected value</label> 
        <br>
        <br>
<input id = "ShowInfo" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="ShowInfo" />
<input id = "Clear" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Clear';" value="Clear" />    
<input id="Export" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Export';" value="Export To Excel" />
<br><br>
<hr style=""> 
<%

String hidAction = (String) request.getParameter("hidAction");
String assetref= (String)request.getParameter("assetref");
    if( assetref== null ){
        assetref= "";        
    }
String sCommand = request.getParameter("repstatus");
 
if(hidAction != null) 
  {
      if(hidAction.equals("ShowInfo")) 
      {     
          count=0;
          Calendar cal_lastcutdate = Calendar.getInstance();
          long tm_lastcutdate = cal_lastcutdate.getTimeInMillis();
          String lastcutdate = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_lastcutdate);        
        
            try
            {   
            if((!(rootPath != null)) || (!(rootPath.length() > 0)))
            {
                //errMsg = "Please provide the path.";
                out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Please provide the path. </span></b></p>");
            }  
            else{       
            if(rootPath.startsWith("/content/dam"))       
               {   
                      
                  out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Asset References under<b>"+rootPath+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
                  
                  Node rootNode = null;
                    if(slingRequest.getResourceResolver().getResource(rootPath)!=null)
                     {   
                        rootNode = slingRequest.getResourceResolver().getResource(rootPath).adaptTo(Node.class);

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
                    </tr>    
                        <%= damdrawChildTree(rootNode,request,metadataNode,resourceResolver,slingRequest,sCommand,assetref) %>                          
                 </table>
                 <br>
                 <div style="text-align:center"><a href="#top"><strong>Return to Top</strong></a><div>   
            <%           
            
                      } 
              }   
              else
              {
                  //errMsg = "Path entered is invalid.";
                out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Path entered is invalid. </span></b></p>");
              }
          }    
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

     } else if(hidAction.equals("Export")) {
       if(rootPath.startsWith("/content/dam/accessmcd"))
         {
            
                String url = "/utility/utility.exportDamReferenceReport.html?rootPath="+rootPath+"&repstatus="+sCommand+"&assetref="+assetref;
                response.sendRedirect(url);
            
         }

       }    
}
%>
</form>

<script>

$('#Clear').click(
    function(){
        $('#rootpath').val('');
    });
  $(document).ready(function() {
        
        sortDropDownListByText("#assetref", "Please select Asset Reference","<%=assetref%>");
        RadionButtonSelectedValueSet("repstatus","<%=sCommand%>");
    });
    
    function RadionButtonSelectedValueSet(name, SelectdValue) {
    $('input[name="' + name+ '"][value="' + SelectdValue + '"]').attr('checked', 'checked');
    }
    function sortDropDownListByText(selectId, dummyVal,assetref) {
        $(selectId).html($(selectId + " option").sort(function(a, b) {
            if (a.text == dummyVal) {
                return -1;
            }
            return a.text == b.text ? 0 : a.text < b.text ? -1 : 1
        }))
        if(assetref== "noval"){
            $("#assetref option:first").attr('selected','selected'); 
        }
        else{
            $('#assetref').val(assetref);
           
        }    
    }

</script>

</BODY>
</HTML>