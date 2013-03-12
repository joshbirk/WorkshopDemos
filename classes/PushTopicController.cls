public with sharing class PushTopicController {

	public List<PushTopic> pushtopics {get; set;}
	public PushTopic currentPushTopic {get; set;}
	
	public String editTopicId {get; set;}

	public PushTopicController() {
		pushtopics = new List<PushTopic>();
		pushtopics = [SELECT Id, Name, Query, Description, ApiVersion, NotifyForOperations, NotifyForFields from PushTopic];
		currentPushTopic = null;
		editTopicId = '';
	}
	
	public PageReference setCurrentTopic() {
		if(editTopicId == 'New') { currentPushTopic = new PushTopic(ApiVersion=26.0,NotifyForOperations='All',NotifyForFields='Referenced'); }
		else {
			for(PushTopic t : pushtopics) {
				if(t.Id == Id.valueOf(editTopicId)) { currentPushTopic = t; }
			}
		}
		return null;
	}
	
	public PageReference saveCurrentTopic() {
		try {
			upsert currentPushTopic;
			pushtopics = [SELECT Id, Name, Query, Description, ApiVersion, NotifyForOperations, NotifyForFields from PushTopic];	
			currentPushTopic = null;
			return null;
		} catch (Exception e) {
			return null;
		}
		
	}
	
	public PageReference deleteCurrentTopic() {
		delete currentPushTopic;
		pushtopics = [SELECT Id, Name, Query, Description, ApiVersion, NotifyForOperations, NotifyForFields from PushTopic];	
		currentPushTopic = null;
		return null;
	}
	
	public PageReference cancelCurrentTopic() {
		currentPushTopic = null;
		return null;
	}
	
	
	@isTest
	static public void testTopicController() {
		PushTopic pushTopic = new PushTopic();
		pushTopic.Name = 'Accounts';
		pushTopic.Description = 'All records for the Account object';
		pushtopic.Query = 'SELECT Id, Name from Account';
		pushTopic.ApiVersion = 26.0;
		pushTopic.NotifyForOperations = 'All';
		pushTopic.NotifyForFields = 'Referenced';
		
		insert pushTopic;
		
		PushTopicController ptc = new PushTopicController();
		ptc.editTopicId = 'New';
		
		ptc.setCurrentTopic();
		System.assertNotEquals(ptc.currentPushTopic,null);
		
		ptc.cancelCurrentTopic();
		System.assertEquals(ptc.currentPushTopic,null);
		
		ptc.editTopicId = pushTopic.Id;
		
		ptc.setCurrentTopic();
		System.assertNotEquals(ptc.currentPushTopic,null);
		
		ptc.saveCurrentTopic();
		System.assertEquals(ptc.currentPushTopic,null);
		
		ptc.editTopicId = pushTopic.Id;
		ptc.setCurrentTopic();
		ptc.deleteCurrentTopic();
		
		System.assertEquals(ptc.pushTopics.size(),0);
		
	}

}