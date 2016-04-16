/*****************************************************
 * @author          : Kingsley Tumaneng
 * @date            : SEPT 14 2015
 * @description     : Batch apex to process multiple
 *                    Opportunity
*****************************************************/
global class ProcessMultipleOpportunity implements Database.Batchable<sObject> {
    private Set<Id> setId = new Set<Id>();
    
    global ProcessMultipleOpportunity(Set<id> oppId){
        setId = oppId;
        system.debug('***oppId = ' + oppId);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('***setId = ' + setId);
        return DataBase.getQueryLocator([SELECT Id, Payor__c, AccountId FROM Opportunity WHERE Id IN : setId]);
	}
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scopeOpp) {
        System.debug('***Inside Batch before');
        Set<Id> payorId = new Set<Id>();
        Set<Id> acctId = new Set<Id>();
        
        for(Opportunity opp: scopeOpp){
		    payorId.add(opp.Payor__c);
            acctId.add(opp.AccountId);
		}
		
		OpportunityTriggerHandler.processMaps(payorId, acctId);
		
		for(Opportunity opp: scopeOpp){
		   OpportunityTriggerHandler.processOpportunity(opp.payor__c, opp.Id, opp, opp.AccountId);
		}
		System.debug('***Inside Batch');
    }
    
    global void finish(Database.BatchableContext BC){}

}