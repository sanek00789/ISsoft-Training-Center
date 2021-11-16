public with sharing class HomePageController {
    
    public HomePageController(ApexPages.StandardController stdController) {        
    }
    
    public PageReference logOut() {         
        PageReference loginPageReference = new PageReference('/apex/LoginPage');
        return loginPageReference.setRedirect(true); 
    }    
}