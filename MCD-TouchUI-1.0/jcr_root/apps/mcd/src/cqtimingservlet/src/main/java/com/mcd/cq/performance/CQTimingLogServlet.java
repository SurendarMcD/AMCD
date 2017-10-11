import java.io.IOException;
import java.io.PrintWriter;

import java.util.Date;
import java.text.SimpleDateFormat;
import javax.servlet.Servlet;
import javax.servlet.ServletException;

import org.apache.sling.api.SlingHttpServletRequest;

import org.apache.sling.api.SlingHttpServletResponse;

import org.apache.sling.api.servlets.SlingAllMethodsServlet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="AEM Timing Servlet"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/cq/timing"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")


/*
    A servlet to capture CQ Timing stats via AJAX
    --requires update to /libs/cq/ui/widgets/source/utils/Timing.js
    8-17-2010 Erik Wannebo
*/
public class CQTimingLogServlet extends SlingAllMethodsServlet {

    private static final Logger log = LoggerFactory.getLogger(CQTimingLogServlet.class);

    @Override

    protected void doGet(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            logTiming(request);
            response.setContentType("text/html");

            PrintWriter out = response.getWriter();

            out.println("ok");
            out.close();

     

    }



    @Override

    protected void doPost(SlingHttpServletRequest request,

            SlingHttpServletResponse response) throws ServletException,

            IOException {
            
            this.doGet(request,response);

       

    }
    
    private void logTiming(SlingHttpServletRequest request){
    
        String timing=request.getParameter("timing");
        if(timing!=null && timing.indexOf('?')>-1)timing=timing.substring(0,timing.indexOf('?'));
        String userid=request.getHeader("sm_user");
        String useragent=request.getHeader("User-Agent");
        if(useragent.indexOf("Chrome")>-1)useragent="Chrome";
        if(useragent.indexOf("Firefox")>-1)useragent="FF";
        if(useragent.indexOf("MSIE 7")>-1)useragent="IE7";
        if(useragent.indexOf("MSIE 8")>-1)useragent="IE8";
        String l_attr=request.getHeader("l");
        if(l_attr!=null)l_attr=l_attr.replaceAll("%20","_");
        String source=request.getParameter("source");
        
        /*
        Enumeration headers=request.getHeaderNames();
        while(headers.hasMoreElements()){
            String headername=(String)headers.nextElement();
            log.error(headername+":"+request.getHeader(headername));
        }
        */
        SimpleDateFormat sdf=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
        String logline="\n"+sdf.format(new Date())+" CQTime: "+source+" "+l_attr+" "+userid+"_"+useragent+" "+timing+" ms";
        log.info(logline);
    }
    
}