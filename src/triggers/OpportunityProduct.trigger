trigger OpportunityProduct on OpportunityLineItem (before insert) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            OpportuntiyLineItemTriggerHandler.beforeInsert(trigger.new);
        }
    }
}