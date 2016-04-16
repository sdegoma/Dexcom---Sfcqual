/**********************************************************
 **Description: Lead trigger handler Test Class.
 **Author:      Louis Augusto Del Rosario, CLOUD SHERPAS
 **Date Created:    JUN.10.2015
**********************************************************/
@isTest
private class LeadTriggerHandlerTest {
    /**********************************************************
     **Description: Test Method if there is an existing account
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.10.2015
    **********************************************************/
    static testMethod void testExisitingAccount(){
        URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE;  
        
        Account testAccount = TestDataBuilder.testAccount();
        insert testAccount;

        Lead testLead = TestDataBuilder.testLead();
        Insert testLead;
        testLead.Email = 'Test2@gmail.com';
        Update testLead;

        List<Lead> listLead = [SELECT Id,Status,hasAccount__c FROM Lead];
        System.debug('### list lead'+ listLead);
        System.assertEquals(true,listLead[0].hasAccount__c);
    }
    /**********************************************************
     **Description: Test Method if the lead has all of the proper values.
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.10.2015
    **********************************************************/
    static testMethod void testLeadScoringAllValues(){
        Lead_Scoring__c testLs = TestDataBuilder.testLeadScoringVal();
        insert testLs;
        
        URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE;  

        Lead testLead = TestDataBuilder.testLead();
        testLead.Interest_Level__c  = 'Very Interested. I would like to begin the ordering process as soon as possible';
        testLead.Status = 'Open';
        Insert testLead;

        List<Lead> listLead = [SELECT Id,Status,hasAccount__c FROM Lead];
        List<LeadStatus> convertStatusList = [SELECT Id, MasterLabel,IsConverted FROM LeadStatus WHERE IsConverted=true];
        System.debug('### list lead'+ listLead);
        System.assertEquals(true,convertStatusList[0].IsConverted);
        
        
        
    }
    /**********************************************************
     **Description: Test Method if the lead dont have the proper values
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.10.2015
    **********************************************************/
    static testMethod void testLeadScoringNoValues(){
        Lead_Scoring__c testLs = TestDataBuilder.testLeadScoringVal();
        insert testLs;
        
        URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE;  

        Lead testLead = new Lead();
        testLead.Patient_Diabetes_Type__c = 'None';
        testLead.LastName = 'Test LastName';
        testLead.Status = 'Open';
        testLead.Phone = '123456789';
        testLead.Interest_Level__c = 'Not Interested';
        Insert testLead;

        List<Lead> listLead = [SELECT Id,Status,hasAccount__c FROM Lead];
        System.debug('### list lead'+ listLead);
        System.assertEquals('Not Qualified',listLead[0].Status);
    }
    /**********************************************************
     **Description: Test Method if the lead has an incomplete values
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.10.2015
    **********************************************************/
    static testMethod void testLeadScoringIncompleteValues(){
        URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE;  
        
        Lead_Scoring__c testLs = TestDataBuilder.testLeadScoringVal();
        insert testLs;
        
        Lead testLead = new Lead();
        testLead.LastName = 'Test LastName';
        testLead.Phone = '123456789';
        testLead.State = 'Test State';
        testLead.City = 'Test City';
        testLead.Street = 'Test Street';
        testLead.Doctor_City__c = 'Test Doc City';
        testLead.Doctor_Name__c = 'Test Doc Name';
        testLead.Insurance_Provider__c = 'Test Insurance Provider';
        testLead.Insurance_Type__c = 'Private Insurance';
        testLead.Status = 'Open';
        
        testLead.Interest_Level__c  = 'Somewhat interested. I'+'\''+'d like to do more research before starting the ordering process';
        Insert testLead;

        List<Lead> listLead = [SELECT Id,Status,hasAccount__c FROM Lead];
        System.debug('### list lead'+ listLead);
        System.assertNotEquals('Qualified',listLead[0].Status);
    }
    /**********************************************************
     **Description: Test Method if the campaign has values
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.10.2015
    **********************************************************/
    static testMethod void testCreateCampaign(){
        URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE; 
        
        Lead_Scoring__c testLs = TestDataBuilder.testLeadScoringVal();
        insert testLs;
        
        User testUser = TestDataBuilder.testUser();
        insert testUser;
        
        Campaign testCampaign = TestDataBuilder.testCampaign(testUser.Id);
        insert testCampaign;
        
        Lead testLead = TestDataBuilder.testLead();
        testLead.Interest_Level__c  = 'Very Interested. I would like to begin the ordering process as soon as possible';
        testLead.Status = 'Open';
        testLead.Dex_Campaign__c = testCampaign.Id;
        Insert testLead;

        List<Lead> listLead = [SELECT Id,Status,hasAccount__c FROM Lead];
        List<LeadStatus> convertStatusList = [SELECT Id, MasterLabel,IsConverted FROM LeadStatus WHERE IsConverted=true];
        System.debug('### list lead'+ listLead);
        System.assertEquals(true,convertStatusList[0].IsConverted);
    }
    
    /**********************************************************
     **Description: Test Method if the campaign is null
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.10.2015
    **********************************************************/
    static testMethod void testCreateDefaultCampaign(){
        URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE; 
        
        Lead_Scoring__c testLs = TestDataBuilder.testLeadScoringVal();
        insert testLs;
        
        User testUser = TestDataBuilder.testUser();
        insert testUser;
        
        Campaign testCampaign = TestDataBuilder.testCampaign(testUser.Id);
        insert testCampaign;
        
        Default_Campaign__c testDC = TestDataBuilder.testDefaultCampaign(testCampaign.Id);
        insert testDC;
        
        Lead testLead = TestDataBuilder.testLead();
        testLead.Interest_Level__c  = 'Very Interested. I would like to begin the ordering process as soon as possible';
        testLead.Status = 'Open';
        testLead.Dex_Campaign__c = null;
        Insert testLead;

        List<Lead> listLead = [SELECT Id,Status,hasAccount__c FROM Lead];
        List<LeadStatus> convertStatusList = [SELECT Id, MasterLabel,IsConverted FROM LeadStatus WHERE IsConverted=true];
        System.debug('### list lead'+ listLead);
        System.assertEquals(true,convertStatusList[0].IsConverted);
    }
    /****************************************************
     **Description: Test Method for LeadPageController
     **Parameters:  None
     **Returns:     None
     **Author:      Abhishek Parghi
     **Date Created:    August.19.2015
    **********************************************************/
    static testMethod void TestLeadPageController(){
        URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE;  
        User testUser = TestDataBuilder.testUser();
        insert testUser;
        Campaign testCampaign = TestDataBuilder.testCampaign(testUser.Id);
        insert testCampaign;
        Lead testLead = TestDataBuilder.testLead();
        testLead.Interest_Level__c  = 'Very Interested. I would like to begin the ordering process as soon as possible';
        testLead.Status = 'Open';
       
        testLead.Dex_Campaign__c = testCampaign.Id;
        Insert testLead;   
        
        ApexPages.StandardController sc = new ApexPages.standardController(testLead);
        LeadPageController e = new LeadPageController(sc);
        Lead LL2 = [Select email,id from Lead where email = 'Test@gmail.com']; 
        
        PageReference pageRef = e.save();
        Test.setCurrentPage(pageRef);
        
    }   
    
}