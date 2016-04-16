@isTest
private class RealTimeCustomerTest {
    @testSetup static void setUp() {
        Id recIdConsumer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId();
        List<Account> accConsumer = TestDataBuilder.getAccountListConsumer(6, recIdConsumer);
            insert accConsumer;
        RealTimeCustomerURL__c testCustomSett = new RealTimeCustomerURL__c();
            testCustomSett.Real_Time_URL__c = 'http://api.salesforce.com/1/1';
            insert testCustomSett;
        User u = TestDataBuilder.getUser('System Administrator', 'dexcomTestUser1');
            u.Oracle_User_Name__c = 'FAKER';
            insert u;
        User uNoOracle = TestDataBuilder.getUser('System Administrator', 'dexcomTestUser2');
            insert uNoOracle;
    }
    
    @isTest static void callIntegrationTest(){
        User thisUser = [ SELECT Id, Oracle_User_Name__c FROM User WHERE Username LIKE '%dexcomTestUser1%' ];
        Test.setMock(HttpCalloutMock.class, new realTimeCalloutTest());
        System.runAs(thisUser){
            test.StartTest();
            Account acc = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name0' LIMIT 1];
            RealTimeCustomer.callIntegration(acc.Id);
            test.StopTest();
            Account accnt = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name0' LIMIT 1];
            system.assertEquals(accnt.AccountNumber , '1');
            system.assertEquals(accnt.Party_ID__c , '1');
        }
    }
    
    @isTest static void callIntegrationTest3(){
        User thisUser = [ SELECT Id, Oracle_User_Name__c FROM User WHERE Username LIKE '%dexcomTestUser1%' ];
        Test.setMock(HttpCalloutMock.class, new realTimeCalloutTest());
        System.runAs(thisUser){
            test.StartTest();
            Account acc = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name2' LIMIT 1];
            RealTimeCustomer.callIntegration(acc.Id);
            test.StopTest();
            Account accnt = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name2' LIMIT 1];
            system.assert(accnt.AccountNumber == null);
            system.assert(accnt.Party_ID__c == null);
        }
    }
    
    @isTest static void callIntegrationTest4(){
        User thisUser = [ SELECT Id, Oracle_User_Name__c FROM User WHERE Username LIKE '%dexcomTestUser1%' ];
        Test.setMock(HttpCalloutMock.class, new realTimeCalloutTest());
        System.runAs(thisUser){
            test.StartTest();
            Account acc = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name3' LIMIT 1];
            RealTimeCustomer.callIntegration(acc.Id);
            test.StopTest();
            Account accnt = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name3' LIMIT 1];
            system.assertEquals(accnt.AccountNumber , null);
            system.assertEquals(accnt.Party_ID__c , null);
        }
    }
    
    @isTest static void callIntegrationTest5(){
        User thisUser = [ SELECT Id, Oracle_User_Name__c FROM User WHERE Username LIKE '%dexcomTestUser1%' ];
        Test.setMock(HttpCalloutMock.class, new realTimeCalloutTest());
        System.runAs(thisUser){
            test.StartTest();
            Account acc = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name4' LIMIT 1];
            RealTimeCustomer.callIntegration(acc.Id);
            test.StopTest();
            Account accnt = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name4' LIMIT 1];
            system.assert(accnt.AccountNumber == null);
            system.assert(accnt.Party_ID__c == null);
        }
    }
    
    @isTest static void callIntegrationTestNoOracle(){
        User thisUser = [ SELECT Id, Oracle_User_Name__c FROM User WHERE Username LIKE '%dexcomTestUser2%' ];
        Test.setMock(HttpCalloutMock.class, new realTimeCalloutTest());
        System.runAs(thisUser){
            test.StartTest();
            Account acc = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name5' LIMIT 1];
            RealTimeCustomer.callIntegration(acc.Id);
            test.StopTest();
            Account accnt = [SELECT Id, 
                                  LastName, 
                                  FirstName, 
                                  AccountNumber, 
                                  Party_ID__c 
                                  FROM Account 
                                  WHERE LastName =: 'Test Account Name5' LIMIT 1];
            system.assert(accnt.AccountNumber == null);
            system.assert(accnt.Party_ID__c == null);
        }
    }
    
    @isTest static void callIntegrationTestException(){
        User thisUser = [ SELECT Id, Oracle_User_Name__c FROM User WHERE Username LIKE '%dexcomTestUser2%' ];
        System.runAs(thisUser){
            test.StartTest();
            Account acc = new Account();
            RealTimeCustomer.callIntegration(acc.Id);
            test.StopTest();
        }
    }
}