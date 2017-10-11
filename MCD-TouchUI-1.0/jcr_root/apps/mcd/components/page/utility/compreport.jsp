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
<script type="text/javascript" src="/scripts/tablesorter.js"></script>    
<TITLE> Component Report Utility </TITLE>
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
        table.pagetable.td p { 
           display: block;
            margin-top: 1em;
            margin-bottom: 1em;
            margin-left: 0;
            margin-right: 0;
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
        #ajaxSpinnerImage {
           display: none;
        }
        table.pagetablesumm {
            border-width: 1px 1px 1px 1px;
            border-spacing: 0px;
            border-style: solid solid solid solid;
            border-color: black black black black;
            border-collapse: collapse;
        }
        table.pagetablesumm th {
            font-weight:bold;
            border-width: 1px 1px 1px 1px;
            padding: 5px 5px 5px 5px;
            border-style: solid solid solid solid;
            background-color: #EEEEEE;
            color: #802A2A;
            font-size: 12px;
        }
        table.pagetablesumm td {
            font-size: 11px;
            border-width: 1px 1px 1px 1px;
            padding: 5px 5px 5px 5px;
            border-style: dotted dotted dotted dotted;
        }
        table.pagetablesumm.td p { 
           display: block;
            margin-top: 1em;
            margin-bottom: 1em;
            margin-left: 0;
            margin-right: 0;
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
    
    String comppath = (String)request.getParameter("comppath");
    if( comppath == null ){
        comppath = "";        
    }
    
    String reportType = (String)request.getParameter("repstatus");
    if( reportType == null ){
        reportType = "";        
    }
    String showNoErrorMessage = "yes";
    String exceptionPath = "";
%>    
    <a name="top"></a>
    <div style="width:100%;padding-top:5px;"><img  src='/images/accessmcd.gif' /></div>
    
    <form id="report" name="report" action="#" style="margin-top: -45px;">
        <table border=0 width="100%"  style="margin-top:10px"><tr><td align="right"><font size="2" color="red">Logged In User:&nbsp;<b><%=user.getName()%></b></font></td></tr> </table>
        
        <input type="hidden" name="hidAction" value="Clear"/>
        
        <h3>Component Report Utility</h3>
        <br>
        <p style="margin-top:-20px;text-align:center;">
            <i>The Report Utility will display list of pages for selected component.</i>
        </p>           
        <hr style="margin-top:-8px;">
        <b>&nbsp;Select Report Type :&nbsp;&nbsp;</b>
        <input type="radio" class="radio-button" name="repstatus" value="shinfo">Show Info
        <input type="radio" class="radio-button" name="repstatus" value="shsummary">Show Summary
        <br><br>
        
        <b>&nbsp;Enter the path of a content folder:&nbsp;&nbsp;</b>
        <input type="text" name="rootPath" id="rootpath" value='<%=rootPath %>' size="40px"></input>    
        <br>
        <label style="font-size:12px"> &nbsp;The path should start with "/content/accessmcd".</label> <br>
        <label style="font-size:12px;color:#808080;"> &nbsp;<b>Note:</b> Please dont append .html to the path entered </label> <br>
        <br>
        
        <span id="complabel"><b>&nbsp;Enter component path:&nbsp;&nbsp;</b></span>
        <select id="comppath" name="comppath">
            <option value="noval">Please select component</option>
        
<%
            Node compRootNode = slingRequest.getResourceResolver().getResource("/apps/mcd/components/content").adaptTo(Node.class);
            NodeIterator nodeIterator = compRootNode.getNodes();
            while(nodeIterator.hasNext()){
                Node compNode = nodeIterator.nextNode();
                String compTitle = compNode.getProperty("jcr:title").getString();
                String compPath = compNode.getPath().replaceAll("/apps/","");
%>
                <option value="<%=compPath%>"><%=compTitle%></option>
<%                
            }
        
%>          
        </select>
        <br>
        <label style="font-size:12px" id="compnote"> &nbsp;Component path for which you want to generate report</label> <br>
        <br>
        
        <input id="ShowInfo" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="Show Info" />
        <input id="ShowSummary" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='ShowSummary';" value="Show Summary" />
        <input id="Clear" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Clear';" value="Clear" />    
        <input id="Export" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Export';" value="Export To Excel" />
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
                    else if("a".equals(comppath)){
                        out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Please provide component path. </span></b></p>");
                    }  
                    else{        
                        if(rootPath.startsWith("/content/accessmcd")){
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
                            //query.setStart(0);
                            //query.setHitsPerPage(20);
                            
                            SearchResult result = query.getResult();
                             
                            // paging metadata
                            int hitsPerPage = result.getHits().size(); // 20 (set above) or lower
                            long totalMatches = result.getTotalMatches();
                            long offset = result.getStartIndex();
                            long numberOfPages = totalMatches / 20;
                            //out.println("Hits :: " + hitsPerPage + " Total Matches :: " + totalMatches + "<br>");
                            
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
                                    <th>S.No</th>
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
                                        <td><%=count%></td>
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
                        else{
                            out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Path entered is invalid. </span></b></p>");
                        }
                    }  
                }
                else if(hidAction.equals("ShowSummary")){
                    if((!(rootPath != null)) || (!(rootPath.length() > 0))){
                        //errMsg = "Please provide the path.";
                        out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'> Please provide the path. </span></b></p>");
                    }
                    else{
                        if(rootPath.startsWith("/content/accessmcd")){
                            Node compRootNodeSumm = slingRequest.getResourceResolver().getResource("/apps/mcd/components/content").adaptTo(Node.class);
                            NodeIterator nodeIteratorSumm = compRootNodeSumm.getNodes();
%>
                            <table class="pagetablesumm" id="pagetablesumm" width="100%" cellpadding="0" cellspacing="1" border="1"> 
                                <thead>
                                    <tr>  
                                        <th>S.No</th>
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
                                        <td><%=count%></td>
                                        <td><%=compTitle%></td>
                                        <td><%=compCount%></td>
                                    </tr>
<%                              
                                count++;
                            }
%>
                                    </tbody>
                            </table>
<%                            
                        }
                    }
                }
                else if(hidAction.equals("Export")) {
                    if(rootPath.startsWith("/content/accessmcd")){
                        String url = "/utility/utility.compReportExport.html?rootPath="+rootPath+"&comppath="+comppath+"&reporttype="+reportType;
                        response.sendRedirect(url);
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
    $(document).ready(function() {
        $("#pagetablesumm").tablesorter(); 
        sortDropDownListByText("#comppath", "Please select component","<%=comppath%>")
    
        $('input[type="radio"]').click(function(){
            if($(this).attr("value")=="shinfo"){
                $("#comppath").show();
                $("#complabel").show();
                $("#compnote").show();
                $("#ShowInfo").show();
                $("#ShowSummary").hide();
                $("#Clear").show();
                $("#Export").show();
            }
            else if($(this).attr("value")=="shsummary"){
                $("#comppath").hide();
                $("#complabel").hide();
                $("#compnote").hide();
                $("#ShowInfo").hide();
                $("#ShowSummary").show();
                $("#Clear").show();
                $("#Export").show();
            }
        }); 
        
        var reportType = "<%=reportType%>";
        
        if(reportType == "shinfo"){
            $("#ShowInfo").show();
            $("#ShowSummary").hide();
            $("#Clear").show();
            $("#Export").show();
            $('input[name=repstatus]').val(['shinfo']);
            $("#comppath").show();
            $("#complabel").show();
            $("#compnote").show();
        }
        else if(reportType == "shsummary"){
            $("#ShowInfo").hide();
            $("#ShowSummary").show();
            $("#Clear").show();
            $("#Export").show();
            $('input[name=repstatus]').val(['shsummary']);
            $("#comppath").hide();
            $("#complabel").hide();
            $("#compnote").hide();
        }
        else{
            $("#comppath").hide();
            $("#complabel").hide();
            $("#compnote").hide();
            $("#ShowInfo").hide();
            $("#ShowSummary").hide();
            $("#Clear").hide();
            $("#Export").hide();
        }
    });
    
    function sortDropDownListByText(selectId, dummyVal,comppath) {
        $(selectId).html($(selectId + " option").sort(function(a, b) {
            if (a.text == dummyVal) {
                return -1;
            }
            return a.text == b.text ? 0 : a.text < b.text ? -1 : 1
        }))
        if(comppath == ""){
            $("#comppath option:first").attr('selected','selected'); 
        }
        else{
            $('#comppath').val(comppath);
            //$('#comppath option[value='"+comppath+'"]').attr("selected", "selected");
        }    
    }
    
    
    
    
</script>

</BODY>
</HTML>       