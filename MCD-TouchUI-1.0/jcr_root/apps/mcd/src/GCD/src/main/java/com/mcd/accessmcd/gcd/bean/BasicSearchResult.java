/* 
 * GCDSearchResult.java                                                                                                                         
 * Description :- Object for GCDSearchResult
 *
 */


package com.mcd.accessmcd.gcd.bean;

public class BasicSearchResult {

    public BasicSearchResult() {
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

    public String getBusPstlCd() {
        return busPstlCd;
    }

    public void setBusPstlCd(String busPstlCd) {
        this.busPstlCd = busPstlCd;
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

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFstNm() {
        return fstNm;
    }

    public void setFstNm(String fstNm) {
        this.fstNm = fstNm;
    }

    public String getLastNm() {
        return lastNm;
    }

    public void setLastNm(String lastNm) {
        this.lastNm = lastNm;
    }

    public String getMidInitNa() {
        return midInitNa;
    }

    public void setMidInitNa(String midInitNa) {
        this.midInitNa = midInitNa;
    }

    public String getFstNaAlias() {
        return fstNaAlias;
    }

    public void setFstNaAlias(String fstNaAlias) {
        this.fstNaAlias = fstNaAlias;
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

    public String getBldgNa() {
        return bldgNa;
    }

    public void setBldgNa(String bldgNa) {
        this.bldgNa = bldgNa;
    }

    public String getUsOffcPhne() {
        return usOffcPhne;
    }

    public void setUsOffcPhne(String usOffcPhne) {
        this.usOffcPhne = usOffcPhne;
    }

    public String getDeptNu() {
        return deptNu;
    }

    public void setDeptNu(String deptNu) {
        this.deptNu = deptNu;
    }

    public String getMailBoxNu() {
        return mailBoxNu;
    }

    public void setMailBoxNu(String mailBoxNu) {
        this.mailBoxNu = mailBoxNu;
    }

    public String getOperIdNu() {
        return operIdNu;
    }

    public void setOperIdNu(String operIdNu) {
        this.operIdNu = operIdNu;
    }

    public String getAdminOffcPhne() {
        return adminOffcPhne;
    }

    public void setAdminOffcPhne(String adminOffcPhne) {
        this.adminOffcPhne = adminOffcPhne;
    }

    public String getMailCd() {
        return mailCd;
    }

    public void setMailCd(String mailCd) {
        this.mailCd = mailCd;
    }

    public String getUsCellPhne() {
        return usCellPhne;
    }

    public void setUsCellPhne(String usCellPhne) {
        this.usCellPhne = usCellPhne;
    }

    public String getVmNodeNu() {
        return vmNodeNu;
    }

    public void setVmNodeNu(String vmNodeNu) {
        this.vmNodeNu = vmNodeNu;
    }

    public String getPrefMailCd() {
        return prefMailCd;
    }

    public void setPrefMailCd(String prefMailCd) {
        this.prefMailCd = prefMailCd;
    }

    public String getVmBoxNu() {
        return vmBoxNu;
    }

    public void setVmBoxNu(String vmBoxNu) {
        this.vmBoxNu = vmBoxNu;
    }

    public String getSequenceNu() {
        return sequenceNu;
    }

    public void setSequenceNu(String seqNu) {
        sequenceNu = seqNu;
    }

    public String getDFlag() {
        return dFlag;
    }

    public void setDFlag(String dFlag) {
    
        this.dFlag = dFlag;
    }   
    
    //**********************************************************************************
    //MPPM allows up to six numbers to be entered.                                     * 
    //Added ib 03/31 by SSV to add 12 methods 6 for phone numbers and 6 for deviceids  *
    //**********************************************************************************

    public String getBusinessPhone() {
        return BusinessPhone;
    }   

    public void setBusinessPhone(String BusinessPhone) {
        this.BusinessPhone = BusinessPhone;
    }
    
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
    

    private String lastNm;
    private String fstNm;
    private String midInitNa;
    private String sequenceNu;
    private String eid;
    private String email;
    private String bldgNa;
    private String usOffcPhne;
    private String busL1Ad;
    private String busL2Ad;
    private String busCityAd;
    private String busAbbrStAd;
    private String busPstlCd;
    private String fstNaAlias;
    private String jobTitlDs;
    private String deptNa;
    private String deptNu;
    private String mailBoxNu;
    private String operIdNu;
    private String mailCd;
    private String usCellPhne;
    private String vmNodeNu;
    private String adminOffcPhne;
    private String prefMailCd;
    private String vmBoxNu;
    private String dFlag;
    
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
    private String BusinessPhone;
}
