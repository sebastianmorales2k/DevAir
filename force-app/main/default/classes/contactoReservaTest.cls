@isTest
public class contactoReservaTest {
    
    @TestSetup
    static void makeData(){
        string pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebookId,
            IsActive = true
        );
        update standardPricebook;
        
        Pricebook2 negocio = new Pricebook2(Name = 'clase negocio',IsActive = true);
        insert negocio;
        
        Avion__c avion = new Avion__c (N_mero_de_pasajeros_clase_negocios__c = 10,N_mero_de_pasajeros_clase_Turista__c = 10);
        insert avion;
        
        Contact contactOppFalse = new Contact (firstName = 'señor', lastName = 'prueba', Tipo_de_Indetificacion__c = 'Cédula de Ciudadania',
                                                    N_mero_de_indetificacion__c= '222', Nacionalidad__c = 'colombiano', Birthdate = Date.newInstance(1999, 05, 09) );
        insert contactOppFalse;
                           
        Contact contactOppTrue = new Contact (firstName = 'señora', lastName = 'prueba', Tipo_de_Indetificacion__c = 'Cédula de Ciudadania', 
                                                    N_mero_de_indetificacion__c= '333', Nacionalidad__c = 'colombiano', Birthdate = Date.newInstance(1999, 05, 09) );
        insert contactOppTrue;
                           
        Opportunity oppContact = new Opportunity (Titular_de_la_reserva__c= contactOppTrue.Id,Name = 'señora',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta',
                                                       Pricebook2Id = negocio.Id );
        insert oppContact;
        
        list<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Nombre_del_Aeropuerto__c = 'jose maria'+i , Pais__c = 'Colombia', Cuidad__c = 'Bogotá', Codigo_IATA__c = 'CCC');
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        
        product2 vuelo = new product2(Name = 'vueloprueba', Aeropuerto_de_partida__c =aeropuertos[0].id, Aeropuerto_de_llegada__c = aeropuertos[1].id,Estado__c = 'en venta',IsActive = true,
                                        Fecha_y_hora_de_partida__c = Date.newInstance(2022, 08, 22),Avion__c = avion.Id,
                                        Fecha_y_hora_estimada_de_llegada__c = Date.newInstance(2022, 08, 23));
        insert vuelo;

        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=20,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;
        
        PricebookEntry negociando = new PricebookEntry(Pricebook2Id = negocio.Id, UnitPrice=30,Product2Id=vuelo.Id, IsActive = true);
        insert negociando;
    }
    
    @isTest
    private static void contactoFalse() {

        system.assertEquals(null, contactoReserva.clienteReserva('Cédula de ciudadania', '000').contacto);
        system.assertEquals(null, contactoReserva.clienteReserva('Cédula de ciudadania', '000').oportunidad);
    }

    @isTest
    private static void contactOppFalse(){
        
        system.assert(contactoReserva.clienteReserva('Cédula de Ciudadania', '222').contacto.Name.contains('señor'));
        system.assertEquals(null, contactoReserva.clienteReserva('Cédula de Ciudadania', '222').oportunidad);
    }

    @isTest
    private static void contactOppTrue(){
        
        system.assert(contactoReserva.clienteReserva('Cédula de Ciudadania', '333').contacto.Name.contains('señora'));
        system.assert(contactoReserva.clienteReserva('Cédula de Ciudadania', '333').oportunidad.StageName.contains('Pre-venta'));
    }

    @isTest
    private static void fakeContact(){
        
        system.assertEquals(null, contactoReserva.clienteReserva('Cédula de Ciudad', '99999999').contacto);
        system.assertEquals(null, contactoReserva.clienteReserva('Cédula de Ciudad', '9999999999').oportunidad);
    }
}

