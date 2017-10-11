/* 
 * UserProfileDAO.java                                                                                          
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep Jain                                                  
 * Date        :- December 09, 2008                                                     
 * Description :-  This class interacts with the DBTool class to get the 
 * connection from the database and holds different SQL queries on the basis of selected method. 
 *
 */

package com.mcd.accessmcd.gcd.dao;

import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.util.ArrayList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.api.scripting.SlingScriptHelper;
import com.mcd.accessmcd.gcd.util.DBTool;
import com.mcd.accessmcd.gcd.util.StringUtils;
import com.mcd.accessmcd.gcd.bean.BasicSearch;
import com.mcd.accessmcd.gcd.bean.AdvancedSearch;
import com.mcd.accessmcd.gcd.bean.BasicSearchResult;
import com.mcd.accessmcd.gcd.bean.ExpandedSearchResult;
import com.mcd.accessmcd.gcd.bean.DirectReports;

/*************************************************************************
 * This class interacts with the DBTool class to get the connection from the
 * database and holds different SQL queries on the basis of selected method. 
 *
 * @version 1.0 &nbsp; December 09, 2008
 * @author : Sandeep Jain
 * 
 * SSV - Modified the code to display dynamic label based on the device id from the device table
 * if they are not present then corresponding label will display phone1,phone2 and etc.
 *
 *************************************************************************/

public class UserProfileDAO implements IUserProfileDAO
{
    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(UserProfileDAO.class);
      
    public ArrayList getSearchResult(BasicSearch basicSearch,SlingScriptHelper sling)throws SQLException, Exception 
    {    log.info("UserProfileDAO--->");  
        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
        ResultSet resultSet = null;
        ResultSet resultSet2 = null;
        
        StringBuffer buildSQL = new StringBuffer();
        buildSQL.append(SELECT_SQL);
        
        StringBuffer whereClauseSQL = new StringBuffer();
        int paramCount = 1;
        
        if(basicSearch.getCountry().length() != 0)
            whereClauseSQL.append(" and h.ctry_cd like ? ");        
        
        if(basicSearch.getLastName().length() != 0)
            whereClauseSQL.append(" and h.last_na like ?  ");
        
        if(basicSearch.getFirstName().length() != 0)
            whereClauseSQL.append(" and ( h.fst_na like ? or d.fst_na_alias like ? ) ");
        
        buildSQL.append(whereClauseSQL.toString());
        buildSQL.append(" order by h.last_na,h.fst_na");
        log.error("SQL--->"+buildSQL.toString());
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(buildSQL.toString());
                if(basicSearch.getCountry().length() != 0)
                pstmt.setString(paramCount++, basicSearch.getCountry());
                if(basicSearch.getLastName().length() != 0)
                    pstmt.setString(paramCount++, "%" + basicSearch.getLastName() + "%");
                
                if(basicSearch.getFirstName().length() != 0){
                    pstmt.setString(paramCount++, "%" + basicSearch.getFirstName() + "%");
                    pstmt.setString(paramCount++, "%" + basicSearch.getFirstName() + "%");
                }
               
                resultSet = pstmt.executeQuery();
                
                BasicSearchResult basicSearchResult;
                for(; resultSet.next(); queryResults.add(basicSearchResult)){
                    basicSearchResult = new BasicSearchResult();
                    String mySeqNu = "";
                    try
                    {
                        mySeqNu = String.valueOf(resultSet.getLong(30));
                        basicSearchResult.setSequenceNu(mySeqNu);
                    }catch(Exception e){
                        mySeqNu = "";
                    }
                    
                    basicSearchResult.setEid(StringUtils.nullToEmptyString(resultSet.getString(1)));
                    String opTest = "";
                    
                    try
                    {
                        opTest = Integer.toString(resultSet.getInt(2));
                    }catch(Exception e){
                        opTest = "";
                    }
                    
                    //log.error("before setting the setOperIdNu");
                    basicSearchResult.setOperIdNu(StringUtils.nullToEmptyString(opTest));
                    basicSearchResult.setLastNm(StringUtils.nullToEmptyString(resultSet.getString(3)));
                    basicSearchResult.setFstNm(StringUtils.nullToEmptyString(resultSet.getString(4)));
                    basicSearchResult.setMidInitNa(StringUtils.nullToEmptyString(resultSet.getString(5)));
                    basicSearchResult.setJobTitlDs(StringUtils.nullToEmptyString(resultSet.getString(7)));
                    basicSearchResult.setBusL1Ad(StringUtils.nullToEmptyString(resultSet.getString(11)));
                    basicSearchResult.setBusL2Ad(StringUtils.nullToEmptyString(resultSet.getString(12)));
                    basicSearchResult.setBusCityAd(StringUtils.nullToEmptyString(resultSet.getString(13)));
                    basicSearchResult.setBusAbbrStAd(StringUtils.nullToEmptyString(resultSet.getString(14)));
                    basicSearchResult.setBusPstlCd(StringUtils.nullToEmptyString(resultSet.getString(15)));
                    basicSearchResult.setFstNaAlias(StringUtils.nullToEmptyString(resultSet.getString(16)));
                    basicSearchResult.setMailBoxNu(StringUtils.nullToEmptyString(resultSet.getString(18)));
                    basicSearchResult.setMailCd("");
                    basicSearchResult.setUsCellPhne(StringUtils.nullToEmptyString(resultSet.getString(20)));
                    basicSearchResult.setVmNodeNu(StringUtils.nullToEmptyString(resultSet.getString(21)));
                    basicSearchResult.setPrefMailCd(StringUtils.nullToEmptyString(resultSet.getString(22)));
                    basicSearchResult.setVmBoxNu("");
                    basicSearchResult.setAdminOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(24)));
                    basicSearchResult.setDFlag(StringUtils.nullToEmptyString(resultSet.getString(31)));
                    
                    if(opTest.length() > 0 && !opTest.equals("0"))
                    {
                        basicSearchResult.setEmail("N/A");
                        basicSearchResult.setDeptNu("N/A");
                        basicSearchResult.setDeptNa("");
                        
                        String phnArea = "";
                        String phnPrefix = "";
                        String phnXt = "";
                        
                        try
                        {
                            if(null==resultSet.getString(25)){
                                phnArea = "";
                            }
                            else{
                                phnArea = resultSet.getString(25);
                            }
                        }catch(Exception e){
                            phnArea = "";
                        }
                        
                        try
                        {
                            if(null==resultSet.getString(26)){
                                phnPrefix="";
                            }
                            else{
                                phnPrefix = resultSet.getString(26);
                            }
                        }catch(Exception e){
                            phnPrefix = "";
                        }
                        
                        try
                        {
                            if(null==resultSet.getString(27)){
                                phnXt="";
                            }
                            else{
                                phnXt = resultSet.getString(27);
                            }
                        }catch(Exception e){
                            phnXt = "";
                        }
                        
                        if(!phnArea.equals("") && !phnPrefix.equals("") && !phnXt.equals("")){
                            basicSearchResult.setUsOffcPhne("(" + phnArea + ") " + phnPrefix + "-" + phnXt);
                        }    
                        else{
                            if(phnArea.equals("") && !phnPrefix.equals("") && !phnXt.equals(""))
                                basicSearchResult.setUsOffcPhne(phnPrefix + "-" + phnXt);
                            else
                                basicSearchResult.setUsOffcPhne("");   
                        }        
                    
                        String ooCity = "";
                        String ooState = "";
                        ooCity = StringUtils.nullToEmptyString(resultSet.getString(28));
                        ooState = StringUtils.nullToEmptyString(resultSet.getString(29));
                        if(ooCity.length() > 0 && ooState.length() > 0){
                            basicSearchResult.setBldgNa(ooCity + ", " + ooState);
                        }    
                        else{
                            basicSearchResult.setBldgNa(ooCity + ooState);
                        }
                    } 
                    else
                    {
                        basicSearchResult.setEmail(StringUtils.nullToEmptyString(resultSet.getString(6)));
                        basicSearchResult.setDeptNa(StringUtils.nullToEmptyString(resultSet.getString(8)));
                        basicSearchResult.setBldgNa(StringUtils.nullToEmptyString(resultSet.getString(9)));
                        basicSearchResult.setDeptNu(StringUtils.nullToEmptyString(resultSet.getString(17)));
                        basicSearchResult.setUsOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(10)));
                    }
                    
                    //SSV added to get the deviceid/numbers. Getting all the records with one and will use the first one.
                    String EID = (StringUtils.nullToEmptyString(resultSet.getString(1)));
                    String BusinessPhone = "";   
                    pstmt2 = conn.prepareStatement(EXPANDED_SELECT_SQL_BUSINESSCONTACT_BY_EID);
                    pstmt2.setString(1, EID);
                    
                    for(resultSet2 = pstmt2.executeQuery(); resultSet2.next();){
                        if (resultSet != null){
                            if (BusinessPhone.length() == 0)
                            {
                            basicSearchResult.setBusinessPhone(StringUtils.nullToEmptyString(resultSet2.getString(1)));                   
                            //log.error("Display value for device id" + " " + (StringUtils.nullToEmptyString(basicSearchResult.getBusinessPhone())));
                            BusinessPhone = basicSearchResult.getBusinessPhone();
                            } 
                        }  
                    }
                    //SSV ended.   
                    
                    if(pstmt2 != null ){
                        try
                        {
                            pstmt2.close();
                            pstmt2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                    }
                    if(resultSet2 != null){ 
                        try
                        {
                            resultSet2.close();      
                            resultSet2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                        
                    }                 
                    pstmt2 = conn.prepareStatement(EXPANDED_SELECT_SQL_DEVICEINFO_BY_EID);
                    pstmt2.setString(1, EID);
                    
                    int counter = 0;
                    for(resultSet2 = pstmt2.executeQuery(); resultSet2.next();){
                        if (resultSet != null){
                            counter = counter + 1;
                            switch (counter)
                            {
                                case 1:  
                                {
                                    basicSearchResult.setDeviceNumber1(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID1(resultSet2.getInt(2));
                                    break;
                                } 
                                case 2:  
                                {
                                    basicSearchResult.setDeviceNumber2(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID2(resultSet2.getInt(2));
                                    break;
                                } 
                                case 3:  
                                {
                                    basicSearchResult.setDeviceNumber3(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID3(resultSet2.getInt(2));
                                    break;
                                } 
                                case 4:  
                                {
                                    basicSearchResult.setDeviceNumber4(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID4(resultSet2.getInt(2));
                                    break;
                                } 
                                case 5:  
                                {
                                    basicSearchResult.setDeviceNumber5(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID5(resultSet2.getInt(2));
                                    break;
                                } 
                                case 6:  
                                {
                                    basicSearchResult.setDeviceNumber6(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID6(resultSet2.getInt(2));
                                    break;
                                } 
                            }  //switch
                        
                        }  
                    
                    }
                    
                    if(pstmt2 != null ){
                        try
                        {
                            pstmt2.close();
                            pstmt2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                    }
                    if(resultSet2 != null){ 
                        try
                        {
                            resultSet2.close();      
                            resultSet2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                        
                    }  
                    
                    //End for excel
                }
            }

        }catch (SQLException sqle) {
            log.error("****** GCD Database Error sqle *******" + sqle);
            log.error("[GCD] [UserProfileDAO getSearchResult] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UserProfileDAO getSearchResult] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error("****** GCD Database Error *******" +e);
            log.error(" [GCD] [UserProfileDAO getSearchResult] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UserProfileDAO getSearchResult] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            if(pstmt2 != null ){
                try
                {
                    pstmt2.close();
                    pstmt2 = null;
                }
                catch(SQLException _ex) { 
                    log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                }
            }
            if(resultSet2 != null){ 
                try
                {
                    resultSet2.close();      
                    resultSet2 = null;
                }
                catch(SQLException _ex) { 
                    log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                }
                
            }  
            DBTool.closeObjects(conn,resultSet,pstmt);
        }
        return queryResults;
    }
    
    public ArrayList getSearchResult(AdvancedSearch advancedSearch,SlingScriptHelper sling)throws SQLException, Exception 
    {
        ArrayList queryResults = new ArrayList();;
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
        ResultSet resultSet = null;
        ResultSet resultSet2 = null;
        
        StringBuffer buildSQL = new StringBuffer();
        StringBuffer whereClauseSQL = new StringBuffer();
        int paramCount = 1;
        
        if(advancedSearch.getCountry().length() != 0)
            whereClauseSQL.append(" and h.ctry_cd like ? ");
        if(advancedSearch.getLastName().length() != 0)
            whereClauseSQL.append(" and h.last_na like ?  ");
        if(advancedSearch.getFirstName().length() != 0)
            whereClauseSQL.append(" and ( h.fst_na like ? or d.fst_na_alias like ? ) ");
        if(advancedSearch.getMi().length() != 0)
            whereClauseSQL.append(" and h.mid_init_na like ? ");
        if(advancedSearch.getDepartment().length() != 0)
            whereClauseSQL.append(" and h.dept_na like ? ");  
        if(advancedSearch.getDepartmentNumber().length() != 0)
            whereClauseSQL.append(" and h.dept_nu like ? ");
        if(advancedSearch.getState().length() != 0)
            whereClauseSQL.append(" and (b.site_abbr_st_ad like ? OR d.oper_st_prov_ad like ? ) ");
        if(advancedSearch.getBuildingNa().length() != 0)
            whereClauseSQL.append(" and b.bldg_Na like ? ");
        if(advancedSearch.getCompanyName().length() != 0)
            whereClauseSQL.append(" and h.co_na like ? ");
        if(advancedSearch.getJobTitle().length() != 0)
            whereClauseSQL.append(" and h.job_titl_ds like ? ");
        if(advancedSearch.getRegNa().length() != 0)
            whereClauseSQL.append(" and h.reg_na = ? ");
        
        //ssv modified to add region name for the accuracy of data - check region code = 02    
        if(advancedSearch.getRegCd().length() != 0){   
            whereClauseSQL.append(" and h.reg_cd = ? ");
            whereClauseSQL.append(" and h.reg_na = ? ");
        } 
        if(advancedSearch.getPrefMailCd().length() != 0)
            whereClauseSQL.append(" and d.prfd_mail_cd = ? ");
        if(advancedSearch.getVmNodeNu().length() != 0)
            whereClauseSQL.append(" and d.vm_node_nu = ? ");
     
        if(advancedSearch.getPhoneNumber().length() != 0){
            whereClauseSQL.append(" and k.phone_number like ? ");
            whereClauseSQL.append(" and k.device_id = ? ");     
            buildSQL.append(PHONE_SELECT_SQL);
        }
        else if(advancedSearch.getPhoneNuExt().length() != 0){
            whereClauseSQL.append(" and k.phone_number like ? ");
            whereClauseSQL.append(" and k.device_id = ? ");     
            buildSQL.append(PHONE_SELECT_SQL);
        }
        else{       
            buildSQL.append(SELECT_SQL);
        }    
        
        buildSQL.append(whereClauseSQL.toString());
        buildSQL.append(" order by h.last_na,h.fst_na");
    
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(buildSQL.toString());
                if(advancedSearch.getCountry().length() != 0)
                    pstmt.setString(paramCount++, advancedSearch.getCountry());
                
                if(advancedSearch.getLastName().length() != 0)
                    pstmt.setString(paramCount++, "%" + advancedSearch.getLastName() + "%");
                
                if(advancedSearch.getFirstName().length() != 0){
                    pstmt.setString(paramCount++, "%" + advancedSearch.getFirstName() + "%");
                    pstmt.setString(paramCount++, "%" + advancedSearch.getFirstName() + "%");
                }
                
                if(advancedSearch.getMi().length() != 0)
                    pstmt.setString(paramCount++, advancedSearch.getMi());
               
                                  
                if(advancedSearch.getDepartment().length() != 0)
                    pstmt.setString(paramCount++, advancedSearch.getDepartment()); 
               
                if(advancedSearch.getDepartmentNumber().length() != 0)
                    pstmt.setString(paramCount++, advancedSearch.getDepartmentNumber());
               
                
                if(advancedSearch.getState().length() != 0){
                    pstmt.setString(paramCount++, advancedSearch.getState());
                    pstmt.setString(paramCount++, advancedSearch.getState());
                }
                
                if(advancedSearch.getBuildingNa().length() != 0)
                    pstmt.setString(paramCount++, advancedSearch.getBuildingNa());
                
                if(advancedSearch.getCompanyName().length() != 0){
                    pstmt.setString(paramCount++, advancedSearch.getCompanyName());
                }
                if(advancedSearch.getJobTitle().length() != 0)
                    pstmt.setString(paramCount++, advancedSearch.getJobTitle());
                
                if(advancedSearch.getRegNa().length() != 0)
                    pstmt.setString(paramCount++, advancedSearch.getRegNa());
                
                if(advancedSearch.getRegCd().length() != 0){
                    pstmt.setString(paramCount++, advancedSearch.getRegCd());
                    pstmt.setString(paramCount++,advancedSearch.getRegCdDesc());
                }
                
                if(advancedSearch.getPrefMailCd().length() != 0)
                    pstmt.setString(paramCount++, advancedSearch.getPrefMailCd());
                
                if(advancedSearch.getVmNodeNu().length() != 0)
                    pstmt.setString(paramCount++, advancedSearch.getVmNodeNu());
                
                if(advancedSearch.getPhoneNumber().length() != 0){
                    pstmt.setString(paramCount++,  "%" + advancedSearch.getPhoneNumber() + "%") ;
                    pstmt.setString(paramCount++, "1") ;
                }
                else if(advancedSearch.getPhoneNuExt().length() != 0){
                    pstmt.setString(paramCount++,  "%" + advancedSearch.getPhoneNuExt()) ;
                    pstmt.setString(paramCount++, "1") ;
                }
                
                resultSet = pstmt.executeQuery();
                int recordcount = 0;
                BasicSearchResult basicSearchResult;
                for(; resultSet.next(); queryResults.add(basicSearchResult)){
                    recordcount = recordcount + 1;
                    
                    basicSearchResult = new BasicSearchResult();
                    String mySeqNu = "";
                    try
                    {
                        mySeqNu = String.valueOf(resultSet.getLong(30));
                        basicSearchResult.setSequenceNu(mySeqNu);
                    }catch(Exception e){
                        mySeqNu = "";
                    }
                    
                    basicSearchResult.setEid(StringUtils.nullToEmptyString(resultSet.getString(1)));
                    String opTest = "";
                    try
                    {
                        opTest = Integer.toString(resultSet.getInt(2));
                    }catch(Exception e){
                        opTest = "";
                    }
                    
                    //log.error("before setting setoperidnu");
                    basicSearchResult.setOperIdNu(StringUtils.nullToEmptyString(opTest));
                    basicSearchResult.setLastNm(StringUtils.nullToEmptyString(resultSet.getString(3)));
                    basicSearchResult.setFstNm(StringUtils.nullToEmptyString(resultSet.getString(4)));
                    basicSearchResult.setMidInitNa(StringUtils.nullToEmptyString(resultSet.getString(5)));
                    basicSearchResult.setJobTitlDs(StringUtils.nullToEmptyString(resultSet.getString(7)));
                    basicSearchResult.setBusL1Ad(StringUtils.nullToEmptyString(resultSet.getString(11)));
                    basicSearchResult.setBusL2Ad(StringUtils.nullToEmptyString(resultSet.getString(12)));
                    basicSearchResult.setBusCityAd(StringUtils.nullToEmptyString(resultSet.getString(13)));
                    basicSearchResult.setBusAbbrStAd(StringUtils.nullToEmptyString(resultSet.getString(14)));
                    basicSearchResult.setBusPstlCd(StringUtils.nullToEmptyString(resultSet.getString(15)));
                    basicSearchResult.setFstNaAlias(StringUtils.nullToEmptyString(resultSet.getString(16)));
                    basicSearchResult.setMailBoxNu(StringUtils.nullToEmptyString(resultSet.getString(18)));
                    basicSearchResult.setMailCd("");
                    basicSearchResult.setUsCellPhne(StringUtils.nullToEmptyString(resultSet.getString(20)));
                    basicSearchResult.setVmNodeNu(StringUtils.nullToEmptyString(resultSet.getString(21)));
                    basicSearchResult.setPrefMailCd(StringUtils.nullToEmptyString(resultSet.getString(22)));
                    basicSearchResult.setVmBoxNu("");
                    basicSearchResult.setAdminOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(24)));
                    basicSearchResult.setDFlag(StringUtils.nullToEmptyString(resultSet.getString(31)));
                    
                    if(opTest.length() > 0 && !opTest.equals("0")){
                        basicSearchResult.setEmail("N/A");
                        basicSearchResult.setDeptNu("N/A");
                        basicSearchResult.setDeptNa("");
                        String ooCity = "";
                        String ooState = "";
                        ooCity = StringUtils.nullToEmptyString(resultSet.getString(28));
                        ooState = StringUtils.nullToEmptyString(resultSet.getString(29));
                        
                        if(ooCity.length() > 0 && ooState.length() > 0)
                            basicSearchResult.setBldgNa(ooCity + ", " + ooState);
                        else
                            basicSearchResult.setBldgNa(ooCity + ooState);
                    }
                    else{
                        basicSearchResult.setEmail(StringUtils.nullToEmptyString(resultSet.getString(6)));
                        basicSearchResult.setDeptNa(StringUtils.nullToEmptyString(resultSet.getString(8)));
                        basicSearchResult.setBldgNa(StringUtils.nullToEmptyString(resultSet.getString(9)));
                        basicSearchResult.setDeptNu(StringUtils.nullToEmptyString(resultSet.getString(17)));
                        basicSearchResult.setUsOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(10)));
                    }
                    
                    String EID = (StringUtils.nullToEmptyString(resultSet.getString(1)));
                    String BusinessPhone = "";
                    if (EID.length() > 0){
                        pstmt2 = conn.prepareStatement(EXPANDED_SELECT_SQL_BUSINESSCONTACT_BY_EID);
                        pstmt2.setString(1, EID);
                        resultSet2 = pstmt2.executeQuery();
                        for(; resultSet2.next();){ 
                            if (BusinessPhone.length() == 0){                  
                                basicSearchResult.setBusinessPhone(StringUtils.nullToEmptyString(resultSet2.getString(1)));                         
                                BusinessPhone =  StringUtils.nullToEmptyString(basicSearchResult.getBusinessPhone());
                            } 
                        }
                    }
                    
                    //populate the devices for the excel spreadsheet
                    //log.error("going into devices section");
                    if(pstmt2 != null ){
                        try
                        {
                            pstmt2.close();
                            pstmt2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                    }
                    if(resultSet2 != null){ 
                        try
                        {
                            resultSet2.close();      
                            resultSet2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                        
                    }    
                    if (EID.length() > 0){
                        pstmt2 = conn.prepareStatement(EXPANDED_SELECT_SQL_DEVICEINFO_BY_EID);
                        pstmt2.setString(1, EID);
                        resultSet2 = pstmt2.executeQuery();
                        int counter = 0;
                        
                        for(;resultSet2.next();){
                            counter = counter + 1;
                            switch (counter)
                            {
                                case 1:  
                                {
                                    basicSearchResult.setDeviceNumber1(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID1(resultSet2.getInt(2));
                                    break;
                                } 
                                case 2:  
                                {
                                    basicSearchResult.setDeviceNumber2(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID2(resultSet2.getInt(2));
                                    break;
                                } 
                                case 3:  
                                {
                                    basicSearchResult.setDeviceNumber3(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID3(resultSet2.getInt(2));
                                    break;
                                } 
                                case 4:  
                                {
                                    basicSearchResult.setDeviceNumber4(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID4(resultSet2.getInt(2));
                                    break;
                                } 
                                case 5:  
                                {
                                    basicSearchResult.setDeviceNumber5(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID5(resultSet2.getInt(2));
                                    break;
                                } 
                                case 6:  
                                {
                                    basicSearchResult.setDeviceNumber6(StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                    basicSearchResult.setDeviceID6(resultSet2.getInt(2));
                                    break;
                                } 
                            }
                        }
                    }
                    
                    if(pstmt2 != null ){
                        try
                        {
                            pstmt2.close();
                            pstmt2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                    }
                    if(resultSet2 != null){ 
                        try
                        {
                            resultSet2.close();      
                            resultSet2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                        
                    }  
                }
            }               
        }catch (SQLException sqle) {
            log.error("****** GCD Database Error sqle *******" + sqle);
            log.error("[GCD] [UserProfileDAO Advanced getSearchResult] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UserProfileDAO getSearchResult] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error("****** GCD Database Error *******" + e);
            log.error(" [GCD] [UserProfileDAO Advanced getSearchResult] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UserProfileDAO getSearchResult] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            if(pstmt2 != null ){
                try
                {
                    pstmt2.close();
                    pstmt2 = null;
                }
                catch(SQLException _ex) { 
                    log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                }
            }
            if(resultSet2 != null){ 
                try
                {
                    resultSet2.close();      
                    resultSet2 = null;
                }
                catch(SQLException _ex) { 
                    log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                }
                
            }  
            DBTool.closeObjects(conn,resultSet,pstmt);  
        }
        return queryResults;
    }

     public ArrayList selectProfileByEid(String EID,SlingScriptHelper sling)throws SQLException, Exception 
     {
        ArrayList queryResults = new ArrayList();
        ArrayList queryDirectReports = new ArrayList();
        Connection conn = DBTool.getConnection(sling); 
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
        ResultSet resultSet = null;
        ResultSet resultSet2 = null;
        String temp = null;
        
        try
        {
            if(conn!=null)
            {
                // log.error("User by Eid"+EXPANDED_SELECT_SQL_BY_EID);  
                pstmt = conn.prepareStatement(EXPANDED_SELECT_SQL_BY_EID);
                pstmt.setString(1, EID);
                resultSet = pstmt.executeQuery();
                
                if(resultSet.next()){
                    ExpandedSearchResult expandedSearchResult = new ExpandedSearchResult();
                    expandedSearchResult.setEid(StringUtils.nullToEmptyString(resultSet.getString(1)));
                    expandedSearchResult.setLastNm(StringUtils.nullToEmptyString(resultSet.getString(2)));
                    expandedSearchResult.setFstNm(StringUtils.nullToEmptyString(resultSet.getString(3)));
                    expandedSearchResult.setMidInitNa(StringUtils.nullToEmptyString(resultSet.getString(4)));
                    expandedSearchResult.setEmail(StringUtils.nullToEmptyString(resultSet.getString(5)));
                    expandedSearchResult.setCtryCd(StringUtils.nullToEmptyString(resultSet.getString(6)));
                    expandedSearchResult.setSiteIdNu(StringUtils.nullToEmptyString(resultSet.getString(7)));
                    expandedSearchResult.setDeptNu(StringUtils.nullToEmptyString(resultSet.getString(8)));
                    expandedSearchResult.setCoNm(StringUtils.nullToEmptyString(resultSet.getString(9)));
                    expandedSearchResult.setFstNmAlias(StringUtils.nullToEmptyString(resultSet.getString(10)));
                    expandedSearchResult.setUsOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(11)));
                    //expandedSearchResult.setUsOffcPhneExt(StringUtils.nullToEmptyString(resultSet.getString(12)));
                    expandedSearchResult.setUsCellPhne(StringUtils.nullToEmptyString(resultSet.getString(13)));
                    expandedSearchResult.setUsFax(StringUtils.nullToEmptyString(resultSet.getString(14)));
                    
                    temp = StringUtils.nullToEmptyString(resultSet.getString(15));
                    String bldgCd = "";
                    int idx = temp.indexOf('-');
                    if(idx > 0)
                        bldgCd = temp.substring(0, idx);
                    else
                        bldgCd = temp;
                    
                    if(bldgCd.length() == 0)
                        bldgCd = "0";
                        
                    expandedSearchResult.setBldgCd(Integer.parseInt(bldgCd));
                    expandedSearchResult.setOffcFlr(StringUtils.nullToEmptyString(resultSet.getString(16)));
                    expandedSearchResult.setOffcWing(StringUtils.nullToEmptyString(resultSet.getString(17)));
                    expandedSearchResult.setOffcNu(StringUtils.nullToEmptyString(resultSet.getString(18)));
                    expandedSearchResult.setIntlOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(19)));
                    expandedSearchResult.setIntlCellPhne(StringUtils.nullToEmptyString(resultSet.getString(20)));
                    expandedSearchResult.setIntlFax(StringUtils.nullToEmptyString(resultSet.getString(21)));
                    expandedSearchResult.setBldgNa(StringUtils.nullToEmptyString(resultSet.getString(22)));
                    expandedSearchResult.setBusNm(StringUtils.nullToEmptyString(resultSet.getString(23)));
                    expandedSearchResult.setBusL1Ad(StringUtils.nullToEmptyString(resultSet.getString(24)));
                    expandedSearchResult.setBusL2Ad(StringUtils.nullToEmptyString(resultSet.getString(25)));
                    expandedSearchResult.setBusCityAd(StringUtils.nullToEmptyString(resultSet.getString(26)));
                    expandedSearchResult.setBusAbbrStAd(StringUtils.nullToEmptyString(resultSet.getString(27)));
                    expandedSearchResult.setBusPstlCd(StringUtils.nullToEmptyString(resultSet.getString(28)));
                    expandedSearchResult.setBusCtryNu(StringUtils.nullToEmptyString(resultSet.getString(29)));
                    expandedSearchResult.setBusOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(30)));
                    expandedSearchResult.setMgrLastNa(StringUtils.nullToEmptyString(resultSet.getString(31)));
                    expandedSearchResult.setMgrFstNa(StringUtils.nullToEmptyString(resultSet.getString(32)));
                    //expandedSearchResult.setMgrOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(33)));
                    //The following field is populated but it is not being displayed.
                    expandedSearchResult.setMgrOffcPhneExt(StringUtils.nullToEmptyString(resultSet.getString(34)));
                    expandedSearchResult.setAdmnLastNm(StringUtils.nullToEmptyString(resultSet.getString(35)));
                    expandedSearchResult.setAdmnFstNm(StringUtils.nullToEmptyString(resultSet.getString(36)));
                    expandedSearchResult.setAdmnOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(37)));
                    expandedSearchResult.setAdmnOffcPhneExt(StringUtils.nullToEmptyString(resultSet.getString(38)));
                    expandedSearchResult.setPreferredMailCd(StringUtils.nullToEmptyString(resultSet.getString(39)));
                    expandedSearchResult.setRowEid(StringUtils.nullToEmptyString(resultSet.getString(40)));
                    expandedSearchResult.setRowTs(resultSet.getDate(41));
                    expandedSearchResult.setJobTitlDs(StringUtils.nullToEmptyString(resultSet.getString(42)));
                    expandedSearchResult.setDeptNa(StringUtils.nullToEmptyString(resultSet.getString(43)));
                    expandedSearchResult.setMgrEid(StringUtils.nullToEmptyString(resultSet.getString(44)));
                    expandedSearchResult.setMgrPersId(StringUtils.nullToEmptyString(resultSet.getString(45)));
                    expandedSearchResult.setMgrJobTitlDs(StringUtils.nullToEmptyString(resultSet.getString(46)));
                    expandedSearchResult.setVmNodeNu(StringUtils.nullToEmptyString(resultSet.getString(47)));
                    expandedSearchResult.setMailBoxNu(StringUtils.nullToEmptyString(resultSet.getString(48)));
                    expandedSearchResult.setCmnt(StringUtils.nullToEmptyString(resultSet.getString(49)));
                    expandedSearchResult.setRegCd(StringUtils.nullToEmptyString(resultSet.getString(50)));
                    expandedSearchResult.setRegNa(StringUtils.nullToEmptyString(resultSet.getString(51)));
                    expandedSearchResult.setRegOffcDeptNu(StringUtils.nullToEmptyString(resultSet.getString(52)));
                    
                    long mySeqNu = resultSet.getLong(53);
                    try
                    {
                        expandedSearchResult.setSequenceNu(String.valueOf(mySeqNu));
                    }catch(Exception e){
                        expandedSearchResult.setSequenceNu("");
                    }
                    
                    pstmt2 = null;
                    resultSet2 = null;
                    String BusinessPhone = "";
                    String SEID = (StringUtils.nullToEmptyString(resultSet.getString(44))); 
                    
                    if (SEID.length() > 0){
                        pstmt2 = conn.prepareStatement(EXPANDED_SELECT_SQL_SUPBUSINESSCONTACT_BY_EID);
                        pstmt2.setString(1, SEID);
                        resultSet2 = pstmt2.executeQuery();                
                        for(; resultSet2.next();){ 
                            if (BusinessPhone.length() == 0){                  
                                BusinessPhone = (StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                expandedSearchResult.supsetEmail(StringUtils.nullToEmptyString(resultSet2.getString(3)));
                            } 
                        }//for    
                    }
                    expandedSearchResult.setMgrOffcPhne(BusinessPhone);
                    
                    BusinessPhone = "";
                    String DEID = "";    
                    pstmt = null;
                    pstmt = conn.prepareStatement(EXPANDED_DIRECT_REPORTS_SQL);
                    pstmt.setString(1, EID); 
                    resultSet = null;
                    resultSet = pstmt.executeQuery();
                    //log.error("Before going to direct reports loop:");
                    for(;resultSet.next();){
                        DirectReports  directReports = new DirectReports();
                        directReports.setName(StringUtils.nullToEmptyString(resultSet.getString(1)));
                        pstmt2 = null;
                        resultSet2 = null;
                        BusinessPhone = "";
                        DEID = "";
                        DEID = (StringUtils.nullToEmptyString(resultSet.getString(3)));         
                        directReports.setEID(DEID);  
                        if (DEID.length() > 0){
                            pstmt2 = conn.prepareStatement(EXPANDED_SELECT_SQL_BUSINESSCONTACT_BY_EID);
                            pstmt2.setString(1, DEID);
                            resultSet2 = pstmt2.executeQuery();                
                            for(; resultSet2.next();){ 
                                if (BusinessPhone.length() == 0){                  
                                    BusinessPhone = (StringUtils.nullToEmptyString(resultSet2.getString(1)));
                                } 
                            }//for    
                        
                        }
                        
                        directReports.setOfficePhone(BusinessPhone);
                        directReports.setEmail(StringUtils.nullToEmptyString(resultSet.getString(2)));
                        queryDirectReports.add(directReports);
                        
                        expandedSearchResult.setDirectReports(queryDirectReports);                  
                    }      
                    
                    pstmt = null;
                    pstmt = conn.prepareStatement(EXPANDED_SELECT_SQL_DEVICEINFO_BY_EID);
                    pstmt.setString(1, EID); 
                    resultSet = null;
                    resultSet = pstmt.executeQuery();
                    
                    int counter = 0;
                    for(;resultSet.next();){          
                        counter = counter + 1;
                        switch (counter)
                        {
                            case 1:  
                            {
                                expandedSearchResult.setDeviceNumber1(StringUtils.nullToEmptyString(resultSet.getString(1)));
                                expandedSearchResult.setDeviceID1(resultSet.getInt(2));
                                expandedSearchResult.setDeviceDescr1(StringUtils.nullToEmptyString(resultSet.getString(3)));
                                break;
                            } 
                            case 2:  
                            {
                                expandedSearchResult.setDeviceNumber2(StringUtils.nullToEmptyString(resultSet.getString(1)));
                                expandedSearchResult.setDeviceID2(resultSet.getInt(2));
                                expandedSearchResult.setDeviceDescr2(StringUtils.nullToEmptyString(resultSet.getString(3)));
                                break;
                            } 
                            case 3:  
                            {
                                expandedSearchResult.setDeviceNumber3(StringUtils.nullToEmptyString(resultSet.getString(1)));
                                expandedSearchResult.setDeviceID3(resultSet.getInt(2));
                                expandedSearchResult.setDeviceDescr3(StringUtils.nullToEmptyString(resultSet.getString(3)));
                                break;
                            } 
                            case 4:  
                            {
                                expandedSearchResult.setDeviceNumber4(StringUtils.nullToEmptyString(resultSet.getString(1)));
                                expandedSearchResult.setDeviceID4(resultSet.getInt(2));
                                expandedSearchResult.setDeviceDescr4(StringUtils.nullToEmptyString(resultSet.getString(3)));
                                break;
                            } 
                            case 5:  
                            {
                                expandedSearchResult.setDeviceNumber5(StringUtils.nullToEmptyString(resultSet.getString(1)));
                                expandedSearchResult.setDeviceID5(resultSet.getInt(2));
                                expandedSearchResult.setDeviceDescr5(StringUtils.nullToEmptyString(resultSet.getString(3)));
                                break;
                            } 
                            case 6:  
                            {
                                expandedSearchResult.setDeviceNumber6(StringUtils.nullToEmptyString(resultSet.getString(1)));
                                expandedSearchResult.setDeviceID6(resultSet.getInt(2));
                                expandedSearchResult.setDeviceDescr6(StringUtils.nullToEmptyString(resultSet.getString(3)));
                                break;
                            } 
                        }  //switch
                    
                    }//for    
                    
                    if(pstmt2 != null ){
                        try
                        {
                            pstmt2.close();
                            pstmt2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                    }
                    if(resultSet2 != null){ 
                        try
                        {
                            resultSet2.close();      
                            resultSet2 = null;
                        }
                        catch(SQLException _ex) { 
                            log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                        }
                        
                    }  
                    queryResults.add(expandedSearchResult);
                
                }
            }
        }catch (SQLException sqle) {
            log.error("[GCD] [UserProfileDAO selectProfileByEid] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UserProfileDAO selectProfileByEid] Error while fetching data from database :: "+ sqle.getMessage());

        }
        catch (Exception e) {
            log.error(" [GCD] [UserProfileDAO selectProfileByEid] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UserProfileDAO selectProfileByEid] Error while fetching data from database " + e.getMessage());
        }
        finally{
            // closing the database connection
            if(pstmt2 != null ){
                try
                {
                    pstmt2.close();
                    pstmt2 = null;
                }
                catch(SQLException _ex) { 
                    log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                }
            }
            if(resultSet2 != null){ 
                try
                {
                    resultSet2.close();      
                    resultSet2 = null;
                }
                catch(SQLException _ex) { 
                    log.error("[GCD UserProfileDAO] exception"+ _ex.getMessage());
                }
                
            }  
            DBTool.closeObjects(conn,resultSet,pstmt); 
        }
        return queryResults;
    }
    
    public ArrayList selectOwnerOperatorProfile(String ownerOperatorId,SlingScriptHelper sling) throws SQLException, Exception 
    {
        ArrayList queryResults = new ArrayList();
        Connection conn = DBTool.getConnection(sling);
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        String temp = null;
        String s = null;
                 
        try
        {
            if(conn!=null)
            {
                pstmt = conn.prepareStatement(EXPANDED_SELECT_OWNER_OPERATOR_SQL);
                pstmt.setString(1, ownerOperatorId);
                resultSet = pstmt.executeQuery();
                if(resultSet.next()){
                    ExpandedSearchResult expandedSearchResult = new ExpandedSearchResult();
                    expandedSearchResult.setEid(StringUtils.nullToEmptyString(resultSet.getString(1)));
                    expandedSearchResult.setLastNm(StringUtils.nullToEmptyString(resultSet.getString(2)));
                    expandedSearchResult.setFstNm(StringUtils.nullToEmptyString(resultSet.getString(3)));
                    expandedSearchResult.setMidInitNa(StringUtils.nullToEmptyString(resultSet.getString(4)));
                    expandedSearchResult.setEmail(StringUtils.nullToEmptyString(resultSet.getString(5)));
                    expandedSearchResult.setCtryCd(StringUtils.nullToEmptyString(resultSet.getString(6)));
                    expandedSearchResult.setSiteIdNu(StringUtils.nullToEmptyString(resultSet.getString(7)));
                    expandedSearchResult.setDeptNu(StringUtils.nullToEmptyString(resultSet.getString(8)));
                    expandedSearchResult.setCoNm(StringUtils.nullToEmptyString(resultSet.getString(9)));
                    expandedSearchResult.setFstNmAlias(StringUtils.nullToEmptyString(resultSet.getString(10)));
                    expandedSearchResult.setUsOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(11)));
                    //expandedSearchResult.setUsOffcPhneExt(StringUtils.nullToEmptyString(rs.getString(12)));
                    expandedSearchResult.setUsCellPhne(StringUtils.nullToEmptyString(resultSet.getString(13)));
                    expandedSearchResult.setUsFax(StringUtils.nullToEmptyString(resultSet.getString(14)));
                    
                    temp = StringUtils.nullToEmptyString(resultSet.getString(15));
                    String bldgCd = "";
                    int idx = temp.indexOf('-');
                    if(idx > 0)
                        bldgCd = temp.substring(0, idx);
                    else
                        bldgCd = temp;
                    
                    if(bldgCd.length() == 0)
                        bldgCd = "0";
                        
                    expandedSearchResult.setBldgCd(Integer.parseInt(bldgCd));
                    expandedSearchResult.setOffcFlr(StringUtils.nullToEmptyString(resultSet.getString(16)));
                    expandedSearchResult.setOffcWing(StringUtils.nullToEmptyString(resultSet.getString(17)));
                    expandedSearchResult.setOffcNu(StringUtils.nullToEmptyString(resultSet.getString(18)));
                    expandedSearchResult.setIntlOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(19)));
                    expandedSearchResult.setIntlCellPhne(StringUtils.nullToEmptyString(resultSet.getString(20)));
                    expandedSearchResult.setIntlFax(StringUtils.nullToEmptyString(resultSet.getString(21)));
                    expandedSearchResult.setBldgNa(StringUtils.nullToEmptyString(resultSet.getString(22)));
                    expandedSearchResult.setBusNm(StringUtils.nullToEmptyString(resultSet.getString(23)));
                    expandedSearchResult.setBusL1Ad(StringUtils.nullToEmptyString(resultSet.getString(24)));
                    expandedSearchResult.setBusL2Ad(StringUtils.nullToEmptyString(resultSet.getString(25)));
                    expandedSearchResult.setBusCityAd(StringUtils.nullToEmptyString(resultSet.getString(26)));
                    expandedSearchResult.setBusAbbrStAd(StringUtils.nullToEmptyString(resultSet.getString(27)));
                    expandedSearchResult.setBusPstlCd(StringUtils.nullToEmptyString(resultSet.getString(28)));
                    expandedSearchResult.setBusCtryNu(StringUtils.nullToEmptyString(resultSet.getString(29)));
                    expandedSearchResult.setBusOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(30)));
                    expandedSearchResult.setMgrLastNa(StringUtils.nullToEmptyString(resultSet.getString(31)));
                    expandedSearchResult.setMgrFstNa(StringUtils.nullToEmptyString(resultSet.getString(32)));
                    expandedSearchResult.setMgrOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(33)));
                    expandedSearchResult.setMgrOffcPhneExt(StringUtils.nullToEmptyString(resultSet.getString(34)));
                    expandedSearchResult.setAdmnLastNm(StringUtils.nullToEmptyString(resultSet.getString(35)));
                    expandedSearchResult.setAdmnFstNm(StringUtils.nullToEmptyString(resultSet.getString(36)));
                    expandedSearchResult.setAdmnOffcPhne(StringUtils.nullToEmptyString(resultSet.getString(37)));
                    expandedSearchResult.setAdmnOffcPhneExt(StringUtils.nullToEmptyString(resultSet.getString(38)));
                    expandedSearchResult.setPreferredMailCd(StringUtils.nullToEmptyString(resultSet.getString(39)));
                    expandedSearchResult.setRowEid(StringUtils.nullToEmptyString(resultSet.getString(40)));
                    expandedSearchResult.setRowTs(resultSet.getDate(41));
                    expandedSearchResult.setJobTitlDs(StringUtils.nullToEmptyString(resultSet.getString(42)));
                    expandedSearchResult.setDeptNa(StringUtils.nullToEmptyString(resultSet.getString(43)));
                    expandedSearchResult.setMgrEid(StringUtils.nullToEmptyString(resultSet.getString(44)));
                    expandedSearchResult.setMgrPersId(StringUtils.nullToEmptyString(resultSet.getString(45)));
                    expandedSearchResult.setMgrJobTitlDs(StringUtils.nullToEmptyString(resultSet.getString(46)));
                    expandedSearchResult.setVmNodeNu(StringUtils.nullToEmptyString(resultSet.getString(47)));
                    expandedSearchResult.setMailBoxNu(StringUtils.nullToEmptyString(resultSet.getString(48)));
                    expandedSearchResult.setCmnt(StringUtils.nullToEmptyString(resultSet.getString(49)));
                    expandedSearchResult.setRegCd(StringUtils.nullToEmptyString(resultSet.getString(50)));
                    expandedSearchResult.setRegNa(StringUtils.nullToEmptyString(resultSet.getString(51)));
                    
                    s = String.valueOf(resultSet.getInt(52));
                    if(s == null)
                        s = "";
                    
                    expandedSearchResult.setSequenceNu(s);
                    expandedSearchResult.setRegOffcDeptNu(StringUtils.nullToEmptyString(resultSet.getString(53)));
                    expandedSearchResult.setOperCareOfNa(StringUtils.nullToEmptyString(resultSet.getString(54)));
                    expandedSearchResult.setOperStreAd(StringUtils.nullToEmptyString(resultSet.getString(55)));
                    expandedSearchResult.setOperCityAd(StringUtils.nullToEmptyString(resultSet.getString(56)));
                    expandedSearchResult.setOperStProvAd(StringUtils.nullToEmptyString(resultSet.getString(57)));
                    expandedSearchResult.setOperZipCd(StringUtils.nullToEmptyString(resultSet.getString(58)));
                    expandedSearchResult.setOperCtryAd(StringUtils.nullToEmptyString(resultSet.getString(59)));
                    expandedSearchResult.setOperPhneAreaCd(StringUtils.nullToEmptyString(resultSet.getString(60)));
                    expandedSearchResult.setOperPhneXcngNu(StringUtils.nullToEmptyString(resultSet.getString(61)));
                    expandedSearchResult.setOperPhneLnNu(StringUtils.nullToEmptyString(resultSet.getString(62)));
                    expandedSearchResult.setOperMailCntcFl(StringUtils.nullToEmptyString(resultSet.getString(63)));
                    expandedSearchResult.setPrinOperMailFl(StringUtils.nullToEmptyString(resultSet.getString(64)));
                    expandedSearchResult.setOperIdNu(StringUtils.nullToEmptyString(resultSet.getString(65)));
                    queryResults.add(expandedSearchResult);
                }
                conn.commit();
            }
        }catch (SQLException sqle) {
            log.error("[GCD] [UserProfileDAO selectOwnerOperatorProfile] Error while fetching data from database :: "+ sqle.getMessage());
            throw new SQLException( "[GCD] [UserProfileDAO selectOwnerOperatorProfile] Error while fetching data from database :: "+ sqle.getMessage());
        }
        catch (Exception e) {
            log.error(" [GCD] [UserProfileDAO selectOwnerOperatorProfile] Error while fetching data from database  " + e.getMessage());
            throw new Exception(" [GCD] [UserProfileDAO selectOwnerOperatorProfile] Error while fetching data from database " + e.getMessage());
        }   
        finally{
            // closing the database connection
            DBTool.closeObjects(conn,resultSet,pstmt); 
        }
        return queryResults;       
    }

      
      private static String SELECT_SQL = " select h.eid, h.oper_id_nu, h.last_na, h.fst_na, h.mid_init_na,       h.email, h.job_titl_ds, h.dept_na,       b.bldg_na, d.us_offc_phne,       b.site_l1_ad, b.site_l2_ad, b.site_city_ad, b.site_abbr_st_ad,       b.site_pstl_cd, d.fst_na_alias, h.dept_nu, d.mail_box_nu,       '', d.us_cell_phne, d.vm_node_nu, d.prfd_mail_cd, '', d.admn_offc_phne,       d.oper_phne_area_cd, d.oper_phne_xcng_nu, d.oper_phne_ln_nu,       d.oper_city_ad, d.oper_st_prov_ad, h.sequence_nu, h.DISABLE_FL  \t\t from gcd_v1userhdr h, gcd_v1userdtl d, gcd_v1bldgna b  \t\twhere  h.eid = d.eid  \t\tand d.bldg_cd = b.bldg_cd(+) and ( h.display_fl = '1') and (((activeinods= 'Y') and (h.disable_fl is null or h.disable_fl = '0')) OR ((h.disable_fl is null or h.disable_fl = '0' ) and (mgr_eid is null))) ";      
      private static String PHONE_SELECT_SQL = " select h.eid, h.oper_id_nu, h.last_na, h.fst_na, h.mid_init_na,h.email, h.job_titl_ds, h.dept_na,b.bldg_na, d.us_offc_phne,b.site_l1_ad, b.site_l2_ad, b.site_city_ad, b.site_abbr_st_ad,       b.site_pstl_cd, d.fst_na_alias, h.dept_nu, d.mail_box_nu,       '', d.us_cell_phne, d.vm_node_nu, d.prfd_mail_cd, '', d.admn_offc_phne,       d.oper_phne_area_cd, d.oper_phne_xcng_nu, d.oper_phne_ln_nu,       d.oper_city_ad, d.oper_st_prov_ad, h.sequence_nu, h.DISABLE_FL, k.phone_number, k.device_id \t\t from gcd_v1userhdr h, gcd_v1userdtl d, gcd_v1bldgna b ,gcd_v1devices k \t\twhere  h.sequence_nu = d.sequence_nu(+)  \t\tand d.bldg_cd = b.bldg_cd(+) \t\t and h.eid = k.eid and ( h.display_fl = '1') and (((activeinods= 'Y') and (h.disable_fl is null or h.disable_fl = '0')) OR ((h.disable_fl is null or h.disable_fl = '0' ) and (mgr_eid is null)))";      
      private static String EXPANDED_SELECT_SQL_BY_EID = "select\tl.eid, l.last_na, l.fst_na, l.mid_init_na, l.email, l.ctry_cd,  l.site_id_nu,\tl.dept_nu, l.co_na,  u.fst_na_alias, u.us_offc_phne, u.us_offc_phne_ext, u.us_cell_phne, u.us_fax,\t u.bldg_cd, u.offc_flr, u.offc_wing, u.offc_nu, u.intl_offc_phne, u.intl_fax, u.intl_cell_phne,  b.bldg_na, b.site_ds, b.site_l1_ad, b.site_l2_ad, b.site_city_ad, b.site_abbr_st_ad,  b.site_pstl_cd, b.ctry_cd, b.site_offc_phne, l.mgr_last_na, l.mgr_fst_na, l.mgr_offc_phne, l.mgr_offc_phne_ext,  u.admn_last_na, u.admn_fst_na, u.admn_offc_phne, u.admn_offc_phne_ext, u.prfd_mail_cd, u.row_eid, u.row_ts,  l.job_titl_ds, l.dept_na, l.mgr_eid, l.mgr_pers_id, l.mgr_job_titl_ds, u.vm_node_nu, u.mail_box_nu, u.cmnt, l.reg_cd, l.reg_na, u.reg_offc_dept_nu, l.sequence_nu  from gcd_v1userhdr l, gcd_v1userdtl u, gcd_v1bldgna b  where  l.eid = u.eid  and u.bldg_cd = b.bldg_cd(+)  and ( l.disable_fl is null or l.disable_fl = '0' ) and upper(l.eid) = ? ";   
      private static String EXPANDED_SELECT_SQL_DEVICEINFO_BY_EID = "select phone_number, gcd_v1devices.device_id, device_type_desc from gcd_v1devices inner join gcd_v1devicetype on gcd_v1devices.device_id = gcd_v1devicetype.device_id where gcd_v1devices.device_id in (1,2,5,6) and upper(gcd_v1devices.eid) = ?  order by gcd_v1devices.eid, gcd_v1devices.device_id"; 
      private static String EXPANDED_SELECT_SQL_BUSINESSCONTACT_BY_EID = " select phone_number, device_id from gcd_v1devices where device_id in (1) and upper(gcd_v1devices.eid) = ? ";
      private static String EXPANDED_SELECT_SQL_SUPBUSINESSCONTACT_BY_EID = " select phone_number, device_id, email from gcd_v1devices,gcd_v1userhdr where device_id in (1) and  gcd_v1userhdr.eid = gcd_v1devices.eid and upper(gcd_v1devices.eid) = ? ";
      private static String EXPANDED_SELECT_OWNER_OPERATOR_SQL = "select\tl.eid, l.last_na, l.fst_na, l.mid_init_na, l.email, c.ctry_na,  l.site_id_nu,\tl.dept_nu, l.co_na,  u.fst_na_alias, u.us_offc_phne, u.us_offc_phne_ext, u.us_cell_phne, u.us_fax,\t u.bldg_cd, u.offc_flr, u.offc_wing, u.offc_nu, u.intl_offc_phne, u.intl_fax, u.intl_cell_phne,  b.bldg_na, b.site_ds, b.site_l1_ad, b.site_l2_ad, b.site_city_ad, b.site_abbr_st_ad,  b.site_pstl_cd, b.ctry_cd, b.site_offc_phne, l.mgr_last_na, l.mgr_fst_na, l.mgr_offc_phne, l.mgr_offc_phne_ext,  u.admn_last_na, u.admn_fst_na, u.admn_offc_phne, u.admn_offc_phne_ext, u.prfd_mail_cd, u.row_eid, u.row_ts,  l.job_titl_ds, l.dept_na, l.mgr_eid, l.mgr_pers_id, l.mgr_job_titl_ds, u.vm_node_nu, u.mail_box_nu, u.cmnt, l.reg_cd, l.reg_na,   '', u.reg_offc_dept_nu, u.oper_care_of_na, u.oper_stre_ad, u.oper_city_ad, u.oper_st_prov_ad,  u.oper_zip_cd, u.oper_city_ad, u.oper_phne_area_cd, u.oper_phne_xcng_nu, u.oper_phne_ln_nu, u.oper_mail_cntc_fl, prin_oper_mail_fl, l.oper_id_nu  from gcd_v1userhdr l, gcd_v1userdtl u, gcd_v1bldgna b, gcd_v1contry c  where  l.sequence_nu = u.sequence_nu  and u.bldg_cd = b.bldg_cd(+)  and l.ctry_cd = c.ctry_cd(+) and ( l.disable_fl is null or l.disable_fl = '0' ) and upper(l.oper_id_nu) = ? ";
      private static String EXPANDED_DIRECT_REPORTS_SQL = "select last_na || ', ' ||  fst_na as name , email,eid from gcd_v1userhdr where disable_fl = 0 and activeinods = 'Y' and mgr_eid = ? order by last_na ";
    
    
}