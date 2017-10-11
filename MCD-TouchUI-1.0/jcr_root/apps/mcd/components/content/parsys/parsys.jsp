<%--
  
  parsys component

  Includes all child resources but respects the columns control resources and
  layouts the HTML accordingly.
  
--%><%@page import="com.day.cq.wcm.foundation.Paragraph,
                    com.day.cq.wcm.foundation.ParagraphSystem,
                    com.day.cq.wcm.api.components.IncludeOptions,
                    com.day.cq.commons.jcr.JcrConstants,
                    com.day.cq.wcm.api.WCMMode" %><%
%>
<%@include file="/apps/mcd/global/global.jsp"%>


<%
    
    //Out of box code to get an object of ParagraphSystem, a String type variable newType and hasColumn
    //To check for column control
    ParagraphSystem parSys = new ParagraphSystem(resource, request.getParameter("cq_diffTo"));
    String newType = resource.getResourceType() + "/new";
    boolean hasColumns = false;
    int columnNum = 0;//To get the column number of the column starting with 0
    String clmCntrlCheckRndCorners="";//To check whether round corners should be included or not
    String clmCntrlBackgroundValue ="";//To store the column control background values entered in the dialog
    String distinctID="";//To have a distinct ID for all the control elements 
    //To use a default color if no value for background
    //color is entered for a particular column in the dialog
    String defaultColor="";
    //To extract individual color value from the comma 
    //seperated background values entered in the dialog
    String backGroundValues[]=null;
    int paddingTop=0;
    int paddingBottom =0;
    int paddingRight=0;
    int paddingLeft=0;
    int marginTop=0;
    int marginBottom =0;
    int marginRight=0;
    int marginLeft=0;
    String rounded = "";
    String showColors = "";
    String pagePath = "";
    boolean flagNode=true;//Takes value from ColumnCntrlNode if its true else from the site level node
    boolean valueNotModified=true;// false if value has been modified at the component level
    //Initialize array index here 
    int colctrl_count = -1;
    String bgColor="";
    //Out of box for loop to iterate through all the 
    //components embedded on paragraph system
    for (Paragraph par: parSys.paragraphs()) {
        if (editContext != null) {
            editContext.setAttribute("currentResource", par);
        }
        //try catch to embed the code to get values from the dialog
        //of column control component
        try
        {
            String nodeName =   par.getPath().substring(par.getPath().lastIndexOf("/")+1);
            //Check whether the node is of column control component
            if(nodeName.toLowerCase().indexOf("colctrl")>-1) {
                //initialize the column control variables
                columnNum = 0;
                clmCntrlBackgroundValue="";
                clmCntrlCheckRndCorners="";
                //Get a new node object if the node is of column control type and 
                //further get its properties
                Node columnCntrlNode = slingRequest.getResourceResolver().getResource(par.getPath()).adaptTo(Node.class);
           

                //these are updated from site settings if not present on the node, or if usingSiteValues==true
                boolean usingSiteValues=false;
                if(columnCntrlNode.hasProperty("useSiteLevel")){
                  if (columnCntrlNode.getProperty("useSiteLevel").getValue().getString().equals("y"))
                        usingSiteValues=true;
                }
                        
                        Node sitelevelproperties =getSiteLevelPropertiesNode(slingRequest, pageProperties, currentDesign);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"paddingTop","",usingSiteValues);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"paddingBottom","",usingSiteValues);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"paddingRight","",usingSiteValues);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"paddingLeft","",usingSiteValues);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"marginTop","",usingSiteValues);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"marginBottom","",usingSiteValues);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"marginRight","",usingSiteValues);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"marginLeft","",usingSiteValues);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"backgroundColumnctrl","",usingSiteValues);
                        setValueFromSite(sitelevelproperties,columnCntrlNode,"checkColumnctrl","",usingSiteValues);
        
                paddingTop=getIntValue(columnCntrlNode,"paddingTop");
                paddingBottom=getIntValue(columnCntrlNode,"paddingBottom");
                paddingLeft=getIntValue(columnCntrlNode,"paddingLeft");
                paddingRight=getIntValue(columnCntrlNode,"paddingRight");
                marginTop=getIntValue(columnCntrlNode,"marginTop");
                marginBottom=getIntValue(columnCntrlNode,"marginBottom");
                marginLeft=getIntValue(columnCntrlNode,"marginLeft");
                marginRight=getIntValue(columnCntrlNode,"marginRight");
                clmCntrlBackgroundValue = columnCntrlNode.getProperty("backgroundColumnctrl").getValue().getString();
                
                //clmCntrlBackgroundValue = clmCntrlBackgroundValue.replaceAll("No Color"," ");
                clmCntrlCheckRndCorners = "";
                if(columnCntrlNode.hasProperty("checkColumnctrl"))clmCntrlCheckRndCorners = columnCntrlNode.getProperty("checkColumnctrl").getValue().getString();
                
                showColors = "";
                if(columnCntrlNode.hasProperty("showColors"))showColors = columnCntrlNode.getProperty("showColors").getValue().getString();
                
                //Derive various colors entered and then set default color accordingly
                backGroundValues=clmCntrlBackgroundValue.split(":");
                defaultColor=backGroundValues[backGroundValues.length-1];
                }
            
        }
        catch(Exception ex)
        {
            log.error("Column control could not be rendered: " + ex.getMessage());
        }
        
        // Erik W 5-26-2010
        bgColor=defaultColor;
        if(backGroundValues!=null && backGroundValues.length>columnNum)bgColor=backGroundValues[columnNum];   
        //bgColor='#'+bgColor;    
        //Out of box code snippet for switch case 

        switch (par.getType()) {
            case START:
                if (clmCntrlCheckRndCorners.contains("check")) {
                    rounded = "roundedcheck";
                }
                
                pagePath = currentPage.getPath();
                if ((pagePath.contains("apmea/au")) || (pagePath.contains("apmea/nz"))) {
                } else {
                    if (showColors.contains("check")) {
                        bgColor = "";
                    }
                }
                
                //Get distinct id of each column control element
                distinctID=par.getPath().substring(par.getPath().lastIndexOf("/")+1);
                if (hasColumns) {
                    // close in case missing END
                    %></div></div><%
                }
                if (editContext != null) {
                    // draw 'edit' bar
                    IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
                    %><sling:include resource="<%= par %>"/><%
                }
                // open outer div
                %><div id="mainColumnCntrl" class="parsys_column <%= par.getBaseCssClass()%>" ><%
                // open column div
                %>
                    <div style="box-sizing:content-box;" class="parsys_column <%= par.getCssClass() %>" >
                    <%
                    //out.println(renderTopContainer(distinctID,columnNum,bgColor));                    
                    out.println("\n\r<div class='containerColumnCntrl' id='container"+distinctID+columnNum+"' style='margin: "+marginTop+"px "+marginRight+"px "+marginBottom+"px "+marginLeft+"px;'>");
                    //out.println(renderTopCorner(distinctID,columnNum,clmCntrlCheckRndCorners,bgColor));
                    out.println("\n\r<div id='main"+distinctID+columnNum+"' class='columncontrolmain "+bgColor+" "+rounded+"' style='padding: "+paddingTop+"px "+paddingRight+"px "+paddingBottom+"px "+paddingLeft+"px;'>");
                    
                    hasColumns = true;
                break;
            case BREAK:
                if (editContext != null) {
                    // draw 'new' bar
                    IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
                    %><sling:include resource="<%= par %>" resourceType="<%= newType %>"/><%
                }
                %>   
                       </div>
                <%
                //Render bottom round corners
                //out.println(renderBottomCorner(distinctID,columnNum,clmCntrlCheckRndCorners,bgColor));
                %>
                       </div>
                    </div>  
                <%
                    columnNum++;
                    // open next column div
                %>
                    <div style="box-sizing:content-box;" class="parsys_column <%= par.getCssClass() %>">
                    <%
                    bgColor=defaultColor;
                    if(backGroundValues!=null && backGroundValues.length>columnNum)bgColor=backGroundValues[columnNum];
                    
                    pagePath = currentPage.getPath();
                    if ((pagePath.contains("apmea/au")) || (pagePath.contains("apmea/nz"))) {
                    } else {
                        if (showColors.contains("check")) {
                            bgColor = "";
                        }
                    }
                    
                    //bgColor='#'+bgColor;
                    out.println("\n\r<div class='containerColumnCntrl' id='container"+distinctID+columnNum+"' style='margin: "+marginTop+"px "+marginRight+"px "+marginBottom+"px "+marginLeft+"px;'>");
                    //out.println(renderTopCorner(distinctID,columnNum,clmCntrlCheckRndCorners,bgColor));
                    out.println("\n\r<div id='main"+distinctID+columnNum+"' class='columncontrolmain "+bgColor+" "+rounded+"' style='padding: "+paddingTop+"px "+paddingRight+"px "+paddingBottom+"px "+paddingLeft+"px;'>");
                break;
            case END:
                if (editContext != null) {
                    // draw new bar
                    IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
                    %><sling:include resource="<%= par %>" resourceType="<%= newType %>"/><%
                }
                if (hasColumns) {
                %>
                   </div>
                <%
                //Render bottom round corners
                //out.println(renderBottomCorner(distinctID,columnNum,clmCntrlCheckRndCorners,bgColor));
                
                // close divs and clear floating
                %>
                    </div></div></div><div style="clear:both"></div><%
                    hasColumns = false;
                    bgColor=defaultColor;
                    if(backGroundValues!=null && backGroundValues.length>columnNum)bgColor=backGroundValues[columnNum];
                    
                    pagePath = currentPage.getPath();
                    if ((pagePath.contains("apmea/au")) || (pagePath.contains("apmea/nz"))) {
                    } else {
                        if (showColors.contains("check")) {
                            bgColor = "";
                        }
                    }
                    
                    columnNum++;
                }
                if (editContext != null && WCMMode.fromRequest(request) == WCMMode.EDIT) {
                    // draw 'end' bar
                    IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
                    %><sling:include resource="<%= par %>"/><%
                }
                
                if(!( (clmCntrlBackgroundValue.equals("")) || (clmCntrlBackgroundValue.contains(" ")) )) {
                    //if (WCMMode.fromRequest(request) != WCMMode.EDIT) {
                    %>
                    <script>
                        // append values in array here                  
                        insertInColctrlArray('<%=distinctID%>',<%=columnNum%>,'<%= ++colctrl_count%>');                   
                    </script>
                    <%
                    //}
                }
                break;
            case NORMAL:
                // include 'normal' paragraph
                IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
                
                // draw anchor if needed
                if (currentStyle.get("drawAnchors", false)) {
                    String path = par.getPath();
                    path = path.substring(path.indexOf(JcrConstants.JCR_CONTENT) 
                            + JcrConstants.JCR_CONTENT.length() + 1);
                    String anchorID = path.replace("/", "_").replace(":", "_");
                    %><a name="<%= anchorID %>" style="visibility:hidden"></a><%
                }
                %><sling:include resource="<%= par %>"/><%
                break;
        }
    }
    if (hasColumns) {
        // close divs in case END missing. and clear floating
        %></div></div><div style="clear:both"></div><%
    }
    if (editContext != null) {
        editContext.setAttribute("currentResource", null);
        // draw 'new' bar
        IncludeOptions.getOptions(request, true).getCssClassNames().add("section");
        %><cq:include path="*" resourceType="<%= newType %>"/><%
    }
    
    // add column hover effect only for AU, yellow columns (legacy)
    if(resource.getPath().contains("/accessmcd/apmea/au") && bgColor.equals("sitecolor3"))
    {
%>
<script>
    function hoverColumnColors(count,color1,color2){
         for(var i=0;i<6;i++)
          {
           $("#top"+i+count+".rndcrnr"+color1).removeClass("rndcrnr"+color1).addClass("rndcrnr"+color2);
           $("#bottom"+i+count+".rndcrnr"+color1).removeClass("rndcrnr"+color1).addClass("rndcrnr"+color2);
          }       
       //   $("#main"+count+"."+color1).removeClass(color1).addClass(color2);            
        //  $("#main"+count).find("."+color1).removeClass(color1).addClass(color2);
             
                   
    }
    $(function(){
        var distinctID = "";
        var color = "";
            
        leftConfig = {
            sensitivity: 1, // number = sensitivity threshold (must be 1 or higher)
            interval: 0, // number = milliseconds for onMouseOver polling interval
            timeout: 0, // number = milliseconds delay before onMouseOut
            over: function() {                                
                distinctID = this.id.substring("container".length);
                hoverColumnColors(distinctID,"sitecolor3","sitecolor4");
            }, 
            out: function() {               
                distinctID = this.id.substring("container".length);
                hoverColumnColors(distinctID,"sitecolor4","sitecolor3");
            } 
    
        }        
        $('.containerColumnCntrl').hoverIntent(leftConfig);
    });

</script>
<%
    }
%>
<%!
    //if properties are not present on the colnode, populate them from the sitenode
    //Erik W 5-26-2010
    public void setValueFromSite(Node sitelevelnode,Node colnode,String propertyname,String defaultvalue,boolean useSite){
        try{
            if(!colnode.hasProperty(propertyname) || useSite){
                String propvalue=defaultvalue;
                if(sitelevelnode!=null){
                    propvalue=sitelevelnode.getProperty(propertyname).getString();
                    if(colnode.hasProperty(propertyname)){
                        if(!propvalue.equals(colnode.getProperty(propertyname).getString())){
                            colnode.setProperty(propertyname,propvalue);
                            colnode.save();
                        }
                    }else{
                           colnode.setProperty(propertyname,propvalue);
                           colnode.save();
                    }
                }else{//no site property
                     if(colnode.hasProperty(propertyname)){
                         colnode.setProperty(propertyname,(Node)null);
                         colnode.save();
                     }
                }
            }
        }catch(Exception e){
            System.out.println("Could not set site value for property: "+propertyname+" " + e.getMessage());      
        }
        return;
    }
    //Function used for creating top and bottom round corners
    public String createRndCorner(String position, String distinctID, int columnNum, String bgColor)
    {
       StringBuffer rndCorner = new StringBuffer(); 
       rndCorner.append("\n\r<div class='roundCornerClmCtrl'>");
       
       String commonstyles="display:block;height:1px;overflow:hidden;border-left:1px solid "+bgColor+"; border-right:1px solid "+bgColor+";background:"+bgColor+";";
      
       if("top".equals(position))//If top round corners need to be rendered
       {

//Customize, make changes to rounded corners, 05/2010, JZ

           rndCorner.append("\n\r<b id='"+position+"0"+distinctID+columnNum+"' class='rndcrnr"+bgColor+"'>");
           rndCorner.append("\n\r<b id='"+position+"1"+distinctID+columnNum+"' class='crnr"+bgColor+" "+bgColor+" rndcorner1'><b></b></b>");
           rndCorner.append("\n\r<b id='"+position+"2"+distinctID+columnNum+"' class='crnr"+bgColor+" "+bgColor+" rndcorner2'><b></b></b>");
           rndCorner.append("\n\r<b id='"+position+"3"+distinctID+columnNum+"' class='crnr"+bgColor+" rndcorner3'></b>");
           rndCorner.append("\n\r<b id='"+position+"4"+distinctID+columnNum+"' class='crnr"+bgColor+" rndcorner4'></b>");
           rndCorner.append("\n\r<b id='"+position+"5"+distinctID+columnNum+"' class='crnr"+bgColor+" rndcorner5'></b></b>");
       }
       else//If bottom round corners need to be rendered
       {
 
//Customize, make changes to rounded corners, 05/2010, JZ
           rndCorner.append("\n\r<b id='"+position+"0"+distinctID+columnNum+"' class='rndcrnr"+bgColor+"'>");
           rndCorner.append("\n\r<b id='"+position+"1"+distinctID+columnNum+"' class='rndcorner5 crnr"+bgColor+"'></b>");
           rndCorner.append("\n\r<b id='"+position+"2"+distinctID+columnNum+"' class='rndcorner4 crnr"+bgColor+"'></b>");
           rndCorner.append("\n\r<b id='"+position+"3"+distinctID+columnNum+"' class='rndcorner3 crnr"+bgColor+"'></b>");
           rndCorner.append("\n\r<b id='"+position+"4"+distinctID+columnNum+"' class='rndcorner2 crnr"+bgColor+" "+bgColor+"'><b></b></b>");
           rndCorner.append("\n\r<b id='"+position+"5"+distinctID+columnNum+"' class='rndcorner1 crnr"+bgColor+" "+bgColor+"'><b></b></b></b>");


       }
      
       rndCorner.append("\n\r</div>");
       
       return rndCorner.toString();
    }
    
    //Function for rendering top round corners
    public String renderTopCorner(String distinctID,int columnNum,String clmCntrlCheckRndCorners,String bgColor)
    {
 
        if(clmCntrlCheckRndCorners.equalsIgnoreCase("check") && (!bgColor.equals("")))
        {
            return createRndCorner("top", distinctID, columnNum, bgColor);   
        }
        return "";
    }
    
    //Function for rendering bottom round corners
    public String renderBottomCorner(String distinctID,int columnNum,String clmCntrlCheckRndCorners,String bgColor)
    {
        if(clmCntrlCheckRndCorners.equalsIgnoreCase("check") && (!bgColor.equals("")))
        {
            return createRndCorner("bottom", distinctID, columnNum, bgColor);
        }
        return "";
    }
    
    private int getIntValue(Node colNode,String prop){
        int retVal=0;
        try{
            if(colNode.hasProperty(prop)){
                retVal=Integer.parseInt(colNode.getProperty(prop).getValue().getString());
            }            
        }catch(Exception e){
            // nothing here.
        }
        return retVal;
    }
%>