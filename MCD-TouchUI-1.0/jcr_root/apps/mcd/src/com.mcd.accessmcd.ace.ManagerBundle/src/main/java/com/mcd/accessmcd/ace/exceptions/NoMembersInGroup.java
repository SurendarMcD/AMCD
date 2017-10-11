
package com.mcd.accessmcd.ace.exceptions;

/**
 * @author mc23284
 *
 */
public class NoMembersInGroup extends RuntimeException{
    
    private String groupID;
    
    public NoMembersInGroup(String groupID){
        this.groupID = groupID;
    }
                
    public String getMessage(){
        return "There are no members in group : " +groupID;
    }
    
    public String toString(){
        return "There are no members in group : " +groupID;
    }
}
