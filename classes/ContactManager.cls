public without sharing class ContactManager {
    
    public static List<Contact> getByUsername (String username) {
        if(username == null || String.isBlank(username)) {
            return new List<Contact>();
        } else {
            List<Contact> contacts = [
            SELECT Id,
                    Name,                     
                    Username__c,
                    Email,
                    Password__c                    
            FROM Contact 
            WHERE Username__c =: username           
            ];
            return contacts;
        }        
    }
}
