public class FormTextTriggerHandler {
	public static void onBeforeInsert(List<FormText__c> newFormTextist) {
		System.debug('IN before insert *********');
		List<FormText__c> retrieveFormText = new List<FormText__c>();
		retrieveFormText = [SELECT Id FROM FormText__c LIMIT 1];
		if(retrieveFormText.size() > 0) {
			for(FormText__c formText : newFormTextist) {
				formText.addError('Cannot create a new record. You should delete the existing record before creating a new one.');
			}
		}
	}
}