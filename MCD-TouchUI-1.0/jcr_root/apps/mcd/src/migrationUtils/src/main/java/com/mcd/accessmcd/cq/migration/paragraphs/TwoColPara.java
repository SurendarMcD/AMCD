package com.mcd.accessmcd.cq.migration.paragraphs;
 

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.mcd.accessmcd.cq.migration.util.*;
import java.util.*; 
/*
* Utility class used for migrating Two Column Paragraph from CQ4
* 
*/

public class TwoColPara{

private static final Logger log = LoggerFactory.getLogger(MergePara.class);

public static boolean process(Element parnode, MigrationInfo mi){
           
           try{
               mi.info("Process TwoColPara for"+mi.destPage.getPath()+":"+mi.rownum+","+mi.colnum);
               //javax.jcr.Node colctrlNode=null;
               if(!mi.process)return true;
           
               String colOneText=Util.getChildNodeText(parnode,"Text");
               colOneText=MergePara.processText(colOneText,parnode,mi);
               colOneText=Util.fixLinks(colOneText,mi);
               String colTwoText=Util.getChildNodeText(parnode,"Col2Text");
               colTwoText=MergePara.processText(colTwoText,parnode,mi);
               colTwoText=Util.fixLinks(colTwoText,mi);
               String outText="<table width='100%'><tr><td width='49%' valign='top'>";
               outText+=colOneText;  
               outText+="</td><td width='4'></td><td width='49%' valign='top'>";
               outText+=colTwoText;     
               outText+="</td></tr></table>";
               MergePara.createEverythingContent(mi.destPage,outText,mi);
               
               
           }catch(Exception e){
           }

           return true;
      }
}