global with sharing class WarehouseEmailRequest implements Messaging.InboundEmailHandler {
	     global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
	                                                       Messaging.InboundEnvelope env){

		       Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
		       String bEmail = email.fromAddress;
		       String bsid = email.Subject;                                                    
		       WarehouseEmailRequest.acceptEmail(bEmail,bsid);                                                    

		       result.success = true;
		       return result; 
		       }
		
		global static void acceptEmail(String bEmail, String mname) {
			String like_filter = '%'+mname+'%';
			List<Merchandise__c> merch = [SELECT Id, Name, Quantity__c from Merchandise__c WHERE Name LIKE :like_filter];
			String response = '';
			
			if(merch.size() == 0) { 
				response = 'No merchandise with that ID found.'; 
				} else {
				for(Merchandise__c m : merch) {
					response += 'Resulting Merchandise:\n';
					response += 'ID:'+m.ID+'\n';
					response += 'Name:'+m.Name+'\n';
					response += 'Quantity:'+m.Quantity__c+'\n';
					response += '\n\n';
				}
		
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		                List<String> tos = new List<String>();
		                if(bEmail.contains(',')) { 
		                    tos = bEmail.split(','); 
		                } else { tos.add(bEmail); }
		                mail.setToAddresses(tos);
		                mail.setSubject ('[WAREHOUSE] Result for ' + mname);  
		                mail.setPlainTextBody(response);

		                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
					}
		}

}