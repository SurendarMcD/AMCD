package com.mcd.accessmcd.pci.util;         

/**
 * A class to hold the values from the pci.properties file
 * 
 * These values are loaded once
 * 
 * 2/6/09 Erik Wannebo
 * 10/20/09 Judy Zhang
 *  
 */

import java.io.InputStream;
import java.net.URL;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Properties;
import java.util.ResourceBundle;

public class PCIProperties{

//DEV   
  //  public static String PCI_SERVLET = "http://mcdeagsun102c:8004/pci/PCIServer?";
//STG   
 // public static String PCI_SERVLET = "http://mcdeagsun102c:8004/pci/PCIServer?";
//PROD
  public static String PCI_SERVLET = "http://mcdeagsun106a:8004/pci/PCIServer?";

    public static int DEFAULT_OSCACHE_REFRESH=60;
    public static String AMCD_MEDIA_LOCATION="/accessmcd/resources";

    public static HashMap serverDomainMap=new HashMap();

    static{
        //PROD
        //serverDomainMap.put("MCDExchange","https://author.accessmcd.com");
        //serverDomainMap.put("MCDExchange","https://www1.accessmcd.com");
        //DEV
        //serverDomainMap.put("MCDExchange","http://mcdeagsun107a.mcd.com:4214");
        //STG
        serverDomainMap.put("MCDExchange","https://www1-int.accessmcd.com");
        //serverDomainMap.put("MCDExchange","https://houspub.int.accessmcd.com");
        serverDomainMap.put("INTLMCDE","https://intl.mcdexchange.com");
        serverDomainMap.put("MCDWMI","https://www.mcdwmi.com");
        serverDomainMap.put("MCDCOM","http://www.mcdonalds.com");
    }   

    //LOCAL, DEV
    //public static String PCI_CQDATASOURCENAME="devpci";
    //STG
    //public static String PCI_CQDATASOURCENAME="stgpci";
    ///PROD
    public static String PCI_CQDATASOURCENAME="stgpci";

    //DEV
    /*
    public static String PCI_DATASOURCE="CQ5";
    public static String PCI_ORACLEDRIVERTYPE="thin";
    public static String PCI_ORACLESERVERNAME="mcdeagsun104a";
    public static int PCI_ORACLESERVERPORT=1528;
    public static String PCI_ORACLEDBNAME="dshr03";
    public static String PCI_ORACLEUSER="pci";
    public static String PCI_ORACLEPASSWORD="b1gm4c1d";
    */

    //STG
   
  public static String PCI_DATASOURCE="CQ5";
  public static String PCI_ORACLEDRIVERTYPE="thin";
  public static String PCI_ORACLESERVERNAME="mcdeagsun104d";
  public static int PCI_ORACLESERVERPORT=1528;
  public static String PCI_ORACLEDBNAME="sshr03";
  public static String PCI_ORACLEUSER="pci";
  public static String PCI_ORACLEPASSWORD="b1gm4c1s";
  
    
    //PROD
  /*public static String PCI_DATASOURCE="CQ5";
  public static String PCI_ORACLEDRIVERTYPE="thin";
  public static String PCI_ORACLESERVERNAME="mcdeagsun112";
  public static int PCI_ORACLESERVERPORT=1528;
  public static String PCI_ORACLEDBNAME="pshr03";
  public static String PCI_ORACLEUSER="pci";
  public static String PCI_ORACLEPASSWORD="b1gm4c1p";*/
    
    
/*
    
    
public static String PCI_SERVLET;
public static int DEFAULT_OSCACHE_REFRESH;
public static String AMCD_MEDIA_LOCATION;
public static HashMap serverDomainMap;
public static String PCI_CQDATASOURCENAME;
public static String PCI_DATASOURCE;
public static String PCI_ORACLEDRIVERTYPE;
public static String PCI_ORACLESERVERNAME;
public static int PCI_ORACLESERVERPORT;
public static String PCI_ORACLEDBNAME;
public static String PCI_ORACLEUSER;
public static String PCI_ORACLEPASSWORD;


static
{
    //load properties once
    serverDomainMap=new HashMap();
    String propertiesFileName="pci.properties";
    ResourceBundle rb = ResourceBundle.getBundle("com.mcd.resources.pci");

    System.out.println("========== after getting resource bundle =========");
    
    PCI_SERVLET=rb.getString("PCIServlet");
    DEFAULT_OSCACHE_REFRESH=Integer.parseInt(rb.getString("DefaultOSCacheRefresh"));
    AMCD_MEDIA_LOCATION=rb.getString("AccessMCDMediaLocation");
    PCI_CQDATASOURCENAME=rb.getString("PCICQDatasourceName");
    PCI_DATASOURCE=rb.getString("PCIDatasource");
    PCI_ORACLEDRIVERTYPE=rb.getString("PCIOracleDriverType");
    PCI_ORACLESERVERNAME=rb.getString("PCIOracleServerName");
    PCI_ORACLESERVERPORT=Integer.valueOf(rb.getString("PCIOracleServerPort")).intValue();
    PCI_ORACLEDBNAME=rb.getString("PCIOracleDBName");
    PCI_ORACLEUSER=rb.getString("PCIOracleUser");
    PCI_ORACLEPASSWORD=rb.getString("PCIOraclePassword");   

    serverDomainMap.put("ServerID.MCDExchange", rb.getString("ServerID.MCDExchange"));
    serverDomainMap.put("ServerID.INTLMCDE", rb.getString("ServerID.INTLMCDE"));
    serverDomainMap.put("ServerID.MCDWMI", rb.getString("ServerID.MCDWMI"));
    serverDomainMap.put("ServerID.MCDCOM", rb.getString("ServerID.MCDCOM"));

*/
    
    /*
    ClassLoader threadContextClassLoader = Thread.currentThread().getContextClassLoader();
    URL url=null;
    if (threadContextClassLoader != null) {
        url = threadContextClassLoader.getResource(propertiesFileName);
    }
    if(url!=null){

        Properties properties = new Properties();
        InputStream in = null;
        try {
            in = url.openStream();
            properties.load(in);
            Enumeration enumPropertyKeys = properties.keys();
            while(enumPropertyKeys.hasMoreElements()){
                String key=(String)enumPropertyKeys.nextElement();
                if(key.startsWith("ServerID.")){
                    String newkey=key.substring(9);
                    serverDomainMap.put(newkey, properties.getProperty(key));
                }
            }
            PCI_SERVLET=properties.getProperty("PCIServlet");
            DEFAULT_OSCACHE_REFRESH=Integer.parseInt(properties.getProperty("DefaultOSCacheRefresh"));
            AMCD_MEDIA_LOCATION=properties.getProperty("AccessMCDMediaLocation");
            PCI_CQDATASOURCENAME=properties.getProperty("PCICQDatasourceName");
            PCI_DATASOURCE=properties.getProperty("PCIDatasource");
            PCI_ORACLEDRIVERTYPE=properties.getProperty("PCIOracleDriverType");
            PCI_ORACLESERVERNAME=properties.getProperty("PCIOracleServerName");
            PCI_ORACLESERVERPORT=Integer.valueOf(properties.getProperty("PCIOracleServerPort")).intValue();
            PCI_ORACLEDBNAME=properties.getProperty("PCIOracleDBName");
            PCI_ORACLEUSER=properties.getProperty("PCIOracleUser");
            PCI_ORACLEPASSWORD=properties.getProperty("PCIOraclePassword"); 

        }catch(Exception e){
            e.printStackTrace(System.out);
        }
    }*/
}


