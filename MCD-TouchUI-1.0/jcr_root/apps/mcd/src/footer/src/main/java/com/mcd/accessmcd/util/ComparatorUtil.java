package com.mcd.accessmcd.util;

import java.lang.reflect.Method;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

/**
 * This class is used for comparing the user name & sorting them accordingly
 * 
 * @author Rajat Chawla
 * @version 1.0
 *
 */

public class ComparatorUtil implements java.util.Comparator {

    String methodName = null;
    boolean sortAscending = true;
    private static final Logger log = LoggerFactory.getLogger(com.mcd.accessmcd.util.ComparatorUtil.class);
    // constructor //
    public ComparatorUtil(String argmethodName, boolean argSortAscending) {
        this.methodName = argmethodName;
        this.sortAscending = argSortAscending;
    }

    // method to sort users according to the name //
    public static void sort(List list, String methodName) {
        ComparatorUtil.sort(list, methodName, true);
    }
    // method to sort the users list //
    public static void sort(List list, String methodName, boolean sortAscending) {
        Collections.sort(list, new ComparatorUtil(methodName, sortAscending));
    }
     
    // method to compare the objects and sort them accordingly //
    public int compare(Object oVar1, Object oVar2) {

        try{

        Class class1 = oVar1.getClass();
        Class class2 = oVar2.getClass();
        
        if(class1 != null && class2 != null && (class1.getName().equals(class2.getName()))){
            Method method1 = null;
            Method method2 = null;

            method1 = class1.getMethod(methodName, new Class[] {});
            method2 = class2.getMethod(methodName, new Class[] {});
            

            if(method1 != null && method2 != null){
                
                Object object1 = method1.invoke(oVar1, new Object[] {});
                
                Object object2 = method2.invoke(oVar2, new Object[] {});
                
                
                Class returnType1 = method1.getReturnType();
                Class returnType2 = method2.getReturnType();

                
                if((returnType1.isInstance(new String())) && (returnType2.isInstance(new String()))){
                    

                    String xString = (String)object1;
                    String yString = (String)object2;
                    if(xString == null){
                        xString = "";
                    }
                    if(yString == null){
                        yString = "";
                    }
                    if(sortAscending){
                        return xString.toLowerCase().compareTo(yString.toLowerCase());
                    }
                    else{
                        return yString.toLowerCase().compareTo(xString.toLowerCase());
                    }
                }

                else if((Class.forName("java.lang.Number").isAssignableFrom(returnType1)) && (Class.forName("java.lang.Number").isAssignableFrom(returnType2))){


                            Number xI = (Number)object1;
                            Number yI = (Number)object2;
                            double xDouble = 0;
                            double yDouble = 0;
        
                                    if(xI == null){
                                        xDouble = 0;
                                    }
                                    else{
                                        xDouble = xI.doubleValue();
                                    }
                
                                    if(yI == null){
                                        yDouble = 0;
                                    }
                                    else{
                                        yDouble = yI.doubleValue();
                                    }
                
                                    double xd = 0;
                
                                    if(sortAscending){
                                        xd = xDouble - yDouble;
                                    }
                                    else{
                                        xd = yDouble - xDouble;
                                    }
                
                                    if(xd > 0){
                                        return 1;
                                    }
                                    else if(xd < 0){
                                        return -1;
                                    }
                                    else{
                                        return 0;
                                    }
        
                        }

                else if((returnType1.isInstance(new Integer(0))) && (returnType2.isInstance(new Integer(0)))){


                            Integer xI = (Integer)object1;
                            Integer yI = (Integer)object2;
                            int xInt = 0;
                            int yInt = 0;
        
                                    if(xI == null){
                                        xInt = 0;
                                    }
                                    else{
                                        xInt = xI.intValue();
                                    }
                
                                    if(yI == null){
                                        yInt = 0;
                                    }
                                    else{
                                        yInt = yI.intValue();
                                    }
                
                                    int xd = 0;
                
                                    if(sortAscending){
                                        xd = xInt - yInt;
                                    }
                                    else{
                                        xd = yInt - xInt;
                                    }
                
                                    if(xd > 0){
                                        return 1;
                                    }
                                    else if(xd < 0){
                                        return -1;
                                    }
                                    else{
                                        return 0;
                                    }
                
                        }
                else if((returnType1.isInstance(new java.util.Date())) && (returnType2.isInstance(new java.util.Date()))){
                        java.util.Date xI = (java.util.Date)object1;
                        java.util.Date yI = (java.util.Date)object2;
                        java.util.Date xDate = (xI == null ? new Date() : xI);
                        java.util.Date yDate = (yI == null ? new Date() : yI);
                        
                        if (sortAscending) {
                            return xDate.compareTo(yDate);
                        } else {
                            return yDate.compareTo(xDate);
                        }
                    }
                    

                else {
                    log.error("[ComparatorUtil] unknown/mismatched data type...no compare done");
                }

            }
        }

       }
       catch(Exception e){
           log.error("[ComparatorUtil.compare excepton] " + e.getMessage());
       }

       return 0;

    }
}