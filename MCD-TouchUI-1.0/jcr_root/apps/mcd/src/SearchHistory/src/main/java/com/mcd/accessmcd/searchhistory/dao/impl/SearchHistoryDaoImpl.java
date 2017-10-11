package com.mcd.accessmcd.searchhistory.dao.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.api.scripting.SlingScriptHelper;

import java.lang.StringBuilder;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;

import com.mcd.accessmcd.searchhistory.util.DBUtil;
import com.mcd.accessmcd.searchhistory.bean.HistoryItem;
import com.mcd.accessmcd.searchhistory.dao.SearchHistoryDao;

public class SearchHistoryDaoImpl implements SearchHistoryDao {

    private static final Logger log = LoggerFactory.getLogger(SearchHistoryDaoImpl.class);

    public List<HistoryItem> getHistoryItems(String userId, Date fromDate, 
            String displayOrder, SlingScriptHelper sling) throws Exception {
        List<HistoryItem> historyItemList = null;
        Connection conn = null;
        try {
            //Getting Connection from DBUtil using Sling
            conn = DBUtil.getConnection(sling);
            //Query
            StringBuilder query = new StringBuilder("SELECT SRCH_LOG_QT_TX, SRCH_LOG_LANG_CD, SRCH_LOG_MKT_CD, SRCH_LOG_TS FROM TBSRCH_LOG");
            query.append(" WHERE SRCH_LOG_USR_ID = ? AND SRCH_LOG_TS > ?");
            query.append(" ORDER BY SRCH_LOG_TS ").append(displayOrder);
            //Generating prepared statement and passing parameters to it
            PreparedStatement psSearchHistory = conn.prepareStatement(query.toString());
            psSearchHistory.setString(1, userId);
            psSearchHistory.setDate(2, new java.sql.Date(fromDate.getTime()));
            //Fetching results from database
            ResultSet result = psSearchHistory.executeQuery();
            historyItemList = new ArrayList<HistoryItem>();
            while(result.next()) {
                //Adding History Items to List
                historyItemList.add(new HistoryItem(result.getString(1), result.getString(2), 
                        result.getString(3), result.getDate(4)));
            }
        } catch (SQLException sqle) {
            log.error("[SearchHistoryDAO] SQLError while fetching search history for user " + userId, sqle);
            throw new SQLException("[SearchHistoryDAO] SQLError while fetching search history for user " + userId, sqle);
        } catch(Exception ex) {
            log.error("[SearchHistoryDAO] Error while fetching search history for user " + userId, ex);
            throw new Exception("[SearchHistoryDAO] Error while fetching search history for user " + userId, ex);
        } finally {
            DBUtil.closeConnection(conn);
        }
        return historyItemList;
    }

}