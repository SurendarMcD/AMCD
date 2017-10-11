/* 
 * ExpandedSearchResult.java                                                                    
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep jain                                                  
 * Date        :- December 22, 2008                                                     
 * Description :- Object for ExpandedSearchResult
 * SSV changed on 03/25/2010 Added 6 devices and device numbers
 *
 */

package com.mcd.accessmcd.gcd.bean;


import java.sql.Date;
import java.util.Calendar;
import java.util.ArrayList;


/**
 *
 * @author Sandeep jain
 */
 

public class ExpandedSearchResult {

    public ExpandedSearchResult() {
    }

    public String getAdmnFstNm() {
        return admnFstNm;
    }

    public void setAdmnFstNm(String admnFstNm) {
        this.admnFstNm = admnFstNm;
    }

    public String getAdmnLastNm() {
        return admnLastNm;
    }

    public void setAdmnLastNm(String admnLastNm) {
        this.admnLastNm = admnLastNm;
    }

    public String getAdmnOffcPhne() {
        return admnOffcPhne;
    }

    public void setAdmnOffcPhne(String admnOffcPhne) {
        this.admnOffcPhne = admnOffcPhne;
    }

    public String getAdmnOffcPhneExt() {
        return admnOffcPhneExt;
    }

    public void setAdmnOffcPhneExt(String admnOffcPhneExt) {
        this.admnOffcPhneExt = admnOffcPhneExt;
    }

    public int getBldgCd() {
        return bldgCd;
    }

    public void setBldgCd(int bldgCd) {
        this.bldgCd = bldgCd;
    }

    public String getBusAbbrStAd() {
        return busAbbrStAd;
    }

    public void setBusAbbrStAd(String busAbbrStAd) {
        this.busAbbrStAd = busAbbrStAd;
    }

    public String getBusCityAd() {
        return busCityAd;
    }

    public void setBusCityAd(String busCityAd) {
        this.busCityAd = busCityAd;
    }

    public String getBusCtryNu() {
        return busCtryNu;
    }

    public void setBusCtryNu(String busCtryNu) {
        this.busCtryNu = busCtryNu;
    }

    public String getBusL1Ad() {
        return busL1Ad;
    }

    public void setBusL1Ad(String busL1Ad) {
        this.busL1Ad = busL1Ad;
    }

    public String getBusL2Ad() {
        return busL2Ad;
    }

    public void setBusL2Ad(String busL2Ad) {
        this.busL2Ad = busL2Ad;
    }

    public String getBusNm(){ 
    
        return busNm;
    }

    public void setBusNm(String busNm) {
    
        this.busNm = busNm;
    }

    public String getBusPstlCd() {
    
        return busPstlCd;
    }

    public void setBusPstlCd(String busPstlCd) {
    
        this.busPstlCd = busPstlCd;
    }

    public String getCoNm() {
    
        return coNm;
    }

    public void setCoNm(String coNm) {
    
        this.coNm = coNm;
    }

    public String getCtryCd() {
    
        return ctryCd;
    }

    public void setCtryCd(String ctryCd) {
    
        this.ctryCd = ctryCd;
    }

    public String getDeptNu() {
    
        return deptNu;
    }

    public void setDeptNu(String deptNu) {
    
        this.deptNu = deptNu;
    }

    public String getEid() {
    
        return eid;
    }

    public void setEid(String eid) {
    
        this.eid = eid;
    }

    public String getEmail() {
    
        return email;
    }

    public void setEmail(String email){ 
    
        this.email = email;
    }
    
    //SSV added for Manager e-mail
    
    public String supgetEmail() {
        return supemail;
    }

    public void supsetEmail(String supemail){ 
        this.supemail = supemail;
    }       
    
    //SSV end for manager e-mail
    public String getFstNm() {
        return fstNm;
    }

    public void setFstNm(String fstNm) {
        this.fstNm = fstNm;
    }

    public String getFstNmAlias() {
        return fstNmAlias;
    }

    public void setFstNmAlias(String fstNmAlias){ 
        this.fstNmAlias = fstNmAlias;
    }

    public String getIntlCellPhne() {
        return intlCellPhne;
    }

    public void setIntlCellPhne(String intlCellPhne){ 
        this.intlCellPhne = intlCellPhne;
    }

    public String getIntlFax() {
        return intlFax;
    }

    public void setIntlFax(String intlFax) {
        this.intlFax = intlFax;
    }

    public String getIntlOffcPhne() {
        return intlOffcPhne;
    }

    public void setIntlOffcPhne(String intlOffcPhne) {
        this.intlOffcPhne = intlOffcPhne;
    }

    public String getLastNm() {
        return lastNm;
    }

    public void setLastNm(String lastNm){ 
        this.lastNm = lastNm;
    }

    public String getMgrFstNa() {
       return mgrFstNa;
    }

    public void setMgrFstNa(String mgrFstNa) {
        this.mgrFstNa = mgrFstNa;
    }

    public String getMgrLastNa() {
        return mgrLastNa;
    }

    public void setMgrLastNa(String mgrLastNa) { 
        this.mgrLastNa = mgrLastNa;
    }

    public String getMgrOffcPhne() {
        return mgrOffcPhne;
    }

    public void setMgrOffcPhne(String mgrOffcPhne) {
        this.mgrOffcPhne = mgrOffcPhne;
    }

    public String getMgrOffcPhneExt() {
        return mgrOffcPhneExt;
    }

    public void setMgrOffcPhneExt(String mgrOffcPhneExt) {
        this.mgrOffcPhneExt = mgrOffcPhneExt;
    }

    public String getMidInitNa() {
        return midInitNa;
    }

    public void setMidInitNa(String midInitNa) {
        this.midInitNa = midInitNa;
    }

    public String getOffcFlr() {
        return offcFlr;
    }

    public void setOffcFlr(String offcFlr) {
        this.offcFlr = offcFlr;
    }

    public String getOffcNu() {
        return offcNu;
    }

    public void setOffcNu(String offcNu) {
        this.offcNu = offcNu;
    }

    public String getOffcWing() {
        return offcWing;
    }

    public void setOffcWing(String offcWing) {
        this.offcWing = offcWing;
    }

    public String getSiteIdNu() {
        return siteIdNu;
    }

    public void setSiteIdNu(String siteIdNu) {
        if(siteIdNu == null || siteIdNu.length() < 5 || siteIdNu.length() > 7) {
            this.siteIdNu = siteIdNu;
            return;
        }
        if(siteIdNu.length() == 5)
            this.siteIdNu = "00" + siteIdNu.substring(0, 1) + "-" + siteIdNu.substring(1);
        else if(siteIdNu.length() == 6)
            this.siteIdNu = "0" + siteIdNu.substring(0, 2) + "-" + siteIdNu.substring(2);
        else if(siteIdNu.length() == 7)
            this.siteIdNu = siteIdNu.substring(0, 3) + "-" + siteIdNu.substring(3);
    }

    public String getUsCellPhne() {
        return usCellPhne;
    }

    public void setUsCellPhne(String usCellPhne) {
        this.usCellPhne = usCellPhne;
    }

    public String getUsFax() {
        return usFax;
    }

    public void setUsFax(String usFax) {
        this.usFax = usFax;
    }

    public String getUsOffcPhne() {
        return usOffcPhne;
    }

    public void setUsOffcPhne(String usOffcPhne) {
        this.usOffcPhne = usOffcPhne;
    }

    public String getUsOffcPhneExt() {
        return usOffcPhneExt;
    }

    public void setUsOffcPhneExt(String usOffcPhneExt) {
        this.usOffcPhneExt = usOffcPhneExt;
    }

    public String getRowEid() {
        return rowEid;
    }

    public void setRowEid(String rowEid) {
        this.rowEid = rowEid;
    }

    public Date getRowTs() {
        return rowTs;
    }

    public void setRowTs(Date rowTs) {
        this.rowTs = rowTs;
    }

    public String displayRowTs() {
        Date d = getRowTs();
        StringBuffer sb = new StringBuffer();
        Calendar cal = Calendar.getInstance();
        if(d != null) {
            cal.setTime(d);
            int month = cal.get(2);
            String szMonthAbbrv = "";
            if(month == 0)
                szMonthAbbrv = "Jan";
            else if(month == 1)
                szMonthAbbrv = "Feb";
            else if(month == 2)
                szMonthAbbrv = "Mar";
            else if(month == 3)
                szMonthAbbrv = "Apr";
            else if(month == 4)
                szMonthAbbrv = "May";
            else if(month == 5)
                szMonthAbbrv = "Jun";
            else if(month == 6)
                szMonthAbbrv = "Jul";
            else if(month == 7)
                szMonthAbbrv = "Aug";
            else if(month == 8)
                szMonthAbbrv = "Sep";
            else if(month == 9)
                szMonthAbbrv = "Oct";
            else if(month == 10)
                szMonthAbbrv = "Nov";
            else if(month == 11)
                szMonthAbbrv = "Dec";
            
            sb.append(szMonthAbbrv).append(" ").append(String.valueOf(cal.get(5))).append(", ").append(String.valueOf(cal.get(1)));
        } else {
            sb.append("");
        }
        return sb.toString();
    }

    public String getBldgNa() {
        return bldgNa;
    }

    public void setBldgNa(String bldgNa) {
        this.bldgNa = bldgNa;
    }

    public String getBusOffcPhne() {
        return busOffcPhne;
    }

    public void setBusOffcPhne(String busOffcPhne) {
        this.busOffcPhne = busOffcPhne;
    }

    public String getDeptNa() {
        return deptNa;
    }

    public void setDeptNa(String deptNa) {
        this.deptNa = deptNa;
    }

    public String getJobTitlDs() {
        return jobTitlDs;
    }

    public void setJobTitlDs(String jobTitlDs) {
        this.jobTitlDs = jobTitlDs;
    }

    public String getMgrEid() {
        return mgrEid;
    }

    public void setMgrEid(String mgrEid) {
        this.mgrEid = mgrEid;
    }

    public String getMgrJobTitlDs() {
        return mgrJobTitlDs;
    }

    public void setMgrJobTitlDs(String mgrJobTitlDs) {
        this.mgrJobTitlDs = mgrJobTitlDs;
    }

    public String getMgrPersId() {
        return mgrPersId;
    }

    public void setMgrPersId(String mgrPersId) {
        this.mgrPersId = mgrPersId;
    }

    public String getCmnt() {
        return cmnt;
    }

    public void setCmnt(String cmnt) {
        this.cmnt = cmnt;
    }

    public String getMailBoxNu() {
        return mailBoxNu;
    }

    public void setMailBoxNu(String mailBoxNu) {
        this.mailBoxNu = mailBoxNu;
    }

    public String getVmNodeNu() {
        return vmNodeNu;
    }

    public void setVmNodeNu(String vmNodeNu) {
        this.vmNodeNu = vmNodeNu;
    }

    public String getPreferredMailCd() {
        return preferredMailCd;
    }

    public void setPreferredMailCd(String preferredMailCd) {
        this.preferredMailCd = preferredMailCd;
    }

    public String getRegCd() {
        return regCd;
    }

    public void setRegCd(String regCd) {
        this.regCd = regCd;
    }

    public String getRegNa() {
        return regNa;
    }

    public void setRegNa(String regNa) {
        this.regNa = regNa;
    }

    public String getOperCareOfNa() {
        return operCareOfNa;
    }

    public void setOperCareOfNa(String operCareOfNa) {
        this.operCareOfNa = operCareOfNa;
    }

    public String getOperCityAd() {
        return operCityAd;
    }

    public void setOperCityAd(String operCityAd) {
        this.operCityAd = operCityAd;
    }

    public String getOperCtryAd() {
        return operCtryAd;
    }

    public void setOperCtryAd(String operCtryAd) {
        this.operCtryAd = operCtryAd;
    }

    public String getOperMailCntcFl() {
        return operMailCntcFl;
    }

    public void setOperMailCntcFl(String operMailCntcFl) {
        this.operMailCntcFl = operMailCntcFl;
    }

    public String getOperPhneAreaCd() {
        return operPhneAreaCd;
    }

    public void setOperPhneAreaCd(String operPhneAreaCd) {
        this.operPhneAreaCd = operPhneAreaCd;
    }

    public String getOperPhneLnNu() {
        return operPhneLnNu;
    }

    public void setOperPhneLnNu(String operPhneLnNu) {
        this.operPhneLnNu = operPhneLnNu;
    }

    public String getOperPhneXcngNu() {
        return operPhneXcngNu;
    }

    public void setOperPhneXcngNu(String operPhneXcngNu) {
        this.operPhneXcngNu = operPhneXcngNu;
    }

    public String getOperStProvAd() {
        return operStProvAd;
    }

    public void setOperStProvAd(String operStProvAd) {
        this.operStProvAd = operStProvAd;
    }

    public String getOperStreAd() {
        return operStreAd;
    }

    public void setOperStreAd(String operStreAd) {
        this.operStreAd = operStreAd;
    }

    public String getOperZipCd() {
        return operZipCd;
    }

    public void setOperZipCd(String operZipCd) {
        this.operZipCd = operZipCd;
    }

    public String getPrinOperMailFl() {
        return prinOperMailFl;
    }

    public void setPrinOperMailFl(String prinOperMailFl) {
        this.prinOperMailFl = prinOperMailFl;
    }

    public String getRegOffcDeptNu() {
        return regOffcDeptNu;
    }

    public void setRegOffcDeptNu(String regOffcDeptNu) {
        this.regOffcDeptNu = regOffcDeptNu;
    }

    public String getSequenceNu() {
        return sequenceNu;
    }

    public void setSequenceNu(String sequenceNu) {
        this.sequenceNu = sequenceNu;
    }

    public String getOperIdNu() {
        return operIdNu;
    }

    public void setOperIdNu(String operIdNu) {
        this.operIdNu = operIdNu;
    }

    public String getVmBoxNu() {
        return vmBoxNu;
    }

    //**********************************************************************************
    //MPPM allows up to six numbers to be entered.                                     * 
    //Added ib 03/24 by SSV to add 12 methods 6 for phone numbers and 6 for deviceids  *
    //**********************************************************************************
    

    public String getDeviceNumber1() {
        return DeviceNumber1;
    }

    public void setDeviceNumber1(String DeviceNumber1) {
        this.DeviceNumber1 = DeviceNumber1;
    }
    
    public String getDeviceNumber2() {
        return DeviceNumber2;
    }

    public void setDeviceNumber2(String DeviceNumber2) {
        this.DeviceNumber2 = DeviceNumber2;
    }
    
    public String getDeviceNumber3() {
        return DeviceNumber3;
    }

    public void setDeviceNumber3(String DeviceNumber3) {
        this.DeviceNumber3 = DeviceNumber3;
    }
    
    public String getDeviceNumber4() {
        return DeviceNumber4;
    }

    public void setDeviceNumber4(String DeviceNumber4) {
        this.DeviceNumber4 = DeviceNumber4;
    }
    
    public String getDeviceNumber5() {
        return DeviceNumber5;
    }

    public void setDeviceNumber5(String DeviceNumber5) {
        this.DeviceNumber5 = DeviceNumber5;
    }
    
    public String getDeviceNumber6() {
        return DeviceNumber6;
    }

    public void setDeviceNumber6(String DeviceNumber6) {
        this.DeviceNumber6 = DeviceNumber6;
    }
    
    public int getDeviceID1() {
        return Device1;
    }

    public void setDeviceID1(int Device1) {
        this.Device1 = Device1;
    }
    
    public int getDeviceID2() {
        return Device2;
    }
    
    public void setDeviceID2(int Device2) {
        this.Device2 = Device2;
    }
    
    public int getDeviceID3() {
        return Device3;
    }
    public void setDeviceID3(int Device3) {
        this.Device3 = Device3;
    }
    
    public int getDeviceID4() {
        return Device4;
    }

    public void setDeviceID4(int Device4) {
        this.Device4= Device4;
    }
    
    public int getDeviceID5() {
        return Device5;
    }
    
    public void setDeviceID5(int Device5) {
        this.Device5 = Device5;
    }  
    
    public int getDeviceID6() {
        return Device6;
    }

    public void setDeviceID6(int Device6) {
        this.Device6 = Device6;
    }
    
    
    //Added Description
    
    public void setDeviceDescr1(String DeviceDescr1) {
        this.DeviceDescr1 =DeviceDescr1;
    }
    
    
    public void setDeviceDescr2(String DeviceDescr2) {
        this.DeviceDescr2 =DeviceDescr2;
    }


    public void setDeviceDescr3(String DeviceDescr3) {
        this.DeviceDescr3 =DeviceDescr3;
    }


    public void setDeviceDescr4(String DeviceDescr4) {
        this.DeviceDescr4 =DeviceDescr4;
    }

    public void setDeviceDescr5(String DeviceDescr5) {
        this.DeviceDescr5 =DeviceDescr5;
    }

    public void setDeviceDescr6(String DeviceDescr6){
        this.DeviceDescr6 =DeviceDescr6;
    }
             
    public String getDeviceDescr1() { 
        return DeviceDescr1;
    }    
    
    
    public String getDeviceDescr2() {
        return DeviceDescr2;
    }    
    
    public String getDeviceDescr3() {
        return DeviceDescr3;
    }    
    
    public String getDeviceDescr4() {
        return DeviceDescr4;
    }    
    
    public String getDeviceDescr5() {
        return DeviceDescr5;
    }    
    
    public String getDeviceDescr6() {
        return DeviceDescr6;
    }    
     
    //End
  
    //Added for displaying the direct reports
    public void setDirectReports(ArrayList<String> DirectReports) {
        this.DirectReports = DirectReports;
    }
    
    public ArrayList<String> getDirectReports() {
        return DirectReports;
    }

    private String eid;
    private String lastNm;
    private String fstNm;
    private String midInitNa;
    private String email;
    //ssv added for supervisor email
    private String supemail;
    //ssv end
    private String ctryCd;
    private String siteIdNu;
    private String deptNu;
    private String coNm;
    private String fstNmAlias;
    private String usOffcPhne;
    private String usOffcPhneExt;
    private String usCellPhne;
    private String usFax;
    private int bldgCd;
    private String offcFlr;
    private String offcWing;
    private String offcNu;
    private String intlOffcPhne;
    private String intlCellPhne;
    private String intlFax;
    private String bldgNa;
    private String busNm;
    private String busL1Ad;
    private String busL2Ad;
    private String busCityAd;
    private String busAbbrStAd;
    private String busPstlCd;
    private String busCtryNu;
    private String busOffcPhne;
    private String mgrLastNa;
    private String mgrFstNa;
    private String admnLastNm;
    private String admnFstNm;
    private String admnOffcPhne;
    private String admnOffcPhneExt;
    private String preferredMailCd;
    private String rowEid;
    private Date rowTs;
    private String jobTitlDs;
    private String deptNa;
    private String mgrEid;
    private String mgrPersId;
    private String mgrJobTitlDs;
    private String mgrOffcPhne;
    private String mgrOffcPhneExt;
    private String vmNodeNu;
    private String vmBoxNu;
    private String mailBoxNu;
    private String cmnt;
    private String regCd;
    private String regNa;
    private String sequenceNu;
    private String regOffcDeptNu;
    private String operCareOfNa;
    private String operStreAd;
    private String operCityAd;
    private String operStProvAd;
    private String operZipCd;
    private String operCtryAd;
    private String operPhneAreaCd;
    private String operPhneXcngNu;
    private String operPhneLnNu;
    private String operMailCntcFl;
    private String prinOperMailFl;
    private String operIdNu;
    
    
    //SSV added the following variables for the six device ids.
    
    private int Device1;
    private int Device2;
    private int Device3;
    private int Device4;
    private int Device5;
    private int Device6;
    
    ////SSV added the following variables for the six device ids.
    
    private String DeviceNumber1;
    private String DeviceNumber2;
    private String DeviceNumber3;
    private String DeviceNumber4;
    private String DeviceNumber5;
    private String DeviceNumber6;
    
    //SSV added the following variables for the six device description
    
    private String DeviceDescr1;
    private String DeviceDescr2;
    private String DeviceDescr3;
    private String DeviceDescr4;
    private String DeviceDescr5;
    private String DeviceDescr6;
    
    //SSV added the following ArrayList for the direct reports
    
    //private ArrayList DirectReports = new ArrayList();
    private ArrayList<String> DirectReports;
            
}