   <%-- ################################################################################ 
 # DESCRIPTION: Render the navigation in form of JSON object, based on view and audience type. 
 #              Used in navigation bar.
 #  
 # Environment: 
 # 
 # UPDATE HISTORY       
 # 1.0  Deepali Goyal Initial Version
 #
 #####################################################################################--%>
<%@ page import="java.util.ArrayList,
        java.util.Iterator,
        java.util.Date,
        com.day.cq.wcm.api.PageFilter,
        com.day.cq.security.User,
        com.mcd.accessmcd.util.CommonUtil,
        java.util.Iterator,javax.jcr.Value,
        java.util.Map,
        java.util.TreeMap,
        java.util.Set,
        com.day.cq.wcm.api.PageFilter,
        java.text.ParseException,
        java.text.SimpleDateFormat,
        java.text.DateFormat"%>
       

<%@ page import="com.mcd.stockticker.facade.StockTickerFacadeImpl" %>
<%@ page import="com.mcd.stockticker.constants.StockTickerConstants" %>
<%@ page import="com.mcd.stockticker.bean.StockDetails" %>
<%@ page import="com.mcd.stockticker.util.StockUtil" %><%
%>

<%@include file="/apps/mcd/global/global.jsp"%> 
<% 
 response.setHeader("Cache-Control","no-cache"); 
//STOCK DETAILS
StockTickerFacadeImpl facade = new StockTickerFacadeImpl();
StockDetails stockBean = facade.getStockInfo(StockTickerConstants.url, StockTickerConstants.timeout);  
String currentPrice = "";
String changePrice = "";
String stockImgName = "down-arrow.png" ; 
if(stockBean != null) {
    StockUtil sUtil = new StockUtil();
    currentPrice = stockBean.getTradePrice();
    changePrice = stockBean.getChange();       
    double price = 0;
    try{
         price = Double.valueOf(changePrice.trim()).doubleValue();
       }catch(NumberFormatException e){
        log.error("moreinfo.jsp Error " + e.getMessage());  
       }
    if(price > 0){
        changePrice = "+" + changePrice;
        stockImgName = "up-arrow.png" ;
    } else if(price < 0){
        stockImgName = "down-arrow.png" ;
    } 
} 
%>
<% 
String allViews =prop.getProperty("allview");  
String [] cview = null;
 if(allViews.contains(","))
 {
  cview= allViews.split(",");
 }
 
CommonUtil commonUtil = new CommonUtil();
String[] requestUrl = request.getRequestURI().split("\\."); 
String view = "corp"; 
String path = globalPath;
String navPath = prop.getProperty("corp_nav");
try {
view = requestUrl[3];  
navPath = prop.getProperty(view+"_nav"); 
path = prop.getProperty(view); 

} catch(Exception e) { }
   
if(path ==  null)
 path = globalPath;
      
if(navPath ==  null)
 navPath = prop.getProperty("corp_nav");
  
%>
{ "Navigation" : [ 
<%
Page globalPage= pageManager.getPage(navPath);
Iterator<Page> myChildren = globalPage.listChildren(new PageFilter(request));  
String seperator = ""; 
String title = "";
boolean hide;
String parentTitle="";
String actualPath = "";
String actualchildPath = "";

String enableFlyout = "";
String columnCount="off";
String minLinks="0";
Node flyoutNode=null;
int levelonecount=0;


if(slingRequest.getResourceResolver().getResource(path+"/jcr:content/navigationpara")!=null)
      {
         flyoutNode = slingRequest.getResourceResolver().getResource(path+"/jcr:content/navigationpara").adaptTo(Node.class);
      }
      if(flyoutNode!=null)
      {   
          if(flyoutNode.hasProperty("enableFlyout")){
              enableFlyout = flyoutNode.getProperty("enableFlyout").getString();
          }
          
          if(flyoutNode.hasProperty("numOfCols")){
              columnCount = flyoutNode.getProperty("numOfCols").getString();
          }
          
          if(flyoutNode.hasProperty("minLinkCount")){
              minLinks = flyoutNode.getProperty("minLinkCount").getString();
          }
      }
      
      if (!enableFlyout.equals("enabled")) {
          columnCount = "off";
      }

//main navigation links
while(myChildren.hasNext()){
    Page child =  (Page) myChildren.next();
    String redirectURL = child.getProperties().get("redirectTarget", child.getPath()).replaceAll("/content/","/") ;
    title =  child.getProperties().get("navTitle","").trim().equals("")?commonUtil.getTitle(child):child.getProperties().get("navTitle","");   
    redirectURL=commonUtil.getValidURL(redirectURL);
    actualPath  = commonUtil.getValidURL(child.getPath().replaceAll("/content/","/"));
    
    //  changes for the hide top navigation
    String hideInNav = "";
     hide = false;
     Page thisPage = child ;
     ValueMap props = thisPage .getProperties();
     try
     {
     Node childNode = slingRequest.getResourceResolver().getResource(thisPage.getPath()+"/jcr:content").adaptTo(Node.class); 
       if(childNode.hasProperty("hideinnav"))
       {
            try {
                Value []p=childNode.getProperty("hideinnav").getValues(); 
                for(int i=0;i<p.length;i++)
                {
                  if(p[i].getString().trim().equalsIgnoreCase("navbar")){
                      hide =true;break;
                   }
                 }
              }catch ( javax.jcr.ValueFormatException e){
                   hideInNav = props.get("hideinnav","");
                   if(hideInNav.equals("navbar")) {
                      hide = true;
                   }
              }
     
       }
     
         parentTitle=title;
    }
    catch(Exception e)
    {
    }  
    if(!hide)
    {      
    %>
        <%=(levelonecount>0?",":"")%>{"Title" : "<%=title %>",  
        "URL" : "<%=redirectURL%>",
        "redURL" : "<%= actualPath%>",
        "children" : [        
    <%
    levelonecount++;

    Iterator<Page> subChildren = child.listChildren(new PageFilter(request));
    //sub navigation links
    boolean currentSelected=false;
    int leveltwocount=0;
    while(subChildren.hasNext()){ 
       
            Page subChild =  (Page) subChildren.next();
            String childRedirectURL = subChild.getProperties().get("redirectTarget", subChild.getPath()).replaceAll("/content/","/") ;
            title = subChild.getProperties().get("navTitle","").trim().equals("")?commonUtil.getTitle(subChild):subChild.getProperties().get("navTitle","");   
            childRedirectURL=commonUtil.getValidURL(childRedirectURL);
            actualchildPath  = commonUtil.getValidURL(subChild.getPath().replaceAll("/content/","/"));
            String launchType = subChild.getProperties().get("launchType","_self");
           
             hide = false;
             thisPage = subChild;
           try
           {
                 Node subchildNode = slingRequest.getResourceResolver().getResource(thisPage.getPath()+"/jcr:content").adaptTo(Node.class); 
                 props = thisPage.getProperties();
                if(subchildNode.hasProperty("hideinnav"))
                {
                try {
                        Value []p=subchildNode.getProperty("hideinnav").getValues(); 
                        for(int i=0;i<p.length;i++)
                        {
                           if(p[i].getString().trim().equalsIgnoreCase("navbar")){
                              hide =true;break;
                           }
                         }
                          
                  }catch ( javax.jcr.ValueFormatException e){
                       hideInNav = props.get("hideinnav","");
                       if(hideInNav.equals("navbar")) {
                                 hide = true;
                       }
                  }
                }
             
         if(!hide)
         {
           %> 
            <%=(leveltwocount>0?",":"")%>
            {"Title" : "<%=title %>",
             "URL" : "<%=actualchildPath %>",
             "redURL" : "<%= childRedirectURL %>",
             "Launch" : "<%= launchType %>"}
        <%   
         leveltwocount++;
         } 
        }
        catch(Exception e)
        {
         out.println("error");
        }       
    } 
    %>
    ]}
    <% 
   }//not hidden
} 
 
%>
    ], 
<%
final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
String stockLabel = "";
String bookmarksLinkText = "";
String globalAdText = "";
String childURL = "";
String mcdAudience= "";
try
   {
    Resource res = slingRequest.getResourceResolver().getResource(currentPage.getPath() + "/jcr:content/navigationpara");
   
// try {
    if(null!=res) {
        Node userlinksNode = res.adaptTo(Node.class);
        
        //retrieve stock label
        stockLabel = userlinksNode.hasProperty("./stocklabel") ? userlinksNode.getProperty("./stocklabel").getString() : "MCD";
        
             
        //retrieve bookmarks link text
        bookmarksLinkText = userlinksNode.hasProperty("./bookmarksLinkText") ? userlinksNode.getProperty("./bookmarksLinkText").getString() : "My Bookmarks";
        bookmarksLinkText  = bookmarksLinkText + "&nbsp; <img src='/images/downArrow.png'/>";   
        
         
    
      //retrieve global ad text data from campaign component
        int flag=0;
        Node pageNode = slingRequest.getResourceResolver().getResource(path+"/jcr:content").adaptTo(Node.class); 
        NodeIterator nodeIterator = pageNode.getNodes();
       
        while(nodeIterator.hasNext())
        {
        
            Node childNode = nodeIterator.nextNode();
            if(childNode.hasNodes())
            {
                NodeIterator childNodeIterator = childNode.getNodes();
                while(childNodeIterator.hasNext())
                {
                    Node subChildNode = childNodeIterator.nextNode();                                            
                    if(subChildNode.getName().equals("campaigncomponent")) 
                    {    
                        mcdAudience = user.getProperty("rep:mcdAudience");
                        if(mcdAudience == null || "null".equals(mcdAudience) || mcdAudience.equals("")) 
                                    mcdAudience = "CorpEmployees" ; 
                                   //globalAdText  = 
                               if(subChildNode.hasProperty("campdata"))
                               { 
                                String [] camps;
                                try                                                 // if it is a multi valued property
                                {
                                 Value [] k=  subChildNode.getProperty("campdata").getValues();
                                  camps = new String[k.length];
                                 for(int i = 0 ;i < k.length ; i++)
                                 {
                                  camps[i] = k[i].getString();
                                 }
                                }
                                catch(Exception e)                                        // if it is a single String
                                {
                                 camps = new String[1];
                                 camps[0] = subChildNode.getProperty("campdata").getString();
                                }
                  
                               String text="";
                               String link= ""; 
                               for(int i =0 ;i < camps.length ;i++) 
                                   {    
                                     String val[] = camps[i].split("\\|");
                                     String mcAud=val[3];
                                     if(((mcAud).indexOf(mcdAudience))!=-1)
                                       {
                                          Date curr = new java.util.Date(); 
                                          Date d1,d2;
                                          d1=new Date(val[4]);
                                          d2=new Date(val[5]);
                                           
                                           if(d1.compareTo(curr) <= 0 && curr.compareTo(d2) <=0) 
                                               {
                                                   flag = 1;
                                                   text = val[2];
                                                   link = commonUtil.getValidURL(val[1]);
                                                }
                                       }
                                   } 
                                   %>
                                 "globalAddtext":"<%= text %>",
                                      "link":"<%= link %>",
                                   <%
                    }   
                    }
               }
             }
          }   
         
      }
              
    }
   catch(Exception e)
   {
   }
 

%> 
"stockLabel" : "<%=stockLabel %>",
"currentPrice" : "$<%=currentPrice %>",
"changePrice" : "<%=changePrice %>", 
"stockImageName" : "<%=stockImgName %>",    
"bookmarksLinkText" : "<%=bookmarksLinkText %>",
"path" : "<%=path%>",

"DYK":[ 
<%
      String linkDYK="";
      String titleDYK="";
      String type="";
      String headings="0";       
      String [] browse=new String[5];
      Node pageNode=null;
      
      if(slingRequest.getResourceResolver().getResource(path+"/jcr:content/navigationpara")!=null)
      {
         pageNode = slingRequest.getResourceResolver().getResource(path+"/jcr:content/navigationpara").adaptTo(Node.class);
      }
      
      
      if(pageNode!=null)
      {
      
       if(pageNode.hasProperty("linkDYK")){
                  linkDYK = pageNode.getProperty("linkDYK").getString(); 
        }
       
       if(pageNode.hasProperty("titleDYK")){
                  titleDYK = pageNode.getProperty("titleDYK").getString(); 
        }       
  
      if(pageNode.hasProperty("type")){
                  type = pageNode.getProperty("type").getString(); 
        }       
      if(pageNode.hasProperty("headings")){
                  headings = pageNode.getProperty("headings").getString(); 
        }  
        if(pageNode.hasProperty("browse")){

           
            try {
                    Value []p=pageNode.getProperty("browse").getValues(); 
                    for(int i=0;i<p.length;i++)
                    {
                      if(i>=5)break;
                       browse[i]=p[i].getString();
                     }
                      
                  }catch ( javax.jcr.ValueFormatException e){
                  
                      browse[0] = pageNode.getProperty("browse").getValue().getString();
                  }
           
                                    
        }     
  }
       
 
       int head=0;
          if(headings!=null)
          {
             head= Integer.parseInt(headings);
          }
                String viewPagePath = currentPage.getPath();
                
                
                String homeView="";
                Boolean isHomepage=false;
                  
                if(view!=null || !view.trim().equals(""))
                {
                  homeView=prop.getProperty(view); 
                }
                if(homeView!=null)
                {
                    if(viewPagePath.indexOf(".")>0)
                    {
                        String [] pages= viewPagePath.split(".");
                        homeView=pages[0];
                    }else
                    {
                        homeView=viewPagePath;
                    } 
                }
              
               if(cview != null)
               {
                for(int i =0 ; i < cview.length ; i++) 
                {
                 if(prop.getProperty(cview[i]) != null)
                 {
                  if( homeView.trim().equalsIgnoreCase(prop.getProperty(cview[i])) )
                  {
                   isHomepage=true;
                   break;
                  }
                 }
                }
               }     
              
           
              int first=1;
              %>
       
          
             <%
                if(isHomepage)
                  { 
                       
                       %>  
                      
                                          <%
                                                 String dykView="";   
                                                 if(cview != null)
                                                 {
                                                  for(int i =0 ; i < cview.length ; i++) 
                                                  {
                                                   if(prop.getProperty(cview[i]) != null)
                                                   {
                                                    if(currentPage.getPath().startsWith(prop.getProperty(cview[i])) )
                                                    {
                                                     dykView=prop.getProperty("DYKPath_" + cview[i]);
                                                     break;
                                                    }
                                                   }
                                                  }
                                                 }     
                                            
                                
                                                %>
                                             
                                                <%
                                                     if(false && type.equals("manual"))
                                                   {    
                                                            String manualBrowse = "";
                                                            for(int m =0;m < browse.length;m++)
                                                            {
                                                               if(browse[m]!=null)
                                                               {
                                                                    
                                                                   Page browsePaths = pageManager.getPage(browse[m]);
                                                                   if(browsePaths!=null)
                                                                   {
                                                                    if(browsePaths.getDescription()!=null)
                                                                    {    
                                                                         if(browsePaths.getDescription().length() >180)
                                                                         {
                                                                             manualBrowse = browsePaths.getDescription();
                                                                             
                                                                             manualBrowse = manualBrowse.replaceAll("\n"," ");
                                                                             manualBrowse = manualBrowse.replaceAll("<(.|\n)*?>","");
                                                                             manualBrowse = manualBrowse.replaceAll("\"","'");
                                                                             
                                                                             manualBrowse = manualBrowse.substring(0,180) + "..." ;
                                                                         } 
                                                                         else
                                                                         {
                                                                             manualBrowse = browsePaths.getDescription();
                                                                             manualBrowse = manualBrowse.replaceAll("\n"," ");
                                                                             manualBrowse = manualBrowse.replaceAll("<(.|\n)*?>","");
                                                                             manualBrowse = manualBrowse.replaceAll("\"","'");
                                                                         }
                                                                     }  
                                                                     else
                                                                         out.println("Description is null");
                                                                       
                                                                       
                                                                       if(first!=1){out.println(",");}
                                                                       first=0;  
                                                                         
                                                                     %>
                                                                         {"dykURL":"<%=commonUtil.getValidURL(browsePaths.getPath())%>","dykDesc":"<%= manualBrowse %>"}
                                                                     <%
                                                                     }
                                                               }
                                                        }
                                                             
                                                    }                                                   
                                                    else  if(false && type.equals("automated"))    
                                                    {
                                                             
                                                             
                                                             
                                                             Page startPage = pageManager.getPage(dykView);
                                                             
                                                             if(startPage!=null)
                                                             { 
                                                                 myChildren = startPage.listChildren(new PageFilter(request));
                                                             
                                                             Page [] dykPage=new Page[10];
                                                             TreeMap<Date,Page> dykpageMap=new TreeMap<Date,Page>();
                                                             DateFormat formatter = new SimpleDateFormat("dd/mm/yyyy");     
                                                             if(myChildren != null)
                                                             {
                                                             while(myChildren.hasNext())
                                                             {
                                                                      Page child =  (Page) myChildren.next();
                                                                      String dateValue=child.getProperties().get("dykArticleDate","");
                                                                      if(!(dateValue.equals("")))
                                                                      {
                                                                             try
                                                                             {
                                                                                   Date date=(Date)formatter.parse(dateValue);
                                                                                   dykpageMap.put(date,child);
                                                                             }
                                                                             catch(ParseException pe)
                                                                             {
                                                                                  log.error("Error in parsing Date");
                                                                             }        
                                                                       } 
                                                               }
                                                               }                 

                                                               Set dykmapSet=dykpageMap.descendingKeySet();                                                                                                                                
                                                               int count=0;
                                                               String dykDesc="";
                                                               for (Iterator i = dykmapSet.iterator(); i.hasNext();) 
                                                               {
                                                                                                                                 
                                                                     if(count==head) 
                                                                             break;
                                                                      count++;
                                                                      Date key = (Date) i.next();        
                                                                      dykPage[count]= (Page)dykpageMap.get(key);   
                                                                      if(dykPage[count].getDescription()!=null)
                                                                      {   
                                                                          dykDesc=dykPage[count].getDescription();
                                                                          dykDesc = dykDesc.replaceAll("\n"," ");
                                                                          dykDesc = dykDesc.replaceAll("<(.|\n)*?>","");
                                                                          dykDesc = dykDesc.replaceAll("\"","'");
                                                                      }
                                                                      if(dykDesc.length()>=180)
                                                                      {
                                                                          dykDesc=dykDesc.substring(0,180)+"...";
                                                                      }
                                                                       
                                                                       if(first!=1){out.println(",");}
                                                                       first=0;
                                                                     %>
                                                                         {"dykURL":"<%=commonUtil.getValidURL(dykPage[count].getPath())%>","dykDesc":"<%=dykDesc%>"}
                                                                     <%
                                                                 }
                                                                 }
                                                        }%> 
                                                    
                                                    
                                                           
               <% 
              } 
            else
            { }
            %>
           
           
          ],"dykTitle":"<%=titleDYK%>","dykLink":"<%=commonUtil.getValidURL(linkDYK)%>","flyoutColumns":"<%=columnCount%>","minLinksPerColumn":"<%=minLinks%>" 
          }    
     