<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<%@ page import="java.util.Calendar,
        java.text.SimpleDateFormat,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        javax.naming.Context,
        javax.naming.NamingEnumeration,
        javax.naming.directory.Attribute,
        javax.naming.directory.Attributes,
        javax.naming.directory.DirContext,
        javax.naming.directory.InitialDirContext,
        javax.naming.directory.SearchControls,
        javax.naming.directory.SearchResult,
        org.apache.sling.api.resource.*,
        org.apache.commons.httpclient.*,
        org.apache.commons.httpclient.auth.*,
        org.apache.commons.httpclient.methods.*,
        com.mcd.cq.util.UserAdmin,
        com.mcd.cq.util.CRXInfoService,
        com.day.cq.security.*,
        org.apache.sling.jcr.base.util.AccessControlUtil,
        com.mcd.cq.util.search.SearchGroup,
        org.apache.sling.api.servlets.SlingAllMethodsServlet,
        org.apache.sling.api.SlingHttpServletResponse,
        org.apache.sling.api.SlingHttpServletRequest,
        javax.servlet.ServletException,
        java.text.SimpleDateFormat,
        java.net.URLEncoder,com.mcd.util.PropertiesLoader"%>
<%@include file="/apps/mcd/global/global.jsp" %> 

<HEAD>
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>    
<TITLE> DN Difference Report Utility </TITLE>
    <style type="text/css">
        body{
            font-family: verdana,sans-serif,arial;
            font-size:14px;
        }
        h3{
            text-align:center;
        text-decoration:underline;
        font-size:20px;
        /*color: #005ACC;*/
        }
        input.formbutton
        {  
           font-family:verdana,sans-serif;
           font-weight:bold;
           color:#FFFFFF;
           background-color:#0077BB;
        }
        table.pagetable {
            border-width: 1px 1px 1px 1px;
            border-spacing: 0px;
            border-style: solid solid solid solid;
            border-color: black black black black;
            border-collapse: collapse;
        }
        table.pagetable th {
            font-weight:bold;
            border-width: 1px 1px 1px 1px;
            padding: 5px 5px 5px 5px;
            border-style: solid solid solid solid;
            background-color: #EEEEEE;
            color: #802A2A;
            font-size: 12px;
        }
        table.pagetable td {
            font-size: 11px;
            border-width: 1px 1px 1px 1px;
            padding: 5px 5px 5px 5px;
            border-style: dotted dotted dotted dotted;
        }
        .nowrap{
            white-space:nowrap;
        }
        .rightAlign{
            text-align:right;
        }
        
        font.error
        {
            color: #ce0000;
            font-size:13px;
        }
        table.pagetable.td p { 
           display: block;
            margin-top: 1em;
            margin-bottom: 1em;
            margin-left: 0;
            margin-right: 0;
        }
        #ajaxSpinnerImage {
           display: none;
        }
    </style>
</HEAD>

<BODY>
<%
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);
    String rootPath = (String)request.getParameter("rootPath");
    if( (!(rootPath != null)) || (!(rootPath.length() > 0)) ){
        rootPath = "";        
    }
    
    String eidList = (String)request.getParameter("EIDLIST");
    if( eidList == null ){
        eidList = "";        
    }
%>
    <a name="top"></a>
    <div style="width:100%;padding-top:5px;"><img  src='/images/accessmcd.gif' /></div>
    
    <form id="report" name="report" action="#" style="margin-top: -45px;">
        <table border=0 width="100%"  style="margin-top:10px"><tr><td align="right"><font size="2" color="red">Logged In User:&nbsp;<b><%=user.getName()%></b></font></td></tr> </table>
        
        <input type="hidden" name="hidAction" value="Clear"/>
        
        <h3>User DN Difference Report Utility</h3>
        <br>
        <p style="margin-top:-20px;text-align:center;">
            <i>The Report Utility will display difference between LDAP DN and CQ DN.</i>
        </p>           
        <hr style="margin-top:-8px;margin-bottom:12px;">
        <input type="checkbox" id="showeidlist" name="showeidlist" value="false"> <span style="background-color:#808080;border-radius:5px;color:#fff;font-size:14px;font-weight:bold;height:15px;padding:10px;">Display text box to put specific user eid.</span><br>
        <h1 id="orid" style="margin-left:100px;"> OR </h1>
        <div id="elseid" style="background-color: #808080;border-radius: 5px;color: #fff;font-weight: bold;height: 15px;padding: 10px 0 10px 10px;width: 640px;">Click on ShowInfo button to get the user DN difference from predefined user list.</div>
        <b><span id="eidlistlabel">&nbsp;EID LIST</span></b><textarea name="EIDLIST" id="EIDLIST" cols="60" rows="5" style="margin-top:20px;"></textarea>     
        <br>
        <label style="font-size:12px;color:#808080;" id="eidlistnote"> &nbsp;<b>Note:</b> Please enter comma separated EIDs in EID List Field. </label> <br>
       
        
        <input id = "ShowInfo" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="ShowInfo" />
        <input id = "Clear" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Clear';" value="Clear" />    
        <br><br>
        <hr style=""> 
<%
        try{
            String hidAction = (String) request.getParameter("hidAction");
            if(hidAction != null){
                if(hidAction.equals("ShowInfo")){
                    /*if("".equals(eidList)){
                        out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Please provide eid list separated with commas. </span></b></p>");
                    }  
                    else{*/
%>
                        <table class="pagetable" width="100%" cellpadding="0" cellspacing="1" border="1"> 
                            <tr>  
                                <th>S.No</th>
                                <th>EID</th>
                                <th>LDAP DN</th>
                                <th>113b 4212 DN</th>
                                <th>113b 4216 DN</th>
                                <th>115 4212 DN</th>
                                <th>115 4214 DN</th>
                            </tr>    
<%                    
                        /* EID DN CODE HERE */
                        
                        
                        if("".equals(eidList.trim())){
                            Properties franProp = PropertiesLoader.loadProperties("franchisee-users.properties");
                            String franUsers = franProp.getProperty("franusers");
                            eidList = franUsers;
                        }
                        //out.println("Fran Users :: " + franUsers);
                        String[] userEID = eidList.split(",");
                        int count = 1;
                        for(int i =0; i < userEID.length ; i++){
                            String eid = userEID[i];
                            String ldapInfo = lookupUser(eid);
                            String serverInfo113b4212 = getPublish113b4212EIDs(eid);
                            String serverInfo113b4216 = getPublish113b4216EIDs(eid);
                            String serverInfo1154212 = getPublish1154212EIDs(eid);
                            String serverInfo1154214 = getPublish1154214EIDs(eid);
                            /*out.println("LDAP Info <br> " + ldapInfo + "<br>");
                            out.println("Server Info 113b 4212 <br> " + serverInfo113b4212 + "<br>");
                            out.println("Server Info 113b 4216 <br> " + serverInfo113b4216 + "<br>");
                            out.println("Server Info 115 4212<br> " + serverInfo1154212 + "<br>");
                            out.println("Server Info 115 4214 <br> " + serverInfo1154214 + "<br>");*/
                           
                            boolean serverInfo113b4212Temp = false;
                            boolean serverInfo113b4216Temp = false;
                            boolean serverInfo1154212Temp = false;
                            boolean serverInfo1154214Temp = false;
                            if(!ldapInfo.trim().equalsIgnoreCase(serverInfo113b4212.trim())){
                                serverInfo113b4212Temp = true;
                            }
                            if(!ldapInfo.trim().equalsIgnoreCase(serverInfo113b4212.trim())){
                                serverInfo113b4216Temp = true;
                            }
                            if(!ldapInfo.trim().equalsIgnoreCase(serverInfo113b4212.trim())){
                                serverInfo1154212Temp = true;
                            }
                            if(!ldapInfo.trim().equalsIgnoreCase(serverInfo113b4212.trim())){
                                serverInfo1154214Temp = true;
                            }
                            
                            if(serverInfo113b4212Temp && serverInfo113b4216Temp && serverInfo1154212Temp && serverInfo1154214Temp){
%>
                                <tr>                            
                                    <td><%=count%></td>
                                    <td><%=eid%></td>
                                    <td><%=ldapInfo%></td>
                                    <td><%=serverInfo113b4212%></td>
                                    <td><%=serverInfo113b4216%></td>
                                    <td><%=serverInfo1154212%></td>
                                    <td><%=serverInfo1154214%></td>
                                </tr>
<%                            
                                count++;
                            }
                        }
%>
                        </table>
<%                         
                     //}
                }           
            }            
        }
        catch(Exception ex){
            //out.println("<br>Excpetion occured for path :: " + exceptionPath);
        } 
        
%>          
    </form>        
</BODY>
</HTML> 


<%!
  public String lookupUsers(String userlist,boolean bUpdateUserOnly){
        String msg="";
         StringTokenizer names= new StringTokenizer(userlist,"\n");
        Session session = null;
        try {
          
            while(names.hasMoreTokens()){
                String name=names.nextToken();
                msg+=lookupUser(name);
                //msg+=getPublishEIDs(name);
                //msg+="<tr><td>"+name+"</td><td>"+mcid+"</td></tr>";           
            }
             
        }catch(Exception e){
               //log.error("lookupUsers: exception occured:" + e.getMessage());
        }finally{
        }
        return msg;
  }
  
  public String lookupUser( String eid){

        
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
                    //log.error("SearchResult is null...continuing ");
                    continue;
                }
                Attributes attrs = sr.getAttributes();
                if (attrs == null)
                {
                    //log.error("SR attributes is null...continuing");
                    continue;
                }
                String displayname="";
                String dn="";
                String location="";
                String personalTitle="";
                String primaryTelexNumber="";
                String email="";
                Attribute attr = attrs.get("displayName");
                if (attr != null)
                {
                    displayname= (String) attr.get(0);
                    
                    
                }
                attr = attrs.get("distinguishedName");
                if (attr != null)
                {
                    dn= (String) attr.get(0);
                    
                    
                }
                attr = attrs.get("l");
                if (attr != null)
                {
                    location= (String) attr.get(0);
                }
                attr = attrs.get("personalTitle");
                if (attr != null)
                {
                    personalTitle= (String) attr.get(0);
                }
                 attr = attrs.get("primaryTelexNumber");
                if (attr != null)
                {
                    primaryTelexNumber= (String) attr.get(0);
                }
                 attr = attrs.get("l");
                if (attr != null)
                {
                    location= (String) attr.get(0);
                }
                
                attr = attrs.get("mail");
                if (attr != null)
                {
                    email= (String) attr.get(0);
                }
                
                //msg+="<tr><td>"+eid+"</td><td>"+dn+"</td><td>"+displayname+"</td><td>"+email+"</td><td>"+location+"</td><td>"+personalTitle+"</td><td>"+primaryTelexNumber+"</td></tr>";
                msg = dn;
                count++;
            }

        }
        catch (Exception ex)
        {
            //log.error(" exception occured" + ex.getMessage());
        }
        
        
        return msg;
        
  }
  
  private String getPublishEIDs(String eid){
        StringBuffer sb=new StringBuffer();
        String strComma="";
        
        String[] serverlist={
         "mcdeagsun113b.mcd.com:4212",
         "mcdeagsun113b.mcd.com:4216",
         "mcdeagsun115.mcd.com:4212",         
         "mcdeagsun115.mcd.com:4214"
        };

        
        for(int ix=0;ix<serverlist.length;ix++){
            String publishuser=new String(getCQ5Content("http://"+serverlist[ix]+"/content/utility/utility.userinfodn.html?eid="+eid));
            sb.append("<b>Server:"+serverlist[ix]+"</b><br>");
            if(!publishuser.equals("")){
                sb.append(publishuser);
                strComma=",";
            }
        }
        return sb.toString();
    
  }
  
  private String getPublish113b4212EIDs(String eid){
    StringBuffer sb = new StringBuffer();
    String publishuser = new String(getCQ5Content("http://mcdeagsun113b.mcd.com:4212/content/utility/utility.userinfodn.html?eid="+eid));
    
    if(!publishuser.equals("")){
        sb.append(publishuser);
    }
    return sb.toString();
  }
  private String getPublish113b4216EIDs(String eid){
    StringBuffer sb = new StringBuffer();
    String publishuser = new String(getCQ5Content("http://mcdeagsun113b.mcd.com:4216/content/utility/utility.userinfodn.html?eid="+eid));
    
    if(!publishuser.equals("")){
        sb.append(publishuser);
    }
    return sb.toString();
  } 
  private String getPublish1154212EIDs(String eid){
    StringBuffer sb = new StringBuffer();
    String publishuser = new String(getCQ5Content("http://mcdeagsun115.mcd.com:4212/content/utility/utility.userinfodn.html?eid="+eid));
    
    if(!publishuser.equals("")){
        sb.append(publishuser);
    }
    return sb.toString();
  } 
  private String getPublish1154214EIDs(String eid){
    StringBuffer sb = new StringBuffer();
    String publishuser = new String(getCQ5Content("http://mcdeagsun115.mcd.com:4214/content/utility/utility.userinfodn.html?eid="+eid));
    
    if(!publishuser.equals("")){
        sb.append(publishuser);
    }
    return sb.toString();
  }   
     
 
   public static byte[] getCQ5Content(String url){
             
            byte[] retbytes="".getBytes();
            GetMethod getPageMeth=null; 
            org.apache.commons.httpclient.HttpClient client = new HttpClient();
            HostConfiguration host = client.getHostConfiguration();
            
            try {

                host.setHost(new org.apache.commons.httpclient.URI(url));
                org.apache.commons.httpclient.Credentials credentials = new UsernamePasswordCredentials("admin", "H@rs!615D");
                client.getState().setCredentials(AuthScope.ANY, credentials);
                
                getPageMeth= new GetMethod(url);
                
                getPageMeth.setDoAuthentication( true );       
                getPageMeth.getParams().setParameter("http.socket.timeout", new Integer(10000));        
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
                 }      
            } catch(Exception e){
            }
            finally {
                getPageMeth.releaseConnection();
                client=null;
            }
            return retbytes;
     }
%>
<script>
$(document).ready(function(){
    $('#showeidlist').change(function(){
        if(this.checked){
            $('#EIDLIST').show();
            $('#eidlistlabel').show();
            $('#orid').hide();
            $('#elseid').hide();
        }    
        else{
            $('#EIDLIST').hide();
            $('#eidlistlabel').hide();
            $('#eidlistnote').hide();
            $('#orid').show();
            $('#elseid').show();
        }    
    });
    $('#EIDLIST').hide();
    $('#eidlistlabel').hide();
    $('#eidlistnote').hide();
    
});
</script>