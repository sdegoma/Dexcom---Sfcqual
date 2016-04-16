/**
 * AUTHOR       : Sherlyn Garcia(Cloud Sherpas)
 * DESCRIPTION  : Live Chat Survey controller for inserting new Survey Record
 * HISTORY      : 16.MAR.2016 SGarcia- Created.
 */
global class CS_SurveyCX {
    //global variable declaration
    public Survey__c surveyObj {get; set;}
    public String chatKey {get;set;}
    public String errorMsg {get;set;}
    public Boolean isSuccess {get;set;}
    
    //Standard controller constructor
    public CS_SurveyCX(ApexPages.StandardController stdController) {
        //Set initial values
        this.surveyObj = (Survey__c)stdController.getRecord();   
        chatKey = apexpages.currentpage().getparameters().get('chatKey');
        isSuccess = false;
        surveyObj.Chat_Key__c = chatKey;
        
        //Check if chatkey is blank display an error message otherwise set the chat key value on the survey object
        if(chatKey == '' || chatKey == null) {
            errorMsg = 'Invalid access. This form can be submitted only by completing a chat session with a Dexcom Agent!.';
        } else {
            errorMsg = '';
        }
        
        System.debug('surveyObjxxxx1' + surveyObj);
    }

    public PageReference setValues() {
        //Insert the survey record
        System.debug('surveyObjxxxx2' + surveyObj);
        try {
                insert surveyObj;
                //isSuccess = true;
            } catch(DmlException dmle) {errorMsg = 'Error in submitting the survey.'; isSuccess = false;}     
            
        return null;
    }
}