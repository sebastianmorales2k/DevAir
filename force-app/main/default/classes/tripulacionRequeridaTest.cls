@isTest
public with sharing class tripulacionRequeridaTest {
   
    @TestSetup
    static void makeData(){
        avion__c avion = new avion__c(N_mero_de_pasajeros_clase_negocios__c = 0, N_mero_de_pasajeros_clase_Turista__c = 150, Aeronave__c = 'Airbus de pruebas');
        insert avion;
        
        avion__c newAvion = [SELECT Id FROM Avion__c LIMIT 1];

        product2 vuelo = new Product2(Name = 'AV-0001', Avion__c = newAvion.Id , Fecha_y_hora_de_partida__c = DateTime.now()+8/7,
                                    Fecha_y_hora_estimada_de_llegada__c = (DateTime.now()+8/7).addHours(1), IsActive = true, Estado__c = 'En Venta');
        insert vuelo;

        Contact auxiliar1 = new Contact(firstName='señor', lastName='pruebas', RecordTypeId='0128a000000Gu8zAAC',
                                        N_mero_de_Pasaporte__c='12312345', Nacionalidad__c='colombiano',
                                        Birthdate=Date.newInstance(2004,03,01));
        insert auxiliar1;

        List<Contact> contactos = new List<Contact>();
        for(integer i = 0; i < 1;i++){
            Contact auxiliar2 = new Contact(firstName='señor'+i, lastName='pruebas'+i, RecordTypeId='0128a000000Gu8zAAC',
                                        N_mero_de_Pasaporte__c='1231234522'+i, Nacionalidad__c='argentino',
                                        Birthdate=Date.newInstance(1990,05,09));
            contactos.add(auxiliar2);
        }
        insert contactos;

        product2 vueloTest = [SELECT Id FROM Product2 LIMIT 1];
        Contact auxTest = [SELECT Id FROM Contact LIMIT 1];

        vueloXcontacto__c junction = new vueloXcontacto__c(Contacto__c = auxTest.Id, Vuelo__c = vueloTest.Id);
        insert junction;
        
    }

    @isTest
    private static void getVuelo(){
        List<TripulacionRequerida.vuelo> vuelos = TripulacionRequerida.getVuelosPendientes();
        system.assertEquals(1, vuelos.size());
    }

    @isTest
    private static void errorGetVuelo(){
        avion__c fakeAvion = [SELECT Id FROM avion__c LIMIT 1];
        delete fakeAvion;
        
        try {
            List<TripulacionRequerida.vuelo> vuelos = TripulacionRequerida.getVuelosPendientes();
        }
        catch (Exception e) {
            system.assert(e.getMessage().contains('Script-thrown exception'));
        }
        
    }

    @isTest
    private static void auxiliares(){
        
        Product2 vuelos = [SELECT Id FROM product2 LIMIT 1];
        
        List<TripulacionRequerida.opcion> auxiliares = TripulacionRequerida.getAuxiliares(vuelos.id);
        system.assertEquals(3, auxiliares.size());
    }

    @isTest
    private static void fakeAuxiliar(){
        
        List<TripulacionRequerida.opcion> auxiliares = TripulacionRequerida.getAuxiliares('4251aad');
    }

    @isTest
    private static void getAuxiliar(){
        Product2 vuelos = [SELECT Id FROM product2 LIMIT 1];
 
        List<Contact> axuliar1 = [SELECT Id FROM Contact];
        List<string> getId = new List<string>();
        for(Contact a: axuliar1){
            getId.add(a.Id);
        }
        TripulacionRequerida.saveAuxiliares(getId,vuelos.id);

        List<TripulacionRequerida.opcion> auxiliares = TripulacionRequerida.getAuxiliares(vuelos.id);
        system.assertEquals(4, auxiliares.size());
    }
}