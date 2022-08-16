public with sharing class DescuentoMartesBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, UnitPrice FROM PricebookEntry WHERE descuento_50__c = FALSE');
    }

    public void execute(Database.BatchableContext BC, List<PricebookEntry> prices){
        for(PricebookEntry p : prices){
            Decimal precio = p.UnitPrice;
            p.UnitPrice = precio * 0.65;
            p.descuento_35__c = true;        
        } 
        update prices;

        Profile ventas = [SELECT Id, Name FROM Profile WHERE Name = 'Equipo de Ventas' LIMIT 1];

        List<User> usuarios = [SELECT Id, Name FROM User WHERE ProfileId = :ventas.Id AND isActive = true];
        List<Event> eventos = new List<Event>();
        if (usuarios.size() > 0) {
            for (User u : usuarios) {
                eventos.add(new Event(OwnerId = u.Id, StartDateTime = DateTime.now(), EndDateTime = DateTime.now().addHours(15), Subject = 'Martes de descuento'));
            }
            Insert eventos;
        }
    }

    public void finish(Database.BatchableContext BC){
        
    }
}