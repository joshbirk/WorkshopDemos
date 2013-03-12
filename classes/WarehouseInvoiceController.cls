public with sharing class WarehouseInvoiceController {
	
	public Line_Item__c new_line_item {get; set;}
	public List<Line_Item__c> line_items {get; set;}
	public Integer current_offset {get; set;}
	
	public Integer page_number {get; set;}
	public Integer page_count {get; set;}
	
	private Id invoice_id;
	
	public WarehouseInvoiceController() {}
	public WarehouseInvoiceController(ApexPages.StandardController stc) {
		current_offset = 0;
		page_number = 1;
		
		invoice_id = stc.getRecord().Id;
		updateLineItemPages();
		new_line_item = new Line_Item__c(Invoice__c = invoice_id);
	}
	
	
	public void updateLineItemPages() {
		line_items = [SELECT ID, Name, Quantity__c, Merchandise__r.Name, Unit_Price__c from Line_Item__c WHERE Invoice__c = :invoice_id LIMIT 5 OFFSET :current_offset ];
		page_count = [SELECT COUNT() from Line_Item__c WHERE Invoice__c = :invoice_id];
		page_count = page_count / 5;
		page_count++;
	}
	
	public PageReference insertNewLineItem() {
		insert new_line_item;
		new_line_item = new Line_Item__c(Invoice__c = invoice_id);
		updateLineItemPages();
		
		return null;
	}
	
	public PageReference updateLineItems() {
		update line_items;
		return null;
	}
	

	
	

}