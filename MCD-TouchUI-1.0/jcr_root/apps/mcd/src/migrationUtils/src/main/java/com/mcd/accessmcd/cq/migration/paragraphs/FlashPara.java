package com.mcd.accessmcd.cq.migration.paragraphs;

 
import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import com.mcd.accessmcd.cq.migration.util.*;
/*
* Utility class used for migrating Flash Paragraph from CQ4
* 
*/

public class FlashPara{

private static final Logger log = LoggerFactory.getLogger(FlashPara.class);

public static boolean process(Element parnode, MigrationInfo mi){
           try{
               mi.info("Process Flash Para for"+mi.destPage.getPath());
               
               if(!(Util.getChildNodeText(parnode,"File")).equals("binary")) return false;//no binary exists  
               
               
               javax.jcr.Node destPar=null;
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("flash_"+parcount))break;
                   parcount++;
               }
               
               destPar=mi.destPage.addNode("flash_"+parcount,"nt:unstructured");
               JcrUtil.setProperty(destPar,"sling:resourceType","foundation/components/flash"); 
               //text corrections
               String text=Util.getChildNodeText(parnode,"Text");
               text = text.replaceAll("\\n","<BR>");   
               
               String height=Util.getChildNodeText(parnode,"MediaHeight");
               if(height.equals(""))height="100";
               String width=Util.getChildNodeText(parnode,"MediaWidth");
               if(width.equals(""))width="100";
               JcrUtil.setProperty(destPar,"height",height);  
               JcrUtil.setProperty(destPar,"width",width);  
               
               JcrUtil.setProperty(destPar,"wmode","opaque");  
               JcrUtil.setProperty(destPar,"flashVersion","9.0.0");  
               String filename=Util.getChildNodeText(parnode,"FileName");
               JcrUtil.setProperty(destPar,"fileName",filename); 
                
               //JcrUtil.setProperty(destPar,"wmode","opaque");  
               
                //create file node
                filename=filename.replaceAll(" ","_");
               String cq4resource=".RowPar."+mi.rownum+".ContentPar."+mi.colnum+".ColumnPar."+mi.parnum+".File.tmp/"+filename;
                if(!mi.isSuperTemplate){
                    cq4resource="."+mi.colname+"Par."+mi.parnum+".File.tmp/"+filename;
                }
                Util.createFileNode(destPar,mi,cq4resource,"application/x-shockwave-flash");             
                    
           }catch(Exception e){
           }
           return true;

   }
}
