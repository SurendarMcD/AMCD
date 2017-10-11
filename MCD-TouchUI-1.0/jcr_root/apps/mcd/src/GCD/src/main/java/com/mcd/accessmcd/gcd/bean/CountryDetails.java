/* 
 * CountryDetails.java                                                                  
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep Jain                                                  
 * Date        :- December 09, 2008                                                     
 * Description :- Object for CountryDetails
 *
 */

package com.mcd.accessmcd.gcd.bean;

import java.sql.Date;

public class CountryDetails {

    public CountryDetails() {
    }

    public String getActiveFl() {
        return activeFl;
    }

    public void setActiveFl(String activeFl) {
        this.activeFl = activeFl;
    }

    public String getCtryCd() {
        return ctryCd;
    }

    public void setCtryCd(String ctryCd) {
        this.ctryCd = ctryCd;
    }

    public String getCtryNm() {
        return ctryNm;
    }

    public void setCtryNm(String ctryNm) {
        this.ctryNm = ctryNm;
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

    private String ctryCd;
    private String ctryNm;
    private String activeFl;
    private String rowEid;
    private Date rowTs;
}