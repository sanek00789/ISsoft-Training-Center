public without sharing class HomePageController {
    public List<Contact> contacts {get;set;}
    public Contact contact {get;set;}
    public String contactId {get;set;}
    public List<Order__c> orders {get;set;}
    public String selectedPrice {get;set;}
    public String selectedPriority {get;set;}
    public String selectedCarOwnewr {get;set;}  
    public List<wrapOrder> wrapOrderList {get; set;}
    public List<Order__c> selectedOrders{get;set;} 
    
    public HomePageController() { 
        contactId = ApexPages.currentPage().getParameters().get('id');
        orders = OrderManager.getOrderSortByName();        

        if(wrapOrderList == null) {
            wrapOrderList = new List<wrapOrder>();
            for(Order__c order: orders) {
                // As each Account is processed we create a new wrapAccount object and add it to the wrapAccountList
                wrapOrderList.add(new wrapOrder(order));
            }
        }
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
    
    public void filterMethod() {  
        orders = OrderManager.filterByParam(selectedPrice, selectedPriority);
        wrapOrderList.clear();
        for(Order__c order: orders) {
            // As each Orders is processed we create a new wrapOrder object and add it to the wrapOrderList
            wrapOrderList.add(new wrapOrder(order));
        }        
    }
    
    public void processSelected() {
        selectedOrders = new List<Order__c>();
    
            for(wrapOrder wrapOrderObj : wrapOrderList) {
                if(wrapOrderObj.selected == true) {
                    selectedOrders.add(wrapOrderObj.ord);
                }
            }
    }    
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Order and a Boolean value
    public class wrapOrder {
        public Order__c ord {get; set;}
        public Boolean selected {get; set;}
 
        //This is the contructor method. When we create a new wrapAccount object we pass a Orderr that is set to the acc property. We also set the selected value to false
        public wrapOrder(Order__c o) {
            ord = o;
            selected = false;
        }
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        List<Contact> contacts = [
            SELECT Name FROM Contact ORDER BY CreatedDate DESC LIMIT 4
        ];
        options.add(new SelectOption('None', 'None'));
        for(Contact contact: contacts) {
            options.add(new SelectOption(contact.Id, contact.Name));
        }        
        return options;
    }
}