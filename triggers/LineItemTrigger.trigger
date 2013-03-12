trigger LineItemTrigger on Line_Item__c (before insert, before update) {	
	
	if(Trigger.isBefore) { //separate events	
		
		if(Trigger.isInsert || Trigger.isUpdate) { //separate events
			Map<Id,Map<Id,Line_Item__c>> invoiceToMerchandise = new Map<Id,Map<Id,Line_Item__c>>();
			for(Line_Item__c li : Trigger.new) {
				if(!invoiceToMerchandise.containsKey(li.Invoice__c)) { //New Invoice
					Map<Id,Line_Item__c> newMap = new Map<Id,Line_Item__c>();
					invoiceToMerchandise.put(li.Invoice__c,newMap);
					Map<Id,Line_Item__c> myMap = invoiceToMerchandise.get(li.Invoice__c);
					myMap.put(li.Merchandise__c,li);			
				} else {
					for(Id i : invoiceToMerchandise.keySet()) {
						if(invoiceToMerchandise.get(li.Invoice__c).containsKey(li.Merchandise__c)) {
							li.addError('Duplicate Merchandise for Invoice');
						}
					}
				
				}
			}
			Set<Id> inids = invoiceToMerchandise.keySet();
			Map<ID, Line_Item__c> relatedLineItems = new Map<ID, Line_Item__c>([SELECT Id, Merchandise__c, Quantity__c FROM Line_Item__c WHERE Invoice__c IN :inids]);
			for(Id i : relatedLineItems.keySet()) {
				for(Line_Item__c li : Trigger.new) {
					if(invoiceToMerchandise.get(li.Invoice__c).containsKey(relatedLineItems.get(i).Merchandise__c) &&
					   invoiceToMerchandise.get(li.Invoice__c).get(relatedLineItems.get(i).Merchandise__c).Id != i
					) {
						li.addError('Duplicate Merchandise for Invoice');
					}
					
				}
			}
	
		}
	
	}

}