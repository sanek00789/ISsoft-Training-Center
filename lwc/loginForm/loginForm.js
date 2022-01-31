import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { publish, MessageContext } from 'lightning/messageService';
import IS_VISIBLE_CHANNEL from '@salesforce/messageChannel/isVisibleMessageChannel__c';
import CONTACTS_CHANNEL from '@salesforce/messageChannel/contactsMessageChannel__c' 

import getByUsernameAndPassword from '@salesforce/apex/ContactManager.getByUsernameAndPassword';

export default class LoginForm extends LightningElement {
    username;
    password;
    contact;
    isVisibleForgotPasswordForm;
    isVisibleRegistrationForm = false;

    @wire(MessageContext)
    messageContext;

    handleUsernameChange(event) {
        this.username = event.detail.value;
        
    }

    handlePasswordChange(event) {
        this.password = event.detail.value;
    }

    handleLogin() {
        getByUsernameAndPassword({username: this.username, password: this.password})
        .then(result => {
            if(result.length > 0) {
                console.log(result);
                this.contact = result;
                this.showToastEvent('success', 'Success!', 'Сontact exists.')
                //console.log(this.contact[0].Id);
                console.log(this.contact);
                const message = {
                    contacts: this.contact          
                };
                publish(this.messageContext, CONTACTS_CHANNEL, message);                                              
            } else {
                this.showToastEvent('Error', 'Error!', 'Сontact does not exists.')
            }
            
        })
        .catch(error => {
            console.log(error);
            this.error = error;            
        });
    }

    showToastEvent(variant, title, message){
        const event = new ShowToastEvent({
            variant: variant,
            title: title,
            message: message                
        });
        this.dispatchEvent(event);
    }

    handleForgotPassword() {
        this.isVisibleForgotPasswordForm = true;
        const message = {
            isVisibleForgotPasswordForm: this.isVisibleForgotPasswordForm,
            //isVisibleregistrationForm: this.isVisibleRegistrationForm,
        };
        publish(this.messageContext, IS_VISIBLE_CHANNEL, message);
    }
    
    handleRegistration() {        
        if(!this.isVisibleRegistrationForm) {
            this.isVisibleRegistrationForm = true;            
        }    
        const message = {
            isVisibleRegistrationForm: this.isVisibleRegistrationForm            
        };
        publish(this.messageContext, IS_VISIBLE_CHANNEL, message);
    }
}