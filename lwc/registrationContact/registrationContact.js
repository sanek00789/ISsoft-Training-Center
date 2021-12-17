import { LightningElement } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//import { createRecord } from "lightning/uiRecordApi";
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import USERNAME_FIELD from '@salesforce/schema/Contact.Username__c';
import PASSWORD_FIELD from '@salesforce/schema/Contact.Password__c';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class RegistrationContact extends LightningElement {
    contactObject = CONTACT_OBJECT;
    myFields = [FIRSTNAME_FIELD, LASTTNAME_FIELD, USERNAME_FIELD, PASSWORD_FIELD, EMAIL_FIELD];

    handleContactCreated(event){
        const evt = new ShowToastEvent({
            title: 'Successfully',
            message: 'Contact created. Record ID: ' + event.detail.id,            
            variant: 'success',
        });
        this.dispatchEvent(evt);        
    }

    handleCancel(event){
        console.log(event.type);
    }       
}