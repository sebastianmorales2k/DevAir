public with sharing class tripulacionRequerida {
    @AuraEnabled(cacheable=true)
    public static List<vuelo> getVuelosPendientes(){
        try {
                DateTime limitDate = DateTime.now().addDays(7);
                List<Product2> vuelos = [SELECT Id, Name, Avion__r.auxiliares_de_vuelo_requeridos__c, Copiloto__c, Piloto__c,
                                            (SELECT id FROM vueloXcontactos__r)
                                            FROM Product2 
                                            WHERE isActive = true 
                                            AND estado__c = 'En venta' 
                                            AND Fecha_y_hora_de_partida__c > TODAY 
                                            AND Fecha_y_hora_de_partida__c < :limitDate];
                List<vuelo> vuelosRta = new List<vuelo>();
                
                for(Product2 v : vuelos){
                    vuelosRta.add(new vuelo((string)v.id, v.name, (integer)v.Avion__r.auxiliares_de_vuelo_requeridos__c, 
                    v.Copiloto__c, v.Piloto__c, v.vueloXcontactos__r.size()));
                }
                System.debug(vuelosRta);
                return vuelosRta;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static list<opcion> getAuxiliares(string idVuelo){
        try {
                List<contact> auxiliaresDisponibles = [SELECT Id, Name 
                                                        FROM Contact 
                                                        WHERE RecordType.Name = 'Auxiliar de Vuelo'
                                                        LIMIT 20];
                List<vueloXcontacto__c> tripulantes = [SELECT id, Contacto__c, Contacto__r.Name 
                                                    FROM vueloXcontacto__c
                                                    WHERE Vuelo__c =: idVuelo];
                list<opcion> opciones = new list<opcion>();
                for(contact c : auxiliaresDisponibles){
                    opciones.add(new opcion(c.name,c.id,false));
                }

                for(vueloXcontacto__c t : tripulantes){
                    opciones.add(new opcion(t.Contacto__r.Name ,t.Contacto__c,true));
                }
                return opciones;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveAuxiliares(List<string> auxiliares, string idvuelo){
        try {
            //estos son los tripulantes que ya existen
            List<vueloXcontacto__c> tripulantes = [SELECT id, Contacto__c, Contacto__r.Name 
                                                FROM vueloXcontacto__c
                                                WHERE Vuelo__c =: idVuelo];
            
            set<string> noEncontrados = new set<string>(); 
            for(vueloXcontacto__c t : tripulantes){
                for(integer i = 0; i < auxiliares.size(); i++){
                    // vamos a remover los existentes de la lista que llego para no duplicarlos
                    if(t.Contacto__c == auxiliares[i]){
                        auxiliares.remove(i);
                        if(noEncontrados.contains(t.id)){
                            noEncontrados.remove(t.id);
                        }
                    } else {
                        // si no lo encuentra lo agrega a una lista para luego eliminarlos
                        noEncontrados.add(t.id);
                    }
                }
            }
            
            //creamos los nuevos tripulantes
            List<vueloXcontacto__c> nuevosTripulantes = new List<vueloXcontacto__c>();
            for(string a : auxiliares){
                nuevosTripulantes.add(new vueloXcontacto__c(vuelo__c = idVuelo, Contacto__c = a));
            }
            system.debug('nuevosTripulantes-->'+nuevosTripulantes);
            insert nuevosTripulantes;

            //eliminamos los que ya no van
            system.debug('noEncontrados-->'+noEncontrados);
            List<vueloXcontacto__c> paraBorrar = new List<vueloXcontacto__c>();
            for(string idT : noEncontrados){
                paraBorrar.add(new vueloXcontacto__c(id = idT));
            }
            delete paraBorrar;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class vuelo{
        @AuraEnabled
        public string idvuelo;
        @AuraEnabled
        public string codVuelo;
        @AuraEnabled
        public integer numaAuxiliares;
        @AuraEnabled
        public integer numAuxiliaresRestantes;
        @AuraEnabled
        public boolean copiloto;
        @AuraEnabled
        public  boolean piloto;

        public vuelo(string id, string name, integer auxiliares, string copilotoId, string pilotoId, integer sizeTripulantes){
            idvuelo = id;
            codVuelo = name;
            numaAuxiliares = auxiliares;
            numAuxiliaresRestantes = auxiliares - sizeTripulantes;
            copiloto = !string.isblank(copilotoId);
            piloto = !string.isblank(pilotoId);
        }
    }

    public class opcion{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
        @AuraEnabled
        public boolean selected;
        public opcion(string label, string value, boolean selected){
            this.label = label;
            this.value = value;
            this.selected = selected;
        }
    }
}
