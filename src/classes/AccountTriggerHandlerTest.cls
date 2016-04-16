/**********************************************************
 **Description: Account trigger handler Test Class.
 **Author:      Louis Augusto Del Rosario, CLOUD SHERPAS
 **Date Created:    JULY.14.2015
**********************************************************/
@isTest
private class AccountTriggerHandlerTest {
    /**********************************************************
     **Description: Test Method if the person email gets copied
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JULY.14.2015
    **********************************************************/
    static testMethod void testCopyEmail(){
        Account testAccount = TestDataBuilder.testAccount();
        insert testAccount;

        List<Account> accountList = [SELECT Id, PersonEmail,PersonEmail__c FROM Account LIMIT 1];

        System.assertEquals(accountList[0].PersonEmail,accountList[0].PersonEmail__C);
    }
    /**********************************************************
     **Description: Test Method the copied person email is also updated
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JULY.14.2015
    **********************************************************/
    static testMethod void testCopyEmailUpdate(){
        Account testAccount = TestDataBuilder.testAccount();
        insert testAccount;
        testAccount.PersonEmail = 'TestUpdate@gmail.com';
        Update testAccount;

        List<Account> accountList = [SELECT Id, PersonEmail,PersonEmail__c FROM Account LIMIT 1];

        System.assertEquals(accountList[0].PersonEmail,accountList[0].PersonEmail__C);
    }
    
    static testMethod void testIntegrationLastModifiedUpdate(){
        Account testAccount = TestDataBuilder.testAccount();
        insert testAccount;
        testAccount.PersonEmail = 'TestUpdate@gmail.com';
        Update testAccount;

        List<Account> accountList = [SELECT Id, PersonEmail,PersonEmail__c, Integration_Last_Modified_Date__c FROM Account LIMIT 1];
        accountList[0].PersonEmail = 'TestUpdate@testEmail.com';
        update accountList;
        
      //  System.assertEquals(accountList[0].Integration_Last_Modified_Date__c, datetime.now());
    }
    
}