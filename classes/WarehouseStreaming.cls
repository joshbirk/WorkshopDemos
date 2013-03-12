public with sharing class WarehouseStreaming {

	public WarehouseStreaming() {}
	
	static public void createWarehouseTopic() {
		//Clear out old ones
		List<PushTopic> pts = [SELECT ID, Name From PushTopic WHERE Name = 'Merchandise'];
		delete pts;
		
		PushTopic pushTopic = new PushTopic();
		pushTopic.Name = 'Merchandise';
		pushTopic.Description = 'All records for the Account object';
		pushtopic.Query = 'SELECT Id, Name, Quantity__c FROM Merchandise__c WHERE Quantity__c < 50';
		pushTopic.ApiVersion = 26.0;
		pushTopic.NotifyForOperations = 'All';
		pushTopic.NotifyForFields = 'Referenced';
		insert pushTopic;
		System.debug('Created new PushTopic: '+ pushTopic.Id);

			
		}
	
	
	@isTest(SeeAllData=true)
	static public void testTopicCreation() {
		WarehouseUtil.createBaselineData();
		WarehouseStreaming.createWarehouseTopic();
		List<PushTopic> pts = [SELECT ID From PushTopic WHERE Name = 'Merchandise'];
		System.assertEquals(pts.size(),1);
	}

}