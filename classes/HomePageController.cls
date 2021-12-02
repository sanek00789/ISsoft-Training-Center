public without sharing class HomePageController {
    public List<Contact> contacts {get;set;}
    public Contact contact {get;set;}
    public String contactId {get;set;}
    public List<Order__c> orders {get;set;}
    public String selectedField1 {get;set;}
    public String selectedField2 {get;set;} 
    public List<Order__c> selectOrders {get;set;}   
    
    public HomePageController() { 
        contactId = ApexPages.currentPage().getParameters().get('id');
        orders = OrderManager.getOrderSortByName();               
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
    
    public void sortMethod() {  
        orders = OrderManager.sortByField(orders, selectedField1, selectedField2);        
    }
}