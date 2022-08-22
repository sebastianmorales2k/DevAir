trigger reservaTrigger on Opportunity (before insert,before update,before delete,after insert,after update, after delete, after undelete) {
    triggerHandler Reserva = new ReservaTriggerHandler(Trigger.isExecuting, Trigger.size);  
    
    switch on trigger.OperationType {
        when before_insert {
            system.System.debug('El desencadenador es antes de insertar');
            Reserva.beforeInsert(trigger.new);
        }
        when before_update{
            system.System.debug('El desencadenador es antes de update');
            Reserva.beforeUpdate(trigger.old,trigger.new,trigger.oldMap, trigger.newMap);
        }
        when before_delete{ 
            system.System.debug('El desencadenador es antes de delete');
            Reserva.beforeDelete(trigger.old,trigger.oldMap);
        }
        when after_insert {
            system.System.debug('El desencadenador es despues de insertar');
            Reserva.afterInsert(trigger.new,trigger.newMap);
        }
        when after_update {
            system.System.debug('El desencadenador es despues de update');
            Reserva.afterUpdate(trigger.old,trigger.new,trigger.oldMap, trigger.newMap);
        }
        when after_delete {
            system.System.debug('El desencadenador es despues de delete');
            Reserva.afterDelete(trigger.old,trigger.oldMap);
        }
        when after_undelete{
            system.debug('El desencadenador es despues de undelete');
            Reserva.afterUndelete(trigger.new,trigger.newMap);
        }        
        when else {
            system.System.debug('El desencadenador es nada');
        }

        
    }
}