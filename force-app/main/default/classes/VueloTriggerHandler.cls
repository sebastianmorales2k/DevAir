public without sharing class VueloTriggerHandler implements TriggerHandler{
    
    private boolean triggerIsExecuting;
    private integer TriggerSize;

    public VueloTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Product2> newRecords) {
        nombreAleatorio(newRecords);        
    }
    public void beforeUpdate(List<Product2> oldRecords, List<Product2> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        DesactivarVuelo(newRecords);
    }
    public void beforeDelete(List<Product2> oldRecords, Map<ID, SObject> oldRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterInsert(List<Product2> newRecords, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterUpdate(List<Product2> oldRecords, List<Product2> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterDelete(List<Product2> oldRecords, Map<ID, SObject> oldRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterUndelete(List<Product2> newRecords, Map<ID, SObject> newRecordMap) {
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
}