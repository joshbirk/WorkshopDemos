public with sharing class WarehouseDataQuery {

	public WarehouseDataQuery() {}
	public WarehouseDataQuery(ApexPages.StandardController stc) {}
		
	static public List<Merchandise__c> getAllMerchandise() {
	        List<Merchandise__c> theMerchandise = [SELECT Name, Quantity__c, Price__c FROM Merchandise__c];
	        return theMerchandise;
	    }	
		

}