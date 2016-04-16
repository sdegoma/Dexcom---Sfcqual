/**
 * AUTHOR       : Sherlyn Garcia(Cloud Sherpas)
 * DESCRIPTION  : Trigger for Survey object.
 * HISTORY      : 04.APR.2016 SGarcia- Created.
 */
trigger SurveyTrigger on Survey__c (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            System.debug('Executing Survey Trigger');
            //Call after insert handler method
            SurveyTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
}