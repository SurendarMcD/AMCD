<%@ page contentType="application/vnd.ms-excel"%>
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

<%
    String rootPath = (String)request.getParameter("rootPath");
    if( (!(rootPath != null)) || (!(rootPath.length() > 0)) ){
        rootPath = "";        
    }
    
    String comppath = (String)request.getParameter("comppath");
    if( comppath == null ){
        comppath = "";        
    }
    
    String reportType = (String)request.getParameter("reporttype");
    if( reportType == null ){
        reportType = "";        
    }
    
    String showNoErrorMessage = "yes";
    String exceptionPath = "";
        try{
            
            if(rootPath.startsWith("/content/accessmcd")){
                response.setHeader("Content-Disposition", "attachment; filename=\"AccessMcD-ComponentReferencesReport.xls\"");  
                if("shsummary".equals(reportType)){
                    Node compRootNodeSumm = slingRequest.getResourceResolver().getResource("/apps/mcd/components/content").adaptTo(Node.class);
                    NodeIterator nodeIteratorSumm = compRootNodeSumm.getNodes();
%>
                    <table class="pagetablesumm" id="pagetablesumm" width="100%" cellpadding="0" cellspacing="1" border="1"> 
                        <thead>
                            <tr>  
                                <th>Component Name</th>
                                <th>Page Count</th>
                            </tr>
                        </thead>
                        <tbody>  
<%                    
                    int count = 1;
                    while(nodeIteratorSumm.hasNext()){
                        Node compNode = nodeIteratorSumm.nextNode();
                        String compTitle = compNode.getProperty("jcr:title").getString();
                        String compPath = compNode.getPath().replaceAll("/apps/","");
                        Map<String, String> map = new HashMap<String, String>();
                        QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
                        Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
                        //create query description as hash map (simplest way, same as form post)
                        map.put("path", rootPath);
                        map.put("1_property","sling:resourceType");
                        map.put("1_property.value",compPath);
                        map.put("1_property.operation","like");
                        map.put("p.limit", "-1"); // same as query.setHitsPerPage(20) below
                        
                        Query query = builder.createQuery(PredicateGroup.create(map), jcrSession);
                        SearchResult result = query.getResult();
                         
                        ArrayList pageList = new ArrayList();
                        for (Hit hit : result.getHits()) {
                            String pagePath = hit.getPath().substring(0,hit.getPath().indexOf("jcr:content")-1);
                            pageList.add(pagePath);
                        }
                        HashSet hs = new HashSet(); 
                        hs.addAll(pageList); 
                        pageList.clear(); 
                        pageList.addAll(hs);
                        Collections.sort(pageList);
                        
                        // paging metadata
                        int compCount = pageList.size();
%>
                        <tr>
                            <td><%=compTitle%></td>
                            <td><%=compCount%></td>
                        </tr>
<%                        
                    }
%>
                        </tbody>
                    </table>
<%                
                }
                else{
                    Map<String, String> map = new HashMap<String, String>();
                    QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
                    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
                    //create query description as hash map (simplest way, same as form post)
                    map.put("path", rootPath);
                    map.put("1_property","sling:resourceType");
                    map.put("1_property.value",comppath);
                    map.put("1_property.operation","like");
                    map.put("p.limit", "-1"); // same as query.setHitsPerPage(20) below
                    
                    Query query = builder.createQuery(PredicateGroup.create(map), jcrSession);
                    SearchResult result = query.getResult();
                     
                    // paging metadata
                    int hitsPerPage = result.getHits().size(); // 20 (set above) or lower
                    long totalMatches = result.getTotalMatches();
                    long offset = result.getStartIndex();
                    long numberOfPages = totalMatches / 20;
                    
                    ArrayList pageList = new ArrayList();
                    for (Hit hit : result.getHits()) {
                        String pagePath = hit.getPath().substring(0,hit.getPath().indexOf("jcr:content")-1);
                        pageList.add(pagePath);
                    }
                    HashSet hs = new HashSet(); 
                    hs.addAll(pageList); 
                    pageList.clear(); 
                    pageList.addAll(hs);
                    Collections.sort(pageList);
%>                        
                    <table class="pagetable" width="100%" cellpadding="0" cellspacing="1" border="1"> 
                        <tr>  
                            <th>Page Path</th>
                        </tr>    
<%                        
                    // iterating over the results
                    int count = 1;
                    for (int i = 0; i < pageList.size(); i++) {
                        String path = pageList.get(i).toString();
                        try{   
%>                                  
                            <tr>
                                <td><%=path%></td>
                            </tr>
<%                           
                            count++;
                        }   
                        catch(Exception ex1){
                           
                        } 
                    } 
%>
                    </table>
<%                          
                }
            }
            else{
                out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Path entered is invalid. </span></b></p>");
            }
                    
        }
        catch(Exception ex){
            //out.println("<br>Excpetion occured for path :: " + exceptionPath);
        } 
        
%>     

