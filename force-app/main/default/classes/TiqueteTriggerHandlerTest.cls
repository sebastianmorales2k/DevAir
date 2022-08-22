@isTest
public with sharing class TiqueteTriggerHandlerTest {
    
@TestSetup
static void makeData(){
    List<Contact> lista = new List<Contact>();
    for(Integer i = 0; i < 20; i++){
        Contact cto = new Contact(FirstName = 'señor '+i, LastName = 'pruebas', 
                                    Tipo_de_Indetificacion__c = 'Cédula de Extranjería',
                                    N_mero_de_indetificacion__c = String.valueof(i));
        lista.add(cto);
    }
    insert lista;
    String id = lista[0].Id;

    Avion__c avion = new Avion__c(Aeronave__c  = 'Airbus A330', N_mero_de_pasajeros_clase_negocios__c = 1, 
    N_mero_de_pasajeros_clase_Turista__c = 0);
    insert avion;
/*
    List<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
    for (Integer i = 0; i<2 ; i++) {
        Aeropuerto__c aeropuerto = new Aeropuerto__c(Nombre_del_Aeropuerto__c = 'Vuelo'+i );
        aeropuertos.add(aeropuerto);
    }
    insert aeropuertos;
*/
    String idAvion = avion.Id;
    List<Product2> Vuelos = new List<Product2>();
    for(Integer i = 0; i < 2; i++){
        Product2 vuelo = new Product2(Name = 'AE-2552', 
                                    Fecha_y_hora_de_partida__c = Datetime.now().addHours(10), Fecha_y_hora_estimada_de_llegada__c = Datetime.now().addHours(12),
                                    Avion__c = idAvion);
        Vuelos.add(vuelo);
    }
    insert Vuelos;
    
    String idV = Vuelos[0].Id;
    Id idEstandar = Test.getStandardPricebookId();
    
    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = idEstandar, Product2Id = idV,
                                                      UnitPrice = 10000, IsActive = true,
                                                      descuento_35__c =  true,
                                                      Descuento_50__c = false);
    insert standardPrice;
    
    Pricebook2 negocios = new Pricebook2(Name = 'clase negocio', IsActive = true);
    insert negocios;

    
    Pricebook2 turista = new Pricebook2(Name = 'clase turista', IsActive = true);
    insert turista;
    
    PricebookEntry entrada = new PricebookEntry(Pricebook2Id = negocios.id, Product2Id = idV, 
                                                UnitPrice = 20000, isActive = true,
                                                descuento_35__c =  true,
                                                Descuento_50__c = false);
    insert entrada;
    
    
    Opportunity res = new Opportunity(Name = 'prueba reserva', Titular_de_la_Reserva__c = id, 
                                    CloseDate = System.today(), StageName = 'Pre-venta', 
                                    Pricebook2Id = negocios.Id);
    Insert res;
    
}

@isTest
static void capacidadMax(){
    try {
        List<Contact> pasajeros = [SELECT Id FROM Contact];
        Opportunity reserva = [SELECT Id FROM Opportunity LIMIT 1];
        Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];

        List<OpportunityLineItem> tiquetes = new List<OpportunityLineItem>();
        for (Integer i = 0; i < 5;  i++) {
            tiquetes.add(new OpportunityLineItem(OpportunityId = reserva.Id, Product2Id = vuelo.Id, Pasajero__c = pasajeros[i].Id));
        }
        insert tiquetes;
        
        OpportunityLineItem sobreventa = new OpportunityLineItem(OpportunityId = reserva.Id, Product2Id = vuelo.Id, Pasajero__c = pasajeros[5].Id);
        insert sobreventa;

    } catch (Exception e) {
        system.assert(e.getMessage().contains('supero la capacidad del vuelo'));
        
    }
}

@isTest
static void equipajeNegocio(){
    Contact pasajero = [SELECT Id FROM Contact LIMIT 1];
    Opportunity reserva = [SELECT Id FROM Opportunity LIMIT 1];
    Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];

    OpportunityLineItem equipaje = new OpportunityLineItem(OpportunityId = reserva.Id, Product2Id = vuelo.Id);
    insert equipaje;

    OpportunityLineItem resultado = [SELECT Id, Equipaje_permitido__c,Pasajero__c FROM OpportunityLineItem LIMIT 1];
    System.assertEquals('Personal;maleta de cabina;maleta de bodega', resultado.Equipaje_permitido__c);
    System.assert(resultado.Pasajero__c != null);

    update resultado;
    delete resultado;
}



}