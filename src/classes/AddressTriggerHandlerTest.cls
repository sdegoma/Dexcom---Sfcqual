/*********************************************************
 * @author      : Kingsley Tumaneng
 * @date        : SEPT 28 2015
 * @description : Test class for AddressTriggerHandler
**********************************************************/
@isTest
private class AddressTriggerHandlerTest {
	@isTest static void testInsertBilling() {
        test.startTest();
            Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            Address__c addrs = TestDataBuilder.getAddressList(acc.Id, true,'Other', 1)[0];
                insert addrs;
                
            List<Account> accList2 = [SELECT Id, BillingStreet, BillingState, BillingCity, BillingCountry, BillingPostalCode
                                     FROM Account WHERE Id =: acc.Id];
            Address__c addrs2 = TestDataBuilder.getAddressList(accList2[0].Id, true,'BILL_TO', 1)[0];
                insert addrs2;
            
            List<Account> accList = [SELECT Id, BillingStreet, BillingState, BillingCity, BillingCountry, BillingPostalCode
                                     FROM Account WHERE Id =: acc.Id];
            List<Address__c> addrsList = [SELECT Id, Account__c, City__c, County__c, State__c, Zip_Postal_Code__c, Street_Address_1__c, Primary_Flag__c, Address_Type__c
                                          FROM Address__c WHERE Id =: addrs2.Id];
            
            system.assertEquals(addrsList[0].City__c,  accList[0].BillingCity);
            //system.assertEquals(addrsList[0].County__c,  accList[0].BillingCountry);
            system.assertEquals(addrsList[0].State__c,  accList[0].BillingState);
            system.assertEquals(addrsList[0].Zip_Postal_Code__c,  accList[0].BillingPostalCode);
            system.assertEquals(addrsList[0].Street_Address_1__c,  accList[0].BillingStreet);
            system.assertEquals(addrsList[0].Primary_Flag__c,  true);
            system.assertEquals(addrsList[0].Address_Type__c,  'BILL_TO');
        test.stopTest();
	}
	
	@isTest static void testInsertShipping() {
        test.startTest();
            Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            Address__c addrs = TestDataBuilder.getAddressList(acc.Id, true,'Other', 1)[0];
                insert addrs;
                
            List<Account> accList2 = [SELECT Id, ShippingStreet, ShippingState, ShippingCity, ShippingCountry, ShippingPostalCode, County__c
                                     FROM Account WHERE Id =: acc.Id];
            Address__c addrs2 = TestDataBuilder.getAddressList(accList2[0].Id, true,'SHIP_TO', 1)[0];
                insert addrs2;
            
            List<Account> accList = [SELECT Id, ShippingStreet, ShippingState, ShippingCity, ShippingCountry, ShippingPostalCode, County__c
                                     FROM Account WHERE Id =: acc.Id];
            List<Address__c> addrsList = [SELECT Id, Account__c, City__c, County__c, State__c, Zip_Postal_Code__c, Street_Address_1__c, Primary_Flag__c, Address_Type__c
                                          FROM Address__c WHERE Id =: addrs2.Id];
            
            system.assertEquals(addrsList[0].City__c,  accList[0].ShippingCity);
            system.assertEquals(addrsList[0].County__c,  accList[0].County__c);
            system.assertEquals(addrsList[0].State__c,  accList[0].ShippingState);
            system.assertEquals(addrsList[0].Zip_Postal_Code__c,  accList[0].ShippingPostalCode);
            system.assertEquals(addrsList[0].Street_Address_1__c,  accList[0].ShippingStreet);
            system.assertEquals(addrsList[0].Primary_Flag__c,  true);
            system.assertEquals(addrsList[0].Address_Type__c,  'SHIP_TO');
        test.stopTest();
	}
	
	@isTest static void testUpdateBilling() {
        test.startTest();
            Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            Address__c addrs = TestDataBuilder.getAddressList(acc.Id, false, 'SHIP_TO', 1)[0];
                insert addrs;
            AddressTriggerHandler.run = true;
            
            addrs.Address_Type__c = 'BILL_TO';
            addrs.Primary_Flag__c = true;
                update addrs;
                
            List<Account> accList = [SELECT Id, BillingStreet, BillingState, BillingCity, BillingCountry, BillingPostalCode
                                     FROM Account WHERE Id =: acc.Id];
            List<Address__c> addrsList = [SELECT Id, Account__c, City__c, County__c, State__c, Zip_Postal_Code__c, Street_Address_1__c, Primary_Flag__c, Address_Type__c
                                          FROM Address__c WHERE Id =: addrs.Id];
            
            system.assertEquals(addrsList[0].City__c,  accList[0].BillingCity);
            //system.assertEquals(addrsList[0].County__c,  accList[0].BillingCountry);
            system.assertEquals(addrsList[0].State__c,  accList[0].BillingState);
            system.assertEquals(addrsList[0].Zip_Postal_Code__c,  accList[0].BillingPostalCode);
            system.assertEquals(addrsList[0].Street_Address_1__c,  accList[0].BillingStreet);
            system.assertEquals(addrsList[0].Primary_Flag__c,  true);
            system.assertEquals(addrsList[0].Address_Type__c,  'BILL_TO');
        test.stopTest();
	}
	
	@isTest static void catchEx(){
	    Address__c addrs = new Address__c();
	    insert addrs;
	}
	
	@isTest static void deleteRec(){
	    test.startTest();
	    try{
	        Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            Address__c addrs = TestDataBuilder.getAddressList(acc.Id, true, 'SHIP_TO', 1)[0];
                insert addrs;
            List<Address__c> addrsList = [SELECT Id, Account__c FROM Address__c WHERE Id =: addrs.Id];
            delete addrsList;
	    }catch(Exception e){
	        Boolean expectedExceptionThrown =  e.getMessage().contains('You cannot delete a Primary Address.');
	        System.AssertEquals(expectedExceptionThrown, true);
	    }
        test.stopTest();
	}
}