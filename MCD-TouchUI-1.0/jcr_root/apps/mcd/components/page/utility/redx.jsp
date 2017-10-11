<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
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
        com.day.cq.security.*"%>
<%@include file="/apps/mcd/global/global.jsp" %>            
<HEAD>
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>    
<TITLE> DAM RED X Report Utility </TITLE>
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
    
    String nDays = (String)request.getParameter("ndays");
    if( nDays == null ){
        nDays = "";        
    }
    String showNoErrorMessage = "yes";
    String exceptionPath = "";
%>    
    <a name="top"></a>
    <div style="width:100%;padding-top:5px;"><img  src='/images/accessmcd.gif' /></div>
    
    <form id="report" name="report" action="#" style="margin-top: -45px;">
        <table border=0 width="100%"  style="margin-top:10px"><tr><td align="right"><font size="2" color="red">Logged In User:&nbsp;<b><%=user.getName()%></b></font></td></tr> </table>
        
        <input type="hidden" name="hidAction" value="Clear"/>
        
        <h3>DAM Asset RED X Report Utility</h3>
        <br>
        <p style="margin-top:-20px;text-align:center;">
            <i>The Report Utility will only list the assets that are in the RED X state.</i>
        </p>           
        <hr style="margin-top:-8px;">
        <br>
        
        <b>&nbsp;Enter the path of a DAM folder:&nbsp;&nbsp;</b>
        <input type="text" name="rootPath" id="rootpath" value='<%=rootPath %>' size="40px"></input>    
        <br>
        <label style="font-size:12px"> &nbsp;The path should start with "/var/dam/accessmcd".</label> <br>
        <label style="font-size:12px;color:#808080;"> &nbsp;<b>Note:</b> Please dont append .html to the path entered </label> <br>
        <br>
        
        <b>&nbsp;Enter number of days:&nbsp;&nbsp;</b>
        <input type="text" name="ndays" id="ndays" value='<%=nDays%>' size="40px"></input>    
        <br>
        <label style="font-size:12px"> &nbsp;For how many days you want to generate report from current day.</label> <br>
        <br>
        
        <input id = "ShowInfo" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="ShowInfo" />
        <input id = "Clear" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Clear';" value="Clear" />    
        <br><br>
        <hr style=""> 
<%
        try{
            String hidAction = (String) request.getParameter("hidAction");
            if(hidAction != null){
                if(hidAction.equals("ShowInfo")){
                    if((!(rootPath != null)) || (!(rootPath.length() > 0))){
                        //errMsg = "Please provide the path.";
                        out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Please provide the path. </span></b></p>");
                    }
                    else if("".equals(nDays)){
                        out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Please provide number of days. </span></b></p>");
                    }  
                    else{        
                        if(rootPath.startsWith("/var/dam")){
                            Map<String, String> map = new HashMap<String, String>();
                            QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
                            Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
                            //create query description as hash map (simplest way, same as form post)
                            map.put("path", rootPath);
                            map.put("type", "nt:file");
                            map.put("1_property","jcr:created");
                            
                            map.put("daterange.property", "jcr:created");
                                    
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            long daysecs = 24*60*60*1000;
                            int daycount = Integer.parseInt(nDays);
                            String startdate = sdf.format((new Date()).getTime()+((1-daycount)*daysecs));
                            out.println("<b>Start Date ::</b> " + startdate);
                            
                            map.put("daterange.lowerBound", startdate);
                            //map.put("rangeproperty.upperOperation", "xs:dateTime('2011-03-15T00:00:00.000Z')");
                                       
                            map.put("orderby", "@jcr:created");
                            map.put("orderby.sort", "desc");
                            
                            // can be done in map or with Query methods
                            //map.put("p.offset", "0"); // same as query.setStart(0) below
                            map.put("p.limit", "-1"); // same as query.setHitsPerPage(20) below
                            
                            Query query = builder.createQuery(PredicateGroup.create(map), jcrSession);
                            //query.setStart(0);
                            //query.setHitsPerPage(20);
                            
                            SearchResult result = query.getResult();
                             
                            // paging metadata
                            int hitsPerPage = result.getHits().size(); // 20 (set above) or lower
                            long totalMatches = result.getTotalMatches();
                            long offset = result.getStartIndex();
                            long numberOfPages = totalMatches / 20;
                            
                            //Place the results in XML to return to client
                            /*DocumentBuilderFactory factory =     DocumentBuilderFactory.newInstance();
                            DocumentBuilder builder = factory.newDocumentBuilder();
                            Document doc = builder.newDocument();
                            
                            //Start building the XML to pass back to the AEM client
                            Element root = doc.createElement( "results" );
                            doc.appendChild( root );*/
%>                        
                            <table class="pagetable" width="100%" cellpadding="0" cellspacing="1" border="1"> 
                                <tr>  
                                    <th>S.No</th>
                                    <th>Asset Path</th>
                                    <th>Created Date</th>
                                </tr>    
<%                        
                            // iterating over the results
                            int count = 1;
                            for (Hit hit : result.getHits()) {
                                String path = hit.getPath();
                                exceptionPath = path;
                                ValueMap properties1 = hit.getProperties();
                                /*for(Map.Entry<String, Object> e : properties1.entrySet()) {
                                    String key = e.getKey();
                                    Object value = e.getValue();
                                }
                                out.println("<hr>");*/
                                String createdDate = properties1.get("jcr:lastModified","");
                                try{
                                Node rootNode = slingRequest.getResourceResolver().getResource(path.replaceAll("/var","/content")).adaptTo(Node.class);
                                //Node root = jcrSession.getRootNode();
                                //Node rootNode = root.getNode(path.replaceAll("/var","content")); 
                                /*if(rootNode == null){*/
%>        
                                    <%--<tr>
                                        <td><%=count%></td>
                                        <td><%=path%></td>
                                        <td><%=createdDate%></td>
                                    </tr>--%>
<%                           
                                    /*count++;
                                    showNoErrorMessage = "no";
                                }*/
                                }   
                                catch(Exception ex1){
%>
                                    <tr>
                                        <td><%=count%></td>
                                        <td><%=path.replaceAll("/var","/content")%></td>
                                        <td><%=createdDate%></td>
                                    </tr>
<%                                
                                    count++;
                                    showNoErrorMessage = "no";
                                    continue;
                                } 
                            } 
%>
                            </table>
<%                          
                            if("yes".equals(showNoErrorMessage)){
                                out.println("<h3 style='color:#AA1E1B;'> There is no RED X issue reported in last " + nDays + " days </h3>");
                            }
                        }
                        else{
                            out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Path entered is invalid. </span></b></p>");
                        }
                    }  
                }
            }
        }
        catch(Exception ex){
            //out.println("<br>Excpetion occured for path :: " + exceptionPath);
        } 
        
%>     
    </form>

<script>
    $('#Clear').click(
        function(){
            $('#rootpath').val('');
        }
    );
</script>

</BODY>
</HTML>       