public with sharing class WarehouseListPage_Remote {

	public transient List<Merchandise__c> merchandise {get;}
	
	public WarehouseListPage_Remote() {
		merchandise = WarehouseDataQuery.getAllMerchandise();
	}


	@RemoteAction
	static public String updateQuantity(Id recordId, Integer quantity) {
		Merchandise__c m = new Merchandise__c(Id=recordId,Quantity__c=quantity);
		update m;
		
		return 'Record '+recordId+' has been updated to '+quantity;
	}

}
