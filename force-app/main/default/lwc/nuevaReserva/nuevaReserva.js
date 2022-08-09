import { LightningElement, wire, track, api } from 'lwc';
import comprobarContacto from '@salesforce/apex/contactoReserva.clienteReserva'; 
import crearteReserva from '@salesforce/apex/contactoReserva.crearReserva';

export default class NuevaReserva extends LightningElement {
    value = 'Cedula de Ciudadania';
    contact;
    error;
    idContacto;
    numeroIdent;
    crearReserva;
    reserva;
    erro2;
    newOpp;
    erroresReserva;
    crearOpp;
    precioSeleccionado;
    contactTrue;
    contactFalse;
    reservaTrue;
    reservaFalse;
    openModal;
    
    get options() {
        return [
            { label: 'Cédula de ciudadania', value: 'Cédula de ciudadania' },
            { label: 'Cédula de extranjería', value: 'Cédula de extranjería' },
            { label: 'Tarjeta de Identidad', value: 'Tarjeta de Identidad' },
        ];
    }

    get listadoPrecios() {
        return [
            { label: 'Clase Turista', value: 'Standard Price Book'},
            { label: 'Clase Negocios', value: 'clase negocio'},
        ];
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.openModal = false;
    }
    closecrearcont() {
        // to close modal set isModalOpen tarck value as false
        this.contactFalse = false;
    }


    handleChange(event) {
        
        switch(event.target.name){
            case 'tipoId':
                this.value = event.detail.value;
                break;
            case 'nroId':
                this.numeroIdent= event.detail.value;
                break;
            case 'listaPrecio':
                this.precioSeleccionado = event.detail.value;
                break;
            
        }
    }

    get idcontact(){
        if(this.contact != null){
            return this.contact.Id;
        }else{
            return '';
        }
    }

    get namecontact(){
        if(this.contact != null){
            return this.contact.Name;
        }else{
            return '';
        }
    }
    get numidcontact(){
        if(this.contact != null){
            return this.contact.N_mero_de_indetificacion__c;
        }else{
            return '';
        }
    }
    get pasaportecontact(){
        if(this.contact != null){
            return this.contact.N_mero_de_Pasaporte__c;
        }else{
            return '';
        }
    }

    get reservaName(){
        if(this.newOpp != null){
            return this.newOpp.Name;
        }else{
            return '';
        }
    }

    get reservaEstado(){
        if(this.newOpp != null){
            return this.newOpp.StageName;
        }else{
            return '';
        }
    }

    get reservaId(){
        if(this.newOpp != null){
            return this.newOpp.Id;
        }else{
            return '';
        }
    }

    get reservaListaPrecio(){
        if(this.newOpp != null){
            return this.newOpp.Pricebook2Id;
        }else{
            return '';
        }
    }

    buscarContacto(event){
        console.log(this.numeroIdent + this.value);
        comprobarContacto({tipoId: this.value, numId: this.numeroIdent})
            .then((result) => {
                this.contact= result.contacto;
                this.reserva = result.oportunidad;
                if(this.contact == undefined){
                    this.contactFalse = true;
                    this.contactTrue = false;
                }else{
                    this.contactTrue = true;
                    this.contactFalse = false;
                    if(this.reserva == undefined){
                        this.openModal = true;
                        this.reservaFalse = true;
                        this.reservaTrue = false;

                    }else{
                        this.openModal = true;
                        this.reservaTrue = true;
                        this.crearOpp = false; 
                        this.reservaFalse = false;
                    }
                }
                this.error = undefined;
                
            }).catch((error) => {
                this.error = error;
                this.contact = undefined;
                this.reserva = undefined;
            });

    }
   
    createReserva(event){
        crearteReserva({idContactito: String(this.contact.Id),listaPrecio: this.precioSeleccionado})
                        .then((result) => {
                            this.erroresReserva = undefined;
                            this.newOpp = result;
                            this.IdreservaNew = this.newOpp.Id;
                            this.crearOpp = true;
                        }).catch((error)=>{
                            this.erroresReserva = error;
                            console.log(error);
                            this.newOpp = undefined;
                        })
    }
}