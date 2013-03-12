global with sharing class WarehouseUtil2 implements Database.Batchable<sObject>, Schedulable {
  
	//Scheduled execute
	global void execute(SchedulableContext ctx) {
		WarehouseUtil2.checkForDatedInvoices();		
	}
	
	//Batch execute	
	global Database.QueryLocator start(Database.BatchableContext BC){
			return Database.getQueryLocator('SELECT ID FROM Invoice__c WHERE Status__c = \'Archived\' AND CreatedDate < LAST_90_DAYS');
		   }
	global void execute(Database.BatchableContext BC, List<sObject> scope) { 
			delete scope; 
		}
	global void finish(Database.BatchableContext BC) { 
		 //add any cleanup here
		 }
		
	
	//Data checking utilties
	static public Integer checkForDatedInvoices() {
		List<Invoice__c> datedInvoices = [SELECT ID, Name, CreatedDate from Invoice__c WHERE Status__c = 'Closed' AND CreatedDate < LAST_90_DAYS];
		for(Invoice__c di : datedInvoices) {
			di.Status__c = 'Archived';
		}
		update datedInvoices;
		
		return datedInvoices.size();
	}	
	
	
	@isTest
	static public void testDatedInvoices() {
		//CreatedDate cannot be written, but it can be imported
		List<Invoice__c> invoices = Test.loadData(Invoice__c.sObjectType, 'InvoiceData');
		update invoices;
		
		invoices = [SELECT ID FROM Invoice__c WHERE Status__c = 'Closed'];
		System.assertNotEquals(0,invoices.size());
		
		
		//Assertion 1: Open records > 90 days have been set to "Archived"
		System.assertNotEquals(0,WarehouseUtil2.checkForDatedInvoices());
		invoices = [SELECT ID FROM Invoice__c WHERE Status__c = 'Archived'];
		System.assertNotEquals(0,invoices.size());

		Test.StartTest();
			ID batchprocessid = Database.executeBatch(new WarehouseUtil2());
		Test.StopTest();
		
		//Assertion 2: Archived records > 90 days have been deleted
		invoices = [SELECT ID FROM Invoice__c];
		System.assertEquals(0,invoices.size());
	}

}