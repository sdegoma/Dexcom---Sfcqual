/**************************************************************************
 * @author          : Kingsley Tumaneng
 * @date            : SEPT 3, 2015
 * @description     : Class that will populate fields form Oppotunity
**************************************************************************/
public class DocuClassDocumentTriggerHandler {
    
    /********************************************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 3 2015
     * param        : List of DocuClass Documents to be inserted
     * return       : void
     * description  : Update Required Documents, Required Document Count,
     *                Collected Documents, Collected Documents Count,
     *                Missing Documents, Missing Documents Count fiels
     *                on Opportunity based on Payor
     * revision(s)  :
    ********************************************************************/
    public static void afterInsert(List<DocuClass_Documents__c> docuClassDoc){
        Set<Id> setOppId = new Set<Id>();
        Set<Id> accId = new Set<Id>();
        Set<Id> payorId = new Set<Id>();
    	Set<Id> acctId = new Set<Id>();

        OpportunityTriggerHandler.toInsert = new List<Opportunity>();
        for(DocuClass_Documents__c docuClass : docuClassDoc){
            accId.add(docuCLass.Account__c);
        }

        for(Opportunity o:[SELECT Id, Payor__c, AccountId FROM Opportunity where AccountID IN: accId]){

            setOppId.clear();
            payorId.clear();
            acctId.clear();

            setOppId.add(o.Id);
            payorId.add(o.Payor__c);
            acctId.add(o.AccountId);

            OpportunityTriggerHandler.processMaps(payorId, acctId);

            OpportunityTriggerHandler.processOpportunity(o.Payor__c, o.Id, o, o.AccountId);
        }
        
        /*for(Account acc : [SELECT Id, (SELECT Id, Payor__c, AccountId FROM Opportunities) FROM Account WHERE Id IN : accId]){
            for(Opportunity opp : acc.Opportunities){
                setOppId.add(opp.Id);
                payorId.add(opp.Payor__c);
                acctId.add(opp.AccountId);
            }
        }*/
        
        //START
        //OpportunityTriggerHandler.processMaps(payorId, acctId);
        
        //OpportunityTriggerHandler.toInsert = new List<Opportunity>();
        
        //for(Opportunity opp : [SELECT Id, Name, Payor__c, AccountId FROM Opportunity WHERE Id IN : setOppId]){
        //    OpportunityTriggerHandler.processOpportunity(opp.Payor__c, opp.Id, opp, opp.AccountId);
        //}
        //END
        
        try{
            if(!OpportunityTriggerHandler.toInsert.isEmpty()){
                update OpportunityTriggerHandler.toInsert;
            }
        }catch(Exception ex){
            system.debug('***ERROR INSERT/UPDATE*** ' + ex.getMessage());
        }
        
        // if(!setOppId.isEmpty()){
        //     Database.executeBatch(new ProcessMultipleOpportunity(setOppId), 20);
        // }
    }
    /**
     *@description	: this will handle all the filter logic for the before update event
     *@author		: Noy De Goma@CSHERPAS
     *@date			: 01.28.2016
     *@param		: docuClassNewList - list of DocuClass_Documents__c thar are being updated
     *@return		: N/A
    **/
    public static void beforeUpdate(map <Id, DocuClass_Documents__c> docuClassNewMap, map <Id, DocuClass_Documents__c> docuClassOldMap){
 		list <DocuClass_Documents__c> docuClassToValidateList = new list <DocuClass_Documents__c>();
 		set <Id> accIds = new set <Id>();
 		Set<Id> setOppId = new Set<Id>();
 		Set<Id> payorId = new Set<Id>();
    	Set<Id> acctId = new Set<Id>();
 		for (DocuClass_Documents__c dd : docuClassNewMap.values()){
 			if(docuClassNewMap.get(dd.Id).Approved__c != docuClassOldMap.get(dd.Id).Approved__c
 					&& dd.Approved__c){
 				docuClassToValidateList.add(dd);
 				accIds.add(dd.Account__c);
 			}else{
 			    accIds.add(dd.Account__c);
 			}
 		}
 		if(!docuClassToValidateList.isEmpty()){
 			preventMultipleApprovedDocuType(docuClassToValidateList, accIds);
 		}

        for(Opportunity o:[SELECT Id, Payor__c, AccountId FROM Opportunity where AccountID IN: accIds]){

            setOppId.clear();
            payorId.clear();
            acctId.clear();

            setOppId.add(o.Id);
            payorId.add(o.Payor__c);
            acctId.add(o.AccountId);

            OpportunityTriggerHandler.processMaps(payorId, acctId);

            OpportunityTriggerHandler.processOpportunity(o.Payor__c, o.Id, o, o.AccountId);
        }
 		
 		/*for(Account acc : [SELECT Id, (SELECT Id, Payor__c, AccountId FROM Opportunities) FROM Account WHERE Id IN : accIds]){
            for(Opportunity opp : acc.Opportunities){
                setOppId.add(opp.Id);
                payorId.add(opp.Payor__c);
                acctId.add(opp.AccountId);
            }
        }
        
        //START
        OpportunityTriggerHandler.processMaps(payorId, acctId);
        
        OpportunityTriggerHandler.toInsert = new List<Opportunity>();
        
        for(Opportunity opp : [SELECT Id, Name, Payor__c, AccountId FROM Opportunity WHERE Id IN : setOppId]){
            OpportunityTriggerHandler.processOpportunity(opp.Payor__c, opp.Id, opp, opp.AccountId);
        }
        */
        //END
            
        try{
            if(!OpportunityTriggerHandler.toInsert.isEmpty()){
                update OpportunityTriggerHandler.toInsert;
            }
        }catch(Exception ex){
            system.debug('***ERROR INSERT/UPDATE*** ' + ex.getMessage());
        }
        
        // if(!setOppId.isEmpty()){
        //     Database.executeBatch(new ProcessMultipleOpportunity(setOppId), 20);
        // }
    }
    
    public static void preventMultipleApprovedDocuType(list <DocuClass_Documents__c> docuClassNewlist, set <id> accIds){
    	set <String> docuClassSet =  new set <String>();
    	list <DocuClass_Documents__c> docuListToApprove =  new list <DocuClass_Documents__c>();
    	/*for (DocuClass_Documents__c dd : docuClassNewList){
    		docuClassMap.put(dd.Account__c+'-'+dd.Document_Type__c, dd);
    	}*/
    	for (Account acc : [SELECT Id, (SELECT Id, Document_Type__c, Approved__c, Account__c FROM DocuClass_Documents__r WHERE Approved__c = true) FROM Account WHERE Id IN: accIds]){
    		
    		
    		for (DocuClass_Documents__c dd: acc.DocuClass_Documents__r){

    				docuClassSet.add(dd.Account__c+'-'+dd.Document_Type__c);

    		}

    	}
    	for (DocuClass_Documents__c dd : docuClassNewlist){
    		if(!docuClassSet.contains(dd.Account__c+'-'+dd.Document_Type__c)){
    			docuListToApprove.add(dd);
    			docuClassSet.add(dd.Account__c+'-'+dd.Document_Type__c);
    		}else{
    			dd.addError('There can only be one approved docuclass documents with the same document type per account.');
    		}
    	}
    	
    }
}