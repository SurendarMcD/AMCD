/*
 * Project: AccessMCD
 *
 * @(#)CommentComparator.java
 * Revisions:
 * Date            Programmer           Description
 * --------------------------------------------------------------------------------------------
 * 27,April 2011   HCL                  This comparator class is used while sorting the 
 *                                      comments datewise.
 * --------------------------------------------------------------------------------------------
 * Description:
 * This software is the confidential and proprietary information of
 * McDonald's Corp. ("Confidential Information").
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with McDonald's.
 *
 * Copyright (c) 2010 McDonalds Corp.
 * All Rights Reserved.
 * www.mcdonalds.com
 */

package com.mcd.accessmcd.comments.util;   

import java.util.Comparator;
import java.util.Date;
import javax.jcr.Node;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.mcd.accessmcd.comments.constants.CommentsConstants;

/**
 * @author HCL
 * @version 1.0
 * @since 1.0
 */
public class CommentComparator implements Comparator<Object>
{
    private static final Logger log = LoggerFactory.getLogger(CommentComparator.class);
    public int compare(Object node1, Object node2)
    {
        int returnValue = 0;
        try
        {
            Date date1 = null;
            Date date2 = null;
            
            if(((Node)node1).hasProperty(CommentsConstants.PROP_ADDED))
                date1 = ((Node)node1).getProperty(CommentsConstants.PROP_ADDED).getDate().getTime();
            else
                date1 = ((Node)node1).getProperty(CommentsConstants.JCR_CREATED).getDate().getTime();
            
            if(((Node)node2).hasProperty(CommentsConstants.PROP_ADDED))
                date2 = ((Node)node2).getProperty(CommentsConstants.PROP_ADDED).getDate().getTime();
            else
                date2 = ((Node)node2).getProperty(CommentsConstants.JCR_CREATED).getDate().getTime();
            
            if(date1.after(date2))
                returnValue = 1;
            else if(date2.after(date1))
                returnValue = -1;
            else
                returnValue = 0;    
        }
        catch (Exception e)
        {
            log.error("[compare()] Exception: ", e);
            returnValue = 0; 
        }
        return returnValue;
    }
}