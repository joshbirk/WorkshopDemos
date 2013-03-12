public with sharing class WarehouseDash {

	public transient List<Invoice__c> invoices {get; set;}

	public WarehouseDash() {
		invoices = [SELECT Id, Name, Invoice_Total__c, Status__c from Invoice__c ORDER BY CreatedDate DESC Limit 10];
		
	}

}