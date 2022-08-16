@isTest
public class schedulableAsignarTripulacionTest {
    
    @isTest
    private static void testVuelo(){
        dateTime partida = DateTime.newInstanceGMT(2022, 8, 20, 0, 0, 0);
        Product2 vuelo = new Product2(Name = 'viaje de prueba', isActive = true,  Estado__c = 'En Venta', Fecha_y_hora_de_partida__c  = partida);
        insert vuelo;
        Product2 vueloTest = [SELECT id,Name,Fecha_y_hora_de_partida__c FROM Product2];
        
        Test.startTest();
        	DateTime fecha = (vueloTest.Fecha_y_hora_de_partida__c).addDays(-7);
            integer segundo = 0;
            integer minuto = 0;
            integer hora = 0;
            integer dia = fecha.day();
            integer mes = fecha.month();
            
            schedulableAsignarTripulacion m = new schedulableAsignarTripulacion(vueloTest.ID);
            String sch = '0 0 0 '+ dia + ' ' + mes + ' ? *';
            
        
        	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                         	FROM CronTrigger Limit 1];
        
            system.assertEquals(sch, ct.CronExpression);
            
            system.assertEquals(0, ct.TimesTriggered);
            
            system.assertEquals('13/08/2022 12:00:00',String.valueOf(ct.NextFireTime));
        Test.stopTest(); 
    }
    
}