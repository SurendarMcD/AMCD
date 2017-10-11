package com.mcd.accessmcd.cq.migration.paragraphs;


import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import com.mcd.accessmcd.cq.migration.util.*;
/*
* Utility class used for migrating Image only Paragraphs from CQ4
* 
*/

public class ImagePara{

private static final Logger log = LoggerFactory.getLogger(ImagePara.class);

public static boolean process(Element parnode, MigrationInfo mi){
           
           try{
               mi.info("Process ImagePara for"+mi.destPage.getPath());
               
               javax.jcr.Node destPar=null;
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("image_"+parcount))break;
                   parcount++;
               }
               
               destPar=mi.destPage.addNode("image_"+parcount,"nt:unstructured");
               JcrUtil.setProperty(destPar,"sling:resourceType","foundation/components/image"); 
               //text corrections
               String text=Util.getChildNodeText(parnode,"Text");
               //text = text.replaceAll("\\n","<BR>");  
               
               //TODO: list reformatting
               
               text=processText(text,parnode,mi);
               log.error("mi.cq4siteroot:"+mi.cq4siteroot);
               log.error("mi.cq5siteroot:"+mi.cq5siteroot);
               text=Util.fixLinks(text,mi);
               
               JcrUtil.setProperty(destPar,"text",text);  
               JcrUtil.setProperty(destPar,"textIsRich","true"); 
               String textalign=Util.getChildNodeText(parnode,"TextAlignment");
               if(textalign=="")textalign="left";
               JcrUtil.setProperty(destPar,"textAlign",textalign);
               JcrUtil.setProperty(destPar,"backgroundColor","");  
               JcrUtil.setProperty(destPar,"borderSize","");
               /* IMAGE */
               String image=Util.getChildNodeText(parnode,"Image");
               String imagePosition=Util.getChildNodeText(parnode,"ImagePosition");
               //??
               if(imagePosition==""){
                   String imageTitleAlign=Util.getChildNodeText(parnode,"ImageTitleAlignment");
                   if(imageTitleAlign.equals("top")){  
                       imagePosition="left";
                   }
                   
               }
               //String height=Util.getChildNodeText(parnode,"Height");
               if(image.equals("binary")){
                   //get image and save it to image node
                   //retMsg+=addMsg(mi.dump());  
                   Util.createImageNode(destPar,mi);
                   //JcrUtil.setProperty(destPar,"image","");
                   JcrUtil.setProperty(destPar,"imagePosition",imagePosition);
                   JcrUtil.setProperty(destPar,"imageLink",Util.getChildNodeText(parnode,"LinkUrl"));
                   JcrUtil.setProperty(destPar,"imageSize",1.0);               
                   JcrUtil.setProperty(destPar,"captionText",Util.getChildNodeText(parnode,"ImageCaption"));
                   JcrUtil.setProperty(destPar,"captionAlignment",Util.getChildNodeText(parnode,"ImageCaptionAlignment"));               
               }
               if((Util.getChildNodeText(parnode,"File")).equals("binary")){
                    addDownloadParagraph(parnode,"Image Link","",mi);
               }
               JcrUtil.setProperty(destPar,"backgroundColor","");
               JcrUtil.setProperty(destPar,"borderSize",0);
 
               JcrUtil.setProperty(destPar,"includeCorner","false");
               //JcrUtil.setProperty(destPar,"paddingBottomText",10);
               //JcrUtil.setProperty(destPar,"paddingLeftText",10);
               //JcrUtil.setProperty(destPar,"paddingRightText",10);
               //JcrUtil.setProperty(destPar,"paddingTopText",10);
               JcrUtil.setProperty(destPar,"paddingBottom",10);
               //JcrUtil.setProperty(destPar,"paddingLeft",5);
               //JcrUtil.setProperty(destPar,"paddingRight",5);
               //JcrUtil.setProperty(destPar,"paddingTop",5);
                       
  
               
               String title=Util.getChildNodeText(parnode,"TableCaption");
               if(title=="")title=Util.getChildNodeText(parnode,"Title");              
               JcrUtil.setProperty(destPar,"jcr:title",title);

               
                    
           }catch(Exception e){
           }

           return true;
   }
   
   /*
   public static boolean displayUnmigratedMessage(Element parnode, MigrationInfo mi,String partype){
           
           try{
               log.info("processPlaceholderfor"+mi.destPage.getPath());
               javax.jcr.Node destPar=null;
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("everything_"+parcount))break;
                   parcount++;
               }
               
               destPar=mi.destPage.addNode("everything_"+parcount,"nt:unstructured");
               JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/everything"); 
                           
               
               
               
               JcrUtil.setProperty(destPar,"text","<center><b>Unmigrated Paragraph:"+partype+"</b></center>");  
               JcrUtil.setProperty(destPar,"textIsRich","true"); 
               JcrUtil.setProperty(destPar,"borderSize",1);
               JcrUtil.setProperty(destPar,"borderColor","sitecolor1");
           }catch(Exception e){
           }

           return true;
   }
    */         


   private static String processText(String intext,Element parnode,MigrationInfo mi){
       String text="";
       text = (new AutoFormatter()).format(intext, AutoFormatter.FORMAT_AUTOBR); 
       //Resolve download links
        int k = 1;
        StringBuffer sb = new StringBuffer(text);
        int tokenPosition = text.indexOf("---File---");
        while (tokenPosition != -1 ) {
               
            if (k > 5 ) {
            
                int tokenPosition1 = text.indexOf("<A TARGET=\"new\" HREF=\"---File---\">");
                sb = sb.replace(tokenPosition1, tokenPosition1 + 34, "");
                text = sb.toString();
                int tokenPosition2 = sb.indexOf("</A>", tokenPosition1);
                sb = sb.replace(tokenPosition2 , tokenPosition2 + 4, "");
                text = sb.toString();
            
            }
           else if (k <6){
           
                    int tokenPosition1 = sb.indexOf("<A TARGET=\"new\" HREF=\"---File---\">");
                    //sb = sb.replace(tokenPosition1, tokenPosition1 + 34, "");
                    
                    int tokenPosition2 = sb.indexOf("</A>", tokenPosition1);
                    String tmpfileName=sb.substring(tokenPosition1+34 , tokenPosition2);
                    
                
                if((Util.getChildNodeText(parnode,"File" + k)).equals("binary")){
                    //sb= sb.replace(tokenPosition1 , tokenPosition2 + 4, "[Download Link Removed]");
                    //../_jcr_content/maincontentpara/download_0/file.res/RDM_for_2010_ROA.%5bA1%5d%5bA6%5d%5bA5%5d%5bA3%5d%5bA2%5d%5bA4%5d.pdf
                    String downloadparurl=addDownloadParagraph(parnode,tmpfileName,k+"",mi);
                    //log.error("downloadparurl:"+downloadparurl);
                    sb.replace(tokenPosition1+22 , tokenPosition1 + 32, downloadparurl);
                    //log.error("download string:"+downloadparurl);
                    //log.error("string:"+sb.toString());

                /*     
                    
                    
                    String fileName = Util.getChildNodeText(parnode,"FileName" + k); 
                     
                    //wei added
                    //tmpfileName = replace(tmpfileName, " ", "_");
                    //org code String downloadString1 =  handle + "." + parReference + ".File" + k + ".tmp/" + tmpfileName + "?" + metaGroups;
                
                    //CREATE separate Download paragraphs after this paragraph, and then link to each
                    //log.info("download filename:"+fileName); 
                    fileName=fileName.replace(',','_');
                    fileName=fileName.replace('[','_');
                    fileName=fileName.replace(']','_');
                    //log.info("download filename:"+fileName);
                    DownloadPara.createDownloadComponent(fileName,tmpfileName,"","File"+k,mi);
                */    
                }else{
                    sb= sb.replace(tokenPosition1+22 , tokenPosition1 + 32, "");
                }
                
                
                
                //String downloadString1 =  "/parReference.File" + k + ".tmp.tmpGroup/" + tmpfileName;
                
                //sb = sb.replace(tokenPosition, tokenPosition + 10, downloadString1);
                //text = sb.toString();
                
                // Insert file size after download text
                /* commenting for now
                Atom file = container.getAtom("File" + k);
                if (file!=null && file.hasContent()) {
                    String fileinfo="";
                    AtomStatus fileStat = file.getStat();
                    String fileSize = String.valueOf(fileStat.size/1024) + " Kb";
                    String ext = tmpfileName.substring(tmpfileName.lastIndexOf(".") + 1).toUpperCase();
                    //fileinfo=" ("+fileSize+" "+ext+")";
                    fileinfo="<span class=\"fileDownloadSize\"> ("+fileSize+" "+ext+")</span>";
                    int tokenPosition2 = text.indexOf("</A>", tokenPosition);
                    if(tokenPosition2>-1){
                        sb = sb.replace(tokenPosition2 , tokenPosition2 + 4, fileinfo+"</A>");
                        text = sb.toString();
                    }
                
                }
                */
        
            }
            
            k++;
            tokenPosition = sb.indexOf("---File---");
        }
        
        text = sb.toString();
       
        //emily 08/12/2008 added text highlight option
        String tmpTxtFontColor = Util.getChildNodeText(parnode,"TxtFontColor");
        String txtFontColorUnderline = Util.getChildNodeText(parnode,"TxtFontColorUnderline");
        String txtFontColorItalic = Util.getChildNodeText(parnode,"TxtFontColorItalic");
        String txtFontColorBold = Util.getChildNodeText(parnode,"TxtFontColorBold");
        
        if (tmpTxtFontColor!=""){
            String beg = "";
            String end = "";
        
            int position = 0;
        
            StringBuffer sbTxt = new StringBuffer(text);
            int tokenPositionTxt = text.indexOf("--Color--");
        
                if (txtFontColorUnderline!=""){
                    beg += "<u>";
                    end += "</u>";  
                }
                if (txtFontColorItalic!=""){
                    beg += "<i>";
                    end += "</i>";  
                }
                if (txtFontColorBold!=""){
                    beg += "<b>";
                    end += "</b>";  
                }
            while (tokenPositionTxt != -1 ) {
                //set font color
                sbTxt = sbTxt.replace(tokenPositionTxt, tokenPositionTxt + 9, tmpTxtFontColor);
                //adds bold underline italic
                position = tokenPositionTxt;
                sbTxt = sbTxt.replace(tokenPositionTxt + 8, tokenPositionTxt + 8, beg);
                text = sbTxt.toString();
                tokenPositionTxt = text.indexOf("</FONT>", position);
                sbTxt = sbTxt.replace(tokenPositionTxt, tokenPositionTxt , end);        
                    
                text = sbTxt.toString();
                
                tokenPositionTxt = text.indexOf("--Color--");   
            }  // end of while
            
        } // end of txtFontColor
        //judy , 04/04/2006 , list color
            String fontcolor = Util.getChildNodeText(parnode,"FontColor");
            //if(fontcolor=="")fontcolor="000000";
        
            String newText = replace(text,"<ul>","<ul><font color ="+fontcolor +">");
            text = replace(newText,"</ul>","</font></ul>");
    
            newText = replace(text,"<ol start=\"1\">","<ol start=\"1\"><font color ="+fontcolor +">");
            text = replace(newText,"</ol>","</font></ol>");
            
      return text; 
   }
   
   private static String addDownloadParagraph(Element parnode,String tmpfileName,String k, MigrationInfo mi){
       String retParURL="";
       if((Util.getChildNodeText(parnode,"File" + k)).equals("binary")){    
        
        String fileName = Util.getChildNodeText(parnode,"FileName" + k); 
         
        //wei added
        //tmpfileName = replace(tmpfileName, " ", "_");
        //org code String downloadString1 =  handle + "." + parReference + ".File" + k + ".tmp/" + tmpfileName + "?" + metaGroups;
    
        //CREATE separate Download paragraphs after this paragraph, and then link to each
        //log.info("download filename:"+fileName); 
        fileName=fileName.replace(',','_');
        fileName=fileName.replace('[','_');
        fileName=fileName.replace(']','_');
        fileName=fileName.replace((char)0xAD,'_');
        fileName=fileName.replace(' ','_');
        //log.info("download filename:"+fileName);
        retParURL=DownloadPara.createDownloadComponent(fileName,tmpfileName,"","File"+k,mi);
      }
        return retParURL;
   }
   
   private static String replace (String target, String from, String to) {   
      // target is the original string
      // from   is the string to be replaced
      // to     is the string which will used to replace
      int start = target.indexOf (from);
      if (start==-1) return target;
      int lf = from.length();
      char [] targetChars = target.toCharArray();
      StringBuffer buffer = new StringBuffer();
      int copyFrom=0;
      while (start != -1) {
        buffer.append (targetChars, copyFrom, start-copyFrom);
        buffer.append (to);
        copyFrom=start+lf;
        start = target.indexOf (from, copyFrom);
        }
      buffer.append (targetChars, copyFrom, targetChars.length-copyFrom);
      return buffer.toString();
      }
}