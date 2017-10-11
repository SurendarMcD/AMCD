 <%--
  ==============================================================================
  Migration Utility
  
  Erik Wannebo 10/22/2010
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
                com.mcd.accessmcd.cq.migration.util.*
                "
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%
%><%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %><%
%><%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%
%><cq:defineObjects /> 
<script language=Javascript> 
function iframecompare(page1,page2){
    document.getElementById("frame1").src=page1;
    document.getElementById("frame2").src=page2;
    
}
</script>

<%!  
    
    public String addMsg(String addmsg){
         return addmsg+"<BR>";
    }
    
    public String addErrMsg(String addmsg){
         return "<font color=red>"+addmsg+"</font><BR>";
    }
     public String doMigration(Session session,MigrationInfo mi,int currentLevel){
        
        String retMsg="";
        mi.currentLevel=currentLevel;
        retMsg+=processCQ4Page(session,mi);
        String newCQ5page=mi.cq5dest+"/"+mi.cq5basepagename;
        if(currentLevel<mi.processLevels){
           //new destination will be last cq5 parent
           //get children of current page
           Document doc=null;
           try{
               byte[] xmlbytes=Util.getCQ4Content(mi,".showxml.html?showchildren=y",null);
               String xml=new String(xmlbytes,"UTF-8");
               doc=getDocument(xml);
           }catch(Exception e){
           }
           if(doc!=null){
                //iterate through children
                NodeList childnodes= doc.getElementsByTagName("child");
                //retMsg+="childnodes length:"+childnodes.getLength();
                for(int c=0;c<childnodes.getLength();c++){
                    Element childElem=(Element)childnodes.item(c);
                    String childhandle=Util.getCharacterDataFromElement(childElem);
                    mi.cq4page=childhandle;
                    /*
                    if( !childhandle.contains("recount")
                    && !childhandle.contains("gaptracker")
                    && !childhandle.contains("extdhrsextfiles")
                    && !childhandle.contains("newhmsalestool")
                    && !childhandle.contains("cbbinitiativenl")
                    ){
                    */
                    if(true){
                        mi.cq5dest=newCQ5page;
                        retMsg+="mi.cq4page:"+mi.cq4page;
                        retMsg+=doMigration(session,mi,currentLevel+1);
                    }else{
                        mi.info("Skipping page:"+childhandle);
                    }
                }
           }else{
               retMsg+="doc is null";
           } 
          } 
        
        return retMsg;
     }
     public String processCQ4Page(Session session,MigrationInfo mi){
      
        String retMsg="";
     
        Document doc=null;
        retMsg+=addMsg("Processing page:"+mi.cq4page);
        mi.info("Processing CQ4 page:"+mi.cq4page);
        if(mi.fix)mi.fixed=false;
        mi.fixpar=0;
        try{
            //byte[] xmlbytes=getCQ4Content("http://mcdeagsun107a.mcd.com:4205/libs/templaters/content/ldapservice.migratecq5.html?PAGE="+cq4page,null);
            byte[] xmlbytes=Util.getCQ4Content(mi,".showxml.html",null);
            String xml=new String(xmlbytes,"UTF-8");
            doc=getDocument(xml);
            if(doc==null)retMsg+="doc is null";
            String srcPath=mi.cq4page.substring(0,mi.cq4page.lastIndexOf("/")+1); 
            String srcPageName=mi.cq4page.substring(mi.cq4page.lastIndexOf("/")+1); 
            String cq5srcPageName=srcPageName;
            if(mi.currentLevel==1 && !mi.cq5basepagename.equals(""))cq5srcPageName=mi.cq5basepagename;   
            mi.cq5basepagename=cq5srcPageName;
            //retMsg+=addMsg("Source page: <a href='"+mi.cq4server+mi.cq4page+".html'>"+mi.cq4server+mi.cq4page+".html</a>"); 
            retMsg+=addMsg("Source page: <a href=\"javascript:void(window.open('"+mi.cq4domain+mi.cq4page+".html'))\">"+mi.cq4domain+mi.cq4page+".html</a>");
            //retMsg+=addMsg("<a href=\"javascript:void(parent.frame1.location='"+mi.cq4server+mi.cq4page+".html')\">Load in top frame</a>");
            retMsg+=addMsg("Destination page <a target='_new' href='"+mi.cq5dest+"/"+cq5srcPageName+".html'>"+mi.cq5dest+"/"+cq5srcPageName+".html</a>");
            //retMsg+=addMsg("<a href=\"javascript:void(parent.frame2.location='"+mi.cq5dest+"/"+srcPageName+".html')\">Load in middle frame</a>");
            //retMsg+=addMsg("Source page: <a href=\"javascript:void(parent.frame1.location='"+mi.cq4server+mi.cq4page+".html';parent.frame2.location='http://mcdeagsun107a.mcd.com:4214"+mi.cq5dest+"/"+srcPageName+".html';)\">COMPARE</a>",false);
            //if(mi.process)retMsg+=addMsg("<a target='_new' href='?compare=y&page1="+mi.cq4domain+mi.cq4page+".html"+"&page2=https://author-.accessmcd.com"+mi.cq5dest+"/"+cq5srcPageName+".html'>Compare</a>");
            if(mi.process)retMsg+=addMsg("<a target='_new' href='?compare=y&page1="+mi.cq4domain+mi.cq4page+".html"+"&page2="+mi.cq5dest+"/"+cq5srcPageName+".html'>Compare</a>");
            //retMsg+=addMsg("Destination page:"+mi.cq5dest+"/"+srcPageName);
            
            
            mi.destPage=Util.getCQ5Page(session, mi.cq5dest,cq5srcPageName,mi.process);
            if(mi.process){    
                if(mi.destPage==null){
                    retMsg+=addErrMsg("Couldn't get destination page.");
                    return retMsg;
                }
                
            }
            if(mi.process || !mi.fixed) mi.destPage=session.getNode(mi.cq5dest+"/"+cq5srcPageName+"/jcr:content");
            if(mi.currentLevel==1){
                mi.cq4siteroot=mi.cq4page+"/";
                mi.cq5siteroot=mi.cq5dest+"/"+cq5srcPageName+"/";
            }
            //mi.info("migration.jsp cq5siteroot:"+mi.cq5siteroot);
            String template="";
            String redirectlink="";
            NodeList contentnodes = doc.getElementsByTagName("content");
            if(contentnodes.getLength()>0){
                Element contentelem=(Element)contentnodes.item(0);
                if(mi.process)retMsg+=addMsg(Util.addPageProperties(mi,contentelem));
                template=Util.getChildNodeText(contentelem,"Template");
                redirectlink=Util.getChildNodeText(contentelem,"RedirectLink");
                mi.template=template;
            }  
             
            if(template.equals("/apps/starter_kit/templates/super_template") ||
            template.equals("/apps/starter_kit/templates/super_template_with_sidebar_template")){
                SuperTemplate st=new SuperTemplate(); 
                st.process(doc,mi);
            }else if(template.equals("/apps/starter_kit/templates/two_column_template") ||
            template.equals("/apps/starter_kit/templates/alternate_two_column_template") ||
            template.equals("/apps/starter_kit/templates/two_column_with_sidebar_template") ||
            template.equals("/apps/starter_kit/templates/alternate_reverse_two_column_template") ||
            template.equals("/apps/starter_kit/templates/three_column_template") ||
            template.equals("/apps/wmi/templates/sma_homepage") ||
            template.equals("/apps/wmi_new/templates/Homepage")
            ){
                TwoColTemplate tct=new TwoColTemplate();
                tct.process(doc,mi);
            }else if (template.equals("/apps/starter_kit/templates/one_column_template")){
                TwoColTemplate tct=new TwoColTemplate();
                tct.process(doc,mi);
            }else if (template.equals("/apps/starter_kit/templates/redirect_template")){
                //just add the redirect page property
                retMsg+=addMsg("cq4 redirect:"+redirectlink+"<br>");
                retMsg+=addMsg("mi.cq4siteroot:"+mi.cq4siteroot+"<br>");
                retMsg+=addMsg("mi.cq5siteroot:"+mi.cq5siteroot+"<br>");
                redirectlink=Util.fixLinks(redirectlink,mi);
                retMsg+=addMsg("cq5 redirect:"+redirectlink+"<br>");
                if(mi.process)JcrUtil.setProperty(mi.destPage,"redirectTarget",redirectlink);
            }else if (template.equals("/apps/starter_kit/templates/email_form_template")){
                EmailFormTemplate eft=new EmailFormTemplate();
                eft.process(doc,mi);
            }else if (template.equals("/apps/starter_kit/templates/redirect_fileattach_template")){
                TwoColTemplate tct=new TwoColTemplate();
                tct.process(doc,mi); 
            }else if (template.equals("/apps/starter_kit/templates/node_list_template")){
                //TODO: Node List Template
                NodeListTemplate nlt=new NodeListTemplate();
                nlt.process(doc,mi);     
                //retMsg+=addErrMsg("Template not found:"+template);
            }
            else{
                retMsg+=addErrMsg("Template not found:"+template);
                mi.error(mi.cq4page+" : Template not found:"+template);
            }
            
            if(mi.process || mi.fixsave){
                session.save();
                mi.fixsave=false;
            }
            mi.processed++;
         }catch(Exception e){
             retMsg+=addErrMsg("Exception:"+e.getMessage());
         }
         
         return retMsg;
      }
        
    public Document getDocument(String xml)
      {
        Document doc=null;
        try {
        DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
         doc = builder.parse(new InputSource(new StringReader(xml.trim())));
        } catch(Exception e) {
          e.printStackTrace();
        }
        return doc;
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
String fix=slingRequest.getParameter("fix");
String compare=slingRequest.getParameter("compare");
if(pmPage!=null && !pmPage.trim().equals("")){
    pmPage=pmPage.trim();
    //mi.cq4page=pmPage;
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
    if(fix!=null)mi.fix=true;
    if(linkroot!=null)mi.linkroot=linkroot.trim();
    if(linktranslate!=null)mi.linktranslate=linktranslate.trim();
    mi.cq4supwd="superuser";
    if(pmPage.startsWith("https://prodp.mcdexchange.com/")){
        mi.cq4server="http://mcdeagsun113b.mcd.com:4206";
        mi.cq4page=pmPage.replaceAll("https://prodp.mcdexchange.com/","/");
        mi.cq4domain="https://prodp.mcdexchange.com";
        /*
        g2g & us styles 
        mainTitle 32px
        siteTitle 28px
        sectionTitle 24px
        sectionSubTitle 20px
        paragraphTitle 16px
        */  
        
        /* us styles */
        /*  */
        mi.titlestyles.put("siteTitle","sectionSubTitle"); //20px
        mi.titlestyles.put("mainTitle","sectionSubTitle"); //18px
        mi.titlestyles.put("sectionTitle","paragraphTitle");//16px
        mi.titlestyles.put("sectionSubtitle","paragraphTitle"); //15px
        mi.titlestyles.put("paraTitle","paragraphTitle");//13px
    }
    if(pmPage.startsWith("https://www.mcdexchange.com/")){
        mi.cq4server="http://mcdeagsun106b.mcd.com:4205";
        mi.cq4page=pmPage.replaceAll("https://www.mcdexchange.com/","/");
        mi.cq4domain="https://www.mcdexchange.com";

        mi.titlestyles.put("siteTitle","sectionSubTitle"); //20px
        mi.titlestyles.put("mainTitle","sectionSubTitle"); //18px
        mi.titlestyles.put("sectionTitle","paragraphTitle");//16px
        mi.titlestyles.put("sectionSubtitle","paragraphTitle"); //15px
        mi.titlestyles.put("paraTitle","paragraphTitle");//13px
        mi.cq4supwd="homemac";
    }
    if(pmPage.startsWith("https://intl.mcdexchange.com/")){
        //mi.cq4server="http://mcdeagsun113b.mcd.com:4208";
        mi.cq4page=pmPage.replaceAll("https://intl.mcdexchange.com/","/");
        mi.cq4server="http://mcdeagsun113b.mcd.com:4208";
        mi.cq4domain="https://intl.mcdexchange.com";
        //europe styles
        mi.titlestyles.put("mainTitle","sectionSubTitle"); //18px
        mi.titlestyles.put("siteTitle","sectionSubTitle"); //18px
        mi.titlestyles.put("sectionTitle","paragraphTitle");//16px
        mi.titlestyles.put("sectionSubtitle","paragraphTitle"); //11px
        mi.titlestyles.put("paraTitle","paragraphTitle");//14px
    }
    if(pmPage.startsWith("https://mcweb.mcdexchange.com/")){
        mi.cq4server="http://mcdeagsun113b.mcd.com:4208";
        mi.cq4domain="https://mcweb.mcdexchange.com";
        mi.cq4page=pmPage.replaceAll("https://mcweb.mcdexchange.com/","/");
        mi.titlestyles.put("siteTitle","paragraphTitle"); //20px
        mi.titlestyles.put("mainTitle","sectionSubTitle"); //18px
        mi.titlestyles.put("sectionTitle","paragraphTitle");//16px
        mi.titlestyles.put("sectionSubtitle","paragraphTitle"); //15px
        mi.titlestyles.put("paraTitle","paragraphTitle");//13px
    }
    if(pmPage.startsWith("https://wmi.accessmcd.com/")){
        mi.cq4server="http://mcdeagsun113b.mcd.com:4210";
        mi.cq4domain="https://wmi.accessmcd.com";
        mi.cq4page=pmPage.replaceAll("https://wmi.accessmcd.com/","/");
        mi.titlestyles.put("mainTitle","sectionSubTitle"); //18px
        mi.titlestyles.put("siteTitle","sectionSubTitle"); //18px
        mi.titlestyles.put("sectionTitle","paragraphTitle");//16px
        mi.titlestyles.put("sectionSubtitle","paragraphTitle"); //11px
        mi.titlestyles.put("paraTitle","paragraphTitle");//14px
    }   
   
    

    if(pmPage.startsWith("https://intl.mcdexchange.com/mcdonalds/franchiseemcd"))pmDesign="/etc/designs/mcd/accessmcd/g2g/ca_g2g_olive";
    
    mi.design=pmDesign;    
     
    //update log page
    /*
    getCQ5Page(session, mi.cq5dest,"migrationlog");
    javax.jcr.Node migrationlog = session.getNode(mi.cq5dest+"/migrationlog/jcr:content");
    String migrationlogpage=mi.cq5dest+"/migrationlog.html";
    JcrUtil.setProperty(migrationlog,"jcr:title","Migration Log");
    JcrUtil.setProperty(migrationlog,"cq:template","/apps/mcd/templates/g2g");
    JcrUtil.setProperty(migrationlog,"sling:resourceType","mcd/components/page/g2g"); 
    
    JcrUtil.setProperty(migrationlog,"authorName","admin"); 
    JcrUtil.setProperty(migrationlog,"authorEmail","admin");
    java.util.Calendar nowDate=java.util.Calendar.getInstance();
    JcrUtil.setProperty(migrationlog,"cq:lastModified",nowDate);
    
    String migrationresults=doMigration(session, mi, 1);
    
    javax.jcr.Node maincontentpara=null;
    if(migrationlog.hasNode("maincontentpara")){
        maincontentpara=migrationlog.getNode("maincontentpara");
    }else{
        maincontentpara=migrationlog.addNode("maincontentpara","nt:unstructured");
       } 
    JcrUtil.setProperty(maincontentpara,"sling:resourceType","foundation/components/parsys");
    
    com.mcd.accessmcd.cq.migration.paragraphs.MergePara.createEverythingContent(maincontentpara,migrationresults);
    
    session.save();
    */
    mi.info("Starting migration");
    long starttime=System.currentTimeMillis();
    out.println(doMigration(session, mi, 1));
    out.println("Processed <b>"+mi.processed+"</b> pages in <b>"+((System.currentTimeMillis()-starttime)/1000)+"</b>s.");
    mi.info("Processed "+mi.processed+" pages in "+((System.currentTimeMillis()-starttime)/1000)+"s.");
    }else if(compare!=null && !compare.trim().equals("")){
    String page1=slingRequest.getParameter("page1");
    String page2=slingRequest.getParameter("page2");
    %>
    <FRAMESET rows="350, 350">
      <FRAME name="frame1" src='<%=page1%>'>
      <FRAME name="frame2" src='<%=page2%>'>
    </FRAMESET>
    <%
    }else{
        //show form
    %>
    <body>
    <h3>CQ4 Content Migration Utility</h3>
    <form action="" method="GET">
    <b>Root CQ4 Page:</b><input name="page" size=120><br>
 
    <b>CQ5 Destination (Parent) Page:</b><input name="dest" size=80 value="/content/accessmcd/corp/marketing/magic" /><br>
    <b>New Homepage Name:</b><input name="newhomepagename" size=40 value="" /><br>
    <b>Link translation root:</b><input name="linkroot" size=40 value="" /><br>
    <b>New translation location:</b><input name="linktranslate" size=40 value="" /><br>
    <!--b>Design:</b><input name="design" size=80 value="/etc/designs/mcd/accessmcd/g2g/g2g_blue" /><br-->
    <!--b>Include Top Nav:</b><input name="topnav" type="checkbox" /><br-->
    <!--b>Include Left Nav:</b><input name="leftnav" type="checkbox" /><br-->
    <b>Depth:</b><input name="levels" size=10 value="1"><br>
    <b>Don't Process:</b><input name="dontprocess" type="checkbox" checked="true" /><br>
    <b>Fix:</b><input name="fix" type="checkbox" /><br>
    <input type=submit value="Migrate">
    </form> 
    
<br>
<br>
<b>Caveats:</b><br>
<ul>
<li>General Layout/Appearance issues
<ul>
<li>wider pages/images squished/truncated</li>
<li>limited color palette</li>
<li>different sizes between original and G2G title classes</li>
</ul>
</li>
<li>Biggest conversion problem: download files embedded in text
<ul>
<li>currently added as separate Download components below Everything, with links to Download</li>
</ul>
</li>
<li>Absolute links (prodp.mcdexchange,etc) in content updated/replaced with relative links for pages which are part of the migration. Absolute links to external sites are not changed.</li>
<li>not all templates/paragraphs implemented/debugged yet
<ul>
<li>webdoc paragraph - HTML content placed into an Everything component - editability may vary</li>
<li>site map template (? - there is a SiteMap component in CQ5)</li>
<li>custom site templates</li>
</ul>
</li>
</ul>
<%--
<FRAMESET rows="250, 250,250">
      <FRAME name="frame1">
      <FRAME name="frame2">
      <FRAME name="frame3" src='<%=migrationlogpage%>'>
</FRAMESET>
--%> 
</body>
<%
}
%>