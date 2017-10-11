/*
 * Project: AccessMCD 
 *
 * @(#)GroupComparator.java
 * Revisions:
 * Date            Programmer           Description
 * --------------------------------------------------------------------------------------------
 * 18,Aug 2011   HCL                  This comparator class is used while sorting the 
 *                                    groups alphabatically.
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

package com.mcd.accessmcd.usermanagement.util;   

import java.util.Comparator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean;

/**
 * @author HCL
 * @version 1.0
 * @since 1.0
 */
public class GroupComparator implements Comparator<Object>
{
    private static final Logger log = LoggerFactory.getLogger(GroupComparator.class);
    public int compare(Object group1, Object group2)
    {
        int returnValue = 0;
        try
        {
            String groupName1 = "";
            String groupName2 = "";
            
            if(null != group1)
                groupName1 = ((GroupDataBean)group1).getGroupName();
            
            if(null != group2)
                groupName2 = ((GroupDataBean)group2).getGroupName();

            int result = groupName1.compareTo(groupName2);
            if(result > 0) 
                returnValue = 1;
            else if(result < 0)
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