
package com.mcd.accessmcd.cq.migration.util;

import java.util.ArrayList;

public class Cell
{
    private String value;
    private ArrayList styles;
    private String alignment = "";
    private String vAlignment = "middle";
    private int colSpan = 1;
    private int rowSpan = 1;
    private boolean display = true;
    private String link;
    private int width;
    
    public Cell() {}
    
    public Cell(String pValue) {
        setValue(pValue);
    }
    
    public String getValue() {
        return value;
    }
    
    public void setValue(String pValue) {
        
        if(pValue == null || pValue.trim().equals("")) {
            value = "&nbsp;";
        }
        else {
            value = pValue;
        }
        
        value = replaceString(value, "\\n", "<br>");
        value = replaceString(value, "\\t", "    ");
        
    }
    
    public void addStyle(String style) {
        if(styles == null) {
            styles = new ArrayList();
        }
        
        styles.add(style);
    }
    
    public String getStyles() {
        if(styles == null) {
            return "";
        }
        
        String returnString = (String)styles.get(0);
        
        for(int count=1; count < styles.size(); count++) {
            returnString += ";" + (String)styles.get(count);
        }
        
        return returnString;
    }
    
    public void setAlignment(String pAlignment) {
        alignment = pAlignment;
    }
    
    public String getAlignment() {
        return alignment;
    }
    
    public void setVAlignment(String pAlignment) {
        vAlignment = pAlignment;
    }
    
    public String getVAlignment() {
        return vAlignment;
    }
    
    public void setColumnSpan(int span) {
        colSpan = span;
    }
    
    public int getColumnSpan() {
        return colSpan;
    }
    
    public void setRowSpan(int span) {
        rowSpan = span;
    }
    
    public int getRowSpan() {
        return rowSpan;
    }
    
    public void setWidth(int size) {
        width = size;
    }
    
    public int getWidth() {
        return width;
    }
    
    public void setDisplay(boolean pDisplay) {
        display = pDisplay;
    }
    
    public boolean getDisplay() {
        return display;
    }
    
    public void setLink(String pLink) {
        link = pLink;
        
        // Remove single quotes
        if(link.startsWith("'")) {
            link = link.substring(1);
        }
        if(link.endsWith("'")) {
            link = link.substring(0, link.length() - 1);
        }
        
        // Check for relative link
        if(!link.startsWith("http")) {
            link += ".html";
        }
    }
    
    public String getLink() {
        if(link == null) {
            return "";
        }
        
        return link;
    }
    
    private String replaceString(String text, String find, String replace) {
        int pos = 0;
        
        pos = text.indexOf(find);
        while(pos > 0) {
            text = text.substring(0, pos) + replace + text.substring(pos + find.length());
            pos = text.indexOf(find, pos + find.length());
        }
        
        return text;
    }
}