 <%--
  ==============================================================================
  AU to G2G Migration Utility
  
  Erik Wannebo 3/29/2012
  ==============================================================================
--%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.text.*,
                java.io.*,
                javax.jcr.*,
                javax.jcr.Session,
                com.day.cq.commons.jcr.*,
                org.apache.commons.httpclient.*,
                org.apache.commons.httpclient.auth.*,
                org.apache.commons.httpclient.methods.*,
                org.w3c.dom.*,javax.xml.parsers.*,org.xml.sax.*,
                com.mcd.accessmcd.cq.migration.templates.*,
                com.mcd.accessmcd.cq.migration.paragraphs.*,
                com.mcd.accessmcd.cq.migration.util.*,
                com.day.cq.wcm.api.*
                "
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%
%><%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %><%
%><%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%
%><cq:defineObjects /> 
<script src="/apps/mcd/docroot/scripts/jquery-1.3.2.min.js"></script>
<script language=Javascript> 
function iframecompare(page1,page2){
    document.getElementById("frame1").src=page1;
    document.getElementById("frame2").src=page2;
    
}
</script>




<title>AU Migration</title>
</head>

<%!  
    
    public String addMsg(String addmsg){
         return addmsg+"<BR>";
    }
    
    public String addErrMsg(String addmsg){
         return "<font color=red>"+addmsg+"</font><BR>";
    }
    
    public String doMigration(Session session, PageManager pageManager, Page currentPage, MigrationInfo mi, int currentLevel){
        
        String retMsg="";
        mi.currentLevel=currentLevel;
        
        try{ 

            String srcPath=mi.cq4page.substring(0,mi.cq4page.lastIndexOf("/")+1); 
            String srcPageName=mi.cq4page.substring(mi.cq4page.lastIndexOf("/")+1); 
            String cq5srcPageName=srcPageName;
            
            if(mi.currentLevel==1 && !mi.cq5basepagename.equals(""))cq5srcPageName=mi.cq5basepagename;   
            //mi.cq5basepagename=cq5srcPageName;
            String newCQ5page=mi.cq5dest+"/"+srcPageName;
            retMsg+="currentLevel:"+mi.currentLevel;
            if(mi.currentLevel==1){
                
                mi.cq4siteroot=mi.cq4page+"/";
                mi.cq5siteroot=mi.cq5dest+"/"+cq5srcPageName+"/";
                
            }
            newCQ5page=mi.cq5dest+"/"+cq5srcPageName;
            
            //retMsg+="new page:"+newCQ5page+"<br>";
            
            if(mi.process){
              retMsg+=addMsg("<a target='_new' href='/content/utility/utility.aumigration.html?compare=y&page1="+currentPage.getPath()+".html&page2="+newCQ5page+".html'>Compare "+newCQ5page+"</a><br>");
              Page newpage=pageManager.copy(currentPage,newCQ5page,null,true,false);
              javax.jcr.Node newpageNode=session.getNode(newCQ5page+"/jcr:content");
              retMsg+=processAUPage(newpageNode,mi);
              session.save();
            }else{
               retMsg+="new page:"+newCQ5page+"<br>";
            }
            
            if(currentLevel<mi.processLevels){
               Iterator niter=currentPage.listChildren();
               while(niter.hasNext()){
                    Page child=(Page)niter.next();
                    mi.cq4page=child.getName();
                    mi.cq5dest=newCQ5page; 
                    retMsg+="mi.cq4page:"+mi.cq4page+"<br>";
                    retMsg+="mi.cq5dest:"+mi.cq5dest+"<br>"; 
                    retMsg+=doMigration(session, pageManager, child, mi, currentLevel+1);
                }
            }
        }catch(Exception e){
        
        }   
     
        return retMsg;
     }
     
     public String processAUPage(javax.jcr.Node node,MigrationInfo mi){
      
        String retMsg="";

        try{
            //String srcPath=mi.cq4page.substring(0,mi.cq4page.lastIndexOf("/")+1); 
            //String srcPageName=mi.cq4page.substring(mi.cq4page.lastIndexOf("/")+1); 
            //String cq5srcPageName=srcPageName;
            //if(mi.currentLevel==1 && !mi.cq5basepagename.equals(""))cq5srcPageName=mi.cq5basepagename;   
            //mi.cq5basepagename=cq5srcPageName;
            //JcrUtil.copy(
            //javax.jcr.Node currentpage=getCQ5Page(session, srcPath, srcPageName)
            //mi.destPage=Util.getCQ5Page(session, srcPath,srcPageName);
            
            //javax.jcr.Node node = currentPage.adaptTo(javax.jcr.Node.class);
            
            //retMsg+=addMsg("Processing page:"+node.getPath());
            mi.info("Processing page:"+node.getPath());       
            if(mi.process){
               //fix page properties
               JcrUtil.setProperty(node,"cq:template","/apps/mcd/templates/g2g");
               JcrUtil.setProperty(node,"sling:resourceType","mcd/components/page/g2g");  
               if(node.hasProperty("redirectTarget")){
                   String currentRedirect=node.getProperty("redirectTarget").getString();
                   JcrUtil.setProperty(node,"redirectTarget",Util.fixLinks(currentRedirect,mi));
               }
               //fix parsys
               
               javax.jcr.Node parnode=null;
               
               parnode=renamenode(node,"contentpar","maincontentpara");
               fixcomponents(parnode,mi);
               //if(node.getPath().contains("/apmea/au"))accordionify(parnode);  
               parnode=renamenode(node,"topnavpar","topnavpara");
               //parnode=renamenode(node,"leftnavpar","leftnavpara");
               parnode=renamenode(node,"breadcrumbpar","breadcrumbpara");
               removenode(node,"printpar");
               removenode(node,"footerpar");
               removenode(node,"searchpar");
               removenode(node,"logopar");
               removenode(node,"leftnavpar");
               
               

            }
            
            mi.processed++;
         }catch(Exception e){
             retMsg+=addErrMsg("Exception:"+e.getMessage());
         }
         
         return retMsg;
      }
      
      private javax.jcr.Node renamenode(javax.jcr.Node parentnode,String oldname, String newname) throws RepositoryException{
      
         javax.jcr.Node retNode=null;
         
         if(parentnode.hasNode(oldname)){
              javax.jcr.Node childnode=parentnode.getNode(oldname);
              parentnode.getSession().move(childnode.getPath(), parentnode.getPath() + "/" + newname);
              
         }
         if(parentnode.hasNode(newname)){
            retNode=parentnode.getNode(newname);
         }
         return retNode;
         
      }
      
      private void removenode(javax.jcr.Node parentnode,String nodename) throws RepositoryException{
      
         if(parentnode.hasNode(nodename)){
             javax.jcr.Node childnode=parentnode.getNode(nodename);
             childnode.remove();
         }
         return;
         
      }
      
      private void fixcomponents(javax.jcr.Node parnode,MigrationInfo mi) throws RepositoryException{
       NodeIterator iternodes=parnode.getNodes();
       while(iternodes.hasNext()){
           javax.jcr.Node child=iternodes.nextNode();
           String restype=child.getProperty("sling:resourceType").getString();
           
           if(restype.equals("mcd/components/content/everything")){
               child.setProperty("backgroundColor","sitecolor2");
               String titleType="";
               if(child.hasProperty("titleType"))titleType=child.getProperty("titleType").getString();
               if(titleType.equals("siteTitle")){
                   child.setProperty("titleType","paragraphTitle");
                   child.setProperty("titleColor","black");
               }
               if(!child.hasProperty("text") &&  (titleType.equals("mainTitle") ||titleType.equals("siteTitle")) ){
                   child.setProperty("titleType","siteTitle");
                   child.setProperty("titleBackgroundColor","sitecolor3");
                   child.setProperty("titleColor","white");
                   child.setProperty("includeCorner","true");
               }
               //remove old icons
               if(child.hasNode("image")){
                    javax.jcr.Node imgNode=child.getNode("image");
                    if(imgNode.hasProperty("fileReference") && imgNode.getProperty("fileReference").getString().contains("PageIcons")){
                        imgNode.remove();
                        String titleColor="default";
                        titleType="sectionTitle";
                        child.setProperty("titleBackgroundColor","sitecolor5");
                        child.setProperty("includeCorner","true");
                        String title=child.getProperty("text").getString();
                        if(title.contains("<h3>"))title=title.replace("<h3>","").replace("</h3>","");
                        child.setProperty("title",title);
                        child.setProperty("text","");
                        String backgroundColor="sitecolor2";
                        child.setProperty("titleType",titleType);
                        child.setProperty("titleColor",titleColor);
                    }
               }
           }
           
           if(restype.equals("mcd/components/content/textimage")){
               child.setProperty("sling:resourceType","mcd/components/content/everything");
               String compname=child.getName();
               String titleColor="black";
               String titleType="paragraphTitle";              
               String backgroundColor="sitecolor2";
               if(compname.contains("textimage")){
                   //renamenode(parnode,compname,compname.replace("textimage","everything"));
                   //fix fields
                   //cssClass / inlinealign / centeralign? to imageposition
                   if(child.hasProperty("cq:cssClass")){
                       String cssClass=child.getProperty("cq:cssClass").getString();
                       if(cssClass.equals("image_left")){
                           child.setProperty("imagePosition","left");
                       }
                       if(cssClass.equals("image_center")){
                           child.setProperty("imagePosition","center");
                       }
                       if(cssClass.equals("image_right")){
                           child.setProperty("imagePosition","right");
                       }
                   }
                   //description to caption
                   //size (sizefield) to imagesize?
                   //
                   
                   //heading (heading1, heading2, heading3) to titletype
                    if(child.hasProperty("heading")){

                       String heading=child.getProperty("heading").getString();
                       if(heading.equals("heading1")){
                           if(!child.hasProperty("text")){ //page header
                               titleType="siteTitle";
                               titleColor="white";
                               //backgroundColor="sitecolor2";
                               child.setProperty("titleBackgroundColor","sitecolor3");
                               child.setProperty("includeCorner","true");
                           }else{
                               titleType="sectionSubTitle";
                           }
                       }
                       //remove old icons
                       if(child.hasNode("image")){
                            javax.jcr.Node imgNode=child.getNode("image");
                            if(imgNode.hasProperty("fileReference") && imgNode.getProperty("fileReference").getString().contains("PageIcons")){
                                imgNode.remove();
                                titleColor="default";
                                titleType="sectionTitle";
                                child.setProperty("titleBackgroundColor","sitecolor5");
                                child.setProperty("includeCorner","true");
                                String title=child.getProperty("text").getString();
                                if(title.contains("<h3>"))title=title.replace("<h3>","").replace("</h3>","");
                                child.setProperty("title",title);
                                child.setProperty("text","");
                                backgroundColor="sitecolor2";
                            }
                       }
                       child.setProperty("titleType",titleType);
                       child.setProperty("titleColor",titleColor);
                   } 
                   
                 
                       
                     child.setProperty("backgroundColor",backgroundColor);               
                   
                   //paddingTitle to paddingTitle items
                   //paddingTxtImg to paddingText items
                   
                   
               }
           }//textimage
           
           //fix column background color
           if(restype.equals("mcd/components/content/parsys/colctrl") ){
               
               child.setProperty("backgroundColumnctrl","sitecolor2");
               child.setProperty("useSiteLevel","n");
           }//colctrl
           
           if(restype.equals("foundation/components/reference") || 
           restype.equals("mcd/components/content/reference")){
                 String refpath=child.getProperty("path").getString();
                   if(refpath.contains("contentpar")){
                       refpath=refpath.replace("contentpar","maincontentpara");
                       String newpath=Util.fixLinks(refpath,mi);
                       child.setProperty("path",newpath);
                   }
           }
           //fixlinks
           //mi.info("fixLinks:"+child.getPath());
           if(child.hasProperty("text")){
                   String oldText=child.getProperty("text").getString();
                   //mi.info("oldText:"+oldText);
                   String fixedText=Util.fixLinks(oldText,mi);
                   child.setProperty("text",fixedText);
           }   
           

             
       }//iternodes

      }
      
      
      private void accordionify(javax.jcr.Node parnode) throws RepositoryException{
       NodeIterator iternodes=parnode.getNodes();
       int dmcsearchcount=0;
       while(iternodes.hasNext()){
           javax.jcr.Node child=iternodes.nextNode();
           String restype=child.getProperty("sling:resourceType").getString();
           
           if(restype.equals("mcd/components/content/searchdmc"))
               dmcsearchcount++;
       }
       if(dmcsearchcount<10)return;
       
       //gather accordion data
       iternodes=parnode.getNodes();

       Vector accordiondata=new Vector();
       String faqquestion="";
       String faqanswer="";
       javax.jcr.Node questNode=null;
       while(iternodes.hasNext()){
           javax.jcr.Node child=iternodes.nextNode();
           String restype=child.getProperty("sling:resourceType").getString();
           if(restype.equals("mcd/components/content/parsys/colctrl")){
             if(child.hasProperty("controlType")){
                 String coltype=child.getProperty("controlType").getString();
                 if(coltype.equals("break")||coltype.equals("end")){
                     if(!faqanswer.equals("")){
                       if(faqquestion.equals(""))faqquestion="No Title";
                       accordiondata.add(faqquestion+"|"+faqanswer );
                       if(questNode!=null){
                           questNode.remove();
                           questNode=null;
                       }
                       faqquestion="";
                       faqanswer="";
                       }
                 }
             }
           }
                     
           
           if(restype.equals("mcd/components/content/everything") ){
               if(!faqanswer.equals("")){
                   if(faqquestion.equals(""))faqquestion="No Title";
                   accordiondata.add(faqquestion+"|"+faqanswer );
                   if(questNode!=null){
                       questNode.remove();
                       questNode=null;
                   }
                   faqquestion="";
                   faqanswer="";
               }
               if(!child.hasProperty("text") && child.hasProperty("title")){
                   faqquestion=child.getProperty("title").getString();
                   questNode=child;  
               }
              
               
           }
           if(restype.equals("mcd/components/content/searchdmc")){
               String url=child.getProperty("documentURL").getString();
               String docname=child.getProperty("documentName").getString();
               docname=docname.replace('+',' ');
               docname=docname.replaceAll("%27","'");
               docname=docname.replace("%28","(");
               docname=docname.replace("%29",")");
               String docsize="";
               if(child.hasProperty("documentSize"))docsize=" ("+child.getProperty("documentSize").getString()+")";
               String dmclink="<a target=\"_blank\" href=\""+url+"\">"+docname+docsize+"</a>";
               faqanswer+=dmclink+"<br><br>";
               child.remove();
           }
          
        }//controltype       
       //create accordion
       javax.jcr.Node destPar=parnode.addNode("accordion_new","nt:unstructured");
       JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/accordion"); 
       JcrUtil.setProperty(destPar,"accordionId","accordion_new");
       JcrUtil.setProperty(destPar,"accordiandata",accordiondata.toArray(new String[0]));     
   
      }
      


%> 
<%
 
MigrationInfo mi=new MigrationInfo();

Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
String pmPage=slingRequest.getParameter("page");
String pmDest=slingRequest.getParameter("dest");
String pmNewHomePageName=slingRequest.getParameter("newhomepagename");
String linkroot=slingRequest.getParameter("linkroot"); 
String linktranslate=slingRequest.getParameter("linktranslate");
String pmDesign=slingRequest.getParameter("design");
String strLevels=slingRequest.getParameter("levels");
String topnav=slingRequest.getParameter("topnav");
String leftnav=slingRequest.getParameter("leftnav");
String dontprocess=slingRequest.getParameter("dontprocess");
String compare=slingRequest.getParameter("compare");
if(pmPage!=null && !pmPage.trim().equals("")){
    pmPage=pmPage.trim();
    mi.cq4page=pmPage;
    if(pmPage.indexOf(".html")>-1)pmPage=pmPage.substring(0,pmPage.indexOf(".html"));
    
    mi.cq5dest=pmDest; 
    if(pmNewHomePageName!=null && !pmNewHomePageName.equals("")){
        mi.cq5basepagename=pmNewHomePageName;
    }
    mi.session=session;
    if(strLevels!=null&&strLevels!=""){
    try{ 
        mi.processLevels=Integer.parseInt(strLevels);
    }catch(Exception e){
        //ignore - probably a number format exception -- defaults to 1 anyway
    }
    }
   // mi.cq5dest="/content/accessmcd/na/us/natl"; 
    
    if(topnav!=null)mi.addTopNav=true;
    if(leftnav!=null)mi.addLeftNav=true;
    if(dontprocess!=null)mi.process=false; 
    if(linkroot!=null)mi.linkroot=linkroot.trim();
    if(linktranslate!=null)mi.linktranslate=linktranslate.trim();
    
    mi.info("Starting migration");
    long starttime=System.currentTimeMillis();
    
    mi.destPage=session.getNode(pmPage); 
    Page newPage= pageManager.getPage(mi.cq4page);
    out.println(doMigration(session, pageManager, newPage, mi, 1));
    out.println("Processed <b>"+mi.processed+"</b> pages in <b>"+((System.currentTimeMillis()-starttime)/1000)+"</b>s.");
    mi.info("Processed "+mi.processed+" pages in "+((System.currentTimeMillis()-starttime)/1000)+"s.");
    }else if(compare!=null && !compare.trim().equals("")){
    String page1=slingRequest.getParameter("page1");
    String page2=slingRequest.getParameter("page2");
    %>
    <FRAMESET rows="350, 350">
      <FRAME id="frame1" src='<%=page1%>'>
      <FRAME id="frame2" src='<%=page2%>'>
    </FRAMESET>
    <%
    }else{
        //show form 
    %>
    <body>
    <h3>CQ5 Content Migration Utility</h3>
    <form action="" method="GET">
    <b>Root CQ4 Page:</b><input name="page" size=80 value="/content/accessmcd/apmea/au"><br>
 
    <b>CQ5 Destination (Parent) Page:</b><input name="dest" size=80 value="/content/accessmcd/test/migration/au" /><br>
    <b>New Homepage Name:</b><input name="newhomepagename" size=40 value="" /><br>
    <b>Link translation root:</b><input name="linkroot" size=40 value="" /><br>
    <b>New translation location:</b><input name="linktranslate" size=40 value="" /><br>
    <!--b>Design:</b><input name="design" size=80 value="/etc/designs/mcd/accessmcd/g2g/g2g_blue" /><br-->
    <!--b>Include Top Nav:</b><input name="topnav" type="checkbox" /><br-->
    <!--b>Include Left Nav:</b><input name="leftnav" type="checkbox" /><br-->
    <b>Depth:</b><input name="levels" size=10 value="1"><br>
    <b>Don't Process:</b><input name="dontprocess" type="checkbox" /><br>
    <input type=submit value="Migrate">
    </form>
    
<br>
<br>

</body>
<%
}
%>  