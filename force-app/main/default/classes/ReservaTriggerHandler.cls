public without sharing class ReservaTriggerHandler implements TriggerHandler{
    
    private boolean triggerIsExecuting;
    private integer TriggerSize;

    public ReservaTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Opportunity> newRecords) {
        NombreDeReserva(newRecords);
        correoReserva(newRecords);
        AsignarVuelos(newRecords);
    }
    public void beforeUpdate(List<Opportunity> oldRecords, List<Opportunity> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        AsignarVuelos(newRecords);
        correoReserva(newRecords);
    }
    public void beforeDelete(List<Opportunity> oldRecords, Map<ID, SObject> oldRecordMap) {

    }
    public void afterInsert(List<Opportunity> newRecords, Map<ID, SObject> newRecordMap) {

    }
    public void afterUpdate(List<Opportunity> oldRecords, List<Opportunity> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {

    }
    public void afterDelete(List<Opportunity> oldRecords, Map<ID, SObject> oldRecordMap) {

    }
    public void afterUndelete(List<Opportunity> newRecords, Map<ID, SObject> newRecordMap) {

    }
	
   
    public static void AsignarVuelos(List<Opportunity> oportunidad){
        for(Opportunity reserva : oportunidad){
            if((reserva.N_mero_de_vuelos__c<1 && reserva.StageName == 'Pagado')||(reserva.N_mero_de_vuelos__c<1 && reserva.StageName == 'Completado')){
                reserva.N_mero_de_vuelos__c.addError('asigne por lo menos un vuelo para continuar');
            } 
        }
    }

    public static void NombreDeReserva(List<Opportunity> opportunities) {
        set <Id> TitularesID = new set<Id>();
        for(Opportunity opp : opportunities){
            TitularesID.add(opp.Titular_de_la_Reserva__c);
        }
        Map<Id, Contact>  Titulares = new Map<Id, Contact>([SELECT Id,Name FROM Contact WHERE Id = : TitularesID]);
        
        for (Opportunity opp : opportunities) {
            if(String.isNotEmpty(opp.Name)){
                String NumeroDeReserva = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 7);
                opp.Name = Titulares.get(opp.Titular_de_la_Reserva__c).name.replace(' ','') +'-'+ NumeroDeReserva;
                System.debug('nombre de reserva: '+ opp.Name);
            }
        }
    }
    
    public static void correoReserva(List<Opportunity> oportunidades){
        List<String> idContactos= new list<String>();
        for(Opportunity reserva: oportunidades){
            if(reserva.StageName == 'Pagado'){
            	idContactos.add(reserva.Titular_de_la_reserva__c);
            }
        }
        if(idContactos.size()>0){
           EmailTemplate et=[SELECT id FROM EmailTemplate WHERE name = 'Reserva Pagada' LIMIT 1];
           Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
           mail.setTargetObjectIds(idContactos);
           mail.setSenderDisplayName('System Admin');
           mail.setTemplateId(et.id);
           Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail }); 
        }
 	}
}
