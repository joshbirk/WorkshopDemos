public with sharing class WarehouseCSVController {

	public transient List<Merchandise__c> allMerchandise { get; set; }

	public WarehouseCSVController() {
		Boolean beRandom = ApexPages.currentPage().getParameters().get('random') != null;
		if(beRandom) {
			allMerchandise = new List<Merchandise__c>();
			for(Integer x = 0; x < 1500; x++) {
				Merchandise__c m = new Merchandise__c(Name='Widget '+String.valueOf(x), Quantity__c=100, Price__c=49.99);
				allMerchandise.add(m);
			}
		} else {
			allMerchandise = WarehouseDataQuery.getAllMerchandise();
		}

	}
	
	@isTest
	static public void testCSVController() {
		//load data
		Merchandise__c m1 = new Merchandise__c(Name='Rack Server',Price__c=1245.99,Quantity__c=500);
		Merchandise__c m2 = new Merchandise__c(Name='Deluxe Rack Server',Price__c=3245.99,Quantity__c=500);
		insert new Merchandise__c[]{m1,m2};
		
		//run logic
		Test.setCurrentPage(Page.WarehouseCSV);
		WarehouseCSVController cvsc = new WarehouseCSVController();
		
		//assertion: allMerchandise is not empty
		System.assertNotEquals(cvsc.allMerchandise.size(),0);
		
		ApexPages.currentPage().getParameters().put('random', 'true');
		cvsc = new WarehouseCSVController();
		
		//assertion: allMerchandise is 1500 long
		System.assertEquals(cvsc.allMerchandise.size(),1500);
		
	}

}