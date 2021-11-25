public without sharing class RegistrationPageController {

    public Contact contact {get;set;}
    private List<Contact> contacts {get;set;}
       
    public RegistrationPageController() {
        contact = new Contact();
    }  

    public PageReference save() {
        List<Contact> contacts = ContactManager.getByUsername(contact.Username__c);
        if (String.isBlank(contact.Lastname) || String.isBlank(contact.Username__c) || String.isBlank(contact.Password__c)) {
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill in the required fields marked with *.');
			ApexPages.addMessage(msg);
			return null;
		} else  if (!contacts.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A contact with same username already exists.');
			ApexPages.addMessage(msg);
			return null;
        } else {
            insert contact;                           
            return Page.LoginPage;			
        }
    }
    
    public PageReference back() {         
        PageReference loginPageReference = new PageReference('/apex/LoginPage');
        return loginPageReference.setRedirect(true); 
    }
}