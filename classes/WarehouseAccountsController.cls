public with sharing class WarehouseAccountsController {

	public Decimal lat {get; set;}
	public Decimal lng {get; set;}
	private List<Account> accounts;
	
	public WarehouseAccountsController() {}
		
	public List<Account> getAccounts() {
		if(accounts != null) { 
			return accounts;
		}
		
		if(lat == null || lng == null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Latitude or Longitude not set'));
		} else {
			String q = 'SELECT ID, Name, ShippingStreet, ShippingCity from Account WHERE DISTANCE(Location__c, GEOLOCATION('+String.valueOf(lat)+','+String.valueOf(lng)+'), \'mi\') < 100';
			accounts = Database.query(q);
			if(accounts.size() == 0) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No records found'));
			}
		}
		
		return accounts;
	}
	
	public Integer getCount() {
		return getAccounts().size();
	}
	
	
	@IsTest
	public static void testGeoAccounts() {
		//load data
		Account a1 = new Account(Name='MarketCorp',ShippingStreet='One Market',ShippingCity='San Francisco',Location__Latitude__s=37.7944988,Location__Longitude__s=-122.3947446);
		Account a2 = new Account(Name='Addington, Inc.',ShippingStreet='2nd and Market',ShippingCity='San Francisco',Location__Latitude__s=37.7880001,Location__Longitude__s=-122.399838);
		Account a3 = new Account(Name='Uptown Unlimited',ShippingStreet='1700 W Foster',ShippingCity='Chicago',Location__Latitude__s=41.976236,Location__Longitude__s=-87.6722582);
		insert new Account[]{a1,a2,a3};

		Warehouse_Location__c wl1 = new Warehouse_Location__c(Name='Chicago Warehouse',Location__Latitude__s=41.9979667,Location__Longitude__s=-87.67685);
		Warehouse_Location__c wl2 = new Warehouse_Location__c(Name='San Francisco Warehouse',Location__Latitude__s=37.7877676,Location__Longitude__s=-122.4050251);
		insert new Warehouse_Location__c[]{wl1,wl2};
		
		//perform logic
		Test.setCurrentPage(Page.WarehouseAccounts);
		
		//assertion:Uptown Unlimited will be found by 'Chicago Warehouse'
		WarehouseAccountsController wac = new WarehouseAccountsController();
		wac.lat = wl1.Location__Latitude__s;
		wac.lng = wl1.Location__Longitude__s;
		System.assertEquals(1,wac.getAccounts().size());
		
		//assertion: MarketCorp and Addington will be found by 'San Francisco Warehouse'
		wac = new WarehouseAccountsController();
		wac.lat = wl2.Location__Latitude__s;
		wac.lng = wl2.Location__Longitude__s;
		System.assertEquals(2,wac.getAccounts().size());
	
	}
	

}