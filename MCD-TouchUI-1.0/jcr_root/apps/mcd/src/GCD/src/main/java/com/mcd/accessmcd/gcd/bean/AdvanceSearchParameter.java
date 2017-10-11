/* 
 * AdvanceSearchParameter.java                                                                  
 * Developed by HCL Technologies.                                                       
 * Author      :- HCL                                                     
 * Description :- Object for AdvanceSearchParameter
 *
 */

package com.mcd.accessmcd.gcd.bean;

import java.util.ArrayList;

public class AdvanceSearchParameter{

    private ArrayList<String> allCountryNames;
    private ArrayList<String> allDepartmentNamesByNumber;
    private ArrayList<String> allDepartmentNumbers;
    private ArrayList<String> allStateCodes;
    private ArrayList<String> allRegionNames;
    private ArrayList<String> allRegionCodes;
    private ArrayList<String> allCompanyNames;
    private ArrayList<String> allJobTitles;
    private ArrayList<String> allPrefMailCodes;
    private ArrayList<String> allVmBoxNu;
    private ArrayList<String> allLocation;
    
    public ArrayList<String> getAllCountryNames() {
        return allCountryNames;
    }
    public void setAllCountryNames(ArrayList<String> allCountryNames) {
        this.allCountryNames = allCountryNames;
    }
        
    public ArrayList<String> getAllDepartmentNamesByNumber() {
        return allDepartmentNamesByNumber;
    }
    public void setAllDepartmentNamesByNumber(ArrayList<String> allDepartmentNamesByNumber) {
        this.allDepartmentNamesByNumber = allDepartmentNamesByNumber;
    }
    public ArrayList<String> getAllDepartmentNumbers() {
        return allDepartmentNumbers;
    }
    public void setDepartmentNumber(ArrayList<String> allDepartmentNumbers) {
        this.allDepartmentNumbers = allDepartmentNumbers;
    }
    
    public ArrayList<String> getAllStateCodes() {
        return allStateCodes;
    }
    public void setAllStateCodes(ArrayList<String> allStateCodes) {
        this.allStateCodes = allStateCodes;
    }
    
    public ArrayList<String> getAllRegionNames() {
        return allRegionNames;
    }
    public void setAllRegionNames(ArrayList<String> allRegionNames) {
        this.allRegionNames = allRegionNames;
    }
    
    public ArrayList<String> getAllRegionCodes() {
        return allRegionCodes;
    }
    public void setAllRegionCodes(ArrayList<String> allRegionCodes) {
        this.allRegionCodes = allRegionCodes;
    }
    
    public ArrayList<String> getAllCompanyNames() {
        return allCompanyNames;
    }
    public void setCompanyName(ArrayList<String> allCompanyNames) {
        this.allCompanyNames = allCompanyNames;
    }
    
    public ArrayList<String> getAllJobTitles() {
        return allJobTitles;
    }
    public void setAllJobTitles(ArrayList<String> allJobTitles) {
        this.allJobTitles = allJobTitles;
    }
    
    public ArrayList<String> getAllPrefMailCodes() {
        return allPrefMailCodes;
    }
    public void setAllPrefMailCodes(ArrayList<String> allPrefMailCodes) {
        this.allPrefMailCodes = allPrefMailCodes;
    }
    
    public ArrayList<String> getAllVmBoxNu() {
        return allVmBoxNu;
    }
    public void setVmNodeNo(ArrayList<String> allVmBoxNu) {
        this.allVmBoxNu = allVmBoxNu;
    }
    
        
    public ArrayList<String> getAllLocation() {
        return allLocation;
    }
    public void setAllLocation(ArrayList<String> allLocation) {
        this.allLocation = allLocation;
    }
}
