public without sharing class TiqueteTriggerHandler implements TriggerHandler{
    
    private boolean triggerIsExecuting;
    private integer TriggerSize;

    public TiqueteTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<OpportunityLineItem> newRecords) {
        //agregarTiqueteVuelo(newRecords);
        //AsignarClaseNegocios(newRecords);
        //PasajeroDeReserva(newRecords);

       
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
        map<id , product2> productos = new map<id , product2>([SELECT ID,Avion__r.N_mero_de_pasajeros_clase_negocios__c,Avion__r.N_mero_de_pasajeros_clase_Turista__c 
                                                                FROM Product2 WHERE Id IN :idTiquetes]); 
        AggregateResult[] groupedResults = [SELECT Count(Id),Product2Id FROM OpportunityLineItem WHERE Product2Id IN :idTiquetes GROUP BY Product2Id  ];
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

    public static void AsignarClaseNegocios(List<OpportunityLineItem> tiqueteNew)
    {
        Pricebook2 listaPrecio = [SELECT Id FROM Pricebook2 WHERE name = 'clase negocio' limit 1];
        set<Id> idReserva = new set<Id>();
        for (OpportunityLineItem tiquete: tiqueteNew) {
            idReserva.add(tiquete.OpportunityId);
        }
        List<Opportunity> reservas = [SELECT Id FROM Opportunity WHERE Id IN : idReserva And Pricebook2Id =: listaPrecio.Id ];
        for(OpportunityLineItem t: tiqueteNew){
            for(Opportunity r: reservas){
                if(t.OpportunityId == r.Id){
                    t.Equipaje_permitido__c = 'Personal;Maleta de Cabina;Maleta de Bodega';
                }
            }
        }
    }

    public static void PasajeroDeReserva (List<OpportunityLineItem> tiquetes){
        List <Opportunity> reservas = new List<Opportunity>([SELECT Id,Titular_de_la_Reserva__c FROM Opportunity WHERE StageName = 'Pre-Venta']);
        for(opportunity reserva : reservas){
            for(opportunityLineItem tiquete : tiquetes){
                if (tiquete.OpportunityId == reserva.Id){
                    if(tiquete.Pasajero__c == null){
                        tiquete.Pasajero__c = reserva.Titular_de_la_Reserva__c;
                    }
                }       
            }
        }
    }
}