package com.mcd.accessmcd.cq.migration.paragraphs;
 

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;
import com.mcd.accessmcd.cq.migration.util.*;
/*
* Utility class used for migrating Merge (Everything) Paragraphs from CQ4
* 
*/

public class MergePara{

private static final Logger log = LoggerFactory.getLogger(MergePara.class);

public static boolean process(Element parnode, MigrationInfo mi){

           try{
               
               if(!mi.process){
                   //fix text in first Everything
                   
                   if(!mi.fixed){
                       
                       if(mi.destPage.hasNode("everything_"+mi.fixpar)){
                               javax.jcr.Node destPar=mi.destPage.getNode("everything_"+mi.fixpar);
                               mi.fixpar++;
                               String existingText=destPar.getProperty("text").getString();
                               if(existingText.equals("")){
                                   String text=Util.getChildNodeText(parnode,"Text");
    
                                   String listtype=Util.getChildNodeText(parnode,"ListType");
                                   if(listtype.equals("ol")){
                                       text=Util.processListText(text,"NumberedList");
                                   }
                                   if(listtype.equals("ul")){
                                       text=Util.processListText(text,"UnorderedList");
                                   }
        
                                   text=processText(text,parnode,mi);
                  
                                   if(Util.getChildNodeText(parnode,"ParSel").equals("webdocpar")){
                                       text=Util.getChildNodeText(parnode,"WebDocFile");
                                   }
    
                                   text=Util.fixLinks(text,mi);
    
                                   
                                   String textalign=Util.getChildNodeText(parnode,"TextAlignment");
                                   if(textalign=="")textalign="left";
                                   //JcrUtil.setProperty(destPar,"textAlign",textalign);
                                   
                                   if(!textalign.equals("") && !textalign.equals("left")){
                                       text="<p style=\"text-align: "+textalign+";\">"+text+"</p>";
                                   } 
                                  if(!text.equals("")){
                                      JcrUtil.setProperty(destPar,"text",text);
                                      mi.info("saving fix");
                                      mi.fixsave=true;
                                      }
                               }
                       }
                       
                   }
                   return true;
               }
           
           
               mi.info("ProcessMergePara for"+mi.destPage.getPath()+":"+mi.rownum+","+mi.colnum);
               javax.jcr.Node destPar=null;
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("everything_"+parcount))break;
                   parcount++;
               }
               destPar=mi.destPage.addNode("everything_"+parcount,"nt:unstructured");
               //text corrections
               String text=Util.getChildNodeText(parnode,"Text");
              //log.info("ProcessMergePara text"+text);
              //text = text.replaceAll("\\n","<BR>");  
               
               //list reformatting
               String listtype=Util.getChildNodeText(parnode,"ListType");
               if(listtype.equals("ol")){
                   text=Util.processListText(text,"NumberedList");
               }
               if(listtype.equals("ul")){
                   text=Util.processListText(text,"UnorderedList");
               }
               
               text=processText(text,parnode,mi);


               if(Util.getChildNodeText(parnode,"ParSel").equals("webdocpar")){
                   text=Util.getChildNodeText(parnode,"WebDocFile");
               }
               
               //mi.info("text before:"+text);
               text=Util.fixLinks(text,mi);
               //mi.info("text after:"+text);
               
               String title=Util.getChildNodeText(parnode,"TableCaption");
               if(title.equals(""))title=Util.getChildNodeText(parnode,"Title");   
               String image=Util.getChildNodeText(parnode,"Image");
               if(text.equals("") && title.equals("") && !image.equals("binary")){
                   mi.info("not creating everything component for "+mi.destPage.getPath()+":"+mi.rownum+","+mi.colnum);
                   destPar.remove();
                   return false;
               }
               
               JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/everything"); 

               String textalign=Util.getChildNodeText(parnode,"TextAlignment");
               if(textalign=="")textalign="left";
               JcrUtil.setProperty(destPar,"textAlign",textalign);
               
               if(!textalign.equals("") && !textalign.equals("left")){
                   text="<p style=\"text-align: "+textalign+";\">"+text+"</p>";
               } 

               JcrUtil.setProperty(destPar,"text",text);  
               JcrUtil.setProperty(destPar,"textIsRich","true"); 

               JcrUtil.setProperty(destPar,"backgroundColor","sitecolor2");  
               JcrUtil.setProperty(destPar,"borderSize","");
               /* IMAGE */
               
               String imagePosition=Util.getChildNodeText(parnode,"ImagePosition");
               //??
               if(imagePosition==""){
                   String imageTitleAlign=Util.getChildNodeText(parnode,"ImageTitleAlignment");
                   if(imageTitleAlign.equals("top")){  
                       imagePosition="left";
                   }
                   
               }
               //String height=Util.getChildNodeText(parnode,"Height");
               javax.jcr.Node imgNode=null;
               String linkurl="";
               if(image.equals("binary")){
                   //get image and save it to image node
                   //retMsg+=addMsg(mi.dump());  
                   imgNode=Util.createImageNode(destPar,mi);
                   if(imgNode!=null){
                       //JcrUtil.setProperty(destPar,"image","");
                       JcrUtil.setProperty(destPar,"imagePosition",imagePosition);
                       linkurl=Util.getChildNodeText(parnode,"LinkUrl");
                       linkurl=Util.fixLinks(linkurl,mi);
                       JcrUtil.setProperty(destPar,"imageLink",linkurl);
                       JcrUtil.setProperty(destPar,"imageSize",1.0);               
                       JcrUtil.setProperty(destPar,"captionText",Util.getChildNodeText(parnode,"ImageCaption"));
                       JcrUtil.setProperty(destPar,"captionAlignment",Util.getChildNodeText(parnode,"ImageCaptionAlignment"));  
                       String imageMap=Util.getChildNodeText(parnode,"ImageMap");
                       if(imageMap!=""){ 
                           //log.info("imageMap:"+imageMap);
                           String newImageMap=Util.convertImageMap(imageMap);
                           //String newImageMap="newImageMap";
                           //log.info("newImageMap:"+newImageMap);
                           newImageMap=Util.fixLinks(newImageMap,mi);
                           JcrUtil.setProperty(imgNode,"imageMap",newImageMap);
                       }
                   }
               
                   if((Util.getChildNodeText(parnode,"File")).equals("binary")){
                        String downloadparurl=addDownloadParagraph(parnode,"Image Link","",mi);
                        if(imgNode!=null && linkurl.equals("")){
                            JcrUtil.setProperty(destPar,"imageLink",downloadparurl);
                        }
                   }
               }
               if(Util.getChildNodeText(parnode,"ParSel").equals("textwithdownload")){
                   if((Util.getChildNodeText(parnode,"File")).equals("binary")){
                        String downloadparurl=addDownloadParagraph(parnode,"Image Link","",mi);
                        
                   }
               }
               JcrUtil.setProperty(destPar,"backgroundColor","sitecolor2");
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
                       
  
               
               String titlebgcolor="";
               String bordercolor="";
           
               JcrUtil.setProperty(destPar,"title",title);

               String titleStyle=Util.getChildNodeText(parnode,"AtomStyle");
               if(titleStyle==""){
                   titleStyle="sectionSubTitle";
               }else{
                   String newstyle=(String)mi.titlestyles.get(titleStyle);
                   if(newstyle!=null)titleStyle=newstyle;
               }
               
               String titlealign=Util.getChildNodeText(parnode,"TableBorderAlignment");
               if(titlealign=="")titlealign=Util.getChildNodeText(parnode,"TitleAlignment");
   
               String titlecolor=Util.getChildNodeText(parnode,"BorderTitleColor");   
               if(titlecolor=="")titlecolor=Util.getChildNodeText(parnode,"TableHeaderFontColor");

               if(!title.equals(""))titlebgcolor="sitecolor3";

               String tablebordercolor=Util.getChildNodeText(parnode,"TableBorderColor1");
               if(tablebordercolor=="")tablebordercolor=Util.getChildNodeText(parnode,"TableBorderColor");
               if(tablebordercolor!=""){
                   bordercolor=tablebordercolor.trim().toUpperCase();
                   titlebgcolor=tablebordercolor.trim().toUpperCase();
               }
               titlecolor=titlecolor.trim().toUpperCase();
                 
               
               if(titlecolor!=""){
                   if("FFFFFF".contains(titlecolor)){
                       titlecolor="white";
                   }else if("000000".contains(titlecolor)){
                       titlecolor="black";
                   }else{
                       titlecolor="default";
                   }
               }
               if(titlecolor=="")titlecolor="black";

               if(titlebgcolor!=""){
                   if("FFFFFF".contains(titlebgcolor)){
                       titlebgcolor="sitecolor2";
                   }else if("000000".contains(titlebgcolor)){
                       titlebgcolor="sitecolor1";
                   }else{
                       titlebgcolor="sitecolor3";
                   }
               }
               if(titlebgcolor=="")titlebgcolor="sitecolor3";
              
               if(bordercolor!=""){
                   if("FFFFFF".contains(bordercolor)){
                       bordercolor="sitecolor2";
                   }else if("000000".contains(bordercolor)){
                       bordercolor="sitecolor1";
                   }else{
                       bordercolor="sitecolor3";
                   }
               }
               if(bordercolor=="")bordercolor="sitecolor3";
             
               if(titlecolor.equals("white"))
                 titlebgcolor="sitecolor1"; 
               String sepColor=Util.getChildNodeText(parnode,"HorizontalRuleColor");     
               String separatorwidth=Util.getChildNodeText(parnode,"VerticalPadding");
               if(!sepColor.equals("") && !sepColor.equals("none")){
                if("FFFFFF".contains(sepColor)){
                   sepColor="sitecolor2";
                   }else if("000000".contains(sepColor)){
                   sepColor="sitecolor1";
                   }else{
                   sepColor="sitecolor3";
                   }
                   if(separatorwidth=="")separatorwidth="1";
               }
               
               String borderSize=Util.getChildNodeText(parnode,"TableBorderSize");               
               
               //McWeb defaults
               if(mi.cq4siteroot.contains("/mcweb/")){
                   titlecolor="sitecolor3";
                   titlebgcolor="sitecolor2";
                   if(!separatorwidth.equals("")){
                       sepColor="sitecolor5";
                       separatorwidth="2";
                   }
                   if(!title.equals("")){
                       if(!mi.titleComponentFound){
                           titleStyle="siteTitle";
                           mi.titleComponentFound=true;
                       }else{
                           titleStyle="sectionTitle";
                       }
                       titlealign="left";
                       JcrUtil.setProperty(destPar,"paddingTop","20");
                   }
               }
               //Magic defaults
               if(mi.cq4siteroot.contains("/mcdonalds/wmi/")){
                   titlecolor="white";
                   titlebgcolor="sitecolor2";
                   if(!separatorwidth.equals("")){
                       sepColor="sitecolor5";
                       separatorwidth="2";
                   }
                   if(!title.equals("")){
                       if(!mi.titleComponentFound){
                           titleStyle="siteTitle";
                           mi.titleComponentFound=true;
                       }else{
                           titleStyle="sectionSubTitle";
                       }
                       titlealign="left";
                       JcrUtil.setProperty(destPar,"paddingTop","20");
                   }
               }
               
                //UK Franchisee defaults
               if(mi.cq4siteroot.contains("/franchiseemcd/")){
                   titlecolor="white";
                   titlebgcolor="sitecolor3";
                   
                   if(!text.equals(""))borderSize="3";
                   bordercolor="sitecolor3";
                   
                   JcrUtil.setProperty(destPar,"includeCorner","true");

                   JcrUtil.setProperty(destPar,"paddingTopText","10");
                   JcrUtil.setProperty(destPar,"paddingBottomText","10");
 
                   JcrUtil.setProperty(destPar,"paddingLeftImage","10");
                   JcrUtil.setProperty(destPar,"paddingRightImage","10");
                   JcrUtil.setProperty(destPar,"paddingTopImage","10");
                   JcrUtil.setProperty(destPar,"paddingBottomImage","10");
                   

               }
               
               JcrUtil.setProperty(destPar,"titleAlign",titlealign);
               JcrUtil.setProperty(destPar,"titleType",titleStyle);
               JcrUtil.setProperty(destPar,"titleColor",titlecolor);
               JcrUtil.setProperty(destPar,"titleBackgroundColor",titlebgcolor);
               JcrUtil.setProperty(destPar,"separatorColor",sepColor);
               JcrUtil.setProperty(destPar,"separatorWidth",separatorwidth);

                

               if(borderSize=="")borderSize="0";
               JcrUtil.setProperty(destPar,"borderSize",borderSize);
               JcrUtil.setProperty(destPar,"borderColor",bordercolor);
               
                    
           }catch(Exception e){
           }

           return true;
   }
   
   public static boolean displayUnmigratedMessage(Element parnode, MigrationInfo mi,String partype){
           if(!mi.process){
               mi.fixpar++;
               return true;
               }
           try{
               log.info("displayUnmigratedMessage"+mi.destPage.getPath());
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
   
      public static javax.jcr.Node createEverythingContent(javax.jcr.Node parnode, String content,MigrationInfo mi){
           javax.jcr.Node destPar=null;
           if(mi.process || !mi.fixed){
               try{
                   
                   if(mi.fixed){
                       int parcount=0;
                       while(parcount<1000){
                           if(!parnode.hasNode("everything_"+parcount))break;
                           parcount++;
                       }
                       
                       destPar=parnode.addNode("everything_"+parcount,"nt:unstructured");
                       JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/everything");
                       JcrUtil.setProperty(destPar,"text",content);
                       JcrUtil.setProperty(destPar,"textIsRich","true");  
                   }else{
                       destPar=parnode.getNode("everything_"+mi.fixpar);  
                       JcrUtil.setProperty(destPar,"text",content);
                       mi.fixsave=true;
                       mi.fixpar++;
                   }
                   
                   

               }catch(Exception e){
               }
            }
           return destPar;
   }
             

   private static String removeTags(String text){
       String ret="";
       ret=text.replaceAll("\\<ul\\>","").replaceAll("\\<\\/ul\\>","");
       ret=ret.replaceAll("\\<li\\>","").replaceAll("\\<\\/li\\>","");
       ret=ret.replaceAll("\\<br\\>","");
       return ret;
   }
   protected static String processText(String intext,Element parnode,MigrationInfo mi){
       String text="";
       if(intext==null || intext.equals(""))return "";
       //mi.info("processText:"+intext);
       text = (new AutoFormatter()).format(intext, AutoFormatter.FORMAT_AUTOBR); 
       //Resolve download links
        int k = 1;
        StringBuffer sb = new StringBuffer(text);
        int tokenPosition = sb.indexOf("---File---");
        boolean hasText=false;
        int lastTokenPosition=0;
        while (tokenPosition != -1 ) {
    
            if (k > 5 ) {
            
                int tokenPosition1 = sb.indexOf("<A TARGET=\"new\" HREF=\"---File---\">");
                if(tokenPosition1>0){
                    String checkText=removeTags(sb.substring(lastTokenPosition,tokenPosition1).trim());
                    //mi.info("checkText a:"+checkText);
                    if(!checkText.equals("")){
                        hasText=true;
                    }
                }
                sb = sb.replace(tokenPosition1, tokenPosition1 + 34, "");
                text = sb.toString();
                int tokenPosition2 = sb.indexOf("</A>", tokenPosition1);
                sb = sb.replace(tokenPosition2 , tokenPosition2 + 4, "");
                text = sb.toString();
                
                lastTokenPosition=sb.indexOf("</A>", tokenPosition1)+4;
            }
           else if (k <6){
           
                    int tokenPosition1 = sb.indexOf("<A TARGET=\"new\" HREF=\"---File---\">");
                    //sb = sb.replace(tokenPosition1, tokenPosition1 + 34, "");
                    if(tokenPosition1>0){
                        String checkText=removeTags(sb.substring(lastTokenPosition,tokenPosition1).trim());
                        //mi.info("checkText b:"+checkText);
                        if(!checkText.equals("")){
                            hasText=true;
                        }
                    }
                    int tokenPosition2 = sb.indexOf("</A>", tokenPosition1);
                    String tmpfileName=sb.substring(tokenPosition1+34 , tokenPosition2);
                    
                
                if((Util.getChildNodeText(parnode,"File" + k)).equals("binary")){

                    String downloadparurl=addDownloadParagraph(parnode,tmpfileName,k+"",mi);
                    //log.error("downloadparurl:"+downloadparurl);
                    sb=sb.replace(tokenPosition1+22 , tokenPosition1 + 32, downloadparurl);
                    //log.error("download string:"+downloadparurl);
               
                }else{
                    if((Util.getChildNodeText(parnode,"File")).equals("binary")){
                    
                        String downloadparurl=addDownloadParagraph(parnode,tmpfileName,"",mi);
                         sb=sb.replace(tokenPosition1+22 , tokenPosition1 + 32, downloadparurl);
               
                    }else{
                        sb= sb.replace(tokenPosition1+22 , tokenPosition1 + 32, "");
                    }
                }
                lastTokenPosition=sb.indexOf("</A>", tokenPosition1)+4;
                
            }
            
            k++;
            
            tokenPosition = sb.indexOf("---File---");
        }
        if(!hasText){
            String checkText=removeTags(sb.substring(lastTokenPosition).trim());
            //mi.info("checkText c:"+checkText);
            if(!checkText.equals("")){
                hasText=true;
            }
        }
        if(hasText){
            text = sb.toString();
        }else{
            text="";
        }
       
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
      text=text.trim();
      return text; 
   }
   
   

   
   private static String addDownloadParagraph(Element parnode,String tmpfileName,String k, MigrationInfo mi){
       //if(!mi.process)return "";
       try{
           if(mi.destPage.getPath().endsWith("/_creative2")){
               mi.info("skipping download component creation for:"+tmpfileName);
               return "";
           }
       }catch(Exception re){
       }
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