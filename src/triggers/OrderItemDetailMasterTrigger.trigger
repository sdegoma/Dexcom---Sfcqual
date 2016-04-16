trigger OrderItemDetailMasterTrigger on Order_Item_Detail__c (after insert, after update) {
	if(trigger.isAfter){
		if(trigger.isInsert){
			OrderItemDetailTriggerHandler.onAfterInsert(trigger.new);
		}	
		if(trigger.isUpdate){
			OrderItemDetailTriggerHandler.onAfterUpdate(trigger.new);
		}
	}
}