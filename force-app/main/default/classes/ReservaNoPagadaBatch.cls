public with sharing class ReservaNoPagadaBatch implements Database.Batchable<sObject>{
   
    DateTime fecha = DateTime.now().addHours(+3);
    public Database.QueryLocator start(Database.BatchableContext context){
                return Database.getQueryLocator('SELECT id, StageName, LastModifiedDate FROM Opportunity');
        }
    
        public void execute(Database.BatchableContext BC, List<Opportunity> reservas){
            List<String> tiquetes = new List<String>();

            try {
                
                for(Opportunity op : reservas){                
                    if (op.LastModifiedDate <= fecha  && (op.StageName == 'Pre-venta' || op.StageName == 'Completado')) {
                        op.StageName = 'No pagado';
                        tiquetes.add(op.Id);
                    }                     
                } 
                update reservas;

                List<OpportunityLineItem> eliminar = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId IN : tiquetes ];
                delete eliminar;
                System.debug('Actualizacion---->'+reservas);
            } catch (Exception e) {
                System.debug('error--->'+e.getMessage());
            } 
            
        }
    
        public void finish(Database.BatchableContext BC){
            
        }
}