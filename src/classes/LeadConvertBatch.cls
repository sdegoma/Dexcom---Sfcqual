/*
	@Author				: Loven Reyes (CloudSherpas)
	@Date Created		: 16-JUL-2005
	@Description		: Class for Lead Conversion Batch.
*/

global class LeadConvertBatch implements Database.Batchable<sObject> {

	private static boolean alreadyConverted = false;

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT Id, Status, hasAccount__c, Initial_Data_Load__c, isConverted 
											FROM Lead 
											 	WHERE isConverted = false 
											 		AND Initial_Data_Load__c = false 
											 		AND hasAccount__c = false 
											 		AND Status = 'Qualified']);
	}

	//method to execute the batch lead conversion as long as the lead meets the criteria in the querylocator
   	global void execute(Database.BatchableContext BC, List<Lead> scope) {
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();

        for(Lead l:scope){
            if(l.hasAccount__c == false && l.Initial_Data_Load__c == false && l.isConverted == false){
                System.Debug('#####Lead to be converted status: ' + l.Status);
                if(l.status == 'Qualified'){
                    try{
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(l.Id);
                        lc.setDoNotCreateOpportunity(true);
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        leadConverts.add(lc);
                        
                    }catch(Exception e){
                        System.debug('### Exception leadConversion' +e);
                    }
                }
            }
        }

        if (!leadConverts.isEmpty()) {
        	alreadyConverted = true;
            List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts);
        }
	}
	
	global void finish(Database.BatchableContext BC) {
	}
}