package com.mcd.accessmcd.cq.migration.util;

/* Table helper class from CQ4 */

import java.util.ArrayList;
import java.util.StringTokenizer;
import java.lang.IndexOutOfBoundsException;

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

public class Table
{
    
    private static final Logger log = LoggerFactory.getLogger(Table.class);
    

    private static final String FMT_STYLE = "font-style:";
    private static final String FMT_WEIGHT = "font-weight:";
    private static final String FMT_VALIGN = "vertical-align:";
    private static final String FMT_ALIGN = "text-align:";
    private static final String FMT_ROWSPAN = "row-span:";
    private static final String FMT_COLSPAN = "column-span:";
    private static final String FMT_HREF = "cq-link-href:";
    
    private static final String rowDelimiter = "\n";
    private static final String columnDelimiter = "\t";
    
    private ArrayList tableRows;
    private int columnCount;
    private ArrayList rowHeight;
    int defaultWidth;
    int defaultHeight;
    
    public Table() {}
    
    public void setTableData(String pData) {
            //log.error("table data : " + pData);
        tableRows = new ArrayList();
        ArrayList columnList;
        
        StringTokenizer rows = new StringTokenizer(pData, rowDelimiter);
        String[] columns;
        String row;
        String column;
        
        while(rows.hasMoreElements()) {
            row = rows.nextToken();
            //log.error("Table.setTableData() row : " + row);
            columnList = new ArrayList();
            
            columns = splitString(row, columnDelimiter);
            
            for(int col = 0; col < columns.length; col++) {
                column = columns[col];
                /*String tmpStr = column.substring(2);
                tmpStr = tmpStr.substring(0, tmpStr.length() -2 );
                column = tmpStr;
                    */
                //log.error("Table.setTableData() col : " + column);
                columnList.add(new Cell(column));
            }
            
            if(columnCount < columns.length) {
                columnCount = columns.length;
            }
            
            tableRows.add(columnList);
        }
    }
    
    public void setTableFormatting(String pFormat) {
        
        StringTokenizer rows = new StringTokenizer(pFormat, rowDelimiter);
        if(rows.countTokens() <= 0) {
            return;
        }
        
        String[] columns;
        StringTokenizer settings;
        String setting;
        String row;
        String column;
        
        rowHeight = new ArrayList();
        int colWidth[] = new int[columnCount];
        int rowNum = 0;
        Cell cell;
        


        // Skip first format row
        String colFormat = rows.nextToken();

        //log.error("colformat : " + colFormat);

        String[] colSettings = splitString(colFormat, "\t");
        

        //log.error("colsetting length : " + colSettings.length);

        // Get cell width and height defaults
        defaultWidth = getDefaultIntValue(colSettings[0], "width:");

        //log.error("default width : " + defaultWidth);
        defaultHeight = getDefaultIntValue(colSettings[0], "height:");
        
        //log.error("default height : " + defaultHeight);
        // Skip first row since it contains table defaults
        for(int count = 1; count < colSettings.length; count++) {
            //log.error("<br>colsetting value : [" + count + "] : " + colSettings[count]);
            colWidth[count - 1] = new Integer(colSettings[count].substring(colSettings[count].indexOf(":") + 1)).intValue();
            
        }

        //log.error("before has more elements...");
        
        while(rows.hasMoreElements()) {
            row = rows.nextToken();
            
            columns = splitString(row, "\t");
            
            for(int colNum = -1; colNum < columns.length - 1; colNum++) {
                
                column = columns[colNum + 1];
                
                if(colNum == -1) { // Row height
                    rowHeight.add(new Integer(
                        column.substring(column.indexOf(":") + 1)));
                }
                else {
                    cell = getCell(rowNum, colNum);
                    cell.setWidth(colWidth[colNum]);
                    
                    settings = new StringTokenizer(column, ";");
            
                    while(settings.hasMoreElements()) {
                        setting = settings.nextToken();
                        
                        if(setting.startsWith(FMT_STYLE)) {
                            cell.addStyle(setting);
                        }
                        else if(setting.startsWith(FMT_WEIGHT)) {
                            cell.addStyle(setting);
                        }
                        else if(setting.startsWith(FMT_VALIGN)) {
                            cell.setVAlignment(setting.substring(FMT_VALIGN.length()));
                        }
                        else if(setting.startsWith(FMT_ALIGN)) {
                            cell.setAlignment(setting.substring(FMT_ALIGN.length()));
                        }
                        else if(setting.startsWith(FMT_HREF)) {
                            cell.setLink(setting.substring(FMT_HREF.length()));
                        }
                        else if(setting.startsWith(FMT_ROWSPAN)) {
                            cell.setRowSpan(new Integer(setting.substring(FMT_ROWSPAN.length())).intValue());
                            for(int count = rowNum + 1; count < rowNum + cell.getRowSpan(); count++) {
                                getCell(count, colNum).setDisplay(false);
                            }   
                        }
                        else if(setting.startsWith(FMT_COLSPAN)) {
                            cell.setColumnSpan(new Integer(setting.substring(FMT_COLSPAN.length())).intValue());
                            cell.setWidth(colWidth[colNum]); 
                            for(int count = colNum + 1; count < colNum + cell.getColumnSpan(); count++) {
                                getCell(rowNum, count).setDisplay(false);
                                if(count < colWidth.length) {
                                    cell.setWidth(cell.getWidth() + colWidth[count]);
                                }
                                else {
                                    cell.setWidth(cell.getWidth() + defaultWidth);
                                }
                            }
                        }
                    } // end while loop
                    
                } // end row height check                   
            } // end column loop
            
            rowNum++;
        } // end row loop
    }
    
    public int getColumnCount() {
        return columnCount;
    }
    
    public int getRowCount() {
        return tableRows.size();
    }
    
    public Cell getCell(int row, int col) {
    
        if(row + 1 > tableRows.size()) {
            for(int count = tableRows.size(); count < row + 1; count++) {
                tableRows.add(new ArrayList());
                rowHeight.add(new Integer(defaultHeight));
            }
        }
        
        ArrayList colList = (ArrayList)tableRows.get(row);
        if(col > colList.size() - 1) {
            for(int count = colList.size(); count < col + 1; count++) {
                Cell newCell = new Cell("");
                newCell.setWidth(defaultWidth);
                colList.add(newCell);
            }
            if(columnCount < col + 1) {
                columnCount = col + 1;
            }
        }
        
        return (Cell)((ArrayList)tableRows.get(row)).get(col);
    }
    
    public int getRowHeight(int row) {
        if(rowHeight == null) {
            return 0;
        }
        else {
            return ((Integer)rowHeight.get(row)).intValue();
        }
    }
    
    private String[] splitString(String value, String delim) {
        ArrayList list = new ArrayList();
        int pos;
        int start = 0;
        
        pos = value.indexOf(delim);
        
        while(pos >= 0) {
            list.add(removeFormatChars(value.substring(start, pos).trim()));
            start = pos + delim.length();
            
            pos = value.indexOf(delim, start);
        }
        list.add(removeFormatChars(value.substring(start)));
        String[] returnValue = new String[list.size()];
        list.toArray(returnValue);
        
        return returnValue;
    }
    
    private String removeFormatChars(String value) {
        
        // Remove extra characters from text
        if(value.startsWith("\t") || value.startsWith("\r") || value.startsWith("\n")) {
            value = value.substring(1);
        }
        if(value.endsWith("\t") || value.endsWith("\r") || value.endsWith("\n")) {
            value = value.substring(0, value.length() - 1);
        }
        
        return value;
    }
    
    private int getDefaultIntValue(String defaults, String value) {
        int start = defaults.indexOf(value) + value.length();

        int end = defaults.indexOf(";", start);

        int retval = 0;
        if(end >=0)
           retval = new Integer(defaults.substring(start, end)).intValue();
        else
           retval = new Integer(defaults.substring(start)).intValue();

        return retval;
    }
    
    
            
        

}