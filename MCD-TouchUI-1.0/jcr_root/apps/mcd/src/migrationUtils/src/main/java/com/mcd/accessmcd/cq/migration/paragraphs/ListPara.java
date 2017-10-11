package com.mcd.accessmcd.cq.migration.paragraphs;
 

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import com.mcd.accessmcd.cq.migration.util.*;
/*
* Utility class used for migrating List paragraphs from CQ4
* 
*/

public class ListPara{


public static boolean process(Element parnode, MigrationInfo mi){
           if(!mi.process){
               mi.fixpar++;
               return true;
           }
           try{
               mi.info("Process ListPara for"+mi.destPage.getPath()+":"+mi.rownum+","+mi.colnum);
               
               String partype=Util.getChildNodeText(parnode,"ParagraphType");
               
               String text=Util.getChildNodeText(parnode,"Text");
              
               text=Util.processListText(text,partype);
               text=Util.fixLinks(text,mi);
               javax.jcr.Node destPar= MergePara.createEverythingContent(mi.destPage,text,mi);
               //for list w/title pars
               String title=Util.getChildNodeText(parnode,"Title");
               if(title!=null && !title.equals("")){
                  JcrUtil.setProperty(destPar,"title",title);  
                  JcrUtil.setProperty(destPar,"titleType","paragraphTitle");
               }
                     
           }catch(Exception e){
           }

           return true;
   }
   
                


 
   
   
}