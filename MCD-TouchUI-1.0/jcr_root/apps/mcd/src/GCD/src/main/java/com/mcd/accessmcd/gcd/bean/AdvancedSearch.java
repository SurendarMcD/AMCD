/* 
 * AdvancedSearch.java                                                                  
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep Jain                                                  
 * Date        :- December 22, 2008                                                     
 * Description :-  object for AdvanceSearch
 *
 */


package com.mcd.accessmcd.gcd.bean;

import com.mcd.accessmcd.gcd.bean.BasicSearch;

/**
 *
 * @author Sandeep Jain
 */
public class AdvancedSearch extends BasicSearch{

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
    
        this.companyName = companyName;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getEid() {
        return eid;
    }

    public void setEid(String eid) {
        this.eid = eid;
    }

    public String getMi() {
        return mi;
    }

    public void setMi(String mi) {
        this.mi = mi;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getBuildingCd() {
        return buildingCd;
    }

    public void setBuildingCd(String buildingCd) {
        this.buildingCd = buildingCd;
    }

    public String getBuildingNa() {
        return buildingNa;
    }

    public void setBuildingNa(String buildingNa) {
        this.buildingNa = buildingNa;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getDepartmentNumber() {
        return departmentNumber;
    }

    public void setDepartmentNumber(String departmentNumber) {
        this.departmentNumber = departmentNumber;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getMailCd() {
        return mailCd;
    }

    public void setMailCd(String mailCd) {
        this.mailCd = mailCd;
    }

    public String getPrefMailCd() {
        return prefMailCd;
    }

    public void setPrefMailCd(String prefMailCd) {
        this.prefMailCd = prefMailCd;
    }

    public String getRegNa() {
        return regNa;
    }

    public void setRegNa(String regNa) {
        this.regNa = regNa;
    }

    public String getRegCd() {
        return regCd;
    }

    public void setRegCd(String regCd) {
        this.regCd = regCd;
    }
    
    //SSV added for the search region desc when region code is selected.
    
    public String getRegCdDesc() {
        return regCdDesc;
    }

    public void setRegCdDesc(String regCdDesc) {
        this.regCdDesc = regCdDesc;
    }

    public String getZoneCd() {
        return zoneCd;
    }

    public void setZoneCd(String zonCd) {
        zoneCd = zonCd;
    }

    public String getPhoneNuExt() {
        return phoneNuExt;
    }

    public void setPhoneNuExt(String phoneNuExt) {
        this.phoneNuExt = phoneNuExt;
    }
    
    //SSV added for the new phone field 01-06-10
    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    //SSV end - 01-06-10
    
    public String getVmNodeNu() {
        return vmNodeNu;
    }

    public void setVmNodeNu(String vmNodeNu) {
        this.vmNodeNu = vmNodeNu;
    }

    private String eid;
    private String mi;
    private String email;
    private String department;
    private String departmentNumber;
    private String state;
    private String buildingCd;
    private String buildingNa;
    private String companyName;
    private String jobTitle;
    private String regNa;
    private String regCd;
    private String zoneCd;
    private String prefMailCd;
    private String mailCd;
    private String vmNodeNu;
    private String phoneNuExt;
    //ssv added for the region code desc
    private String regCdDesc;
    //ssv added for the phone number field
    private String phoneNumber;
    
}
