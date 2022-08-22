trigger cuentatrigger on Account (before insert,before update,before delete,after insert,after update, after delete, after undelete) {
    triggerHandler cuenta = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size);

    switch on trigger.OperationType {
        when before_insert {
            system.System.debug('El desencadenador es antes de insertar');
            cuenta.beforeInsert(trigger.new);
        }
        when before_update{
            system.System.debug('El desencadenador es antes de update');
            cuenta.beforeUpdate(trigger.old,trigger.new,trigger.oldMap, trigger.newMap);
        }
        when before_delete{ 
            system.System.debug('El desencadenador es antes de delete');
            cuenta.beforeDelete(trigger.old,trigger.oldMap);
        }
        when after_insert {
            system.System.debug('El desencadenador es despues de insertar');
            cuenta.afterInsert(trigger.new,trigger.newMap);
        }
        when after_update {
            system.System.debug('El desencadenador es despues de update');
            cuenta.afterUpdate(trigger.old,trigger.new,trigger.oldMap, trigger.newMap);
        }
        when after_delete {
            system.System.debug('El desencadenador es despues de delete');
            cuenta.afterDelete(trigger.old,trigger.oldMap);
        }
        when after_undelete{
            system.debug('El desencadenador es despues de undelete');
            cuenta.afterUndelete(trigger.new,trigger.newMap);
        }        
        when else {
            system.System.debug('El desencadenador es nada');
        }
    }
}