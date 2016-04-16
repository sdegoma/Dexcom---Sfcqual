/********************************************************************************
@author Chuck Nothdurft
@date 6/04/2015
@description: To transfer the DX_Note Interaction Status value to the related account
when a new PCS Note is entered but not when a DX notes is entered.
Added these notes, plus debugging codes for operation in Prod.

Revision(s):
01 Chuck Nothdurft 06/04/2015 Added filters for limiting functionality to PCS not DX notes
    and added debug code (4 locations). 
02 Chuck Nothdurft 06/16/2015 added back line to set Account Call List value to false.
**************************************************/
trigger PCS_DX_Notes_InteractionStatus on DX_Notes__c (after insert,after update)

{
    Set<ID> AccountIDs = new Set<ID>();
    List<Account> acctsToUpdate = new List<Account>();
    List<Account> acctsToUpdateintdate = new List<Account>();
    Map<ID,String> acctIDToIntStatusMap = new Map<ID,String>(); //Account ID --> Interaction Status
    Map<ID,Datetime> acctIDToIntDateMap = new Map<ID,Datetime>(); //Account ID --> Interaction Status
    String oldStatus ='';

    //1. Get the accounts of DX_Notes__c

    for(DX_Notes__c Note : Trigger.new) //To get all the AccountIDs only for the Notes that have Call_List SET to TRUE
    {
        DX_Notes__c oldNote;
        if(Trigger.isUpdate)
            {
                oldNote = Trigger.oldMap.get(Note.Id);
                oldStatus = oldNote.Interaction_Status__c;
                //01
                if(oldStatus != Note.Interaction_Status__c)
                //01 END
                    {
                    AccountIDs.add(Note.CONSUMER__c);
                    acctIDToIntStatusMap.put(Note.CONSUMER__c,Note.Interaction_Status__c);
                    acctIDToIntDateMap.put(Note.CONSUMER__c,Note.createdDate);
                    }
            }

        if(Trigger.isInsert)
            {//01
            if(Note.Interaction_Status__c!=Null)
            //01 END
                {
                AccountIDs.add(Note.CONSUMER__c);
                acctIDToIntStatusMap.put(Note.CONSUMER__c,Note.Interaction_Status__c);
                acctIDToIntDateMap.put(Note.CONSUMER__c,Note.createdDate);
                }
            }
    }

    //2. get all Accounts associated with these identified DX_Notes__c

    if(AccountIDs.size()>0)
    {
        acctsToUpdate = [SELECT ID,Call_List__c,Interaction_Status__c    FROM Account WHERE ID in : AccountIDs limit 49999];
        acctsToUpdateintdate = [SELECT ID,Latest_Interaction_Date__c    FROM Account WHERE ID in : AccountIDs limit 49999];
        
    //3. Update fields accordingly

        if(acctsToUpdate.size()>0)
        {

                for(Account acc : acctsToUpdate)
                {
                     acc.Interaction_Status__c = acctIDToIntStatusMap.get(acc.Id);
                     //02
                     acc.Call_List__c = false;
                     //02 END
                 //01
                 system.debug('acc.Interaction_Status__c');
                 system.debug(acc.Interaction_Status__c);
                 //01 END
                 }

                update acctsToUpdate;

                for(Account acc : acctsToUpdateintdate)
                {
                     acc.Latest_Interaction_Date__c = acctIDToIntDateMap.get(acc.Id);
                 //01
                 system.debug('acc.Latest_Interaction_Date__c');
                 system.debug(acc.Latest_Interaction_Date__c);
                 //01 END
                }

                update acctsToUpdateintdate;


        }//acctsToUpdate IF - Ends Here

 }//AccountIDs - IF - Ends Here

}