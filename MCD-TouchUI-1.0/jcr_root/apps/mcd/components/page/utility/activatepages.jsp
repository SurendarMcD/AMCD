<%--
/* 
Utility to activate a list of pages
*/
--%>

<%@ page import="java.util.Calendar,
        java.text.*,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        java.sql.*,
        java.net.*,
        javax.sql.DataSource,
        com.day.commons.datasource.poolservice.DataSourcePool,
        org.apache.jackrabbit.commons.JcrUtils,
        org.apache.commons.lang.StringEscapeUtils,  
        com.day.cq.replication.*,
        com.day.cq.replication.ReplicationActionType
        
        "%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<%!

 public String activatePage(javax.jcr.Session session, Replicator replicator,String page){
        if(!page.startsWith("/content")){
            page="/content" + page;
        }
        try{
            javax.jcr.Node node=session.getNode(page+"/jcr:content");
            if(node!=null){
                if (node.hasProperty("cq:lastReplicated")){
                    java.util.Calendar lastReplicated=node.getProperty("cq:lastReplicated").getDate();
                    java.util.Calendar cal = Calendar.getInstance();
                    //don't activate if activated in last day
                    cal.add(Calendar.DAY_OF_YEAR,-1);
                    //cal.set(2014, 0, 30, 21, 0);
                    SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
                    if(cal.compareTo(lastReplicated)>0){
                        replicator.replicate(session, ReplicationActionType.ACTIVATE, page); 
                        return "<br>Activated "+page;
                    }else{
                        return "<br><font color=red>Page recently replicated: "+page+" on "+simpleFormat.format(lastReplicated.getTime())+"</font>";
                    }
                 }
            }else{
                return "<br><font color=red>Page does not exist: "+page+"</font>";
            }
        }
        catch(Exception e){
            return "Error "+e.getMessage()+" activating "+page;
        }
        return "<br><font color=red>Page not activated: "+page+"</font>";
        
 }
  
 
%>
<head> 
<title>Page Activator</title>
</head>
<body>
Page Activation Utility (enter pages in code)
<%
com.day.cq.replication.Replicator repl = sling.getService(com.day.cq.replication.Replicator.class);
org.apache.sling.jcr.api.SlingRepository repository = sling.getService(org.apache.sling.jcr.api.SlingRepository.class);
javax.jcr.Session sess = repository.loginAdministrative(null);

String[] urls={
"/content/accessmcd/corp/services_support/rewardsandrecognition/en/getting_started/defining_rewards_vs_recognition",
"/content/accessmcd/corp/services_support/rewardsandrecognition/en/why_it_works/program_essentials_and_measurement",
"/content/accessmcd/corp/services_support/rewardsandrecognition/en/getting_started/for_country_and_aow_staff"



};

for(int i=0;i<urls.length;i++){
    String urltoactivate=urls[i];
    out.println(activatePage(sess,repl,urltoactivate));
}
%>





<%--

--%>
 






<%
if(sess!=null)sess.logout();
%>
</body>