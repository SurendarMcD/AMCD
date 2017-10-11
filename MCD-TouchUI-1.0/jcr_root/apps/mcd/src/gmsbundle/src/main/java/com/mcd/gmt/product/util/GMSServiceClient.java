package com.mcd.gmt.product.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.Calendar;

public class GMSServiceClient
{
    URL url = null;
    URLConnection connection = null;
    InputStream in = null;
    BufferedReader res = null;
    
    public GMSServiceClient()
    {
        url = null;
        connection = null;
        in = null;
        res = null;
    }
    
    public String callURL(String strUrl)  throws IOException
    {
        System.getProperties().put("proxySet", "true"); 
        System.getProperties().put("proxyHost", "10.112.62.73"); 
        System.getProperties().put("proxyPort", "8080"); 

        StringBuffer sBuffer = new StringBuffer();
        try
        { 
            long miliseconds = Calendar.getInstance().getTimeInMillis();
            strUrl += "?time="+miliseconds;
            url = new URL(strUrl);
            connection = url.openConnection();
            
            in = connection.getInputStream();
            res = new BufferedReader(new InputStreamReader(in, "UTF-8"));
            
            String inputLine;
            while ((inputLine = res.readLine()) != null)
            {
                sBuffer.append(inputLine);
            }
        }
        catch(Exception ex)
        {
           ex.printStackTrace();
        }
        finally
        {
           if(res != null)
               res.close();
           if(in != null)
               in.close();
           connection = null;
        }       
        
        return sBuffer.toString();
    }
    
    /*OperationDesc _operations[] = new OperationDesc[3];
    
    public GMSServiceClient()
    {
        _initOperationDesc1();
    }
    
    private void _initOperationDesc1()
    {
        OperationDesc oper = new OperationDesc();
        oper.setName("GetNutrientComposition");
        ParameterDesc param = new ParameterDesc(new QName("http://mcdeagpweb153.corp.pri/", "SpecNumberList"), (byte)1, new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("http://mcdeagpweb153.corp.pri/", "IsApproved"), (byte)1, new QName("http://www.w3.org/2001/XMLSchema", "boolean"), Boolean.TYPE, false, false);
        oper.addParameter(param);
        oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(String.class);
        oper.setReturnQName(new QName("http://mcdeagpweb153.corp.pri/", "GetNutrientCompositionResult"));
        oper.setStyle(Style.WRAPPED);
        oper.setUse(Use.LITERAL);
        _operations[0] = oper;
        oper = new OperationDesc();
        oper.setName("GetSpecBuildInformation");
        param = new ParameterDesc(new QName("http://mcdeagpweb153.corp.pri/", "SpecNumberList"), (byte)1, new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("http://mcdeagpweb153.corp.pri/", "IsApproved"), (byte)1, new QName("http://www.w3.org/2001/XMLSchema", "boolean"), Boolean.TYPE, false, false);
        oper.addParameter(param);
        oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(String.class);
        oper.setReturnQName(new QName("http://mcdeagpweb153.corp.pri/", "GetSpecBuildInformationResult"));
        oper.setStyle(Style.WRAPPED);
        oper.setUse(Use.LITERAL);
        _operations[1] = oper;
        oper = new OperationDesc();
        oper.setName("GetSpecName");
        param = new ParameterDesc(new QName("http://mcdeagpweb153.corp.pri/", "SpecNumberList"), (byte)1, new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("http://mcdeagpweb153.corp.pri/", "IsApproved"), (byte)1, new QName("http://www.w3.org/2001/XMLSchema", "boolean"), Boolean.TYPE, false, false);
        oper.addParameter(param);
        oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(String.class);
        oper.setReturnQName(new QName("http://mcdeagpweb153.corp.pri/", "GetSpecNameResult"));
        oper.setStyle(Style.WRAPPED);
        oper.setUse(Use.LITERAL);
        _operations[2] = oper;
    }
    
    public String callURL(String specNumberList, boolean isApproved)  throws IOException
    {
        Call _call;
    
        _call = createCall();
        _call.setOperation(_operations[0]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://mcdeagpweb153.corp.pri/GetNutrientComposition");
        _call.setEncodingStyle(null);
        _call.setProperty("sendXsiTypes", Boolean.FALSE);
        _call.setProperty("sendMultiRefs", Boolean.FALSE);
        _call.setSOAPVersion(SOAPConstants.SOAP12_CONSTANTS);
        _call.setOperationName(new QName("http://mcdeagpweb153.corp.pri/", "GetNutrientComposition"));
        setRequestHeaders(_call);
        setAttachments(_call);
        Object _resp;
        _resp = _call.invoke(new Object[] {
            specNumberList, new Boolean(isApproved)
        });
        if(_resp instanceof RemoteException)
            throw (RemoteException)_resp;
        extractAttachments(_call);
        return (String)_resp;
    }
    
    protected Call createCall()
    {
        Call _call = null;
        try
        {
            _call = super._createCall();
            if(super.maintainSessionSet)
                _call.setMaintainSession(super.maintainSession);
            if(super.cachedUsername != null)
                _call.setUsername(super.cachedUsername);
            if(super.cachedPassword != null)
                _call.setPassword(super.cachedPassword);
            if(super.cachedEndpoint != null)
                _call.setTargetEndpointAddress(super.cachedEndpoint);
            if(super.cachedTimeout != null)
                _call.setTimeout(super.cachedTimeout);
            if(super.cachedPortName != null)
                _call.setPortName(super.cachedPortName);
            String key;
            for(Enumeration<Object> keys = super.cachedProperties.keys(); keys.hasMoreElements(); _call.setProperty(key, super.cachedProperties.get(key)))
                key = (String)keys.nextElement();
        } 
        catch (ServiceException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    
        return _call;
    }*/
}