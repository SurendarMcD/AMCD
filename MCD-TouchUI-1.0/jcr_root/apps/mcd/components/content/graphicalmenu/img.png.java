/*
 * Copyright 1997-2008 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */

package apps.mcd.components.content.graphicalmenu;

import java.io.IOException;
import java.io.InputStream;

import javax.jcr.RepositoryException;
import javax.jcr.Property;
import javax.servlet.http.HttpServletResponse;

import com.day.cq.wcm.foundation.Image;
import com.day.cq.wcm.commons.RequestHelper;
import com.day.cq.wcm.commons.WCMUtils;
import com.day.cq.wcm.commons.AbstractImageServlet;
import com.day.cq.commons.SlingRepositoryException;
import com.day.image.Layer;
import org.apache.commons.io.IOUtils;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;

/**
 * Renders an image
 */
public class img_png extends AbstractImageServlet {

    protected Layer createLayer(ImageContext c)
            throws RepositoryException, IOException {
        // don't create the later yet. handle everything later
        return null;
    }

    protected void writeLayer(SlingHttpServletRequest req,
                              SlingHttpServletResponse resp,
                              ImageContext c, Layer layer)
            throws IOException, RepositoryException {

        Image image = new Image(c.resource);
        if (!image.hasContent()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // get style and set constraints
        image.loadStyleData(c.style);

        // get pure layer
        layer = image.getLayer(false, false, false);
        boolean modified = false;
        
        if (layer != null) {
            // crop
            modified = image.crop(layer) != null;

            // resize
            modified |= image.resize(layer) != null;

            // rotate
            modified |= image.rotate(layer) != null;

        }
        if (modified) {
            resp.setContentType("image/png");
            layer.write("image/png", 1.0, resp.getOutputStream());
        } else {
        	try{
	            // do not re-encode layer, just spool
	            Property data = image.getData();
	            InputStream in = data.getStream();
	            resp.setContentLength((int) data.getLength());
	            resp.setContentType(image.getMimeType());
	            IOUtils.copy(in, resp.getOutputStream());
	            in.close();
        	}
        	catch(Exception e){
        		System.out.println(e.getMessage());
        	}
        }
        resp.flushBuffer();
    }
}