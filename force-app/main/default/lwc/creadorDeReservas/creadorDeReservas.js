import { api, LightningElement, wire, track } from 'lwc';
import getContactos from '@salesforce/apex/Reservas.getContactos';
import crearReserva from '@salesforce/apex/Reservas.crearReserva';

export default class creadorDeReservas extends LightningElement {
    value = 'Cedula de Ciudadania';
    contactoCliente;
    error;
    idContacto;
    numeroIdent;
    crearReserva;
    reserva;
    erro2;
    

    //valores de la reserva creada
    reservaNuevaInfo;
    erroresReserva;
    creardaReservita;
    precioSeleccionado;

    // Booleans para activar y desactivar secciones
    existeContacto;
    noExisteContacto;
    reservaExiste;
    reservaNoExiste;
    openModal;
    
    get options() {
        return [
            { label: 'Cedula de Ciudadania', value: 'Cedula de Ciudadania' },
            { label: 'Cedula de Extranjeria', value: 'Cedula de Extranjeria' },
            { label: 'Tarjeta de Identidad', value: 'Tarjeta de Identidad' },
        ];
    }

    get listadoPrecios() {
        return [
            { label: 'Clase Turista', value: 'Turista'},
            { label: 'Clase Negocios', value: 'Negocio'},
        ];
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.openModal = false;
    }

    handleChange(event) {
        
        switch(event.target.name){
            case 'tipoId':
                this.value = event.detail.value;
                console.log("Tipo de ide: "+this.value);
                break;
            case 'nroId':
                this.numeroIdent= event.detail.value;
                console.log("numero de ide: "+this.numeroIdent);
                break;
            case 'listaPrecio':
                this.precioSeleccionado = event.detail.value;
                console.log("lista de precios seleccionada: "+ this.precioSeleccionado);
                break;
            
        }
    }

    get idcontact(){
        if(this.contactoCliente != null){
            return this.contactoCliente.Id;
        }else{
            return '';
        }
    }

    get namecontact(){
        if(this.contactoCliente != null){
            return this.contactoCliente.Name;
        }else{
            return '';
        }
    }
    get numidcontact(){
        if(this.contactoCliente != null){
            return this.contactoCliente.N_mero_de_indetificacion__c;
        }else{
            return '';
        }
    }
    get pasaportecontact(){
        if(this.contactoCliente != null){
            return this.contactoCliente.N_mero_de_Pasaporte__c;
        }else{
            return '';
        }
    }

    get reservaName(){
        if(this.reservaNuevaInfo != null){
            return this.reservaNuevaInfo.Name;
        }else{
            return '';
        }
    }

    get reservaEstado(){
        if(this.reservaNuevaInfo != null){
            return this.reservaNuevaInfo.StageName;
        }else{
            return '';
        }
    }

    get reservaId(){
        if(this.reservaNuevaInfo != null){
            return this.reservaNuevaInfo.Id;
        }else{
            return '';
        }
    }

    get reservaListaPrecio(){
        if(this.reservaNuevaInfo != null){
            return this.reservaNuevaInfo.Pricebook2Id;
        }else{
            return '';
        }
    }

    buscarContacto(event){
        console.log(this.numeroIdent + '' + this.value);
        getContactos({numId: this.numeroIdent, tipoId: this.value})
            .then((result) => {
                this.contactoCliente= result.contacto;
                this.reserva = result.oportunidad;
                console.log('contacto: '+this.contactoCliente);
                console.log('reserva: '+this.reserva);
                if(this.contactoCliente === undefined){
                    console.log('llegó 1');

                    this.ModCrearCont = true;
                    this.ModCrearRes = false;
                }else{
                console.log('contacto: '+this.contactoCliente);
                console.log('reserva: '+this.reserva);
                    this.ModCrearRes = true;
                    this.ModCrearCont = false;
                    if(this.reserva == undefined){
                        
                    console.log('llegó 1 2');
                       /* this.openModal = true;
                        this.reservaNoExiste = true;
                        this.reservaExiste = false; */

                    }else{
                        /*this.openModal = true;
                        this.reservaExiste = true;
                        this.creardaReservita = false; 
                        this.reservaNoExiste = false;*/
                    }
                    console.log('llegó');
                }
                this.error = undefined;
                
            }).catch((error) => {
                this.error = error;
                this.contactoCliente = undefined;
                this.reserva = undefined;
            });

    }
   
    createReserva(event){
        console.log('se va a crear la reserva');
        crearReserva({idcontactoCliente: String(this.contactoCliente.Id),listaPrecio: this.precioSeleccionado})
                        .then((result) => {
                            console.log('resultado-->'+result);
                            this.erroresReserva = undefined;
                            this.reservaNuevaInfo = result;
                            this.creardaReservita = true;
                        }).catch((error)=>{
                            this.erroresReserva = error;
                            console.log(error);
                            this.reservaNuevaInfo = undefined;
                        })
    }
}