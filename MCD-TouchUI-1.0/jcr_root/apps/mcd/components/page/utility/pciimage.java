/**
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  pciimage
  
  globbing pattern jsp to return CQ4 image within CQ5 domain
  
  modified version of /libs/foundation/components/page/img.png.java
  
  Erik Wannebo 3/3/2012

  ==============================================================================
 
**/
package apps.mcd.components.page.utility; 
  
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;

import javax.jcr.RepositoryException;
import javax.jcr.Property;
import javax.servlet.http.HttpServletResponse;

import com.day.cq.commons.ImageResource;
import com.day.cq.wcm.foundation.Image;
import com.day.cq.wcm.commons.RequestHelper;
import com.day.cq.wcm.commons.WCMUtils;

import com.day.cq.wcm.api.Page;
import com.day.cq.commons.SlingRepositoryException;
import com.day.image.Layer;
import org.apache.commons.io.IOUtils;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.auth.*;
import org.apache.commons.httpclient.methods.*;

/**
 * Renders an image
 */
public class pciimage extends SlingSafeMethodsServlet{

    

    protected void doGet(SlingHttpServletRequest req,
                              SlingHttpServletResponse resp
                              )
            throws IOException {


          try{
            
            String url=req.getRequestURL().toString();
            
            String requestimage=url.substring(url.indexOf(".pciimage.")+10);
            requestimage=requestimage.substring(0,requestimage.indexOf("."));

            //this is the HO/US Publish on the same server
            //DEV
            //String imageurl="http://mcdeagsun107a:4205/accessmcd/resources/topstories/"+requestimage+".AMCDImage.gif";
            //PROD
            String imageurl="http://mcdeagsun113b:4206/accessmcd/resources/topstories/"+requestimage+".AMCDImage.gif";
            byte[] imagedata=getCQ4Content(imageurl);


            resp.setContentType("image/jpeg");
            resp.setContentLength((int) imagedata.length);
            OutputStream respOut = resp.getOutputStream();
            respOut.write(imagedata);

            respOut.flush();

            }catch(Exception e){
              System.err.print("pciimage exception:"+e.getMessage());
            }
        resp.flushBuffer();
    }
     public static byte[] getCQ4Content(String url){
            
            byte[] retbytes=null;
            GetMethod getPageMeth=null; 
            org.apache.commons.httpclient.HttpClient client = new HttpClient();
            HostConfiguration host = client.getHostConfiguration();

            try {

                host.setHost(new org.apache.commons.httpclient.URI(url));
                org.apache.commons.httpclient.Credentials credentials = new UsernamePasswordCredentials("superuser", "superuser");
                client.getState().setCredentials(AuthScope.ANY, credentials);
                
                getPageMeth= new GetMethod(url);
                
                getPageMeth.setDoAuthentication( true );       
                getPageMeth.getParams().setParameter("http.socket.timeout", new Integer(60000));        
                client.getParams().setAuthenticationPreemptive( true );

                int status = client.executeMethod(getPageMeth);
                              
                if(status==200){ 
                    byte[] byteArray=new byte[1024];
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream() ;
                    int count = 0 ;
                    while((count = getPageMeth.getResponseBodyAsStream().read(byteArray, 0, byteArray.length)) > 0)
                    { 
                     outputStream.write(byteArray, 0, count) ;
                    }                 
                    retbytes=outputStream.toByteArray();         
                 }        
            } catch(Exception e){
            }
            finally {
                getPageMeth.releaseConnection();
                client=null;
            }
            return retbytes;
     }
    
} 