/********************************************************************************
@author Abhishek Parghi
@date 01/08/2016
@description: To populate initial call list on accounts.
*******************************************************************************/
trigger OIDTrigger on Order_Item_Detail__c (before insert, before update,after insert, after update) {
 if(trigger.isbefore){
     if(trigger.isInsert){
         PCSCallList.OIDAccountIdUpdate(trigger.new); 
      //   PCSCallList.OrderDetail(trigger.new);  
     }
     if(trigger.isupdate){
     PCSCallList.OIDAccountIdUpdate(trigger.new); 
     } 
 }
 
   if(trigger.isAfter){
       if(trigger.isInsert){
     //    PCSCallList.OrderDetail(trigger.new);  
       }
           if(trigger.isUpdate){
            PCSCallList.OIDInitialCallList(trigger.new); 
          }
    
}
}