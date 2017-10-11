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
<title>Test PCI2 DB Query</title>
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
    out.println("<h1>PCI 2.0 Query</h1><br>");

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
   
    if(categoryID==null)categoryID="";
    if(audience==null)audience="";
    if(topStoryCategoryID==null)topStoryCategoryID="";
    if(resultCount==null)resultCount="10";
    if(viewType==null)viewType="";
    if(sortType==null)sortType="rchrono";
    if(displayType==null)displayType="XML";
    if(fromDate==null)fromDate="";
    if(toDate==null)toDate="";
    
    if(entityType==null)entityType="ENT";
    
    out.println("<FORM name=\"pciquery\" action=\"\" method=\"GET\">");

    out.println("<B>Category ID:</B><INPUT id=\"categoryID\" name=\"categoryID\" value=\""+categoryID+"\">");

    out.println("<SELECT id=\"catidsetter\" onchange='$(\"#categoryID\").val($(\"#catidsetter\").val());'>");
    out.println("<OPTION value=\"0\" ></OPTION>");
    out.println("<OPTION value=\"1000\" >Australia Homepage Calendar</OPTION>");
    out.println("<OPTION value=\"20051\" >News From Around The World</OPTION>");
    out.println("<OPTION value=\"20052\" >Featured Story</OPTION>");
    out.println("<OPTION value=\"20053\" >Interactive Portlet</OPTION>");
    out.println("<OPTION value=\"30101\" >Inside MCD USA</OPTION>");
    out.println("<OPTION value=\"31101\" >Inside MCD USA Top Story</OPTION>");
    out.println("<OPTION value=\"30009\" >Inside Chicago Region</OPTION>");
    out.println("<OPTION value=\"31009\" >Inside Chicago Region Top Story</OPTION>");
    out.println("<OPTION value=\"1056\" >Site Finder</OPTION>");
    out.println("<OPTION value=\"20113\" >PCI Testing</OPTION>");
    out.println("<OPTION value=\"25007\" >Japan Category</OPTION>");
    out.println("</SELECT><BR>");
 
    out.println("<BR>");

    out.println("<B>Entity:</B><SELECT name=\"entityType\" >");
    out.println("<OPTION value=\"AU\" "+ (entityType.equals("ENT")?"SELECTED":"")+">Australia</OPTION>");
    out.println("<OPTION value=\"ENT\" "+ (entityType.equals("ENT")?"SELECTED":"")+">Global</OPTION>");
    out.println("<OPTION value=\"JA\" "+ (entityType.equals("JA")?"SELECTED":"")+">Japan</OPTION>");
    out.println("<OPTION value=\"US\" "+ (entityType.equals("US")?"SELECTED":"")+">US</OPTION>");
    out.println("</SELECT><BR>");


    out.println("<B>Audience:</B><SELECT name=\"audience\" >");
    out.println("<OPTION value=\"\" >Select Audience</OPTION>");
    out.println("<OPTION value=\"CorpEmployees\" "+ (audience.equals("CorpEmployees")?"SELECTED":"")+">CorpEmployees</OPTION>");
    out.println("<OPTION value=\"Crew\" "+ (audience.equals("Crew")?"SELECTED":"")+">Crew</OPTION>");
    out.println("<OPTION value=\"Franchisees\" "+ (audience.equals("Franchisees")?"SELECTED":"")+">Franchisees</OPTION>");
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
    out.println("<OPTION value=\"chrono\" "+ (sortType.equals("chrono")?"SELECTED":"")+">chrono</OPTION>");
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
    out.println("<h2>PCI Results..</h2><br>");
    
    
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
    SimpleDateFormat sdf=new SimpleDateFormat("M/d/yyyy");
    try{
        Date dtFromDate=sdf.parse(fromDate);
        pciquery.setFromDate(dtFromDate);
        Date dtToDate=sdf.parse(toDate);
        dtToDate.setHours(23);
        dtToDate.setMinutes(59);
        dtToDate.setSeconds(59);
        out.println("<br>Todate :: "+dtToDate);
        pciquery.setToDate(dtToDate);
    }catch(Exception e){
    }
    
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
        out.println("<TABLE>");
        out.println("<TR>");
        out.println(td("<B>#</b>"));
        out.println(td("<B>Title</b>"));
        out.println(td("<B>Publish Date</b>"));
        out.println(td("<B>URI</b>"));
        out.println(td("<B>Thumbnail</b>"));
        out.println(td("<B>Image</b>"));
        out.println(td("<B>Media</b>"));
        out.println(td("<B>Audience</b>"));
        out.println("</TR>");
        
        for(int ix=0;ix<results.length;ix++){
            out.println("<TR>");
            out.println(td(""+(ix+1)));
            com.mcd.accessmcd.pci.bo.PCIResult result=results[ix];
            out.println(new String(td(result.getDocumentTitle()).getBytes("UTF-8"),"UTF-8"));
            out.println(td(result.getPublishDate()));
            out.println(td(result.getPageURI()));
            out.println(td(result.getThumbnailURI()));
            out.println(td(result.getImageURI()));
            out.println(td(result.getMediaURI()));
            out.println(td(result.getAudienceType()));
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
