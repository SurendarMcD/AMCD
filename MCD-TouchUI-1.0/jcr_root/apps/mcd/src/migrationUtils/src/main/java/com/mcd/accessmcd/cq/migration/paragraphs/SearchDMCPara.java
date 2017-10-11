package com.mcd.accessmcd.cq.migration.paragraphs;

 
import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import com.mcd.accessmcd.cq.migration.util.*;
/*
* Utility class used for migrating SearchDMC Paragraph from CQ4
* 
*/

public class SearchDMCPara{

private static final Logger log = LoggerFactory.getLogger(SearchDMCPara.class);

public static boolean process(Element parnode, MigrationInfo mi){
           try{
               mi.info("Process SearchDMC Para for"+mi.destPage.getPath());
               
               javax.jcr.Node destPar=null;
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("searchdmc_"+parcount))break;
                   parcount++;
               }
               
               destPar=mi.destPage.addNode("searchdmc_"+parcount,"nt:unstructured");
               JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/searchdmc"); 
               //text corrections
               String text=Util.getChildNodeText(parnode,"Text");
               text = text.replaceAll("\\n","<BR>");   
               //TODO: list reformatting
               JcrUtil.setProperty(destPar,"documentIcon",Util.getChildNodeText(parnode,"AssetIconStr"));  
               JcrUtil.setProperty(destPar,"documentName",Util.getChildNodeText(parnode,"AssetNameOrScanNbr")); 
               JcrUtil.setProperty(destPar,"documentDesc",Util.getChildNodeText(parnode,"AssetDescription")); 
               JcrUtil.setProperty(destPar,"documentSize","");
               JcrUtil.setProperty(destPar,"documentURL",Util.getChildNodeText(parnode,"AssetHandle"));  
               JcrUtil.setProperty(destPar,"showDocIcon","yes");
               
                    
           }catch(Exception e){
           }
           return true;

   }
}
