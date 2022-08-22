@isTest
public with sharing class accountTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        Account cuenta = new Account(Name = 'Test');
        insert cuenta;
    }

    @isTest
    static void PruebaPositiva(){
        Account cuenta = new Account(Name = 'cuenta Test');
        insert cuenta;

        case casoCreado = [SELECT Subject FROM case LIMIT 1];

        system.assertEquals('Dedupe this Account', casoCreado.Subject);
    }

    @isTest
    static void PruebaMasiva(){
       List<Account> cuentas = new List<Account>();
       
       for(Integer i = 0; i < 50; i++){
        Account cuenta = new Account (Name = 'cuenta test'+ i);
        cuentas.add(cuenta);
       }

       insert cuentas;
       
       List<Case> casos = new List<case>();
       casos = [SELECT Id FROM Case];

       system.assertEquals(51, casos.size());
    }

    @isTest
    static void actualizar() {
        Account actualizada = [SELECT Id, Name FROM Account WHERE Name ='Test'];
        actualizada.Name = 'Test actualizado';
        update actualizada;

        Account pruebaUpdate = [SELECT Id, Name FROM Account WHERE Name ='Test actualizado'];
        System.assertEquals('Test actualizado', pruebaUpdate.Name);
    }

    @isTest
    static void borrar() {
        Account accPruebas = [SELECT Id FROM Account LIMIT 1];
        Id accId = accPruebas.Id;
        Case casosPrueba = [SELECT Id FROM Case WHERE AccountId =: accId];
        delete casosPrueba;
        delete accPruebas;

        List<Account> eliminada = [SELECT id FROM Account WHERE Id =: accId];
        system.assertEquals(0, eliminada.size()); 

        Account recuperarAcc = new Account(Id = accId);
        undelete recuperarAcc;
        
        List<Account> CuentaRestaurada = [SELECT Id FROM Account WHERE Id =: accId];
        system.assertEquals(1, CuentaRestaurada.size());
    }
}

