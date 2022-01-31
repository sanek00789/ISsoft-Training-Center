import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//import { createRecord } from "lightning/uiRecordApi";
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import USERNAME_FIELD from '@salesforce/schema/Contact.Username__c';
import PASSWORD_FIELD from '@salesforce/schema/Contact.Password__c';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';
import IS_VISIBLE_CHANNEL from '@salesforce/messageChannel/isVisibleMessageChannel__c';

export default class RegistrationContact extends LightningElement {
    contactObject = CONTACT_OBJECT;
    myFields = [FIRSTNAME_FIELD, LASTTNAME_FIELD, USERNAME_FIELD, PASSWORD_FIELD, EMAIL_FIELD];
    isVisible = false;
    subscription =null;

    @wire(MessageContext)messageContext;

    handleContactCreated(event){
        const fields = event.detail.fields;
        console.log( "Fields: ", fields );
        console.log('d');
        const evt = new ShowToastEvent({
            title: 'Successfully',
            message: 'Contact created. Record ID: ' + event.detail.id,            
            variant: 'success',
        });
        this.dispatchEvent(evt);
        this.handleReset();
        //his.isVisible = false;        
    }

    connectedCallback() {
        console.log('Loading registration Form');
        this.subscribeToMessageChannel();
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
        //console.log(this.subscription);s           
    }

    handleMessage(message) {    
        //console.log(message);
        this.isVisible = message.isVisibleRegistrationForm;    
    }

    handleBack() {
        this.isVisible = !this.isVisible;    
    }

    handleReset(event) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }
}