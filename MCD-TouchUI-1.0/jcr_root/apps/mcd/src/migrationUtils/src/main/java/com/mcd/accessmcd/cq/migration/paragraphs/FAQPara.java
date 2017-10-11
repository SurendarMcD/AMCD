package com.mcd.accessmcd.cq.migration.paragraphs;
 

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import com.mcd.accessmcd.cq.migration.util.*;
import java.util.*;
/*
* Utility class used for migrating FAQ paragraphs from CQ4
* 
*/

public class FAQPara{


public static boolean process(Element parnode, MigrationInfo mi){
           
           try{
               mi.info("Process FAQPara for"+mi.destPage.getPath()+":"+mi.rownum+","+mi.colnum);
               String faqtitle=Util.getChildNodeText(parnode,"Title");
               if(mi.process && faqtitle!=null && !faqtitle.equals("")){
                  //add FAQ title
                  MergePara.createEverythingContent(mi.destPage,faqtitle,mi);
                  
                  
               }              
               javax.jcr.Node destPar=null;
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("accordion_"+parcount))break;
                   parcount++;
               }
               
               if(mi.process){
                  destPar=mi.destPage.addNode("accordion_"+parcount,"nt:unstructured");
                  JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/accordion"); 
                  JcrUtil.setProperty(destPar,"accordionid","accordion_"+parcount);
               }
               
               

               NodeList faqelem= parnode.getElementsByTagName("FAQ_Elem");
               Vector accordiondata=new Vector();
               
               for (int j = 0; j < faqelem.getLength(); j++) {
                   Element faqnode=(Element)faqelem.item(j);
                   String faqquestion=Util.getChildNodeText(faqnode,"Question");
                   String faqanswer=Util.getChildNodeText(faqnode,"Answer");
                   faqanswer= (new AutoFormatter()).format(faqanswer, AutoFormatter.FORMAT_AUTOBR);
                   String faqanswertext =Util.fixLinks(faqanswer,mi);
                   accordiondata.add(faqquestion+"|"+faqanswertext );
               }                 
               if(mi.process)JcrUtil.setProperty(destPar,"accordiandata",accordiondata.toArray(new String[0]));  
                 
                     
           }catch(Exception e){
           }

           return true;
   }
   
                


 
   
   
}