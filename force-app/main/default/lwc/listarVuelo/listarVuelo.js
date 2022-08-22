import { LightningElement, wire, track, api } from 'lwc';
import listaVuelos from '@salesforce/apex/contactoReserva.obtenerVuelos';
import crearTiquete from '@salesforce/apex/contactoReserva.crearTiquete';
import pasajerosDisponibles from '@salesforce/apex/contactoReserva.obtenerPasajeros';
import crearPasajero from '@salesforce/apex/contactoReserva.crearTiquete';
import comprobarPasajero from '@salesforce/apex/contactoReserva.crearTiquete';



const columns = [
    { label: 'Nombre del Vuelo', fieldName: 'codigo', sortable: "true" },
    { label: 'Aeropuerto de Partida', fieldName: 'aeropuertoPartida',wrapText: true, sortable: "true"},
    { label: 'Pais de Partida', fieldName: 'aeropuertoPartidaPais',wrapText: true, sortable: "true"},
    { label: 'Aeropuerto de Llegada', fieldName: 'aeropuertoLlegada',wrapText: true, sortable: "true"},
    { label: 'Pais de Llegada', fieldName: 'aeropuertoLlegadaPais',wrapText: true, sortable: "true"},
    { label: 'Precio de Venta', fieldName: 'precioUnitario', wrapText: true, sortable: "true"},
    { label: 'Fecha y Hora de Partida', fieldName: 'fechaPartida',wrapText: true, type: "date",
    typeAttributes:{
        year: "numeric",
        month: "long",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit"
    } },
    { label: 'fecha y Hora de Llegada', fieldName: 'fechaLlegada',wrapText: true, type: "date",
    typeAttributes:{
        year: "numeric",
        month: "long",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit"
    } },
];
const columnas = [
    {label: 'Pasajero', fieldName: 'Pasajero__r.Name'},
    {label: 'número de silla', fieldName: 'Asiento__c'},
]

export default class ListarVuelos extends LightningElement {
    @track columns = columns;
    @track data;
    @track sortBy;
    @track sortDirection;
    @track isModalOpen = false;
    @track tiqueteTitular;

    @api idPrecio;
  //@api opportunityId;
    @api recordId;
    @api resId;
    @api conId;
    
    ids= [];
    value = 'Cedula de Ciudadania';
    idVueloSelect;
    contactSelect;
    vueloSeleccionado;

    contactFalse = false;
    contactTrue =false;
    tiqCreado = false;

    get options() {
        return [
            { label: 'Cédula de ciudadania', value: 'Cédula de ciudadania' },
            { label: 'Cédula de extranjería', value: 'Cédula de extranjería' },
            { label: 'Tarjeta de Identidad', value: 'Tarjeta de Identidad' },
        ];
    }
    handleChange(event) {
        
        switch(event.target.name){
            case 'tipoId':
                this.value = event.detail.value;
                console.log("lista-->"+this.value);
                break;
            case 'nroId':
                this.numeroIdent= event.detail.value;
                console.log("numero-->"+this.numeroIdent);
                break;
        }
    }

    buscarContacto(event){
        console.log(this.numeroIdent + this.value);
        comprobarContacto({tipoId: this.value, numId: this.numeroIdent})
            .then((result) => {
                this.contact= result.contacto;
                console.log('contacto-->'+this.contact);
                if(this.contact == undefined){
                    this.contactFalse = true;
                    this.contactTrue = false;
                }else{
                    this.contactTrue = true;
                    this.contactFalse = false;
                }
                this.error = undefined;
                
            }).catch((error) => {
                this.error = error;
                this.contact = undefined;
            });
    }

    seleccionPasajero(){

        console.log('Entro a lista pasajeros');
        pasajerosDisponibles({resId: this.resId , idOwner: this.conId})
            .then((resultado)=> {
                this.datos = resultado;
                console.log('lista pasajeros');
                console.log(resultado);
            }).catch((errores) => {
                console.log('error:');
                console.log(this.errores);
            })
    }

    @wire(listaVuelos,{idListaPrecios: '$idPrecio'})vuelos(result){
        if (result.data) {
            this.data = result.data;
            this.error = undefined;
        } else if (result.error) {
            console.log(result.error);
            this.error = result.error;
            this.data = undefined;
        }
    }



    getSelectedRec() {
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
        if(selectedRecords.length > 0){
            console.log('selectedRecords are ', selectedRecords);
            console.log('lista de precio: '+ this.idPrecio );
            selectedRecords.forEach(currentItem => {
                this.idVueloSelect= currentItem.idVuelo;
                console.log('vuelo: '+ this.idVueloSelect);
                this.ids.push(this.idVueloSelect);
        });
        console.log('cuantos vuelos selecciono: '+ this.ids.length);
        console.log(this.ids);
        console.log(this.resId);
        console.log(this.conId);
        crearTiquete({reserva: this.resId, vuelo: this.ids, contacto: this.conId})
            .then((resultado)=> {
                this.tiqueteTitular = resultado;
                console.log('tiquete creado');
                this.tiqCreado = true;
                this.error= undefined;
            }).catch((errores) => {
                console.log(errores);
            })
        } 
    } 
 

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    } 

    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }

    getseleccionvuelo(event){
        const selectedRows = event.detail.selectRows;
        this.vueloSeleccionado = selectedRows[0].codigo;
        console.log(this.vueloSeleccionado);
    }

    get idcontact(){
        if(this.contactSelect != null){
            return this.contactSelect.Id;
        }else{
            return '';
        }
    }

    get namecontact(){
        if(this.contactSelect != null){
            return this.contactSelect.Name;
        }else{
            return '';
        }
    }

    get numidcontact(){
        if(this.contactSelect != null){
            return this.contactSelect.N_mero_de_indetificacion__c;
        }else{
            return '';
        }
    }

    get pasaportecontact(){
        if(this.contactSelect != null){
            return this.contactSelect.N_mero_de_Pasaporte__c;
        }else{
            return '';
        }
    }

    pasajeroOpp(event){
        console.log(this.numeroIdent + this.value);
        comprobarPasajero({tipoId: this.value, numId: this.numeroIdent})
            .then((result) => {
                this.contactSelect= result.contacto;
                console.log('contacto: '+this.contactSelect);
                if(this.contactSelect == undefined){
                    this.contactFalse = true;
                    this.contactTrue = false;
                }else{
                    this.contactTrue = true;
                    this.contactFalse = false;
                }
                this.error = undefined;
                
            }).catch((error) => {
                this.error = error;
                //this.contactSelect = undefined;
            });

    }

    limpiar(){
        this.value = '';
        this.numeroIdent = '';
        this.contactTrue = false;
    }

    nuevoPasajero(){
        console.log('crear pasajero');
        crearPasajero({reserva: this.resId, vuelo: this.ids, contacto: this.conId})
            .then((resultado)=> {
                this.tiqueteTitular = this.resultado;
                console.log('se ha creado exitosamente los tiquetes');
                this.tiqCreado = true;
                this.error= undefined;
            }).catch((errores) => {
                console.log('error: '+this.errores);
            })
    }

}