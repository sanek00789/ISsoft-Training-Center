import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import filterByParam from '@salesforce/apex/OrderManager.filterByParam';
import getFiveLast from '@salesforce/apex/ContactManager.getFiveLast';
import upadateOrders from '@salesforce/apex/OrderManager.upadateOrders';

import CONTACTS_CHANNEL from '@salesforce/messageChannel/contactsMessageChannel__c';
import { subscribe, MessageContext, APPLICATION_SCOPE } from 'lightning/messageService';

const SUCCESS_TITLE = 'Success';
const SUCCESS_VARIANT = 'success';
const ERROR_TITLE   = 'Error';
const ERROR_VARIANT = 'error';
const INFO_TITLE   = 'Info';
const INFO_VARIANT = 'info';
const MESSAGE_SELECT_A_CONTACT = 'Select a contact';

const columns = [
    { label: 'Name', fieldName: 'OrderURL', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'} },
    { label: 'Car Owner', fieldName: 'Car_Owner' },
    { label: 'Master', fieldName: 'Master'},
    { label: 'Price', fieldName: 'Price', type: 'currency'},
    //{ label: 'Car', fieldName: 'Car__c' },
    { label: 'End Date', fieldName: 'End_Date', type: 'date'},
    { label: 'Priority', fieldName: 'Priority'},
];

export default class TableWithSortingForm extends LightningElement {
    contact;    
    orders = [];
    isVisible = false;
    columns = columns;
    valuePrice = 'None';
    valuePriority = 'None';    
    subscription = null; 
    valueContact = '';                         
    optionsContact = '';
    selectedRows = [];
    urlPage = null;
    aToken = null;

    get optionPrices() {
        return [
            { label: 'None', value: 'None' },
            { label: '< 100$', value: '< 100' },
            { label: '100$-300$', value: '>= 100 AND Price__c <= 300' },
            { label: '> 300$', value: '> 300' },
        ];
    }

    get optionPriorities() {
        return [
            { label: 'None', value: 'None' },
            { label: 'Low', value: 'Low' },
            { label: 'Normal', value: 'Normal' },
            { label: 'Hight', value: 'Hight' },
        ];
    }

    @wire(MessageContext)messageContext; 

    @wire (filterByParam, {selectedPrice: '$valuePrice', selectedPriority: '$valuePriority'})    
    wiredOrders(result) {
        this.wiredOrderList = result;
        this.allProducts = [];
        
        if(result.data) {   
            for (let i = 0; i < result.data.length; i++) {
                let order = result.data[i];               

                this.allProducts = [
                    ...this.allProducts,
                    Object.assign(
                        {
                            Name: order.Name,
                            Car_Owner: order.Car_Owner__r === undefined ? ' ' : order.Car_Owner__r.Name,
                            //OrderURL: '/lightning/r/Order__c/' + order.Id + '/view',
                            OrderURL: '/' + order.Id,
                            Master: order.Master__r.Name,                            
                            Price: order.Price__c,
                            End_Date: order.End_Date__c,
                            Priority: order.Priority__c,                            
                        },
                        order
                    )
                ];
            }        
            this.orders = this.allProducts;
            this.error = undefined;
            this.changeSelectRows(this.orders);
        } else if(result.error) {
            this.error = result.error.message;                       
        }  
    }

    @wire(getFiveLast, {})
      contactName({ error, data }) {
      if (data) {
        this.optionsContact = data.map(name => {          
          return { label: name.Name, value: name.Id };
        });
        this.optionsContact.unshift({ label: 'None', value: '' });
      } else if (error) {
        this.optionsContact = undefined;
        this.error = error;
      }
    }    

    handleChangePrice(event) {
        this.valuePrice = event.detail.value;        
    }

    handleChangePriority(event) {
        this.valuePriority = event.detail.value;        
    }
        

    connectedCallback() {
        this.subscribeToMessageChannel();
        console.log(this.valueContact);
        //this.getUrl();
               
    }

    /* getUrl() {
        console.log(window.location.hash == '');
        let url;
        if(window.location.hash == '') {
            url = window.location.href;        
            console.log(url);
            this.urlPage = url;            
        } else {            
            let a = window.location.hash;
            console.log(a.split('&')[0]);
            let b = a.split('&')[0];
            console.log(b.split('=')[1]);
            this.aToken = b.split('=')[1];
        }
    } */

    subscribeToMessageChannel() {
        console.log(this.subscription);
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                CONTACTS_CHANNEL,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }  
    }

    handleMessage(message) {
        this.contact = message.contacts[0];        
        this.isVisible = true;        
    }
    
    handleLogout () {
        this.isVisible = false;
    }

    handleChangeContact(event) {
        this.valueContact = event.detail.value;        
        console.log(this.valueContact);
        this.changeSelectRows(this.orders);        
    }

    handleAssign() {
        if(this.valueContact == null || this.valueContact === '') {
            this.showToastEvent(ERROR_VARIANT, ERROR_TITLE, MESSAGE_SELECT_A_CONTACT);
        } else {            
            upadateOrders({orderIds :this.selectedRows, selectedCarOwnerId :this.valueContact})
            .then(() => {
                this.showToastEvent(SUCCESS_VARIANT, SUCCESS_TITLE, 'Orders updated');
                refreshApex(this.wiredOrderList);
            })
            .catch(error => {
                this.error = error;
                this.showToastEvent(ERROR_VARIANT, ERROR_TITLE, this.error)
            })
        }
    }

    showToastEvent(variant, title, message){
        const event = new ShowToastEvent({
            variant: variant,
            title: title,
            message: message                
        });
        this.dispatchEvent(event);
    }

    onRowSelection(event) {
        if(this.valueContact == null || this.valueContact === '') {
            this.showToastEvent(INFO_VARIANT, INFO_TITLE, MESSAGE_SELECT_A_CONTACT);
        } else {
            this.selectedRows = event.detail.selectedRows.map(row => {
                let rtnId;            
                if(row.Car__r.Contact__c === this.valueContact) {
                    rtnId = row.Id;
                } else {
                    this.showToastEvent(INFO_VARIANT, INFO_TITLE, 'Row selection is not allowed');                
                }            
                return rtnId;
            });
        }    
    }    

    changeSelectRows(orders) {  
        const rows = [];
        orders.forEach(order => {
            if(order.Car__r.Contact__c == this.valueContact ) { 
                rows.push(order.Id);
            }
        });
        console.log(rows);
        this.selectedRows = rows;
    }

    /* getIP() {        
        let calloutURI;
        if (this.aToken == null) {
            calloutURI = 'https://oauth.vk.com/authorize?client_id=8022717&display=page&redirect_uri=' + this.urlPage + '&scope=friends,wall&response_type=token&v=5.131';
            document.location.href = calloutURI;
                     
        } else {
            calloutURI = 'https://api.vk.com/method/friends.getOnline?user_id=18799794&message=Test&access_token=' + this.aToken + '&v=5.131';
            //calloutURI = 'https://api.vk.com/method/wall.post?user_id=18799794&message=Test&access_token=' + this.aToken + '&v=5.131';
            fetch(calloutURI, {
                method: "GET",                
                headers: {
                    'Content-Type': 'text/html; charset=utf-8'
                }                  
            }).then(function(response) {
                console.log(response);
            });
           

            /* let xhr = new XMLHttpRequest();
            xhr.open('GET', calloutURI);
            xhr.send();
            xhr.onload = function() {
                if (xhr.status != 200) { 
                    console.log(`Error = ' ${xhr.status}: ${xhr.statusText}`); 
                } else {
                    console.log(response);
                }
            //}; 


        }        
        
    } */
    
}