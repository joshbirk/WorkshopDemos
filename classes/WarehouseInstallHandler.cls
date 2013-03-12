global with sharing class WarehouseInstallHandler implements InstallHandler, UninstallHandler {

	global WarehouseInstallHandler() {}
	
	global void onInstall(InstallContext ctx) {
		if(ctx.previousVersion() == null) {
		      WarehouseStreaming.createWarehouseTopic();

		      User u = [Select Id, Email from User where Id =:ctx.installerID()];   
		      String toAddress= u.Email;
		      String[] toAddresses = new String[]{toAddress};
		      Messaging.SingleEmailMessage mail = 
		        new Messaging.SingleEmailMessage();
		      mail.setToAddresses(toAddresses);
		      mail.setReplyTo('support@package.dev');
		      mail.setSenderDisplayName('My Package Support');
		      mail.setSubject('Package install successful');
		      mail.setPlainTextBody('Thanks for installing the package.');
		      Messaging.sendEmail(new Messaging.Email[] { mail });
		    
		  	  }
		    else if(ctx.previousVersion().compareTo(new Version(1,0)) == 0) {
		    
		      }
		    if(ctx.isUpgrade()) {
		   
		      }
		    if(ctx.isPush()) {
		    
		      }
		    }
		
	global void onUninstall(UninstallContext ctx) {
			    User u = [Select Id, Email from User where Id =:ctx.uninstallerID()];   
			    String toAddress= u.Email;
			    String[] toAddresses = new String[] {toAddress};
			    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			    mail.setToAddresses(toAddresses);
			    mail.setReplyTo('support@package.dev');
			    mail.setSenderDisplayName('My Package Support');
			    mail.setSubject('Package uninstall successful');
			    mail.setPlainTextBody('Thanks for uninstalling the package.');
			    Messaging.sendEmail(new Messaging.Email[] { mail }); 
			  }
			
	@isTest(SeeAllData=true)
	static void testUninstallScript() {
	  Test.testInstall(new WarehouseInstallHandler(), null);
      Test.testInstall(new WarehouseInstallHandler(), new Version(1,0), true);
	
	  Test.testUninstall(new WarehouseInstallHandler());
	}

}