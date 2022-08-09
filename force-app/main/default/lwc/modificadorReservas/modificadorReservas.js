import { LightningElement, wire, api } from 'lwc';
import {createRecord,  getRecord, getFieldValue} from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import TITULARDERESERVA_FIELD from '@salesforce/schema/Opportunity.Titular_de_la_Reserva__c';
import ESTADO_FIELD from '@salesforce/schema/Opportunity.StageName';
import NOMBREDERESERVA_FIELD from '@salesforce/schema/Opportunity.Name';
import FECHADECIERRE_FIELD from '@salesforce/schema/Opportunity.CloseDate';


export default class ModificadorReservas extends LightningElement {
    @api recordId;
    @wire(getRecord, {recordId: '$recordId', fields: [NAME_FIELD]}) record;

    objectApiName = OPPORTUNITY_OBJECT;
    opportunityId;
    estado = 'Pre-venta';
    fecha = new Date().toISOString().slice(0, 10);

    get contactName(){
        return this.record.data ? getFieldValue(this.record.data, NAME_FIELD) : '';
    }
    
    handleSuccess(event) {
        console.log('onsuccess event recordEditForm',event.detail.id)
    }
    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }



    crearReserva() {
        this.dispatchEvent(new CustomEvent('cerrar'));
        
        const fields = {}
        fields[TITULARDERESERVA_FIELD.fieldApiName] = this.recordId;
        fields[NOMBREDERESERVA_FIELD.fieldApiName] = this.contactName;
        fields[ESTADO_FIELD.fieldApiName] = this.estado;
        fields[FECHADECIERRE_FIELD.fieldApiName] = this.fecha;    
       
        const recordInput ={apiName: OPPORTUNITY_OBJECT.objectApiName, fields };
        console.log(recordInput);
        createRecord(recordInput)

        
        .then(opportunity => {
            
            this.opportunityId = opportunity.id;
            console.log(fields);
            console.log('Reserva creada con éxito');
            this.dispatchEvent(new CustomEvent('mensaje'));
            
        })
        .catch(error => {
            console.error(error);
        })
        
    }

}