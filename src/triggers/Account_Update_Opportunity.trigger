/*revision : Kingsley Tumaneng (10/6/2015) add Payor__c to be updated*/
trigger Account_Update_Opportunity on Account (after update) {
//
//Summary: Update mobile phone in opporunity after account is updated.
//Programmer: BHU
//Change Log
//  04/22/2015 BHU Initial Version
//
//-- Modified by Noy De Goma@CSHERPAS on 11.03.2015
    //--Added Prescribers__c and Medical_Facility__c to be updated
    
    //  Get the IDs of the Accounts
    Set<ID> accIDs = Trigger.newMap.keySet();
    //  Get all Opportunities associated with the Account in this Trigger
    List<Opportunity> OppoList = [
        SELECT Id, Account.Id, Account.PersonContact.MobilePhone, Mobile_Phone__c, Account.Payor__c, Account.Prescribers__c, Account.Medical_Facility__c
        FROM Opportunity
        WHERE IsClosed = false
        AND (StageName != '61. Quote Approved' AND StageName != '10. Cancelled')
        AND Account.Id IN :accIDs ] ;          
    //  Loop through them to copy Number of Partners from parent (Account) to the Opportunity
    for(Opportunity opps: OppoList)
    {
        opps.Mobile_Phone__c = opps.Account.PersonContact.MobilePhone ;
        
        if(opps.Account.Payor__c != trigger.oldMap.get(opps.AccountId).Payor__c){
            opps.Payor__c = opps.Account.Payor__c;
        }
        // Added by Noy De Goma@CSHERPAS on 11.03.2015
        if(opps.Account.Prescribers__c != trigger.oldMap.get(opps.AccountId).Prescribers__c){
            opps.Prescribers__c = opps.Account.Prescribers__c;
        }
        // Added by Noy De Goma@CSHERPAS on 11.03.2015
        if(opps.Account.Medical_Facility__c != trigger.oldMap.get(opps.AccountId).Medical_Facility__c){
            opps.Medical_Facility__c = opps.Account.Medical_Facility__c;
        }
    }
    //  Updates the Opportunity
    try{
        update OppoList;
    }catch(Exception e){
        system.debug('***error = ' + e.getMessage());
    }
}