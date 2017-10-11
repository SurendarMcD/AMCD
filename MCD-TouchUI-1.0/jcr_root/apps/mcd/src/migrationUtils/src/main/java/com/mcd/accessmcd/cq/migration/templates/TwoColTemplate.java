package com.mcd.accessmcd.cq.migration.templates;
/* 
Two Column Template Processing
*/

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import java.util.*;

import com.mcd.accessmcd.cq.migration.util.*;


public class TwoColTemplate{

private static final Logger log = LoggerFactory.getLogger(TwoColTemplate.class);

 

public boolean process(Document doc, MigrationInfo mi)
{
           //if(!mi.process)return true;
           NodeList nodes=null;

           
           int numOfCols=2;//default
           try{ 
            mi.isSuperTemplate=false;
            
            javax.jcr.Node origDestPage=mi.destPage;
             //set up basic template sections (g2g for now)
            if(mi.process){
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
            

             
             
             //create flexicolumn node
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("colctrl_"+parcount))break;
                   parcount++;
               }
               javax.jcr.Node colctrlNode=null;
               if(mi.process){
                     colctrlNode=mi.destPage.addNode("colctrl_"+parcount,"nt:unstructured");
                     String colLayout="2;cq-colctrl-lt0";
                     if(!mi.template.equals("one_column_template"))colLayout="1;cq-colctrl-lt7";
                     colctrlNode.setProperty("layout",colLayout); 
                   //default to white (sitecolor2) background for cols
                   String bgcolorCols="sitecolor2";

                   if(!mi.template.equals("one_column_template"))numOfCols=1;
                   for(int i=1;i<numOfCols;i++){
                       bgcolorCols+=":sitecolor2";
                   }
                   colctrlNode.setProperty("backgroundColumnctrl",bgcolorCols);
                   colctrlNode.setProperty("sling:resourceType","mcd/components/content/parsys/colctrl");
                }
                

                //put top par in main content area
                 
                 mi.colname="Top";
                   nodes = doc.getElementsByTagName("TopPar_Elem");
                   for (int i = 0; i < nodes.getLength(); i++) {
                       Element parNode= (Element) nodes.item(i);
                       Util.processParagraph(parNode,mi);
                   }


               //Column 1
               mi.colname="ColumnOne";
               nodes = doc.getElementsByTagName("ColumnOnePar_Elem");
               for (int i = 0; i < nodes.getLength(); i++) {
                   Element parNode= (Element) nodes.item(i);
                   Util.processParagraph(parNode,mi);
               }
                   
               if(mi.process && numOfCols>1){
                 colctrlNode=mi.destPage.addNode("col_break"+Calendar.getInstance().getTimeInMillis(),"nt:unstructured");
                 colctrlNode.setProperty("controlType","break"); 
                 colctrlNode.setProperty("sling:resourceType","mcd/components/content/parsys/colctrl");
               }
                //Column 2
                mi.colname="ColumnTwo";
                nodes = doc.getElementsByTagName("ColumnTwoPar_Elem");
                for (int i = 0; i < nodes.getLength(); i++) {
                   Element parNode= (Element) nodes.item(i);
                   Util.processParagraph(parNode,mi);
                }

                if(mi.process){
                  colctrlNode=mi.destPage.addNode("col_end"+Calendar.getInstance().getTimeInMillis(),"nt:unstructured");
                  colctrlNode.setProperty("controlType","end"); 
                  colctrlNode.setProperty("sling:resourceType","mcd/components/content/parsys/colctrl");
                }
                //Bottom Par
                mi.colname="Bottom";
                nodes = doc.getElementsByTagName("BottomPar_Elem");
                for (int i = 0; i < nodes.getLength(); i++) {
                   Element parNode= (Element) nodes.item(i);
                   Util.processParagraph(parNode,mi);
                } 

                //column three (sidebar) goes in the right column
                Util.addInheritanceNode(origDestPage,mi,"rightcontentpara",false);  
              
                mi.colname="ColumnThree";
                nodes = doc.getElementsByTagName("ColumnThreePar_Elem");
                for (int i = 0; i < nodes.getLength(); i++) {
                   Element parNode= (Element) nodes.item(i);
                   Util.processParagraph(parNode,mi);
                } 
                
 
                Util.addNavigation(origDestPage,mi);
                Util.addInheritedSections(origDestPage,mi);
            }catch(Exception e){
                log.error(e.getMessage());
            }
             return true;

}
   
   
}