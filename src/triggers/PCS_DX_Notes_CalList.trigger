/**********************************************
*    Project : PCS
*    Author: Venkat Kollimarla
*    This trigger is to make the Account's Call_List__c 
*    to TRUE upon DX_Note Call_List is Set to TRUE
*
*************************************************/


trigger PCS_DX_Notes_CalList on DX_Notes__c (before insert,after update) 
{
    
    Set<ID> AccountIDs = new Set<ID>();
    List<Account> acctsToUpdate = new List<Account>();
            
    //1. Get the accounts of DX_Notes__c 
    
    for(DX_Notes__c Note : Trigger.new) //To get all the AccounIDs only for the Notes that have Call_List SET to TRUE
    {    
           if(Note.Call_List_DX_Note__c)    {  AccountIDs.add(Note.CONSUMER__c);  }
    }
     
    //2. get all Accounts associated with these identified DX_Notes__c 
    
    if(AccountIDs.size()>0)
    {
            acctsToUpdate = [SELECT ID,Call_List__c FROM Account WHERE Call_List__c!= true and ID in : AccountIDs limit 49999];
      
    //3. Update fields accordingly
    
        if(acctsToUpdate.size()>0)
        {
        
                for(Account acc : acctsToUpdate)
                {
                     acc.Call_List__c = true;
                }
    
                update acctsToUpdate;
  
       }//acctsToUpdate IF - Ends Here
    
 }//AccounIDs - IF - Ends Here
    
}