package com.mcd.monitors;

import java.lang.Runnable;
import java.util.Date;
import java.util.Map;
import java.util.NoSuchElementException;

import com.mcd.monitors.Activator;
import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;
import com.mcd.email.Email;
import com.mcd.email.EmailImpl;

import java.text.*;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(value = Runnable.class)
@Properties({
    @Property( name="service.description",value="MCDMemory"),
    @Property( name="service.vendor",value="MCD"),
    @Property( name="scheduler.period",longValue = 900),
    @Property( name="scheduler.expression", value="0 0/10 * * * ?", label="Expression", description="see unix cron format"),
    @Property(name="scheduler.concurrent", boolValue=false)
})


public class MCDMemory implements Runnable{

    BundleContext bc = Activator.getBundleContext();

    @Reference
    private Email email;

    public void run() {
        try{
            ServiceReference sr = bc.getServiceReference("com.mcd.email.Email");
            String[] a = {"judy.zhang@us.mcd.com"};
            Long max = new Long(Runtime.getRuntime()
                .maxMemory() / 1024);
            Long total = new Long(Runtime.getRuntime()
                .totalMemory() / 1024);
            Long free = new Long(Runtime.getRuntime()
                .freeMemory() / 1024);
            String percent = this.getPercentFree();
            if (Double.parseDouble(percent)<3){
                System.out.println("free memory is :"+percent+"%");
                String msg = percent+"% Free \n"+free+" KB Free\n"+total +" KB Total\n";
                email.sendTextEmail("oak2app35.mcd.com", "", "", a, "Alert- Cq5 STG 107b:4217 free memory low("+percent+"%)", msg,"noreply@us.mcd.com", null, null);
              }
           }catch(Exception e){
                   System.out.println("Exception in checkStatus" + e.getMessage());
           }
    }


    /**
     * @author: Judy Zhang
     * 
     */
    private String getPercentFree() {
        double max = (double) Runtime.getRuntime()
                .maxMemory();
        double free = (double) Runtime.getRuntime()
                .freeMemory();
        DecimalFormat fmtObj = new DecimalFormat("####0.00");
        return fmtObj.format((free / max) * 100);
    }
     
	protected void bindEmail(Email email)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.email = email;
            
    }   
    protected void unbindEmail(Email email)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        email = null;
    }
}
