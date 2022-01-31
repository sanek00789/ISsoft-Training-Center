public without sharing class ContactManager {
    
    @AuraEnabled(cacheable=true)    
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

    @AuraEnabled(cacheable=true)
    public static List<Contact> getFiveLast () {
        return [SELECT Name FROM Contact ORDER BY CreatedDate DESC LIMIT 5];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getByUsernameAndPassword (String username, String password) {
        if(String.isBlank(username) || username == null || password == null || String.isBlank(password)) {
            return new List<Contact>();
        }
        List<Contact> contact = [
            SELECT Id, 
                    Name, 
                    Username__c, 
                    Password__c 
            FROM Contact 
            WHERE Username__c =: username AND Password__c =: password
            LIMIT 1
        ];
        return contact;
    }
    
}
