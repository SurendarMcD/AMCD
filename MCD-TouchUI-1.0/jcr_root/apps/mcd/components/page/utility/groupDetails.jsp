<%-- 
  ==============================================================================
  Group Detail Form
  ==============================================================================
--%>  
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<html>
    <head>
        <script language="javascript" src="/apps/mcd/docroot/scripts/flot/jquery-1.4.1.min.js"></script>
        <title>Group Details</title>
    </head>
    <body>
        <div id="selectGroup">
            <form name="groupForm" action="javascript:fetchGroupDetails();">
                <table width="50%" style="margin-left:25%;" border="1">
                    <tr>
                        <td align="center" width="50%">
                            <label>Please select the type of groups</label>
                        </td>
                        <td align="center" width="50%">
                            <select name="groupType">
                                <option value="author">Author</option>
                                <option value="publish">Publish</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div id="groupDetails">
        </div>
        <script>
            function fetchGroupDetails(form){
                console.log(document.querySelector('[name="groupType"]').value);
                var path = '<%=currentPage.getPath()%>.groupUserMapping.html?type='+document.querySelector('[name="groupType"]').value;
                $.ajax({
                    url: path,
                    success: function(data) {
                        $("#groupDetails").html(data);
                    }
                });
                //alert('Hi'+form.groupType);
            }
        </script>
    </body>
</html>