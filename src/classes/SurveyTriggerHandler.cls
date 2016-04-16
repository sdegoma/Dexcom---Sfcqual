/**
 * AUTHOR       : Sherlyn Garcia(Cloud Sherpas)
 * DESCRIPTION  : Trigger for LiveChatTranscript object.
 * HISTORY      : 04.APR.2016 SGarcia- Created.
 */
public class SurveyTriggerHandler {
    public static void onAfterInsert(List<Survey__c> newSurveyList) {
        //Variable Declaration
        Map<String, Survey__c> surveyMap = new Map<String, Survey__c>();
        List<LiveChatTranscript> liveChatTransList = new List<LiveChatTranscript>();
        
        //Store the chat key and sruvey records in a Map
        for(Survey__c surveyRec : newSurveyList) {
            surveyMap.put(surveyRec.Chat_Key__c, surveyRec);
        }
        
        //Find the matching ChatKey in the livechattranscript from the survey chatkeys
        for(LiveChatTranscript liveChatTransRec : [SELECT Id, ChatKey, Rating__c
                                                   FROM LiveChatTranscript 
                                                   WHERE ChatKey IN : surveyMap.keySet()]) {
            //Check if the rating is null and the survey chat key is not null or blank
            if(liveChatTransRec.Rating__c == null && 
              (surveyMap.get(liveChatTransRec.ChatKey).Rating__c != null || surveyMap.get(liveChatTransRec.ChatKey).Rating__c != '')) {
                liveChatTransRec.Rating__c = surveyMap.get(liveChatTransRec.ChatKey).Rating__c;
                liveChatTransList.add(liveChatTransRec);
            }
        }
        
        //update the live chat transcript with the rating
        if(liveChatTransList.size() > 0) {
            try {
                update liveChatTransList;
            } catch(DmlException dmle) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Something went wrong. ' + dmle);
                ApexPages.addMessage(msg);
            }
        }
    }
}