 package com.mcd.accessmcd.cq.migration.util;
 
import java.util.HashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
//import javax.jcr.Session;
 /* 
 * Data storage helper class for migrations
 */
 public class MigrationInfo{
       public String cq4page="";
       public String cq4domain="";
       public String cq4siteroot="";
       public String cq5siteroot=""; 
       public javax.jcr.Node destPage=null;
       public String cq5dest="";
       public String cq5basepagename="";
       public String linkroot="";
       public String linktranslate="";
       public String rownum="";
       public String colnum="";
       public String parnum="";
       public String cq4server="";
       public String cq4supwd="";
       public boolean isSuperTemplate=false;
       public String template="";
       public String colname="";
       public String design="";
       public HashMap titlestyles=new HashMap();
       public int processLevels=1;
       public int currentLevel=1;
       public boolean addTopNav=false; 
       public boolean addLeftNav=false;
       public javax.jcr.Session session=null;
       public boolean process=true;
       public int processed=0;
       public boolean titleComponentFound=false;
       public boolean fix=false;
       public boolean fixed=true;
       public boolean fixsave=false;
       public int fixpar=0;
       private static final Logger log = LoggerFactory.getLogger(MigrationInfo.class);
       
       public MigrationInfo(){
       }
       
       public String dump(){
           return " cq4page:"+this.cq4page+
           " cq5dest:"+this.cq5dest+
           " rownum:"+this.rownum+
           " colnum:"+this.colnum+
           " parnum:"+this.parnum;
       }
       
       public void info(String msg){
            log.info(msg);
       }
       public void error(String msg){
            log.error(msg);
       }
   }