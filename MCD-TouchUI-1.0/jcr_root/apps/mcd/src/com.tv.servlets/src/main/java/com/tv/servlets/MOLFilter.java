package com.tv.servlets;

import com.day.cq.wcm.api.Page;
import org.apache.commons.lang.StringUtils;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.ReferencePolicy;
import org.apache.felix.scr.annotations.sling.SlingFilter;
import org.apache.felix.scr.annotations.sling.SlingFilterScope;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.request.RequestDispatcherOptions;
import org.apache.sling.api.resource.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.*;
import java.io.IOException;
import java.util.*;
import javax.servlet.http.Cookie;
import org.osgi.service.cm.Configuration;
import org.osgi.service.cm.ConfigurationAdmin;


@SlingFilter(scope = SlingFilterScope.REQUEST,generateService = true,order = -2501)
public final class MOLFilter implements Filter {

	private static final Logger log = LoggerFactory.getLogger(MOLFilter.class);

	private static final int ERR_STATUS = 404;


	@Reference
    private ConfigurationAdmin configAdmin;

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(final FilterConfig filterConfig) throws ServletException {
		//Do Nothing
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(final ServletRequest servletRequest, final ServletResponse servletResponse,
			final FilterChain chain) throws IOException, ServletException {

		if (!(servletRequest instanceof SlingHttpServletRequest)) {
			chain.doFilter(servletRequest, servletResponse);
			return;
		}

		SlingHttpServletRequest request = (SlingHttpServletRequest) servletRequest;
		SlingHttpServletResponse response = (SlingHttpServletResponse) servletResponse;

		Resource resource = request.getResource();
		Page page = resource.adaptTo(Page.class);

        if(page != null && !page.getPath().equals("/content/start") && page.getPath().startsWith("/content")){

            String storeGuid = getCookieByName("StoreGuid",request);
            String userGuid = getCookieByName("UserGuid",request);
            if("".equals(userGuid) && "".equals(storeGuid)){
                Configuration config1 = (Configuration)configAdmin.getConfiguration("com.truevalue.login.url");
                Dictionary props = config1.getProperties();
                String loginPage = ((String)props.get("loginURL"));
                log.error("Login Page URL :: " + loginPage);
                log.error("Store Guid :: " + storeGuid);
                log.error("User Guid :: " + userGuid);
                response.sendRedirect(loginPage);
                log.error("************ After Redirect Log***********");
                return;
            }
        }

		chain.doFilter(servletRequest, servletResponse);
	}
	
	private String getCookieByName(String cookieName,SlingHttpServletRequest request){
        Cookie[] cookies = request.getCookies();
        String cookieValue = "";
        if(null != cookies){
            for(int i = 0; i < cookies.length; i++) { 
                Cookie cookie1 = cookies[i];
                if (cookie1.getName().equals(cookieName)) {
                    cookieValue = cookie1.getValue();
                }
            } 
        }
        return cookieValue;
    }


    protected void bindConfigAdmin(ConfigurationAdmin configAdmin)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.configAdmin = configAdmin;
            
    }   
    protected void unbindConfigAdmin(ConfigurationAdmin configAdmin)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        configAdmin = null;
    }
	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		//Do Nothing
	}
}
