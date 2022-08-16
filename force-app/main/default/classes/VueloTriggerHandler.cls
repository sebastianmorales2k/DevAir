public without sharing class VueloTriggerHandler implements TriggerHandler{
    
    private boolean triggerIsExecuting;
    private integer TriggerSize;

    public VueloTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<SObject> newRecords) {
        System.debug('En este momento se esta ante de insertar');
        
    }
    public void beforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        DesactivarVuelo(newRecords);
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
    
    public void DesactivarVuelo(List<Product2> vuelos){
        for(Product2 v : vuelos){
            if(v.IsActive != false && (v.Estado__c == 'Terminado' || v.Estado__c == 'Cancelado')){
                v.IsActive = false;
                if(v.Estado__c == 'Cancelado' && String.isNotEmpty(v.Motivo_de_cancelaci_n__c)){
                    date fecha = date.today();
                    v.Fecha_de_cancelaci_n__c = fecha;
                }else if(v.Estado__c == 'Cancelado'){
                    v.Motivo_de_cancelaci_n__c.addError('Debe agregar un motivo de cancelación');
                }     
            }
         }
    }

    public void nombreAleatorio(List<Product2> vuelos){
        for(Product2 v : vuelos){
            String aleatorio = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 6);
            v.Name = 'AE-'+aleatorio;
        }
    }
/*
    public void AsignarTripulacion(List<Product2> vuelos){
        for(Product2 v : vuelos){
            DateTime fecha = (v.Fecha_y_hora_de_partida__c).addDays(-7);
            integer segundo = 0;
            integer minuto = 0;
            integer hora = 0;
            integer dia = fecha.day();
            integer mes = fecha.month();
            
            schedulableAsignarTripulacion m = new schedulableAsignarTripulacion(v.ID,v.Name);
            String sch = '0 0 0 '+ dia + ' ' + mes + ' ? *';
            String jobID = system.schedule('Asignar Tripulacion: '+v.Name, sch, m);
        }
    }
*/
    public void notificationDetripulacion(List<Product2> vuelos){
        for(Product2 v : vuelos){
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Asignar_tripulantes'];
            List<user> usuarios = [SELECT id, name FROM user WHERE UserRole.Name = 'Administrador del sistema'];
            set<String> ids = new set<String>();
            for(user a: usuarios){
                ids.add(a.Id);
            }
            notification.setTitle('Asignar Tripulacion:  ');
            notification.setBody('asignar la tripulacion'+ v.Name);
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(v.Id); 
            try {
                notification.send(ids);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }
    }
}