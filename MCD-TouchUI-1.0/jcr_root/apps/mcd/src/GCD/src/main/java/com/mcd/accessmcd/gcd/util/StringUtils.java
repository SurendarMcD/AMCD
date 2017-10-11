/* 
 * StringUtils.java                                                                             
 * Developed by HCL Technologies.                                                       
 * Author      :- Mansi                                                  
 * Date        :- December 22, 2011                                                     
 * Description :-  This class is the utility class for DBTool Class
 * database related functionalities.. 
 * 
 */

package com.mcd.accessmcd.gcd.util;

import java.util.ArrayList;

/*************************************************************************
 * This class is the utility class for DBTool Class to perform database 
 * 
 *
 * @version 1.0 &nbsp; December 22, 2011
 * @author Mansi
 *
 *************************************************************************/


public class StringUtils
{

    public StringUtils()
    {
    }

    public static String nullToEmptyString(String s)
    {
        return s = s != null ? s : "";
    }

    public static String nullToSzZero(String s)
    {
        return s = s != null ? s : "0";
    }

    public static int nullToIntZero(String s)
    {
        int i = 0;
        if(s == null)
            i = 0;
        else
            try
            {
                i = Integer.parseInt(s);
            }
            catch(Exception e)
            {
                i = 0;
            }
        return i;
    }

    public static ArrayList<String> split(String s, char c)
    {
        ArrayList<String> al = new ArrayList<String>();
        int idx = s.indexOf(c);
        String leftSide = "";
        String rightSide = "";
        if(idx > 0)
            leftSide = s.substring(0, idx);
        if(idx > 0 && idx + 1 < s.length())
            rightSide = s.substring(idx + 1);
        al.add(leftSide);
        al.add(rightSide);
        return al;
    }
}