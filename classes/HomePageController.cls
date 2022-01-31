public without sharing class HomePageController {
    public List<Contact> contacts {get;set;}
    public Contact contact {get;set;}
    public String contactId {get;set;}
    public List<Order__c> orders {get;set;}
    public String selectedPrice {get;set;}
    public String selectedPriority {get;set;}
    public String selectedCarOwner {get;set;}  
    public List<wrapOrder> wrapOrderList {get; set;}
    public List<Order__c> selectedOrders{get;set;}
    public List<SelectOption> options {get;set;}
    public String urlPage {get;set;}
    public String urlToken {get;set;}
    public String accessToken {get;set;}
    public String anchorElement {get;set;}
    public String code {get;set;}


    public String inputText {get; set;}

    public void updateCurrentRecord(){
            String token = inputText.split('&')[0];
            List<String> tokenList = token.split('=');

            inputText = tokenList[tokenList.size()-1];
            ApexPages.addMessage(
                    New ApexPages.Message(
                            ApexPages.Severity.INFO, 'You entered ' + inputText
                    )
            );
        

    }
    
    
    public HomePageController() { 
        contactId = ApexPages.currentPage().getParameters().get('id');
        selectedPrice = 'None';
        selectedPriority = 'None';
        urlPage = 'https://brest-carservice-developer-edition.ap27.force.com/HomePage?Id=';
        //urlPage = 'https://brest-carservice-developer-edition.ap27.force.com/LoginPage';
        
        //urlToken = 'hi';
        //urlToken = ApexPages.currentPage().getRef();
        urlToken = ApexPages.currentPage().getUrl();
        //urlToken = ApexPages.currentPage().getAnchor();
        //urlToken = URL.getCurrentRequestUrl().toExternalForm();
        //urlToken = URL.getCurrentRequestUrl().getQuery();        
        //accessToken = ApexPages.currentPage().getParameters().get('access_token');

        
        anchorElement = '';
        //accessToken = '';
        

        //urlPage = 'https://empathetic-hawk-3u50k7-dev-ed--c.visualforce.com/apex/HomePage?Id=';
        filterMethod();        
    } 
    
    public PageReference getUrlToken()    {
        
        return null;
    }
    

    
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Order and a Boolean value
    public class wrapOrder {
        public Order__c ord {get; set;}
        public Boolean selected {get; set;}
        public Boolean disabled {get; set;}        
 
        //This is the contructor method. When we create a new wrapAccount object we pass a Orderr that is set to the acc property. We also set the selected value to false
        public wrapOrder(Order__c o) {
            ord = o;            
            disabled = true;
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
        wrapOrderList = new List<wrapOrder>();
            
        for(Order__c order: orders) {
            WrapOrder newWrapOrder=  new wrapOrder(order);
            if(order.Car_Owner__c != null) {
                newWrapOrder.selected = true;
            } else {
                newWrapOrder.selected = false;
            }            
            wrapOrderList.add(newWrapOrder);
        } 
    }    
    

    public void processSelected() {
        
        selectedOrders = new List<Order__c>();
    
            for(wrapOrder wrapOrderObj : wrapOrderList) {
                if(wrapOrderObj.selected == true && !wrapOrderObj.disabled) {
                    selectedOrders.add(wrapOrderObj.ord);
                }
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

    public void visibilityCheckbox() {
        if (selectedCarOwner != 'None') { 
            for(wrapOrder wrapOrd : wrapOrderList) {
                if(wrapOrd.ord.Car__r.Contact__c == selectedCarOwner) {
                    wrapOrd.disabled = false;
                } else {
                    wrapOrd.disabled = true;
                }                
            }
        } else {
            for(wrapOrder wrapOrd : wrapOrderList) {                
                wrapOrd.disabled = true;              
            }
        }
    }
    
    public PageReference assignCarOwner() {        
        selectedOrders = new List<Order__c>();
    
        for(wrapOrder wrapOrderObj : wrapOrderList) {
            if(wrapOrderObj.selected == true && !wrapOrderObj.disabled) {                
                wrapOrderObj.ord.Car_Owner__c = selectedCarOwner;
                selectedOrders.add(wrapOrderObj.ord);
            }
        }
        List<Database.SaveResult> result = Database.update(selectedOrders);
        System.debug(result);
        System.debug(result[0]);
        if (result[0].isSuccess()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Car owner has been successfully assigned.');
            ApexPages.addMessage(msg);
            return null;
        } else {
            String errMessage = 'Problems with assignment: ' + result[0].getErrors();
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, errMessage);
            ApexPages.addMessage(msg);
            return null;
        } 
    }
    public PageReference a() {
        //PageReference a = new PageReference('https://oauth.vk.com/authorize?client_id=8022717&display=page&redirect_uri=https://brest-carservice-developer-edition.ap27.force.com/HomePage?Id=0035j000006WGB2AAO&scope=friends,wall&response_type=token&v=5.131');
        //return a;

        //contactId = ApexPages.currentPage().getParameters().get('id');
        String urlRequest = 'https://oauth.vk.com/authorize?client_id=8022717&display=page&redirect_uri=' + urlPage + contactId + '&scope=friends,wall&response_type=token&v=5.131';
        //String urlRequest = 'https://oauth.vk.com/authorize?client_id=8022717&display=page&redirect_uri=' + urlPage + '&scope=friends,wall&response_type=token&v=5.131';

        System.debug(urlRequest);
        PageReference a = new PageReference(urlRequest);
        //accessToken = ApexPages.currentPage().getParameters().get('access_token');
        //PageReference a = new PageReference('https://oauth.vk.com/authorize?client_id=8022717&display=page&redirect_uri=https://brest-carservice-developer-edition.ap27.force.com/HomePage?Id=0035j000006WGB2AAO&scope=friends,wall&response_type=token&v=5.131');
        
        return a;
    }
    
   

    public void calloutVKa() {
        
        
        
        //String endPoint = 'https://api.vk.com/method/friends.getOnline?user_id=18799794&message=Test&access_token=' + inputText + '&v=5.131';
        String endPoint = 'https://api.vk.com/method/friends.getOnline?user_id=18799794&message=Test&access_token=dc722010e1724dcdc84d6ac4a4e8af6f8dceb129f907646daf662310888135fbe0d34e59c3ba8ed672e01&v=5.131';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //request.setEndpoint('https://api.vk.com/method/friends.search?user_id=18799794&message=Test&access_token=04655ec77280df555be431af7777e802d1cc3a1c57996d58d909a796154a3669b4cdf0afd54cc3a752ba3&v=5.131');
        request.setEndpoint(endPoint);
        //request.setEndpoint('https://oauth.vk.com/authorize?client_id=8022717&display=page&redirect_uri=&scope=friends,wall&response_type=token&v=5.131');




        
        //Http http = new Http();
        //HttpRequest request = new HttpRequest();
        //request.setEndpoint('https://api.vk.com/method/friends.search?user_id=18799794&message=Test&access_token=04655ec77280df555be431af7777e802d1cc3a1c57996d58d909a796154a3669b4cdf0afd54cc3a752ba3&v=5.131');
        //request.setEndpoint('https://api.vk.com/method/wall.post?user_id=18799794&message=Test&access_token=37fa217612c7b44955022ec5eef1903d3c1d7778749922be98839795d5c8ec5fdadb67863e3abeec03a02&v=5.131');
        //request.setEndpoint('https://oauth.vk.com/authorize?client_id=8022717&display=page&redirect_uri=&scope=friends,wall&response_type=token&v=5.131');
        
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        string xmlresponse=response.getBody();
        String req = request.toString();
        
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {

            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, xmlresponse);
            ApexPages.addMessage(msg);
            //return null;
        }
            
        //return null;
    }
    
    

    public PageReference calloutVK() {
        code = ApexPages.currentPage().getParameters().get('code');
        if(code == null || String.isBlank(code)) {
            //String blank = 'https://oauth.vk.com/blank.html';
            String urlRequest = 'https://oauth.vk.com/authorize?client_id=8022717&display=page&redirect_uri=' + urlPage + contactId + '&scope=friends,wall&response_type=code&v=5.131';
            //String urlRequest = 'https://oauth.vk.com/authorize?client_id=8022717&display=page&redirect_uri=' + blank + '&scope=friends,wall,messages&response_type=code&v=5.131';
            System.debug(urlRequest);
            /* ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, code);
            ApexPages.addMessage(msg); */
            PageReference a = new PageReference(urlRequest);
            
            System.debug(code);
            return a;
        } else {
            System.debug(code);
            accessToken = ApexPages.currentPage().getParameters().get('access_token');
            String urlRequest = 'https://oauth.vk.com/access_token?client_id=8022717&client_secret=iyn2bJYi2kiVAiTpFqD7&redirect_uri=' + urlPage + contactId + '&code=' + code;

            System.debug(urlRequest);
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, code);
            ApexPages.addMessage(msg);
            PageReference a = new PageReference(urlRequest);
            return a;
            //getAccessToken();
            //return null;
        }
           
        
    }
    public PageReference getAccessToken() {        
        return null;
    }
}