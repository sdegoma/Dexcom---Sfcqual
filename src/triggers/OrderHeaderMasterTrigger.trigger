trigger OrderHeaderMasterTrigger on Order_Header__c (before insert) {
	if(trigger.isBefore){
		if(trigger.isInsert){
			OrderHeaderTriggerHandler.onBeforeInsert(trigger.new);
		}
	}
}