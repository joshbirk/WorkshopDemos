@RestResource(urlMapping='/WarehouseREST/*')
global with sharing class WarehouseREST {

	global WarehouseREST() {}
	
	@HttpGet
	global static Map<String,Integer> getMerchandiseForInvoice() {
		String id = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/')+1);
		List<AggregateResult> lis = [SELECT SUM(Line_Item_Total__c) total, Merchandise__r.Name name from Line_Item__c where Invoice__c = :id Group By Merchandise__r.Name];
		
		Map<String,Integer> results = new Map<String,Integer>();
		for(AggregateResult a : lis) {
			results.put(String.valueOf(a.get('name')),Integer.valueOf(a.get('total')));
		}
		
		return results;
	}
	
	@HttpPost 
	global static RESTMessage postMerchandiseToInvoice(Id invoiceID, List<Id> merchIDs) {
		List<Line_Item__c> line_items = new List<Line_Item__c>();
		
		for(Id m : merchids) {
			Line_Item__c li = new Line_Item__c(Invoice__c = invoiceID, Merchandise__c=m, Quantity__c=1);
			line_items.add(li);
		}
		try {
			insert line_items;
			return new RESTMEssage(line_items.size() +' item(s) added','Completed', invoiceId);
		} catch (DMLException e) {
			return new RESTMEssage(e.getMessage(),'Error', invoiceId);
		}		
	}

	
	@HttpDelete
	global static RESTMessage deleteMerchandiseFromInvoice() {
		Id merchId = RestContext.request.params.get('mid');
		Id invoiceId = RestContext.request.params.get('iid');
		List<Line_Item__c> line_items = [SELECT ID from Line_Item__c WHERE Merchandise__c = :merchID AND Invoice__c = :invoiceId];
		
		try {
			delete line_items;
			return new RESTMEssage(line_items.size() +' item(s) deleted','Completed', merchId+','+invoiceId);
		} catch (DMLException e) {
			return new RESTMEssage(e.getMessage(),'Error', merchId+','+invoiceId);
		}
	}
	
	global class RESTMessage {
		public String message {get; set;}
		public String status {get; set;}
		public String info {get; set;}
		public RESTMessage(String m, String s, String i) {
			this.message = m;
			this.status = s;
			this.info = i;
		}
	}
	
	@IsTest
	global static void testWarehouseREST() {	
		Merchandise__c m = new Merchandise__c(Name='Rack Server',Price__c=1245.99,Quantity__c=500);
		insert m;
		
		Invoice__c i = new Invoice__c();
		insert i;
		
		Line_Item__c li = new Line_Item__c(Name='1',Quantity__c=10,Merchandise__c=m.Id,Invoice__c=i.Id);
		insert li;
		
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		WarehouseREST.RESTMessage r = WarehouseREST.postMerchandiseToInvoice(i.id,new Id[]{m.id});
		System.assertEquals(r.status,'Completed');
		
		// pass the req and resp objects to the method		 
		req.requestURI = 'https://www.salesforce.com/services/apexrest/WarehouseREST/'+i.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
 		Map<String,Integer> get_results = WarehouseREST.getMerchandiseForInvoice();
		System.assertEquals(get_results.size(),1);
		
		// pass the req and resp objects to the method		 
		req.requestURI = 'https://www.salesforce.com/services/apexrest/WarehouseREST/?iid='+i.Id+'&'+m.id;  
		req.httpMethod = 'DELETE';
 		RestContext.request = req;
		RestContext.response = res;
		
		r = WarehouseREST.deleteMerchandiseFromInvoice();
		System.assertEquals(r.status,'Completed');
		
		
	}
	


}