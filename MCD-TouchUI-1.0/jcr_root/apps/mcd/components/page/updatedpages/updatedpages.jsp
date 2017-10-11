<HTML>
<%@ page import="java.util.Calendar,
        java.util.Locale,
        java.text.SimpleDateFormat,
        java.util.Iterator,
        org.apache.jackrabbit.util.Text"%>

<%@include file="/libs/wcm/global.jsp" %>
<head>
<title>Updated Content Pages Utility</title>
<script type="text/javascript" src="/apps/mcd/components/page/updatedpages/datetimepicker.js"> </script>
<style type="text/css">
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
}
table.pagetable td {
    white-space:nowrap;
    font-size: 14px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: dotted dotted dotted dotted;
}
</style>
</head>

<body>

<%!
int count;
public String drawChildTree (Page rootPage, int indent, long tm_cutdate, HttpServletRequest request){
    StringBuffer outBuffer = new StringBuffer("");
    indent = indent + 15;
    if (rootPage != null) {
        // code to retirieve the child pages of the selected page in the itertor object
        Iterator<Page> children = rootPage.listChildren();       
        try {
            while (children.hasNext()) {
                Page child = children.next();               
                             
                String lastModified = child.getProperties().get("cq:lastModified",String.class);
                String lastReplicated = child.getProperties().get("cq:lastReplicated",String.class);
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction",String.class);
                
                long tm_lastModified = -1;
                long tm_lastReplicated = -1;
                
                if(child.getProperties().get("cq:lastModified",Calendar.class)!=null){
                    Calendar cal_lastModified = child.getProperties().get("cq:lastModified",Calendar.class);
                    tm_lastModified = cal_lastModified.getTimeInMillis();
                }
                
                if(child.getProperties().get("cq:lastReplicated",Calendar.class)!=null){
                    Calendar cal_lastReplicated = child.getProperties().get("cq:lastReplicated",Calendar.class);
                    tm_lastReplicated = cal_lastReplicated.getTimeInMillis();
                }
                
                boolean isModified = tm_lastModified > tm_cutdate;
                boolean isReplicated = tm_lastReplicated > tm_cutdate;
                
                String style = "";
                
                if(isModified || isReplicated){    
                    if("Deactivate".equals(lastReplicationAction)){             
                        style = "style=\"color:red\"";
                    }
                       
                    String pathtoinclude=child.getPath();
                    
                    outBuffer.append("<tr "+style+">");
                    outBuffer.append("<td>" + ++count +"</td>");
                    outBuffer.append("<td><div style=\"margin-left:" + indent +"px;\"><img src=\"/apps/mcd/components/page/updatedpages/bullet.gif\"/>&nbsp;&nbsp;"+pathtoinclude+"</td>");
                    outBuffer.append("<td>"+lastModified+"</td>");
                    outBuffer.append("<td>"+lastReplicated+"</td>");
                    outBuffer.append("<td>"+lastReplicationAction + "</td>");
                    outBuffer.append("</tr>");
                }
                outBuffer.append(drawChildTree(child,indent,tm_cutdate,request));
            }
        } finally {         
             
        }
    }
    // return the html code as string //
    return outBuffer.toString();
}
%>
<form action="#">
    <input type="hidden" name="hidAction" value="Clear"/>
    <h3>Updated Content Pages Utility</h3>
    <p style="margin-top:-16px;">
       &nbsp;&nbsp;&nbsp; List content pages <b>Modified</b> (Created/Edited) OR <b>Replicated</b> (Activated/Deactivated) under Root Path after a particular date
    </p>
    <hr style="margin-top:-8px;">
    <br><b>
    &nbsp;&nbsp;&nbsp;Enter Root &nbsp;:&nbsp;&nbsp;</b>
    <input type="text" name="rootPath" id="rootpath" value="/content/accessmcd"></input>
    <br>
    <span><i style="font-size: 13px; padding-left: 10px;">DEFAULT : Absolute Parent at level 1</i></span>
    <br><br><b>
    &nbsp;&nbsp;&nbsp;Select Date :&nbsp;&nbsp;</b>
    <input type="text" name="incDate" id="incidentDate" readonly></input>&nbsp;
    <a href="javascript:NewCal('incidentDate','yyyymmdd',true,24)">
      <img src="/apps/mcd/components/page/updatedpages/cal.gif" alt="Pick a date" width="20" height="20" border="0"/>
    </a>
    &nbsp;&nbsp;&nbsp;
    <input type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="ShowInfo" />
    <input type="submit" onclick="this.form.hidAction.value='clear';" value="Clear" />
    <br>
    <span><i style="font-size: 13px; padding-left: 10px;">DEFAULT : Current Date</i></span>
    <br><br>
    
<%  
    String hidAction = (String) request.getParameter("hidAction");
    if(hidAction != null) 
    {
      if(hidAction.equals("ShowInfo")) 
      { 
        String rootPath = (String) request.getParameter("rootPath");
        
        if (!(rootPath.length() > 0)) {
            rootPath = Text.getAbsoluteParent(currentPage.getPath(), 1);
        }
        
        String userDate =  request.getParameter("incDate");
        int year, month, day, hrs, mins, sec;
        count=0;
        Calendar cal_lastcutdate = Calendar.getInstance();
        
        if (userDate.length() == 19) {
            
            year = Integer.parseInt(userDate.substring(0,4));
            month = Integer.parseInt(userDate.substring(5,7));
            day = Integer.parseInt(userDate.substring(8,10));
           
            hrs = Integer.parseInt(userDate.substring(11,13));
            mins = Integer.parseInt(userDate.substring(14,16));
            sec = Integer.parseInt(userDate.substring(17,19));
                        
            //Clear all fields
            cal_lastcutdate.clear();
            
            /*
            Calendar.set(int year, int month, int date, int hourOfDay, int minute, int second)
            Month value is 0-based. e.g., 0 for January. So, deduction 1 from month value.      
            */
            cal_lastcutdate.set(year,(month-1),day,hrs,mins,sec);

        } else {
            // take current date as default
        }
        
        //2010-05-06T11:11:23.000+0530  - Utility Format
        //2010-05-06T11:11:23.563+05:30 - DAY Crx Format
        
        SimpleDateFormat sdf =new SimpleDateFormat ("yyyy-MM-dd'T'HH:mm:ss.SSSZ",Locale.US );
        String lastcutdate = sdf.format(cal_lastcutdate.getTimeInMillis());
        
        long tm_lastcutdate = cal_lastcutdate.getTimeInMillis();
%>
        <div class="text">    
<%              
        out.println("<br>Updated Content Pages under <b>"+rootPath+"</b> after [<b>"+ lastcutdate +"</b>] are -<br><br>");
        Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(rootPath);
%>
        <table class="pagetable">
        <tr>
            <th>S.No</th>
            <th>Page Handle</th>
            <th>Last Modified Date</th>
            <th>Last Replicated Date</th>
            <th>Last Replication Action</th>
        </tr>
<% 
        out.println(drawChildTree(rootPage,0,tm_lastcutdate,request));
%>
        </table>  
        </div>    
<%              
      } 
    }
%> 
</form>

</body>
</HTML>