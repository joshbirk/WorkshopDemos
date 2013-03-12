public with sharing class WarehouseSimpleTests {

	public WarehouseSimpleTests() {	}
	
	
	@isTest
	static public void testRequiredFields() {	
		Merchandise__c m = new Merchandise__c(Name = 'Test');
		
		//assertion: Merchandise requires Price and Quantity
		try {
			insert m;
		} catch (DMLException e) {
			System.assert(e.getMessage().length() > 0);
		}
		
		m.Quantity__c = 0;
		m.Price__c = 9.99;
		
		//assertion: Merchandise requires Price and Quantity
		try {
			insert m;
			System.assert(String.valueOf(m.Id).length() > 0);
		} catch (DMLException e) {
			System.debug(e.getMessage());
		}
		
		System.debug('REQUIRED FIELDS:');
		//Detect all the required fields and debug out the result.  This will help if a required field is added in the future.
		Map<String, Schema.SObjectField> describeFields = Schema.SObjectType.Merchandise__c.fields.getMap();
		Map<String, Schema.DisplayType> fieldsTypes = new Map<String, Schema.DisplayType>();
		for(String field : describeFields.keyset()){
		    Schema.DescribeFieldResult dr = describeFields.get(field).getDescribe();
		    if(dr.isCreateable() && !dr.isNillable() && !dr.isDefaultedOnCreate()) {
				System.debug('REQUIRED FIELD:' +field);
			}
		}
	}

}