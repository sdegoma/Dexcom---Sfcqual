/**********************************************
*    Project : PCS
*    Author: Brian Uyeda
*
*    Description:
*    This trigger is to make the Account's Call_List__c 
*    to FALSE upon Interaction_Status__c is 
*           'Completed - no follow up' or
*           'Patient will call when additional support is needed.'
*
*    Change Log:
*    ============================================
*    03/31/2015 BHU Original production version
*    06/16/2015 CMN See comments 01. Ticket 51772. Added clinic condition to check
*************************************************/

trigger PCS_DX_Notes_Remove_CallList on DX_Notes__c (before insert,after update) 
{
    // Variables
    Set<ID> AccountIDs = new Set<ID>();
    List<Account> acctsToUpdate = new List<Account>();
            
    //1. Get the accounts of DX_Notes__c
    //   if the Insteraction_Status__c is set to one of two values
    for(DX_Notes__c Note : Trigger.new) //To get all the AccounIDs only for the Notes that have Call_List SET to TRUE
    {    
           // 01
           if(Note.Interaction_Status__c == 'Completed - no follow up' || Note.Interaction_Status__c == 'Patient will call when additional support is needed.'|| Note.Interaction_Status__c == 'Clinic will call when additional support is needed.')  
           // 01 End
           {  
               AccountIDs.add(Note.CONSUMER__c);  
           }
    }
     
    //2. Get all Accounts associated with these identified DX_Notes__c 
    //   Verify that there are records to update and gather accounts that are on the call list 
    if(AccountIDs.size()>0)
    {
           acctsToUpdate = [SELECT ID,Call_List__c FROM Account WHERE Call_List__c = true and ID in : AccountIDs limit 49999];
      
    //3. Update the account call list flag to false
           if(acctsToUpdate.size()>0)
           {
                for(Account acc : acctsToUpdate)
                {
                     acc.Call_List__c = false;
                }
    
                update acctsToUpdate;
  
           }
     }
}