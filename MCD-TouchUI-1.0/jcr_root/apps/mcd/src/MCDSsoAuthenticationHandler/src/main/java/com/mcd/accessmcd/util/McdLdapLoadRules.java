package com.mcd.accessmcd.util;

import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.Iterator;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.Value;


import org.apache.jackrabbit.api.security.user.Authorizable;
import org.apache.jackrabbit.api.security.user.Group;
import org.apache.jackrabbit.api.security.user.User;
import org.apache.jackrabbit.api.security.user.UserManager;
import org.apache.jackrabbit.api.JackrabbitSession;

import com.mcd.accessmcd.util.ADMapper;


/*
 * Class containing logic to determine whether users are affected by LDAP synch 
 * One step closer to XML driven rules of old
 * Erik Wannebo 3/11/2010
 */
public class McdLdapLoadRules {

    public static final boolean ASSIGN_GROUPS = true;

    //map for 6 global default groups
	public static Map<String,String> groupMap=new HashMap<String,String>();

    static {
    	groupMap.put("CorpEmployees", "DEFAULT-Employee");
    	groupMap.put("Franchisees", "DEFAULT-Owner_Operator");
    	groupMap.put("FranchiseeRestMgrs", "DEFAULT-Franchisee_Restaurant_Manager");
    	groupMap.put("McOpCoRestMgrs", "DEFAULT-McOpCo_Restaurant_Manager");
    	groupMap.put("SupplierVendor", "DEFAULT-Suppliers_Vendors");
    	groupMap.put("SupplierVendors", "DEFAULT-Suppliers_Vendors");
    	groupMap.put("Crew", "DEFAULT-Crew");
		//add 2 new audience types : FranchiseeOfficeStaff , Agency, by Judy, 06/25
    	groupMap.put("FranchiseeOfficeStaff", "default-franchisee_office_staff");
    	groupMap.put("Agency", "default-agency");
    	
    }

    //map for 6 global default groups, added by Judy
	public static Map<String,String> groupMap2=new HashMap<String,String>();

    static {
    	//groupMap2.put("OfficeStaff", "default-office_staff");
    	groupMap2.put("FranchiseeOfficeStaff", "default-franchisee_office_staff");
    	groupMap2.put("Agency", "default-agency");
    }

	/*
	 * Return group to assign user based on LDAP attributes
	 */
	public static String getDefaultGroupForUser(String mcdAudience)
	throws RepositoryException{
		String groupName="";
		groupName=groupMap.get(mcdAudience);;
		return groupName;
	}


	/*
	 * Return group to assign user based on LDAP attributes
	 */
	public static ArrayList getDefaultGroupListForUser(String mcdAudience)
	throws RepositoryException{

        ArrayList defaultgroups=new ArrayList();

		String groupName=groupMap.get(mcdAudience);

		defaultgroups.add(groupName);
		
		return defaultgroups;
	}

	/*
	 * Return extra group to assign user based on LDAP attributes, added by Judy
	 */
	public static String getExtraGroupForUser(Map<String, Value[]> attributes)
	throws RepositoryException{

		String groupName="";
		if(!ASSIGN_GROUPS)return "";

//		ArrayList extragroups=new ArrayList();
//    	String groupName="";
//		if(!ASSIGN_GROUPS)return extragroups;

		String mcdRole="";
		String mcdCompanyType="";
		String mcdAudience="";
		
		Value[] mcdRoleVals=attributes.get("personalTitle"); 
		if (mcdRoleVals != null && mcdRoleVals[0] != null) {
			mcdRole=mcdRoleVals[0].getString();
			
		}

//System.out.println("extra:: callback mcdRole ........"+ mcdRole);

		Value[] mcdCompanyTypeVals=attributes.get("primaryTelexNumber"); 
		if (mcdCompanyTypeVals != null && mcdCompanyTypeVals[0] != null) {
			mcdCompanyType=mcdCompanyTypeVals[0].getString();
			
		}
		mcdAudience=(new ADMapper()).getInstance().getMcdAudience(mcdCompanyType, mcdRole);

//		groupName=groupMap.get(mcdAudience);

//		extragroups.add(groupName);

//System.out.println("extra:: callback mcdAudience ........"+ mcdAudience);

//adding special cases, ignore FranchiseeRestMgrs, McOpCoRestMgrs,SupplierVendor sincde they already have default groups
//			  if(mcdAudience.equals("FranchiseeRestMgrs"))extragroups.add("franchiserestaurantmanagers");
//			  if(mcdAudience.equals("McOpCoRestMgrs"))extragroups.add("mcopcorestaurantmanagers");
//			  if(mcdAudience.equals("SupplierVendor"))extragroups.add("suppliers");

//only handle  agency and franchisee office staff , no need to map SOF groups
//			  if(mcdAudience.equals("CorpEmployees")){
//				 // extragroups.add("default-office_staff");
//				  groupName = "default-office_staff";
//			  }

//role to default group mapping		
		      if(mcdRole.equals("Agency")){
				 // extragroups.add("default-agency");
				  groupName = "default-agency";
			  }
			  if(mcdRole.equals("Franchisee Office Staff")){
				 // extragroups.add("default-frachisee_office_staff");
//				  extragroups.add("sof_ca_ownop");
				  groupName = "default-franchisee_office_staff";
			  }
		
/*			   
 // sof groups
			  if(mcdRole.equals("Franchisee") || 
					  mcdRole.equals("Restaurant Manager") ||
					  mcdRole.equals("First Assistant") ||
					  mcdRole.equals("Second Assistant") ||
					  mcdRole.equals("Manager Trainee"))
				     extragroups.add("sof_ca_ownop");
			  if(mcdRole.equals("Swing Manager"))extragroups.add("sof_ca_rest_mgr");
			  if(mcdRole.equals("Crew"))extragroups.add("sof_ca_emp");
*/ 	 	
	   	  
	
		
		return groupName;
	}

    	/*
	 * Assigns user to default groups based on User attributes
	 */
	public static boolean assignUserToDefaultGroup(UserManager userManager, Authorizable user,String mcdaudience)
	throws RepositoryException{
		boolean bAddToGroup=true;
        boolean bGroupMembershipChanged=false;
        String defaultGroupName=getDefaultGroupForUser(mcdaudience);

        if(defaultGroupName==null){
            defaultGroupName="";
            bAddToGroup=false;
        }

        // compare against current user groups
        Iterator<Group> userGroups=user.declaredMemberOf();
        while(userGroups.hasNext()){
            Group grp=userGroups.next();
            if(grp.getID().equals(defaultGroupName)){
                bAddToGroup=false;
            }else{
                //remove user from other role groups
                if(McdLdapLoadRules.groupMap.containsValue(grp.getID())){
                    grp.removeMember(user);
                    bGroupMembershipChanged=true;
                }
            }
        }
        
        if(bAddToGroup){
            Group assignGrp=(Group)userManager.getAuthorizable(defaultGroupName);
            if(assignGrp!=null){
                assignGrp.addMember(user);
                bGroupMembershipChanged=true;
            }
        }
        return bGroupMembershipChanged;

	}



}
