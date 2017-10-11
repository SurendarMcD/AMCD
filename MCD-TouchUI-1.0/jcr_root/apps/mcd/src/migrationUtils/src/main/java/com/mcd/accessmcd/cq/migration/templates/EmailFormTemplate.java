package com.mcd.accessmcd.cq.migration.templates;
/* 
Email Form Template Processing
*/

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import java.util.*;

import com.mcd.accessmcd.cq.migration.util.*;
import com.mcd.accessmcd.cq.migration.paragraphs.*;


public class EmailFormTemplate{

private static final Logger log = LoggerFactory.getLogger(EmailFormTemplate.class);

 

public boolean process(Document doc, MigrationInfo mi)
{
           //if(!mi.process)return true;
           NodeList nodes=null;
           try{ 
            mi.isSuperTemplate=false;
            javax.jcr.Node origDestPage=mi.destPage;
             //set up basic template sections (g2g for now)
           javax.jcr.Node startNode=null;
            if(mi.process){
                if(mi.destPage.hasNode("maincontentpara")){
                    mi.destPage=mi.destPage.getNode("maincontentpara");
                }else{
                    mi.destPage=mi.destPage.addNode("maincontentpara","nt:unstructured");
                   } 
            
               startNode=mi.destPage.addNode("start","nt:unstructured");
               startNode.setProperty("actionType","foundation/components/form/actions/mail"); 
               startNode.setProperty("sling:resourceType","foundation/components/form/start");
               startNode.setProperty("formid","emailform"); 
               startNode.setProperty("from",""); 
             }  
               //Top Par
               mi.colname="Top";
               if(!mi.cq4page.contains("/mcweb/")){
                    nodes = doc.getElementsByTagName("TopPar_Elem");
                    for (int i = 0; i < nodes.getLength(); i++) {
                       Element parNode= (Element) nodes.item(i);
                       Util.processParagraph(parNode,mi);
                    }
               }
            
               //Column 1
               mi.colname="ColumnOne";
               nodes = doc.getElementsByTagName("ColumnOnePar_Elem");
               for (int i = 0; i < nodes.getLength(); i++) {
                   Element parnode= (Element) nodes.item(i);
                   
                   if(mi.process && Util.getChildNodeText(parnode,"ParSel").equals("formsubmit")){
                       String sendTo=Util.getChildNodeText(parnode,"InputDefault");
                       //test values
                       //sendTo="erik.wannebo@us.mcd.com";
                       startNode.setProperty("mailto",sendTo);
                       //String from="erik.wannebo@us.mcd.com";
                       startNode.setProperty("from",sendTo); 
                       
                       String subject=Util.getChildNodeText(parnode,"Title");
                       startNode.setProperty("subject",subject);                        
                        
                       
                       javax.jcr.Node endNode=mi.destPage.addNode("form_end_"+Calendar.getInstance().getTimeInMillis(),"nt:unstructured");
                       //create confirmation page
                       String confirmationMessage=Util.getChildNodeText(parnode,"AltText");
                       createConfirmationPage(mi, confirmationMessage, sendTo);
                       startNode.setProperty("redirect",mi.cq5basepagename+"/confirmation"); 
                       
                       
                       String inputCaption=Util.getChildNodeText(parnode,"InputCaption");

                       endNode.setProperty("jcr:title",""); 
                       endNode.setProperty("sling:resourceType","foundation/components/form/end");
                       endNode.setProperty("submit","true"); 
                       endNode.setProperty("name","EmailSubmit"); 
                       
                   }else{
                       Util.processParagraph(parnode,mi);
                   }
               }
                  
               Util.addNavigation(origDestPage,mi);
               
               Util.addInheritedSections(origDestPage,mi);
            }catch(Exception e){
                log.error(e.getMessage());
            }
             return true;

}

public boolean createConfirmationPage(MigrationInfo mi,String confirmationText,String sendTo){
    
    try{
     
        javax.jcr.Node confirmpage=Util.getCQ5Page(mi.session,mi.cq5dest+"/"+mi.cq5basepagename,"confirmation",true);

        JcrUtil.setProperty(confirmpage,"jcr:title","Confirmation Page");
        JcrUtil.setProperty(confirmpage,"cq:template","/apps/mcd/templates/g2g");
        JcrUtil.setProperty(confirmpage,"sling:resourceType","mcd/components/page/g2g");   
        JcrUtil.setProperty(confirmpage,"authorName",sendTo); 
        JcrUtil.setProperty(confirmpage,"authorEmail",sendTo);
        
        String[] testtags={"confirmation"};
        confirmpage.setProperty("cq:tags",testtags); 
        java.util.Calendar nowDate=java.util.Calendar.getInstance();
        JcrUtil.setProperty(confirmpage,"cq:lastModified",nowDate);
        JcrUtil.setProperty(confirmpage,"jcr:description","Confirmation Page");   
        
        //add Everything component
        
        javax.jcr.Node contentnode=null;
        if(confirmpage.hasNode("maincontentpara")){
             contentnode=confirmpage.getNode("maincontentpara");
        }else{
             contentnode=confirmpage.addNode("maincontentpara","nt:unstructured");
        } 
        JcrUtil.setProperty(contentnode,"sling:resourceType","foundation/components/parsys");
         
        com.mcd.accessmcd.cq.migration.paragraphs.MergePara.createEverythingContent(contentnode,confirmationText,mi);
        String returnLink="<a href='"+mi.cq5dest+"/"+mi.cq5basepagename+".html'>Return To Form</a>";
        com.mcd.accessmcd.cq.migration.paragraphs.MergePara.createEverythingContent(contentnode,returnLink,mi);
        
        mi.session.save();
        
    
    }catch(Exception e){
                log.error(e.getMessage());
    }

    return true;
}
   
   
}