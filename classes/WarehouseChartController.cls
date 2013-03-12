public with sharing class WarehouseChartController {
		public ID invoiceID {get; set;}
	    public WarehouseChartController() {}
		
	    public List<pieData> getData() {
	    	  List<AggregateResult> LineItems = [select SUM(Line_Item_Total__c) total, Merchandise__r.Name merch from Line_Item__c where Invoice__c = :invoiceID Group By Merchandise__r.Name];

	          List<pieData> data = new List<pieData>();
			  for(AggregateResult a : LineItems) {
	          	data.add(new pieData(String.valueOf(a.get('merch')),Integer.valueOf(a.get('total'))));
				}	
			  return data;
			  }

	    public class pieData {
	        public String name { get; set; }
	        public Integer data { get; set; }

	        public pieData(String name, Integer data) {
	            this.name = name;
	            this.data = data;
	        }
	    }
	
	
	
		@isTest
		static public void testChartController() {
			//WarehouseUtil.createBaselineData();
			WarehouseChartController wcc = new WarehouseChartController();
			wcc.getData();
		}
	
	
	}