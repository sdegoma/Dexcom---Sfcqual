trigger ScheduledShipmentsMasterTrigger on Scheduled_Shipments__c (before insert, before update) {
	if(trigger.isBefore){
		if(trigger.isInsert){
			ScheduledShipmentsTriggerHandler.onBeforeInsert(trigger.new);
		}
		if(trigger.isUpdate){
			ScheduledShipmentsTriggerHandler.onBeforeUpdate(trigger.newMap);
		}
	}
}