<!DOCTYPE html>

<%@include file="/apps/mcd/global/global.jsp"%>
   

<%@ page import="java.util.ArrayList,
         java.util.Iterator,
         java.util.Date,
         com.day.cq.wcm.api.PageFilter,
         javax.jcr.Binary,javax.jcr.Node,javax.jcr.Session,org.apache.sling.jcr.api.SlingRepository,
         org.apache.sling.api.scripting.SlingScriptHelper,org.apache.sling.api.wrappers.SlingRequestPaths,
         com.day.cq.security.User,com.day.cq.security.Group,java.text.*
       "%> 
       
<html>
    
<meta http-equiv="Content-Type" content="text/html; utf-8">

<cq:includeClientLib categories="cq.wcm.edit" />
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>    

<link rel="stylesheet" type="text/css" href="/css/ext-all.css" />

<title>Component Report Utility</title>

<script type="text/javascript" src="/scripts/sling.js"></script>
<style type="text/css">

#CQ .button {
    background:#DFDFDF;
    -webkit-box-shadow:inset 0px -1px 5px -18px #ffffff;
    box-shadow:inset 0px -1px 5px -18px #ffffff;
    background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #ededed), color-stop(1, #dfdfdf) );
    background:-moz-linear-gradient( center top, #ededed 5%, #dfdfdf 100% );
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ededed', endColorstr='#dfdfdf');
    background-color:#ededed;
    border-radius:11px;
    border:1px solid #aaaaaa;
    display:inline-block;
    color:#777777;
    font-family:arial;
    font-size:11px;
    font-weight:bold;
    padding:3px 27px;
    text-decoration:none;
    text-shadow:-46px 1px 50px #ffffff
    cursor:pointer;
}.button:hover {
    background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #dfdfdf), color-stop(1, #ededed) );
    background:-moz-linear-gradient( center top, #dfdfdf 5%, #ededed 100% );
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#dfdfdf', endColorstr='#ededed');
    background-color:#dfdfdf;
}.button:active {
    position:relative;
    top:1px;
}
/* This imageless css button was generated by CSSButtonGenerator.com */
</style>
  <style>
    .cpathclass{
    align:right;
    width:400px;
    }
    
    .x-form-trigger {
    background:url("/content/dam/accessmcd/awesome_bar/corp/searchsite.jpg") no-repeat scroll center center lightgrey;
    border: 1px solid #B5B8C8;
    cursor: pointer;
    float: right;
    height: 17px;
    width: 18px;
    *margin-top:-19px;margin-top:-19px\9;

}
.x-form-item {
    display: block;
    margin-bottom: 15px;
    position: relative;
}
     .x-fit-item{
    
    
     //background: none repeat scroll 0 0 white;
    border-color: #C5C5C5 #99BBE8 #99BBE8;
    border-right: 1px solid #99BBE8;
    border-style: solid;
    border-width: 1px;
    height: 290px;
    overflow-y: auto;
    }

.x-panel-header {
    background: -moz-linear-gradient(center top , #DAE7F6, #CDDEF3 45%, #ABC7EC 46%, #ABC7EC 50%, #B8CFEE 51%, #CBDDF3) repeat scroll 0 0 #CBDDF3;
    border: 1px solid #99BBE8;
    color: #04468C;
    font-size: 10px;
    font-weight: bold;
    padding: 5px 4px 4px 5px;
}

.x-panel-body
 {
    background: none repeat scroll 0 0 white;
    border: 1px solid #99BBE8;
    color: black;
    height: 70px;
}
 .x-btn-mc{
    background-color: lightgrey;
    border-style: solid;
    border-width: 1px;
    padding: 2px; 
    margin:3px;
    font-size:12px;
    border-color:black;
    }
    .x-btn button {
    background: lightgrey;
    border: 0 none;
    margin: 0;
    outline: 0 none;
    overflow: hidden;
    padding: 0;
    vertical-align: bottom;
    width: auto;
    font-size:12px;
}

    fieldset { 
        border: 1px solid #B5B8C8;
        display: block;
        margin-bottom: 10px;
        padding: 10px; 
   }

legend {
    color: #15428B;
    font: 11px/16px bold tahoma,arial,verdana,sans-serif;
    padding: 0 3px;
  }
#CQ .reportlabel{
    margin-left:120px;
    font-size:12px;
    color:#15428B;
    font-weight:bold;
}
#CQ html, #CQ body, #CQ fieldset, #CQ input, #CQ p, #CQ blockquote, #CQ th, #CQ td {
    margin: auto;
    padding-left: 10px;
    padding-top:5px;
}
#CQ .x-panel-header-text{
    margin-left:0px;
}
#CQ .x-tree-node a span, #CQ .x-dd-drag-ghost a span {
    margin-left:0px;
    font-size:11px;
    font-weight:normal;
}
 </style>
  
</head>

   
<%
final User user = slingRequest.getResourceResolver().adaptTo(User.class); //instantiate User object

%>

<body style="background-color:#FFFDDF" id="CQ">
<table border=0 height="100%" width="100%" >
  <tr>
  <td width="100%" valign="top">
            <table border=0 width="100%" height="100%">
                <tr>
                    <td valign="top" width="100%">
                         <form name="auth1form" id="auth1form" >
                            <div style="color:red;font-size:12px;text-align:right;margin-top:0px\9; ">Logged In User:&nbsp;<span style="color:red;font-size:13px;font-weight:bold;margin-left:0px;"><%=user.getName()%></span></div>
                            <fieldset style="width:800px;margin-left:188px;margin-top:10px;height:50px;">
                                <legend>Report Type</legend>
                                   <span class="reportlabel">Find Components on Page(s) ? &nbsp;<input type="radio" id="pageselect" name="userselection" value="page" onclick="checkSelection();"> &nbsp;&nbsp;&nbsp;&nbsp;</span>
                                   <span class="reportlabel">Find Pages with Component ?&nbsp; <input type="radio" id="componentselect" name="userselection" value="component" onclick="checkSelection();"></span>
                            </fieldset>
                            
                         </form>
                    </td>  
                </tr>
                <tr>
                 <td align="top" valign="top"> 
                   <div id="pages" style="margin-top:15px;"></div>  
                </td>
               </tr>
            </table>
            <div id="grid-table" style="width:100%;height:100%"></div>  
    </td>
    </tr>
</table>  
</body>
<div id="temppageid">
    <div id="getpagereport" style="display:none;margin-top:10px;margin-left:205px;">
        <a href="#" style="float:left;" onclick="getPage('page','find')" class="button">Generate Report</a>
        <form id="pagerepform" name="pagerepform" method="get">    
            <a href="#" id="pagerep" style="margin-left:10px;" onclick="exportToExcel('pagerepform');" class="button">Export to Excel</a>
             <input type="hidden" name="pagereportpath" id="pagereportpath" value="" />
             <input type="hidden" name="childpage" id="childpage" value="" />
             <input type="hidden" name="pagereporttype" id="pagereporttype" value="" />
         </form>   
    </div>
</div>
<div id="tempcompid">
    <div id="getcompreport" style="display:none;margin-top:10px;margin-left:205px;">
        <a href="#" style="float:left;" onclick="getPage('comp','find')" class="button">Generate Report</a>
        <form id="comprepform" name="comprepform"  method="get">
            <a href="#" id="comprep" style="margin-left:10px;" onclick="exportToExcel('comprepform');" class="button">Export to Excel</a>
            <input type="hidden" name="comppagepath" id="comppagepath" value="" />
            <input type="hidden" name="comppath" id="comppath" value="" />
            <input type="hidden" name="compreporttype" id="compreporttype" value="" />
        </form>    
    </div>
</div>

<script>
    var User = CQ.Ext.data.Record.create([
        {name: 'name'}, 
        {name: 'email'} 
     ]);


     
  var userreader = new CQ.Ext.data.JsonReader({ root: 'components'     }, User);
  
  var userstore = new CQ.Ext.data.JsonStore({
     root:"components",      
     url: '<%=currentPage.getPath()%>.componentreport.components.html',
     totalProperty:'results',
     fields: ['component','path'], 
     autoLoad:true    
    });
  
   
   // Page Report Section
 
        var author1 =  new CQ.Ext.form.FormPanel({
            frame:false,
            renderTo: 'CQ',
            id:"pageinfo",
            bodyStyle:'padding:15px',
            width: '64%',
            height:90,
            style:'margin-left:205px;',
            fieldDefaults: {
                msgTarget: 'side',
                labelWidth: 128
            },
            defaultType: 'textfield',
            items:[
                { 
                    xtype:'browsefield',        
                    id:'ppath',
                    name:'ppath',
                    fieldClass:'cpathclass',
                    fieldLabel:'Enter Page Path',
                    maxLength:120,
                    width:'200px',
                    labelSeparator:':',
                    rootPath:'/content',
                    hideTrigger:false
                },
                { 
                    xtype:'checkbox',        
                    id:'childcheck',
                    name:'childcheck',
                    fieldClass:'cpathclass',
                    fieldLabel:'Child Pages',
                    maxLength:180,
                    width:'400px',
                    labelSeparator:':'
                }
            ],
            title: 'Find Components on Page(s)'
            
        });


    // Component Report Section
      
        var author1 =  new CQ.Ext.form.FormPanel({
            frame:false,
            bodyStyle:'padding:15px',
            renderTo: 'CQ',
            id:"compinfo",
            width: '64%',
            height:95,
            style:'margin-left:205px;',
            fieldDefaults: {
                msgTarget: 'side',
                labelWidth: 180
            },
            defaultType: 'textfield',
            items: [
                { 
                    xtype:'browsefield',        
                    id:'rootpath',
                    name:'rootpath',
                    fieldClass:'cpathclass',
                    fieldLabel:'Select Root Path',
                    maxLength:120,
                    width:'100%',
                    rootPath:'/content',
                    hideTrigger:false,
                    defaultValue : '/content/accessmcd'
                },
                new CQ.Ext.form.ComboBox({
                    xtype:'combo',
                    bodyStyle:'padding:15px 5px 0',
                    style:"width:350px;",
                    autoWidth:false,
                    name:'author1list',
                    id:'component',
                    editable:false,
                    hideTrigger: true,
                    fieldClass:'cpathclass',
                    fieldLabel:'Component Name',
                    mode:'local',      
                    minChars:1,
                    typeAhead:false,
                    store:userstore,
                    disableKeyFilter:true, 
                    enableKeyEvents:true,  
                    triggerAction: 'all', 
                    emptyText:'Select Component...',
                    displayField: "component",
                    valueField: "path",
                    listeners: 
                    { select: { fn:function(combo, record,index)
                    {
                    setComponentPath(combo);
                    }
                    } } 
                
                }),
                {                                                                                              
                    xtype: 'textfield',
                    hidden: true,
                    id:'compPath'
                }  
            ],
            title: 'Find Pages with Component'
        });


        
 var loading="<div id='loadingajax' style='margin-left:550px;margin-top:20px;'><img src='/images/ajax-loader.gif'></div>";
 
 
    function setComponentPath(combo) 
    {
     $("#compPath").val(combo.value);
    }
 
    
    function exportToExcel(excelID){
        
        /*alert("Path :: " + path);
        alert("Child :: " + child);
        alert("Form ID :: " + excelID);*/
        var url = "/mcd/compreport/exporttoexcel";
        var validationStatus = true;
        if(excelID == "pagerepform"){
            var path=document.getElementById("ppath").value;
            var child =document.getElementById("childcheck").checked;
            //url = "/mcd/compreport/exporttoexcel?pagepath="+path+"&childpage="+child+"&reporttype=page";
            
            if(jQuery.trim(path) == ''){
                alert("Please enter page path");
                validationStatus = false;
            }
            else{
                document.getElementById('pagereportpath').value = path;
                document.getElementById('childpage').value = child;
                document.getElementById('pagereporttype').value = "page";
                validationStatus = true;
            }     
            
        }
        else if(excelID == "comprepform"){
            var path=document.getElementById("rootpath").value;
            var component = $("#compPath").val();
            if(jQuery.trim(path) == '' || component == ''){
                alert("Please select root path and component name");
                validationStatus = false;     
            }
            else{
                document.getElementById('comppagepath').value = path;
                document.getElementById('comppath').value = component;
                document.getElementById('compreporttype').value = "comp";
                validationStatus = true;
            }
            //url = "/mcd/compreport/exporttoexcel?pagepath="+path+"&comppath="+component+"&reporttype=comp";
        }
        
        if(validationStatus == true){ 
            document.forms[excelID].action = url;
            document.forms[excelID].submit();
        }
    } 
    
    // function to fetch the results
    

    function getPage(user,action)
    {     
       
        if(user.split(' ').join('')=='page')
        {
            var path=document.getElementById("ppath").value;
            var child =document.getElementById("childcheck").checked;
            if(jQuery.trim(path) == '')
              {
               alert("Please enter page path");
               return;     
              }
         
            $('#newpageid').after(loading);
            var data=Sling.httpGet("<%=currentPage.getPath()%>.componentreport.request.html?path="+escape(path)+"&child="+escape(child)+"&type=page"); 
            var text=data.responseText;  
           
               $('#grid-table').hide();
                if(text.indexOf("norecordfound")<0){
                   $('#grid-table').html(data.responseText);
                  }
                else{
                $('#grid-table').html("No Record Found");
               // return;
               } 
                 $('#resultdiv').remove();   
                var resultHTML = "<div id='resultdiv' style='margin-left:205px;margin-top:10px;width:800px;'>" + $('#grid-table').html() + "</div>";
                $('#newpageid').after(resultHTML);    
                $('#loadingajax').remove();
                $('#resultdiv #grid-table').show();
          
           
        }
        
        
        if(user.split(' ').join('')=="comp")
        {
            var path=document.getElementById("rootpath").value;
            var component = $("#compPath").val();
            if(jQuery.trim(path) == '' || component == ''){
                alert("Please select Root Path or Component");
                return;     
            }
            $('#newcompid').after(loading);
            var data=Sling.httpGet("<%=currentPage.getPath()%>.componentreport.request.html?path="+escape(path)+"&component="+escape(component)+"&type=comp"); 
            var text=data.responseText;  
           
                $('#grid-table').hide();
                 if(text.indexOf("norecordfound")<0){
                   $('#grid-table').html(data.responseText);
                  }
               else{
                  $('#grid-table').html("<div style='font-weight:bold;font-size:16;margin-left:300px;'>No Records Found</div>");
              //    return;
               } 
                $('#resultcompdiv').remove();
                var resultHTML = "<div id='resultcompdiv' style='margin-left:205px;margin-top:10px;width:808px;'>" + $('#grid-table').html() + "</div>";
                $('#newcompid').after(resultHTML);  
                $('#loadingajax').remove();  
                $('#resultcompdiv #grid-table').show();
           
        }
    }

// Hide panel in Starting

   $('#pageinfo').hide();
   $('#compinfo').hide();
   $('#getpagereport').hide();
   $('#getcompreport').hide();
     


// Function to render the Panels depending on user selection
           
                 
        function checkSelection()
        {
         // page report selected
         if($("#pageselect").is(":checked"))
         {
            $('#pageinfo').show();
            $('#compinfo').hide();
            $('#newpageid').remove();
            var buttonHTML = "<div id='newpageid'>" + $('#temppageid').html() + "</div>";
            $('#resultcompdiv').remove();
            $('#pageinfo').after(buttonHTML);
            $('#temppageid #getpagereport').hide();
            $('#newcompid').remove();
            $('#newpageid #getpagereport').show();
            $('#newpageid').show();
            $('#newpageid').children("div").show();
             
            // $('#newpageid #getpagereport').css('display','block');
         }
        
         // Component Report Selected
         if(document.getElementById("componentselect").checked==true)
         {
           $('#pageinfo').hide();
           $('#compinfo').show();
           $('#newcompid').remove();
           var buttonHTML = "<div id='newcompid'>" + $('#tempcompid').html() + "</div>";
           $('#resultdiv').remove();
           $('#compinfo').after(buttonHTML );
           $('#tempcompid #getcompreport').hide();
           $('#newpageid').remove();
           $('#newcompid #getcompreport').show();
           $('#newcompid').show();  
            $('#newcompid').children("div").show();
         }
             
        }
        
    
    </script>

</html>

     