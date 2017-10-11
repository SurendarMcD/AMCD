<%--
==============================================================================
MCD Global WCM script. 

This script can be used by any other script in order to get the default
tag libs, sling objects and CQ objects defined.

the following page context attributes are initialized via the <cq:defineObjects/>
tag:

  @param slingRequest SlingHttpServletRequest
  @param slingResponse SlingHttpServletResponse
  @param resource the current resource
  @param currentNode the current node    
  @param log default logger
  @param sling sling script helper

  @param componentContext component context of this request
  @param editContext edit context of this request
  @param properties properties of the addressed resource (aka "localstruct")
  @param pageManager page manager
  @param currentPage containing page addressed by the request (aka "actpage")
  @param resourcePage containing page of the addressed resource (aka "myPage")
  @param pageProperties properties of the containing page
  @param component current CQ5 component
  @param designer designer
  @param currentDesign design of the addressed resource  (aka "actdesign")
  @param resourceDesign design of the addressed resource (aka "myDesign")
  @param currentStyle style of the addressed resource (aka "actstyle")

==============================================================================
--%> 
<%@page session="false" import="javax.jcr.*,
      com.day.cq.wcm.api.Page,
      com.day.cq.wcm.api.PageManager,
      org.apache.sling.api.resource.Resource,
      org.apache.sling.api.SlingHttpServletRequest,
      org.apache.sling.api.SlingHttpServletRequest,
      com.day.cq.wcm.commons.WCMUtils,
      com.day.cq.wcm.api.NameConstants,
      com.day.cq.wcm.api.designer.Designer,
      com.day.cq.wcm.api.designer.Design,
      com.day.cq.wcm.api.designer.Style,
      org.apache.sling.api.resource.ValueMap,
      com.day.cq.wcm.api.components.ComponentContext,
      com.day.cq.wcm.api.components.EditContext,
      com.mcd.util.PropertiesLoader,
      java.util.Properties,
      com.mcd.bumper.BumperEncryption,
      java.util.Locale,
      java.util.ResourceBundle,
      com.day.cq.i18n.I18n"
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%
%><%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %><%
%><%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%
%><cq:defineObjects />
<%
 // Bumper object
    BumperEncryption bumperEncryption = new BumperEncryption();
       
    
    // Property file object to get the default values
    String label = currentPage.getAbsoluteParent(2) != null ? currentPage.getAbsoluteParent(2).getName() : currentPage.getName();

	/* After Upgrade Change Start */

	//Properties prop = PropertiesLoader.loadProperties("common.properties");

	Properties prop = PropertiesLoader.loadProperties("com/mcd/util/common.properties");

	/* After Upgrade Change End */

	String globalPath = prop.getProperty("corp");  
    String usPath = prop.getProperty("us");  
    String auPath = prop.getProperty("au"); 
    String mcsourcePath = prop.getProperty("mcsource"); 
   
    // For Internationalisation Support
    Locale pageLocale = currentPage.getLanguage(false);
   
    //If above bool is set to true. CQ looks in to page path rather than jcr:language property.
   
    //checking french language set on page
    if(currentPage.getLanguage(false).toString().startsWith("fr_"))
    {
        pageLocale= new Locale("fr");
    }   
    ResourceBundle resourceBundle = slingRequest.getResourceBundle(pageLocale);             
    I18n langText =new I18n(resourceBundle);

  %> 
<%!

/* used to access site palette, column defaults, etc */
/* Erik Wannebo 7/8/2010 */

public Node getSiteLevelPropertiesNode(SlingHttpServletRequest slingRequest,ValueMap pageProperties,Design currentDesign){
   Node sitelevelproperties = null;

   try{
        String template=pageProperties.get("cq:template", "");
        template=template.substring(template.lastIndexOf("/")+1);
        Resource resourcePath=null;
        resourcePath=slingRequest.getResourceResolver().getResource(currentDesign.getPath()+"/jcr:content/"+template+"/sitelevelproperties");
        if(resourcePath!=null){
            sitelevelproperties =  resourcePath.adaptTo(Node.class);
        }
    }catch(Exception e){
    //OK w/nothing on error
    }
    
    return sitelevelproperties;
}
    
    

//only add 6 basic groups 

//static String[] DEFAULT_GRPS = {"DEFAULT-Employee","DEFAULT-Crew","DEFAULT-Franchisee_Restaurant_Manager","DEFAULT-Owner_Operator","DEFAULT-McOpCo_Restaurant_Manager","DEFAULT-Suppliers_Vendors"};
//add two new groups, Judy , 09/05/2012
static String[] DEFAULT_GRPS = {"DEFAULT-Employee","DEFAULT-Crew","DEFAULT-Franchisee_Restaurant_Manager","DEFAULT-Owner_Operator","DEFAULT-McOpCo_Restaurant_Manager","DEFAULT-Suppliers_Vendors", "default-franchisee_office_staff","default-agency"};

public String getCUG(javax.jcr.Node currentNode){

  StringBuffer temp = new StringBuffer();
  try{
      com.day.crx.CRXSession session = (com.day.crx.CRXSession)currentNode.getSession();
     
      javax.jcr.Node nd = session.getRootNode();

      String handle = currentNode.getPath();
      int first = handle.indexOf("/content/");

      String jcrPath=handle.substring(first+1)+"/jcr:content";
      
       javax.jcr.Node jcrNode = nd.getNode(jcrPath);
      
      if (jcrNode == null) 
      {
          System.out.println("Node not found for CUG info.");
          return "";
      }

      // default values
      String cugEnalbed="false";
      if (jcrNode.hasProperty("cq:cugEnabled") && jcrNode.getProperty("cq:cugEnabled")!=null)
          cugEnalbed=jcrNode.getProperty("cq:cugEnabled").getString();


      javax.jcr.Value[] cugs=null;
      if (cugEnalbed.equalsIgnoreCase("true")){
          String cugPrinciples="";
          if (jcrNode.hasProperty("cq:cugPrincipals") && jcrNode.getProperty("cq:cugPrincipals")!=null)
          {

                  try {
                      cugs=jcrNode.getProperty("cq:cugPrincipals").getValues();
                      
                  }catch ( javax.jcr.ValueFormatException e){
                      cugs = new javax.jcr.Value[1];
                      cugs[0] = jcrNode.getProperty("cq:cugPrincipals").getValue();
                  }
              
                  for (int i=0; i<cugs.length ;i++ ){
                       temp.append("["+cugs[i].getString()+"]"); 
                  }
          }
               
      }


  }catch(Exception e){e.printStackTrace();}

      
  return temp.toString();
  }

public String getAllGroup(javax.jcr.Node currentNode){
  StringBuffer temp = new StringBuffer() ;

  try{
      com.day.crx.CRXSession session = (com.day.crx.CRXSession)currentNode.getSession();
      
      javax.jcr.Node nd = session.getRootNode();

      //use CUG , judy   , 01/2010   
      boolean getParent = true;
      String withJCR = currentNode.getPath();
      int last = withJCR.lastIndexOf("/jcr:content");
      int first = withJCR.indexOf("/");
      String thePath = withJCR.substring(first+1,last)+"/";
  
      while (getParent){
          int lastSlash = thePath.lastIndexOf("/");
          thePath=thePath.substring(0,lastSlash);
          //System.out.println("the Path :: "+ thePath);
          javax.jcr.Node theNode = nd.getNode(thePath);
          temp.append(getCUG(theNode));
          //System.out.println("temp :: "+ temp.toString());
          if (temp.length()>0 || thePath.length()< 10 ){ 
              getParent = false;
          }
      }

  
  
  
  }catch(Exception e){e.printStackTrace();}

  return temp.toString();
}



%>
