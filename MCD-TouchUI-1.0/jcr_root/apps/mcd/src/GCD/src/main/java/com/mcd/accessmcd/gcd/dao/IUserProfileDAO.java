/* 
 * IUserProfileDAO.java                                                                                         
 * Developed by HCL Technologies.                                                       
 * Author      :- Sandeep Jain                                                  
 * Date        :- December 09, 2008                                                     
 * Description :-  this interface is used for delegating requests to actual implementation.
 *
 */

package com.mcd.accessmcd.gcd.dao;



import java.sql.SQLException;
import java.util.ArrayList;
import com.mcd.accessmcd.gcd.bean.BasicSearch;
import com.mcd.accessmcd.gcd.bean.AdvancedSearch;
import org.apache.sling.api.scripting.SlingScriptHelper;

/*************************************************************************

 * This is an interface for delegating requests to actual implementation. 
 * @version 1.0 &nbsp; November 13, 2008
 * @author : Sandeep jain 
 *
 *************************************************************************/

public interface IUserProfileDAO
{
    public ArrayList getSearchResult(BasicSearch basicSearch,SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList getSearchResult(AdvancedSearch advancedSearch,SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList selectProfileByEid(String EID,SlingScriptHelper sling)throws SQLException, Exception; 
    
    public ArrayList selectOwnerOperatorProfile(String ownerOperatorId,SlingScriptHelper sling)throws SQLException, Exception;
}