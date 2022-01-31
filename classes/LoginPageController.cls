public class LoginPageController {
    public String userName {get; set;}
    public String password {get; set;}
    public Boolean getInput {get;set;}
    public Boolean ischeck {get;set;}
    public List<Contact> contact {get;set;}

    public loginPageController() {
        getInput = true;
        contact = new List<Contact>();
        //urlToken = URL.getCurrentRequestUrl().getQuery();        
        //urlToken = URL.getCurrentRequestUrl().getAuthority();
        //urlToken = 'hi';
        //urlToken = ApexPages.currentPage().getUrl();
        //urlToken = ApexPages.currentPage().getAnchor();
        //urlToken = URL.getCurrentRequestUrl().getRef();
    }
    
    public PageReference  getUsernameAndPassword() {       
        contact = [
            SELECT Id, 
                    Name, 
                    Username__c, 
                    Password__c 
            FROM Contact 
            WHERE Username__c =: userName AND Password__c =: password
            LIMIT 1
        ];
        
        if(!(!contact.isEmpty() && contact.size() > 0)){
            getInput = false;                        
            return null;
        }else{
            getInput = true;                        
            pageReference homePageReference = new pageReference('/apex/HomePage?Id=' + contact[0].Id);
            return homePageReference.setRedirect(true);           
        }        
    }

    public PageReference registration() {         
        PageReference registrationPageReference = new PageReference('/apex/RegistrationPage');
        return registrationPageReference.setRedirect(true); 
    }

    public PageReference forgotPassword() {         
        PageReference forgotPasswordPageReference = new PageReference('/apex/ForgotPasswordPage');
        return forgotPasswordPageReference.setRedirect(true); 
    }
}