import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

import java.util.*;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;

import org.apache.sling.api.SlingHttpServletRequest;

import org.apache.sling.api.SlingHttpServletResponse;

import org.apache.sling.api.servlets.SlingAllMethodsServlet;

import com.mcd.cq.util.search.SearchGroup;

import org.apache.sling.jcr.base.util.AccessControlUtil;

import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.auth.*;
import org.apache.commons.httpclient.methods.*;

import javax.jcr.Session;
import com.day.cq.security.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mcd.cq.util.UserAdmin;
import com.mcd.cq.util.CRXInfoService;
import javax.servlet.Servlet;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="User Search Security"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/cq/util/search/UserSearchSecurity"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")


/* User Search Security
* Servlet to return a given user's Search Group membership
* This filter is tne applied by Search to return results only accessible 
* to a given user.
*
* Erik Wannebo 10-5-2010
*/ 

public class UserSearchSecurity extends SlingAllMethodsServlet {

    @Reference
    private UserManagerFactory userManagerFactory;
    
    @Reference
    private org.apache.sling.jcr.api.SlingRepository repository;
    

    private static final Logger log = LoggerFactory.getLogger(UserSearchSecurity.class);

    @Override

    protected void doGet(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
           
            response.setContentType("text/html");

            PrintWriter out = response.getWriter();
            String userid=request.getParameter("EID");
            if(userid==null)userid="";

            out.println(getUserSearchSecurityXML(request, userid));
            
            out.close();

    }



    @Override

    protected void doPost(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            this.doGet(request,response);

    }
     
      /*
    * Method returns XML for mcdSearch (custom Ultraseek search servlet)
    * Called from user_maintenance.jsp
    * 7/13/2007 ECW
    */  
    public String getUserSearchSecurityXML(SlingHttpServletRequest request, String userid){
        StringBuffer outXML=new StringBuffer();
        outXML.append("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>");
        outXML.append("<search-security>");
        outXML.append("<eid>"+userid+"</eid>");
        outXML.append("<content></content>");               
        outXML.append("<security>"+getSearchSecurityString(request,userid)+"</security>");             
        outXML.append("</search-security>");
        return outXML.toString();
    }
    
   /*
    * Method returns Search Security string to be used to filter Ultraseek results for user
    */
    private String getSearchSecurityString(SlingHttpServletRequest request, String userid){
        String securityMetaTag="groupsType";
        String securityString="";                
        
        try{
           StringBuffer userGroups = new StringBuffer();    
           com.day.cq.security.User u = request.getResourceResolver().adaptTo(com.day.cq.security.User.class);
           
           String requestuserid=u.getID();
           
           if(requestuserid.equals("admin") && !userid.equals("")){
              //Session session = request.getResourceResolver().adaptTo(Session.class);
               
                
               Session session = repository.loginAdministrative(null);
               try {
                   UserManager mgr= userManagerFactory.createUserManager(session); 
                   com.day.cq.security.User user=null;
                   try{
                       user = (User)mgr.get(userid);
                   }catch(com.day.cq.security.NoSuchAuthorizableException e){
                      securityString="USER_NOT_FOUND";
                   }
                   if(user!=null){
                       Iterator ig = user.memberOf();
                        while (ig.hasNext()){
                            String groupName="["+((com.day.cq.security.Group)ig.next()).getID()+"]";
                            String groupCode=(String)SearchGroup.groupCodes.get(groupName);
                            List<String> codes = Arrays.asList("[S1]", "[S2]", "[S3]", "[S4]", "[S5]", 
                                                "[S6]", "[S7]", "[S8]");
                            if (codes.contains(groupCode)) {
                            securityString+=" groupsType:"+groupCode;
                            securityString+=" url:"+URLEncoder.encode(groupCode);
                            } 
                            if(groupCode==null)groupCode=groupName;
                            if(groupCode.indexOf("-P-")!=-1 || groupCode.indexOf("-p-")!=-1){
                            groupCode=groupCode.replace("-","");
                            groupCode=groupCode.replace("_","");
                            groupCode.replace(" ",""); 
                            securityString+=" groupsType:"+groupCode;
                            securityString+=" url:"+URLEncoder.encode(groupCode);
                            } 
                      }
                   }
                }catch(Exception e){
                    //exception retrieving group information
                    securityString+="Error1";
                }finally{
                  session.logout();
                }
            }       
        }catch(Exception e){
            securityString+=e.getLocalizedMessage()+"Error";
            e.printStackTrace();
            //do nothing
        }
        return securityString;
    }
    
    protected void bindUserManagerFactory(UserManagerFactory userManagerFactory)
    {
        this.userManagerFactory = userManagerFactory;

    }   
    protected void unbindUserManagerFactory(UserManagerFactory userManagerFactory)
    {       
        userManagerFactory = null;
    }
    protected void bindRepository(org.apache.sling.jcr.api.SlingRepository repository)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.repository = repository;
            
    }   
    protected void unbindRepository(org.apache.sling.jcr.api.SlingRepository repository)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        repository = null;
    }
}