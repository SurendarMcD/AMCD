package com.mcd.accessmcd.cq.migration.util;

/* Table helper class from CQ4 */

import java.util.*;
import java.io.*;
import java.net.*;
import java.lang.IndexOutOfBoundsException;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.auth.*;
import org.apache.commons.httpclient.methods.*;
import org.w3c.dom.*;
import com.mcd.accessmcd.cq.migration.paragraphs.*;
import com.day.cq.commons.jcr.*; 
import javax.jcr.Session;

  public class Util{

  public static String getChildNodeText(Element node,String childnodename){
       String retVal="";
       NodeList childelem = node.getElementsByTagName(childnodename);
       if(childelem.getLength()>0){
           Element childElem=(Element)childelem.item(0);
           retVal=getCharacterDataFromElement(childElem);
       }
       return retVal;
   } 
 

   public static String getCharacterDataFromElement(Element e) {
       org.w3c.dom.Node child = e.getFirstChild();
       if (child instanceof CharacterData) {
         CharacterData cd = (CharacterData) child;
           return cd.getData();
         }
       return "?";
   } 
 
   public static javax.jcr.Node createImageNode(javax.jcr.Node par, MigrationInfo mi){
       if(!mi.process)return null;
       javax.jcr.Node imgNode=null;
       try{
           if(!par.hasNode("image")){
               imgNode= par.addNode("image", "nt:unstructured");
               imgNode.setProperty("sling:resourceType","foundation/components/image");
           }else{
               imgNode=par.getNode("image");
           }
           String cq4resource=".RowPar."+mi.rownum+".ContentPar."+mi.colnum+".ColumnPar."+mi.parnum+".Image.gif";
            if(!mi.isSuperTemplate || mi.colname.equals("SideBarContent")){
                cq4resource="."+mi.colname+"Par."+mi.parnum+".Image.gif";
            }
           javax.jcr.Node filenode=createFileNode(imgNode,mi,cq4resource,"image/jpeg");
           if(filenode==null){
               return null;
           }
           
       }catch(Exception e){
       }
       return imgNode;
   }
   
   public static javax.jcr.Node createFileNode(javax.jcr.Node node, MigrationInfo mi, String cq4resource,String mimetype){
   
       if(!mi.process)return null;
       
       javax.jcr.Node fileNode=null;
       try{
           if(!node.hasNode("file")){
                fileNode=node.addNode("file", "nt:file");
                javax.jcr.Node contentNode = fileNode.addNode("jcr:content", "nt:resource");
                // set the mandatory properties
                
                if(mimetype==""){
                    //automatically set mime type based on retrieved content
                    byte[] fileBytes=getCQ4Content(mi,cq4resource,contentNode);
                    if(fileBytes!=null){
                        contentNode.setProperty("jcr:data", new ByteArrayInputStream(fileBytes));
                    }else{
                        return null;
                    }
                }else{
                    byte[] fileBytes=getCQ4Content(mi,cq4resource,null);
                    if(fileBytes!=null){
                        contentNode.setProperty("jcr:data", new ByteArrayInputStream(fileBytes));
                        contentNode.setProperty("jcr:mimeType", mimetype);
                    }else{
                        return null;
                    }
                }
                
                contentNode.setProperty("jcr:lastModified", Calendar.getInstance());
                
           }
       }catch(Exception e){
       }
       return fileNode;
     }

   public static byte[] getCQ4Content(MigrationInfo mi,String page,javax.jcr.Node contentNodeToSetMimeTypeOn){
            
            
            String url=mi.cq4server+mi.cq4page+page;
            byte[] retbytes=null;
            GetMethod getPageMeth=null; 
            org.apache.commons.httpclient.HttpClient client = new HttpClient();
            HostConfiguration host = client.getHostConfiguration();
            mi.info("Getting CQ4 content url:"+url);
            if(!url.contains(".showxml.")&& !mi.process)return null;
            try {
                //url=URLEncoder.encode(url);
                //System.err.println("CQ4 url:"+url);
                host.setHost(new org.apache.commons.httpclient.URI(url));
                org.apache.commons.httpclient.Credentials credentials = new UsernamePasswordCredentials("superuser", mi.cq4supwd);
                client.getState().setCredentials(AuthScope.ANY, credentials);
                
                getPageMeth= new GetMethod(url);
                
                getPageMeth.setDoAuthentication( true );       
                getPageMeth.getParams().setParameter("http.socket.timeout", new Integer(120000));        
                client.getParams().setAuthenticationPreemptive( true );

                int status = client.executeMethod(getPageMeth);
                              
                if(status==200){
                    //retbytes= getPageMeth.getResponseBody(); 
                    byte[] byteArray=new byte[1024];
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream() ;
                    int count = 0 ;
                    while((count = getPageMeth.getResponseBodyAsStream().read(byteArray, 0, byteArray.length)) > 0)
                    { 
                     outputStream.write(byteArray, 0, count) ;
                    }                 
                    retbytes=outputStream.toByteArray();
                    
                    if(contentNodeToSetMimeTypeOn!=null){
                        String mimetype = getPageMeth.getResponseHeader("Content-type").toString(); 
                        if(mimetype==null)mimetype="application/octet-stream";//default
                        if(mimetype.indexOf(":")>-1){
                            mimetype=mimetype.substring(mimetype.indexOf(":")+1);
                            if(mimetype.indexOf(";")>-1){
                                mimetype=mimetype.substring(0,mimetype.indexOf(";"));
                            }
                        }
                        mimetype=mimetype.trim();
                        contentNodeToSetMimeTypeOn.setProperty("jcr:mimeType", mimetype); 
                       }               
                 }        
            } catch(Exception e){
            }
            finally {
                getPageMeth.releaseConnection();
                client=null;
            }
            return retbytes;
     }



    public static String[] linkToCheck = { ".mcdexchange.com"
                                                             , ".mcdwmi.com"
                                                             , "wmi.accessmcd.com"                                                       
                                                             , "www.mcweb.ca"
                                    };
    public static String[] linkToMatch = { 
                       "https://prodp.mcdexchange.com"
                      ,"https://intl.mcdexchange.com"
                      ,"http://intl.mcdexchange.com"
                      ,"https://mcweb.mcdexchange.com"
                      ,"http://www.mcweb.ca" 
                      ,"https://www.mcdwmi.com" 
                      ,"http://www.mcdwmi.com" 
                      ,"https://wmi.accessmcd.com"               
                      ,"http://dmc.accessmcd.com" 
                      ,"https://dmc.accessmcd.com"              
                    
                                    };
                                
    public static String createTarget( String theUrl){
          boolean linkMatched = false;
                      
          if (theUrl.indexOf(".html") !=-1){
              for (int i = 0; i < linkToCheck.length; i++) {
                      if (theUrl.indexOf(linkToCheck[i]) != -1 ) {
                          linkMatched = true;
                       break;
                  }       
                  }//end for 1
          }//end if 

          for (int j = 0; j < linkToMatch.length; j++) {
                   if (theUrl.equalsIgnoreCase(linkToMatch[j])) {
                   linkMatched = true;
               break;
           }          
              }//end for 2
                
          if (linkMatched)
          {
                  return "_self";
              }else{
                  return "_blank";
          }
          }
          
    public static String processParagraph(Element parnode, MigrationInfo mi){
       String retMsg="";
       mi.parnum=parnode.getAttribute("parnum");
       
       mi.info("Processing para:"+mi.parnum);
       
       String partype=Util.getChildNodeText(parnode,"ParSel");
       //check for File Download  (used by redirect_file_attach template)
       //if(Util.getChildNodeText(parnode,"File").equals("binary"))
       //    partype="download";
       retMsg+="Par Type:"+partype; 
       mi.info("Par Type:"+partype);
       if(partype.equals("mergepara") ||
        partype.equals("mw_mergepara") ||
        partype.equals("super_mergepara") ||
        partype.equals("text") ||
        partype.equals("textandimage") ||
        partype.equals("titletextimagepar") ||
        partype.equals("textwithdownload") ||
        partype.equals("imagewithdownload") || 
        partype.equals("textwithtitle") ||
        partype.equals("titlewithimage") ||
        partype.equals("mw_titletextimagepar") ||
        partype.equals("title") ||
        partype.equals("image") || 
        partype.equals("listpar") ||
        partype.equals("combinedtextandtitlewithborder") ||
        partype.equals("mw_combinedtextandtitlewithborder") ||
        partype.equals("mw_textwithtitleandborder") ||
        partype.equals("webdocpar") ||
        partype.equals("textwithtitleandborder") ||
        partype.equals("imageandtextlink") ||
        partype.equals("frankeltextandimageyellowbox") ||
        partype.equals("bulletedtextandtitlewithborder") 
        ){
           com.mcd.accessmcd.cq.migration.paragraphs.MergePara.process(parnode,mi);
       }else if(partype.equals("bulletedlist") ||
           partype.equals("numberedlist")||
        partype.equals("bulletedlistwithtitle")
       ){
           com.mcd.accessmcd.cq.migration.paragraphs.ListPara.process(parnode,mi);
       }else if(partype.equals("searchdmc")){
           com.mcd.accessmcd.cq.migration.paragraphs.SearchDMCPara.process(parnode,mi);
       }else if(partype.equals("tablepar") ||
       partype.equals("table") ||
       partype.equals("mw_tablepar")){
           com.mcd.accessmcd.cq.migration.paragraphs.TablePara.process(parnode,mi);
       }else if(partype.equals("flash") ||
       partype.equals("flashmcd")){
           com.mcd.accessmcd.cq.migration.paragraphs.FlashPara.process(parnode,mi);
       }else if(
       partype.equals("linebreak") || 
       partype.equals("lineseparator") ||
       partype.equals("mw_lineseparator")){ 
           //??
       }else if(partype.equals("multidownload")|| 
       partype.equals("download") ||
       Util.getChildNodeText(parnode,"File").equals("binary") ){
           com.mcd.accessmcd.cq.migration.paragraphs.DownloadPara.process(parnode,mi);
       }else if(partype.equals("inputfield")){
           com.mcd.accessmcd.cq.migration.paragraphs.InputPara.process(parnode,mi);
       }
       else if(partype.equals("listchildren")){
           com.mcd.accessmcd.cq.migration.paragraphs.ListChildrenPara.process(parnode,mi);
       }
       else if(partype.equals("twocolumntext")){
           com.mcd.accessmcd.cq.migration.paragraphs.TwoColPara.process(parnode,mi);
       }
       else if(partype.equals("faqpar")){
           com.mcd.accessmcd.cq.migration.paragraphs.FAQPara.process(parnode,mi);
       }
       else{
           //create placeholder for unmigrated paragraph
           com.mcd.accessmcd.cq.migration.paragraphs.MergePara.displayUnmigratedMessage(parnode,mi,partype);
           mi.error(mi.cq4page+" : Unmigrated Par Type:"+partype);
       }
       return retMsg;
   }
   
   /* updates same-site links in text from CQ4 url to CQ5 url */
   public static String fixLinks(String text,MigrationInfo mi) {
       String retText=text;
       String replace=(!mi.linkroot.equals(""))?mi.linkroot:mi.cq4siteroot;
       
       //if(replace.endsWith("/"))replace=replace.substring(0,replace.length()-1);
       if(replace.startsWith("/content"))replace=replace.substring(8);

       String replaceWith=(!mi.linktranslate.equals(""))?mi.linktranslate:mi.cq5siteroot;
       
       //if(replaceWith.endsWith("/"))replaceWith=replaceWith.substring(0,replaceWith.length()-1);
       if(replaceWith.startsWith("/content"))replaceWith=replaceWith.substring(8);


       //mi.info("replace:"+replace);
       //mi.info("replaceWith:"+replaceWith);
       //mi.info("text:"+text);
       if(text.contains(replace)){
           
           //within migration tree
           //replace domains, too
           if(!mi.cq4domain.equals("")){
               //mi.info("replace1:");
               retText=text.replaceAll(mi.cq4domain+replace,replaceWith);
               }
           //System.out.println("replace:"+mi.cq4domain+replace+" replaceWith:"+replaceWith);
           //mi.info("replace2:"+retText);
           retText=retText.replaceAll(replace,replaceWith);
           //mi.info("replace2a:"+retText);
        }else{
           if(text.startsWith("/")){
               //convert to external link
               retText=mi.cq4domain+text;
               if(!retText.endsWith(".html") && !retText.endsWith(".htm")){
                   retText+=".html";
               }
           }
        }
       return retText;
   }
   
   public static boolean addInheritanceNode(javax.jcr.Node basePage, MigrationInfo mi,String nodename,boolean inherit){
        if(!mi.process)return true;
        try{
            if(basePage.hasNode(nodename)){
                mi.destPage=basePage.getNode(nodename);
            }else{
                mi.destPage=basePage.addNode(nodename,"nt:unstructured");
               }  
            JcrUtil.setProperty(mi.destPage,"sling:resourceType","foundation/components/iparsys");
            javax.jcr.Node destPar=mi.destPage.addNode("iparsys_fake_par","nt:unstructured");
            JcrUtil.setProperty(destPar,"sling:resourceType","foundation/components/iparsys/par"); 
            if(!inherit)JcrUtil.setProperty(destPar,"inheritance","cancel");       
        }catch(Exception e){
        }
        return true;
   }
   
   /* converts the HTML imagemap of cq4 to the cq5 image map format */
   public static String convertImageMap(String imageMap){
   
       String retMap="";
       
       //parse image map
       int currentloc=0;
       int mapEntryStart=imageMap.indexOf("<",currentloc);
       int mapEntryEnd=imageMap.indexOf(">",currentloc);
       while(mapEntryStart>-1 && mapEntryEnd>-1){
           String mapEntry=imageMap.substring(mapEntryStart+1,mapEntryEnd);
           String mapalt=getImageMapAttribute(mapEntry,"alt");
           String maphref=getImageMapAttribute(mapEntry,"href");
           String mapshape=getImageMapAttribute(mapEntry,"shape");
           String mapcoords=getImageMapAttribute(mapEntry,"coords");
           String maptarget=getImageMapAttribute(mapEntry,"target");
           retMap+="["+mapshape+"("+mapcoords+")\""+maphref+"\"|";
           if(maptarget!=""){
               retMap+="\""+maptarget+"\"";
           }
           retMap+="|\""+mapalt+"\"]";
       
           currentloc=mapEntryEnd+1;
           mapEntryStart=imageMap.indexOf("<",currentloc);
           mapEntryEnd=imageMap.indexOf(">",currentloc);
       }
                        
                       
       return retMap;
   
   }
   
   /* converts the HTML imagemap of cq4 to the cq5 image map format */
   public static String getImageMapAttribute(String imageMapEntry, String attribute){
   
       String attr="";
       int attrloc=imageMapEntry.indexOf(attribute+"='");
           if(attrloc>-1){
               int attrloc2=imageMapEntry.indexOf("'",attrloc+attribute.length()+2);
               if(attrloc2>-1){
                   attr=imageMapEntry.substring(attrloc+attribute.length()+2,attrloc2);                   
               }
           }
       
       return attr;
   }
   
   /* add navigation components to page */
   public static String addNavigation(javax.jcr.Node origDestPage, MigrationInfo mi){
       if(!mi.process)return "";
       String retMsg="";
       if(mi.currentLevel==1){
           try{
                    if(mi.addTopNav){
                        //add a topnav paragraph
                        if(origDestPage.hasNode("topnavpara")){
                            mi.destPage=origDestPage.getNode("topnavpara");
                        }else{
                            mi.destPage=origDestPage.addNode("topnavpara","nt:unstructured");
                        }  
                        JcrUtil.setProperty(mi.destPage,"sling:resourceType","foundation/components/iparsys");
                        javax.jcr.Node destPar=mi.destPage.addNode("topnavigation","nt:unstructured");
                        JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/topnavigation"); 
                        JcrUtil.setProperty(destPar,"dispTopNavImg","yes");
                        
                        JcrUtil.setProperty(destPar,"listroot",mi.cq5siteroot); 
                    }
                    if(mi.addLeftNav){
                        //add a leftparagraph
                        if(origDestPage.hasNode("leftcontentpara")){
                            mi.destPage=origDestPage.getNode("leftcontentpara");
                        }else{
                            mi.destPage=origDestPage.addNode("leftcontentpara","nt:unstructured");
                        }  
                        JcrUtil.setProperty(mi.destPage,"sling:resourceType","foundation/components/iparsys");
                        javax.jcr.Node destPar=mi.destPage.addNode("leftnavigation","nt:unstructured");
                        JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/leftnavigation"); 
                        JcrUtil.setProperty(destPar,"listroot",mi.cq5siteroot); 
                        destPar.setProperty("stoplevel",2);
                    }
          }catch(Exception e){ 
              retMsg="Error addNavigation:"+e.getMessage();       
          }
      }
   return retMsg;
   }

   /* add inherited sections to page 11/1/11 ECW*/
   public static String addInheritedSections(javax.jcr.Node origDestPage, MigrationInfo mi){
       if(!mi.process)return "";
       String retMsg="";
      
           try{
                    //add inherited sections to page
                    if(!origDestPage.hasNode("sitelogopara")){addInheritanceNode(origDestPage, mi, "sitelogopara",true);}
                    if(!origDestPage.hasNode("breadcrumbpara")){addInheritanceNode(origDestPage, mi, "breadcrumbpara",true);}
                    if(!origDestPage.hasNode("topnavpara")){addInheritanceNode(origDestPage, mi, "topnavpara",true);}
                    if(!origDestPage.hasNode("leftnavpara")){addInheritanceNode(origDestPage, mi, "leftnavpara",true);}
                    if(!origDestPage.hasNode("leftcontentpara")){addInheritanceNode(origDestPage, mi, "leftcontentpara",true);}
                    if(!origDestPage.hasNode("rightcontentpara")){addInheritanceNode(origDestPage, mi, "rightcontentpara",true);}
 
          }catch(Exception e){ 
              retMsg="Error addNavigation:"+e.getMessage();       
          }

   return retMsg;
   }   
   
   
   public static javax.jcr.Node getCQ5Page(Session session, String loc, String newpage,boolean bCreate){
         
         javax.jcr.Node retNode=null;
         try{
             javax.jcr.Node parentNode=session.getNode(loc); 
             if(parentNode!=null){
                 if(!parentNode.hasNode(newpage) && bCreate){
                     retNode=JcrUtil.createPath(loc+"/"+newpage+"/jcr:content","cq:Page","cq:PageContent", session,true);
                     //session.save();
                 }else{
                     retNode=parentNode.getNode(newpage);
                 }
             }
         }catch(Exception e){
                 
         }
         
         return retNode;
     }
     
     public static String addPageProperties(MigrationInfo mi,Element srcElement){
         if(!mi.process)return "";
         String retMsg="";
         try{
            //retMsg+=addMsg("Adding property to :"+mi.destPage.getPath());
            JcrUtil.setProperty(mi.destPage,"jcr:title",Util.getChildNodeText(srcElement,"TitleText"));
            JcrUtil.setProperty(mi.destPage,"cq:template","/apps/mcd/templates/g2g");
            JcrUtil.setProperty(mi.destPage,"sling:resourceType","mcd/components/page/g2g");   
            if(mi.currentLevel==1 && mi.design!="") JcrUtil.setProperty(mi.destPage,"cq:designPath",mi.design);
            JcrUtil.setProperty(mi.destPage,"authorName",Util.getChildNodeText(srcElement,"Author")); 
            JcrUtil.setProperty(mi.destPage,"authorEmail",Util.getChildNodeText(srcElement,"ContactEmail"));
            JcrUtil.setProperty(mi.destPage,"hideHeader","parent");
            JcrUtil.setProperty(mi.destPage,"hideTopNav","parent");
            JcrUtil.setProperty(mi.destPage,"hideLeftNav","parent");
            /*
            String keywords=Util.getChildNodeText(srcElement,"Keywords"); 
            String[] kwds=keywords.split(",");
            for(int i=0;i<kwds.length;i++){
                kwds[i]=kwds[i].toLowerCase().trim().replace(" ","_");
            }
            /*
            StringTokenizer st=new StringTokenizer(keywords,",");
            ArrayList al=new ArrayList();
            while(st.hasMoreTokens()){
                String tok=st.nextToken();
                al.add(st.trim());
            }
            */
            //ArrayList arrtags=new ArrayList();
            //arrtags.add("mcd");  
            //arrtags.add("test");     
            String[] testtags={"reports","text","test"};
            
            //mi.destPage.setProperty("cq:tags",kwds);  
            java.util.Calendar nowDate=java.util.Calendar.getInstance();
            JcrUtil.setProperty(mi.destPage,"cq:lastModified",nowDate);
            JcrUtil.setProperty(mi.destPage,"jcr:description",Util.getChildNodeText(srcElement,"Abstract"));           
         }catch(Exception e){
             retMsg+="Error:"+e.getMessage()+"<br>";
         }
     
         return retMsg;
     }
     
       public static String processListText(String intext,String partype){
       String text=""; 
       //String[] newLines = com.mcd.accessmcd.cq.migration.util.Text.split(intext, '\n', true); 
       String[] newLines = intext.split("\n");
       String bulletLine = "";
       int previousCount=0;
       int currentCount=0;
       int j=0;
       String listtag="ul";
       if(intext==null || intext.equals(""))return "";
       if(partype.equals("NumberedList"))listtag="ol";
       text="<"+listtag+">";
       for(int i=0; i<newLines.length; i++ )  {
            bulletLine = newLines[i];
            
            if (bulletLine.length()>1){  //is not empty
                currentCount=numberTabs(bulletLine);
                if (currentCount > previousCount) { //indenting the bullet
                    j=(currentCount-previousCount);
                    
                    while (j>0) {
                        text+="<"+listtag+">";
                        j-=1;
                    }
                }
                else if (currentCount < previousCount) {//closing the <ul>
                    j=(previousCount - currentCount);   
                
                    while (j>0) {
                        text+="</"+listtag+">";
                        j-=1;
                    }
            
                }
        
                text+="<li>" + bulletLine +"</li>";
                previousCount=currentCount;
            }
            else{//is empty
                text+="<br>";
                previousCount=currentCount;
            }
    
        }

        text+="</"+listtag+">"; 
            
      return text; 
   }
   
  private static int numberTabs(String bulletLine){
    StringBuffer bulletLineBuffer = new StringBuffer(); 
    int count=0;
    if (bulletLine.indexOf('\t') != -1) {
        bulletLineBuffer.append(bulletLine);
        while (bulletLine.indexOf('\t')==0){
            count+=1; 
            bulletLineBuffer.delete(0,1);   
            bulletLine=bulletLineBuffer.toString();
        }
    }
    return count;
}   
     
}