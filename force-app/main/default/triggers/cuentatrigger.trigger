/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-12-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger cuentatrigger on Account (before insert, before update, before delete, 
                                  after insert, after update, after delete, after undelete) {    
    
    TriggerHandler handler = new AccountTriggerHandler(trigger.isExecuting, trigger.size);
    switch on trigger.operationType {
        when  BEFORE_INSERT{
            system.debug('ingresa before insert');
            handler.beforeInsert(trigger.new);
            /*accountTriggerHandler.annoDeInicio(trigger.new);
            accountTriggerHandler.numeroAleatorio(trigger.new);
            accountTriggerHandler.prioridadCliente(trigger.new);*/
        }
        when  BEFORE_UPDATE{
            system.debug('ingresa before update');
            handler.beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
            /*accountTriggerHandler.annoDeInicio(trigger.new);
            accountTriggerHandler.numeroAleatorio(trigger.new);
            accountTriggerHandler.prioridadCliente(trigger.new);*/
            
        }
        when  BEFORE_DELETE{
            System.debug('En este momento se esta ante de insertar');
            
        }
        when  AFTER_INSERT{
            System.debug('En este momento se esta ante de insertar');
            
        }
        when  AFTER_UPDATE{
            System.debug('En este momento se esta ante de insertar');
            
        }
        when  AFTER_DELETE{
            System.debug('En este momento se esta ante de insertar');
            
        }
        when  AFTER_UNDELETE{
            System.debug('En este momento se esta ante de insertar');
            
        }
        when else {
            System.debug('En este momento no pasa nada');
            
        }
    }
}