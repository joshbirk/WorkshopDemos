public with sharing class Isotope {

	public ID recordID {get; set;}
	public Isotope() {}
	
	public List<Line_Item__c> getLine_Items() {
		return [SELECT ID, Name, Merchandise__r.Name, Quantity__c, Line_Item_Total__c from Line_Item__c WHERE Invoice__c =: recordID ORDER BY Quantity__c ASC];
	}
}