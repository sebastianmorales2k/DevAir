public with sharing class Reservas {
    @AuraEnabled(cacheable = true)
    public static ValidacionRes getContactos(string numId, string tipoId){
        try {
            Contact cliente = null;
            Opportunity reserva = null;
        
            List<Contact> pasajero = [SELECT Id, Name, N_mero_de_indetificacion__c, N_mero_de_Pasaporte__c FROM Contact 
                                 WHERE Tipo_de_Indetificacion__c =: tipoId
                                 AND N_mero_de_indetificacion__c =: numId
                                 LIMIT 1];
            List<Opportunity> reservaAsignada = new List<Opportunity>();

            if (pasajero.size() == 1) {
            cliente = pasajero[0];
            reservaAsignada = [SELECT Id, Name, StageName FROM Opportunity
                                WHERE Titular_de_la_Reserva__c =: cliente.Id
                                AND StageName NOT IN ('Pagado', 'No pagado')];
            }

            if (reservaAsignada.size() == 1) {
                reserva = reservaAsignada[0];
            }
        
            ValidacionRes resultado = new ValidacionRes(cliente, reserva);
            return resultado;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static Opportunity crearReserva(string idcontactoCliente, string listaPrecio){
        List<Pricebook2> listasPrecios = [SELECT Id, Name FROM Pricebook2];
        Id idLista;
        for(Pricebook2 a: listasPrecios ){
            if(a.Name == listaPrecio ){
                idLista = a.Id;
            }
        }
        date fechapagar = Date.today();
        Opportunity nuevaReserva = new Opportunity(Titular_de_la_Reserva__c = idcontactoCliente, StageName = 'Pre-venta', Name = 'a', CloseDate = fechapagar, Pricebook2Id = idLista);
        insert(nuevaReserva);
        return nuevaReserva;
    }


    @AuraEnabled(cacheable = true)
    public static List<vuelosDispo> getVuelos(string idListaPrecios){
        try {
                List<Product2> vuelos = [SELECT Id, Name, Aeropuerto_de_Llegada__r.Name, Aeropuerto_de_partida__r.Name, Fecha_y_hora_de_partida__c, Fecha_y_hora_real_de_llegada__c,
                                        (SELECT unitprice FROM pricebookEntries WHERE Pricebook2Id =: idListaPrecios )
                                        FROM Product2
                                        WHERE Fecha_y_hora_de_partida__c > TODAY
                                        AND Estado__c = 'En Venta' 
                                        AND IsActive = true];

                List<vuelosDispo> listaVuelos = new List<vuelosDispo>();

                for(Product2 p : vuelos){
                    if(p.pricebookEntries.size() > 0){
                        listaVuelos.add(new vuelosDispo((string)p.id, p.Name, p.Aeropuerto_de_Llegada__r.Name, p.Aeropuerto_de_partida__r.Name, p.Fecha_y_hora_de_partida__c, p.Fecha_y_hora_real_de_llegada__c, p.pricebookEntries[0].unitprice));
                    }  
                }
                return listaVuelos;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class ValidacionRes {
        @AuraEnabled
        public Contact contacto;
        @AuraEnabled
        public Opportunity oportunidad;

        public ValidacionRes(Contact pasajero, Opportunity reserva){
            contacto = pasajero;
            oportunidad = reserva;
        }
    }

    public class vuelosDispo {
        @AuraEnabled
        public string IdVuelo {get;set;}
        @AuraEnabled
        public string numVuelo {get;set;}
        @AuraEnabled
        public string aeroPartida {get;set;}
        @AuraEnabled
        public string aeroLlegada {get;set;}
        @AuraEnabled
        public DateTime fechaLlegada {get;set;}
        @AuraEnabled
        public DateTime fechaPartida {get;set;}
        @AuraEnabled 
        public decimal precioUnitario {get;set;}  

        
        public vuelosDispo(string IdV, string numV, string aeroLle, string aeroPar, DateTime fechaLle, DateTime fechaPar, decimal precio){
            IdVuelo = IdV;
            numVuelo = numV;
            aeroPartida = aeroPar;
            aeroLlegada = aeroLle;
            fechaLlegada = fechaLle;  
            fechaPartida = fechaPar;
            precioUnitario = precio;

        }
    }
}
