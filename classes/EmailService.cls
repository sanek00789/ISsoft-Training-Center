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
}