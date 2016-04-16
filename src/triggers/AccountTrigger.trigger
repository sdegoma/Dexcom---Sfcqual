trigger AccountTrigger on Account (before insert, before update, after update) {

    if(trigger.isBefore){
        if(trigger.isInsert){
            AccountTriggerHandler.onBeforeInsert(trigger.new);
       
        }
        if(trigger.isUpdate){
            AccountTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);   
            AccountTerritoryUpdate.PrescribersTerritoryBeforeUpdate(Trigger.new);
            AccountTerritoryUpdate.PrescribersOwnerupdate(Trigger.new);
            AccountTerritoryUpdate.ConsumersTerritoryBeforeUpdate(Trigger.new);
            AccountTerritoryUpdate.ConsumersOwnerupdate(Trigger.new);
            AccountTerritoryUpdate.AccountPartyIDUpdate(trigger.new);
        }
    }
}