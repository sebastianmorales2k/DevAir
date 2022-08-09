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
}