package com.mcd.accessmcd.cq.migration.paragraphs;

import com.mcd.accessmcd.cq.migration.util.*;

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

import org.w3c.dom.*;
import com.day.cq.commons.jcr.*;

/*
* Utility class used for migrating Table Paragraphs from CQ4
* 
*/

public class TablePara{
  
    private static final Logger log = LoggerFactory.getLogger(TablePara.class);

    public static boolean process(Element parnode, MigrationInfo mi) {
    
        try{
                mi.info("Process TablePara for"+mi.destPage.getPath());
        
        String html="";
        String tableData=Util.getChildNodeText(parnode,"TableData");
        String tableFormat=Util.getChildNodeText(parnode,"TableFormat");
        String tableBorderSize=Util.getChildNodeText(parnode,"TableBorderSize");
        String tableBorderColor=Util.getChildNodeText(parnode,"TableBorderColor");
        String tableCaption=Util.getChildNodeText(parnode,"TableCaption");
        String titleStyle=Util.getChildNodeText(parnode,"AtomStyle");
        String titleAlign=Util.getChildNodeText(parnode,"TitleAlignment");
        String tableHeaderBgColor=Util.getChildNodeText(parnode,"TableHeaderBgColor");
        String tableHeaderFontColor=Util.getChildNodeText(parnode,"TableHeaderFontColor");
        String tableHeaderEnabledString=Util.getChildNodeText(parnode,"TableHeaderEnabled");
                

        boolean tableHeaderEnabled=false;
        
        if (tableBorderSize == "") {
            tableBorderSize = "0";
        }
        
        if (tableHeaderBgColor.startsWith("#")) {
            tableHeaderBgColor = tableHeaderBgColor.replace('#',' ');
            tableHeaderBgColor = tableHeaderBgColor.trim();
        }

        if(tableHeaderEnabledString.equals("yes")) {
                tableHeaderEnabled = true;
        }
        
        
        html+="<table width=\"100%\" border=\""+tableBorderSize+"\"";
        if (!tableBorderColor.equals("")) { 
            html+=" bordercolor=\""+tableBorderColor+"\"";
        }
        html+="cellpadding=\"2\" cellspacing=\"0\">";
        if (tableCaption != "") {
            html+="<caption align=\""+titleAlign+"\"><span class=\""+titleStyle+"\">"+tableCaption+"</span></caption>";
        }

        com.mcd.accessmcd.cq.migration.util.Table table = new Table();
        table.setTableData(tableData);
        table.setTableFormatting(tableFormat);
        
        float totalWidth = 0;
        int rowWidth;
        
        // Calculate the total table width
        for(int row = 0; row < table.getRowCount(); row++) {
            rowWidth = 0;
            for(int col = 0; col < table.getColumnCount(); col++) { 
                Cell cell = table.getCell(row, col);
                if(cell.getDisplay()) {
                    rowWidth += cell.getWidth();
                }
            }
            if(rowWidth > totalWidth) {
                totalWidth = rowWidth;
            }
        }
        // Draw the table
        for(int row = 0; row < table.getRowCount(); row++) {
  
            html+="<tr>";
                  
            for(int col = 0; col < table.getColumnCount(); col++) { 
                Cell cell = table.getCell(row, col);
                if(cell.getDisplay()) {
                    if(tableHeaderEnabled && row == 0) {
                        if(!tableHeaderFontColor.equals("")) {
                            cell.addStyle("color:" + tableHeaderFontColor);
                        }
                        
                        html+="<th class=\"tableText\" bgcolor=\""+tableHeaderBgColor+"\" style=\""+cell.getStyles()+"\" width=\""+(new Float(((float)cell.getWidth() / totalWidth) * 100).intValue())+"\"";
                        html+=" height=\""+ table.getRowHeight(row)+"\"";
                        if((cell.getAlignment()).equals("")){
                            html+=" align=\"left\"";
                        }else{
                            html+=" align=\""+ cell.getAlignment()+"\"";
                        }
                        html+=" valign=\""+ cell.getVAlignment()+"\" rowspan=\""+ cell.getRowSpan() +"\" colspan=\""+ cell.getColumnSpan() +"\">"+cell.getValue()+"</th>";
                    }
                    else {
                        if(cell.getLink().trim().equals("")) {
                                html+="<td class=\"tableText\" style=\""+cell.getStyles() +"\" width=\""+( new Float(((float)cell.getWidth() / totalWidth) * 100).intValue())+"\" height=\""+ table.getRowHeight(row)+"\" align=\""+ cell.getAlignment()+"\" valign=\""+cell.getVAlignment()+"\" rowspan=\""+cell.getRowSpan()+"\" colspan=\""+cell.getColumnSpan()+"\">"+ cell.getValue()+"</td>";
                        }
                        else {
                                //CUSTOM_MCDX  Wei Wu 04/07/2007
                                String target = "_self";

                                if (cell.getLink().indexOf("http") != -1) {
                                    target = Util.createTarget(cell.getLink());
                                }
                                
                                html+="<td class=\"tableText\" style=\""+cell.getStyles() +"\" width=\""+( new Float(((float)cell.getWidth() / totalWidth) * 100).intValue())+"\"";
                                html+=" height=\""+ table.getRowHeight(row)+"\" align=\""+ cell.getAlignment()+"\" valign=\""+cell.getVAlignment()+"\" rowspan=\""+cell.getRowSpan()+"\"";
                                html+=" colspan=\""+cell.getColumnSpan()+"\"><a href=\""+cell.getLink()+"\" TARGET=\""+ target +"\">"+ cell.getValue()+"</a></td>";
                            
                        }
                    } // end table header check
                    
                } // end if cell display
                    
                    
            } //end for cells
            html+="</tr>";
        } //end for rows    
        html+="</table>";
        
        //create paragraph (using Everything)

               
               javax.jcr.Node destPar=null;
               int parcount=0;
               while(parcount<1000){
                   if(!mi.destPage.hasNode("everything_"+parcount))break;
                   parcount++;
               }
               
               destPar=mi.destPage.addNode("everything_"+parcount,"nt:unstructured");
               JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/everything");
               
               JcrUtil.setProperty(destPar,"text",html);  
               JcrUtil.setProperty(destPar,"textIsRich","true");
               
               
         }catch(Exception e){
         }
    return true;
    }
    
}