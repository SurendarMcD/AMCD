<%--
  ==============================================================================

  Left Navigation component

  Draws Left navigaton on the left of the pages. 
  this component will render the child pages of the particular page
  Also it can move upto 7 level of navigation.
 ==============================================================================
--%>
    <%@include file="/apps/mcd/global/global.jsp"%>
    <%@ page import="java.util.ArrayList,java.util.Iterator,com.day.cq.wcm.api.PageFilter"%>
    
    
    
    <%!
    // Declaring Constants & Global Variables //
    static final int START_LEVEL=1;
    int navLevel = 0;
    int navEndLevel=0;
    %>
    
    <%
    //To check whether round corners should be included or not //
    Boolean roundCorners=properties.get("checkRoundCorners", false);
    %>
     <!--  Div for the rounded corners on the Left navigation table -->
    
       <form id="leftNavForm"> 
      <% if(roundCorners){ %>
      <div style="width: 140px">
          <b id="LeftNavtop0" class="leftnavBorder">
          <b id="LeftNavtop1" class="leftnavBorder1"><b></b></b>
          <b id="LeftNavtop2" class="leftnavBorder2"><b></b></b>
          <b id="LeftNavtop3" class="leftnavBorder3"></b>
          <b id="LeftNavtop4" class="leftnavBorder4"></b>
          <b id="LeftNavtop5" class="leftnavBorder5"></b></b>
        </div>
        <%} %>
          
        <!-- LEFT NAV Table starts  -->
           <table width="140" border="0" cellpadding="0" cellspacing="0" >
           <tr> 
           <td>
           <table class="leftnav" width="140" border="0" cellpadding="0" cellspacing="0" >
    
    <%
    // Variable Declarations //
    // variable for starting the navigaton level//
    int startLevel = START_LEVEL;
    
    // for storing the html of left nav //
    String streamOutput="";
    // for storing start page handle //
    String startPageHandle="";
    // storing the current design page path //
    String designPath=currentDesign.getPath();
    String rootPage = "";
    String absParentLevel = "";
    String navStoplevel = "";
    
    

    // code for retrieving the values of the node or dialog //
    rootPage = properties.get("listroot","");
    absParentLevel = properties.get("parentLevel","");
    navStoplevel = properties.get("stoplevel","");
    
    // checking if the dialog has values or not as these //
    // are the minimum requirement for the link navigation to render //
    if(rootPage.equals("")&& absParentLevel.equals(""))
    {
        
        out.println("Please enter the values in dialog box");
    }
    else
    { 
        // calling method-getPath() to retrieive the root path of the pages //
        // this method will return the path of the root folder from where the navigation will work //
        startPageHandle=getPath(rootPage,absParentLevel,currentPage);
        // converting the String val to Integer //
        navLevel=Integer.parseInt(navStoplevel);
        navEndLevel=navLevel+START_LEVEL;
        navLevel=navLevel-START_LEVEL;
    
        // code to calculate the final stop level for the navigation //
        if(absParentLevel.equals(""))
        {
               String levelVal[]=rootPage.split("/");
               // array length has been subtracted by 2 as it starts with 1 & legnth has 1 more value//
               navLevel=navLevel+levelVal.length-2;
        }else
        {
            navLevel=navLevel+Integer.parseInt(absParentLevel);
        }
        
        
        // calling the get children method to retrieve all the child pages//
        // of the given root folder. and implementing the logic for the CSS //
        
        if (!startPageHandle.equals(""))
        {
          streamOutput=getChildren(pageManager.getPage(startPageHandle),currentPage.getPath(),startLevel,navLevel,request,designPath,true);
        }
        else
        {
            out.println("No Child page exist for parent level mentioned at dialog");
        }
        // this will render the left navigaton //
        
        // If round corners are included //
        // code to provide the mouse over effect on the rounnd corners //
        // code to hide the seprator line for the last item //
    
        if(roundCorners){ 
                try
                {       
                    // declaring & initializing  variables //
                    int start_str=0;
                    int strLen=0;
                    int firstindex_id=0;
                    int lastindex_id=0;
                    int lastindex_class=0;
                    
                    String tempStreamOutput="";
                    String firstid_str="";
                    String lastid_str="";
                    String classname_str="";
                    
                    // this variable is used to replace the class name of the last seprator line in case of rounded corners //
                    String classname_replace="leftnavRowEnd";
                    String id_val="id=\"\"";
                    String class_name="leftnavRowStart";
                    
                    
                    tempStreamOutput = streamOutput;
                    strLen = tempStreamOutput.length();
                    // calculating the first index of the id in the html code //
                    firstindex_id = tempStreamOutput.indexOf(id_val);
                    
                    
                    // adding the legth of the id //
                    firstindex_id = firstindex_id+id_val.length();
                    
                    lastindex_id = tempStreamOutput.lastIndexOf(id_val);
                    
                    //unused
                    //lastindex_class = tempStreamOutput.lastIndexOf(class_name);
                    if(firstindex_id-id_val.length()==lastindex_id)
                    {
                        streamOutput=tempStreamOutput.replace(id_val,"id=\"333\" ");
                    
                    }
                    else
                    {   
                    
                        firstid_str = tempStreamOutput.substring(start_str, firstindex_id);
                        lastid_str= tempStreamOutput.substring(firstindex_id, lastindex_id);
                        classname_str= tempStreamOutput.substring(lastindex_id, strLen);
                        
                        // this is used to replace the first  <td>  id  with the mouse over effect for the rounded corners //
                        firstid_str = firstid_str.replace(id_val,"id=\"111\" ");
                        // this is used to replace the class name of the last seprator line in case of rounded corners //
                        classname_str = classname_str.replace(id_val,"id=\"000\" ");
                        //classname_str = classname_str.replace(class_name,"leftnavRowEnd");
                        
                        // creation of the final string after manipulation //
                        streamOutput = firstid_str+lastid_str+classname_str;
                    }
                    
                    
                }
                catch(Exception ex)
                {
                    log.error("Error in Left Navigation >>>> "+ ex.getMessage());
                }
     }
        
        out.println(streamOutput);
        
              
    }
    
    %>
            </table>
          </td>
       </tr>
     </table>
     <!-- Div for the rounded corners at the bottom of the table -->
    <%if(roundCorners){ %>
    <div style="width: 140px">
      <b id="LeftNavbottom0" class="leftnavBorder">
      <b id="LeftNavbottom5" class="leftnavBorder5"></b>
      <b id="LeftNavbottom4" class="leftnavBorder4"></b>
      <b id="LeftNavbottom3" class="leftnavBorder3"></b>
      <b id="LeftNavbottom2" class="leftnavBorder2"><b></b></b>
      <b id="LeftNavbottom1" class="leftnavBorder1"><b></b></b></b>
    </div>
    <%} %>
 </form>
     
    
    <%!
    
    // this method takes the value of the rootpage, absParentLevel,currentpage value for getting the 
    // root folder for the navigaton & will return the root handle for the navigation.
    public String getPath(String rootPage,String absParentLevel,Page currentPage)
    {
    // declaring variable //    
    String startPage="";
    StringBuffer outStream = new StringBuffer("");
    int parentLevel=0;
    
    // checking if the absolute parent is not given in the dialog 
    // then the rootpage path will be mentioned //
    try{
        if(!absParentLevel.equals(""))
         {
            parentLevel=Integer.parseInt(absParentLevel);
            startPage=currentPage.getAbsoluteParent(parentLevel).getPath();
        }
        else
        {
            
            startPage=rootPage; 
            
        }
    }
    catch(Exception ex)
    {
        outStream.append("No Child page exist for parent level mentioned at dialog");
        return startPage;
    }
    return startPage;
    }
    
    
    // this method return the child pages for the page //
    // also it set the UI for all the pages //
    
    public String getChildren(Page rootPage,String navSelectedPath,int startLevel,int stopLevel,HttpServletRequest request, String designPage,boolean isTopNode)
    {
    
    // Declaring & nitializing variables //
    String whiteRow=  "</td></tr><tr><td class=\"leftnavRowStart\"></td></tr>";
    StringBuffer outStream = new StringBuffer("");
    // calling navspacer method //
    String spacing = navspacer(startLevel-1,"","",designPage);
    String childPath="";
    String title="";
    
    
    // code to retirieve the child pages of the selected page in the itertor object //
    Iterator<Page> myChildren = rootPage.listChildren(new PageFilter(request));
    
    // loop to render the child page //
     while(myChildren.hasNext()){
               // retrieving the value of the page from the list //
              Page child =  (Page) myChildren.next();
             
               if (child!=null&&startLevel!= navEndLevel) {
                       // code to get the child path & the titleto be shown on the html page //
                       childPath = child.getPath();
                       title = child.getNavigationTitle();
                       if (title == null || title.equals("")) {
                           title = child.getPageTitle();
                       }
                       if (title == null || title.equals("")) {
                           title = child.getTitle();
                       }
                       if (title == null || title.equals("")) {
                           title = child.getName();
                       }
                       
                       outStream.append("<tr>");
                        //if it contains child path
                       if (navSelectedPath.equals(childPath)) {
                            //this is selected item // 
                            // calling pf navspacer method adds the TD classes to the cod e//
                            if(!isTopNode){
                                outStream.append("</td></tr><tr><td class=\"leftnavRowStart"+startLevel+"\"></td></tr>");
                            }outStream.append(navspacer(startLevel-1,"On","",designPage));
                            // added the title of the link & the seprator line //
                            
                            outStream.append(title);
                            //outStream.append(title + whiteRow);
                            
                            // this recursivly calls the getChildren method //
                            outStream.append(getChildren(child,navSelectedPath,startLevel+1,startLevel+1,request,designPage,false));
                        }
                        else {
                            if (navSelectedPath.startsWith(childPath+'/')) {
                                //this is a parent of th eselected child 
                                if(!isTopNode){
                                    outStream.append("</td></tr><tr><td class=\"leftnavRowStart"+startLevel+"\"></td></tr>");
                                }outStream.append(spacing);
                                // creating the link for the page //
                               //outStream.append("<a href=\"" + childPath + ".html\">" + title + "</a>" + whiteRow);
                                outStream.append("<a href=\"" + childPath + ".html\">" + title + "</a>");
                                    if(startLevel<stopLevel){
                                        //continue down tree
                                        outStream.append(getChildren(child,navSelectedPath,startLevel+1,stopLevel+1,request,designPage,false));
                                    }
                            }
                            else {
                                    // to stop the navigation level as per given in the dialog // 
                                    if(startLevel==stopLevel){
                                          //bottom of tree -- different bullet points
                                         if(!isTopNode){
                                                 outStream.append("</td></tr><tr><td class=\"leftnavRowStart"+startLevel+"\"></td></tr>");
                                         }
                                         outStream.append(spacing);
                                    }else{
                                        if(!isTopNode){
                                           outStream.append("</td></tr><tr><td class=\"leftnavRowStart"+startLevel+"\"></td></tr>");
                                        }   
                                        outStream.append(spacing);
                                    }
                                // code to create the child page item of the left navigation //                      
                                //outStream.append("<a href=\"" + childPath+ ".html\">" + title+startLevel + "</a>"  + whiteRow);
                                    outStream.append("<a href=\"" + childPath+ ".html\">" + title + "</a>");
                            }
                        }
                }
                isTopNode = false;
      }
    // return the html code as string //
    return outStream.toString();
}
    
    
    // Method for building the TD and implenting the classes at the HTML code of the navigation //
    public String navspacer(int level, String classSuffix, String cssSelector, String designPage){
        //assumption here is that there will be CSS class definitions for "leftnav"[level number][classSuffix]
        StringBuffer outStream=new StringBuffer("");
       // apprends the TD with the specific level id with the css class //
        outStream.append("<td id=\"" + cssSelector + "\"  class=\"navitem leftnav"+String.valueOf(level+1) + classSuffix + "\" colspan=\"5\" >");
        //onMouseOver='this.className+=\"hover\";' OnMouseOut='this.className=this.className.replace(\"hover\",\"\");'
        return outStream.toString();
    }
%>
<script>
    $(function(){
        var distinctID = "";
        var color = "";
            
        hoverConfig = {
            sensitivity: 1, // number = sensitivity threshold (must be 1 or higher)
            interval: 0, // number = milliseconds for onMouseOver polling interval
            timeout: 0, // number = milliseconds delay before onMouseOut
            over: function() {                                
                this.className+="hover";
                if(this.id=="000" || this.id=="111" ||this.id=="333")
                {
                    changecolor(this.id);
                }
                    
            }, // function = onMouseOver callback (REQUIRED)
            out: function() {
                this.className=this.className.replace("hover","");
                if(this.id=="000" || this.id=="111" ||this.id=="333")
                {
                    togglecolor(this.id);
                }               
            } // function = onMouseOut callback (REQUIRED)
    
        }        
        $('.navitem').hoverIntent(hoverConfig);
    });
</script>
     
    
            
    
