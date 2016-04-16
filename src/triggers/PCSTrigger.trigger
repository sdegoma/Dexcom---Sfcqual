trigger PCSTrigger on DX_Notes__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
/********************************************************************************
@author Abhishek Parghi
@date 10/08/2015
@description: To populate return call list on accounts.
*******************************************************************************/
    if(trigger.isBefore){
        if(trigger.isInsert){
               PCSCallList.DxReturnCallList(trigger.new); 
          //   PCSCallList.AccFlagUpdate(trigger.new);
        }
        if(trigger.isUpdate){
         //   PCSCallList.PcsFlagUpdate(trigger.new); 
              PCSCallList.DxReturnCallList(trigger.new);        
        }
    }
    if(trigger.isafter){
         if(trigger.isInsert){
             PCSCallList.AccountReturnCallList(trigger.new);
         }if(trigger.isUpdate){
             PCSCallList.AccountReturnCallList(trigger.new);
         }
        
    }
}