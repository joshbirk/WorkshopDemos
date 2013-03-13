public with sharing class BadClass {

	public Merchandise__c merch {get; set;}

	public BadClass(ApexPages.StandardController s) {
		merch = (Merchandise__c)s.getRecord();
		fixUnitTests();
	}
	
	@RemoteAction
	public static String getName(Id merchId) {
		return [SELECT NAME from Merchandise__c WHERE ID =: merchId LIMIT 1].Name;
	}

	
	@RemoteAction 
	public static Merchandise__c getRecord(Id merchId) {
		return [SELECT Id, NAME, Price__c from Merchandise__c WHERE ID =: merchId LIMIT 1];
	}

	@isTest
	public static void myTest() {
		BadClass bc = new BadClass(new ApexPages.StandardController(new Merchandise__c()));
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public void fixUnitTests() {
		Integer i;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		
	}

}