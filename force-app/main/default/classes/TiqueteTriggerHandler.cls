public without sharing class TiqueteTriggerHandler implements TriggerHandler{
    
    private boolean triggerIsExecuting;
    private integer TriggerSize;

    public TiqueteTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<OpportunityLineItem> newRecords) {
        agregarTiqueteVuelo(newRecords);
        AsignarClaseNegocios(newRecords);
       
    }
    public void beforeUpdate(List<OpportunityLineItem> oldRecords, List<OpportunityLineItem> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void beforeDelete(List<OpportunityLineItem> oldRecords, Map<ID, SObject> oldRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterInsert(List<OpportunityLineItem> newRecords, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterUpdate(List<OpportunityLineItem> oldRecords, List<OpportunityLineItem> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterDelete(List<OpportunityLineItem> oldRecords, Map<ID, SObject> oldRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }
    public void afterUndelete(List<OpportunityLineItem> newRecords, Map<ID, SObject> newRecordMap) {
        System.debug('En este momento se esta ante de insertar');
    }

    public static void agregarTiqueteVuelo(List<OpportunityLineItem> tiquetes){

        set <Id> idTiquetes = new set<Id>();
        for (opportunityLineItem Tiquete : tiquetes)
        {
            idTiquetes.add(Tiquete.Product2Id);
        }
        map<id , product2> productos = new map<id , product2>([SELECT ID,Avion__r.Id,Avion__r.N_mero_de_pasajeros_clase_negocios__c,Avion__r.N_mero_de_pasajeros_clase_Turista__c 
                                                                FROM Product2 WHERE Id IN :idTiquetes]); 
        AggregateResult[] groupedResults = [SELECT Count(Id),Product2Id FROM OpportunityLineItem where Product2Id IN :idTiquetes GROUP BY Product2Id  ];
        List<Product2> vuelos = new List<Product2>();
        for (AggregateResult ar : groupedResults){
            system.debug(ar.get('Product2Id'));
            system.debug(ar.get('expr0'));
            decimal pasajerosTotales = productos.get((string)ar.get('Product2Id')).Avion__r.N_mero_de_pasajeros_clase_negocios__c+productos.get((string)ar.get('Product2Id')).Avion__r.N_mero_de_pasajeros_clase_Turista__c;
            if ((pasajerosTotales*1.1)<(integer)ar.get('expr0')) {
                vuelos.add(new product2(id=(string)ar.get('Product2Id')));
            } 
        }
        for(opportunityLineItem a: tiquetes){
            for(product2 p: vuelos){
                if (a.Product2Id==p.Id){
                    a.adderror('No es posible sobrevender los tiquetes');
                }
            }
        }
    }

    

    public static void AsignarClaseNegocios(List<OpportunityLineItem> tiquetes){
        set <Id> idVuelos = new set<Id>();
        for (OpportunityLineItem tiq : tiquetes) {
            idVuelos.add(tiq.product2id);            
        }
        String idNegocios = [SELECT id FROM Pricebook2 WHERE Name = 'Tiquetes Clase Negocios' LIMIT 1].Id;
        List<PricebookEntry> listEntry = [SELECT Id, Pricebook2Id, Product2Id FROM PricebookEntry WHERE Pricebook2Id =: IdNegocios AND Product2Id IN : idVuelos];
        for (PricebookEntry enLis: listEntry) {
            for (OpportunityLineItem tiq : tiquetes) {
                if (tiq.product2id == enLis.product2id){
                    tiq.Equipaje_permitido__c = 'Maleta de cabina;Maleta de bodega';
                }
            }
        }
    }
}