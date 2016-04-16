trigger FormTextTrigger on FormText__c (before insert) {
	if(Trigger.isBefore) {
		if(Trigger.isInsert) {
			FormTextTriggerHandler.onBeforeInsert(Trigger.new);
		}
	}
}