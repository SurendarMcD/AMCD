package com.mcd.accessmcd.pci.dao.impl;
/**
DAO Implementation class to return PCI content from the new PCI DB tables <br>

Erik Wannebo 10/6/09
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.StringTokenizer;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.sling.api.scripting.SlingScriptHelper;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;
import com.mcd.accessmcd.pci.dao.IPCIContentDao;
import com.mcd.accessmcd.pci.manager.PCIResultsToXMLDoc;
import com.mcd.accessmcd.pci.util.PCIDBUtil;
import com.mcd.accessmcd.pci.util.PCIProperties;
import com.mcd.accessmcd.pci.util.XMLUtils;

public class PCIContentDBDao implements IPCIContentDao {
    
    private String PCI_DATASOURCENAME="";
    private SlingScriptHelper sling=null;
    private SimpleDateFormat sdfPublishDateMainFormat=new SimpleDateFormat("MM.dd.yy");
    private SimpleDateFormat sdfPublishDateJapanFormat=new SimpleDateFormat("yy.MM.dd");
    private SimpleDateFormat sdfPublishDateNonUSFormat=new SimpleDateFormat("dd.MM.yy");
    private static String PCI_CONTENT_QUERY_FIELDS=""+
            "CTNT.AUD_IDS AUDIENCES, "+
            "CTNT.DOC_URI, " +
            "CTNT.UUID, " +
            "CTNT.IMG_URL, " +
            "CTNT.MEDIA_URL, " +
            "CTNT.ALT_URL, " +
            "DTL.TITLE,  " +
            "DTL.DS,  " +
            "DTL.LNCH_TYP,  " +
            "DTL.PUBL_DT, " +
            "DTL.CTNT_ID, " +
            "DTL.ID, "+
            "PCI_VIEW.CD ENTITY";
    /* less efficient version
     private static String PCI_CONTENT_AUDIENCE_DATA1 = "" +
    "(select ctnt_id audienceid, ltrim(sys_connect_by_path(ds,','),',') AUDIENCES "+
    "from (select ctnt_id, "+
    "aud.ds, "+
    "row_number() over (partition by ctnt_id order by aud_id)  rn, "+
    "count(*) over  (partition by ctnt_id)   cnt "+
    "from pci_ctnt_aud caud, pci_aud aud " +
    "where aud.id=caud.aud_id "+
    ") "+
    "where rn = cnt "+
    "start with rn = 1 "+
    "connect by prior ctnt_id = ctnt_id and prior rn = rn-1)";
    */
    /*
     * 
     private static String PCI_CONTENT_AUDIENCE_DATA = "" +
    "(select audcatid, audienceid, ltrim(sys_connect_by_path(ds,','),',') AUDIENCES "+
    "from (select dtl.cat_id audcatid, " +
    "caud.ctnt_id audienceid, "+
    "aud.ds, "+
    "row_number() over (partition by caud.ctnt_id order by caud.ctnt_id)  rn, "+
    "count(*) over  (partition by caud.ctnt_id)   cnt "+
    "from pci_ctnt_aud caud, pci_aud aud, PCI_CTNT_DTL DTL " +
    "where aud.id=caud.aud_id " +
    "and caud.ctnt_id=dtl.ctnt_id "+
    "and dtl.cat_id = ? "+
    "AND DTL.ACTV_FL=1 ) "+
    "where rn = cnt "+
    "start with rn = 1 "+
    "connect by prior audienceid = audienceid and prior rn = rn-1)";
*/

    private static String PCI_CONTENT_QUERY_TABLES=""+
            "PCI_CTNT CTNT, " +
            "PCI_CTNT_DTL DTL, " +
            "PCI_CTNT_AUD AUD, " +
            "PCI_AUD, " +
            "PCI_VIEW  ";
    
    private static String PCI_CONTENT_QUERY_WHERE=""+
            "CTNT.ID=DTL.CTNT_ID " +
            "AND CTNT.ID=AUD.CTNT_ID " +
            "AND DTL.VIEW_ID=PCI_VIEW.ID " +
            "AND AUD.AUD_ID=PCI_AUD.ID " +
            "AND DTL.ACTV_FL=1 " +
//          "AND DTL.CTNT_ID=CTNT.ID " +
//          "AND WKFL.CTNT_DTL_ID = DTL.ID "  +
//          "AND WKFL.STUS_ID = 4 " +
            "AND DTL.CAT_ID= ? ";
    
    private static String PCI_CONTENT_QUERY_VIEW_PARAM="AND PCI_VIEW.CD= ? ";
    private static String PCI_CONTENT_QUERY_AUD_PARAM="AND PCI_AUD.DS= ? ";            
    
    private static String  PCI_CONTENT_QUERY_WHERE_DATES = ""+
            "AND DTL.PUBL_DT>= ? " +
            "AND DTL.PUBL_DT<= ? ";
    //this keeps future Publish Dated items from being included
    private static String  PCI_CONTENT_QUERY_WHERE_DATES_BEFORE_NOW = ""+
            "AND DTL.PUBL_DT<=  SYSDATE ";
    private static String PCI_CONTENT_ORDER_CHRONO=" ORDER BY DTL.PUBL_DT ASC";
    private static String PCI_CONTENT_ORDER_CHRONO_UUID=" ORDER BY DTL.PUBL_DT ASC, CTNT.UUID ASC";
    private static String PCI_CONTENT_ORDER_RCHRONO=" ORDER BY DTL.PUBL_DT DESC";
    private static String PCI_CONTENT_ORDER_RCHRONO_UUID=" ORDER BY DTL.PUBL_DT DESC, CTNT.UUID DESC";
    private static String PCI_CONTENT_ORDER_ALPHA=" ORDER BY nlssort(DTL.TITLE,'NLS_SORT=BINARY_CI') ";
    
    private static String PCI_CATEGORY_SQL=""+
    "SELECT " +
    "CAT.ID, " +
    "CAT.PREN_ID, " +
    "CAT.NA, " +
    "CAT.DISP_NA, " +
    "CAT.GOTO_URI " +
    "FROM PCI_CAT CAT " +
    "WHERE CAT.ID = ? ";

    public PCIContentDBDao(){
        //PCI_DATASOURCENAME=PCIProperties.PCI_DATASOURCENAME;
        //PCI_DATASOURCENAME="pciDataSource";
    }
    
    public PCIContentDBDao(SlingScriptHelper sling){
        //PCI_DATASOURCENAME=PCIProperties.PCI_DATASOURCENAME;
        //PCI_DATASOURCENAME="pciDataSource";
        this.sling=sling;
    }
    
   private boolean isInternalSite(String serverHostDomain){
       if(serverHostDomain==null)return false;
       return (serverHostDomain.indexOf(".mcdexchange.")>-1 || 
               serverHostDomain.indexOf(".accessmcd.")>-1 ||
               serverHostDomain.indexOf(".mcdwmi.")>-1 );
   }
 
    /**
     * Reads the PCIResult properties from the "content" resultset
     */
    private PCIResult readPCIContentResult(ResultSet rs){
        PCIResult retResult=new PCIResult();
        try{
            
            String docuri=rs.getString("DOC_URI");
            String altdocuri=rs.getString("ALT_URL");
            if(altdocuri!=null && !altdocuri.equals("")){
                docuri=altdocuri;
            }
            String serverHostDomain="";
            if(docuri!=null && !docuri.equals("")){
                int doubleslashloc=docuri.indexOf("//");
                if(doubleslashloc>-1){
                    int nextslash=docuri.indexOf("/",doubleslashloc+2);
                    if(nextslash>-1){
                        serverHostDomain=docuri.substring(0,nextslash);
                        docuri=docuri.substring(nextslash);
                    }
                }
            }
            String launch_type=rs.getString("LNCH_TYP");
            if(isInternalSite(serverHostDomain) && !docuri.endsWith(".html")){
                if(launch_type!=null){
                    if(launch_type.equals("0")){
                        //docuri+=".accessmcd";
                        launch_type="1";
                    }
                    if(launch_type.equals("2")){
                        //docuri+=".accessmcd";
                        launch_type="3";
                    }
                }
                docuri+=".html";
            }
            retResult.setPageURI(docuri);
            retResult.setTypeCode("A");//obsolete
            retResult.setServerHostDomain(serverHostDomain); 
            retResult.setUUID(rs.getString("UUID"));                    
            retResult.setDescription(rs.getString("DS"));                   
            retResult.setDocumentTitle(rs.getString("TITLE"));
            //added 2/24/11 ECW  
            retResult.setContentID(rs.getString("CTNT_ID"));  
            retResult.setContentDetailID(rs.getString("ID"));  
            retResult.setEntityType(rs.getString("ENTITY"));  
            //decode audiences
            String audienceCodes=rs.getString("AUDIENCES");
            String audiences="";
            StringTokenizer stAudiences=new StringTokenizer(audienceCodes,",");
            String strComma="";
            while(stAudiences.hasMoreTokens()){
                int audCode=Integer.valueOf(stAudiences.nextToken()).intValue();
                //hate to hard-code these, but here we are...
                switch (audCode){
                    case 1:audiences+=strComma+"CorpEmployees";break;
                    case 2:audiences+=strComma+"Crew";break;
                    case 3:audiences+=strComma+"FranchiseeRestMgrs";break;
                    case 4:audiences+=strComma+"Franchisees";break;
                    case 5:audiences+=strComma+"McOpCoRestMgrs";break;
                    case 6:audiences+=strComma+"SupplierVendors";break;
                    case 7:audiences+=strComma+"Agency";break;
                    case 8:audiences+=strComma+"FranchiseeOfficeStaff";break;
                    default :audiences+=strComma+String.valueOf(audCode);break;
                }
                strComma=",";
            }
            retResult.setAudienceType(audiences);
            retResult.setPageURI(docuri);
            retResult.setLaunchType(launch_type);                   

            java.util.Date publishDate=new java.util.Date(rs.getTimestamp("PUBL_DT").getTime());
            retResult.setPublishDateObj(publishDate);
            //System.out.println((new SimpleDateFormat("M/d/yy hh:mma")).format(publishDate));
            try{
                retResult.setPublishDate(sdfPublishDateMainFormat.format(publishDate));         
                retResult.setPublishDateJapan(sdfPublishDateJapanFormat.format(publishDate));           
                retResult.setPublishDateNonUS(sdfPublishDateNonUSFormat.format(publishDate));           
            }catch(Exception e){                //
                //System.out.println("error parsing date"+publishDate);
            }
                    
            retResult.setMediaURI(rs.getString("MEDIA_URL"));
            String imgURL=rs.getString("IMG_URL");
            String thumbURL=imgURL;
                if(imgURL!=null){
                    retResult.setImageURI(imgURL);
                    if(imgURL.indexOf(".featureimage.")>-1){
                        thumbURL=imgURL.replace(".featureimage.",".featurethumbnail.");
                    }
                }
            retResult.setThumbnailURI(thumbURL);                
            
        }catch(SQLException sqle){
            System.out.println("SQLException:"+sqle.getLocalizedMessage());
        }
        return retResult;
    }
    
    /**
     * Reads the PCIResult properties from the "category" resultset
     */
    private PCIResult readPCICategoryResult(ResultSet rs){
        PCIResult retResult=new PCIResult();
        try{    
            retResult.setCategoryID(rs.getString("ID"));
            String categoryName=rs.getString("NA");
            String categoryDisplayName=rs.getString("DISP_NA");
            if(categoryDisplayName!=null && !categoryDisplayName.equals("") && !categoryDisplayName.equals("n/a")){
                retResult.setCategoryTitle(categoryDisplayName);
            }else{
                retResult.setCategoryTitle(categoryName);
            }
            retResult.setPageURI(rs.getString("GOTO_URI"));
            //TODO: change when field is added
            retResult.setCategoryAbstract(rs.getString("DISP_NA"));
            retResult.setParentCategoryID(rs.getString("PREN_ID"));
        }catch(SQLException sqle){
            System.out.println("SQLException:"+sqle.getLocalizedMessage());
        }
        return retResult;
    }
    
    /**
     * Handles requests of type "content".
     */
    private ArrayList getPCIContentRequest(Connection conn, PCIQuery query) throws SQLException{
        int totalResultCount=0;
        boolean bFilterByAudience=false;
        boolean bFilterByView=false;
        

        ArrayList arrResults= new ArrayList();
        String basesql=" FROM "+ PCI_CONTENT_QUERY_TABLES+
        " WHERE " + PCI_CONTENT_QUERY_WHERE;
        if(!query.getEntityType().equals("ALL")){
            bFilterByView=true;
            basesql+=PCI_CONTENT_QUERY_VIEW_PARAM;
            }
        if(!query.getAudience().equals("ALL")){
            bFilterByAudience=true;
            basesql+=PCI_CONTENT_QUERY_AUD_PARAM;
            }
        String sqldatelimited=basesql;
        if(query.getFromDate()!=null && query.getToDate()!=null){
            sqldatelimited+=PCI_CONTENT_QUERY_WHERE_DATES;
        }else{
            //This line prevents the return of items with Publish Date greater than the current date
            //TODO: figure out how to make this independent of server time--maybe give each view a default time zone?
            sqldatelimited+=PCI_CONTENT_QUERY_WHERE_DATES_BEFORE_NOW;
        }
        //System.out.println("pci query:"+basesql);
        //********* ADD TOP STORY ENTRY
        int topstorycount=0;
        if(query.getTopStoryCategoryID()!=null && !query.getTopStoryCategoryID().equals("")){
            //add the most recent Top Story category as the first result returned
            String topstorysql="SELECT " + PCI_CONTENT_QUERY_FIELDS +basesql+PCI_CONTENT_ORDER_RCHRONO;
            PreparedStatement pstmtTopStory = conn.prepareStatement(topstorysql);
            int paramnum=1;
            pstmtTopStory.setString(paramnum++, query.getTopStoryCategoryID());
            if(bFilterByView)pstmtTopStory.setString(paramnum++, query.getEntityType());
            if(bFilterByAudience)pstmtTopStory.setString(paramnum++, query.getAudience());
            if(query.getFromDate()!=null && query.getToDate()!=null){
                pstmtTopStory.setDate(paramnum++, new java.sql.Date(query.getFromDate().getTime()));
                pstmtTopStory.setDate(paramnum++, new java.sql.Date(query.getToDate().getTime()));
            }
            ResultSet rsTopStory= pstmtTopStory.executeQuery();

            while(topstorycount<1 && rsTopStory.next()){
                PCIResult pciresult=readPCIContentResult(rsTopStory);
                pciresult.setCategoryID(query.getTopStoryCategoryID());
                arrResults.add(pciresult);
                topstorycount++;
            }
        }
        //********* END TOP STORY ENTRY

        // get total count in category
        PreparedStatement pstmtTotalCount = conn.prepareStatement("SELECT count(*)"+basesql);
        int paramnum=1;
        pstmtTotalCount.setString(paramnum++, query.getCategoryID());
        
        if(bFilterByView)pstmtTotalCount.setString(paramnum++, query.getEntityType());
        if(bFilterByAudience)pstmtTotalCount.setString(paramnum++, query.getAudience());
        ResultSet rsTotalCount= pstmtTotalCount.executeQuery();
        while(rsTotalCount.next()){
            totalResultCount=rsTotalCount.getInt(1);
        }
        
        if(query.getSortType().equals("alpha"))sqldatelimited+=PCI_CONTENT_ORDER_ALPHA;
        if(query.getSortType().equals("chrono"))sqldatelimited+=PCI_CONTENT_ORDER_CHRONO;
        if(query.getSortType().equals("chronouuid"))sqldatelimited+=PCI_CONTENT_ORDER_CHRONO_UUID;
        if(query.getSortType().equals("rchrono"))sqldatelimited+=PCI_CONTENT_ORDER_RCHRONO;
        if(query.getSortType().equals("rchronouuid"))sqldatelimited+=PCI_CONTENT_ORDER_RCHRONO_UUID;

        //System.out.println("sql:"+sql);
        //System.out.println("query cat:"+query.getCategoryID());
        //System.out.println("total result count:"+totalResultCount);
        
        if(totalResultCount>0){
            PreparedStatement pstmt = conn.prepareStatement("SELECT " + PCI_CONTENT_QUERY_FIELDS +sqldatelimited);
            //System.out.println(query.getSortType());
            //System.out.println("SELECT " + PCI_CONTENT_QUERY_FIELDS +sqldatelimited); 
            //
            paramnum=1;
            pstmt.setString(paramnum++, query.getCategoryID());
            
            if(bFilterByView)pstmt.setString(paramnum++, query.getEntityType());
            if(bFilterByAudience)pstmt.setString(paramnum++, query.getAudience());
            if(query.getFromDate()!=null && query.getToDate()!=null){
                pstmt.setDate(paramnum++, new java.sql.Date(query.getFromDate().getTime()));
                pstmt.setDate(paramnum++, new java.sql.Date(query.getToDate().getTime()));
            }
            
            ResultSet rs= pstmt.executeQuery();
            int currentCount=1;
            int resultCount=0;
            if(topstorycount==1)currentCount=2;
            int maxresults=Integer.valueOf(query.getResultCount()).intValue();
            int startcount=Integer.valueOf(query.getResultStart()).intValue();
            
            while(resultCount<maxresults  && rs.next()){
                if(currentCount>=startcount){
                    PCIResult pciresult=readPCIContentResult(rs);
                    pciresult.setCategoryID(query.getCategoryID());
                    pciresult.setTotalResultCount(totalResultCount);
                    arrResults.add(pciresult);
                    resultCount++;
                }
                currentCount++;
            }
        }
    return arrResults;
    }

    
    /**
     * Handles requests of type "category". 
     */
    private ArrayList getPCICategoryRequest(Connection conn, PCIQuery query) throws SQLException{
        int totalResultCount=0;
        ArrayList arrResults= new ArrayList();
        //TODO: finish
        String sql=PCI_CATEGORY_SQL;
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, query.getCategoryID());
        
        ResultSet rs= pstmt.executeQuery();
        int currentCount=0;
        int maxresults=Integer.valueOf(query.getResultCount()).intValue();
        while(currentCount<maxresults && rs.next()){
            PCIResult pciresult=readPCICategoryResult(rs);
            int totalCategoryCount=0;
            //TODO: calculate
            pciresult.setTotalResultCount(totalCategoryCount);
            arrResults.add(pciresult);
            currentCount++;
        }
        return arrResults;
    }

    
    /**
     * Handles requests of type "combo".
     */
    private ArrayList getPCIComboRequest(Connection conn, PCIQuery query) throws SQLException{
        int totalResultCount=0;
        boolean bFilterByAudience=false;
        boolean bFilterByView=false;
        
        ArrayList arrResults= new ArrayList();
        //TODO: finish
        String sql=" FROM "+ PCI_CONTENT_QUERY_TABLES+
        " WHERE " + PCI_CONTENT_QUERY_WHERE;
        if(!query.getEntityType().equals("ALL")){
            bFilterByView=true;
            sql+=PCI_CONTENT_QUERY_VIEW_PARAM;
            }
        if(!query.getAudience().equals("ALL")){
            bFilterByAudience=true;
            sql+=PCI_CONTENT_QUERY_AUD_PARAM;
            }
        if(query.getFromDate()!=null && query.getToDate()!=null){
            sql+=PCI_CONTENT_QUERY_WHERE_DATES;
        }else{
            //sql+=PCI_CONTENT_QUERY_WHERE_DATES_BEFORE_NOW;
        }
        if(query.getSortType().equals("alpha"))sql+=PCI_CONTENT_ORDER_ALPHA;
        if(query.getSortType().equals("chrono"))sql+=PCI_CONTENT_ORDER_CHRONO;
        if(query.getSortType().equals("chronouuid"))sql+=PCI_CONTENT_ORDER_CHRONO_UUID;
        if(query.getSortType().equals("rchrono"))sql+=PCI_CONTENT_ORDER_RCHRONO;
        if(query.getSortType().equals("rchronouuid"))sql+=PCI_CONTENT_ORDER_RCHRONO_UUID;
        // get total count in category
        PreparedStatement pstmtTotalCount = conn.prepareStatement("SELECT count(*)"+sql);
        //
        int paramnum=1;
        pstmtTotalCount.setString(paramnum++, query.getCategoryID());
        if(bFilterByView)pstmtTotalCount.setString(paramnum++, query.getEntityType());
        if(bFilterByAudience)pstmtTotalCount.setString(paramnum++, query.getAudience());
        ResultSet rs= pstmtTotalCount.executeQuery();
        while(rs.next()){
            totalResultCount=rs.getInt(1);
        }
        if(totalResultCount>0){
            PreparedStatement pstmt = conn.prepareStatement("SELECT " + PCI_CONTENT_QUERY_FIELDS +sql);
            //
            paramnum=1;
            pstmt.setString(paramnum++, query.getCategoryID());
            if(bFilterByView)pstmt.setString(paramnum++, query.getEntityType());
            if(bFilterByAudience)pstmt.setString(paramnum++, query.getAudience());
            if(query.getFromDate()!=null && query.getToDate()!=null){
                pstmt.setDate(paramnum++, new java.sql.Date(query.getFromDate().getTime()));
                pstmt.setDate(paramnum++, new java.sql.Date(query.getToDate().getTime()));
            }
            
            rs= pstmt.executeQuery();
            int currentCount=0;
            int maxresults=Integer.valueOf(query.getResultCount()).intValue();
            while(currentCount<maxresults && rs.next()){
                PCIResult pciresult=readPCIContentResult(rs);
                pciresult.setCategoryID(query.getCategoryID());
                pciresult.setTotalResultCount(totalResultCount);
                arrResults.add(pciresult);
                currentCount++;
                
            }
        }
    return arrResults;
    }
    
    /**
     * Handles requests of type "sf" (SiteFinder).
     * 
     *  
     */
    private ArrayList getPCISFRequest(Connection conn, PCIQuery query) throws SQLException{
        int totalResultCount=0;
        boolean bFilterByAudience=false;
        boolean bFilterByView=false;
        
        ArrayList arrResults= new ArrayList();
        String sql=" FROM "+ PCI_CONTENT_QUERY_TABLES+
        " WHERE " + PCI_CONTENT_QUERY_WHERE;
        if(!query.getEntityType().equals("ALL")){
            bFilterByView=true;
            sql+=PCI_CONTENT_QUERY_VIEW_PARAM;
            }
        if(!query.getAudience().equals("ALL")){
            bFilterByAudience=true;
            sql+=PCI_CONTENT_QUERY_AUD_PARAM;
            }
        if(query.getFromDate()!=null && query.getToDate()!=null){
            sql+=PCI_CONTENT_QUERY_WHERE_DATES;
        }else{
            //sql+=PCI_CONTENT_QUERY_WHERE_DATES_BEFORE_NOW;
        }
        if(query.getSortType().equals("alpha"))sql+=PCI_CONTENT_ORDER_ALPHA;
        if(query.getSortType().equals("chrono"))sql+=PCI_CONTENT_ORDER_CHRONO;
        if(query.getSortType().equals("chronouuid"))sql+=PCI_CONTENT_ORDER_CHRONO_UUID;
        if(query.getSortType().equals("rchrono"))sql+=PCI_CONTENT_ORDER_RCHRONO;
        if(query.getSortType().equals("rchronouuid"))sql+=PCI_CONTENT_ORDER_RCHRONO_UUID;
        // get total count in category
        PreparedStatement pstmtTotalCount = conn.prepareStatement("SELECT count(*)"+sql);
        //
        
        int paramnum=1;
        pstmtTotalCount.setString(paramnum++, query.getCategoryID());
        if(bFilterByView)pstmtTotalCount.setString(paramnum++, query.getEntityType());
        if(bFilterByAudience)pstmtTotalCount.setString(paramnum++, query.getAudience());
        ResultSet rs= pstmtTotalCount.executeQuery();
        while(rs.next()){
            totalResultCount=rs.getInt(1);
        }
        //System.out.println("sql:"+sql);
        //System.out.println("total result count:"+totalResultCount);
        if(totalResultCount>0){
            PreparedStatement pstmt = conn.prepareStatement("SELECT " + PCI_CONTENT_QUERY_FIELDS +sql);
            //
            paramnum=1;
            pstmt.setString(paramnum++, query.getCategoryID());
            if(bFilterByView)pstmt.setString(paramnum++, query.getEntityType());
            if(bFilterByAudience)pstmt.setString(paramnum++, query.getAudience());
            if(query.getFromDate()!=null && query.getToDate()!=null){
                pstmt.setDate(paramnum++, new java.sql.Date(query.getFromDate().getTime()));
                pstmt.setDate(paramnum++, new java.sql.Date(query.getToDate().getTime()));
            }
            
            rs= pstmt.executeQuery();
            int currentCount=1;
            int maxresults=Integer.valueOf(query.getResultCount()).intValue();
            int startcount=Integer.valueOf(query.getResultStart()).intValue();
            while(currentCount<=maxresults && currentCount>=startcount && rs.next()){
                PCIResult pciresult=readPCIContentResult(rs);
                pciresult.setCategoryID(query.getCategoryID());
                pciresult.setTotalResultCount(totalResultCount);
                arrResults.add(pciresult);
                currentCount++;
                
            }
        }
    return arrResults;
    }
/**
 * Main class to return PCIQuery content from the database.
 * 
 * @return XML Document object
 */

public PCIResult[] getPCIContent(PCIQuery query) {
        
        
        Connection conn = null;
        ArrayList arrResults = new ArrayList();
        //System.out.println("getPCIContent");
        try{
            if(sling!=null){
                conn =PCIDBUtil.getDBConnection(sling);
            }else{
                conn =PCIDBUtil.getDBConnection();
            }
            if(conn==null){
                System.err.println("Exception: PCIContentDBDao.getPCIContent: Couldn't get PCI connection");
                return new PCIResult[0];
            }
            conn.setAutoCommit(false);
            if(query.getViewType().equals("content"))arrResults=getPCIContentRequest(conn,query);
            if(query.getViewType().equals("category"))arrResults=getPCICategoryRequest(conn,query);
            if(query.getViewType().equals("combo"))arrResults=getPCIComboRequest(conn,query);
            if(query.getViewType().equals("sf"))arrResults=getPCIContentRequest(conn,query);//same as content
        }catch(SQLException sqle){
            System.out.println("SQLException:"+sqle.getLocalizedMessage());
        }finally{
            PCIDBUtil.returnDBConnection(conn);
        }

        Iterator iterResults=arrResults.iterator();
        PCIResult[] retResults=new PCIResult[arrResults.size()];
        int ix=0;
        while(iterResults.hasNext()){
            retResults[ix++]=(PCIResult)iterResults.next();
        }
        return retResults;
    }

    public String getPCIContentAsString(PCIQuery query) {
        return this.getPCIContentAsXMLString(query);
    }


    public Document getPCIContentAsXMLDocument(PCIQuery query) {

        //for testing
        //pciURL="http://mcdeagsun007:8004/pci/PCIServer?action=read&viewtype=content&sorting=rchrono&catid=20052&count=10&sm_user=test&mcdaudience=CorpEmployees&mcdentity=ENT";
        PCIResult[] results=getPCIContent(query);
        if(query.getViewType().equals("content"))return PCIResultsToXMLDoc.getContentXmlDocumentFromResults(results,query);
        if(query.getViewType().equals("category"))return PCIResultsToXMLDoc.getCategoryXmlDocumentFromResults(results,query);
        if(query.getViewType().equals("combo"))return PCIResultsToXMLDoc.getComboXmlDocumentFromResults(results,query);
        if(query.getViewType().equals("sf"))return PCIResultsToXMLDoc.getSFXmlDocumentFromResults(results,query);
        return null;
    }

    public String getPCIContentAsXMLString(PCIQuery query) {
        String strXML="";
        Document doc=getPCIContentAsXMLDocument(query);
        if(doc!=null)strXML=XMLUtils.convertXMLDocToString(doc);
        
        return strXML;
    }




}
 