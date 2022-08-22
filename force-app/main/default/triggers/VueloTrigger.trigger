trigger VueloTrigger on Product2 (before insert,before update,before delete,after insert,after update, after delete, after undelete) {
    
    triggerHandler Vuelo  = new VueloTriggerHandler(Trigger.isExecuting, Trigger.size);  
    
    switch on trigger.OperationType {
        when before_insert {
            system.System.debug('El desencadenador es antes de insertar');
            Vuelo.beforeInsert(trigger.new);
        }
        when before_update{
            system.System.debug('El desencadenador es antes de update');
            Vuelo.beforeUpdate(trigger.old,trigger.new,trigger.oldMap, trigger.newMap);
        }
        when before_delete{ 
            system.System.debug('El desencadenador es antes de delete');
            Vuelo.beforeDelete(trigger.old,trigger.oldMap);
        }
        when after_insert {
            system.System.debug('El desencadenador es despues de insertar');
            Vuelo.afterInsert(trigger.new,trigger.newMap);
        }
        when after_update {
            system.System.debug('El desencadenador es despues de update');
            Vuelo.afterUpdate(trigger.old,trigger.new,trigger.oldMap, trigger.newMap);
        }
        when after_delete {
            system.System.debug('El desencadenador es despues de delete');
            Vuelo.afterDelete(trigger.old,trigger.oldMap);
        }
        when after_undelete{
            system.debug('El desencadenador es despues de undelete');
            Vuelo.afterUndelete(trigger.new,trigger.newMap);
        }        
        when else {
            system.System.debug('El desencadenador es nada');
        }
    }
}