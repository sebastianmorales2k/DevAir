public with sharing class contactoReserva {
  
    @AuraEnabled
    public static ctoReserva clienteReserva(string tipoId, string numId){
        contact cliente = null;
        Opportunity reserva = null;
        List<Contact> contacto = [SELECT Id, Name, N_mero_de_indetificacion__c,	N_mero_de_Pasaporte__c 
        FROM Contact WHERE Tipo_de_Indetificacion__c =: tipoId AND N_mero_de_indetificacion__c =: numId LIMIT 1];

        List<Opportunity> reservaExistente = new List<Opportunity>();

        if(contacto.size() > 0){
        cliente = contacto[0];
        reservaExistente = [SELECT Id, Name, StageName FROM Opportunity WHERE StageName NOT IN ('Pagado', 'No pagado') 
            AND Titular_de_la_Reserva__c =: cliente.Id LIMIT 1];
        }

        if(reservaExistente.size() > 0){
        reserva = reservaExistente[0];
        }

        ctoReserva resultado = new ctoReserva(cliente, reserva);
        return resultado;

    }

    @AuraEnabled
    public static Opportunity crearReserva(string contaId, string listaPrecio){
        try {
            List<Pricebook2> listasPrecios = [SELECT Id, Name FROM Pricebook2];
            Id idLista;
            for(Pricebook2 a: listasPrecios ){
                if(a.Name == listaPrecio ){
                    idLista = a.Id;
                }
            }
            date fechapagar = Date.today();
            Opportunity nuevaReserva = new Opportunity(Titular_de_la_Reserva__c = contaId, StageName = 'Pre-venta', Name = 'a', CloseDate = fechapagar, Pricebook2Id = idLista);
            insert(nuevaReserva);
            return nuevaReserva;
        } catch (Exception e) {
            return null;
        }

    }

    @AuraEnabled
    public static List<OpportunityLineItem> crearTiquete(string reserva, string contacto, List<string> vuelo){
        try {
            List<OpportunityLineItem> listaTiq = new List<OpportunityLineItem>();
            for(string IdV : vuelo){
                OpportunityLineItem newTiquete = new OpportunityLineItem(OpportunityId = reserva, Product2Id = IdV, Quantity = 1, Pasajero__c = contacto);
                listaTiq.add(newTiquete);
            }
            insert listaTiq;
            return listaTiq;
        } catch (Exception e) {
            return null;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<vuelo> obtenerVuelos(string idListaPrecios){
        try{
            List<Product2> listado = [SELECT Id, Name,Aeropuerto_de_partida__r.Name,Aeropuerto_de_partida__r.Pais__c,
                                    Aeropuerto_de_llegada__r.Name,Aeropuerto_de_llegada__r.Pais__c,Fecha_y_hora_de_partida__c,Fecha_y_hora_estimada_de_llegada__c,  
                                    (SELECT unitprice FROM pricebookEntries WHERE Pricebook2Id =: idListaPrecios )FROM Product2 WHERE Estado__c = 'En Venta' AND IsActive = true ];

            List<Vuelo> vuelosRta = new List<Vuelo>();

            for(Product2 a: listado){
                if(a.pricebookEntries.size() > 0){
                    vuelosRta.add(new vuelo((string)a.Id, a.Name, a.Aeropuerto_de_partida__r.Name,a.Aeropuerto_de_partida__r.Pais__c,
                                a.Aeropuerto_de_llegada__r.Name,a.Aeropuerto_de_llegada__r.Pais__c, a.Fecha_y_hora_de_partida__c, a.Fecha_y_hora_estimada_de_llegada__c,
                                a.pricebookEntries[0].unitprice));
                }
                
            }

            return vuelosRta;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        } 
    }





    @AuraEnabled(cacheable = true)
    public static string listaPrecios(string entradaDeLista){
        Pricebook2 precios = [SELECT Id FROM Pricebook2 WHERE  Name =: entradaDeLista LIMIT 1];
        string nombreLista = precios.Id;
        return nombreLista;
    }
    


    public class ctoReserva{
        @auraEnabled 
        public Contact contacto;
        @auraEnabled 
        public Opportunity oportunidad;
        
        public ctoReserva(Contact cliente, Opportunity reserva){
            contacto = cliente;
            oportunidad = reserva;
        }

    }




    public class vuelo{
        
        @AuraEnabled 
        public string codigo {get;set;}
        @AuraEnabled 
        public string idVuelo {get;set;}      
        @AuraEnabled 
        public string aeropuertoPartida {get;set;}
        @AuraEnabled 
        public string aeropuertoPartidaPais {get;set;}
        @AuraEnabled
        public string aeropuertoLlegada {get;set;}       
        @AuraEnabled 
        public string aeropuertoLlegadaPais {get;set;} 
        @AuraEnabled 
        public DateTime fechaPartida {get;set;}
        @AuraEnabled 
        public DateTime fechaLlegada {get;set;}
        @AuraEnabled 
        public decimal precioUnitario {get;set;}  

        public Vuelo(string id, string codigoVuelo, string aeropuertoDePartida, string aeroPartidaPais, string aeropuertoDeLlegada, string aeroLlegadaPais, DateTime fechaDePartida, DateTime fechaDeLlegada, decimal precio) {
            idVuelo= id;
            codigo= codigoVuelo;
            aeropuertoPartida= aeropuertoDePartida; 
            aeropuertoPartidaPais = aeroPartidaPais;
            aeropuertoLlegada= aeropuertoDeLlegada;
            aeropuertoLlegadaPais = aeroLlegadaPais;
            fechaPartida= fechaDePartida;
            fechaLlegada= fechaDeLlegada;
            precioUnitario = precio;
        }
    }  
}