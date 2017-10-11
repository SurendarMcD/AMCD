package com.mcd.accessmcd.cq.migration.paragraphs;
 

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import com.mcd.accessmcd.cq.migration.util.*;
/*
* Utility class used for migrating List Children paragraphs from CQ4
* 
*/

public class ListChildrenPara{

private static final Logger log = LoggerFactory.getLogger(ListChildrenPara.class);

public static boolean process(Element parnode, MigrationInfo mi){
           
           try{
               mi.info("Process ListChildrenPara for"+mi.destPage.getPath()+":"+mi.rownum+","+mi.colnum);
               if(!mi.process)return true;
               javax.jcr.Node listNode=mi.destPage.addNode("list","nt:unstructured");
               listNode.setProperty("sling:resourceType","foundation/components/list"); 
               listNode.setProperty("listFrom","children");
                     
           }catch(Exception e){
           }

           return true;
   }
   
                


 
   
   
}