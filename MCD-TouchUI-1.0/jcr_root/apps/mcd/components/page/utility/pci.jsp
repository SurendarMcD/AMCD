<%@include file="/libs/wcm/global.jsp" %>  
<%@page import="java.io.*, 
               java.io.InputStream,
               java.net.URL,
               java.text.*,
               java.util.*" %>

<%@page import="com.mcd.accessmcd.pci.bo.PCIQuery,
                com.mcd.accessmcd.pci.bo.PCIResult,
                com.mcd.accessmcd.pci.util.PCIProperties,
                com.mcd.accessmcd.pci.dao.IPCIContentDao,
                com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl,
                com.mcd.accessmcd.pci.util.XMLUtils" 
                
%>
               
<%@page import="org.apache.commons.httpclient.DefaultHttpMethodRetryHandler,
                org.apache.commons.httpclient.HttpClient,
                org.apache.commons.httpclient.HttpStatus,
                org.apache.commons.httpclient.methods.GetMethod,
                org.apache.commons.httpclient.params.HttpMethodParams,
                org.w3c.dom.Document,
                org.w3c.dom.Element,
                org.w3c.dom.Node,
                org.w3c.dom.NodeList" %>

<%@page import="org.apache.sling.api.scripting.SlingScriptHelper" %>

<html>
<head>
<title>PCI Query</title>
<script language="javascript" src="/apps/mcd/docroot/scripts/jquery-1.js"></script>
<script language="javascript">
$(document).ready(function(){
    $("#catidsetter").val($("#categoryID").val());
});

</script>
</head>
<%!

//client timeout session for Http connections
private final int CLIENT_TIMEOUT=5000; //5 secs    

//socket timeout param
private final String SOCKET_TIMEOUT_ARG = "http.socket.timeout";

//connection timeout param
private final String CONN_TIMEOUT_ARG   = "http.connection.timeout";


public String PCI_SERVLET;
public int DEFAULT_OSCACHE_REFRESH;
public String AMCD_MEDIA_LOCATION;
public HashMap serverDomainMap;



private String td(String val){
    return "<TD>"+val+"</TD>";
}


public void displayForm(javax.servlet.jsp.JspWriter out,HttpServletRequest cqReq)throws IOException{
    out.println("<h1>PCI Query</h1><br>");

    String categoryID=cqReq.getParameter("categoryID");
    String topStoryCategoryID=cqReq.getParameter("topStoryCategoryID");
    String resultCount=cqReq.getParameter("resultCount");
    String audience=cqReq.getParameter("audience");
    String sortType=cqReq.getParameter("sortType");
    String entityType=cqReq.getParameter("entityType");
    String viewType=cqReq.getParameter("viewType");
    String displayType=cqReq.getParameter("displayType");
    String fromDate=cqReq.getParameter("fromDate");
    String toDate=cqReq.getParameter("toDate");
   
    if(categoryID==null)categoryID="3000";
    if(audience==null)audience="ALL";
    if(entityType==null)entityType="ALL";
    if(topStoryCategoryID==null)topStoryCategoryID="";
    if(resultCount==null)resultCount="10";
    if(viewType==null)viewType="content";
    if(sortType==null)sortType="rchrono";
    if(displayType==null)displayType="table";
    if(fromDate==null)fromDate="";
    if(toDate==null)toDate=""; 
    
    //if(entityType==null)entityType="ENT";
    
    out.println("<FORM name=\"pciquery\" action=\"\" method=\"GET\">");

    out.println("<B>Category ID:</B><INPUT id=\"categoryID\" name=\"categoryID\" value=\""+categoryID+"\">");

    out.println("<SELECT id=\"catidsetter\" onchange='$(\"#categoryID\").val($(\"#catidsetter\").val());'>");
    out.println("<OPTION value=\"0\" ></OPTION>");
    out.println("<OPTION value=\"20051\" >Global Media</OPTION>");
    out.println("<OPTION value=\"32061\" >At McDonalds</OPTION>");
    out.println("<OPTION value=\"30101\" >US News</OPTION>");
    out.println("<OPTION value=\"30100\" >Home Office News</OPTION>");
    out.println("<OPTION value=\"1000\" >AU/NZ Homepage Calendar</OPTION>");
    out.println("<OPTION value=\"3000\" >Calendar</OPTION>");
    out.println("<OPTION value=\"4000\" >Notice Board</OPTION>");
    out.println("<OPTION value=\"1056\" >Site Finder</OPTION>");
    out.println("<OPTION value=\"20113\" >PCI Testing</OPTION>");
    out.println("</SELECT><BR>");
 
    out.println("<BR>"); 

    out.println("<B>Entity:</B><SELECT name=\"entityType\" >");
    out.println("<OPTION value=\"ALL\" "+ (entityType.equals("ALL")?"SELECTED":"")+">ALL</OPTION>");
    out.println("<OPTION value=\"AU\" "+ (entityType.equals("AU")?"SELECTED":"")+">Australia</OPTION>");
    out.println("<OPTION value=\"ENT\" "+ (entityType.equals("ENT")?"SELECTED":"")+">Global</OPTION>");
    out.println("<OPTION value=\"JA\" "+ (entityType.equals("JA")?"SELECTED":"")+">Japan</OPTION>");
    out.println("<OPTION value=\"NZ\" "+ (entityType.equals("NZ")?"SELECTED":"")+">New Zealand</OPTION>");
    out.println("<OPTION value=\"US\" "+ (entityType.equals("US")?"SELECTED":"")+">US</OPTION>");
    out.println("</SELECT><BR>");
 

    out.println("<B>Audience:</B><SELECT name=\"audience\" >");
    out.println("<OPTION value=\"\" >Select Audience</OPTION>");
    out.println("<OPTION value=\"ALL\" "+ (audience.equals("ALL")?"SELECTED":"")+">ALL</OPTION>");
    out.println("<OPTION value=\"Agency\" "+ (audience.equals("Agency")?"SELECTED":"")+">Agency</OPTION>");
    out.println("<OPTION value=\"CorpEmployees\" "+ (audience.equals("CorpEmployees")?"SELECTED":"")+">CorpEmployees</OPTION>");
    out.println("<OPTION value=\"Crew\" "+ (audience.equals("Crew")?"SELECTED":"")+">Crew</OPTION>");
    out.println("<OPTION value=\"Franchisees\" "+ (audience.equals("Franchisees")?"SELECTED":"")+">Franchisees</OPTION>");
    out.println("<OPTION value=\"FranchiseeOfficeStaff\" "+ (audience.equals("FranchiseeOfficeStaff")?"SELECTED":"")+">FranchiseeOfficeStaff</OPTION>");
    out.println("<OPTION value=\"FranchiseeRestMgrs\" "+ (audience.equals("FranchiseeRestMgrs")?"SELECTED":"")+">FranchiseeRestMgrs</OPTION>");
    out.println("<OPTION value=\"McOpCoRestMgrs\" "+ (audience.equals("McOpCoRestMgrs")?"SELECTED":"")+">McOpCoRestMgrs</OPTION>");
    out.println("<OPTION value=\"SupplierVendors\" "+ (audience.equals("SupplierVendors")?"SELECTED":"")+">SupplierVendors</OPTION>");
    out.println("</SELECT><BR>");
        

    out.println("<B>Result Count:</B><INPUT name=\"resultCount\" value=\""+resultCount+"\"><BR>");


    out.println("<B>View Type:</B><SELECT name=\"viewType\" >");
    out.println("<OPTION value=\"content\" "+ (viewType.equals("content")?"SELECTED":"")+">content</OPTION>");
    out.println("<OPTION value=\"category\" "+ (viewType.equals("category")?"SELECTED":"")+">category</OPTION>");
    out.println("<OPTION value=\"sf\" "+ (viewType.equals("sf")?"SELECTED":"")+">sf</OPTION>");
    out.println("</SELECT><BR>");

    out.println("<B>Sort:</B><SELECT name=\"sortType\" >");
    out.println("<OPTION value=\"alpha\" "+ (sortType.equals("alpha")?"SELECTED":"")+">alpha</OPTION>");
    out.println("<OPTION value=\"rchrono\" "+ (sortType.equals("rchrono")?"SELECTED":"")+">rchrono</OPTION>");
    out.println("<OPTION value=\"rchronouuid\" "+ (sortType.equals("rchronouuid")?"SELECTED":"")+">rchronouuid</OPTION>");
    out.println("<OPTION value=\"chrono\" "+ (sortType.equals("chrono")?"SELECTED":"")+">chrono</OPTION>"); 
    out.println("<OPTION value=\"chronouuid\" "+ (sortType.equals("chronouuid")?"SELECTED":"")+">chronouuid</OPTION>");
    out.println("</SELECT><BR>");


    out.println("<B>Return type:</B><SELECT name=\"displayType\" >");
    out.println("<OPTION value=\"XML\" "+ (displayType.equals("XML")?"SELECTED":"")+">XML</OPTION>");
    out.println("<OPTION value=\"table\" "+ (displayType.equals("table")?"SELECTED":"")+">table</OPTION>");
    out.println("</SELECT><BR>");
    
    out.println("<B>Top Story Category ID:</B><INPUT name=\"topStoryCategoryID\" value=\""+topStoryCategoryID+"\"><BR>");

    out.println("<B>From Date:</B><INPUT name=\"fromDate\" value=\""+fromDate+"\"> <i>M/d/yyyy</i><BR>");

    out.println("<B>To Date:</B><INPUT name=\"toDate\" value=\""+toDate+"\"> <i>M/d/yyyy</i><BR>");

    out.println("<INPUT TYPE=SUBMIT>");
    
    out.println("</FORM><BR>");



}


public void displayResults(javax.servlet.jsp.JspWriter out,HttpServletRequest cqReq, SlingScriptHelper sling)throws IOException{

  if(sling !=null){
    PCIContentDeliveryFacadeImpl pci=new PCIContentDeliveryFacadeImpl(sling);
    //com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl pci=new com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl();
    out.println("<h2>PCI Results Test</h2><br>");
    
    
    String categoryID=cqReq.getParameter("categoryID");
    String topStoryCategoryID=cqReq.getParameter("topStoryCategoryID");
    String resultCount=cqReq.getParameter("resultCount");
    String audience=cqReq.getParameter("audience");
    String sortType=cqReq.getParameter("sortType");
    String entityType=cqReq.getParameter("entityType");
    String actionType="read";
    String viewType=cqReq.getParameter("viewType");
    String displayType=cqReq.getParameter("displayType");
    String fromDate=cqReq.getParameter("fromDate");
    String toDate=cqReq.getParameter("toDate");

    com.mcd.accessmcd.pci.bo.PCIQuery pciquery=new com.mcd.accessmcd.pci.bo.PCIQuery();
    
    if(categoryID==null || categoryID.equals("")){
        out.println("Please enter a category ID");
        return;
    }
    if(displayType==null)displayType="XML";
    
    String outputXML="";
    
    pciquery.setAudience(audience);
    pciquery.setCategoryID(categoryID);
    pciquery.setResultCount(resultCount) ;
    pciquery.setSortType(sortType);
    pciquery.setEntityType(entityType);
    pciquery.setActionType(actionType);
    pciquery.setViewType(viewType);
    pciquery.setTopStoryCategoryID(topStoryCategoryID);
    pciquery.setCacheRefresh(0); // no caching
    SimpleDateFormat sdf=new SimpleDateFormat("M/d/yyyy");
    SimpleDateFormat pdsdf=new SimpleDateFormat("M/d/yyyy hh:mm:ss");
    try{
        Date dtFromDate=sdf.parse(fromDate);
        pciquery.setFromDate(dtFromDate);
        Date dtToDate=sdf.parse(toDate);
        pciquery.setToDate(dtToDate);
    }catch(Exception e){
    }
    
    out.println("the query is ............."+pciquery.toQueryString(false));
    
    if(displayType.equals("XML")){
        outputXML=pci.getPCIContentAsXMLString(pciquery);
        outputXML=XMLUtils.convertXMLDocToString(pci.getPCIContentAsXMLDocument(pciquery)); 
        outputXML=outputXML.replaceAll("\\<","&lt;");
        outputXML=outputXML.replaceAll("\\>","&gt;<br>");
        out.println(new String(outputXML.getBytes("UTF-8"),"UTF-8"));
    }


    if(displayType.equals("table")){
    
        com.mcd.accessmcd.pci.bo.PCIResult[] results=pci.getPCIContent(pciquery);  

        out.println("Results returned:"+results.length+"<br>");
        out.println("<TABLE align=\"center\" border=1>");
        out.println("<TR>");
        out.println(td("<B>#</b>"));
        out.println(td("<B>UUID</b>"));
        out.println(td("<B>Content ID</b>"));
        out.println(td("<B>Detail ID</b>"));
        out.println(td("<B>View</b>"));
        out.println(td("<B>Audience</b>"));
        out.println(td("<B>Title</b>"));
        out.println(td("<B>Publish Date</b>"));
        out.println(td("<B>Link</b>"));
        out.println(td("<B>Description</b>"));
        
        out.println("</TR>"); 
        
        for(int ix=0;ix<results.length;ix++){
            out.println("<TR>");
            out.println(td(""+(ix+1)));
            com.mcd.accessmcd.pci.bo.PCIResult result=results[ix];
            out.println(td(result.getUUID()));
            out.println(td(result.getContentID()));
            out.println(td(result.getContentDetailID()));
            out.println(td(result.getEntityType()));
            out.println(td(result.getAudienceType()));
            out.println(new String(td(result.getDocumentTitle()).getBytes("UTF-8"),"UTF-8"));
            Date pubDt=result.getPublishDateObj();
            
            out.println(td(pdsdf.format(pubDt)));
            out.println(td(result.getPageURI()));
            out.println(td(result.getDescription()));
            
            out.println("</TR>");
        }
        out.println("</TABLE>");
    }

  }else{
        out.println("<h2>Sling is null</h2><br>");

  }
}

%>

<%
HttpServletRequest cqReq = (HttpServletRequest) request;

response.setContentType("text/html;charset=UTF-8");
displayForm(out,cqReq);
displayResults(out,cqReq,sling);

//loadproperties();

//out.println("PCI properties: "+PCI_SERVLET);
//out.println("PCI properties: "+ com.mcd.accessmcd.pci.util.PCIProperties.PCI_SERVLET);

//String testURL = "http://mcdeagsun007:8004/pci/PCIServer?action=read&viewtype=content&sorting=rchrono&catid=30101&count=10&sm_user=test&mcdaudience=CorpEmployees&mcdentity=US";

//String testRe = getXMLStringFromURL(testURL);

//out.println(testRe);

%>
 
</html>


      