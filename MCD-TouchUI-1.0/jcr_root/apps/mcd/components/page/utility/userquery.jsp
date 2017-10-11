<%/*
Lists recently updated files
Erik Wannebo 11/22/2010
*/
%>
<%@ page import="java.util.Calendar,  
        java.text.SimpleDateFormat,
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
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
        javax.naming.Context,
        javax.naming.NamingEnumeration,
        javax.naming.directory.Attribute,
        javax.naming.directory.Attributes,
        javax.naming.directory.DirContext,
        javax.naming.directory.InitialDirContext,
        javax.naming.directory.SearchControls,
        javax.naming.directory.SearchResult,
        java.util.regex.*;
"%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<HTML>
<head>
<script language='javascript'>
function openInCRXDE(path){
window.open("/crxde/#/crx.default/jcr%3aroot"+path);
}
</script>
</head>
<body style="font-family:arial">
<h2>Content Query</h2>
 
<%!
 
public static void doSearchNew(JspWriter out,String searchpath,String searchtype,String lastModifiedField,QueryBuilder builder,ResourceResolver resourceResolver){
long daysecs=24*60*60*1000;
SimpleDateFormat xpathdate =new SimpleDateFormat("yyyy-MM-dd");
try{ 
    String query="/jcr:root/home//*[ @jcr:primaryType='rep:User' and";
    String startdate=xpathdate.format((new Date()).getTime())+"T00:00:00.000Z";
    query+=" @"+lastModifiedField+" > xs:dateTime('"+startdate+"') ] order by @"+lastModifiedField+" descending";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    out.write(query+"<br>");
    SimpleDateFormat sfModified=new SimpleDateFormat("MM.dd.yyyy hh:mm a");
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>File</b></td><td><b>E-mail</b></td><td><b>Last Modified</b></td></thead>");
    Calendar lastLastModified=Calendar.getInstance();
    int count=0;
    while(result.hasNext()) { 
            if(count>10)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String path = n.getPath();
                String outpath="";
                
                outpath+="<a target=_new href=\""+path+".html\">"+path+"</a>";
                
                Calendar lastModified=n.getProperty(lastModifiedField).getDate();
                //if(System.currentTimeMillis()-lastModified.getTimeInMillis()>(3*24*60*60*1000)){
                    String modifiedTime=sfModified.format(lastModified.getTime());
                    String email=n.getProperty("rep:e-mail").getString();
                    String role=n.getProperty("rep:role").getString();
                    String company=n.getProperty("CompanyType").getString();
                    out.write("<tr>");
                    String cellstyle="";
                    
                   
                    out.write("<td"+cellstyle+">"+outpath+"</td>");
                    out.write("<td"+cellstyle+">"+email+"</td>");
                    out.write("<td"+cellstyle+">"+modifiedTime+"</td>");
                    out.write("</tr>");
              // }
                
            }
    }
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}    

public static void checkLastSynch(JspWriter out,ArrayList arUsers,QueryBuilder builder,ResourceResolver resourceResolver){
long daysecs=24*60*60*1000;
SimpleDateFormat xpathdate =new SimpleDateFormat("yyyy-MM-dd");
long nsync=0;
int count=0;
String eid="";
try{ 
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>EID</b><td><b>DN</b></td><td><b>Location</b></td><td><b>Role</b></td><td><b>Company</b></td><td><b>Last Synched</b></td>");
    out.write("<td><b>LDAP DN</b></td><td><b>LDAP Name</b></td><td><b>LDAP Location</b></td><td><b>LDAP Role</b></td><td><b>LDAP Company</b></td></thead>");
    Iterator iterUsers=arUsers.iterator();
    
    while(iterUsers.hasNext() && count<10000){
        eid=(String)iterUsers.next();
        String query="/jcr:root/home/users//*[ @jcr:primaryType='rep:User' and jcr:contains(., '"+eid+"') ]";
        Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
        //out.write(query+"<br>");
        SimpleDateFormat sfModified=new SimpleDateFormat("MM.dd.yyyy hh:mm a");
        Calendar lastLastModified=Calendar.getInstance();
        
         //out.write("<tr>"+lookupUser(eid)+"</tr>"); 
         while(result.hasNext()) { 
                //if(count>10)break; 
                
                Resource r=(Resource)result.next();
                javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
                if (n != null) {
                    String path = n.getPath();
                    String outpath="";
                    
                    outpath+="<a target=_new href=\""+path+".html\">"+path+"</a>";
                    
                    
                    Calendar lastModified=null;
                    
                    Property prop=null;
                    try{
                        prop=n.getProperty("rep:lastsynced");
                    }catch(Exception e){};
                    if(prop!=null){
                            lastModified=prop.getDate();
                        }else{
                            lastModified=Calendar.getInstance();
                        }
                        
                   if(System.currentTimeMillis()-lastModified.getTimeInMillis()>(3*24*60*60*1000)){
                        String modifiedTime=sfModified.format(lastModified.getTime());
                        
                        String dn="";
                        prop=n.getProperty("rep:principalName");
                        if(prop!=null)dn=prop.getString();
                        String location="";
                        prop=n.getProperty("rep:location");
                        if(prop!=null)location=prop.getString();
                        String role="";
                        prop=n.getProperty("rep:role");
                        if(prop!=null)role=prop.getString();
                        String company="";
                        prop=n.getProperty("CompanyType");
                        if(prop!=null)company=prop.getString();
                        out.write("<tr>");
                        String cellstyle="";
                        
                       
                        //out.write("<td"+cellstyle+">"+outpath+"</td>");
                        out.write("<td"+cellstyle+">"+eid+"</td>");
                        out.write("<td"+cellstyle+">"+dn+"</td>");
                        out.write("<td"+cellstyle+">"+location+"</td>");
                        out.write("<td"+cellstyle+">"+role+"</td>");
                        out.write("<td"+cellstyle+">"+company+"</td>");
                        out.write("<td"+cellstyle+">"+modifiedTime+"</td>");
                        out.write(lookupUser(eid));
                        out.write("</tr>");
                        
                    }else{
                        nsync++;
                    }
                }
         }
         count++;
    }
    out.write("Total:"+arUsers.size()+"In Synch:"+nsync); 
  }catch(Exception e){
      try{
          out.println(count+":"+eid+":"+e.getMessage());
          //e.printStackTrace(out);
      }catch(Exception ex){
      }
  }
  
   
}   


 public static String lookupUsers(ArrayList arUsers,boolean bDetails){
 
   
    Hashtable<String, String> env = new Hashtable<String, String>();
     //PROD
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
    env.put(Context.PROVIDER_URL, "ldap://66.111.144.237:3268/DC=pri");
    env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,CN=Users,DC=narest,DC=pri"); 
    env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
    
    /*
    // STG
    env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
    env.put(Context.PROVIDER_URL, "ldap://66.111.145.9:3268/DC=pri");
    env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,OU=Service Accounts,OU=US,DC=labnarestmgmt,DC=pri");
    env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
    */
     
     StringBuffer sbReturn=new StringBuffer();
     Iterator iterUsers=arUsers.iterator();
     int count=0;
     SimpleDateFormat sf=new SimpleDateFormat("MM_dd_yyyy_H_mm_ss");
     String baseFileName="/tmp/authorusers"+sf.format((new Date()).getTime())+".csv";
     DataOutputStream os=null; 
     String outputfile=baseFileName;
     try{
         DirContext ctx = new InitialDirContext(env);
         
         FileOutputStream fstream = new FileOutputStream(outputfile);    

         os = new DataOutputStream(fstream);
         BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(os));
     
            while(iterUsers.hasNext() && count<100000){
                String eid=(String)iterUsers.next();
                if(bDetails){
                    //sbReturn.append("<tr><td>"+eid+"</td>"+lookupStoreUser(eid)+"</tr>");
                    lookupStoreUser(eid,bw,ctx);
                }
                count++;
            }
             bw.close();
             os.close();
             fstream.close();

        }catch (Exception e){//Catch exception if any
          System.err.println("Error: " + e.getMessage());
        }finally{
            try{
                if(os!=null)os.close();
            }catch(IOException ioe){
                //OK
            }
        }  
     return "<tr><td>"+count+" users</td></tr>"+sbReturn.toString();
 
 
 
 }


 public static String lookupStoreUser( String eid, BufferedWriter bw,DirContext ctx){
        
        String principalname="";
        String msg="";
        try
        {
            
            String searchFilter = "(samAccountName=" + eid.trim() + "*)";
           
            SearchControls scon = new SearchControls();
           
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);
            
            int count=0;
            while (answer.hasMore() && count<100)
            {
                SearchResult sr = (SearchResult) answer.next();

                if (sr == null)
                {
                    msg="SearchResult is null...continuing";
                    continue;
                }
                Attributes attrs = sr.getAttributes();
                if (attrs == null)
                {
                    msg="SR attributes is null...continuing";
                    continue;
                }
                String displayname="";
                String location="";
                String role="";
                String company="";
                String st="";
                Attribute attr = attrs.get("displayName");
                if (attr != null)
                {
                    displayname= (String) attr.get(0);
                    
                    
                }
                attr = attrs.get("l");
                if (attr != null)
                {
                    location= (String) attr.get(0);
                    
                    
                }
                attr = attrs.get("personalTitle");
                if (attr != null)
                {
                    role= (String) attr.get(0);
                    
                }
                attr = attrs.get("primaryTelexNumber");
                if (attr != null)
                {
                    company= (String) attr.get(0);
                    
                }
                attr = attrs.get("st");
                if (attr != null)
                {
                    st= (String) attr.get(0);
                    
                }
                msg+="<td>"+st+"</td><td>"+displayname+"</td><td>"+location+"</td><td>"+role+"</td><td>"+company+"</td>";
                bw.write(eid+","+st+",\""+location+"\","+role+",\""+displayname+"\",\""+company+"\"\n");
                count++;
            }

        }
        catch (Exception ex)
        {
            msg=" exception occured" + ex.getMessage();
        }
        
        
        return msg;
        
  }



 public static String lookupUser( String eid){

        
        String msg="";
        Hashtable<String, String> env = new Hashtable<String, String>();
         //PROD
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://66.111.144.237:3268/DC=pri");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,CN=Users,DC=narest,DC=pri"); 
        env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
        
        /*
        // STG
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://66.111.145.9:3268/DC=pri");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,OU=Service Accounts,OU=US,DC=labnarestmgmt,DC=pri");
        env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
        */
        String principalname="";
        
        try
        {
            DirContext ctx = new InitialDirContext(env);
            String searchFilter = "(samAccountName=" + eid.trim() + "*)";
           
            SearchControls scon = new SearchControls();
           
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);
            
            int count=0;
            while (answer.hasMore() && count<100)
            {
                SearchResult sr = (SearchResult) answer.next();

                if (sr == null)
                {
                    msg="SearchResult is null...continuing";
                    continue;
                }
                Attributes attrs = sr.getAttributes();
                if (attrs == null)
                {
                    msg="SR attributes is null...continuing";
                    continue;
                }
                String displayname="";
                String location="";
                String role="";
                String company="";
                String dn="";
                Attribute attr = attrs.get("displayName");
                if (attr != null)
                {
                    displayname= (String) attr.get(0);
                    
                    
                }
                attr = attrs.get("l");
                if (attr != null)
                {
                    location= (String) attr.get(0);
                    
                    
                }
                attr = attrs.get("personalTitle");
                if (attr != null)
                {
                    role= (String) attr.get(0);
                    
                }
                attr = attrs.get("primaryTelexNumber");
                if (attr != null)
                {
                    company= (String) attr.get(0);
                    
                }
                attr = attrs.get("distinguishedName");
                if (attr != null)
                {
                    dn= (String) attr.get(0);
                    
                }
                msg+="<td>"+dn+"</td><td>"+displayname+"</td><td>"+location+"</td><td>"+role+"</td><td>"+company+"</td>";
                count++;
            }

        }
        catch (Exception ex)
        {
            msg=" exception occured" + ex.getMessage();
        }
        
        
        return msg;
        
  }
  
  private ArrayList getTimingLogUsers(String baseFileName,String date){
 

        HashMap users=new HashMap();
        
        SimpleDateFormat sf=new SimpleDateFormat("MM/dd/yyyy H:mm:ss");
        SimpleDateFormat sfparm=new SimpleDateFormat("MM/dd/yyyy");
        
        String logEntryPattern = "^(\\d+\\/\\d+\\/\\d+ \\d+:\\d+:\\d+) Timing: ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)";
        //String logEntryPattern = "^("+date+" \\d+:\\d+:\\d+) Timing: ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)";
        Pattern p = Pattern.compile(logEntryPattern);
        DataInputStream in=null; 
        int filecount=-1;
        boolean bPassedDate=false;
        boolean bFoundDate=false;
        try{
         Date dtParm=sfparm.parse(date);
         while(!bPassedDate&&filecount<20){
                if(bFoundDate){
                    bPassedDate=true;
                    bFoundDate=false;
                }
                String requestlogfile=baseFileName+((filecount==-1)?"":"."+filecount);
                FileInputStream fstream = new FileInputStream(requestlogfile);    

                in = new DataInputStream(fstream);
                BufferedReader br = new BufferedReader(new InputStreamReader(in));
                String strLine;
                long localtime=System.currentTimeMillis();
                long timezoneoffset=(TimeZone.getTimeZone("America/Chicago").getOffset(localtime));
                while (((strLine=br.readLine())!=null))   {
                    Matcher matcher = p.matcher(strLine);
                    
                    
                    if(matcher.find() &&   matcher.group(6).equals("ms")){
                            String logdatestr=matcher.group(0);
                            Date logdate=sf.parse(logdatestr);
                            if(logdate.after(dtParm)){
                                if(!bFoundDate)bFoundDate=true;
                                bPassedDate=false;        
                                String eid=matcher.group(4);
                                eid=eid.substring(0,eid.indexOf("_"));
                                users.put(eid,"1");
                             }
                      }
                  }
                 br.close();
                 in.close();
                 fstream.close();
                 filecount++;
             }
            }catch (Exception e){//Catch exception if any
              System.err.println("Error: " + e.getMessage());
            }finally{
                try{
                    if(in!=null)in.close();
                }catch(IOException ioe){
                    //OK
                }
            }  
            return new ArrayList(users.keySet());
    }
    
     private ArrayList write(String baseFileName,String date){
 

        HashMap users=new HashMap();
        SimpleDateFormat sf=new SimpleDateFormat("MM/dd/yyyy H:mm:ss");
        //String logEntryPattern = "^(\\d+\\/\\d+\\/\\d+ \\d+:\\d+:\\d+) Timing: ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)";
        String logEntryPattern = "^("+date+" \\d+:\\d+:\\d+) Timing: ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)";
        Pattern p = Pattern.compile(logEntryPattern);
        DataInputStream in=null; 
        int filecount=-1;
        boolean bPassedDate=false;
        boolean bFoundDate=false;
        try{
         while(!bPassedDate&&filecount<20){
                if(bFoundDate){
                    bPassedDate=true;
                    bFoundDate=false;
                }
                String requestlogfile=baseFileName+((filecount==-1)?"":"."+filecount);
                FileInputStream fstream = new FileInputStream(requestlogfile);    

                in = new DataInputStream(fstream);
                BufferedReader br = new BufferedReader(new InputStreamReader(in));
                String strLine;
                long localtime=System.currentTimeMillis();
                long timezoneoffset=(TimeZone.getTimeZone("America/Chicago").getOffset(localtime));
                while (((strLine=br.readLine())!=null))   {
                    Matcher matcher = p.matcher(strLine);
                    if(matcher.find() && matcher.group(6).equals("ms")){
                            if(!bFoundDate)bFoundDate=true;
                            bPassedDate=false;        
                            String eid=matcher.group(4);
                            eid=eid.substring(0,eid.indexOf("_"));
                            users.put(eid,"1");
                      }
                  }
                 br.close();
                 in.close();
                 fstream.close();
                 filecount++;
             }
            }catch (Exception e){//Catch exception if any
              System.err.println("Error: " + e.getMessage());
            }finally{
                try{
                    if(in!=null)in.close();
                }catch(IOException ioe){
                    //OK
                }
            }  
            return new ArrayList(users.keySet());
    }
    
%>
<%
QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);

HttpServletRequest cqReq = request;
boolean isAdmin=false;
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    isAdmin=false;
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    return;
}


//out.write("hello");
//doSearchNew(out,"/apps","","jcr:created",builder,resourceResolver);
//ArrayList arUsers=new ArrayList();

/*
String userlist=request.getParameter("userlist");
if(userlist!=null && !userlist.equals("")){

StringTokenizer names= new StringTokenizer(userlist,"\n");
while(names.hasMoreTokens()){
    String name=names.nextToken();
    arUsers.add(name);       
}

} 
*/  

String fordate=request.getParameter("fordate");
if(fordate==null)fordate="08/12/2013";
boolean bDetails=false;
String details=request.getParameter("details");

if(details!=null)bDetails=true;

ArrayList arUsers=getTimingLogUsers("crx-quickstart/logs/timing.log",fordate);

//lookup AD attributes for users in timing.log
out.println("<table>");
out.println(lookupUsers(arUsers,bDetails));
out.println("</table>");
//checkLastSynch(out,arUsers,builder,resourceResolver);
//doSearch(out,"/content","cq:Page","cq:lastModified",builder,jcrSession);
%>
<form action="" method=\"POST\">
<textarea name="userlist" id="userlist" rows=20 cols=150 ></textarea><br>
<input type=submit>
</form>
</body>
</html> 