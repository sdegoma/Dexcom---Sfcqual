trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(trigger.isBefore){
        if(trigger.isInsert){
            LeadTriggerHandler.onBeforeInsert(trigger.new);
        }
        if(trigger.isUpdate){
            LeadTriggerHandler.onBeforeUpdate(trigger.new);
        }
    }

    if(trigger.isAfter){
        if(trigger.isUpdate){
            LeadTriggerHandler.onAfterUpdate(trigger.new);
        }
        if(trigger.isInsert){
            LeadTriggerHandler.onAfterInsert(trigger.new);
        }
    }
}