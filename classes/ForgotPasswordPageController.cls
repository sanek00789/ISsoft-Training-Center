public without sharing class ForgotPasswordPageController {
    public Contact contact {get;set;}
    
    public ForgotPasswordPageController() {
        contact = new Contact();
    }

    public PageReference remind() {        
        List<Contact> contacts = ContactManager.getByUsername(contact.Username__c);                

        if (contacts.isEmpty()) {
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'User with this username does not exist.');
			ApexPages.addMessage(msg);
			return null;
		} else {            
            List<String> emailAddress = new List<String> {contacts[0].Email};            
            String textEmail = 'Password to enter your personal account: ' +  contacts[0].Password__c;
            Messaging.SendEmailResult[] result = EmailService.sendEmail(emailAddress, textEmail);  
           
            if (result[0].isSuccess()) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'An email was sent to the email address specified for this account.');
                ApexPages.addMessage(msg);
                return null;
            } else {
                String errMessage = 'Problems sending email: ' + result[0].getErrors();
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, errMessage);
                ApexPages.addMessage(msg);
                return null;
            }            
        }
    }

    public PageReference back() {         
        PageReference loginPageReference = new PageReference('/apex/LoginPage');
        return loginPageReference.setRedirect(true); 
    }
}
