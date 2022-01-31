import { LightningElement, wire } from 'lwc';
import getFiveLast from '@salesforce/apex/ContactManager.getFiveLast';
import getByCarOwnerId from '@salesforce/apex/OrderManager.getByCarOwnerId';


export default class OrderSearchForm extends LightningElement {
    options = '';
    value = '';
    orders;
    //getOrders(this.value);
    connectedCallback() {
        console.log('fffff');
        this.getOrders(this.value);
    }
    
    @wire(getFiveLast, {})
      contactName({ error, data }) {
      if (data) {
        this.options = data.map(name => {          
          return { label: name.Name, value: name.Id };
        });
        this.options.unshift({ label: 'None', value: '' });
      } else if (error) {
        this.options = undefined;
        this.error = error;
      }
    }
    
    handleChange(event) {
        this.value = event.detail.value;
        this.getOrders(this.value);
    }

    getOrders(carOwnerId) {
        console.log(this.value);
        getByCarOwnerId({ selectedCarOwnerId: carOwnerId })
        .then(result => {
            if(result.length > 0) {
                console.log(result);
                this.orders = result;
            } else {
                this.orders = null;
            }
            
        })
        .catch(error => {
            console.log(error);
            this.error = error;
        });
    }
}