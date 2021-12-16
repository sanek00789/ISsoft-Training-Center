@RestResource(urlMapping='/Contact/*')
global without sharing class ContactRestService {
    public static final Integer STATUS_CODE_409 = 409;
    public static final Integer STATUS_CODE_200 = 200;
    public static final String USERNAME_EXISTS = 'This username already exists';
    

    @HttpPost
    global static void createContact(String lastName, String username, String password) {
        RestResponse res = RestContext.response;
        Contact newContact = new Contact(
            LastName = lastName,
            Username__c = username,
            Password__c = password
            );
        List<Contact> contacts = ContactManager.getByUsername(username);
        if(!contacts.isEmpty()){
            res.statusCode = STATUS_CODE_409;
            res.responseBody = Blob.valueOf(USERNAME_EXISTS);
        } else {
            insert newContact;
            res.statusCode = STATUS_CODE_200;
            res.responseBody = Blob.valueOf(newContact.Id);                    
        }        
    }
}
