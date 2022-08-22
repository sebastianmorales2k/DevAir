@isTest
public class contactoReservaTest {

    @TestSetup
    static void makeData(){
        List<Contact> contactos = new List<Contact>();
        for (Integer i = 0; i < 2 ; i++) {
            contact contacto = new contact(Tipo_de_Indetificacion__c = 'Tarjeta de Identidad',
                                        N_mero_de_indetificacion__c = '1'+i,
                                        FirstName = 'señor', LastName = 'pruebas');
            contactos.add(contacto);
        }
        insert contactos;
        string id = contactos[1].Id;

        Avion__c avion = new Avion__c(Aeronave__c = 'avion de pruebas', N_mero_de_pasajeros_clase_negocios__c = 32,N_mero_de_pasajeros_clase_turista__c = 200);
        insert avion;


        //Data para metodo obtenerVuelo        
        List<Product2> Vuelos = new List<Product2>();
        for(Integer i = 0; i < 2; i++){
            String estado;
            
            if(i == 0){
                estado = 'Check in';
            }
            else{
                estado = 'En venta';
            }

            Product2 vuelo = new Product2(Name = 'AE-00'+i, Fecha_y_hora_de_partida__c = System.today().addDays(i+1),Estado__c = estado,
                                            Fecha_y_hora_estimada_de_llegada__c = System.today().addDays(i+2), Avion__c = avion.Id, IsActive = true);
            Vuelos.add(vuelo);
            system.debug(System.today().addDays(i+1));

            system.debug(System.today().addDays(i+2));
        }

        insert Vuelos;
        String idV = Vuelos[1].Id;
        System.debug(idV);

        System.debug(Vuelos[1].Name);
        
        Id idEstandar = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry( Pricebook2Id = idEstandar, Product2Id = idV, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 turista = new Pricebook2(Name = 'Tiquetes clase turista', IsActive = true);
        insert turista;
        Pricebook2 negocios = new Pricebook2(Name = 'Tiquetes Negocios', IsActive = true);  
        insert negocios;
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = turista.id, Product2Id = idV, UnitPrice = 20000, IsActive = true);
        insert entrada;
        
        Opportunity reserva = new Opportunity(Name = 'A', Titular_de_la_Reserva__c = id, CloseDate = System.today(), StageName = 'Pre-venta', Pricebook2Id = turista.Id);
        insert reserva;
    }
    
    @isTest
    static void contactoSinReserva(){
        contactoReserva.CtoReserva test = contactoReserva.clienteReserva('10' , 'Tarjeta de Identidad');
        System.assert(test.contacto != null);
        System.assert(test.oportunidad == null);
    }

    @isTest
    static void contactoConReserva(){
        contactoReserva.CtoReserva test = contactoReserva.clienteReserva('11' , 'Tarjeta de Identidad');
        System.assert(test.contacto != null);
        System.assert(test.oportunidad != null);
    }

    @isTest
    static void busquedaFallida(){
        contactoReserva.CtoReserva test = contactoReserva.clienteReserva('1' , 'Tarjeta de Identidad');
        System.assert(test.contacto == null);
        System.assert(test.oportunidad == null);
    }

    @isTest
    static void obtieneVuelos(){
        Pricebook2 listaPrecio = [SELECT id From Pricebook2 WHERE NAme = 'Tiquetes clase turista' LIMIT 1];
        string idlistaPrecio = listaPrecio.Id;

        List<contactoReserva.vuelo> vuelos = contactoReserva.obtenerVuelos(idlistaPrecio);

        System.assertEquals(1, vuelos.size());

    }

    @isTest
     static void nombrePricebook(){
        Pricebook2 listaPrecio = [SELECT id,Name From Pricebook2 WHERE NAme = 'Tiquetes clase turista' LIMIT 1];
        string idAComparar = listaPrecio.Id;
        
        string id = contactoReserva.listaPrecios('Tiquetes clase turista');
        System.assertEquals(idAComparar, id);
    }

    @isTest
    static void crearTiquete(){
        Contact contacto = [SELECT Id From Contact WHERE N_mero_de_indetificacion__c = '11' LIMIT 1];
        string idContact = contacto.Id;

        system.debug(contacto);

        Opportunity reserva = [SELECT Id FROM Opportunity LIMIT 1];
        string idReserva = reserva.Id;

        system.debug(contacto +''+ reserva);

        List<Product2> vuelo = [SELECT Id FROM Product2 WHERE Estado__c = 'En venta' ];
        List<String> idVuelos = new List<String>();
        for (Product2 v : vuelo) {
            idVuelos.add(v.Id);
        }
        system.debug(idReserva +' '+ idVuelos +' '+ idContact);

        contactoReserva.crearTiquete(idReserva, idContact, idVuelos);
        
        List<OpportunityLineItem> tiquetes = [Select Id FROM OpportunityLineItem LIMIT 10];
        
        System.assertEquals(1, tiquetes.size());
    }
}

 