@istest
public with sharing class descuentoRemateBatchTest {
    
    @TestSetup
    static void makeData(){
        List<Contact> lista = new List<Contact>();
        for(Integer i = 0; i < 2; i++){
            Contact cto = new Contact(FirstName = 'señor', LastName = 'pruebas', 
                                        Tipo_de_Indetificacion__c = 'Cédula de Extranjería',
                                        N_mero_de_indetificacion__c = String.valueof(i));
            lista.add(cto);
        }
        insert lista;
        String id = lista[0].Id;

        Avion__c avion = new Avion__c(Aeronave__c  = 'Airbus A330', N_mero_de_pasajeros_clase_negocios__c = 30, 
        N_mero_de_pasajeros_clase_Turista__c = 222);
        insert avion;

       
        List<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for (Integer i = 0; i<2 ; i++) {
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Nombre_del_Aeropuerto__c = 'aero pruebas'+i, Pais__c = 'Chile', Codigo_IATA__c = 'BBA', Cuidad__c = 'Balmaceda');
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        String idAvion = avion.Id;
        List<Product2> Vuelos = new List<Product2>();
        for(Integer i = 0; i < 2; i++){
            Product2 vuelo = new Product2(Name = 'AE-2552', 
                                        Fecha_y_hora_de_partida__c = Datetime.now().addHours(10), Fecha_y_hora_estimada_de_llegada__c = Datetime.now().addHours(12),
                                        Avion__c = idAvion, Aeropuerto_de_partida__c = aeropuertos[0].Id,
                                        Aeropuerto_de_Llegada__c = aeropuertos[1].Id );
            Vuelos.add(vuelo);
        }
        insert Vuelos;
        String idV = Vuelos[0].Id;
        Id idEstandar = Test.getStandardPricebookId();
        //Insertar entrada de precios estandar
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = idEstandar, Product2Id = idV,
                                                          UnitPrice = 10000, IsActive = true,
                                                          descuento_35__c =  true,
                                                          descuento_50__c = false);
        insert standardPrice;
        
        Pricebook2 negocios = new Pricebook2(Name = 'Clase Negocios', IsActive = true);
        insert negocios;

        
        Pricebook2 turista = new Pricebook2(Name = 'clase turista', IsActive = true);
        insert turista;
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = turista.id, Product2Id = idV, 
                                                    UnitPrice = 20000, isActive = true,
                                                    descuento_35__c =  false,
                                                    Descuento_50__c = false);
        insert entrada;
        
        
        Opportunity res = new Opportunity(Name = 'reserva de prueba', Titular_de_la_Reserva__c = id, 
                                        CloseDate = System.today(), StageName = 'Pre-venta', 
                                        Pricebook2Id = turista.Id);
        Insert res;
    }

    @isTest
    static void pruebaDescuentoMartes(){
        Test.startTest();
        DescuentoRemateSchedulable prueba = new DescuentoRemateSchedulable();
        String sch = '1 0 0 ? * * *';
        String jobID = System.schedule('DescuentoRemateSchedulable', sch, prueba);
        descuentoRemateBatch descuento = new descuentoRemateBatch();
        ID batchprocessid = Database.executeBatch(descuento);
        Test.stopTest();
        
        List<PricebookEntry> entradaConDescuento = [SELECT Id 
                                FROM PricebookEntry 
                                WHERE Descuento_50__c = true];
        System.assertEquals(2, entradaConDescuento.size());
    }

}