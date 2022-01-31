public without sharing class EmailService {

    
    public static Messaging.SendEmailResult[] sendEmail (List<String> emails, String textEmail) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = emails;            
            message.subject = 'Password reminder';
            message.plainTextBody = textEmail;            
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            return results;
    }

    @AuraEnabled
    public static List<String> sendEmailForAuraEnabled (List<String> emails, String textEmail) {
        Messaging.SendEmailResult[] results = sendEmail(emails, textEmail);
        List<String> listResults = new List<String>();
        List<String> error = new List<String>();
        System.debug(results);
        for(Messaging.SendEmailResult result :results) {
            if(result.isSuccess()) {
                listResults.add(String.valueOf(result.isSuccess()));
            } else {
                listResults.add(result.getErrors().get(0).getMessage());
                 
            }
        }
        return listResults;
    }
}