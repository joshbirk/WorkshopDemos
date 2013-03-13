global with sharing class WarehouseServiceRequest implements Messaging.InboundEmailHandler {

	global WarehouseServiceRequest() {}

	//-- Inbound Email		
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
		       //inboundEmail has:
		       //binaryAttachments, textAttachments, 
			   //ccAddresses, fromAddress, fromName, replyTo, subject,  toAddresses,
			   //htmlBodyIsTruncated, inReplyTo, messageId, plainTextBody, plainTextBodyIsTruncated, references, headers, htmlBody 

			   Merchandise__c associated = [SELECT ID, Name from Merchandise__c WHERE NAME =: email.subject];
			   Case c = new Case(Subject=email.subject,Description=email.plainTextBody,Merchandise__c=associated.Id);
			   insert c;
			   List<String> responder = new List<String>();
			   responder.add(email.fromAddress);
			   sendEmail('Case created for '+email.subject,'A case has been created for the following issue:\n'+email.plainTextBody,responder,false);
			
			
			   Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
		       result.success = true;
		       return result; 
		       }
		
	//-- Outbound Email	
	static global Boolean sendEmail(String subject, String body, List<String> toAddresses, Boolean isHTML) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setToAddresses(toAddresses);
		        mail.setSubject (subject);  
		        if(isHTML) {
					mail.setHTMLBody(body);
				} else {
					mail.setPlainTextBody(body);
				}	
		        Messaging.SendEmailResult []r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
				return r[0].isSuccess();
			}
}
