public with sharing class HomePageController {
    public List<Contact> contacts {get;set;}
    public Contact contact {get;set;}
    public String contactId {get;set;}    
    
    public HomePageController() { 
        contactId = ApexPages.currentPage().getParameters().get('id');        
    }

    public PageReference getContact() {  
        contact = [
            SELECT Id, Name
            FROM Contact 
            WHERE Id =: contactId            
        ][0];                
        return null;
    }    
    
    public PageReference logOut() {         
        PageReference loginPageReference = new PageReference('/apex/LoginPage');
        return loginPageReference.setRedirect(true); 
    }    
}