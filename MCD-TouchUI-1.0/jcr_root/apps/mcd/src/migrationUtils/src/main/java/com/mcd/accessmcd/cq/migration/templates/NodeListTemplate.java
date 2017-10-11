package com.mcd.accessmcd.cq.migration.templates;
/* 
Node List Template Processing
*/

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import java.util.*;

import com.mcd.accessmcd.cq.migration.util.*;
import com.mcd.accessmcd.cq.migration.paragraphs.*;


public class NodeListTemplate{

private static final Logger log = LoggerFactory.getLogger(EmailFormTemplate.class);
 

public boolean process(Document doc, MigrationInfo mi)
{
           if(!mi.process)return true;
           NodeList nodes=null;
           try{ 
            mi.isSuperTemplate=false;
            javax.jcr.Node origDestPage=mi.destPage;
             //set up basic template sections (g2g for now)
            if(mi.destPage.hasNode("maincontentpara")){
                mi.destPage=mi.destPage.getNode("maincontentpara");
            }else{
                mi.destPage=mi.destPage.addNode("maincontentpara","nt:unstructured");
               } 
            
           Element parNode= (Element) doc;
           
           ListChildrenPara.process(parNode,mi);
             
           javax.jcr.Node listNode=mi.destPage.addNode("list","nt:unstructured");
           listNode.setProperty("sling:resourceType","foundation/components/list"); 
           listNode.setProperty("listFrom","children");
               
               
            Util.addNavigation(origDestPage,mi);
            Util.addInheritedSections(origDestPage,mi);      
            }catch(Exception e){
                log.error(e.getMessage());
            }
             return true;

}


   
   
}