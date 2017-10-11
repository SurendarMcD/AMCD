<%-- #############################################################################
# DESCRIPTION:  Flash Utility Component is used to upload assets of flash
#
# Author: Deepali 
# Environment: 
# 
# INTERFACE   
# Controller: 
# Targets: 
# Inputs: global.jsp 
#                    
# Outputs:      
#   
# UPDATE HISTORY        
# 1.0  Deepali Goyal, 05-05-2010, Initial Version 
# 
# Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
###################################################################################--%>

<%@page session="false"
        contentType="text/html"
        pageEncoding="utf-8"
        import="java.util.Iterator,
            javax.jcr.Node,
            org.apache.jackrabbit.util.Text,
            com.day.cq.wcm.foundation.Download,
            com.day.cq.wcm.api.components.DropTarget,
            com.day.cq.wcm.api.WCMMode,
            com.day.cq.wcm.commons.WCMUtils,
            java.util.zip.ZipInputStream,
            java.util.zip.ZipEntry,
            java.util.Calendar,
            javax.activation.MimetypesFileTypeMap,
            java.io.FileInputStream,
            java.io.InputStream,
            java.io.File,
            java.io.FileOutputStream,
            java.io.IOException,
            java.io.FileNotFoundException" %><%
%><%@include file="/apps/mcd/global/global.jsp"%><% 
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects /><%
%>
 
<table border="0" width="100%" height="530px" cellspacing="0" cellpadding="0">
  <tr>
    <td width="20%" bgcolor="#999966" valign="top">&nbsp;
    
    <div id="zipupload">
<%
    //hidden field to check if any change has been made in the zip file or not
    String flag = properties.get("flag", "0");

    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "file";
    
    Download dld = new Download(resource);  
    
    //retrieve the path where the zip folder is to be added
    String docRootPath = prop.getProperty("flashutilityPath_" + currentPage.getAbsoluteParent(1).getName()); 
    //MailNotification mailnotification = new MailNotification();

    Node docRootNode = null;
    Node rootNode = null;
    StringBuffer sb = null;
    String firstDirName = "";
    String firstDirPage = "";
    String path = "";
    if(docRootPath == null)
    {
%>
        </div>
        </td>
        
        <td width="100%" valign="top" style="padding:10px 20px 0 10px;">    
        <div style="color:#000000;font-weight:bold;font-size:12;"><%= langText.get("Please provide path in the properties file.") %></div>
<% 
    }
    else if(dld.hasContent())
    {
        String href = Text.escape(dld.getHref(), '%', true);
        String title = dld.getTitle(true);
        
        %>
        <p style="margin:3 0 0 20"><b>
                <font face="Arial" size="2" color="#000000">
                    &raquo;&nbsp;
                    <a style="color:#000000;font-weight:bold;" href="<%= href%>" title="<%=title%>"><%= langText.get("Download Zip") %></a> <br>
                </font>
        </b></p>
        
    </div><div class="clear"></div>
    
    
    </td>
    
    <td width="100%" valign="top" style="padding:22px 10px 0 25px;">
      <div style="padding-bottom:20px">
            <img src="/libs/foundation/components/download/resources/zip.gif" />
            <font face="Arial" size="2" color="#000000">
                <a style="color:#000000;font-weight:bold;" href="<%= href%>" title="<%=title%>"><%= (dld.getInnerHtml() == null ? dld.getFileName() : dld.getInnerHtml())%></a>
            </font>
      </div>
      
    <%  //if new zip file is added or if changes are made in the old file
        if(flag.equals("1"))
        {
        
            try
            {
                docRootNode = slingRequest.getResourceResolver().getResource(docRootPath).adaptTo(Node.class);
                ZipInputStream zip =  new ZipInputStream(dld.getData().getStream());
                ZipEntry entry = null;
                int i=0;
                //iterate to retrieve all the entries in the zip folder
                while ((entry = zip.getNextEntry())!=null)
                {
                    String fileName = entry.getName();                     
                    String [] check=fileName.split("/");        
                    
                    out.print("<div class=\"action\" style='width:50px'>" + langText.get("Create") + "</div>");
                    out.print("<div class=\"title\" style='width:675px'>"+ fileName + "</div>");
                    out.print("<div class=\"path\"></div><br>");
                      
                    //Checking if it is a parent directory
                    if(i==0)
                    {
                        firstDirName = check[0];
                        firstDirPage = docRootPath + "/" + firstDirName;
                        try{
                            //set the flag to "0" so that the file is uploaded only when zip file is changed or a new zip file is added
                            currentNode.setProperty("docroot_path", firstDirPage);
                            currentNode.save();
                            currentNode.refresh(true);
                        }
                        catch(Exception e){   
                            log.error("docRootPath not set :: " + e); 
                        }

%>

        <br><strong><%= langText.get("Starting uploading") %> :</strong><br>
      <hr size="1">
        
<%
                        //checking if parent directory is already created
                        if(docRootNode.hasNode(firstDirName))
                        {
                            rootNode = slingRequest.getResourceResolver().getResource(firstDirPage).adaptTo(Node.class);
                            //deleting the directory folder if foldfer is already avalaible
                            rootNode.remove();
                        }
                    
                        //creating the directory structure
                        rootNode = docRootNode.addNode(firstDirName,"nt:folder");   

                        path = firstDirPage;
                        docRootNode.save();
                        docRootNode.refresh(true);
                        
                        i++;
                    }
                    
                    //Check if it is a directory
                    if (entry.isDirectory())
                    {
                        String existDirPage = docRootPath + "/" + fileName.substring(0,fileName.lastIndexOf("/")) ;
                        String dirName = check[check.length-1];
                        rootNode = slingRequest.getResourceResolver().getResource(existDirPage.substring(0,existDirPage.lastIndexOf("/"))).adaptTo(Node.class);
                       
                        if(!rootNode.hasNode(dirName))
                        {
                            
                            Node childNode = rootNode.addNode(dirName,"nt:folder");
                            log.error(dirName + " directory created");
                            rootNode.save();
                            rootNode.refresh(true);
                        }
                        
                        continue; 
                    }
        
                    String existPageHandle = docRootPath + "/" + fileName.substring(0,fileName.lastIndexOf("/"));
                    
                    String existFileName = docRootPath + "/" + fileName;
                    
                    Node file = null;
                    if(docRootNode.hasNode(fileName))
                    {
                        file = slingRequest.getResourceResolver().getResource(existFileName).adaptTo(Node.class);
                        file.remove();
                    }
                    
                    byte[] buffer = new byte[(int) entry.getSize()];
                    InputStream is = writeData(buffer, fileName.substring((fileName.lastIndexOf("/")+1)), zip);
                    
                    String mimeType = new MimetypesFileTypeMap().getContentType(fileName);
                   
                    file = docRootNode.addNode(fileName,"nt:file");
                    
                    Node data = file.addNode("jcr:content","nt:resource");
                    data.setProperty("jcr:data",is);
                    data.setProperty("jcr:mimeType",new MimetypesFileTypeMap().getContentType(fileName));
                    data.setProperty("jcr:lastModified",Calendar.getInstance());
                    
                    docRootNode.save();
                    docRootNode.refresh(true);
               } 
               if(zip!=null) { 
                   zip.close();
                   
                   File tempDir = new File("zipcontent"); 
                   if(tempDir.exists()) {
                       tempDir.delete();
                   }
               }
               
                 
        %><hr size="1"><br>      
        <div> <strong><%= langText.get("Zip file uploaded") %>. </strong> </div>
        <div>
            <%       
                 try{
                    //set the flag to "0" so that the file is uploaded only when zip file is changed or a new zip file is added
                    currentNode.setProperty("flag", "0");
                    currentNode.save();
                    currentNode.refresh(true);              
                }
                catch(Exception e){   
                    log.error("Flag not set :: " + e);
                }
  
            %> </div>
    <%     }
           catch(Exception e)
           {
               log.error("Zip File not uploaded correctly due to " + e.getMessage());               
               out.print("<b>" + langText.get("Zip file not uploaded completely") + ".</br>");
               //mailnotification.sendExceptionEmail(e);
                
           }
       }// flag == 0
    }//if zip file is available
    else
    {
            %></div>
    </td>
    
    <td width="100%" valign="top" style="padding:0 10px 0 10px;">
<%
      if (WCMMode.fromRequest(request) == WCMMode.EDIT){
%>
      <br><div class="cq-file-placeholder <%= ddClassName %>" style="text-align: left;"></div>
<%
      }
    }
%>
</div>
    </td>
    
    
    
    <td width="20%" valign="top"></td>
    
  </tr>
</table>

<%!
    
    public InputStream writeData(byte[] buffer, String fileName, ZipInputStream stream) throws Exception
    {
        FileInputStream fileDataStream = null;
        String outdir = "zipcontent";
        File tempDir = new File(outdir); // Temp directory on server which will store all the temporary files.
        File file = new File(outdir+"/"+fileName); // Temporary File.
        if(!tempDir.exists())
            tempDir.mkdir();
        
        if(fileName.indexOf("/") > -1)
        {
            fileName = fileName.substring(fileName.lastIndexOf("/")+1); 
        }
        
        FileOutputStream output = null;
        try {
            output = new FileOutputStream(outdir+"/"+fileName);
            int len = 0;
            while ((len = stream.read(buffer)) > 0) {
                output.write(buffer, 0, len);
            }
        }
        catch(Exception ex)
        {
              throw new Exception();   
        }
        finally {
            // we must always close the output file
            if (output != null)
                try {
                    output.close();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                    throw new Exception();
                }
        }
        try {
            fileDataStream = new FileInputStream(file);
        } catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            throw new Exception();
        }
        finally
        {
            if(file.exists())
            {
                file.delete();
            }
        }
        return fileDataStream;
    }
%>

   