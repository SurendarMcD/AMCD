package com.mcd.accessmcd.usermanagement.replication.services;

public interface IReplicationService
{

    /**
     * Method to replicate group on publish instances.
     * 
     * @param groupID
     */
    public boolean replicateGroupOnPublish(String groupID) throws Exception;

    /**
     * Method to replicate user on publish instances.
     * 
     * @param EID
     */
    public boolean replicateUserOnPublish(String EID) throws Exception;
}