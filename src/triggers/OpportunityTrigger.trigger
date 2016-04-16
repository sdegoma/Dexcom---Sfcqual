trigger OpportunityTrigger on Opportunity (after insert, after update, before update, before insert) {
    if(trigger.IsBefore){
        if(trigger.isInsert){
            OpportunityTriggerHandler.beforeInsert(trigger.new);
        }
    }
    if(trigger.IsAfter){
        if(trigger.isInsert){
            OpportunityTriggerHandler.afterInsert(trigger.new);
        }
        
        if(trigger.isUpdate){
            if(UtilityClass.runOnce()){
                OpportunityTriggerHandler.afterUpdate(trigger.new, trigger.oldMap);
            }
        }
    }
}