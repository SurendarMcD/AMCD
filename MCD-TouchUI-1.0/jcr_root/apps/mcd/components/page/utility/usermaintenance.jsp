<%--
  ==============================================================================
  User Maintenance Form
  
  Erik Wannebo 4/27/2010
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                javax.jcr.Session,
                com.day.cq.security.*"%>
<cq:includeClientLib js="granite.csrf.standalone"/>
<html>
<head>

<title>User Administration</title>
<!--script language="javascript"  src="/apps/mcd/docroot/scripts/flot/jquery-1.4.1.min.js"></script-->
<script language="javascript"  src="/etc/clientlibs/granite/jquery.js"></script>

<script Language="JavaScript">
    function showGroupURL()
    {
        var selIndex = document.drop_list.GROUP.selectedIndex;
        var aceGroupValue = document.drop_list.GROUP.options[selIndex].value
        //alert("ACE Group Value : " + aceGroupValue);
        for (var i=0; i < document.getElementById('groupurl').options.length; i++)
        {
            var groupUrlValue = document.getElementById('groupurl').options[i].value;
            
            if(groupUrlValue == aceGroupValue)
            {
                document.drop_list.siteurl.value=document.getElementById('groupurl').options[i].text;
            }
        }
    }
    
function fillCategory(){ 
 // this function is used to fill the category list on load
}

function SelectSubCat(){
// ON selection of category this function will work

removeAllOptions(document.drop_list.DISPLAYNUM);
//addOption(document.drop_list.DISPLAYNUM, "", "Limit to how many results", "");

if(document.drop_list.ACTION.value == 'viewgroup'){
addOption(document.drop_list.DISPLAYNUM,"200", "200");
addOption(document.drop_list.DISPLAYNUM,"500", "500");
addOption(document.drop_list.DISPLAYNUM,"1000", "1000");
}
if(document.drop_list.ACTION.value == 'view' || document.drop_list.ACTION.value == 'add' || document.drop_list.ACTION.value == 'delete'){
//no limit set in the view, add and delete methods in user_maintenance.jsp
addOption(document.drop_list.DISPLAYNUM, "", "no limit", "");
}

}

function removeAllOptions(selectbox)
{
    var i;
    for(i=selectbox.options.length-1;i>=0;i--)
    {
        selectbox.remove(i);
    }
}


function addOption(selectbox, value, text )
{
    var optn = document.createElement("OPTION");
    optn.text = text;
    optn.value = value;

    selectbox.options.add(optn);
}

function addUserToGroup(user,group,bAdd){
    var msg="Add "+user+" to group "+group;
    if(!bAdd)msg="Remove "+user+" from group "+group;
    if(confirm(msg + "?")){
         $("[name=EID]").val(user);
         $("[name=EIDLIST]").val("");
         $("[name=GROUP]").val(group);
         if(bAdd){
             $("[name=pmACTION]").val("add");
         }else{
             $("[name=pmACTION]").val("delete");
         }
         //alert(newlocation);
         $("#maintform").submit();
    }
}

function addUser(user){
    var msg="Add "+user;
    if(confirm(msg+ "?")){
         $("[name=EID]").val(user);
         $("[name=pmACTION]").val("createuser");
         $("#maintform").submit();
    }
}

function viewUser(user){
         $("[name=EID]").val(user);
         $("[name=pmACTION]").val("view");
         $("#maintform").submit();
}

function viewGroup(group){
         $("[name=GROUP]").val(group);
         $("[name=pmACTION]").val("viewgroup");
         $("#maintform").submit();
}
</script>
<style>
a   {
    font-weight: normal; 
    color: #0000ff; 
    font-family: Verdana, Arial, Helvetica, sans-serif; 
    text-decoration: none;
    }
    
a:visited 
    {
    color: #0000ff;
    }

a:hover 
    {
    color: #333366;
    }
    
body {
    background-color: #ffffff;
    margin: 0px 0px 0px 0px;
    margin-bottom: 0px;
    margin-left: 0px;
    margin-right: 0px;
    margin-top: 0px;
    padding-bottom: 0px;
    padding-left: 0px;
    padding-right: 0px;
    padding-top: 0px;
    font-family: Arial, Helvetica, sans-serif; 

    }
table.group,tr.group,td.group{
    border:1pt #000000 solid;
}
</style>

</head>
<body >
<table cellpadding="2" cellspacing="5" border=0 align="center" class="text">
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
    //get a connection to the ContentBus
    //String userid = ticket.getUserId();
    String userid = "admin";
    
    public boolean isSecurityAdmin(String user) throws Exception {
        return true;
    }

    public boolean isSecurityReader(String user) throws Exception {
       return true;
    }
    
    public Hashtable getGroups(UserManager uMgr){
        
        Hashtable htGroups=new Hashtable();

        Iterator iterGroups=uMgr.getGroups();
        while(iterGroups.hasNext()){
            Group grp=(Group)iterGroups.next();
            htGroups.put(grp.getID(),grp.getName());
        }
        return htGroups;
    }
    
   
     private String hashtableToOptions(String selectname,Hashtable ht, String selectedvalue,String id) {
        
        String retString="";
        retString+="<div id=\""+id+"\"><B>"+selectname+":</B><SELECT name=\""+selectname+"\">";
        retString+="<OPTION value=''></OPTION>";
        
        //sort first
        List keys = new ArrayList(ht.keySet());
        Collections.sort(keys);
        
        Iterator i = keys.iterator();
        while (i.hasNext()) {
            String key = (String) i.next();
            String value=(String)ht.get(key);
            retString+="<OPTION value=\""+value+"\"";
            if((selectedvalue!=null) && selectedvalue.equals(value)){
                retString+=" SELECTED ";
            }
            retString+=">"+key+"</OPTION>";
        }
        retString+="</SELECT></div>";
        return(retString);
    }

    private String checkParameter(String param, String msg){
        if(param== null || param.trim().length() == 0){
            return bold("<font class=errorMessageText>Please enter "+msg+".</font>")+"<br>";   
        }
        return "";
    }
        
    public String addDeleteUser(String userid, String groupid,UserManager uMgr,boolean bDelete) throws Exception {
        
        String BR="<br>";
        String msg="";
       
        msg+=checkParameter(userid, "an EID");
        msg+=checkParameter(groupid, "a Group");

        if(!msg.equals(""))return msg;
        
        User user=null;
        try{
            user=(User)uMgr.get(userid);
        }catch(NoSuchAuthorizableException e){
            msg+="User "+userid+" not found."+addUserLink(userid)+BR;
        }
        if(user==null){
            msg+=bold("User is null")+BR;
            return msg;
        }
        Group group=(Group)uMgr.get(groupid);
        if(group==null){
            msg+=bold("Group is null")+BR;
            return msg;
        }
        try{
            if(bDelete){
                group.removeMember(user);
            }else{
                group.addMember(user);
            }
        }catch (Exception e){
            msg+="Exception adding/removing user from group."+BR;
        }
        if(bDelete){
            msg+="Deleted "+userid+"("+user.getName()+") from group "+group.getName()+BR;
        }else{
            msg+="Added "+userid+"("+user.getName()+") to group "+group.getName()+BR;
        }
        return msg;
    }
    public String createUser(UserManager uMgr, String userid) throws Exception {
            String BR="<br>";
            String msg="";
            //msg+=checkParameter(userid, "an EID");
            //if(!msg.equals(""))return msg;
            
            User user=null;
            try{
                //need to supply a password, and since it doesn't get updated w/LDAP password
                //it needs to be something random (LDAP login still works, and apparently doesn't
                //rely on this password)
                String password=Double.toString(Math.random());
                String principalname="uid="+userid+",ou=People,o=accessmcd.com,o=mcd.com";
                String path="/home/users/"+userid.substring(0,6)+"xx/";
                user=(User)uMgr.createUser(userid,password,principalname,path);
                msg+="User "+userid+" created."+BR;
            }catch(NoSuchAuthorizableException e){
                msg+="User "+userid+" not found."+addUserLink(userid)+BR;
            }
            
            return msg;
        }
            
            
    public String viewUser(UserManager uMgr, String userid) throws Exception {
            String BR="<br>";
            String msg="";
            msg+=checkParameter(userid, "an EID");
            if(!msg.equals(""))return msg;
            
            User user=null;
            try{
                user=(User)uMgr.get(userid);
            }catch(NoSuchAuthorizableException e){
                msg+="User "+userid+" not found."+addUserLink(userid)+BR;
            }
            if(user!=null){
                msg+=bold("EID:")+userid+BR;
                String name=user.getProperty("rep:fullname");
                if(name==null)name=user.getName();
                msg+=bold("Name:")+name+BR;
                msg+=bold("mcdaudience:")+user.getProperty("rep:mcdAudience")+BR;
                Iterator usergroups=user.memberOf();
                msg+=tr(td(bold("Groups"))+td(""));
                while(usergroups.hasNext()){
                    Group grp=(Group)usergroups.next();
                    msg+=tr(td(viewGroupLink(grp.getName()))+td(deleteUserFromGroupLink(userid,grp.getName())));
                }
            }
            return "<TABLE class='group' border=1>"+msg+"</TABLE>";
          
        }

    public String viewGroup(UserManager uMgr, String groupname, int displayNum) throws Exception {
                   
        String BR="<br>";
        String msg="";
        
        msg+=checkParameter(groupname, "a Group");
        if(!msg.equals(""))return msg;

        msg="Group "+bold(groupname)+" contains these users:";
        msg+=tr(td(bold("ID"))+td(bold("Name"))+td(""));
        String grouphome="/home/groups/"+groupname.substring(0,1).toLowerCase()+"/"+groupname;
        Group group=(Group)uMgr.get(groupname);
        if(group!=null){
            Iterator members=group.members();
            int cnt=0;
            while(cnt<250 && members.hasNext()){
                Authorizable member=(Authorizable)members.next();
                msg+=tr(td(viewUserLink(member.getID()))+td(member.getName())+td(deleteUserFromGroupLink(member.getID(),groupname)));
                cnt++;
            }
            if(cnt==250)msg+=tr(td("MAX 250 Results returned"));
        }else{
            msg+="Group not found."+BR;
        }
        return "<TABLE class='group' border=2>"+msg+"</TABLE>";
        
    }  
    public String getDefaultGroup(String mcdAudience){
        String defaultGroup="";
        if(mcdAudience==null)return "";
        if(mcdAudience.equals("CorpEmployees"))defaultGroup="DEFAULT-Employee";
        if(mcdAudience.equals("Franchisees"))defaultGroup="DEFAULT-Owner_Operator";
        if(mcdAudience.equals("FranchiseeRestMgrs"))defaultGroup="DEFAULT-Franchisee_Restaurant_Manager";
        if(mcdAudience.equals("McOpCoRestMgrs"))defaultGroup="DEFAULT-McOpCo_Restaurant_Manager";
        if(mcdAudience.equals("SupplierVendor"))defaultGroup="DEFAULT-Suppliers_Vendors";
        if(mcdAudience.equals("Crew"))defaultGroup="DEFAULT-Crew";
        if(mcdAudience.equals("Agency"))defaultGroup="DEFAULT-Agency";
        if(mcdAudience.equals("FranchiseeOfficeStaff"))defaultGroup="DEFAULT-Franchisee_Office_Staff";
        return defaultGroup;
    }
            
            
    /* Display list of users who are in incorrect default groups */        
    public String showMisgrouped(UserManager uMgr){
        String BR="<br>";
        String msg="";
        Iterator iterUsers=uMgr.getUsers();
        msg+="have users:";
        User user=null;
        int cnt=0;
        while(iterUsers.hasNext()){
            try{
                user=(User)iterUsers.next();
            }catch(Exception e){
                msg+=tr(td("Error getting user"));
            }
            if(user!=null && user.isUser() && !user.getID().equals("ei101124")){
                String mcdAudience=user.getProperty("rep:mcdAudience");
                String defaultGroup=getDefaultGroup(mcdAudience);
                boolean bFound=false;
                Iterator memberGroups=user.memberOf();
                String userinfo=td(user.getID())+td(user.getName())+td(mcdAudience);
                String usergroups="";
                while(memberGroups.hasNext()){
                    Group grp=(Group)memberGroups.next();
                    if(grp.getName().equals(defaultGroup))bFound=true;
                    usergroups+=grp.getName()+BR;
                }
                if(!bFound){
                       msg+=tr(userinfo+td(usergroups+td("Should be member of "+bold(defaultGroup)+addUserToGroupLink(user.getID(),defaultGroup))));
                }
            }
            cnt++;
        }
        return "<table>"+msg+"</table>";
    }
    
    public String viewUserLink(String userid){
        return "<A href=\"javascript:viewUser('"+userid+"');\">"+userid+"</A>";
    }
    
    public String viewGroupLink(String groupid){
        return "<A href=\"javascript:viewGroup('"+groupid+"');\">"+groupid+"</A>";
    }
    
    public String addUserToGroupLink(String userid,String groupid){
        return "<A href=\"javascript:addUserToGroup('"+userid+"','"+groupid+"',true);\">Add</A>";
    }
    
    public String addUserLink(String userid){
        return "<A href=\"javascript:addUser('"+userid+"');\">Add User</A>";
    }
    
    public String deleteUserFromGroupLink(String userid,String groupid){
        return "<A style='color:red' href=\"javascript:addUserToGroup('"+userid+"','"+groupid+"',false);\">Remove</A>";
    }
    public String getMaintenanceForm(String eid, String eidlist, String group, String type, String userID,UserManager uMgr) throws Exception { //NoSuchPageException, ContentBusException{        
    String retString="";
    String authPubChecked = "";
    String aceChecked = "";
    //contentchampion admin flag
    boolean contentChampionAdmin = false;

    retString="<H1>User Maintenance</H1><BR>";
    retString+="<FORM id=\"maintform\" action=\"/content/utility/utility/_jcr_content.usermaintenance.html\" method=\"post\">";
    retString+="<B>EID:</B><INPUT name=\"EID\" value=\""+eid+"\"><BR>";
    retString+="<B>EID List:</B><TEXTAREA rows=5 cols=60 name=\"EIDLIST\">"+eidlist+"</TEXTAREA><BR>";
    Hashtable groups = getGroups(uMgr);
    retString+=hashtableToOptions("GROUP",groups,group,"group");
    
        
    /*
    retString+="<B>ACTION:</B><SELECT name=\"ACTION\">";
    retString+="<OPTION "+(type.equals("view")?"SELECTED":"")+" value=\"view\">view</OPTION>";
    retString+="<OPTION "+(type.equals("viewgroup")?"SELECTED":"")+" value=\"viewgroup\">viewgroup</OPTION>"; 
    retString+="<OPTION "+(type.equals("add")?"SELECTED":"")+" value=\"add\">add</OPTION>"; 
    retString+="<OPTION "+(type.equals("delete")?"SELECTED":"")+" value=\"delete\">delete</OPTION>"; 
    */
    retString+="<B>ACTION:</B><SELECT name=\"pmACTION\">";
    retString+="<OPTION SELECTED value=\"view\">view</OPTION>";
   retString+="<OPTION value=\"viewgroup\">view group</OPTION>";
    retString+="<OPTION value=\"add\">add user to group</OPTION>"; 
    retString+="<OPTION value=\"delete\">delete user from group</OPTION>";
     retString+="<OPTION value=\"createuser\">create user</OPTION>"; 
   
    retString+="</SELECT><BR>";
    
    //wei added a dropdown
    /*
    retString+="<B>LIMIT TO HOW MANY RESULTS:</B><SELECT id=\"DISPLAYNUM\" NAME=\"DISPLAYNUM\">";
    retString+="<Option value=\"\">no limit</option>";
        
    retString+="</SELECT><BR>";
    */
    retString+="<INPUT type=\"submit\" value=\"submit\" /><BR>";
    retString+="</FORM>";
    
    return(retString);
    }
    
    public String bold(String val){return "<B>"+val+"</B>";}

    public String tr(String val){return "<TR>"+val+"</TR>";}
    
    public String td(String val){return "<TD>"+val+"</TD>";}
    
    public String tag(String tg,String val){return "<"+tg+">"+val+"</"+tg+">";}
    
%>
<% 
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    out.write("<a href='/libs/cq/core/content/login.html?resource=/content/utility/utility.usermaintenance.html'>LOGIN HERE</a>");
    return;
}
final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
UserManager uMgr = userManagerFactory.createUserManager(jcrSession);

    //temp
        try {
            String pmEID=request.getParameter("EID");
            String pmEIDList=request.getParameter("EIDLIST");
            String pmGroup=request.getParameter("GROUP");
            String pmAction=request.getParameter("pmACTION");
            String pmUpdate=request.getParameter("UPDATE");
            String pmStart=request.getParameter("START");
            String pmDisplayNum=request.getParameter("DISPLAYNUM");
            String radioValue=request.getParameter("groupradio");
            
            //wei added for call from the link
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
        
            out.write(getMaintenanceForm(pmEID,pmEIDList,pmGroup,pmAction,userid,uMgr));
      
     
     
            // wei added for call from the link
            if (pmFlag.equals("1") && pmGroup!="") {
                 if (displayNum>maxLimit) {
                    out.write("<BR><B>Note: Maximum limit is set to " + maxLimit + " for performance consideration.</B>");
                 } else {

                    if(pmGroup!=null){
                        if(!pmGroup.startsWith("/access/groups/")){
                            pmGroup="/access/groups/"+pmGroup;
                        }
                        //viewGroup(out,pmGroup,displayNum);
                    }
                 }
                 pmFlag="";
                 return;
            }
            
            
            if((pmEID!="" || pmGroup!="") && pmAction!=""){

                out.write("<BR><HR><BR>");
                //out.write(bold("EID:")+pmEID+"<BR>");
                //out.write("Action:"+pmAction+"<BR>");

                if((pmAction.equals("add") 
                    || pmAction.equals("createuser") 
                    || pmAction.equals("delete")) 
                    //&& isSecurityAdmin(ticket, userid)
                ) {
                    if(pmGroup!=""){
                       //if(!pmGroup.startsWith("/access/groups/")){
                       //     pmGroup="/access/groups/"+pmGroup;
                       // }
                        
                        //if(!pmGroup.equalsIgnoreCase("/access/groups/")){
                        //    out.write("Group:"+pmGroup+"<BR>");
                        //}
                        
                        if(!pmEIDList.equals("")){
                            StringTokenizer eids= new StringTokenizer(pmEIDList);
                            while(eids.hasMoreTokens()){
                                String eidValue=eids.nextToken();
                                if(pmAction.equals("add")){
                                     out.write(addDeleteUser(eidValue,pmGroup,uMgr,false));
                                }
                                if(pmAction.equals("delete")){
                                    out.write(addDeleteUser(eidValue,pmGroup,uMgr,true));
                                }
                                if(pmAction.equals("createuser")){
                                    out.write(createUser(uMgr,eidValue));
                                }
                                
                            }
                        }else{
                            if(pmAction.equals("add")){
                                if(jcrSession.hasPendingChanges())jcrSession.save();
                                out.write(addDeleteUser(pmEID,pmGroup,uMgr,false));
                                pmAction="view";
                            }
                            
                            if(pmAction.equals("delete")){
                                out.write(addDeleteUser(pmEID,pmGroup,uMgr,true));
                                pmAction="view";
                            }
                            
                            if(pmAction.equals("createuser")){
                                if(jcrSession.hasPendingChanges())jcrSession.save();
                                out.write(createUser(uMgr,pmEID));
                                pmAction="view";
                            }
                        } 
                    }
                }
                if(pmAction.equals("view")){
                    out.write(viewUser(uMgr,pmEID));
                }
                if(pmAction.equals("viewgroup")){
                    if(pmGroup!=null){
                        
                        out.write(viewGroup(uMgr, pmGroup,displayNum));
                    }
                }
                if(pmAction.equals("misgrouped")){
                    out.write(showMisgrouped(uMgr));
                }

        }

        }catch (Exception e) {
            out.write(e.getMessage());
            e.printStackTrace();
        }finally{
            uMgr=null;
            jcrSession=null;
        }
%>

        </td>
    </tr>
</table>

</body>

</html>

