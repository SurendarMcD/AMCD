package com.mcd.accessmcd;          

import java.sql.Connection;
import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.PreparedStatement;
import org.apache.sling.api.scripting.SlingScriptHelper;
import com.day.commons.datasource.poolservice.DataSourcePool;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.ArrayList;
import java.util.Date;
import com.day.cq.security.User;


public class adminConsoleData{

private static final Logger log = LoggerFactory.getLogger(adminConsoleData.class);

   public static String CQDATASOURCENAME="stylebookdb";
    public static String DATASOURCE="CQ5";
    public static String ORACLEDRIVERTYPE="thin";
    public static String ORACLESERVERNAME="10.122.70.141";
    public static int ORACLESERVERPORT=1521;
    public static String ORACLEDBNAME="ORCL";
    public static String ORACLEUSER="Stylebook";
    public static String ORACLEPASSWORD="ygYGY7Ty";
    
    /*
    public static String CQDATASOURCENAME="devpci";
    public static String DATASOURCE="CQ5";
    public static String ORACLEDRIVERTYPE="thin";
    public static String ORACLESERVERNAME="mcdeagsun104a";
    public static int ORACLESERVERPORT=1528;
    public static String ORACLEDBNAME="dshr03";
    public static String ORACLEUSER="pci";
    public static String ORACLEPASSWORD="b1gm4c1d";
    */
    

    public static Connection getDBConnection(SlingScriptHelper sling1){
        Connection retConnection=null;
            try
            {
              DataSourcePool dbService = (DataSourcePool)sling1.getService(DataSourcePool.class);              
              DataSource dataSource = (DataSource)dbService.getDataSource(CQDATASOURCENAME);              
              retConnection = dataSource.getConnection();              
            }
            catch (Exception e)
            {
              e.printStackTrace();
            }
            return retConnection; 
    
    }
    
    public ArrayList getStyleBookData(SlingScriptHelper sling)
    {        
        log.error("*****************ConnectionINSIDE METHOD********************");   
        Connection con=null;
        ArrayList<StylebookData> styleBook= new ArrayList();
     
    try { 
      if(sling!=null){
               
        con =getDBConnection(sling);  
        log.error("*****************Connection********************"+con);      

      Statement select = con.createStatement();
      ResultSet resultSet = select.executeQuery("select * from GLOSSARY where STATUS='C' OR STATUS='U'");         
 
      while(resultSet.next()) {
        StylebookData stylebookData= new StylebookData();
        stylebookData.setId(resultSet.getInt("ID"));
        stylebookData.setKey(resultSet.getString("KEY"));
        stylebookData.setDescription(resultSet.getString("DESCRIPTION"));
        if(resultSet.getString("RELATED_ITEMS")!=null){
            stylebookData.setRelatedItems(resultSet.getString("RELATED_ITEMS"));
        }
        else{
            stylebookData.setRelatedItems("");
        }
        stylebookData.setStatus(resultSet.getString("STATUS"));
        stylebookData.setCreatedDate(resultSet.getDate("CREATED_DATE"));
        stylebookData.setUpdatedDate(resultSet.getDate("UPDATED_DATE")); 
        stylebookData.setUpdatedUser(resultSet.getString("UPDATED_USER"));   
        styleBook.add(stylebookData); 
        }
     
      resultSet.close();
      con.close();
     }
    }
    catch( Exception e ) {
      e.printStackTrace();
    } 
    return styleBook;
    
  }   
  
  public int insertStyleBookData(SlingScriptHelper sling,StylebookData styleBookData,User user)
  {

        String key=styleBookData.getKey(); 
        String description=styleBookData.getDescription();       
        String [] relatedItems=(styleBookData.getRelatedItems()).split(","); 
        String relatedId="";
        
        for(int i=0;i<relatedItems.length;i++){
            if(i==relatedItems.length - 1){
                relatedId=relatedId+getID(sling,relatedItems[i]);
            }
            else{
                 relatedId=relatedId+getID(sling,relatedItems[i])+",";
            } 
        } 

        String updatedUser=user.getName();       
        String insertQueryString="Insert into GLOSSARY (ID,KEY,DESCRIPTION,RELATED_ITEMS,STATUS,CREATED_DATE,UPDATED_DATE,UPDATED_USER) values (id_sequence.nextval,?,?,?,?,?,?,?)";
        int insertedRows=0;

        Connection con=null;
         try { 
              if(sling!=null){
               
                            con =getDBConnection(sling);                              
                            con.setAutoCommit(false);   
                 
            PreparedStatement insertStatement= con.prepareStatement(insertQueryString);

            insertStatement.setString(1,key);
            insertStatement.setString(2,description);
            insertStatement.setString(3,relatedId);
            insertStatement.setString(4,"C");
            insertStatement.setDate(5,new java.sql.Date(System.currentTimeMillis()));
            insertStatement.setDate(6,new java.sql.Date(System.currentTimeMillis()));
            insertStatement.setString(7,updatedUser);
            
            insertedRows=insertStatement.executeUpdate();
            
            con.commit();
            con.close();
            }
        }catch(Exception e){
         e.printStackTrace();
        }
        
        return insertedRows;

   } 
   
   public int updateStyleBookData(SlingScriptHelper sling,StylebookData styleBookData,User user)
   {
        int id=0;
        id=styleBookData.getId();
        String key="";
        key=styleBookData.getKey();
        String description="";
        description=styleBookData.getDescription();   
        String [] relatedItems=(styleBookData.getRelatedItems()).split(",");
        String updatedUser="";
        updatedUser=user.getName(); 
        int updatedRows=0;
        String relatedId=""; 
        
        for(int i=0;i<relatedItems.length;i++){
            if(i==relatedItems.length - 1){
                relatedId=relatedId+getID(sling,relatedItems[i]);
            }
            else{
                relatedId=relatedId+getID(sling,relatedItems[i])+",";
            }
        }
        String updateQueryString="UPDATE GLOSSARY SET KEY=?,DESCRIPTION=?,RELATED_ITEMS=?,STATUS=?,UPDATED_DATE=?,UPDATED_USER=? WHERE ID=?";
        log.error("&****************query string "+updateQueryString);
        Connection con=null;
        
         try { 
              if(sling!=null){
               
                            con =getDBConnection(sling);                              
                            con.setAutoCommit(false);   
           
log.error("*************update new quer22222221y ");
            PreparedStatement updateStatement= con.prepareStatement(updateQueryString);
            updateStatement.setString(1,key);
            updateStatement.setString(2,description);
            updateStatement.setString(3,relatedId);
            updateStatement.setString(4,"U");
            updateStatement.setDate(5,new java.sql.Date(System.currentTimeMillis()));
            updateStatement.setString(5,updatedUser);
            updateStatement.setInt(6,id);
            updatedRows=updateStatement.executeUpdate();log.error("*************update new quer11111111111y ");
            log.error("*************update new query ");
            con.commit();
            con.close();
            }
        }catch(Exception e){
         e.printStackTrace();
        }
      return updatedRows;
   }
   
   public int deleteStyleBookData(SlingScriptHelper sling,StylebookData styleBookData,User user)
   {
           int id=0;
           id=styleBookData.getId();
           String updatedUser=user.getName();
           int deletedRows=0;
           
           String updateQueryString="UPDATE GLOSSARY SET STATUS=?,UPDATED_DATE=?,UPDATED_USER=? WHERE ID=?";
           Connection con=null;
        
         try { 
              if(sling!=null){
               
                            con =getDBConnection(sling);                              
                            con.setAutoCommit(false);   
                 
            PreparedStatement updateStatement= con.prepareStatement(updateQueryString);

            updateStatement.setString(1,"D");
            updateStatement.setDate(2,new java.sql.Date(System.currentTimeMillis()));
            updateStatement.setString(3,updatedUser);
            updateStatement.setInt(4,id);

            deletedRows=updateStatement.executeUpdate();
            
            con.commit();
            con.close();
            }
        }catch(Exception e){
         e.printStackTrace();
        }
     
        return deletedRows;     
   }
   
   public StylebookData getStyleBookDataForId(SlingScriptHelper sling,StylebookData styleBookData)
    {        
        
        Connection con=null;
        int id=0;
        id=styleBookData.getId();
        ArrayList<StylebookData> styleBook= new ArrayList();
        String queryString="";

        try { 
        if(sling!=null){
               
               con =getDBConnection(sling);        
        
        queryString="select KEY,DESCRIPTION, RELATED_ITEMS from GLOSSARY where (STATUS='C' OR STATUS='U')and ID=?";
        PreparedStatement selectStatement= con.prepareStatement(queryString);
        selectStatement.setInt(1,id);
        
        ResultSet resultSet = selectStatement.executeQuery();         

      while(resultSet.next()) {

        styleBookData.setKey(resultSet.getString("KEY"));
        styleBookData.setDescription(resultSet.getString("DESCRIPTION"));
        String relatedItemsString="";        
        String relatedKey="";
        if(resultSet.getString("RELATED_ITEMS")!=null){
            relatedItemsString=resultSet.getString("RELATED_ITEMS");
        }
        else{
            relatedItemsString="";
        }
        if(!(relatedItemsString.equals(""))){
            String [] relatedItems=relatedItemsString.split(",");
            for(int i=0;i<relatedItems.length;i++){
                int passedId=(int)Integer.parseInt(relatedItems[i]);
                String keyValue=getKey(sling,passedId);
                if(i==relatedItems.length - 1){                    
                    if(keyValue.equals("")){                    
                        int index=relatedKey.lastIndexOf(",");
                        if(index!=-1){
                            relatedKey=relatedKey.substring(0,index);
                        }
                    }
                    else{
                        relatedKey=relatedKey+keyValue;
                    }
                    
                }
                else{
                    if(!(keyValue.equals(""))){
                        relatedKey=relatedKey+keyValue+",";
                    }                    
                }
            }
        }
        styleBookData.setRelatedItems(relatedKey); 
      }
      resultSet.close();
      con.close();
     }
   }
    catch( Exception e ) {
      e.printStackTrace();
    } 
    return styleBookData;
    
  }   

  public String getKey(SlingScriptHelper sling,int Id)
  {
  
      String key="";
      String selectQuery="select KEY from GLOSSARY where ID=? and (STATUS='U' OR STATUS='C')";
      Connection con=null;
      try{
          if(sling!=null)
          {
              con=getDBConnection(sling);
              PreparedStatement selectStatement=con.prepareStatement(selectQuery); 
              selectStatement.setInt(1,Id);
              ResultSet resultSet=selectStatement.executeQuery();
              while(resultSet.next()){
              
              key=resultSet.getString("KEY");
              
              }
          resultSet.close();
          con.close();
          }
      }catch(Exception e)
      {
          e.getMessage();
      }
      
  return key;
  
  }
  
  public String getID(SlingScriptHelper sling,String key)
  { 
      String id="";
      String selectQuery="select ID from GLOSSARY where KEY=?";
      Connection con=null;
      try{
            if(sling!=null)
            {
                 con=getDBConnection(sling);
                 PreparedStatement selectStatement=con.prepareStatement(selectQuery); 
                 selectStatement.setString(1,key); 
                 ResultSet resultSet=selectStatement.executeQuery(); 
                 while(resultSet.next()){        
                          
                        id=(String)Integer.toString(resultSet.getInt("ID"));              
                 }
                 resultSet.close();
                 con.close();   
            }
      }catch(Exception e)
      {
          e.getMessage();
      }
      return id;
  }
  
  public ArrayList getAllExistingKeys(SlingScriptHelper sling){
      Connection con=null;
      ArrayList<String> styleBookKeys= new ArrayList<String>();    
       
      try { 
          if(sling!=null){               
              con =getDBConnection(sling);             
              Statement select = con.createStatement();
              ResultSet resultSet = select.executeQuery("select KEY from GLOSSARY where STATUS='C' OR STATUS='U'");
              while(resultSet.next()) {
                  //StylebookData stylebookData= new StylebookData();
                  //stylebookData.setKey(resultSet.getString("KEY"));
                  styleBookKeys.add(resultSet.getString("KEY")); 
              }
          resultSet.close();
          con.close();
          }
      }
      catch( Exception e ) {
          e.printStackTrace();
      }
  return styleBookKeys;
  }
  
  public ArrayList getAllKeys(SlingScriptHelper sling){
      Connection con=null;
      ArrayList<String> styleBookKeys= new ArrayList<String>();    
       
      try { 
          if(sling!=null){               
              con =getDBConnection(sling);             
              Statement select = con.createStatement();
              ResultSet resultSet = select.executeQuery("select KEY from GLOSSARY");
              while(resultSet.next()) {
                  //StylebookData stylebookData= new StylebookData();
                  //stylebookData.setKey(resultSet.getString("KEY"));
                  styleBookKeys.add(resultSet.getString("KEY")); 
              }
          resultSet.close();
          con.close();
          }
      }
      catch( Exception e ) {
          e.printStackTrace();
      }
  return styleBookKeys;
  }
  
}
        