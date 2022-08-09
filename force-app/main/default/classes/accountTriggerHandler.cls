/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-12-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

public without sharing class accountTriggerHandler implements TriggerHandler{
    
    private boolean triggerIsExecuting;
    private integer TriggerSize;

    public AccountTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public static void annoDeInicio(List<Account> cuenta) {
        for (Account cta : cuenta){
            
            system.debug('hola'+cta.YearStarted);
            
            if (cta.YearStarted == null) {
                system.debug('Entra');
                cta.YearStarted = String.valueOf(date.today().year());
            }
            
            
        }
    }

    public static void numeroAleatorio(List<Account> cuenta){
        for (Account cta : cuenta){
            if (cta.AccountNumber == null) {
                system.debug('Entra2');
                Integer IntrandomNumber = Integer.valueof(Math.random() * 10000000);
                cta.AccountNumber = String.valueof(IntrandomNumber);
                IntrandomNumber += 1; 
            }
        }
    }

    public static void prioridadCliente(List<Account> cuenta){
        for (Account cta : cuenta){
            if (cta.CustomerPriority__c == 'High' && cta.SLA__c != 'Gold' || 
                cta.CustomerPriority__c == 'Medium' && cta.SLA__c != 'Silver' ||
                cta.CustomerPriority__c == 'Low' && cta.SLA__c != 'Bronze'){
                    cta.addError('seleccion invalida');
                    system.debug('seleccion invalida');
                } 
    
                else{
                    switch on cta.CustomerPriority__c {
                        when 'High' {
                        cta.SLA__c = 'Gold';
                        }
                        when 'Medium' {
                        cta.SLA__c = 'Silver';
                        }
                        when 'Low' {
                        cta.SLA__c = 'Bronze';
                        }
                        when else {
                        cta.SLA__c = null;
                        }
                    }   
                }
        }
    }

    public static void DupeReminder(List<Account> cuenta){
        List<Case> casos = new List<Case>();
        for(Account acc: cuenta){
            Case c = new Case();
            c.Subject = 'Dedupe this Account';
            c.OwnerId = acc.OwnerId;
            c.AccountId = acc.Id;
            casos.add(c);
        }
        insert casos;
    }

    public void beforeInsert(List<SObject> newRecords) {
        annoDeInicio(newRecords);
        numeroAleatorio(newRecords);
        prioridadCliente(newRecords);
    }
    public void beforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        annoDeInicio(trigger.new);
        numeroAleatorio(trigger.new);
        prioridadCliente(trigger.new);
    }
    public void beforeDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {
        // code block
    }
    public void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap) {
        // code block
    }
    public void afterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        // code block
    }
    public void afterDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {
        // code block
    }
    public void afterUndelete(List<SObject> newRecords, Map<ID, SObject> newRecordMap) {
        // code block
    }

    public static void DedupeReminder(List<Account> cuenta){
        List<Case> casos = new List<Case>();
        for(Account acc: cuenta){
            Case c = new Case();
            c.Subject = 'Dedupe this Account';
            c.OwnerId = acc.OwnerId;
            c.AccountId = acc.Id;
            casos.add(c);
        }
        insert casos;
    }
}
