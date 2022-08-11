@isTest
public class contactoReservaTest {
    
    @TestSetup
    static void makeData(){
        Contact ContactoNew = new Contact (firstName = 'prueba', lastName = 'test', Tipo_de_Identificacion__c = 'Cedula de Ciudadania', N_mero_de_Pasaporte__c = '3124123424',
                                                    Numero_de_Identificacion__c= '1111111111111', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1980, 03, 02) );
        
        insert ContactoNew;

        Pricebook2 ListPrecio = new Pricebook2(Name = 'Standard Price Book');
        insert ListPrecio;
        
        Pricebook2 ListPrecio2 = new Pricebook2(Name = 'precios prueba');
        insert ListPrecio2;

        Contact contactoOpp = new Contact (firstName = 'prueba2', lastName = 'test', Tipo_de_Identificacion__c = 'Cedula de Ciudadania', 
                                            Numero_de_Identificacion__c= '2222222222', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1990, 05, 09) );
        insert contactoOpp;

        Opportunity reservaContacto = new  Opportunity (Titular_de_la_reserva__c= contactoOpp.Id,Name = 'reservaPrueba',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta',
                                                        Pricebook2Id = ListPrecio.Id );
        insert reservaContacto;

        List<Aeropuerto__c> aeros = new List<Aeropuerto__c>();
        for(integer i = 0; i < 2; i++){
            Aeropuerto__c joseMaria = new Aeropuerto__c(Name = 'Jose Maria'+i, Pais__c = 'Colombia', Cuidad__c = 'bogota');
            aeros.add(joseMaria);
        }
        insert aeros;

        Product2 viajes  = new Product2(Name = '', Fecha_y_hora_de_partida__c = Date.newInstance(2022, 09, 22), Fecha_y_hora_estimada_de_llegada__c = Date.newInstance(2022, 09, 23)
                                        Aeropuerto_de_partida__c =aeros[0].id, Aeropuerto_de_llegada__c = aeros[1].id);
        insert viajes;

    }
    
    @isTest
    public contacto() {

        
    }

    @isTest
    public creacionreserva() {

    }

    @isTest
    public creaciontiquete() {

    }

    @isTest
    public obtieneVuelo() {

    }
}
