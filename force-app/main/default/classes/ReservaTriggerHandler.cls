public without sharing class ReservaTriggerHandler implements TriggerHandler{
    
    private boolean triggerIsExecuting;
    private integer TriggerSize;

    public ReservaTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<SObject> newRecords) {
        NombreDeReserva(newRecords);
        ReservaPagada(newRecords);
        AsignarVuelos(newRecords);
    }
    public void beforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
        AsignarVuelos(newRecords);
    }
    public void beforeDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterUndelete(List<SObject> newRecords, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
	
   
    public static void NombreDeReserva(List<Opportunity> opportunities) {
        set <Id> TitularesID = new set<Id>();
        for(Opportunity opp : opportunities){
            TitularesID.add(opp.Titular_de_la_Reserva__c);
        }
        Map<Id, Contact>  Titulares = new Map<Id, Contact>([SELECT Name FROM Contact WHERE Id = : TitularesID]);
        
        for (Opportunity opp : opportunities) {
            if(String.isNotEmpty(opp.Name)){
                Integer NumeroDeReserva = Integer.valueof(Math.random() * 100000);
                opp.Name = Titulares.get(opp.Titular_de_la_Reserva__c).name + NumeroDeReserva;
                System.debug('nombre de reserva: '+ opp.Name);
            }
        }
    }
    
    public static void ReservaPagada(List<Opportunity> reserva){
        for (Opportunity opp : reserva){
            if (opp.StageName == 'Pagado') {
                opp.Fecha_de_Pago__c = Date.newInstance(Date.today().year(), date.today().month(), Date.today().day());
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                String[] toAddresses = new String[] { 'jsebastian.morales18@gmail.com' };                
                mail.setToAddresses(toAddresses);
                mail.setReplyTo('support@acme.com');
                mail.setSenderDisplayName('Salesforce Support');
                mail.setSubject('CONFIRMACION DE RESERVA');
                mail.setPlainTextBody('bienvenido '+ opp.Titular_de_la_reserva__c +' su reserva número ' 
                                    + opp.Numero_de_reserva__c + ' ha sido creada');

                mail.setUseSignature(false);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                Messaging.SendEmailResult[] results = Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail });

                inspectResults(results);
            }            
        }
    }
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
    public static void AsignarVuelos(List<Opportunity> oportunidad){
        for(Opportunity reserva : oportunidad){
            if((reserva.Numero_de_vuelos__c < 1 && reserva.StageName == 'Pagado')||(reserva.Numero_de_vuelos__c < 1 && reserva.StageName == 'Completado')){
                reserva.Numero_de_vuelos__c.addError('debe asignar un vuelo');
            }
        }
    }
}