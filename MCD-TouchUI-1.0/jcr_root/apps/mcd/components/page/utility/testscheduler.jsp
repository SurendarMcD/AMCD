<%--
  ==============================================================================
  Test service
  
  Judy Zhang 10/2010 
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                java.lang.*,
                java.util.Date,
                java.util.Calendar,
                java.text.SimpleDateFormat,
                com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
                javax.jcr.Session, 
                org.apache.sling.jcr.api.SlingRepository,
                java.util.Enumeration,
                com.mcd.accessmcd.ace.scheduler.MCDACEScheduler,
                com.day.cq.security.*"%>

                  
<html>

<head> 

<title>ACE Test Scheduler </title>
<script Language="JavaScript">

function isValid() { 
    var myForm=document.acetestform;
    
    if (myForm.testDate.value==null||myForm.testDate.value =="")
    {
        alert("Please enter a valid date.");
        return false;
    }
}

</script>

</head>
<body >

<table cellpadding="2" cellspacing="5" border=0 align="center" class="text">
    <tr>
        <td>

<%!

    private static String dateFormat ="dd.MM.yyyy HH:mm:ss";

%>
    
<% 
        try {
            SlingRepository repo = sling.getService(SlingRepository.class);


            String pmURL=request.getParameter("testDate");
            String testURL=request.getParameter("testURL");
            String testToEmail=request.getParameter("testToEmail");
            String testCCEmail=request.getParameter("testCCEmail");
            String testResult = "";

            if(pmURL!=null && !pmURL.equals("null") && pmURL.trim().length()>0 &&
                testURL!=null && !testURL.equals("null") && testURL.trim().length()>0 &&
                testToEmail!=null && !testToEmail.equals("null") && testToEmail.trim().length()>0 &&
                testCCEmail!=null && !testCCEmail.equals("null") && testCCEmail.trim().length()>0)
            {            
                 SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
                 Date d = sdf.parse(pmURL);
                 MCDACEScheduler myTest = new MCDACEScheduler();
                 myTest.test(d,testURL,testToEmail,testCCEmail,sling);
                 testResult = "<BR><BR>Test completed.<BR>";
            }     
   
            
            String retString="<H1>ACE Test Scheduler </H1><BR>"; 
            retString+="<FORM id=\"acetestform\" name=\"acetestform\" action=\"/content/utility/utility/_jcr_content.testscheduler.html\" method=\"get\" onsubmit=\"javascript:isValid();\">";
            retString+="<B>Test Date : </B><INPUT name=\"testDate\" value=\""+pmURL+"\"><BR>";
            retString+="<B>Test URL : </B><INPUT name=\"testURL\" value=\""+testURL+"\"><BR>";
            retString+="<B>To Address : </B><INPUT name=\"testToEmail\" value=\""+testToEmail+"\"><BR>";
            retString+="<B>CC Address : </B><INPUT name=\"testCCEmail\" value=\""+testCCEmail+"\"><BR>";
            retString+="<BR><INPUT type='submit' value='submit' /><BR>";
            retString+="<BR><BR><BR>Please enter test date in dd.MM.yyyy HH:mm:ss format.";
            retString+="<BR>Example: 01.04.2011 16:00:00<BR>";
            retString+="<BR>Please enter test url.";
            retString+="<BR>Example:<ul><li>/content/accessmcd</li><li>/content/accessmcd/corp</li><li>/content/accessmcd/apmea/au</li><li>/content/accessmcd/corp/test</li></ul>";
            out.write(retString);
            out.write(testResult);
            out.write("</FORM>");
        }catch (Exception e) {
            out.write("Please enter valid date");
 //           e.printStackTrace();
        }
%>

        </td>
    </tr>
</table>

</body>

</html>

  