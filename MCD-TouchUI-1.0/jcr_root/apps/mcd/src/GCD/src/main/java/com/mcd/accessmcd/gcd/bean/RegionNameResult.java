// Decompiled by DJ v3.7.7.81 Copyright 2004 Atanas Neshkov  Date: 12/23/2008 7:52:24 PM
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3) 
// Source File Name:   RegionNameResult.java

package com.mcd.accessmcd.gcd.bean;


public class RegionNameResult {

    public RegionNameResult() {
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

    public String getZoneNa() {
        return zoneNa;
    }

    public void setZoneNa(String zNa) {
        zoneNa = zNa;
    }

    public String getZoneCd() {
        return zoneCd;
    }

    public void setZoneCd(String zCd) {
        zoneCd = zCd;
    }

    private String regCd;
    private String regNa;
    private String zoneNa;
    private String zoneCd;
}
