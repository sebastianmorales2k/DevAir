trigger TiqueteTrigger on OpportunityLineItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {    
    
    TriggerHandler Tiquete = new TiqueteTriggerHandler(trigger.isExecuting, trigger.size);

    switch on trigger.operationType {
        when  BEFORE_INSERT{
            system.debug('ingresa before insert');
            Tiquete.beforeInsert(trigger.new);
        }
        
        when  BEFORE_UPDATE{
            system.debug('ingresa before update');
            Tiquete.beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);    
        }

        when  BEFORE_DELETE{
            System.debug('En este momento se esta ante de insertar');    
        }

        when  AFTER_INSERT{
            System.debug('despues de insertar');    
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