import {api, LightningElement} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {createRecord} from 'lightning/uiRecordApi';
import TIQUETE_OBJECT from '@salesforce/schema/OpportunityLineItem';
import crearTiquete from '@salesforce/apex/contactoReserva.crearTiquete';



export default class CreateTiquete extends LightningElement {
    @api vueloSeleccionado;
    @api contactId;

    objectApiName= TIQUETE_OBJECT;

    Quantity = 1;
    


}