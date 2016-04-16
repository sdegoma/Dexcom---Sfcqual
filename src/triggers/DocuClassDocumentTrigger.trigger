trigger DocuClassDocumentTrigger on DocuClass_Documents__c (after insert, after update, before update) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            DocuClassDocumentTriggerHandler.afterInsert(trigger.new); 
        }
    }
    if(trigger.isBefore){
    	if(trigger.isUpdate){
    		DocuClassDocumentTriggerHandler.beforeUpdate(trigger.newMap, trigger.oldMap);
    	}
	}
}