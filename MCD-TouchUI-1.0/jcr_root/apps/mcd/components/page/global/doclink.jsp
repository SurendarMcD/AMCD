<%@page session="false" %>
<%@page import="java.net.URLEncoder" %>
<%
     // Callback from DMC where document properties are returned
    String docUrl = request.getParameter("docUrl");// Doc URL
    String docTitle = URLEncoder.encode(request.getParameter("docTitle"));//Doc Title/File Name
    String docDesc = URLEncoder.encode(request.getParameter("docDesc"));// Doc Description
    String docIconUrl = request.getParameter("docIconUrl");// Doc Icon URL
    String cq_id = request.getParameter("parName");// Component Id
//[GA|05_2010],Judy, add doc size
    String docSize = request.getParameter("docSize");// Doc Size
//[GA|END] 

%>

<html>
<head><title>Document Linking - Callback</title></head>
<script language="JavaScript">
   // Method for updating dialog widgets and closing DMC window.
    function updateDialog(){       
        // index variable for component id 
        var index = 0;      
        // component id
        var cq_id = '<%=cq_id%>'; 

        // Code for updating the particular component wizards       
        var form = window.opener.document.forms;        
        for(var i=0;i<form.length;i++){
            if(cq_id==form[i].id){
                index = i;
            }
        }      

        // Code for retrieving form fields
        var openerDocumentUrl = window.opener.document.forms[index]["./documentURL"];
        var openerDocumentName = window.opener.document.forms[index]["./documentName"];
        var openerDocumentDesc = window.opener.document.forms[index]["./documentDesc"];
        var openerDocumentIcon = window.opener.document.forms[index]["./documentIcon"];
//[GA|05_2010],Judy, add doc size
        var openerDocumentSize = window.opener.document.forms[index]["./documentSize"];
//[GA|END] 

        // Code for updating the wizards in the dialog and closing the window.
        if(openerDocumentUrl!=null)
            openerDocumentUrl.value = '<%= docUrl%>';
        if(openerDocumentName!=null)
            openerDocumentName.value = '<%= docTitle%>';
        if(openerDocumentDesc!=null)
            openerDocumentDesc.value = '<%= docDesc%>';
        if(openerDocumentIcon!=null)
            openerDocumentIcon.value= '<%= docIconUrl%>';
//[GA|05_2010],Judy, add doc size
        if(openerDocumentSize!=null)
            openerDocumentSize.value= '<%= docSize%>';
//[GA|END] 
        window.close();
              
    }
    
</script>
<body onload="updateDialog();">
</body>
</html>