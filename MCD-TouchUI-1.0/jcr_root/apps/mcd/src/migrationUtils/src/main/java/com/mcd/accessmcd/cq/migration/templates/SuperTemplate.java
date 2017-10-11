package com.mcd.accessmcd.cq.migration.templates;
/* 
Super Template Processing
*/

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import java.util.*;

import com.mcd.accessmcd.cq.migration.util.*;



public class SuperTemplate{

private static final Logger log = LoggerFactory.getLogger(SuperTemplate.class);



public boolean process(Document doc, MigrationInfo mi)
{ 
            //if(!mi.process)return true;
            NodeList nodes=null;
            mi.isSuperTemplate=true;
            mi.titleComponentFound=false;
            mi.colname="";
            javax.jcr.Node origDestPage=mi.destPage;
            try{
     
            if(mi.process){
            //set up basic template sections (g2g for now)
                if(mi.destPage.hasNode("maincontentpara")){
                    mi.destPage=mi.destPage.getNode("maincontentpara");
                }else{
                    mi.destPage=mi.destPage.addNode("maincontentpara","nt:unstructured");
                } 
                JcrUtil.setProperty(mi.destPage,"sling:resourceType","/apps/mcd/components/content/parsys");
            }else{
                if(mi.fix){
                    if(mi.destPage.hasNode("maincontentpara")){
                        mi.destPage=mi.destPage.getNode("maincontentpara");
                    }
                }
            }
            //put top par content first in maincontentpara
            //Util.addInheritanceNode(origDestPage,mi,"topnavpara",false);
            
            mi.colname="Top";
            if(!mi.cq4page.contains("/mcweb/")){
                nodes = doc.getElementsByTagName("TopPar_Elem");
                for (int i = 0; i < nodes.getLength(); i++) {
                   Element parNode= (Element) nodes.item(i);
                   Util.processParagraph(parNode,mi);
                }
            }
           
            nodes = doc.getElementsByTagName("RowPar_Elem");
             for (int i = 0; i < nodes.getLength(); i++) {
               Element rowNode= (Element) nodes.item(i);
               processRow(rowNode,mi);
             }
      
            //sidebar (if there is one) goes in the right column 
            Util.addInheritanceNode(origDestPage,mi,"rightcontentpara",false);
            mi.colname="SideBarContent";
            nodes = doc.getElementsByTagName("SideBarContentPar_Elem");
            if(nodes.getLength()>0){

                for (int i = 0; i < nodes.getLength(); i++) {
                   Element parNode= (Element) nodes.item(i);
                   Util.processParagraph(parNode,mi);
                }
            }
            
            Util.addNavigation(origDestPage,mi);
            Util.addInheritedSections(origDestPage,mi);
            }catch(Exception e){
                log.error(e.getMessage());
            }            

            return true;

}

   public String processRow(Element rownode, MigrationInfo mi){
       String retMsg="";
       mi.rownum=rownode.getAttribute("parnum");
  
       retMsg+="Processing row:"+mi.rownum;
       
       try{
           //Add Column separator
        
           //String numOfCols=Util.getChildNodeText(rownode,"InitialCols");
           boolean bFlexiColumn=false;
           NodeList contparelem= rownode.getElementsByTagName("ContentPar_Elem");
           int numOfCols=contparelem.getLength();
           //TODO: ignore spacing columns
           javax.jcr.Node colctrlNode=null;
           if(numOfCols>1 && !mi.cq4siteroot.contains("/mcweb/")){
               //create flexicolumn node
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("colctrl_"+parcount))break;
                   parcount++;
               }
               if(mi.process){
                 colctrlNode=mi.destPage.addNode("colctrl_"+parcount,"nt:unstructured");
                 colctrlNode.setProperty("sling:resourceType","mcd/components/content/parsys/colctrl");
                 }
               bFlexiColumn=true;
           } 
    
           NodeList colelem= rownode.getElementsByTagName("ContentPar_Elem");
           boolean hadContent=false;
           numOfCols=0;
           for (int j = 0; j < colelem.getLength(); j++) {
               //add column separator
               if(bFlexiColumn && j>0 && hadContent && mi.process){
                   javax.jcr.Node tmpColctrlNode=mi.destPage.addNode("col_break"+Calendar.getInstance().getTimeInMillis(),"nt:unstructured");
                   tmpColctrlNode.setProperty("controlType","break"); 
                   tmpColctrlNode.setProperty("sling:resourceType","mcd/components/content/parsys/colctrl");
               }
               Element colnode= (Element) colelem.item(j);
               contparelem= colnode.getElementsByTagName("ColumnPar_Elem");
               if(contparelem.getLength()>0){
                   retMsg+=processColumn(colnode,mi);
                   hadContent=true;
                   numOfCols++;
               }else{
                   hadContent=false;
               }
            }
            if(bFlexiColumn && mi.process){
                   javax.jcr.Node  tmpColctrlNode=mi.destPage.addNode("col_end"+Calendar.getInstance().getTimeInMillis(),"nt:unstructured");
                   tmpColctrlNode.setProperty("controlType","end"); 
                   tmpColctrlNode.setProperty("sling:resourceType","mcd/components/content/parsys/colctrl");
            }
            //assign layout based on actual number of non-spacing columns
            if(colctrlNode!=null && mi.process){
            String colLayout="2;cq-colctrl-lt0";//default for template
                if(numOfCols==3){
                   colLayout="3;cq-colctrl-lt2";
                }
                if(numOfCols==4){
                   colLayout="4;cq-colctrl-lt4";
                }
                   
                colctrlNode.setProperty("layout",colLayout); 
                //default to white (sitecolor2) background for cols
                String bgcolorCols="sitecolor2";
                for(int i=1;i<numOfCols;i++){
                   bgcolorCols+=":sitecolor2";
                }
                colctrlNode.setProperty("backgroundColumnctrl",bgcolorCols);
            }
                
       }catch(Exception e){
           retMsg+="Error: "+e.getMessage();
       }
            
       return retMsg;
   }
   
   public String processColumn(Element colnode, MigrationInfo mi){
       String retMsg="";
       mi.colnum=colnode.getAttribute("parnum");
      
       retMsg="Processing col:"+mi.colnum;
       
       NodeList contparelem= colnode.getElementsByTagName("ColumnPar_Elem");
       for (int j = 0; j < contparelem.getLength(); j++) {
           Element parnode= (Element) contparelem.item(j);
           retMsg+=Util.processParagraph(parnode,mi);
        }
        
       return retMsg;
   }
  
   
   
}