@isTest
public with sharing class WarehouseUnitTests {
	
	static public string dataString = '"17 Inch Monitor",99,200\n"21 Inch Monitor",129,200\n"25 Inch Monitor",179,200';
	
	public WarehouseUnitTests() {}
	
	//Test Email Utility
	@isTest
	static public void testDatedInvoices() {
		//CreatedDate cannot be written, but it can be imported
		List<Invoice__c> invoices = Test.loadData(Invoice__c.sObjectType, 'InvoiceData');
		update invoices;
	
		System.assertEquals(WarehouseUtil.checkForDatedInvoices(),true);
		
		invoices[0].Status__c = 'Closed';
		update invoices;
		
		System.assertNotEquals(WarehouseUtil.checkForDatedInvoices(),true);
		
		
		Test.StartTest();
			System.schedule('testSchedule','0 0 13 * * ?',new WarehouseUtil());
			ID batchprocessid = Database.executeBatch(new WarehouseUtil());
		Test.StopTest();
		
		invoices = [SELECT ID FROM Invoice__c];
		System.assertEquals(invoices.size(),0);
	}
	
	//Test Data Utilty
	
	//We do not set (seeAllData) and hence can assume there are 0 records in the system.
	@isTest
	static public void testEnterDataFromText() {
		WarehouseUtil.enterDataFromText(dataString);
		List<Merchandise__c> merch = [SELECT ID from Merchandise__c];
		System.assertEquals(merch.size(),3);
	}
	
	@isTest
	static public void testCreateBaselineData() {
		WarehouseUtil.createBaselineData();
		List<Merchandise__c> merch = [SELECT ID from Merchandise__c];
		System.assertEquals(merch.size(),1);
		
		List<Invoice__c> invoices = [SELECT ID from Invoice__c];
		System.assertEquals(invoices.size(),1);
		
		List<Line_Item__c> line_items = [SELECT ID from Line_Item__c];
		System.assertEquals(line_items.size(),1);
		
		
	}
	
/*	@isTest
	static public void testLineItemTrigger() {
		Merchandise m = new Merchandise__c(Name='Rack Server',Price__c=3245.99,Quantity__c=500);
		insert m;
		
		Invoice i = new Invoice__c();
		insert i;
		
		Line_Item old_item = new Line_Item__c(Name='1',Quantity__c=10,Merchandise__c=m[0].Id,Invoice__c=i.Id);
		insert old_item;
		
		List<Line_Item__c> duplicateItems = new List<Line_Item__c>();
				duplicateItems.add(new Line_Item__c(Name='1',Quantity__c=10,Merchandise__c=m[0].Id,Invoice__c=i.Id));
				duplicateItems.add(new Line_Item__c(Name='1',Quantity__c=20,Merchandise__c=m[0].Id,Invoice__c=i.Id));
		try {
					Line_Item__c li2 = new Line_Item__c(Name='1',Quantity__c=10,Merchandise__c=m[0].Id,Invoice__c=i.Id);
					insert duplicateItems;
				} catch(DMLException e) {
					System.assertEquals(e.getMessage().contains('Duplicate'),true);
				}
		
		List<Line_Item__c> lis = [SELECT ID, Merchandise__c from Line_Item__c];
		System.assertEquals(1,lis.size());	
	} */
	
//	@isTest
//	private class TestHandleProductPriceChange {
	     static testMethod void testPriceChange() {
	         Invoice__c invoice = new Invoice__c
	            (Status__c = 'Negotiating');
	         insert invoice;
	         Merchandise__c[] products = new Merchandise__c[]{
	             new Merchandise__c(Name = 'item 1', Price__c = 10, Quantity__c = 10),
	             new Merchandise__c(Name = 'item 2', Price__c = 11, Quantity__c = 10)
	         };
	         insert products;
	         Line_Item__c[] lineItems = new Line_Item__c[] {
	             new Line_Item__c(Invoice__c = invoice.id, Merchandise__c = products[0].id, Unit_Price__c = 10, Quantity__c = 3),
	              new Line_Item__c(Invoice__c = invoice.id, Merchandise__c = products[1].id, Unit_Price__c = 11, Quantity__c = 6)
	         };
	         insert lineItems;

	     products[0].price__c = 20;
	       Test.startTest();
	       update products;
	       Test.stopTest();
	lineItems = [SELECT id, unit_price__c FROM Line_Item__c WHERE id IN :lineItems];
	       system.assert(lineItems[0].unit_price__c == 10);
	   }
//	}		

}