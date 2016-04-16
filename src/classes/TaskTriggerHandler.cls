public class TaskTriggerHandler {
/********************************************************************************
@author Abhishek Parghi
@date 01/29/2016
@description:It retrives Prescribers fields from associated 
Prescriber when creating a new "Log a Call" for Call Records. It's 
part of IMS Project.
*******************************************************************************/
  Public Static void  TaskFieldUpdates(List<Task> ListTask) {    
    List<Task> TaskList = new List<Task>();
    Map<Id, Task> MapTasks = new Map<Id, Task>();
    Set<Id> PrescriberIds = new Set<Id>();
    List<Task> UpdatedTasks = new List<Task>();
    Map<Id, List<Task>> whatIdsMap = new Map<Id, List<Task>>();     
 
        for(Task t : ListTask){
        if(t.WhatId != null){
           
            if(!whatIdsMap.containsKey(t.WhatId)){
                List<Task> temp = new List<Task>();
                temp.add(t);
                whatIdsMap.put(t.WhatId, temp);
            }else{
                whatIdsMap.get(t.WhatId).add(t);
            }
        }
    }
      
      for(Account a : [Select ID,firstname,LastName,Middle_Name__c,
                      IMS_ID__pc,PersonMailingStreet,CCV_ID__c,
                      PersonMailingCity,PersonMailingPostalCode,PersonMailingState,New_Address_ID__c,
                      Suffix__pc,Territory_Code__c,Account_Record_Type__c,Party_ID__c
                      from Account where Account_Record_Type__c = 'Prescriber' AND ID  in :whatIdsMap.keySet()]){

        for(Task t :whatIdsMap.get(a.Id)){
             t.First_Name__c = a.firstname;
    	     t.LastName__c = a.LastName;
        	 t.Middle_Name__c = a.Middle_Name__c;
         	 t.IMS_ID__c =a.IMS_ID__pc;
             t.Address_Line_1__c = a.PersonMailingStreet;
             t.CCV_ID__c = a.CCV_ID__c; 
             t.City__c = a.PersonMailingCity;
             t.Zip_Code__c = a.PersonMailingPostalCode;
             t.State__c = a.PersonMailingState;
             t.Suffix__c =a.Suffix__pc;
             t.Prescriber_Territory_Code__c = a.Territory_Code__c;
             t.Prescribers_SFDC_ID__c = a.id;
             t.Prescriber_s_RecordType__c = a.Account_Record_Type__c;
             t.Party_ID__c =a.Party_ID__c;
             t.Territory__c = a.Territory_Code__c;
             t.New_Address_ID__c = a.New_Address_ID__c; 
        }
      }
      
   }
}