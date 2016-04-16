trigger AddressTrigger on Address__c (after insert, after update, before delete) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            system.debug('***AFTER INSERT');
            AddressTriggerHandler.afterInsert(trigger.new);
             PresriberAddressTriggerhandler.afterInsert(trigger.new);
        }
        if(AddressTriggerHandler.runOnce()){
            if(trigger.isUpdate){
                system.debug('***AFTER INSERT');
                AddressTriggerHandler.afterUpdate(trigger.new, trigger.oldMap);
                PresriberAddressTriggerhandler.afterUpdate(trigger.new, trigger.oldMap);
            }
        }
    }
    if(trigger.isBefore){
    /*
        if(trigger.isDelete){
            AddressTriggerHandler.isBeforeDeleted(trigger.old);
        }
    */
    }
}