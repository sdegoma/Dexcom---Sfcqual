@isTest
private class ProcessExistingAddressTest {
    
    @testSetup static void setup(){
        Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
        Account acc = TestDataBuilder.getAccountList(1, recId)[0];
            insert acc;
        Address__c addrs = TestDataBuilder.getAddressList(acc.Id, true,'SHIP_TO', 1)[0];
            insert addrs;
        Address__c addrs2 = TestDataBuilder.getAddressList(acc.Id, true,'BILL_TO', 1)[0];
                insert addrs2;
    }
    
	@isTest static void test() {
	    test.startTest();
    	    List<Address__c> addrs = [SELECT Id, 
                                      PARTY_NAME__c, 
                                      Primary_Flag__c, 
                                      Address_Type__c, 
                                      Account__c,
                                      Street_Address_1__c,
                                      State__c,
                                      City__c,
                                      County__c,
                                      Zip_Postal_Code__c
                                      FROM Address__c WHERE Address_Type__c = 'SHIP_TO'];
            List<Address__c> addrs2 = [SELECT Id, 
                                      PARTY_NAME__c, 
                                      Primary_Flag__c, 
                                      Address_Type__c, 
                                      Account__c,
                                      Street_Address_1__c,
                                      State__c,
                                      City__c,
                                      County__c,
                                      Zip_Postal_Code__c
                                      FROM Address__c WHERE Address_Type__c = 'BILL_TO'];                          
            
            ProcessExistingAddress batchClass = new ProcessExistingAddress();
            Database.executeBatch(batchClass);
        test.stopTest();
	}
}