package com.mcd.accessmcd.usermanagement.replication.services;

import java.util.Map;

public interface ILdapSynchService
{
    /**
     * Method is used to check user in LDAP
     * 
     * @param EID
     * @return boolean (True-> If exists, False-> If not exists)
     */
    public boolean checkUserInLDAP(String EID) throws Exception;

    /**
     * Method to get user properties from LDAP
     * 
     * @param EID
     * @return Map Containing User Properties from LDAP
     */
    public Map getUserPropertiesFromLDAP(String EID) throws Exception;

}