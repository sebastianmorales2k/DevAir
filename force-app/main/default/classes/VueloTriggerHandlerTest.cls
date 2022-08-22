@isTest
public with sharing class VueloTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        Product2 vuelo = new Product2(isactive = true, estado__c = 'En venta', name = 'Vuelo de prueba', Aeropuerto_de_llegada__c = 'a0D8a00001gk3vcEAA', Aeropuerto_de_partida__c = 'a0D8a00001gk3vnEAA',
                                    Fecha_y_hora_de_partida__c = (date.today()+1) , Fecha_y_hora_estimada_de_llegada__c = Date.today()+2);
        insert vuelo;
    }

    @isTest
    static void estadoTerminado(){
    Product2 vuelo = [SELECT id, estado__c , name
                        FROM Product2 LIMIT 1];  
        vuelo.estado__c = 'Terminado';
        update vuelo;
    }

    @isTest
    static void estadoCancelado(){
    Product2 vuelo = [SELECT id, estado__c , name
                        FROM Product2 LIMIT 1];  
        vuelo.estado__c = 'cancelado';
        vuelo.Motivo_de_cancelaci_n__c = 'sobreventa';
        update vuelo;

        vuelo = [SELECT id, estado__c , name
                        FROM Product2 LIMIT 1];  
        System.assertEquals('cancelado', vuelo.estado__c);
    }

    @isTest
    static void cancelSinMotivo(){
        Product2 vuelo = [SELECT id, estado__c , name
                        FROM Product2 LIMIT 1];  
        vuelo.estado__c = 'Cancelado';
        try {
            update vuelo;
        } catch (Exception e) {
            system.assert(e.getMessage().contains('Debe agregar un motivo de cancelación'));
        }
       
    }

    @isTest
    private static void cancelarConMotivo(){
        
        List<Product2> vuelitos = [Select Id,Name, Estado__c, Motivo_de_cancelaci_n__c From Product2];
        for(Product2 v: vuelitos){
            v.Estado__c = 'Cancelado';
            v.Motivo_de_cancelaci_n__c ='Sobreventa';
        }
        update vuelitos;
        
        List<Product2> vuelitosActualizados = [Select Id From Product2 Where Motivo_de_cancelaci_n__c != null ];
        system.assertEquals(1, vuelitosActualizados.size());
    }

    @isTest
    private static void borrarRecuperar(){
        Product2 vuelo = [SELECT Id FROM Product2 LIMIT 1];
        id idVuelo = vuelo.Id;
        
        delete vuelo;
        
        List<Product2> buscarVuelo = [SELECT id FROM Product2 WHERE Id =: idVuelo ];
        
        system.assertEquals(0, buscarVuelo.size());
        
        Product2 vuelito = new Product2(id = idVuelo);
        
        undelete vuelito;
        
        List<Product2> buscarVuelo1 = [SELECT id FROM Product2 WHERE Id =: vuelito.Id ];
        
        system.assertEquals(1, buscarVuelo1.size());
    }
    
}
