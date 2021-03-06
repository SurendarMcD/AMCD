 <%-- 
  ==============================================================================
  Runs diffs between files on the same/different instances 
  
  Erik Wannebo 1/14/2010
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
                org.apache.commons.lang.*
                "
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%
%><%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %><%
%><%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%
%><cq:defineObjects />
<title>CQ5 Diff Utility</title>
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script> 
<link rel="stylesheet" type="text/css" href="/scripts/utility/diffview.css"/> 
<!--script type="text/javascript" src="/scripts/utility/pd.js"></script-->  
<script type="text/javascript" src="/scripts/utility/prettydiff.js"></script> 

<script language=Javascript> 
function diffUsingJS () {
// get the baseText and newText values from the two textboxes, and split them into lines
//var base = difflib.stringAsLines($("#page1content").text());
//var newtxt = difflib.stringAsLines($("#page2content").text());
// create a SequenceMatcher instance that diffs the two sets of lines
//var sm = new difflib.SequenceMatcher(base, newtxt);
// get the opcodes from the SequenceMatcher instance
// opcodes is a list of 3-tuples describing what changes should be made to the base text
//      in order to yield the new text
//var opcodes = sm.get_opcodes();
//var diffoutputdiv = $("#diffoutput");
//while (diffoutputdiv.firstChild) diffoutputdiv.removeChild(diffoutputdiv.firstChild);
//var contextSize = null;
//contextSize = contextSize ? contextSize : null;
// build the diff view and add it to the current DOM
//diffoutputdiv.html("");
//diffoutputdiv.append(prettydiff());
viewType=(($('input[id="inline"]:checked', '#diffForm').val()=="on") ?  "inline" :"sidebyside");
//alert(viewType);
//alert($("#host1 option:selected").text());
var sourcetext=$("#baseText").val();
var newtext=$("#newText").val();
var language="auto";
var pagename=$('input[id="page1"]').val().toLowerCase();
var extension=pagename.substring(pagename.lastIndexOf("."));
//alert(extension);
if(extension==".css")language="css";
if(extension==".js")language="js";
if(extension==".jsp")language="text";
language="text";
//alert(sourcetext);
var output=prettydiff(
sourcetext,
newtext,
"diff",
language,
"",
"",
"",
"indent",
"",
"indent",
"",
"",
true,
false,
false,
viewType,
$("#host1 option:selected").text(),
$("#host2 option:selected").text(),
""
);
$("#diffoutput").html(output[0]+output[1]);
//alert('done');
//.buildView({ baseTextLines:base,
//newTextLines:newtxt,
//opcodes:opcodes,
// set the display titles for each resource
//baseTextName:$("#host1 option:selected").text(),
//newTextName:$("#host2 option:selected").text(),
//contextSize:contextSize,

// scroll down to the diff view
//window.location = url + "#diff";
}
</script>
<body style="font:12px arial;">
<h2>CQ5 File Diff</h2><br>
<%!
     
     public String getContent(String url){
            
            if(url==null || url.equals(""))return "";
            byte[] retbytes=null;
            GetMethod getPageMeth=null; 
            org.apache.commons.httpclient.HttpClient client = new HttpClient();
            HostConfiguration host = client.getHostConfiguration();
            
            try {
                
                host.setHost(new org.apache.commons.httpclient.URI(url));
                String adminpwd="H@rs!615D";
                if(url.indexOf("mcdeagsun107a")>-1)adminpwd="Ch@rl!906";
                if(url.indexOf("mcdeagsun107b")>-1)adminpwd="admin";
                org.apache.commons.httpclient.Credentials credentials = new UsernamePasswordCredentials("admin", adminpwd);
                client.getState().setCredentials(AuthScope.ANY, credentials);
                
                getPageMeth= new GetMethod(url);
                
                getPageMeth.setDoAuthentication( true );       
                getPageMeth.getParams().setParameter("http.socket.timeout", new Integer(30000));        
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
            String retString=new String(retbytes);
            return retString;
     }
     
     public String addMsg(String addmsg){
         return addmsg+"<BR>";
    }
    
    public String addErrMsg(String addmsg){
         return "<font color=red>"+addmsg+"</font><BR>";
    }
   
%> 
<%
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    return;
    }
//Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
String page1=slingRequest.getParameter("page1");
String page2=slingRequest.getParameter("page2");
String host1=slingRequest.getParameter("host1");
String host2=slingRequest.getParameter("host2");
if(host1==null)host1="";
if(host2==null)host2="";
String page1content="";
String page2content="";
if(page1==null)page1="";
if(page2==null || page2=="")page2=page1;

if(!page1.trim().equals("")  ){
    page1=page1.trim();
    if(page2!=null && !page2.trim().equals("")){
        page2=page2.trim();
    }else{
        page2=page1.trim();
    }
   
    
   // if(page1.indexOf(".html")>-1)page1=page1.substring(0,page1.indexOf(".html"));
    
    try{
        page1content=getContent(host1+page1);
        page2content=getContent(host2+page2);
        
    }catch(Exception e){
        
    }
   }
%>
 
<textarea id="baseText" style="display:none;"><%=page1content %></textarea>
<textarea id="newText" style="display:none;"><%=page2content %></textarea><br>
   <form id="diffForm" action="" method="GET">
    <b>File 1:</b><select id="host1" name="host1">
    <option value="http://mcdeagsun107a.mcd.com:4214" <%= (host1.equals("http://mcdeagsun107a.mcd.com:4214")?"selected":"")%>>DEV AUTH</option>
    <option value="http://mcdeagsun107b.mcd.com:4213" <%= (host1.equals("http://mcdeagsun107b.mcd.com:4213")?"selected":"")%>>STG AUTH</option>
    <option value="http://mcdeagsun113b.mcd.com:4210" <%= (host1.equals("http://mcdeagsun113b.mcd.com:4210")?"selected":"")%>>PROD AUTH</option>
    <option value="http://mcdeagsun107a.mcd.com:4215" <%= (host1.equals("http://mcdeagsun107a.mcd.com:4215")?"selected":"")%>>DEV PUB</option>
    <option value="http://mcdeagsun107b.mcd.com:4214" <%= (host1.equals("http://mcdeagsun107b.mcd.com:4214")?"selected":"")%>>STG PUB</option>
    <option value="http://mcdeagsun113b.mcd.com:4212" <%= (host1.equals("http://mcdeagsun113b.mcd.com:4212")?"selected":"")%>>PROD PUB 113A</option>
    <option value="http://mcdeagsun113b.mcd.com:4214" <%= (host1.equals("http://mcdeagsun113b.mcd.com:4214")?"selected":"")%>>PROD PUB 113B</option>
    <option value="http://mcdeagsun115.mcd.com:4212" <%= (host1.equals("http://mcdeagsun115.mcd.com:4212")?"selected":"")%>>PROD PUB 115A</option>
    <option value="http://mcdeagsun115.mcd.com:4213" <%= (host1.equals("http://mcdeagsun115.mcd.com:4213")?"selected":"")%>>PROD PUB 115B</option>
    
    </select>
    <input id="page1" name="page1" size=100 value="<%=page1 %>"><br>
    <b>File 2:</b><select id="host2" name="host2">
    <option value="http://mcdeagsun107a.mcd.com:4214" <%= (host2.equals("http://mcdeagsun107a.mcd.com:4214")?"selected":"")%>>DEV AUTH</option>
    <option value="http://mcdeagsun107b.mcd.com:4213" <%= (host2.equals("http://mcdeagsun107b.mcd.com:4213")?"selected":"")%>>STG AUTH</option>
    <option value="http://mcdeagsun113b.mcd.com:4210" <%= (host2.equals("http://mcdeagsun113b.mcd.com:4210")?"selected":"")%>>PROD AUTH</option>
    <option value="http://mcdeagsun107a.mcd.com:4215" <%= (host2.equals("http://mcdeagsun107a.mcd.com:4215")?"selected":"")%>>DEV PUB</option>
    <option value="http://mcdeagsun107b.mcd.com:4214" <%= (host2.equals("http://mcdeagsun107b.mcd.com:4214")?"selected":"")%>>STG PUB</option>
    <option value="http://mcdeagsun113b.mcd.com:4212" <%= (host2.equals("http://mcdeagsun113b.mcd.com:4212")?"selected":"")%>>PROD PUB 113A</option>
    <option value="http://mcdeagsun113b.mcd.com:4214" <%= (host2.equals("http://mcdeagsun113b.mcd.com:4214")?"selected":"")%>>PROD PUB 113B</option>
    <option value="http://mcdeagsun115.mcd.com:4212" <%= (host2.equals("http://mcdeagsun115.mcd.com:4212")?"selected":"")%>>PROD PUB 115A</option>
    <option value="http://mcdeagsun115.mcd.com:4213" <%= (host2.equals("http://mcdeagsun115.mcd.com:4213")?"selected":"")%>>PROD PUB 115B</option>
    </select><input id="page2" name="page2" size=100 value="<%=page2 %>"> (defaults to same path as File 1)<br>
    <strong>Diff View Type:</strong> 
    <input type="radio" onclick="javascript:diffUsingJS();" name="_viewtype" checked="checked" id="sidebyside"/> Side by Side
    &#160;&#160;
    <input type="radio" onclick="javascript:diffUsingJS();" name="_viewtype" id="inline"/> Inline
  <input type=submit>
    </form>
    <div id="diffoutput" style="width:100%"></div>


<script language="Javascript">
diffUsingJS();
</script>
</body> 