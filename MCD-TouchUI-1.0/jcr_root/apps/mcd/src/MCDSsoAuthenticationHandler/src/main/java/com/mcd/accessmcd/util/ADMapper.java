package com.mcd.accessmcd.util;


import java.util.ArrayList;
import java.util.Iterator;

/*
 * Class to use to map Active Directory attibutes to other values
 * 
 * 9/22/2011 Erik Wannebo
 * 
 */
public class ADMapper {
	private static ADMapper theMapper;
	private ArrayList mappings;
	
	public ADMapper(){
		this.mappings=new ArrayList();
	
		this.mappings.add(new TwoInputMap("McD Director","*","CorpEmployees"));
		this.mappings.add(new TwoInputMap("McD Executive","*","CorpEmployees"));
		this.mappings.add(new TwoInputMap("McD Staff","*","CorpEmployees"));
		this.mappings.add(new TwoInputMap("Operations Consultant","*","CorpEmployees"));
		this.mappings.add(new TwoInputMap("Business Consultant","*","CorpEmployees"));
		this.mappings.add(new TwoInputMap("Consultant","*","CorpEmployees"));
		this.mappings.add(new TwoInputMap("Partner Brand","*","CorpEmployees"));
		
        /* MCIDs in corp branch of AD have companytype=="" */
		this.mappings.add(new TwoInputMap("First Assistant","","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Second Assistant","","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Manager Trainee","","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Restaurant Manager","","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Swing Manager","","McOpCoRestMgrs"));

		this.mappings.add(new TwoInputMap("First Assistant","McDonald's Corporation","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Second Assistant","McDonald's Corporation","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Manager Trainee","McDonald's Corporation","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Restaurant Manager","McDonald's Corporation","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Swing Manager","McDonald's Corporation","McOpCoRestMgrs"));
		
		this.mappings.add(new TwoInputMap("First Assistant","McDonald's USA, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Second Assistant","McDonald's USA, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Manager Trainee","McDonald's USA, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Restaurant Manager","McDonald's USA, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Swing Manager","McDonald's USA, LLC","McOpCoRestMgrs"));
		
		this.mappings.add(new TwoInputMap("First Assistant","McDonald's Europe, Inc.","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Second Assistant","McDonald's Europe, Inc.","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Manager Trainee","McDonald's Europe, Inc.","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Restaurant Manager","McDonald's Europe, Inc.","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Swing Manager","McDonald's Europe, Inc.","McOpCoRestMgrs"));

		this.mappings.add(new TwoInputMap("First Assistant","McDonald's Latin America, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Second Assistant","McDonald's Latin America, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Manager Trainee","McDonald's Latin America, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Restaurant Manager","McDonald's Latin America, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Swing Manager","McDonald's Latin America, LLC","McOpCoRestMgrs"));
		
		this.mappings.add(new TwoInputMap("First Assistant","McDonald's AMEA, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Second Assistant","McDonald's AMEA, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Manager Trainee","McDonald's AMEA, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Restaurant Manager","McDonald's AMEA, LLC","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Swing Manager","McDonald's AMEA, LLC","McOpCoRestMgrs"));
		
		this.mappings.add(new TwoInputMap("First Assistant","McDonald's International, LLC (JCANZ)","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Second Assistant","McDonald's International, LLC (JCANZ)","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Manager Trainee","McDonald's International, LLC (JCANZ)","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Restaurant Manager","McDonald's International, LLC (JCANZ)","McOpCoRestMgrs"));
		this.mappings.add(new TwoInputMap("Swing Manager","McDonald's International, LLC (JCANZ)","McOpCoRestMgrs"));
		
		this.mappings.add(new TwoInputMap("First Assistant","Franchisee","FranchiseeRestMgrs"));
		this.mappings.add(new TwoInputMap("Second Assistant","Franchisee","FranchiseeRestMgrs"));
		this.mappings.add(new TwoInputMap("Manager Trainee","Franchisee","FranchiseeRestMgrs"));
		this.mappings.add(new TwoInputMap("Restaurant Manager","Franchisee","FranchiseeRestMgrs"));
		this.mappings.add(new TwoInputMap("Swing Manager","Franchisee","FranchiseeRestMgrs"));
		
		//add 2 new audience types : FranchiseeOfficeStaff , Agency, by Judy, 06/25
//		this.mappings.add(new TwoInputMap("Franchisee Office Staff","*","Franchisees"));
		this.mappings.add(new TwoInputMap("Franchisee Office Staff","*","FranchiseeOfficeStaff"));
		this.mappings.add(new TwoInputMap("Franchisee","*","Franchisees"));
		
		this.mappings.add(new TwoInputMap("Crew","*","Crew"));

//		this.mappings.add(new TwoInputMap("Agency","*","SupplierVendor"));
		this.mappings.add(new TwoInputMap("Agency","*","Agency"));
		this.mappings.add(new TwoInputMap("Supplier / Vendor","*","SupplierVendor"));

	}
	
	public static ADMapper getInstance(){
		if(theMapper==null)
			theMapper=new ADMapper();
		return theMapper;
	}
	
	/* maps to legacy mcdaudiencetype */
	public String getMcdAudience(String companyType, String role){
		String audType="";

		Iterator iterMappings=this.mappings.iterator();
		while(iterMappings.hasNext()){
			TwoInputMap map=(TwoInputMap)iterMappings.next();
			if(map.mapsTo(role,companyType))
				return map.getMap();
		}
		
		return audType;
		
	}

	/*
	 * Helper class to hold mappings
	 * either attribute having a null value represents "ANY" value
	 *  
	 */
	private class TwoInputMap{
	
		private String attr1=null;
		private String attr2=null; 
		private String mapsTo=null;
		
		public TwoInputMap(String attr1, String attr2, String mapsTo){
			if(!attr1.equals("*"))this.attr1=attr1;
			if(!attr2.equals("*"))this.attr2=attr2;
			this.mapsTo=mapsTo;
		}
		
		public boolean mapsTo(String attr1, String attr2){
		if((this.attr1==null || attr1.equals(this.attr1)) &&
		   (this.attr2==null || attr2.equals(this.attr2))
		   )
			return true;
		return false;
		}
		
		public String getMap(){
			return this.mapsTo;
		}
	}
	
}

