import { api, LightningElement, wire } from 'lwc';
import {createRecord,  getRecord, getFieldValue} from 'lightning/uiRecordApi';
import getContactos from '@salesforce/apex/Reservas.getContactos';
import getVuelos from '@salesforce/apex/Reservas.getVuelos';

const columns = [
    { label: 'Vuelo', fieldName: 'name' },
    { label: 'Aeropuerto de Partida', fieldName: 'aeroPartida', type: 'text' },
    { label: 'Aeropuerto de llegada', fieldName: 'aeroLlegada', type: 'text' },
    { label: 'fecha de partida', fieldName: 'fechaPartida', type: 'date' },
    { label: 'fecha de llegada', fieldName: 'fechaLlegada', type: 'date' },
];

export default class BasicDatatable extends LightningElement {
    columns = columns;
    Id;
    selected = [];

    get vuelos(){
        return this.Id;
    }

    @wire(getVuelos)
    vuelos;

    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

}
