/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-08-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger SSolucionTrigger on Solucion__c (before insert,before update,before delete,after insert,after update,after delete, after undelete) {
        switch on trigger.operationType {
            when before_insert{
                System.debug('se inserto');
            }
            when before_update{
                System.debug('se actualizo');
            }
            when before_delete{
                System.debug('se borro');
            }
            when after_insert{
                System.debug('despues de insertar');
            }
            when after_update{
                System.debug('despues de actualizar');
            }
            when after_delete{
                System.debug('desdepues de borrar');
            }
            when after_undelete{
                System.debug('despues de recuperar');
            }
            when else{
                System.debug('invalido');
            }
        }
}