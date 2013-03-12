public with sharing class WarehouseDataInstall {

	public WarehouseDataInstall() {}

	public static boolean getHasData() {
		return [SELECT Id from Merchandise__c].size() > 0;
	}
	
	public PageReference createData() {
		List<Merchandise__c> m = new List<Merchandise__c>();
		m.add(new Merchandise__c(Name='Rack Server',Price__c=3245.99,Quantity__c=500));
		m.add(new Merchandise__c(Name='Old Laptop',Price__c=345.99,Quantity__c=50));
		m.add(new Merchandise__c(Name='Deluxe Desktop',Price__c=1399.99,Quantity__c=250));
		m.add(new Merchandise__c(Name='Work Desktop',Price__c=1145.99,Quantity__c=750));		
		insert m;
		
		Invoice__c i = new Invoice__c();
		insert i;
		
		Line_Item__c li = new Line_Item__c(Name='1',Quantity__c=10,Merchandise__c=m[0].Id,Invoice__c=i.Id);
		insert li;
		
		return null;
	}
	
	
	@isTest
	public static void testWarehouseDataInstall() {
		WarehouseDataInstall wdi = new WarehouseDataInstall();
		if(!WarehouseDataInstall.getHasData()) {
			wdi.createData();
		}
		System.assertEquals(true,WarehouseDataInstall.getHasData());
	}

}