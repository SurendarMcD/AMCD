<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                javax.jcr.*,
                com.day.cq.security.*"%>   
<%@page import="java.net.*"%>              
<%@ page import="com.mcd.accessmcd.mysites.bean.SiteList"%>
<%@ page import="com.mcd.accessmcd.mysites.constants.*"%>
<%@ page import="com.mcd.accessmcd.mysites.manager.*"%>
<%@ page import="com.mcd.accessmcd.mysites.bean.*"%> 
<%@ page import="com.mcd.accessmcd.mysites.util.*"%>
<%@page import="javax.servlet.jsp.JspWriter"%>     
<%@ page buffer="1024kb"%>
<%@ include file="/apps/mcd/global/global.jsp"%> 
<%
    response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");
  
%>   
<SCRIPT language=Javascript src="/scripts/mysite.js" type=text/javascript></SCRIPT> 
<cq:includeClientLib categories="granite.csrf.standalone" />
<%  
    
     
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
     
    final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
    User loggedInUser = slingRequest.getResourceResolver().adaptTo(User.class);
    ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());
    String userId = loggedInUser.getID();
    
    String homeURL = "";
    String homeURLRequest = request.getParameter("homeURL");
    String version = request.getParameter("ver");
    String view = request.getParameter("view");
    if(version == null)
        version = "";
    if(view == null)
        view = "";
    if(homeURLRequest == null)
        homeURLRequest = "";
        
    if(version.equalsIgnoreCase("CQ4"))
    {
        homeURL = homeURLRequest;
    }
    else
    {
        //if(view.equalsIgnoreCase("CORP"))
            //homeURL = globalPath+".html";
        //else if(view.equalsIgnoreCase("US"))
            //homeURL = usPath+".html";
        //else if(view.equalsIgnoreCase("AU"))
            //homeURL = auPath+".html";
        //else if(view.equalsIgnoreCase("MCSOURCE"))
            //homeURL = mcsourcePath+".html";
        homeURL = prop.getProperty(view)+".html";
    }
    
    // Initializing all variables
    String helpText = bundle.getString("MB_HELP_TEXT");
    String submitLabel = bundle.getString("MB_DONE");
    String cancelLabel = bundle.getString("MB_CANCEL");
    String upLabel = bundle.getString("MB_UP");
    String downLabel = bundle.getString("MB_DOWN");
    String leftLabel = bundle.getString("MB_LEFT");
    String rightLabel = bundle.getString("MB_RIGHT");
    String addLabel = bundle.getString("MB_ADD_ALL");
    String removeLabel = bundle.getString("MB_REMOVE_ALL");
    String addBookMarkLabel = bundle.getString("MB_ADD");
    String editBookMarkLabel = bundle.getString("MB_EDIT");
    String deleteBookMarkLabel = bundle.getString("MB_DELETE");
    String maxVal = String.valueOf(MySitesConstants.MAX_SITES);
    String errorFMsg = "errorFMsg";
    String errorSMsg = "errorSMsg";
    String errorMsg = "errorMsg";
    
    boolean isAdministrator = false;  
    errorMsg = "Error Message.";
    // get the handle of the page
    String pageHandle = resource.getPath()+".html";  
    
    String save = request.getParameter("save");
    
    ArrayList globalSiteList = new ArrayList();
    ArrayList favoriteSiteList = new ArrayList();
    try 
    {
        MySitesManager mySitesManager = new MySitesManager(sling, jcrSession);
        isAdministrator = true;
        SiteList sitelist = mySitesManager.getSiteList(userId, view);
        globalSiteList = sitelist.getGlobalSiteList();
        favoriteSiteList = sitelist.getFavoriteSiteList();
        String headername = "";
        for(Enumeration e = request.getHeaderNames(); e.hasMoreElements();){
            headername = (String)e.nextElement();
            //out.println(request.getHeader(headername) + "<br>");
        }

        if ("1".equals(save)) 
        {    
            //request.setCharacterEncoding("UTF-8");   
            String[] favSiteIds = request.getParameterValues("siteId");
            String[] globalSiteIds = request.getParameterValues("siteId1");
            globalSiteList = getSiteListFromArray(globalSiteIds);
            favoriteSiteList = getSiteListFromArray(favSiteIds);
            sitelist = new SiteList(globalSiteList, favoriteSiteList);
            boolean success = mySitesManager.updateSiteList(userId, sitelist);
            sitelist = mySitesManager.getSiteList(userId, view);
%>          
            <script>
                alert('<%=bundle.getString(langText.get("MB_BOOKMARKS_UPDATED"))%>');
                //window.open('<%=homeURL%>','_parent');
                history.go(-2);
            </script>
<%
        }     
%> 
        <div id= "mysites">  
            <div class='paragraphTitle textbold'><%= langText.get("My Bookmarks") %></div>
            <hr>  
            <form name="siteListForm" method="POST" action="<%=pageHandle%>">
                <input type ="hidden" id="save" name="save" value="0"/>
                <input type ="hidden" id="homeURL" name="homeURL" value="<%=homeURLRequest %>"/>
                <input type ="hidden" id="ver" name="ver" value="<%=version %>"/>
                <input type ="hidden" id="view" name="view" value="<%=view %>"/>
                <table align="center" id='bookmarksTab'>
                    <tr>
                        <td colspan=4><span class="textbold" style="font-size:9pt;"><%=helpText%></span>  
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <select id="siteId1" name="siteId1" style="width:320px; border:1px solid #A9A9A9;font-size:9pt;" multiple size=18 onDblClick="jumpPage('<%=basePath%>',this.form.siteId1)">
<%
                                Iterator globalsiteiter = globalSiteList.iterator();
                                String globalNewSitename = "";
                                String globalStyle = "";
                                String isLinkUpdated = "";
                                while(globalsiteiter.hasNext()) 
                                {
                                    Site globalsite = (Site) globalsiteiter.next(); 
                                    if(globalsite.getNewSiteName() == null || globalsite.getNewSiteName().equalsIgnoreCase(""))
                                    {
                                        globalNewSitename = globalsite.getSiteName();
                                        isLinkUpdated = "N";
                                    }
                                    else
                                    {
                                        globalNewSitename = globalsite.getNewSiteName();
                                        isLinkUpdated = "Y";
                                    }
                                    if(globalsite.getSiteID().equalsIgnoreCase("0"))
                                    {
                                        globalStyle = "personal";
                                    }
                                    else
                                    {
                                        globalStyle = "global";
                                    }
%>
                                <option class = '<%= globalStyle%>' value="<%=globalsite.getSiteID()+"^$^"+globalNewSitename.replaceAll("\"","&quot;")+"^$^"+globalsite.getSiteURI()+"^$^"+isLinkUpdated+"^$^"+globalsite.getSiteName().replaceAll("\"","&quot;")%>"><%=globalNewSitename.replaceAll("\"","&quot;")%></option>
<%                              } 
%>
                            </select>
                        </td> 
                        <td valign="middle" align="center" style="padding:0px 50px;">
                            <a style="cursor: pointer; font-weight:bold;"  id="right" name="right" value="<%=rightLabel%>" onClick="javascript:moveSelectedOptionsRightforThisPage(document.getElementById('siteId1'),document.getElementById('siteId'))"><img width="30px" height="25px" title="Move Right" src="/images/rightarrow.PNG"/></a><br><br> 
                            <a style="cursor: pointer; font-weight:bold;"  name="left" value="<%=leftLabel%>" onClick="javascript:moveSelectedOptionsLeft(document.getElementById('siteId'),document.getElementById('siteId1'),'<%= langText.get("Please select a Bookmark to move.") %>')"><img width="30px" height="25px" title="Move Left" src="/images/leftarrow.PNG"/></a><br><br><br><br> 
                            <a style="cursor: pointer; font-weight:bold;"  name="right" value="<%=addLabel%>" onClick="javascript:moveAllOptionsLeft(document.getElementById('siteId1'),document.getElementById('siteId'),true)"><img width="30px" height="25px" title="Move All Right" src="/images/allright.PNG"/></a><br><br>
                            <a style="cursor: pointer; font-weight:bold;"  name="left" value="<%=removeLabel%>" onClick="javascript:moveAllOptionsRight(document.getElementById('siteId'),document.getElementById('siteId1'),true)"><img width="30px" height="25px" title="Move All Left" src="/images/allleft.PNG"/></a>    
                        </td>
                        <td>
                            <select id="siteId" name="siteId" style="width:320px; border:1px solid #A9A9A9;font-size:9pt;" multiple size=18 onDblClick="jumpPage('<%=basePath%>',document.getElementById('siteId'))">
<%
                            Iterator favoritesiteiter = favoriteSiteList.iterator();
                            String favNewSitename = "";
                            String favStyle = "";
                            while(favoritesiteiter.hasNext()) 
                            {
                                Site favoritesite = (Site) favoritesiteiter.next();
                                if(favoritesite.getNewSiteName() == null || favoritesite.getNewSiteName().equalsIgnoreCase(""))
                                {
                                    favNewSitename = favoritesite.getSiteName();
                                }
                                else
                                {
                                    favNewSitename = favoritesite.getNewSiteName();
                                }
                                if(favoritesite.getSiteID().equalsIgnoreCase("0"))
                                {
                                    favStyle = "personal";
                                }
                                else
                                {
                                    favStyle = "global";
                                }
%>            
                                <option class = '<%= favStyle%>' value="<%=favoritesite.getSiteID()+"^$^"+URLEncoder.encode(favNewSitename.replaceAll("\"","&quot;"),"UTF-8").replaceAll("\\+"," ")+"^$^"+favoritesite.getSiteURI()+"^$^Y^$^"+URLEncoder.encode(favoritesite.getSiteName().replaceAll("\"","&quot;"),"UTF-8").replaceAll("\\+"," ")%>"><%=favNewSitename.replaceAll("\"","&quot;")%></option>
<%                          }
%>
                            </select>
                        </td>
                        <td valign=middle align=center>
                            <a style="width:60px;cursor: pointer; font-weight:bold;" value="<%=upLabel%>" onClick="javascript:moveOptionUp(document.getElementById('siteId'),'<%= langText.get("Please select a BookMark") %>','<%= langText.get("Please select only one BookMark") %>')"><img style="margin-bottom:20px;" width="30px" height="25px" title="Move Up" src="/images/uparrow.PNG"/></a><br> 
                            <a style="width:60px;cursor: pointer; font-weight:bold;" value="<%=downLabel%>" onClick="javascript:moveOptionDown(document.getElementById('siteId'),'<%= langText.get("Please select a BookMark") %>','<%= langText.get("Please select only one BookMark") %>')"><img style="margin-top:20px;" width="25px" height="25px" title="Move Down" src="/images/downarrow.PNG"/></a>  
                        </td>
                    </tr>
                    <tr> <td> &nbsp; &nbsp; </td> </tr>
                    <tr>
                        <td colspan="3" align = 'center'>                              
                            <a id="addLink" style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;color:#000000;" onClick="javascript:openAddEditPopUp('Add','<%=currentPage.getPath()%>.mysitesaddsite.html','<%= langText.get("Please select a BookMark") %>','<%= langText.get("Please select only one BookMark from one list at a time") %>');" value='<%=addBookMarkLabel%>' ><img align="absMiddle" src="/images/add.png" />&nbsp;<%=addBookMarkLabel%></a>&nbsp; &nbsp;|&nbsp; &nbsp;
                            <a id="editLink" style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;color:#000000;" onClick="javascript:openAddEditPopUp('Edit','<%=currentPage.getPath()%>.mysitesaddsite.html','<%= langText.get("Please select a BookMark") %>','<%= langText.get("Please select only one BookMark from one list at a time") %>');" value='<%=editBookMarkLabel%>' ><img align="absMiddle" src="/images/edit.png" />&nbsp;<%=editBookMarkLabel%></a>&nbsp; &nbsp;|&nbsp; &nbsp;
                            <a style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;color:#000000;" onClick="javascript:deleteBookMark('<%= langText.get("Please select a BookMark") %>','<%= langText.get("Do you want to delete the Bookmark ?") %>','<%= langText.get("The global bookmark from global list can not be deleted.") %>','<%= langText.get("Please select only one BookMark from one list at a time.") %>');" value = '<%=deleteBookMarkLabel%>'><img align="absMiddle" src="/images/delete.png" />&nbsp;<%=deleteBookMarkLabel%></a>  
                         </td>   
                         <td></td>  
                    </tr> 
                    
                    <tr>
                    <td colspan="3" align='center'><hr width="230px"></td>  
                    <td></td>
                    </tr>      
                    <tr>
                        <td colspan="3" align = 'center'>   
                            <a style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;color:#000000;"  onClick='javascript:mySiteAction("save");' value = '<%=submitLabel%>'><img align="absMiddle" src="/images/save.png" />&nbsp;<%=submitLabel%></a>&nbsp; &nbsp;|&nbsp; &nbsp;
                            <a style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;color:#000000;"  onClick='javascript:history.go(-1)' value = '<%=cancelLabel%>'><img align="absMiddle" src="/images/cancel.gif" />&nbsp;<%=cancelLabel%></a>     
                        </td>
                        <td></td> 
                    </tr>                   
                    <!--  
                    <tr>
                        <td colspan=4>
                            <a style = "cursor:pointer;color:blue; font-weight:bold;" onclick = 'window.open("<%=currentPage.getPath()%>.addtobookmark.html","", "location=yes,menubar=no,toolbar=no,scrollbars=no,status=yes,width=350,height=200")'><%= langText.get("add to bookmark") %></a>
                        </td>
                    </tr> -->
                </table>
                <br/>
                <table border = '0'>
                    <tr>
                        <td valign = 'top'><%= langText.get("Note") %>:</td>
                        <td>
                            <i style='font-size:9pt'> 
                                1. <%= langText.get("Please press and hold the <b>ctrl</b> key to select/deselect multiple items in the list box.") %><br/>
                                2. <%= langText.get("The Global link will not be deleted from favorite List and will be moved to global bookmark list for future selection.") %>
                            </i>
                        </td>
                    </tr>  
                </table>
            </form>           
        </div>
<%
    } 
    catch (Exception e) 
    {
        out.println(errorMsg);
        e.printStackTrace();
    } 
%>
<script language ="JavaScript">
     
    window.onload = function() { sortSelect(document.siteListForm.siteId1); }; 
    var deSelectedSitesArray = new Array();
    var selectedSitesArray = new Array();
<%
    for (int i = 0; i < globalSiteList.size(); i++) 
    {
        Site deselected = new Site();
        deselected = (Site) globalSiteList.get(i);
%>
        var deselectobj = new Object();
        deselectobj.id = "<%=deselected.getSiteID()%>";
        deselectobj.url = "<%=(deselected.getSiteURI() != null) ? deselected.getSiteURI() .replace("ext_","") : ""%>";
        deSelectedSitesArray[<%=i%>] = deselectobj;
<%  }

    for (int j = 0; j < favoriteSiteList.size(); j++) 
    {
        Site selected = new Site();
        selected = (Site) favoriteSiteList.get(j);
%>
        var selectobj = new Object();
        selectobj.id = "<%=selected.getSiteID()%>";
        selectobj.url =  "<%=(selected.getSiteURI() != null) ? selected.getSiteURI() .replace("ext_","") : ""%>";
        selectedSitesArray[<%=j%>] = selectobj;
<%  }
%>
    var newSitesArray = deSelectedSitesArray.concat(selectedSitesArray);
    // -------------------------------------------------------------------
    // selectAllOptionsLeft(select_object)
    //  This function takes a select box and selects all options (in a 
    //  multiple select object). This is used when passing values between
    //  two select boxes. Select all options in the right box before 
    //  submitting the form so the values will be sent to the server.
    //  maxVal is the maximum number of links that can be selected by the user 
    // -------------------------------------------------------------------
    /*function selectAllOptionsLeft(obj1) 
    {
        if (!hasOptions(obj1)) 
        { 
            return; 
        }  
        var maxVal = "<%=maxVal%>";
        var optLen = obj1.options.length;   
        if(maxVal>optLen)
            maxVal = optLen;
        for (var i=0; i<maxVal; i++) 
        {      
            if(obj1.options[i]!=null)
            obj1.options[i].selected = true;
        }
        if("<%=maxVal%>"<optLen)    
            alert('<%=errorFMsg%>');        
    }*/
    
    function selectAllOptionsLeft(obj1) 
    {
        if (!hasOptions(obj1)) 
        { 
            return; 
        }  
        var optLen = obj1.options.length;   
        for (var i=0; i<optLen; i++) 
        {      
            if(obj1.options[i]!=null)
            obj1.options[i].selected = true;
        }
    }

    // -------------------------------------------------------------------
    // moveSelectedOptionsRight(select_object,select_object[,autosort(true/false)[,regex]])
    //  This function moves options between select boxes. Works best with
    //  multi-select boxes to create the common Windows control effect.
    //  Passes all selected values from the first object to the second
    //  object and re-sorts each box.
    //  If a third argument of 'false' is passed, then the lists are not
    //  sorted after the move.
    //  If a fourth string argument is passed, this will function as a
    //  Regular Expression to match against the TEXT or the options. If 
    //  the text of an option matches the pattern, it will NOT be moved.
    //  It will be treated as an unmoveable option.
    //  You can also put this into the <SELECT> object as follows:
    //    onDblClick="moveSelectedOptionsRight(this,this.form.target)
    //  This way, when the user double-clicks on a value in one box, it
    //  will be transferred to the other (in browsers that support the 
    //  onDblClick() event handler).
    //  maxVal is the maximum number of links that can be selected by the user
    // -------------------------------------------------------------------
    function moveAllOptionsLeft(from, to) 
    {
        selectAllOptionsLeft(from);
        if (arguments.length == 2) 
        {
            moveSelectedOptionsRight(from, to);
        }
        else 
        {
            if (arguments.length == 3) 
            {
                moveSelectedOptionsRight(from, to, arguments[2]);
            } 
            else 
            {
                if (arguments.length == 4) 
                {
                    moveSelectedOptionsRight(from, to, arguments[2], arguments[3]);
                }
            }
        }
        if((to.options.length)> "<%=maxVal%>")
        {
            alert("The Favorite Site list contains more than <%=maxVal%> links, but only <%=maxVal%> links will be visible in My Bookmarks dropdown at a time.");
        }
    }
    
    function moveSelectedOptionsRightforThisPage(from,to) 
    {   
        var selectedFlag = false;
        // Unselect matching options, if required
        if (arguments.length>3) 
        {
            var regex = arguments[3];
            if (regex != "") 
            {
                unSelectMatchingOptions(from,regex);
            }
        }
        // Move them over 
        /*if((to.options.length-1)< "<%=maxVal%>"-1) 
        {*/
            if (!hasOptions(from)) 
            { 
                return; 
            }
            for (var i=0; i<from.options.length; i++) 
            {
                var o = from.options[i];
                if (o.selected) 
                {
                    selectedFlag = true;
                    if (!hasOptions(to)) 
                    { 
                        var index = 0; 
                    } 
                    else 
                    { 
                        var index=to.options.length; 
                    }  
                    /*if(index < <%=maxVal%>)
                    {*/
                        var class1 = o.className;
                        var prevValue = o.value.split("^$^");
                        o.value = prevValue[0]+'^$^'+encodeURI(prevValue[1])+'^$^'+prevValue[2]+'^$^Y^$^'+encodeURI(prevValue[4]);
                        var objToBeMoved = new Option( o.text, o.value, false, false);
                        objToBeMoved.className = class1;
                        to.options[index] = objToBeMoved;
                    //}                                           
                }  
            }
            // Delete them from original
            for (var i=(from.options.length-1); i>=0; i--) 
            {
                var o = from.options[i];
                if (o.selected) 
                {
                    from.options[i] = null;
                }
            }
            if(selectedFlag)
            {
                if((to.options.length)> "<%=maxVal%>")
                {
                    alert("The Favorite Site list contains more than <%=maxVal%> links, but only <%=maxVal%> links will be visible in My Bookmarks dropdown at a time.");
                }
            }
            else
            {
                alert("Please select a Bookmark to move.");
                return false;
            } 
            if ((arguments.length<3) || (arguments[2]==true)) 
            {
                //sortSelect(from);
                //sortSelect(to);
            }
            
            from.selectedIndex = -1;
            to.selectedIndex = -1;
        /*} 
        else 
        {
            alert('<%=errorSMsg%>');
        }*/
    }    
    
    function moveSelectedOptionsRight(from,to) 
    {   
        // Unselect matching options, if required
        if (arguments.length>3) 
        {
            var regex = arguments[3];
            if (regex != "") 
            {
                unSelectMatchingOptions(from,regex);
            }
        }
        // Move them over 
        /*if((to.options.length-1)< "<%=maxVal%>"-1) 
        {*/
            if (!hasOptions(from)) 
            { 
                return; 
            }
            for (var i=0; i<from.options.length; i++) 
            {
                var o = from.options[i];
                if (o.selected) 
                {
                    if (!hasOptions(to)) 
                    { 
                        var index = 0; 
                    } 
                    else 
                    { 
                        var index=to.options.length; 
                    }  
                    /*if(index < <%=maxVal%>)
                    {*/
                        var class1 = o.className;
                        var prevValue = o.value.split("^$^");
                        o.value = prevValue[0]+'^$^'+encodeURI(prevValue[1])+'^$^'+prevValue[2]+'^$^Y^$^'+encodeURI(prevValue[4]);
                        var objToBeMoved = new Option( o.text, o.value, false, false);
                        objToBeMoved.className = class1;
                        to.options[index] = objToBeMoved;
                    //}
                }
            }
            // Delete them from original
            for (var i=(from.options.length-1); i>=0; i--) 
            {
                var o = from.options[i];
                if (o.selected) 
                {
                    from.options[i] = null;
                }
            }
            if ((arguments.length<3) || (arguments[2]==true)) 
            {
                //sortSelect(from);
                //sortSelect(to);
            }
            
            from.selectedIndex = -1;
            to.selectedIndex = -1;
        /*} 
        else 
        {
            alert('<%=errorSMsg%>');
        }*/
    } 
    
    function addOptionFromPopup(text, value, mode, sourceList, class1)
    {
        var obj1;
        var obj2;
        if (sourceList == "favorite")  
        {
            obj1 = document.siteListForm.siteId;
            obj2 = document.siteListForm.siteId1;
        } 
        else 
        {
            obj1 = document.siteListForm.siteId1;
            obj2 = document.siteListForm.siteId;
        }
        for (var i = 0; i < obj1.options.length; i++) 
        {
            var o = obj1.options[i];
            if (mode == "Edit")  
            {  
                if (!o.selected) 
                {
                    var optionValue = o.value;  
                    if (optionValue.split("^$^")[1] == value.split("^$^")[1]) 
                    {
                        return "<%= langText.get("BookMark Title already exists.") %>";
                    }
                }
            }
            else if (mode == "Add")
            {
                var optionValue = o.value;
                if ((optionValue.split("^$^")[0] == '0') && (optionValue.split("^$^")[1] == value.split("^$^")[1])) 
                {
                    return "<%= langText.get("BookMark Title already exists.") %>";
                }
            }
        }
        for (var j = 0; j < obj2.options.length; j++) 
        {
            var o = obj2.options[j];
            var optionValue = o.value;
            if ((optionValue.split("^$^")[0] == '0') && (optionValue.split("^$^")[1] == value.split("^$^")[1])) 
            {
                return "<%= langText.get("BookMark Title already exists.") %>" ;
            }
        }
        if (mode == "Add") 
        {
            var newOpt = new Option(decodeURI(text), value, false, false);
            newOpt.className = 'personal';
            var selLength = obj1.length;
            obj1.options[selLength] = newOpt;
        } 
        else 
        {
            if (mode == "Edit") 
            {
                var newOpt = new Option(decodeURI(text), value, false, true);
                newOpt.className = class1;
                for (var j = 0; j < obj1.options.length; j++)
                {
                    var o = obj1.options[j];
                    if (o.selected) 
                    {
                        obj1.options[j] = newOpt;
                    }
                }
            }
        }
        if (mode == "Add")
        {
            if((obj1.options.length)> "<%=maxVal%>")
            {
                alert("The Favorite Site list contains more than <%=maxVal%> links, but only <%=maxVal%> links will be visible in My Bookmarks dropdown at a time.");
                return "";
            }
            else
            {
                return "";
            }
        }
        else
        {
            return "";
        }
    }  
</SCRIPT>
<script>
    String.prototype.trim = function() 
    {
        return this.replace(/^\s+|\s+$/g,"");
    }
    String.prototype.ltrim = function() 
    {
        return this.replace(/^\s+/,"");
    }
    String.prototype.rtrim = function() 
    {
        return this.replace(/\s+$/,"");
    }
    
</script>
<%! 
public ArrayList getSiteListFromArray(String[] siteArr)
{
    ArrayList siteList = new ArrayList();
    Site site = null;
    String siteID = "";
    String siteName = "";
    String siteURL = "";
    String isLinkUpdated = "";
    String siteValue = "";
    String oldSiteName = "";
    if(siteArr != null)
    {   
        for(int i = 0 ; i < siteArr.length ; i++)  
        {
            siteValue = siteArr[i]; 
            site = new Site();
            //out.println(siteValue);
            siteValue = siteValue.replaceAll("\\^\\$\\^", "^");
            //out.println("siteValue---"+siteValue + "<br>");  
            //StringTokenizer st = new StringTokenizer(siteValue,"§");
            StringTokenizer st = new StringTokenizer(siteValue,"^");
            while(st.hasMoreTokens()){
                try{
                siteID = st.nextToken();
                //out.println("siteID---"+siteID + "<br>");
                //siteName = st.nextToken();
                siteName = URLDecoder.decode((String)st.nextToken(),"UTF-8");
                
                siteURL = st.nextToken();
                //out.println("   ==== siteURL---"+siteURL );
                isLinkUpdated = st.nextToken();
                //out.println("   ==== isLinkUpdated---"+isLinkUpdated);
                oldSiteName = URLDecoder.decode((String)st.nextToken(),"UTF-8");
                //oldSiteName = st.nextToken();
                
                }
                catch(Exception ex){}
            }
            
            site.setSiteID(siteID);
            site.setSiteName(oldSiteName);
            site.setNewSiteName(siteName);
            site.setSiteURI(siteURL);
            site.setIsLinkUpdated(isLinkUpdated);
            siteList.add(site);
        }
    }
    return siteList; 
}
 
%> 
<style>
div.sitefooter table {display:none;}
div.sitefooter #AlertBox table {display:block;}
</style>     