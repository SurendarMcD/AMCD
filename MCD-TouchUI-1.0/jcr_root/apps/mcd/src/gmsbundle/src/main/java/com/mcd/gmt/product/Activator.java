package com.mcd.gmt.product;

import org.osgi.framework.BundleActivator;
import org.osgi.framework.BundleContext;

public class Activator implements BundleActivator {
    private static BundleContext context;
    public static BundleContext getBundleContext() { 
        return context; 
    }
    /*
     * (non-Javadoc)
     * @see org.osgi.framework.BundleActivator#start(org.osgi.framework.BundleContext)
     */
    public void start(BundleContext bc) throws Exception {
        context = bc;
        //System.out.println("Activator Start - Scheduler Bundle"); 
        // TODO add initialization code
    }

    /* 
     * (non-Javadoc)
     * @see org.osgi.framework.BundleActivator#stop(org.osgi.framework.BundleContext)
     */
    public void stop(BundleContext context) throws Exception {
    System.out.println("GMScheduler Activator");
        // TODO add cleanup code
    }

}

  