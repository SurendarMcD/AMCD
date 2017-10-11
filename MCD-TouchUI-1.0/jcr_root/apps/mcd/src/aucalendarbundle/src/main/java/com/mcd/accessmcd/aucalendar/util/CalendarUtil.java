/* Wei
   Utility functions for Calendar and NoticeBoard
   03/2011
*/   

package com.mcd.accessmcd.aucalendar.util;


import java.util.*;
import com.mcd.accessmcd.calendar.util.DesEncrypter;
import com.mcd.accessmcd.calendar.util.DateUtil;

import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;
import com.mcd.accessmcd.pci.facade.IPCIContentDeliveryFacade;
import com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;

import com.day.cq.security.User;
import com.day.cq.security.UserManager;
import com.day.cq.security.UserManagerFactory;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.api.scripting.SlingScriptHelper;

import javax.jcr.Session;
import javax.jcr.Node;

public class CalendarUtil
{
    private IPCIContentDeliveryFacade facadeImpl;  
    private String loggedUserAudType="CorpEmployees";
    private DesEncrypter encrypter = new DesEncrypter();
    private String encryptedAudType="";    
      
    //wei - parse date to the proper format for displaying
    public String formatNoticeBoardDate (String date) {
         HashMap hm = new HashMap();
         
         hm.put("01", "January");
         hm.put("02", "February");
         hm.put("03", "March");
         hm.put("04", "April");
         hm.put("05", "May");
         hm.put("06", "June");
         hm.put("07", "July");
         hm.put("08", "August");  
         hm.put("09", "September");   
         hm.put("10", "October"); 
         hm.put("11", "November");
         hm.put("12", "December"); 
         
         String[] dates = date.split("\\.");
         String month = dates[0];
         String day = dates[1];
         String year = dates[2];
         //System.out.println(month + " " + day + " " + year);
    
         Set keys = hm.keySet();
         Iterator It = keys.iterator();
         while (It.hasNext()) {
             String inputMonth = (String)(It.next());
             if (inputMonth.equals(month))
                 month =  (String) hm.get(inputMonth);            
        }
          
        String noticeBoardDate = day + " " + month + " " + "20" + year;
    
        return noticeBoardDate;
    }
    
    public Date getStartDate () {
        Calendar cDate= Calendar.getInstance();
        int day = 0;
       
        Date stDate = cDate.getTime();
        //out.println("stDate=" + stDate);
        stDate = DateUtil.getAusDate(stDate);
        //out.println("AU stDate=" + stDate);
               
        //tuesday - if (stDate.getDay() == 2) 
       if (stDate.getDay() == 0) day = stDate.getDate() - 6;       
        else if (stDate.getDay() == 1) day = stDate.getDate() - 7;
        else if (stDate.getDay() == 2) day = stDate.getDate() - 1;  
        else if (stDate.getDay() == 3) day = stDate.getDate() - 2; 
        else if (stDate.getDay() == 4) day = stDate.getDate() - 3; 
        else if (stDate.getDay() == 5) day = stDate.getDate() - 4;  
        else if (stDate.getDay() == 6) day = stDate.getDate() - 5;
            
        stDate.setDate(day);
        //stDate.setMonth(stDate.getMonth());
        stDate.setHours(0);
        stDate.setMinutes(0);
        stDate.setSeconds(0);
        
        return stDate;
    }
    
    public String replaceString (String target, String from, String to) {   
        // target is the original string
        // from   is the string to be replaced
        // to     is the string which will used to replace
        int start = target.indexOf (from);
        if (start==-1) return target;
        int lf = from.length();
        char [] targetChars = target.toCharArray();
        StringBuffer buffer = new StringBuffer();
        int copyFrom=0;
        while (start != -1) {
            buffer.append (targetChars, copyFrom, start-copyFrom);
            buffer.append (to);
            copyFrom=start+lf;
            start = target.indexOf (from, copyFrom);
        }   
        buffer.append (targetChars, copyFrom, targetChars.length-copyFrom);
        return buffer.toString();
    }
    
    /*
     * Method that gets the PCIContent
     * @param PCIQuery, SlingScriptHelper
     * return an array of PCIResult object.
     */      
    public Object[] getPCIContent(PCIQuery query, SlingScriptHelper sling) throws Exception { 
    
        Object calendarContent[] = null;
        List pciResultList = new ArrayList();
        
        try {
            facadeImpl = new PCIContentDeliveryFacadeImpl(sling);
            PCIResult pciResult[] = null;
            try {
                pciResult = facadeImpl.getPCIContent(query); 
            } catch(Exception ex) {
                System.out.println("PCIResult object could not be retrieved from PCI Interface " + ex);
            }
                        
            for(int i = 0; i < pciResult.length; i++) {
                PCIResult pciresult = pciResult[i];                
                pciResultList.add(pciresult);
            }
            calendarContent = pciResultList.toArray();
          
        } catch(Exception e) {
            System.out.println(" Error while Fatching data " + e);            
            throw new Exception((new StringBuilder()).append(" [Notice Board] [CalendarUtil] [getPCIContent()] Error while Fatching data ").append(e.getMessage()).toString());
        }
       
        return calendarContent;
    }
    
    public String getLoggedUserAudType(SlingScriptHelper sling, User user) {
    
        SlingRepository repos= sling.getService(SlingRepository.class);  
        UserManagerFactory fact =sling.getService(UserManagerFactory.class);
            
            if (!(repos==null || fact==null)) {
                Session session = null;
                try {
                    session = repos.loginAdministrative(null);
                    final UserManager umgr = fact.createUserManager(session);
                    if(umgr.hasAuthorizable(user.getID())){
                        //Authorizable auth = umgr.get(user.getID());
                   
                        // code to retrieve the audience type of the logged in user
                        Node userProfileNode = (Node) session.getItem(user.getHomePath() + "/profile");
                        if(userProfileNode.hasProperty("mcdAudience"))
                        { 
                            loggedUserAudType=userProfileNode.getProperty("mcdAudience").getValue().getString();
                        
                            //code to encrypt the Audience type of the logged in user
                            encryptedAudType = encrypter.encrypt(loggedUserAudType).replace("/","");
                       
                         }else{
                             if(null!=user.getProperty("./rep:mcdAudience")){
                                 loggedUserAudType=user.getProperty("./rep:mcdAudience");
                                 encryptedAudType = encrypter.encrypt(loggedUserAudType).replace("/","");
                             }         
                     
                         }
                    
                     }
                } catch (Exception e) {
                } finally {
                    if (session!=null) {
                        session.logout();
                    }
                }
            }
            return loggedUserAudType;
      }
}  