/* 
 * ICountryDAO.java                                                                                         
 * Developed by HCL Technologies.                                                       
 * Author      :- Mansi                                                  
 * Date        :- December 22, 2011                                                     
 * Description :-  this interface is used for delegating requests to actual implementation.
 *
 */

package com.mcd.accessmcd.gcd.dao;


import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.sling.api.scripting.SlingScriptHelper;
import com.mcd.accessmcd.gcd.bean.CountryDetails;

/*************************************************************************

 * This is an interface for delegating requests to actual implementation. 
 * @version 1.0 &nbsp; December 22, 2011
 * @author : Mansi 
 *
 *************************************************************************/

public interface ICountryDAO
{
    public ArrayList<String> getCountries(SlingScriptHelper sling) throws SQLException,Exception;
    
    public int updateCountriesStatus(ArrayList<CountryDetails> updateList,String eid,SlingScriptHelper sling)throws SQLException,Exception;
    
    public int updateCountriesFlag(SlingScriptHelper sling) throws SQLException,Exception;
}  