package com.mcd.accessmcd.pci.util;

import java.sql.Connection;
 
import javax.sql.DataSource;


import org.apache.sling.api.scripting.SlingScriptHelper;
import com.day.commons.datasource.poolservice.DataSourcePool;

//import oracle.jdbc.pool.OracleConnectionPoolDataSource;
//import oracle.jdbc.pool.OraclePooledConnection;

//import com.day.cq.util.DBUtil;

public class PCIDBUtil {
    public static Connection getDBConnection(){
        Connection retConnection=null;
        String dataSource=PCIProperties.PCI_DATASOURCE;
        //System.out.println("datasource:"+dataSource);
        try{
            if(dataSource.equals("CQ")){
                // String PCI_DATASOURCENAME=PCIProperties.PCI_CQDATASOURCENAME;
//              retConnection=DBUtil.getConnection(PCI_DATASOURCENAME);
            }
            if(dataSource.equals("CQ5")){
                //separate method
            }
            if(dataSource.equals("Oracle")){
/*
                OracleConnectionPoolDataSource ocpds_pci = new OracleConnectionPoolDataSource();               
                ocpds_pci.setDriverType(PCIProperties.PCI_ORACLEDRIVERTYPE);
                ocpds_pci.setServerName(PCIProperties.PCI_ORACLESERVERNAME); //hostname
                ocpds_pci.setPortNumber(PCIProperties.PCI_ORACLESERVERPORT);
                ocpds_pci.setDatabaseName(PCIProperties.PCI_ORACLEDBNAME); // sid
                ocpds_pci.setUser(PCIProperties.PCI_ORACLEUSER);
                ocpds_pci.setPassword(PCIProperties.PCI_ORACLEPASSWORD);         
                retConnection=ocpds_pci.getPooledConnection().getConnection();
*/
            }
        }catch(Exception sqe){
            System.out.println("SQLException:"+sqe.getLocalizedMessage());
        }
        return retConnection;
    }
    
    public static Connection getDBConnection(SlingScriptHelper sling1){
        Connection retConnection=null;
            try
            {
              String PCI_DATASOURCENAME=PCIProperties.PCI_CQDATASOURCENAME;
              //hard-coded for CQ5
              //String PCI_DATASOURCENAME="stgpci";
              DataSourcePool dbService = (DataSourcePool)sling1.getService(DataSourcePool.class);
              DataSource dataSource = (DataSource)dbService.getDataSource(PCI_DATASOURCENAME);
              retConnection = dataSource.getConnection();
            }
            catch (Exception e)
            {
              e.printStackTrace();
            }
            return retConnection;
    }
    
    public static void returnDBConnection(Connection conn){
        String dataSource=PCIProperties.PCI_DATASOURCE;
        //System.out.println("datasource:"+dataSource);
        try{
            if(dataSource.equals("CQ")){
//              DBUtil.cleanUp(conn);
            }
            if(dataSource.equals("CQ5")){
                //TODO: implement for CQ5
                //String PCI_DATASOURCENAME=PCIProperties.PCI_CQDATASOURCENAME;
                //retConnection=DBUtil.getConnection(PCI_DATASOURCENAME);
                conn.close();
            }
            if(dataSource.equals("Oracle")){
/*
                OracleConnectionPoolDataSource ocpds_pci = new OracleConnectionPoolDataSource();               
                ocpds_pci.setDriverType(PCIProperties.PCI_ORACLEDRIVERTYPE);
                ocpds_pci.setServerName(PCIProperties.PCI_ORACLESERVERNAME); //hostname
                ocpds_pci.setPortNumber(PCIProperties.PCI_ORACLESERVERPORT);
                ocpds_pci.setDatabaseName(PCIProperties.PCI_ORACLEDBNAME); // sid
                ocpds_pci.setUser(PCIProperties.PCI_ORACLEUSER);
                ocpds_pci.setPassword(PCIProperties.PCI_ORACLEPASSWORD);         
                ocpds_pci.close();
                conn.close();
*/
            }

        }catch(Exception e){
            System.out.println("Exception:"+e.getLocalizedMessage());
        }
        return;

    }
    
}
