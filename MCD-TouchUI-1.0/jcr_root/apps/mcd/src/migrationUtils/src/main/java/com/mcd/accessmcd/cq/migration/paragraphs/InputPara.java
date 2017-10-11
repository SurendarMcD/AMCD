package com.mcd.accessmcd.cq.migration.paragraphs;

 
import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import java.util.Vector;
import com.day.cq.commons.jcr.*;
import com.mcd.accessmcd.cq.migration.util.*;
/*
* Utility class used for migrating Flash Paragraph from CQ4
* 
*/

public class InputPara{

private static final Logger log = LoggerFactory.getLogger(InputPara.class);

public static boolean process(Element parnode, MigrationInfo mi){
           try{
               mi.info("Process Input Para for"+mi.destPage.getPath());
               
               if(!mi.process)return true;
               
               String fieldtype=Util.getChildNodeText(parnode,"InputType");
               
               if(fieldtype.equals("text")){
                   processInput(parnode, mi,"text",1,60);
               }
               
               if(fieldtype.equals("textbox1")){
                   processInput(parnode, mi,"text",3,60);
               }
               
               if(fieldtype.equals("textbox2")){
                   processInput(parnode, mi,"text",5,60);
               }
               
               if(fieldtype.equals("textbox3")){
                   processInput(parnode, mi,"text",8,60);
               }
               
               if(fieldtype.equals("radio1")){
                   processInput(parnode, mi,"radio",1, 1);
               }


               if(fieldtype.equals("checkbox1")){
                   processInput(parnode, mi,"checkbox",1, 1);
               }      
               
               if(fieldtype.equals("dropdown")){
                   processInput(parnode, mi,"dropdown",1, 1);
               }          
                
 
               //add a spacer everything component
               MergePara.createEverythingContent((javax.jcr.Node)mi.destPage,"<br>",mi);
                        
                    
           }catch(Exception e){
           }
           return true;

   }
   
   private static boolean processInput(Element parnode, MigrationInfo mi,String fieldtype, int rows, int cols){
   
           try{
               javax.jcr.Node destPar=null;
               String inputCaption=Util.getChildNodeText(parnode,"InputCaption");
               //put question header text into separate Everything component
               //MergePara.createEverythingContent((javax.jcr.Node)mi.destPage,inputCaption);
               
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode(fieldtype+"_"+parcount))break;
                   parcount++;
               }
               destPar=mi.destPage.addNode(fieldtype+"_"+parcount,"nt:unstructured");
               JcrUtil.setProperty(destPar,"sling:resourceType","foundation/components/form/"+fieldtype); 
               JcrUtil.setProperty(destPar,"sling:resourceSuperType","foundation/components/form/defaults/field");
                              
               String inputOptions=Util.getChildNodeText(parnode,"InputOptions");
               
               if(!inputOptions.equals("")){
                   //String[] ss=new String[2];
                   //ss[0]="yes";
                   //ss[1]="no";
                    
                   //Vector options=new Vector();
                   //options.add("yes");
                   //options.add("no");
                   //String[] ss = (String[])options.toArray(new String[options.size()]);
                   if(fieldtype.equals("dropdown"))inputOptions="|"+inputOptions;
                   String[] ss = inputOptions.split("\\|");
                   destPar.setProperty("options",ss);
                   
               }
               
 
               if(rows>1){
                   JcrUtil.setProperty(destPar,"rows",rows);
                   JcrUtil.setProperty(destPar,"cols",cols);
               }
                 
               JcrUtil.setProperty(destPar,"jcr:title",inputCaption);  
               
               String InputFieldName=Util.getChildNodeText(parnode,"InputFieldName");
               JcrUtil.setProperty(destPar,"name",InputFieldName.replaceAll(" ","_"));  
               JcrUtil.setProperty(destPar,"jcr:description",InputFieldName);  

               String required=Util.getChildNodeText(parnode,"InputRequired");
               if(required.equals("|yes|")){
                   JcrUtil.setProperty(destPar,"required","true");
               } 
                   
               String validation=Util.getChildNodeText(parnode,"InputValidation");
               if(validation.equals("email")){
                   JcrUtil.setProperty(destPar,"constraintType","foundation/components/form/constraints/email");
               }
               if(validation.equals("phone1")){
                   JcrUtil.setProperty(destPar,"constraintType","foundation/components/form/constraints/numeric");
               }
               //if(validation.equals("date1")){
               //    JcrUtil.setProperty(destPar,"constraintType","foundation/components/form/constraints/date");
              // }

                   
           }catch(Exception e){
               return false;
           }
           
           return true;
       
   }
   
   
   
   
   
}
