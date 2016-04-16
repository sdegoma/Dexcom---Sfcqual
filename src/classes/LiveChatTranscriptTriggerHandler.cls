/**
 * AUTHOR       : Sherlyn Garcia(Cloud Sherpas)
 * DESCRIPTION  : Trigger handler for LiveChatTranscript object.
 * HISTORY      : 16.MAR.2016 SGarcia- Created.
 */
public class LiveChatTranscriptTriggerHandler {
    public static void onBeforeInsert(List<LiveChatTranscript> newLiveChatTranscriptList) {
        // Variable declarations
        Map<String, LiveChatTranscript> liveChatTranscriptMap = new Map<String, LiveChatTranscript>();
        List<Survey__c> surverysToDelete = new List<Survey__c>();
        
        // Looping of live chat transcript and store in the map
        for(LiveChatTranscript liveChatTranscript : newLiveChatTranscriptList) {
            liveChatTranscriptMap.put(liveChatTranscript.ChatKey, liveChatTranscript);
        }
        
        //find the matching survey record with the live chat transcript
        for(Survey__c survey : [SELECT Id, Rating__c, Chat_key__c 
                                FROM Survey__c
                                WHERE Chat_Key__c IN :liveChatTranscriptMap.keySet()]) {
                //Set the the rating of the live chat transcript
                liveChatTranscriptMap.get(survey.Chat_key__c).Rating__c = survey.Rating__c;
                //store the matching survey records in a list (for deletion)
                surverysToDelete.add(survey);
        }
        
        //Loop through the live chat transcript to store the rating on before insert
        for(LiveChatTranscript liveChatTranscript : newLiveChatTranscriptList) {
            if(liveChatTranscript.ChatKey== liveChatTranscriptMap.get(liveChatTranscript.ChatKey).ChatKey) { 
                liveChatTranscript.Rating__c = liveChatTranscriptMap.get(liveChatTranscript.ChatKey).Rating__c;    
            }
        }
        
        //Delete survey records
        if(surverysToDelete.size() > 0) {
            try {
                delete surverysToDelete;
            } catch(DmlException dmle) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Something went wrong. ' + dmle);
                ApexPages.addMessage(msg);
            }
        }
    }
    
    public static void onAfterUpdate(List<LiveChatTranscript> newLiveChatTranscriptList) {
        // Variable declarations
        List<String> chatKeys = new List<String>();
        List<Survey__c> surverysToDelete = new List<Survey__c>();

        // Looping of live chat transcript and store in the map
        for(LiveChatTranscript liveChatTranscript : newLiveChatTranscriptList) {
            chatKeys.add(liveChatTranscript.ChatKey);
        }
        
        //find the matching survey record with the live chat transcript
        for(Survey__c survey : [SELECT Id, Rating__c, Chat_key__c 
                                FROM Survey__c
                                WHERE Chat_Key__c IN :chatKeys]) {
                //store the matching survey records in a list (for deletion)
                surverysToDelete.add(survey);
        }
        
        //Delete survey records
        if(surverysToDelete.size() > 0) {
            try {
                delete surverysToDelete;
            } catch(DmlException dmle) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Something went wrong. ' + dmle);
                ApexPages.addMessage(msg);
            }
        }
    }    
}