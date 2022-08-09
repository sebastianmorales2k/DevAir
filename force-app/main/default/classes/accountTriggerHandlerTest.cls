@isTest
public with sharing class accountTriggerHandlerTest {

    @isTest
    static void PruebaPositiva(){
        Account cuenta = new Account(Name = 'cuenta Test');
        insert cuenta;

        case casoCreado = [SELECT Subject FROM case limit 1];

        system.assertEquals('Dedupe this Account', casoCreado.Subject);
    }

    @isTest
    static void PruebaMasiva(){
       List<Account> cuentas = new List<Account>();
       
       for(Integer i = 0; i < 200; i++){
        Account cuenta = new Account (Name = 'cuenta test'+ i);
        cuentas.add(cuenta);
       }

       insert cuentas;
       
       List<Case> casos = new List<case>();
       casos = [SELECT Id FROM Case];

       system.assertEquals(200, casos.size());
    }
}
