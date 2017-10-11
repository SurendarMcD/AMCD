/*
 * Project: AccessMCD
 *
 * @(#)CommonUtilities.java
 * Revisions:
 * Date            Programmer           Description
 * --------------------------------------------------------------------------------------------
 * 27,April 2011   HCL                  This Class contains the common utility methods. 
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

import java.util.StringTokenizer;
import com.mcd.accessmcd.comments.constants.CommentsConstants;

/**
 * @author HCL
 * @version 1.0
 * @since 1.0
 */
public class CommonUtilities
{
    /**
     * Method to capitalize the first letter of every word in a sentence.
     * @param strToCapitalize
     * @return String
     */
    public static String capitalizeFirstLetters(String strToCapitalize)
    {
        String returnStr = "";
        if(!strToCapitalize.equalsIgnoreCase(""))
        {
            StringTokenizer stoken = new StringTokenizer(strToCapitalize, " ");
            String tempStr = null;
            while (stoken.hasMoreTokens())
            {
                tempStr = stoken.nextToken().toString();
                returnStr = returnStr + String.format("%s%s", Character.toUpperCase(tempStr.charAt(0)), tempStr.substring(1)) + " ";
            }
            returnStr = returnStr.trim();
        }
        return returnStr;
    }
    
    /**
     * Method to check NULL Values. returns blank String when NULL else return the String which is passed.
     * @param strString
     * @return String
     */
    public static String checkNull(String strString)
    {
        if (strString == null || strString.equalsIgnoreCase(CommentsConstants.NULL) || strString.indexOf(CommentsConstants.NULL) != -1)
            return CommentsConstants.BLANK;
        else
            return strString.trim();
    }
}