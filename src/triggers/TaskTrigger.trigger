trigger TaskTrigger on Task (before insert,before update, after insert, after update) {
/********************************************************************************
@author Abhishek Parghi
@date 01/29/2016
@description:Task Trigger
*******************************************************************************/
if(trigger.isBefore){
        if(trigger.isInsert){
         //  TaskTriggerHandler.populateWhatIdTypeandWhoIdType(trigger.new); 
             TaskTriggerHandler.TaskFieldUpdates(trigger.new);
         //  TaskTriggerHandler.RingDNAOppTask(trigger.new);
                    
        }
        if(trigger.isUpdate){ 
        //   TaskTriggerHandler.populateWhatIdTypeandWhoIdType(trigger.new); 
        //   TaskTriggerHandler.TaskFieldUpdates(trigger.new);
        }
    }
if(trigger.isafter){
         if(trigger.isInsert){
        //   TaskTriggerHandler.AutoShareTasks(trigger.new);      
        //   TaskTriggerHandler.TaskFieldUpdates(trigger.new);              
         }if(trigger.isUpdate){
        //   TaskTriggerHandler.AutoShareTasks(trigger.new);
         }
        
    }








}