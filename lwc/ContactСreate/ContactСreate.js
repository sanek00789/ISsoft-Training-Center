import { LightningElement } from 'lwc';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import USERNAME_FIELD from '@salesforce/schema/Contact.Username__c';
import PASSWORD_FIELD from '@salesforce/schema/Contact.Password__c';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

/**
 * Creates Account records.
 */
export default class ContactCreate extends LightningElement {

    contactObject = CONTACT_OBJECT;
    myFields = [FIRSTNAME_FIELD, LASTTNAME_FIELD, USERNAME_FIELD, PASSWORD_FIELD, EMAIL_FIELD];

    handleContactCreated(event){
        const evt = new ShowToastEvent({
            title: 'Contact created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
}