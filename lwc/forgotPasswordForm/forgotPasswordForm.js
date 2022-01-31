import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getByUsername from '@salesforce/apex/ContactManager.getByUsername';
import sendEmailForAuraEnabled from '@salesforce/apex/EmailService.sendEmailForAuraEnabled';

import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import IS_VISIBLE_CHANNEL from '@salesforce/messageChannel/isVisibleMessageChannel__c';

export default class ForgotPasswordForm extends LightningElement {
    username;
    contacts;
    textEmail = 'Password to enter your personal account: ';
    //isVisible = true;
    isVisible = false;
    subscription = null;
    
    @wire(MessageContext)messageContext;    


    handleUsernameChange(event) {
        this.username = event.detail.value;
    }

    handleRemind() {
        getByUsername({username :this.username})
        .then(result => {
            if(result.length > 0) {                
                console.log(result);
                this.contacts = result;
                this.sendEmail(this.contacts);                                
            } else {
                this.showToastEvent('Error', 'Error!', 'User with this username does not exist.')
            }
        })
        .catch(error => {
            this.error = error;
        });
    }
    
    sendEmail(contacts) {
        console.log('sendEmail' + contacts);
        console.log(contacts[0].Password__c);
        this.textEmail += contacts[0].Password__c;
        console.log(this.textEmail);
        let emailAddress = [contacts[0].Email];
        console.log(emailAddress);
        sendEmailForAuraEnabled({emails :emailAddress, textEmail :this.textEmail})
        .then(result => {
            //let sendEmailResult = JSON.parse(result);
            console.log('result= ' + result);
            //console.log(sendEmailResult);
            if(result[0] == 'true') {
                this.showToastEvent('success', 'Success!', 'Email send.');
                this.isVisible = false;
            } else {
                this.showToastEvent('Error', 'Error!', 'Email not send.')
            }            
            

        })
        .catch(error => {
            this.error = error;
            this.showToastEvent('Error', 'Error!', this.error)
        })
        
    }

    showToastEvent(variant, title, message){
        const event = new ShowToastEvent({
            variant: variant,
            title: title,
            message: message                
        });
        this.dispatchEvent(event);
    }
    
    handleBack() {
        this.isVisible = !this.isVisible;
    }

    subscribeToMessageChannel() {
        console.log(this.subscription);
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                IS_VISIBLE_CHANNEL,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }  
    }

    handleMessage(message) {    
        console.log(message);
        this.isVisible = message.isVisibleForgotPasswordForm;    
    }

    connectedCallback() {        
        this.subscribeToMessageChannel();
    }

}


/* List<Contact> contacts = ContactManager.getByUsername(contact.Username__c);                

        if (contacts.isEmpty()) {
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'User with this username does not exist.');
			ApexPages.addMessage(msg);
			return null;
		} else {            
            List<String> emailAddress = new List<String> {contacts[0].Email};            
            String textEmail = 'Password to enter your personal account: ' +  contacts[0].Password__c;
            Messaging.SendEmailResult[] result = EmailService.sendEmail(emailAddress, textEmail);   */