package com.mcd.accessmcd.cq.migration.paragraphs;

 
import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import java.net.*;
import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import com.mcd.accessmcd.cq.migration.util.*;
/*
* Utility class used for migrating Download Paragraph from CQ4
* 
*/

public class DownloadPara{

public static boolean process(Element parnode, MigrationInfo mi){
           try{
               mi.info("Process Download Para for"+mi.destPage.getPath());
               
               if(!(Util.getChildNodeText(parnode,"File")).equals("binary")) return false;//no binary exists  
               NodeList downloadelem= parnode.getElementsByTagName("DownloadFiles_Elem");
               if(downloadelem.getLength()>0){ 
                   for (int j = 0; j < downloadelem.getLength(); j++) {
                       Element downloadparnode=(Element)downloadelem.item(j);
                       String filename=Util.getChildNodeText(downloadparnode,"FileName");
                       String filedescription=Util.getChildNodeText(downloadparnode,"description");
                       String dispfilename=Util.getChildNodeText(parnode,"fileTitle");
                       if(dispfilename.equals("")){
                           dispfilename=Util.getChildNodeText(downloadparnode,"LinkText");
                       }else{
                           if(filedescription.equals(""))filedescription=Util.getChildNodeText(downloadparnode,"LinkText");
                       }
                       String downloadparnum=downloadparnode.getAttribute("parnum");
                       createDownloadComponent(filename, dispfilename, filedescription, "DownloadFiles."+downloadparnum+".File", mi);
                   }
                
               }else{
                   String filename=Util.getChildNodeText(parnode,"filename");
                   if(filename.equals(""))filename=Util.getChildNodeText(parnode,"FileName");
                   String filedescription=Util.getChildNodeText(parnode,"description");
                   String dispfilename=Util.getChildNodeText(parnode,"fileTitle");
                   if(dispfilename.equals("")){
                       dispfilename=Util.getChildNodeText(parnode,"LinkText");
                   }else{
                       if(filedescription.equals(""))filedescription=Util.getChildNodeText(parnode,"LinkText");
                   }
                   createDownloadComponent(filename, dispfilename, filedescription, "File", mi);
                   return true;
               }
               
         
                    
           }catch(Exception e){
           }
           return true;

   }

public static String createDownloadComponent(String filename,String altfilename, String description, String fileatomname, MigrationInfo mi){   
         String retParName="";
          try{
                          
              
               mi.info("Creating Download Component for"+filename);
               if(!mi.process){ 
                   if(!mi.fixed){
                       int parcount=0;
                       while(mi.destPage.hasNode("download_"+parcount)){
                           javax.jcr.Node dwnld=mi.destPage.getNode("download_"+parcount);
                           String existFilename=dwnld.getProperty("fileName").getString();
                           if(existFilename.equals(filename)){
                               //return file node
                               filename=filename.replace(" ","_");
                               filename=filename.replace("'","_");
                               filename=filename.replace("!","_");
                               filename=URLEncoder.encode(filename);
                               return dwnld.getPath()+"/file.res/"+filename;  
                           }
                           parcount++;
                       }
                   }
                   return "";
               }
               //if(description==null || description.equals(""))description=filename;
               
               javax.jcr.Node destPar=null;
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("download_"+parcount))break;
                   parcount++;
               }
               
               destPar=mi.destPage.addNode("download_"+parcount,"nt:unstructured");
               JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/download"); 
                              
               JcrUtil.setProperty(destPar,"fileName",filename);  
               JcrUtil.setProperty(destPar,"altTitle",altfilename); 
               JcrUtil.setProperty(destPar,"jcr:description",description);             
               
                //create file node
               filename=filename.replace(" ","_");
               filename=filename.replace("'","_");
               filename=filename.replace("!","_");
               filename=URLEncoder.encode(filename);
                
               String cq4resource=".RowPar."+mi.rownum+".ContentPar."+mi.colnum+".ColumnPar."+mi.parnum+"."+fileatomname+".tmp/"+filename;
                if(!mi.isSuperTemplate || mi.colname.equals("SideBarContent")){
                    cq4resource="."+mi.colname+"Par."+mi.parnum+"."+fileatomname+".tmp/"+filename;
                }
                
                mi.info("cq4resource:"+cq4resource);
                Util.createFileNode(destPar,mi,cq4resource,""); 
                retParName=destPar.getPath()+"/file.res/"+filename;            
                    
           }catch(Exception e){
           }
           return retParName;
           }
   
}