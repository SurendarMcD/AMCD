   <%-- 
  ==============================================================================
  User Maintenance Form
  ==============================================================================
--%>  
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,  
                java.io.*,
                javax.jcr.*,
                com.mcd.accessmcd.usermanagement.user.manager.UserMaintenanceManager,
                com.mcd.accessmcd.usermanagement.user.bo.UserDataBean,
                com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean,
                com.day.cq.security.*,
                com.mcd.accessmcd.usermanagement.util.GroupComparator"%>
<html>
<head>
 
<title>User Administration</title>
<script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery-1.4.1.min.js"></script>
<link rel="stylesheet" href="/css/usermaintenance.css" type="text/css" />
<cq:includeClientLib categories="granite.csrf.standalone" />                    
<%
       
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");

%> 
<%! 
    ArrayList groupList = new ArrayList(); 
    String instance = "Author";
%>

<% 
    final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
     
    UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
    User loggedInUser = slingRequest.getResourceResolver().adaptTo(User.class);
    ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());
    UserMaintenanceManager umManager = new UserMaintenanceManager(sling, bundle, jcrSession, uMgr, resourceResolver);
    
    Resource res= slingRequest.getResourceResolver().getResource("/apps/cq/core/config/maxLimit");
    Value pageSizeVal[]= null;
    if(null!=res)
    {
        Node pageSize=res.adaptTo(Node.class);
        pageSizeVal=pageSize.getProperty("maxLimitVal").getValues();
    }
    
    String instancePropFile = "UserMaintenanceConfig.properties"; 
    //String serverFilesPath = "/app/mcd/cms/wcm1_auth_stg/crx-quickstart/server/files/";
    
    //PROD AUTH PATH
    String serverFilesPath = "/app/mcd/cms/fs04/wcm1_auth_prod/crx-quickstart/server/files/";

    //PROD PUB PATH
    //String serverFilesPath = "/app/mcd/cms/fs05/wcm1_pub_prod/crx-quickstart/server/files/";
    
    
        
    Properties instanceProp = null; 
    java.io.FileInputStream fis = null;
    try
    {
        fis = new java.io.FileInputStream(new java.io.File(serverFilesPath + instancePropFile));
        java.util.Properties props = new java.util.Properties();
        props.load(fis);
        fis.close();
        instanceProp = props;
        instance = instanceProp.getProperty("instance");
    }
    catch (Exception e)
    {
        e.printStackTrace();
    }
    finally
    {
        try
        {
            if (fis != null)
                fis.close();
        }
        catch (Exception ei)
        {
            System.out.println("Problem occured usermaintenanceform JSP. Cannot close reader " + ei.getMessage());
        }
    }
%>
<script language="javascript">
function validateForm()
{   
    var skillsSelect = document.getElementById("user_list");
    var selectedText = skillsSelect.options[skillsSelect.selectedIndex].text;
    var strEid=document.forms["maintform"]["EID"].value.replace(/^\s+|\s+$/g, '');
    var strEidList=document.forms["maintform"]["EIDLIST"].value.replace(/^\s+|\s+$/g, '');
    var char1 = strEid.charAt(0);
    var cc = char1.charCodeAt(0);
    
    if(selectedText=="add user as member" || selectedText=="add user as administrator" || selectedText=="delete user from group")
      {
            if((strEidList.length==0 && strEidList=='')&&(strEid.length!=0 && strEid!=''))
                {
                    if((cc>64 && cc<91) || (cc>96 && cc<123))
                    {
                       if(strEid.length<8)
                       {
                        alert("EID should not be less than 8 characters");
                        return false;
                       }
                
                     }
                    else
                      {
                         alert('Please provide a valid Employee ID (e.g. E0012345)');
                         return false;
                      }
                   
                }
                else if((strEidList.length==0 && strEidList=='')&&(strEid.length==0 && strEid=='')) {
                     if((cc>64 && cc<91) || (cc>96 && cc<123))
                        {
                       if(strEid.length<8)
                       {
                        alert("EID should not be less than 8 characters");
                        return false;
                       }
                
                     }
                    else
                      {
                         alert('Please provide a valid Employee ID (e.g. E0012345)');
                         return false;
                      }
                                
                }
            else {
                 strEid.length=0;
                    
                }
                          
     }    
    else
    {   
     if(selectedText=="view group")
     {
      strEid.length=0;
     }else {
        if((cc>64 && cc<91) || (cc>96 && cc<123))
         {
            if(strEid.length<8)
            {
            alert("EID should not be less than 8 characters");
            return false;
            }
            
        }
         else {
         alert('Please provide a valid Employee ID (e.g. E0012345)');
         return false;
         }
     }   
     }
 return true; 
}  
</script>

<script language="javascript">

    var maxLimitArr=new Array(); 
    
    <% 
    for(int i=0;i<pageSizeVal.length;i++)
    { 
    %>
        maxLimitArr[<%=i%>] = "<%= pageSizeVal[i].getString() %>";
    <% 
    } 
    %>    
</script>

<script language="javascript"  src="/scripts/usermaintenance.js"></script>

</head>
<body onload = 'showGroupURL();'>

<div style="width:100%; ">
<img style="float:right" src='/images/accessmcd.gif' />
</div>
<table cellpadding="2" cellspacing="5" border="0" align="center" class="text" style="clear:both">
    <tr>
        <td>

<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>    
    
        
<%!
    String uidHandleBase="/home/users/";
    String groupHandleBase="/home/groups/";
    String cqinstance="cq52";
    int maxLimit = 1000;
    String userid = "admin";
    String superAdmin = "admin";
    Map siteURLMap = new HashMap();
    
    private String groupListToOptions(String selectname,ArrayList ht, String selectedvalue,String id) 
    {
        String retString="";
        //retString+="<div id=\""+id+"\"><B>"+selectname+"</B><SELECT name=\""+selectname+"\" >";
        retString+="<TR><TD><B>"+selectname+"</B></TD><TD><SELECT name=\""+selectname+"\" onChange=\"showGroupURL();\">";
        retString+="<OPTION value=''></OPTION>";

        Iterator i = ht.iterator();
        GroupDataBean grpDataBean = null;
        while (i.hasNext()) 
        {
            grpDataBean = (GroupDataBean)i.next();
            String grpId = grpDataBean.getGroupID();
            String grpName = grpDataBean.getGroupName();
            groupList.add(grpId+"#"+grpDataBean.getSiteURL());
            retString+="<OPTION value=\""+grpId+"\"";
            if((selectedvalue!=null) && selectedvalue.equals(grpId))
            {
                retString+=" SELECTED ";
            }
            retString+=">"+grpName+"</OPTION>";
        }
        retString+="</SELECT></TD></TR>";
        
        return(retString);
    }

    private String checkParameter(String param, String msg)
    {
        if(param== null || param.trim().length() == 0)
        {
            return bold("<font class=error>Please enter "+msg+".</font>")+"<br>";   
        }
        return "";
    }
        
    public String viewUserLink(String userid)
    {
        return "<A href=\"javascript:viewUser('"+userid+"');\">"+userid+"</A>";
    }
    
    public String viewGroupLink(GroupDataBean groupBean)
    {
        return "<A href=\"javascript:viewGroup('"+groupBean.getGroupID()+"');\">"+groupBean.getGroupName()+"</A>";
    }
    
    public String deleteUserFromGroupLink(String userid,String groupid)
    {
        if(instance.equalsIgnoreCase("Author"))
            return "<A href=\"javascript:deleteUserFromGroup('"+userid+"','"+groupid+"',false);\">Remove</A>";
        else
            return "<FONT COLOR='#999999'>Remove</FONT>";
    }
    public String getMaintenanceForm(String eid, String eidlist, String group, String type, String userID,UserManager uMgr,UserMaintenanceManager umManager,String siteURL, String displayNum) throws Exception 
    {
        String retString="";
        
        retString="<fieldset><legend>User Maintenance</legend>";
        retString+="<FORM id=\"maintform\" name=\"maintform\" onsubmit=\"return validateForm()\" action=\"/content/utility/utility/_jcr_content.usermaintenanceform.html\" method=\"post\">";
        retString+="<TABLE border = '0'>";
        retString+="<TR><TD><B>EID:</B></TD><TD><INPUT name=\"EID\" maxlength=\"8\" value=\""+eid+"\"></TD></TR>";
        retString+="<TR><TD><B>EID List:</B></TD><TD><TEXTAREA rows=5 cols=60 name=\"EIDLIST\">"+ eidlist +"</TEXTAREA></TD></TR>";
        retString+="<TR><TD><B>&nbsp;</B></TD><TD>Note: Please enter comma separated EIDs in EID List Field.</TD></TR>";
        
        ArrayList groupsList = umManager.getGroupsAdminForUser(userID.trim());
        Collections.sort(groupsList, new GroupComparator()); 
        retString+=groupListToOptions("GROUP",groupsList,group,"group");
        retString+="<TR><TD><B>SITE URL: </B></TD><TD><INPUT readonly=\"readonly\" name=\"siteurl\" value=\""+siteURL+"\" size=\"70\"></TD></TR>";          
        retString+="<TR><TD><B>ACTION:</B></TD><TD><SELECT id=\"user_list\" name=\"pmACTION\" onChange=\"SelectSubCat();\">";
        retString+="<OPTION SELECTED value=\"view\""+(type.equalsIgnoreCase("view") ? "selected" : "")+">view</OPTION>";
        retString+="<OPTION value=\"viewgroup\""+(type.equalsIgnoreCase("viewgroup") ? "selected" : "")+">view group</OPTION>";
        
        if(instance.equalsIgnoreCase("Author"))
        {
            retString+="<OPTION value=\"addM\""+(type.equalsIgnoreCase("addM") ? "selected" : "")+">add user as member</OPTION>"; 
            if(umManager.checkForAdminDropDown(userID.trim()))
            {
                retString+="<OPTION value=\"addA\""+(type.equalsIgnoreCase("addA") ? "selected" : "")+">add user as administrator</OPTION>";
            }
                retString+="<OPTION value=\"delete\""+(type.equalsIgnoreCase("delete") ? "selected" : "")+">delete user from group</OPTION>";
        }
        
        retString+="</SELECT></TD></TR>";
        retString+="<TR><TD><B>LIMIT TO HOW MANY RESULTS:</B></TD><TD><SELECT id=\"DISPLAYNUM\" NAME=\"DISPLAYNUM\">";
        retString+="<Option value=\"\">no limit</option>";
            
        retString+="</SELECT></TD></TR>";
        retString+="</TR></TABLE>";
        retString+="<br><INPUT class='btn' type=\"submit\" value=\"SUBMIT\" /><br>";
        retString+="</FORM></fieldset><br><br>";
        
        return(retString);
    }
    
    public String bold(String val){return "<B>"+val+"</B>";}

    public String tr(String val){return "<TR>"+val+"</TR>";}
    
    public String td(String val){return "<TD>"+val+"</TD>";}
%>
<% 
    if(!(loggedInUser.getID().trim().equals(superAdmin) || umManager.checkForAdminDropDown(loggedInUser.getID().trim()))) 
    {
        out.write("<b><font class = 'error'>You are not authorised to view the form.</font></b><br>");
        return;
    }
    
    try 
    {
        String pmEID=request.getParameter("EID");
        String pmEIDList=request.getParameter("EIDLIST");
        String pmGroup=request.getParameter("GROUP");
        String pmAction=request.getParameter("pmACTION");
        String pmUpdate=request.getParameter("UPDATE");
        String pmStart=request.getParameter("START");
        String pmDisplayNum=request.getParameter("DISPLAYNUM");
        String radioValue=request.getParameter("groupradio");
        String siteURL=request.getParameter("siteurl");
        
        String pmFlag=request.getParameter("FLAG");
        
        if(pmEID==null)pmEID="";
        if(pmEIDList==null)pmEIDList="";
        if(pmGroup==null)pmGroup="";
        if(pmAction==null)pmAction="";
        if(pmUpdate==null)pmUpdate="";
        if(pmStart==null)pmStart="";
        if(pmDisplayNum==null)pmDisplayNum="";
        if(pmFlag==null)pmFlag="";
        if(radioValue==null)radioValue="";

        pmEID=pmEID.toLowerCase();
        pmEIDList=pmEIDList.toLowerCase();
        
        int displayNum = 200;

        if(!pmDisplayNum.equals("")) 
            displayNum = Integer.parseInt(pmDisplayNum);
        this.userid = loggedInUser.getID();
        out.write(getMaintenanceForm(pmEID,pmEIDList,pmGroup,pmAction,userid,uMgr,umManager,siteURL,pmDisplayNum));
      
%>
<script language="javascript">
    
        var disNameArr=new Array(); 
        <% 
        for(int i=0;i<groupList.size();i++)
        { 
        %>
            disNameArr[<%=i%>] = "<%= groupList.get(i) %>";
        <% 
        } 
        %>
        SelectSubCat();
        document.maintform.DISPLAYNUM.value = '<%=pmDisplayNum%>';
</script>
<%
        if((pmEID!="" || pmGroup!="") && pmAction!="")
        {
            out.write("<BR/><HR><BR/>");
            out.write(bold("EID:")+pmEID+"<BR/>");
            
            if(pmAction.equalsIgnoreCase("view"))
                out.write(bold("Action:")+"view"+"<BR/><BR/>");
            if(pmAction.equalsIgnoreCase("viewgroup"))
                out.write(bold("Action:")+"view group"+"<BR/><BR/>");
            if(pmAction.equalsIgnoreCase("addM")) 
                out.write(bold("Action:")+"add user as member"+"<BR/><BR/>");
            if(pmAction.equalsIgnoreCase("addA"))
                out.write(bold("Action:")+"add user as administrator"+"<BR/><BR/>");
            if(pmAction.equalsIgnoreCase("delete"))
                out.write(bold("Action:")+"delete user from group"+"<BR/><BR/>"); 
            if(pmAction.equals("addM") || pmAction.equals("addA") || pmAction.equals("delete"))
            {
                if(pmEIDList.trim().equals("") && pmEID.trim().equals(""))
                {
                    out.write("<FONT class = 'error'>Please enter an EID.</FONT>");
                    return;
                }
                if(pmGroup.trim().equals(""))
                {
                    out.write("<FONT class = 'error'>Please select a group.</FONT>");
                    return;
                }
                Map resultMap = null;
                if(!pmEIDList.equals(""))
                {
                    String[] arrEID = pmEIDList.split(",");
                    String eidValue="";
                    for(int i=0 ; i<arrEID.length ; i++)
                    {
                        if(i<arrEID.length-1){
                            umManager.setCloseSession(false);
                        }
                        else{
                            umManager.setCloseSession(true);
                        }                        
                        eidValue=arrEID[i].trim();
                        if(!eidValue.equalsIgnoreCase(""))
                        {
                            if(pmAction.equals("addM"))
                                resultMap = umManager.updateUserGroup(eidValue, pmGroup, "Add", false);
                            else if(pmAction.equals("addA"))
                                resultMap = umManager.updateUserGroup(eidValue, pmGroup, "Add", true);
                            else if(pmAction.equals("delete"))
                                resultMap = umManager.updateUserGroup(eidValue, pmGroup, "Delete", false);
                                 
                            out.write("<FONT class = '"+(resultMap.get("errorFlag").toString().equalsIgnoreCase("true") ? "error" : "success")+"'>"+resultMap.get("errorMessage").toString()+"</FONT>");
                            out.write("<BR/>"); 
                        }
                    }
                }
                else
                {
                   
                    if(jcrSession.hasPendingChanges())
                        jcrSession.save();
                    
                    if(pmAction.equals("addM")){
                        resultMap = umManager.updateUserGroup(pmEID, pmGroup, "Add", false);
                    }    
                    else if(pmAction.equals("addA"))
                        resultMap = umManager.updateUserGroup(pmEID, pmGroup, "Add", true);
                    else if(pmAction.equals("delete"))
                        resultMap = umManager.updateUserGroup(pmEID, pmGroup, "Delete", false);
                        
                    out.write("<FONT class = '"+(resultMap.get("errorFlag").toString().equalsIgnoreCase("true") ? "error" : "success")+"'>"+resultMap.get("errorMessage").toString()+"</FONT>");
                    pmAction="view";
                }
                   
                //resultMap = umManager.updateTemp(pmEID, pmGroup, pmAction, pmEIDList);
                //out.write("<FONT class = '"+(resultMap.get("errorFlag").toString().equalsIgnoreCase("true") ? "error" : "success")+"'>"+resultMap.get("errorMessage").toString()+"</FONT>");
                //pmAction="view";
            }
            else if(pmAction.equals("view"))
            {
                String BR="<br>";
                String msg="";
                msg+=checkParameter(pmEID, "an EID");
                if(!msg.equals(""))
                {
                    out.write("<FONT class = 'error'>"+bundle.getString("UAF_ENTER_EID")+"</FONT>");
                }
                else
                {
                    UserDataBean uBean = (UserDataBean)umManager.getUserDetails(pmEID);
                
                    if(uBean.getEid().equalsIgnoreCase(""))
                    {
                        msg+="<FONT class = 'error'>"+bundle.getString("UAF_USER_NOT_FOUND").replaceAll("eid", bold(pmEID))+"</FONT>";
                        out.write(msg);
                        return;
                    }
                    else
                    {
                        msg+=bold("EID:")+pmEID+BR;
                        String name=uBean.getFullName();
                        msg+=bold("Name:")+name+BR;
                        msg+=bold("mcdaudience:")+uBean.getMcaudience()+BR;
                        out.write("<TABLE class='group' border=0>"+msg+"</TABLE>");
                    }
                    //out.write(viewUser(uMgr,pmEID));   
                    // -------------Calling method for groups---------------
                    ArrayList grpArrList = umManager.getUserGroupsDetails(pmEID);
                    String loggedInUserID = loggedInUser.getID();
                   
                    ArrayList adminGrpListForLoggedInUser = null;
                    ArrayList listToDisplay = null;
                    if(loggedInUserID.equalsIgnoreCase(superAdmin)) 
                        listToDisplay = grpArrList;
                    else
                    {
                        adminGrpListForLoggedInUser = umManager.getGroupsAdminForUser(loggedInUserID);
                        listToDisplay = getCommonGroupsList(adminGrpListForLoggedInUser, grpArrList);
                    }
                    msg = "";
                    
                    out.write("<h3>GROUPS:</h3>");
                    
                    msg+="<tr><th>Name</th><th>Description</th><th>Admin</th><th>Delete</th></tr>"; 
                     
                    GroupDataBean grpBean = null;
                    for(int i = 0 ; i < listToDisplay.size() ; i++)
                    {
                        grpBean = (GroupDataBean)listToDisplay.get(i); 

                        if(i%2 == 0) 
                        {
                            msg+="<tr class='odd'>" + 
                                td(viewGroupLink(grpBean))+
                                td(grpBean.getGroupDescription()+"&nbsp;")+
                                td(grpBean.getAdminUsers().indexOf(pmEID) != -1 ? "Y" : "&nbsp;")+
                                td(deleteUserFromGroupLink(pmEID, grpBean.getGroupName())) + "</tr>" ;
                        }
                        else 
                        {
                            msg+="<tr class='even'>" + 
                                td(viewGroupLink(grpBean))+
                                td(grpBean.getGroupDescription()+"&nbsp;")+
                                td(grpBean.getAdminUsers().indexOf(pmEID) != -1 ? "Y" : "&nbsp;")+
                                td(deleteUserFromGroupLink(pmEID, grpBean.getGroupName())) + "</tr>" ;
                        }
                    }
                    
                    if(listToDisplay.size() == 0)
                    {
                        out.write(bundle.getString("UAF_USER_NOT_IN_GROUP").replaceAll("eid", bold(pmEID)));
                    }
                    else
                    {
                        out.write("<TABLE class='group' border=0>"+msg+"</TABLE>");
                    }
                    
                }
            }
            else if(pmAction.equals("viewgroup"))
            {
                if(pmGroup!=null)
                {
                    String groupname = pmGroup;
                    String maxLimit = String.valueOf(displayNum);
                    
                    String BR="<br>";
                    String msg="";
                    
                    msg+=checkParameter(pmGroup, "a Group.");
                    if(!msg.equals(""))
                    {
                        out.write(bold("<FONT class = 'error'>"+bundle.getString("UAF_SELECT_GROUP")+"</font>")+"<br>");
                        return;
                    }
                    out.println("Group ID :: " + groupname.toLowerCase() + "<br>");
                    GroupDataBean grpDet= umManager.getGroupDetails(groupname);
                    ArrayList grpMemArrList = umManager.getGroupMembersDetails(groupname, pmDisplayNum);
                    int grpMembersSize = umManager.getGroupMembersSize(groupname);
                    
                    msg=bold("Group Handle: ")+grpDet.getGroupHandle()+"<BR/>";
                    msg+=bold("Group Name: ")+grpDet.getGroupName()+"<BR/>";
                    msg+=bold("Group Description: ")+grpDet.getGroupDescription()+"<BR/>";
                    msg+="<BR/>";
                    
                    out.write(msg);
                    
                    msg=bold("Group Members:");
                    msg+="<BR/>";
                    
                    msg+="<tr><th>Name</th><th>EID</th><th>Admin</th><th>Delete</th></tr>"; 
                    UserDataBean userBean = null;
                    for(int i = 0 ; i < grpMemArrList.size() ; i++)
                    {
                        userBean = (UserDataBean)grpMemArrList.get(i);
                        if(i%2 == 0) 
                        {
                            msg+="<tr class='odd'>" + 
                                 td(userBean.getFullName()) + 
                                 td(viewUserLink(userBean.getEid()))+
                                 td(grpDet.getAdminUsers().indexOf(userBean.getEid()) != -1 ? "Y" : "&nbsp;")+
                                 td(deleteUserFromGroupLink(userBean.getEid(),groupname)) + "</tr>" ;
                         }
                         else 
                         {
                            msg+="<tr class='even'>" + 
                                 td(userBean.getFullName()) + 
                                 td(viewUserLink(userBean.getEid()))+
                                 td(grpDet.getAdminUsers().indexOf(userBean.getEid()) != -1 ? "Y" : "&nbsp;")+
                                 td(deleteUserFromGroupLink(userBean.getEid(),groupname)) + "</tr>" ;
                         }             
                    }
                    if(grpMemArrList.size() == 0)
                    {
                        out.write("<BR/><FONT class = 'error'>"+bundle.getString("UAF_NO_USERS_FOR_GROUP").replaceAll("groupname", bold(groupname))+"</FONT><BR/>");
                    }
                    else
                    {
                        out.write("<TABLE class='group' border=0>"+msg+"</TABLE>");
                    }
                    if(!pmDisplayNum.equalsIgnoreCase(""))
                    {
                        if(grpMemArrList.size() < grpMembersSize)
                        {
                            out.write("<BR/><B>"+bundle.getString("UAF_MAX_RESULTS").replaceAll("maxnum", bold(pmDisplayNum))+"</B><BR/>");
                        }
                    }
                }
            }
        }
    }catch (Exception e) 
    {
        out.write(e.getMessage());
        e.printStackTrace();
    }  
    finally
    {    
        uMgr=null;
        if (jcrSession!=null){
                    jcrSession.logout();       
                    log.info("*********** Session is Closed *********");
                    
        }            
        jcrSession=null;
    }
%>     



<%!
    public ArrayList<GroupDataBean> getCommonGroupsList(ArrayList<GroupDataBean> loggedInAdminGroups, ArrayList<GroupDataBean> enteredGroupsList)
    {
        GroupDataBean grpBeanEntered = null;
        String groupNameEntered = "";
        GroupDataBean grpBeanLoggedIn = null;
        String groupNameLoggedIn = "";
        ArrayList<GroupDataBean> groupListReturned = new ArrayList<GroupDataBean>();
        
        for(int i = 0 ; i < enteredGroupsList.size() ; i++)
        {
            grpBeanEntered = (GroupDataBean)enteredGroupsList.get(i);
            groupNameEntered = grpBeanEntered.getGroupName().trim();
            for(int j = 0 ; j < loggedInAdminGroups.size() ; j++)
            {
                grpBeanLoggedIn = (GroupDataBean)loggedInAdminGroups.get(j);
                groupNameLoggedIn = grpBeanLoggedIn.getGroupName().trim();
                if(groupNameEntered.equalsIgnoreCase(groupNameLoggedIn))
                {
                    groupListReturned.add(grpBeanEntered);
                }
            }
        }
        return groupListReturned;
    }
%> 

        </td>
    </tr>
</table>

</body>

</html>      