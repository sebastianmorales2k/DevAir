@isTest
public with sharing class ReservaTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        List<Contact> contactos = new List<Contact>();
        for(integer i = 0 ; i < 50 ; i++){
            integer year = 1900;
            Contact contacto = new Contact (firstName = 'señor', lastName = 'pruebas'+i, 
                                            Tipo_de_Indetificacion__c = 'Cédula de Ciudadania',
                                            N_mero_de_indetificacion__c = '000'+i, 
                                            Nacionalidad__c = 'colombiano', 
                                            Birthdate = Date.newInstance(year+i, 09, 02) );
            contactos.add(contacto);
        }
        insert contactos;   
        
        Opportunity reservaContacto = new Opportunity (Titular_de_la_Reserva__c = contactos[0].Id, 
                                                        Name = 'a',
                                                        CloseDate = Date.today().addDays(1),
                                                        StageName = 'Pre-venta');
        insert reservaContacto;
    }

    @isTest
    private static void nombreOpp(){
        List<Contact> contacts = [SELECT Id FROM Contact];
        List<Opportunity> opp = new List<Opportunity>();
        for(Contact c : contacts){
            Opportunity reservaContacto = new Opportunity (Titular_de_la_Reserva__c = c.Id,
                                                            Name = 'oppTest',
                                                            CloseDate = Date.today().addDays(1),
                                                            StageName = 'Pre-venta');
            opp.add(reservaContacto);
        }
        insert opp;
        List<Opportunity> oppUpdate = [SELECT Id,Name FROM Opportunity];

        system.assertEquals(51,oppUpdate.size());
        system.assert(oppUpdate[0].Name.contains('señorpruebas'));
    }

    @isTest
    private static void oppSinVuelo(){
        try{
            Opportunity oppUpdate = [SELECT id,Name,StageName FROM Opportunity LIMIT 1];
            oppUpdate.StageName = 'Pagado';
            update oppUpdate;
        }
        catch(exception e){
            system.assert(e.getMessage().contains('debe asignar un vuelo'));
        } 
    }

    @isTest
    private static void updateFecha(){
        Opportunity oppUpdate = [SELECT id,Name,StageName,CloseDate FROM Opportunity LIMIT 1];
        oppUpdate.CloseDate = Date.today().addDays(5);
        update oppUpdate;
        
        Opportunity nuevaOpp=[SELECT id,Name,StageName,CloseDate FROM Opportunity WHERE id =: oppUpdate.Id LIMIT 1];
        system.assert(nuevaOpp.CloseDate == Date.today().addDays(5) );
    }

    @isTest
    private static void deleteOpp(){
        Opportunity oppUpdate = [SELECT id,Name,StageName,CloseDate FROM Opportunity LIMIT 1];
        Id idreserva = oppUpdate.Id;
        delete oppUpdate;
        
        List<Opportunity> deleteOpp = [SELECT id,Name,StageName,CloseDate FROM Opportunity WHERE Id =: idreserva LIMIT 1];
        system.assertEquals(0, deleteOpp.size()); 
        
        Opportunity reservaBorrada = new Opportunity(Id = idreserva);
        undelete reservaBorrada;
        List<Opportunity> recuperacionOpp = [SELECT id,Name,StageName,CloseDate FROM Opportunity WHERE Id =: idreserva LIMIT 1];
        system.assertEquals(1, recuperacionOpp.size());
    }
}
