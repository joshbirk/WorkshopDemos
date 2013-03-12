global with sharing class WarehouseUtil implements Database.Batchable<sObject>, Schedulable {
    
    global Integer deletedRecordCount = 0;
    
    //General constructor
    global WarehouseUtil() {}
    
    //Scheduled execute
    global void execute(SchedulableContext ctx) {
        WarehouseUtil.checkForDatedInvoices();      
    }
    
    //Batch execute 
    global Database.QueryLocator start(Database.BatchableContext BC){
            return Database.getQueryLocator('SELECT ID FROM Invoice__c WHERE Status__c = \'Closed\' AND CreatedDate < LAST_90_DAYS');
           }
    global void execute(Database.BatchableContext BC, List<sObject> scope) { 
            deletedRecordCount += scope.size();
            delete scope; 
        }
    global void finish(Database.BatchableContext BC) { sendDeletedRecordsNotice(deletedRecordCount); deletedRecordCount = 0; }
    
    
    
    //Data checking utilties
    static public Boolean checkForDatedInvoices() {
        List<Invoice__c> datedInvoices = [SELECT ID, Name, CreatedDate from Invoice__c WHERE Status__c = 'Open' AND CreatedDate < LAST_90_DAYS];
        for(Invoice__c di : datedInvoices) {
            di.Status__c = 'Archived';
        }
        WarehouseUtil.sendDatedNotice(datedInvoices);
        update datedInvoices;
        
        return false;
    }
    
    
    //Email utilities
    static public Boolean sendDatedNotice(List<Invoice__c> datedInvoices) {
        if(datedInvoices.size() == 0) { return false; }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String body = '<h2>'+datedInvoices.size()+' have been found</h2>';
        for (Invoice__c i : datedInvoices) {
            body += '<a href=/'+i.Id+'>'+i.Name+'</a> ('+i.CreatedDate.format()+')';
        }
        
        mail.setToAddresses(Label.emaillist.split(','));
        mail.setSubject ('[Warehouse] Dated Invoices');  
        mail.setHTMLBody(body);
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        return r[0].isSuccess();
    }
    
    static public Boolean sendDeletedRecordsNotice(Integer count) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String body = count+' closed records older than 90 days have been deleted';
        mail.setToAddresses(Label.emaillist.split(','));
        mail.setSubject ('[Warehouse] Dated Invoices');  
        mail.setPlainTextBody(body);
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        return r[0].isSuccess();
    }
    
    //Data manipulation utilities
    static public Boolean createBaselineData() {
        Merchandise__c m = new Merchandise__c(Name='Rack Server',Price__c=1245.99,Quantity__c=500);
        insert m;
        
        Invoice__c i = new Invoice__c();
        insert i;
        
        Line_Item__c li = new Line_Item__c(Name='1',Quantity__c=10,Merchandise__c=m.Id,Invoice__c=i.Id);
        insert li;
        
        return true;    
    }
    
    
    static public Boolean enterDataFromText(String dataString) {
        List<String> data = dataString.split('\n');
        List<Merchandise__c> merch= new List<Merchandise__c>();
        for(String s : data) {
            List<String> objectData = s.split(',');
            Merchandise__c m = new Merchandise__c(Name=objectData[0].replaceAll('"',''),Quantity__c=Decimal.valueOf(objectData[1]),Price__c=Decimal.valueOf(objectData[2]));
            merch.add(m);
        }
        try {
            insert merch;
            return true;
        } catch(DMLException d) {
            return false;
        }
        
    }
    
    
    
    //Test Email Utility
    @isTest
    static public void testDatedInvoices() {
        //CreatedDate cannot be written, but it can be imported
        List<Invoice__c> invoices = Test.loadData(Invoice__c.sObjectType, 'InvoiceData');
        update invoices;
    
        System.assertEquals(WarehouseUtil.checkForDatedInvoices(),true);
        
        invoices[0].Status__c = 'Closed';
        update invoices;
        
        System.assertNotEquals(WarehouseUtil.checkForDatedInvoices(),true);
        
        
        Test.StartTest();
            System.schedule('testSchedule','0 0 13 * * ?',new WarehouseUtil());
            ID batchprocessid = Database.executeBatch(new WarehouseUtil());
        Test.StopTest();
        
        invoices = [SELECT ID FROM Invoice__c];
        System.assertEquals(invoices.size(),0);
    }
    
    

}