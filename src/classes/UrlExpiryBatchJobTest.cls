/**********************************************************
 **Description: Url Expiry Batch Test Class.
 **Author:      Louis Augusto Del Rosario, CLOUD SHERPAS
 **Date Created:    JUN.30.2015
**********************************************************/
@isTest
private class UrlExpiryBatchJobTest {
    /**********************************************************
     **Description: Test Method for if the signed url gets populated.
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.30.2015
    **********************************************************/
    static testMethod void testupdateURL(){
        Lead_Scoring__c testLs = TestDataBuilder.testLeadScoringVal();
        insert testLs;

        URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE;  

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
        testLead.Interest_Level__c  = 'Somewhat Interested';
        Insert testLead;

        Test.startTest();
            UrlExpiryBatchJob urlEB = new UrlExpiryBatchJob();
            Database.executeBatch(urlEB);
        Test.stopTest();

        List<Lead> listLead = [SELECT Id,Status,Signed_URL__c FROM Lead];
        System.debug('### list lead'+ listLead);
        System.assertNotEquals(null,listLead[0].Signed_URL__c);
    }
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void test() {
        Test.startTest();

            // Schedule the test job
            String jobId = System.schedule('UrlExpiry',
            CRON_EXP, 
            new UrlExpiry());
            
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
            NextFireTime
            FROM CronTrigger WHERE id = :jobId];
            
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, 
            ct.CronExpression);
            
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
            
            // Verify the next time the job will run
            System.assertEquals('2022-03-15 00:00:00', 
            String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}