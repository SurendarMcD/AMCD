<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<%@include file="/apps/mcd/global/global.jsp" %>
<%@page import="com.day.cq.dam.api.*,
                javax.jcr.Session,com.day.cq.wcm.foundation.Download,
                javax.jcr.*,
                org.apache.sling.api.resource.Resource,
                java.io.Writer,
                java.io.IOException,
                java.util.ArrayList,
                java.util.Iterator,
                java.util.Enumeration,
                java.text.DecimalFormat,
                com.day.cq.security.UserManagerFactory,
                com.day.cq.security.UserManager,
                com.day.cq.security.User,
                com.day.cq.security.Group,
                com.mcd.accessmcd.ace.manager.ACEManager,
                com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
                com.mcd.accessmcd.usermanagement.user.manager.UserMaintenanceManager,
                com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean"%>
                
<HEAD>
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
</style>
</HEAD>

<BODY>
<%!

String superUser = "admin";
double count = 0;
double totalSize = 0;
double[] countSize = new double[2];
int nodeCount = 1;
double folderlevelCount = 0;
int folderCount = 0;
ArrayList<String> folderName = new ArrayList<String>();
String size = "bytes";
int nodeLevel = 0;
String[] restrictSites = {"/content",
                          "/content/accessmcd",
                          "/content/utility"
};

public boolean isAceSite(ArrayList userGrpList,Writer out)throws IOException{
    boolean rt = false;
    
    // get ACE site keys    
    ACEManager aceManager = new ACEManager();
    Enumeration allURLs = aceManager.getAllSiteKeys();
    while(allURLs.hasMoreElements())
    {
        String theURL = (String)allURLs.nextElement();              
        
        if (!checkRestrictSites(theURL)) {            
            ACEConfigDataBean aceBean = aceManager.getACEConfigBean(theURL);
            
            if(userGrpList.contains(aceBean.getGroupName()) ) {
                //if( (rootPath.equals(theURL)) || (rootPath.indexOf(theURL+"/")>-1) ){
                    rt=true;
               // }
                
            }
        }
    }
    
    return rt;
}

public boolean checkRestrictSites(String curPage){
        boolean rt = false;
        if(restrictSites!=null){
            for (int j = 0; j < restrictSites.length; j++) 
            {                           
                 if(curPage.equals(restrictSites[j])){                                                        
                    rt=true;
                 }
             }  
        }
        return rt;
}


int getNodeLevel(String currentNodePath,String rootNodeName,String currentNodeName)
{
    int rootNodeIndex = currentNodePath.indexOf("/"+rootNodeName);
    int currentNodeIndex = currentNodePath.indexOf("/"+currentNodeName);
    String middleStr = currentNodePath.substring(rootNodeIndex,currentNodeIndex);
    
    for(int i =0; i < middleStr.length(); i++)      
    {
        if(middleStr.charAt(i) == '/')
            
        nodeLevel++;    
    
    }
    
    
return nodeLevel;    
    
    
}


double getSize(double damFolder)
{
           if(damFolder>(1024*1024*1024))
           {
               damFolder = damFolder/(1024*1024*1024); 
               size = "GB";
               
           }
           else if(damFolder>(1024*1024))
           {
                damFolder = damFolder/(1024*1024);   
                size = "MB";
           }
           else if(damFolder>1024)
           {
                damFolder = damFolder/1024;   
                size = "KB";
           }
           else
           {
                damFolder = damFolder;   
                size = "bytes";
           }
      return  damFolder;    
}

int getFolderCount(Node damNode,Writer out) throws RepositoryException,IOException
{
    //out.write("Node name"+damNode.getName()+"<br>");
    if(damNode.hasNodes())
    {
        NodeIterator iterator = damNode.getNodes();
        while(iterator.hasNext())
        {
            Node childNode = iterator.nextNode();
            Property primaryType = childNode.getProperty("jcr:primaryType");
            String assetType  = primaryType.getString(); 
            if(assetType.equals("sling:OrderedFolder"))
            {   
                 
                 //out.write("Node Name"+childNode.getName());
                 folderCount++;
                 folderName.add(childNode.getPath());
                 //out.write("Node name"+childNode.getName());
                 //out.write("Folder Name"+folderName[folderCount-1]);
                 
                // out.write("Folder Count"+folderCount+"<br>");
                 getFolderCount(childNode,out);                                  
            }
        }
    }
    
   return folderCount; 
}


double[] getFolderDetails(DamManager damManager,Session session,Node damNode,Writer out) throws RepositoryException,IOException  
{
    
      boolean checkNodes = damNode.hasNodes();

    if(checkNodes)
    {
            NodeIterator iterator = damNode.getNodes();       
            while(iterator.hasNext())
            {
                Node childNode = iterator.nextNode();
                Property primaryType = childNode.getProperty("jcr:primaryType");
                String nodeType  = primaryType.getString();
                
                if(nodeType.equals("dam:Asset"))
                {
                     String assetNodePath =  childNode.getPath();
                     String assetBinaryPath = assetNodePath.replaceFirst("/content","/var");  
                     
                     Asset asset = damManager.createAssetStructure(assetBinaryPath,session,true);
                     
                     Rendition assetDAMRendition = asset.getCurrentOriginal();
                     if(assetDAMRendition!=null)
                     {
                         
                         String assetRenditionName = assetDAMRendition.getPath();
                         long renditionSize = 0;
                         renditionSize = (assetDAMRendition.getSize());                                       
                         //renditionSize = (assetDAMRendition.getSize())/1024;                                       
                         totalSize += renditionSize;
                         
                         
                     }  
                     
                     count++;
                     
                } 
                else if(nodeType.equals("sling:OrderedFolder"))
                {  
                      getFolderDetails(damManager,session,childNode,out);                
                }     
                  
            }
    }


countSize[0] = count;
countSize[1] = totalSize;
return countSize;

}

%>
<%
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);
    
    String userID = user.getID();
    
    final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
    ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());
    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
    UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
    UserMaintenanceManager umManager = new UserMaintenanceManager(sling, bundle, jcrSession, uMgr, resourceResolver);
    
    ArrayList grpArrList = umManager.getUserGroupsDetails(user.getID());
    ArrayList userGrpList = new ArrayList();
    GroupDataBean grpBean = null;
    for(int i = 0 ; i < grpArrList.size() ; i++)
    {
        grpBean = (GroupDataBean)grpArrList.get(i);
        userGrpList.add(grpBean.getGroupID());
    }

    
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


<%

if(!(userID.trim().equals(superUser)) && !isAceSite(userGrpList,out) )
    {
        
%>
        <table border=0 width="100%"  style="margin-top:10px"><tr><td align="center"><font size="4" color="#ce0000">You are not authorised to view the form.</b></font></td></tr> </table>    
<%   
       
        return;
    }
    
    
else
{    




%>



<input type="hidden" name="hidAction" value="Clear"/>

<h3>DAM Report Utility</h3>
<br>           
<hr style="margin-top:-8px;">
<br><b>
&nbsp;Enter the path of a DAM folder:&nbsp;&nbsp;</b>
<input type="text" name="rootPath" id="rootpath" value='<%=rootPath %>' size="40px"></input>    
<br>
<label style="font-size:12px"> &nbsp;The path should start with "/content/dam/accessmcd".</label>
<br>
<br>
<input class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="ShowInfo" />
<input class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Clear';" value="Clear" />    
<br><br>
<hr style=""> 
<%

    String hidAction = (String) request.getParameter("hidAction");
    //String size = "bytes";
    DecimalFormat df = new DecimalFormat("###.##");


    if(hidAction != null) 
    {
      if(hidAction.equals("ShowInfo")) 
      {     
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
                        if(user.hasPermissionOn("wcm/core/privileges/replicate",rootPath))
                        {
                            Node damNode = slingRequest.getResourceResolver().getResource(rootPath).adaptTo(Node.class); 
                            DamManager damManager = resourceResolver.adaptTo(DamManager.class);
                            Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
                                       
                            double[] damFolder = new double[2];          
                            count = 0;
                            totalSize = 0;
            
                            out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Folder Details of <b>"+rootPath+"</b></p>");
                    
            %>
                        <table class="pagetable" width="100%">
                        <tr>
                        <th>S.No</th>
                        <th>Name of DAM Folder</th>
                        <th>No. of Assets under this folder</th>
                        <th>Size</th>
                        </tr>
                         
            <%                     
                       damFolder = getFolderDetails(damManager,session,damNode,out);
                       
                       String nodeTitle = damNode.getName();
                       String bulletSign = ">>";
            %>           
                        <tr>
                        <td>1</td>   
                        <td><b>&nbsp;<%=nodeTitle%></td>   
                        <td><b><%=(int)damFolder[0]%></td>
                        <td><b><%=df.format(getSize(damFolder[1]))%>&nbsp;<%=size%></td>
                        </tr>
            
            <%    
                      folderCount = 0;
                      int childFolderCount = getFolderCount(damNode,out);  
                      //out.println("Folder Count"+childFolderCount);
                      int k = 0;
                      for(int i=0;i<childFolderCount;i++)
                      {
                          
                          count = 0;
                          totalSize = 0;
                          //out.println("Name"+folderName[i]+"<br>");
                          Node childFolder = slingRequest.getResourceResolver().getResource(folderName.get(i)).adaptTo(Node.class);              
                          damFolder = getFolderDetails(damManager,session,childFolder,out);
                          
                          nodeLevel = 0;
                          nodeLevel = getNodeLevel(folderName.get(i),nodeTitle,childFolder.getName());                                                
            %>                         
                                                <tr>
                                                <td><%=i+2%></td> 
                                                <td style="padding-left:<%=10+(nodeLevel*3)%>px"><%=bulletSign %>&nbsp;<%=childFolder.getName()%></td>
                                                <!-- <td><%=bulletSign %>&nbsp;<%=childFolder.getName()%></td> -->
                                                <td><%=(int)damFolder[0]%></td>
                                                <td><%=df.format(getSize(damFolder[1]))%>&nbsp;<%=size%></td>
                                                </tr>
            <%  
                    
                      }
                      
            %>        
            </table>
            <%            
                  
                  }
                  else
                  {
                
                      out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> ERROR : Sorry, you are not authorized to execute the utility on " + rootPath + ". Please enter a valid DAM folder path. </span></b></p>");     
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
              
     } 
   }    
}
%>

</BODY>
</HTML>