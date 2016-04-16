/**
 * AUTHOR       : SHERLYN GARCIA(CLOUD SHERPAS)
 * DESCRIPTION  : TEST CLASS FOR SURVEY CONTROLLER
 * HISTORY      : 17.MAR.2016 SGARCIA - Created.
 */
@isTest
public class CS_SurveyCX_Test {
    /**
    * AUTHOR        : SHERLYN GARCIA(CLOUD SHERPAS)
    * DESCRIPTION   : TEST DATA SETUP METHOD
    * RETURN        : NONE
    * PARAM         : NONE
    * HISTORY       : 17.MAR.2016 SGARCIA - Created.
    */
    @testSetup static void setup() {
        //Create Survey Record
        Survey__c surveyObj = new Survey__c();
        surveyObj.Rating__c = '2 - Met Expectations';
        surveyObj.Chat_Key__c = 'dfasdsa-as-a-d-sdsa';
        insert surveyObj;
        
       
        
        //Create Live Chat Visitor
        LiveChatVisitor liveChatVisitorObj = new LiveChatVisitor();
        insert liveChatVisitorObj;
        
        //Create Live Chat Transcript
        List<LiveChatTranscript> liveChatTranscriptList = new List<LiveChatTranscript>();
        LiveChatTranscript liveChatTranscriptObj = new LiveChatTranscript();
        liveChatTranscriptObj.ChatKey = 'dfasdsa-as-a-d-sdsa';
        liveChatTranscriptObj.Browser = 'Chrome 49.0.2623.87';
        liveChatTranscriptObj.BrowserLanguage = 'en-US';
        liveChatTranscriptObj.EndTime = Datetime.now();
        liveChatTranscriptObj.Location = 'Los Altos, CA, United States';
        liveChatTranscriptObj.RequestTime = Datetime.now()-5;
        liveChatTranscriptObj.StartTime = Datetime.now()-5;
        liveChatTranscriptObj.IpAddress = '99.45.169.135';
        liveChatTranscriptObj.EndedBy = 'Visitor';
        liveChatTranscriptObj.Body = 'Test Body';
        liveChatTranscriptObj.LivechatVisitorid = liveChatVisitorObj.id;
        liveChatTranscriptList.add(liveChatTranscriptObj);
        
        liveChatTranscriptObj = new LiveChatTranscript();
        liveChatTranscriptObj.ChatKey = 'vfasdsa-as-a-d-xxxx';
        liveChatTranscriptObj.Browser = 'Chrome 49.0.2623.87';
        liveChatTranscriptObj.BrowserLanguage = 'en-US';
        liveChatTranscriptObj.EndTime = Datetime.now();
        liveChatTranscriptObj.Location = 'Los Altos, CA, United States';
        liveChatTranscriptObj.RequestTime = Datetime.now()-5;
        liveChatTranscriptObj.StartTime = Datetime.now()-5;
        liveChatTranscriptObj.IpAddress = '99.45.169.135';
        liveChatTranscriptObj.EndedBy = 'Visitor';
        liveChatTranscriptObj.Body = 'Test Body';
        liveChatTranscriptObj.LivechatVisitorid = liveChatVisitorObj.id;
        liveChatTranscriptObj.Rating__c = null;
        liveChatTranscriptList.add(liveChatTranscriptObj);
        insert liveChatTranscriptList;
    }

    /**
    * AUTHOR        : SHERLYN GARCIA(CLOUD SHERPAS)
    * DESCRIPTION   : UNIT TEST METHOD
    * RETURN        : NONE
    * PARAM         : NONE
    * HISTORY       : 04.MAR.2015 SGARCIA - Created.
    */
    @isTest static void myUnitTest() {
        Survey__c surveyObj = new Survey__c();
        surveyObj.Rating__c = '2 - Met Expectations';
        surveyObj.Chat_Key__c = 'dfasdsa-as-a-d-sdsd';
       system.currentPageReference().getParameters().put('chatKey', '');
       
        //Another Survey record
        Survey__c surveyObj1 = new Survey__c();
        surveyObj1.Rating__c = '2 - Met Expectations';
        surveyObj1.Chat_Key__c = 'dfasdsa-as-a-d-sdsd';
        insert surveyObj1;
        
        //to throw an exception and cover the exception case
        surveyObj.Id = surveyObj1.id;
        
        Test.startTest();
            Test.setCurrentPage(Page.OLAPostChatForm);
            
            ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(surveyObj);
            CS_SurveyCX surveyCX = new CS_SurveyCX(stdController);
            surveyCx.setValues();
       
        Test.stopTest();
    }
    
     /**
    * AUTHOR        : SHERLYN GARCIA(CLOUD SHERPAS)
    * DESCRIPTION   : UNIT TEST METHOD
    * RETURN        : NONE
    * PARAM         : NONE
    * HISTORY       : 04.MAR.2015 SGARCIA - Created.
    */
    @isTest static void myUnitTest1() {
        
        Survey__c surveyObj1 = new Survey__c();
        surveyObj1.Rating__c = '2 - Met Expectations';
        surveyObj1.Chat_Key__c = 'dfasdsa-as-a-d-sdsd';
        insert surveyObj1;
        
        Survey__c surveyObj = new Survey__c();
        surveyObj.Rating__c = '2 - Met Expectations';
        surveyObj.Chat_Key__c = 'dfasdsa-as-a-d-sdsd';
        system.currentPageReference().getParameters().put('chatKey', 'dfasdsa-as-a-d-sdsd');
        surveyObj.Id = surveyObj1.Id;
        
        
        Test.startTest();
            Test.setCurrentPage(Page.CSRPostChatForm);
            system.currentPageReference().getParameters().put('chatKey', 'dfasdsa-as-a-d-sdsd');
            ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(surveyObj);
            CS_SurveyCX surveyCX = new CS_SurveyCX(stdController);
            surveyCx.setValues();
            
        Test.stopTest();
    }
    
    /**
    * AUTHOR        : SHERLYN GARCIA(CLOUD SHERPAS)
    * DESCRIPTION   : UNIT TEST METHOD
    * RETURN        : NONE
    * PARAM         : NONE
    * HISTORY       : 04.MAR.2015 SGARCIA - Created.
    */
    @isTest static void myUnitTest2() {
        Survey__c surveyObj = new Survey__c();
        surveyObj.Rating__c = '1 - Met Expectations';
        surveyObj.Chat_Key__c = 'vfasdsa-as-a-d-1234';
        
         //Create Live Chat Visitor
        LiveChatVisitor liveChatVisitorObj = new LiveChatVisitor();
        insert liveChatVisitorObj;
        
        LiveChatTranscript liveChatTranscriptObj = new LiveChatTranscript();
        liveChatTranscriptObj.ChatKey = 'vfasdsa-as-a-d-1234';
        liveChatTranscriptObj.Browser = 'Chrome 49.0.2623.87';
        liveChatTranscriptObj.BrowserLanguage = 'en-US';
        liveChatTranscriptObj.EndTime = Datetime.now();
        liveChatTranscriptObj.Location = 'Los Altos, CA, United States';
        liveChatTranscriptObj.RequestTime = Datetime.now()-5;
        liveChatTranscriptObj.StartTime = Datetime.now()-5;
        liveChatTranscriptObj.IpAddress = '99.45.169.135';
        liveChatTranscriptObj.EndedBy = 'Visitor';
        liveChatTranscriptObj.Body = 'Test Body';
        liveChatTranscriptObj.LivechatVisitorid = liveChatVisitorObj.id;
        liveChatTranscriptObj.Rating__c = null;
        insert liveChatTranscriptObj;
        
        
       // insert surveyObj;
               
        Test.startTest();
            
             insert surveyObj;
                 
         
        Test.stopTest();
    }
    
    /**
    * AUTHOR        : SHERLYN GARCIA(CLOUD SHERPAS)
    * DESCRIPTION   : UNIT TEST METHOD
    * RETURN        : NONE
    * PARAM         : NONE
    * HISTORY       : 04.MAR.2015 SGARCIA - Created.
    */
    @isTest static void myUnitTest3() {
        // Setup test data
        
        //Create Survey record
        Survey__c surveyObj = new Survey__c();
        surveyObj.Rating__c = '1 - Met Expectations';
        surveyObj.Chat_Key__c = 'vfasdsa-as-a-d-1234';
        insert surveyObj;
            
        //Create Live Chat Visitor
        LiveChatVisitor liveChatVisitorObj = new LiveChatVisitor();
        insert liveChatVisitorObj;
        
        //Create Live Chat Transcript record
        LiveChatTranscript liveChatTranscriptObj = new LiveChatTranscript();
        liveChatTranscriptObj.ChatKey = 'vfasdsa-as-a-d-1234';
        liveChatTranscriptObj.Browser = 'Chrome 49.0.2623.87';
        liveChatTranscriptObj.BrowserLanguage = 'en-US';
        liveChatTranscriptObj.EndTime = Datetime.now();
        liveChatTranscriptObj.Location = 'Los Altos, CA, United States';
        liveChatTranscriptObj.RequestTime = Datetime.now()-5;
        liveChatTranscriptObj.StartTime = Datetime.now()-5;
        liveChatTranscriptObj.IpAddress = '99.45.169.135';
        liveChatTranscriptObj.EndedBy = 'Visitor';
        liveChatTranscriptObj.Body = 'Test Body';
        liveChatTranscriptObj.LivechatVisitorid = liveChatVisitorObj.id;
        liveChatTranscriptObj.Rating__c = null;
        insert liveChatTranscriptObj;
        
        //Create Another Live Chat Transcript record
        LiveChatTranscript liveChatTranscriptObj1 = new LiveChatTranscript();
        liveChatTranscriptObj1.ChatKey = 'vfasdsa-as-a-d-1234';
        liveChatTranscriptObj1.Browser = 'Chrome 49.0.2623.87';
        liveChatTranscriptObj1.BrowserLanguage = 'en-US';
        liveChatTranscriptObj1.EndTime = Datetime.now();
        liveChatTranscriptObj1.Location = 'Los Altos, CA, United States';
        liveChatTranscriptObj1.RequestTime = Datetime.now()-5;
        liveChatTranscriptObj1.StartTime = Datetime.now()-5;
        liveChatTranscriptObj1.IpAddress = '99.45.169.135';
        liveChatTranscriptObj1.EndedBy = 'Visitor';
        liveChatTranscriptObj1.Body = 'Test Body';
        liveChatTranscriptObj1.LivechatVisitorid = liveChatVisitorObj.id;
        liveChatTranscriptObj1.Rating__c = null;
        
        
            
            Test.startTest();
               
                    
                    insert liveChatTranscriptObj1;
                    //set id of transcript to the Id transcript record to be inserted
                    liveChatTranscriptObj1.id = liveChatTranscriptObj.id;
                    update liveChatTranscriptObj1; 
                
               
            Test.stopTest();
      
    }
}