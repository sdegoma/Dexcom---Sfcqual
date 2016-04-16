/**
 * AUTHOR       : Sherlyn Garcia(Cloud Sherpas)
 * DESCRIPTION  : Trigger for LiveChatTranscript object.
 * HISTORY      : 16.MAR.2016 SGarcia- Created.
 */
trigger LiveChatTranscriptTrigger on LiveChatTranscript (before insert, after update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            System.debug('Executing Live Chat Transcript Trigger');
            //Call before insert handler method
            LiveChatTranscriptTriggerHandler.onBeforeInsert(Trigger.new);
        }
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isUpdate){
            System.debug('Executing Live Chat Transcript Trigger');
            //Call after update handler method
            LiveChatTranscriptTriggerHandler.onAfterUpdate(Trigger.new);
        }
    }
}