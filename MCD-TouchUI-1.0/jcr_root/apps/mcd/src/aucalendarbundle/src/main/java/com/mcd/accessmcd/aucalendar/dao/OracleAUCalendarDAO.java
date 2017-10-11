package com.mcd.accessmcd.aucalendar.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import javax.jcr.Session;

import org.apache.sling.api.scripting.SlingScriptHelper;
import com.day.commons.datasource.poolservice.DataSourcePool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mcd.accessmcd.aucalendar.bean.*;
import com.mcd.accessmcd.aucalendar.constants.*;
import com.mcd.accessmcd.aucalendar.util.DBTool;


public class OracleAUCalendarDAO implements IAUCalendarDAO
{
    private static final Logger log = LoggerFactory.getLogger(OracleAUCalendarDAO.class);
    DBTool dbTool = null;
    SlingScriptHelper sling = null;
    Session jcrSession = null;
    DataSourcePool dbService = null;
    
    public OracleAUCalendarDAO(SlingScriptHelper sling, Session jcrSession)
    {
        this.sling = sling;
        this.jcrSession = jcrSession;
        dbTool = new DBTool(sling, jcrSession);
    }
    
    public OracleAUCalendarDAO(DataSourcePool dbService, Session jcrSession)
    {
        this.dbService = dbService;
        this.jcrSession = jcrSession;
        dbTool = new DBTool(dbService , jcrSession); 
    } 
    
    /** 
     * This method will provide the list of sites.
     * @param String userId, Page currPage and Ticket ticket
     * @return SiteList object containing a list of global sites and favorite sites.
     */ 
    public ArrayList<Category> getCategoryList () throws SQLException, Exception
    {
        ArrayList<Category> cl = new ArrayList<Category>();
      
        Connection conn = null;
        PreparedStatement pstmtGetCategoryList = null;
       
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(AUCalendarConstants.DEFAULT_DSN);
            
            pstmtGetCategoryList = conn.prepareStatement("select ID, NA from pci.PCI_CAT");
                    
            rs = pstmtGetCategoryList.executeQuery();

            while (rs.next())
            {
                Category ca = new Category();
               // log.error("id=" + rs.getString("ID"));
               // log.error("name=" + rs.getString("NA"));
                
                ca.setCategoryID(rs.getString("ID"));
                ca.setCategoryName(rs.getString("NA"));
                            
                cl.add(ca);   
            }
            
         
        }
        catch (SQLException sqle)
        {
            log.error("[OracleAUCalendarDAO.getCategoryList]:SQLException in getting category list: " + sqle);
            throw new SQLException("[OracleAUCalendarDAO.getCategoryList]:SQLException in getting category list: " + sqle);
        }        
        catch (Exception e)
        {
            log.error("[OracleAUCalendarDAO.getCategoryList]:Exception in getting category list: " + e);
            throw new Exception("[OracleCategoryDAO.getSiteList]:Exception in getting category list: " + e);
        }
        finally
        {
           // DBTool.closeStatement(pstmtGetCategoryList);
           // DBTool.closeResultSet(rs);
          //  DBTool.closeConnection(conn);
            if (pstmtGetCategoryList != null)
                pstmtGetCategoryList.close();
            if (rs != null) 
                rs.close();
            if (conn != null)
                conn.close();
        }

        
        return cl;
    }

    /** 
     * This method will get posts from table based on Content ID
     */ 
    public ArrayList<PostEntry> getPostOnCtntID(String ctntid) throws SQLException, Exception
    {
        ArrayList<PostEntry> pl = new ArrayList<PostEntry>();
      
        Connection conn = null;
        PreparedStatement pstmtGetPostList = null;
       
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(AUCalendarConstants.DEFAULT_DSN);
            
            pstmtGetPostList = conn.prepareStatement(SQLstmts.SELECT_CTNT_SQL);
                
            pstmtGetPostList.setString(1, ctntid);
                    
            rs = pstmtGetPostList.executeQuery();

            while (rs.next())
            {
System.out.println("test select posts on Cotnent id........");
                PostEntry pe = new PostEntry();

                
                pe.setContentID(rs.getString("CTNT_ID"));   
                pe.setTitle(rs.getString("TITLE"));
                pe.setDocURL(rs.getString("DOC_URI"));
                pe.setAudienceType (rs.getString("AUD_IDS"));
                pe.setUUID(rs.getString("UUID"));
                pe.setCategoryID(rs.getString("CAT_ID"));
                pe.setViewID(rs.getString("VIEW_ID"));
                pe.setActvFlag(rs.getString("ACTV_FL"));
                pe.setLaunchtype(rs.getString("LNCH_TYP"));
                pe.setPubDate(rs.getString("PUBL_DT"));
                pe.setInsDate(rs.getString("ISRT_DT"));
                pe.setModDate(rs.getString("MOD_DT"));
                pe.setInsUser(rs.getString("ISRT_USER"));
                pe.setModUser(rs.getString("MOD_USER"));
                pe.setDesc(rs.getString("DS"));
                
                            
                pl.add(pe);   
            }
            
         
        }
        catch (SQLException sqle)
        {
            log.error("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
            throw new SQLException("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
        }        
        catch (Exception e)
        {
            log.error("[OracleAUCalendarDAO.getPostList ]:Exception in getting post list: " + e);
            throw new Exception("[OracleCategoryDAO.getPostList ]:Exception in getting post list: " + e);
        }
        finally
        {
           // DBTool.closeStatement(pstmtGetPostList);
           // DBTool.closeResultSet(rs);
          //  DBTool.closeConnection(conn);
            if (pstmtGetPostList!= null)
                pstmtGetPostList.close();
            if (rs != null) 
                rs.close();
            if (conn != null)
                conn.close();
        }
        
        return pl;
    }

    /** 
     * This method will get posts from table based on UUID
     */ 
    public ArrayList<PostEntry> getPostOnUUID(String uuid) throws SQLException, Exception
    {
        ArrayList<PostEntry> pl = new ArrayList<PostEntry>();
      
        Connection conn = null;
        PreparedStatement pstmtGetPostList = null;
       
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(AUCalendarConstants.DEFAULT_DSN);
            
            pstmtGetPostList = conn.prepareStatement(SQLstmts.SELECT_UUID_SQL);
                
            pstmtGetPostList.setString(1, uuid);
                    
            rs = pstmtGetPostList.executeQuery();

            while (rs.next())
            {
System.out.println("test select posts on UUid........");
                PostEntry pe = new PostEntry();

                
                pe.setContentID(rs.getString("CTNT_ID"));   
                pe.setTitle(rs.getString("TITLE"));
                pe.setDocURL(rs.getString("DOC_URI"));
                pe.setUUID(rs.getString("UUID"));
                pe.setAudienceType (rs.getString("AUD_IDS"));
                pe.setCategoryID(rs.getString("CAT_ID"));
                pe.setViewID(rs.getString("VIEW_ID"));
                pe.setActvFlag(rs.getString("ACTV_FL"));
                pe.setLaunchtype(rs.getString("LNCH_TYP"));
                pe.setPubDate(rs.getString("PUBL_DT"));
                pe.setInsDate(rs.getString("ISRT_DT"));
                pe.setModDate(rs.getString("MOD_DT"));
                pe.setInsUser(rs.getString("ISRT_USER"));
                pe.setModUser(rs.getString("MOD_USER"));
                pe.setDesc(rs.getString("DS"));
                
                            
                pl.add(pe);   
            }
            
         
        }
        catch (SQLException sqle)
        {
            log.error("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
            throw new SQLException("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
        }        
        catch (Exception e)
        {
            log.error("[OracleAUCalendarDAO.getPostList ]:Exception in getting post list: " + e);
            throw new Exception("[OracleCategoryDAO.getPostList ]:Exception in getting post list: " + e);
        }
        finally
        {
           // DBTool.closeStatement(pstmtGetPostList);
           // DBTool.closeResultSet(rs);
          //  DBTool.closeConnection(conn);
            if (pstmtGetPostList!= null)
                pstmtGetPostList.close();
            if (rs != null) 
                rs.close();
            if (conn != null)
                conn.close();
        }
        
        return pl;
    }

    /** 
     * This method will get posts from table 
     */ 
    public ArrayList<PostEntry> getPostList(String catid) throws SQLException, Exception
    {
        ArrayList<PostEntry> pl = new ArrayList<PostEntry>();
      
        Connection conn = null;
        PreparedStatement pstmtGetPostList = null;
       
        ResultSet rs = null;

        try
        {
            conn = dbTool.createConnection(AUCalendarConstants.DEFAULT_DSN);
            
            pstmtGetPostList = conn.prepareStatement(SQLstmts.SELECT_POST_SQL);
                
            pstmtGetPostList.setString(1, catid);
                    
            rs = pstmtGetPostList.executeQuery();

            while (rs.next())
            {
System.out.println("test........");
                PostEntry pe = new PostEntry();

                
                pe.setContentID(rs.getString("CTNT_ID"));   
                pe.setTitle(rs.getString("TITLE"));
                pe.setDocURL(rs.getString("DOC_URI"));
                pe.setAudienceType (rs.getString("AUD_IDS"));
                pe.setUUID(rs.getString("UUID"));
                pe.setCategoryID(rs.getString("CAT_ID"));
                pe.setViewID(rs.getString("VIEW_ID"));
                pe.setActvFlag(rs.getString("ACTV_FL"));
                pe.setLaunchtype(rs.getString("LNCH_TYP"));
                pe.setPubDate(rs.getString("PUBL_DT"));
                pe.setInsDate(rs.getString("ISRT_DT"));
                pe.setModDate(rs.getString("MOD_DT"));
                pe.setInsUser(rs.getString("ISRT_USER"));
                pe.setModUser(rs.getString("MOD_USER"));
                pe.setDesc(rs.getString("DS"));
                
                            
                pl.add(pe);   
            }
            
         
        }
        catch (SQLException sqle)
        {
            log.error("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
            throw new SQLException("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
        }        
        catch (Exception e)
        {
            log.error("[OracleAUCalendarDAO.getPostList ]:Exception in getting post list: " + e);
            throw new Exception("[OracleCategoryDAO.getPostList ]:Exception in getting post list: " + e);
        }
        finally
        {
           // DBTool.closeStatement(pstmtGetPostList);
           // DBTool.closeResultSet(rs);
          //  DBTool.closeConnection(conn);
            if (pstmtGetPostList!= null)
                pstmtGetPostList.close();
            if (rs != null) 
                rs.close();
            if (conn != null)
                conn.close();
        }
        
        return pl;
    }

    /** 
     * This method will make the post in DB inactive, we're not deleting them though
     */ 
    public boolean deletePost(String id) throws SQLException, Exception
    {
        boolean isUpdated = false;
        Connection conn = null;
        PreparedStatement pstmtDeletePost = null;
           
        try
        {
            conn = dbTool.createConnection(AUCalendarConstants.DEFAULT_DSN);
            conn.setAutoCommit(false);
            
            pstmtDeletePost = conn.prepareStatement(SQLstmts.DELETE_POST_SQL);
                
            pstmtDeletePost.setString(1, id);
                    
            pstmtDeletePost.executeQuery();
            conn.commit();
            isUpdated = true;
         
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            log.error("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
            throw new SQLException("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
        }        
        catch (Exception e)
        {
            log.error("[OracleAUCalendarDAO.getPostList ]:Exception in getting post list: " + e);
            throw new Exception("[OracleCategoryDAO.getPostList ]:Exception in getting post list: " + e);
        }
        finally
        {
           // DBTool.closeStatement(pstmtGetPostList);
           // DBTool.closeResultSet(rs);
          //  DBTool.closeConnection(conn);
            if (pstmtDeletePost!= null)
                pstmtDeletePost.close();
            if (conn != null)
                conn.close();
        }
        return isUpdated;
        
    }        

    /** 
     * This method will make the post in DB inactive, we're not deleting them though
     */ 
    public boolean deletePostByUUID(String uuid) throws SQLException, Exception
    {
        boolean isUpdated = false;
        Connection conn = null;
        PreparedStatement pstmtSel = null;
        PreparedStatement pstmtDeletePost = null;
        ResultSet rs1=null;   
           
        try
        {
            conn = dbTool.createConnection(AUCalendarConstants.DEFAULT_DSN);
            conn.setAutoCommit(false);
            
            pstmtSel = conn.prepareStatement(SQLstmts.GET_CTNTID_SQL);
                
            pstmtSel.setString(1, uuid);
                    
            rs1 = pstmtSel.executeQuery();

            while (rs1.next())
            {
                String ctntid= rs1.getString(1); 
                
                pstmtDeletePost = conn.prepareStatement(SQLstmts.DELETE_POST_SQL);
                
                pstmtDeletePost.setString(1, ctntid);
                    
                pstmtDeletePost.executeQuery();
  
            }

            conn.commit();
            isUpdated = true;
         
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            log.error("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
            throw new SQLException("[OracleAUCalendarDAO.getPostList ]:SQLException in getting post list: " + sqle);
        }        
        catch (Exception e)
        {
            conn.rollback();
            log.error("[OracleAUCalendarDAO.getPostList ]:Exception in getting post list: " + e);
            throw new Exception("[OracleCategoryDAO.getPostList ]:Exception in getting post list: " + e);
        }
        finally
        {
           // DBTool.closeStatement(pstmtGetPostList);
           // DBTool.closeResultSet(rs);
          //  DBTool.closeConnection(conn);
            if (pstmtSel!= null)
                pstmtSel.close();
            if (pstmtDeletePost!= null)
                pstmtDeletePost.close();
            if (rs1!= null)
                rs1.close();
            if (conn != null)
                conn.close();
        }
        return isUpdated;
        
    }        
    
    public boolean updatePost(PostEntry pe) throws SQLException, Exception
    {
        boolean isUpdated = false;
        Connection conn = null;
        PreparedStatement pstmtUpdatePost = null;
        PreparedStatement pstmtDel= null;
        String ctnt_id="";
        String dtl_id="";
        ResultSet rsSequence = null;
          
          
        try
        {
            conn = dbTool.createConnection(AUCalendarConstants.DEFAULT_DSN);
            conn.setAutoCommit(false);

            ctnt_id= pe.getContentID();
            
//update CTNT table first
            pstmtUpdatePost = conn.prepareStatement(SQLstmts.UPDATE_CTNT_SQL);
                
            pstmtUpdatePost.setString(1, pe.getDocURL());
            //getInsUser or getModUser
            pstmtUpdatePost.setString(2, pe.getModUser());
//            pstmtUpdatePost.setString(2, "tester");
            pstmtUpdatePost.setString(3, pe.getAudienceType());
            pstmtUpdatePost.setString(4, ctnt_id);

            System.out.println("pstmt update ctnt 1:" + pe.getDocURL());
            System.out.println("pstmt update ctnt 2:" + pe.getModUser());
            System.out.println("pstmt update ctnt 3:" + pe.getAudienceType());
            System.out.println("pstmt update ctnt 4:" + ctnt_id);

            pstmtUpdatePost.executeQuery();
            System.out.println("pstmt update ctnt=" + pstmtUpdatePost.toString());
            
            conn.commit();


//delete old conent dtl
            pstmtDel= conn.prepareStatement(SQLstmts.DELETE_CTNT_DTL_SQL);
            pstmtDel.setString(1, ctnt_id);
            
            rsSequence = pstmtDel.executeQuery();
            conn.commit();
            

            System.out.println("pstmt del ctnt dtl" );

//add the new content dtl          
            String views= pe.getViewID();
            String[] vw = views.split("\\,");


            for (int i=0;i<vw.length;i++){
 
                //insert into PCI_CTNT_DTL
                 pstmtUpdatePost = conn.prepareStatement(SQLstmts.INSERT_CTNT_DTL_SQL);
                
                pstmtUpdatePost.setString(1, ctnt_id);
                pstmtUpdatePost.setString(2, pe.getCategoryID());
//                pstmtUpdatePost.setString(3, pe.getViewID());
                pstmtUpdatePost.setString(3, vw[i]);
                pstmtUpdatePost.setString(4, pe.getTitle());
                pstmtUpdatePost.setString(5, pe.getDesc());
                pstmtUpdatePost.setString(6, pe.getLaunchtype());
                pstmtUpdatePost.setString(7, pe.getActvFlag());
                pstmtUpdatePost.setString(8, pe.getPubDate());


            System.out.println("pstmt update dtl 1:" + ctnt_id);
            System.out.println("pstmt update dtl 2:" + pe.getCategoryID());
            
            System.out.println("pstmt update dtl 3:" + pe.getViewID());
            System.out.println("pstmt update dtl 4:" + pe.getTitle());
            System.out.println("pstmt update dtl 5:just testing");
            System.out.println("pstmt update dtl 6:" + pe.getLaunchtype());
            System.out.println("pstmt update dtl 7:" + pe.getActvFlag());
            System.out.println("pstmt update dtl 8:" + pe.getPubDate());



                System.out.println("pstmt update dtl=" + pstmtUpdatePost.toString());        
                pstmtUpdatePost.executeQuery();
                
            
                conn.commit();
            }


//delete old conent AU
            pstmtDel= conn.prepareStatement(SQLstmts.DELETE_CTNT_AUD_SQL);
            pstmtDel.setString(1, ctnt_id);
            
            rsSequence = pstmtDel.executeQuery();
            conn.commit();
                System.out.println("pstmt del aud");        

//add the new content AU          
 
                 pstmtUpdatePost= conn.prepareStatement(SQLstmts.INSERT_CTNT_AUD_SQL);
                 
                 pstmtUpdatePost.setString(1, ctnt_id);
                 pstmtUpdatePost.setString(2, pe.getAudienceType());
                 //log.error("***** Insert Post Query 2 ***** "+pstmtUpdatePost);    
                 pstmtUpdatePost.executeQuery();
                 System.out.println("pstmt insert aud=" + pstmtUpdatePost.toString());
                 conn.commit();
           
            conn.commit();
            isUpdated = true;
         
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            log.error("[OracleAUCalendarDAO.updatePostEntry ]:SQLException in updating post entry: " + sqle);
            throw new SQLException("[OracleAUCalendarDAO.updatePostEntry ]:SQLException in updating post entry: " + sqle);
        }        
        catch (Exception e)
        {
            conn.rollback();
            log.error("[OracleAUCalendarDAO.updatePostEntry ]:Exception in updating post entry: " + e);
            throw new Exception("[OracleCategoryDAO.updatePostEntry ]:Exception in updating post entry: " + e);
        }
        finally
        {
           // DBTool.closeStatement(pstmtGetPostList);
           // DBTool.closeResultSet(rs);
          //  DBTool.closeConnection(conn);
            if (rsSequence != null)
                rsSequence.close();
            if (pstmtDel!= null)
                pstmtDel.close();
            if (pstmtUpdatePost!= null)
                pstmtUpdatePost.close();
            if (conn != null)
                conn.close();
        }
        return isUpdated;
        
    }        
    

    
    public boolean insertPost(PostEntry pe) throws SQLException, Exception
    {
        boolean isUpdated = false;
        Connection conn = null;
        PreparedStatement pstmtInsertPost = null;
        PreparedStatement pstmtSequence= null;
        String ctnt_id="";
        ResultSet rsSequence = null;
          
          
        try
        {
            conn = dbTool.createConnection(AUCalendarConstants.DEFAULT_DSN);
            conn.setAutoCommit(false);

            

            pstmtInsertPost = conn.prepareStatement(SQLstmts.INSERT_CTNT_SQL);
            //log.info("**** SQLstmts.INSERT_CTNT_SQL ****" + SQLstmts.INSERT_CTNT_SQL);    
            pstmtInsertPost.setString(1, pe.getDocURL());
            pstmtInsertPost.setString(2, pe.getInsUser());
            pstmtInsertPost.setString(3, pe.getAudienceType());
            pstmtInsertPost.setString(4, pe.getUUID());


            //log.error("***** pstmt insert ctnt 0 *****" + pstmtInsertPost);        
            pstmtInsertPost.executeQuery();
            System.out.println("pstmt insert ctnt=" + pstmtInsertPost.toString());
            
//            conn.commit();

            String seqsql = SQLstmts.GET_CTNT_SEQUENCE_SQL;
            pstmtSequence = conn.prepareStatement(seqsql);
            //log.info("****** seqsql *****" + seqsql); 
            rsSequence = pstmtSequence.executeQuery();
        
            if (rsSequence.next())
            {
                  ctnt_id= rsSequence.getString(1);
            }
            System.out.println("[insert Post entry]Content ID is.."+ctnt_id);

           
            String views= pe.getViewID();
            String[] vw = views.split("\\,");


            for (int i=0;i<vw.length;i++){
 
                //insert into PCI_CTNT_DTL
                 pstmtInsertPost = conn.prepareStatement(SQLstmts.INSERT_CTNT_DTL_SQL);
                 
                  
                pstmtInsertPost.setString(1, ctnt_id);
                pstmtInsertPost.setString(2, pe.getCategoryID());
//              pstmtInsertPost.setString(3, pe.getViewID());
                pstmtInsertPost.setString(3, vw[i]);
                pstmtInsertPost.setString(4, pe.getTitle());
                pstmtInsertPost.setString(5, pe.getDesc());
                pstmtInsertPost.setString(6, pe.getLaunchtype());
                pstmtInsertPost.setString(7, pe.getActvFlag());
                pstmtInsertPost.setString(8, pe.getPubDate());
                System.out.println("pstmt insert dtl=" + pstmtInsertPost.toString());
                pstmtInsertPost.executeQuery();
            }
            

            //insert into PCI_CTNT_AUD
                 pstmtInsertPost = conn.prepareStatement(SQLstmts.INSERT_CTNT_AUD_SQL);
                 pstmtInsertPost.setString(1, ctnt_id);
                 pstmtInsertPost.setString(2, pe.getAudienceType());
                 pstmtInsertPost.executeQuery();
                 System.out.println("pstmt insert aud=" + pstmtInsertPost.toString());
              
            conn.commit();
            isUpdated = true;
         
        }
        catch (SQLException sqle)
        {
            conn.rollback();
            log.error("[OracleAUCalendarDAO.insertPostEntry ]:SQLException in inserting post entry: " + sqle);
            throw new SQLException("[OracleAUCalendarDAO.insertPostEntry ]:SQLException in inserting post entry: " + sqle);
        }        
        catch (Exception e)
        {
            conn.rollback();
            log.error("[OracleAUCalendarDAO.insertPostEntry ]:Exception in inserting post entry: " + e);
            throw new Exception("[OracleCategoryDAO.insertPostEntry ]:Exception in inserting post entry: " + e);
        }
        finally
        {
           // DBTool.closeStatement(pstmtGetPostList);
           // DBTool.closeResultSet(rs);
          //  DBTool.closeConnection(conn);
            if (rsSequence != null)
                rsSequence.close();
            if (pstmtSequence != null)
                pstmtSequence.close();
            if (pstmtInsertPost!= null)
                pstmtInsertPost.close();
            if (conn != null)
                conn.close();
        }
        return isUpdated;
        
    }        
    

 }  
    
       
       