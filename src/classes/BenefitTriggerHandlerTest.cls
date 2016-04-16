@isTest
private class BenefitTriggerHandlerTest {
    public static Account accConsumer = new Account();
    public static Account accPayor = new Account();
    public static Benefits__c bnf = new Benefits__c();
    public static Benefits__c bnf2 = new Benefits__c();
    
	@testSetup static void setup() {
        Id recIdConsumer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId();
        accConsumer = TestDataBuilder.getAccountListConsumer(1, recIdConsumer)[0];
            insert accConsumer;
        
        Id recIdPayor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
        accPayor = TestDataBuilder.getAccountList(1, recIdPayor)[0];
            insert accPayor;
        
        Id recId = Schema.SObjectType.Benefits__c.getRecordTypeInfosByName().get('Benefits').getRecordTypeId();
        bnf = TestDataBuilder.getBenefits(accConsumer.Id, accPayor.Id, 1, 'Primary', recId)[0];
            insert bnf;
        bnf2 = TestDataBuilder.getBenefits(accConsumer.Id, accPayor.Id, 1, 'Secondary', recId)[0];
            insert bnf2;
	}
	
	@isTest static void testInsert(){
	    test.startTest();
	        Account consumer = [SELECT Id, Payor__c FROM Account WHERE RecordType.Name =: 'Consumers' LIMIT 1];
	        Account payor = [SELECT Id, Payor__c FROM Account WHERE RecordType.Name =: 'Payor' LIMIT 1];
	        Benefits__c benef = [SELECT Id, Payor__c, Account__c FROM Benefits__c WHERE Benefit_Hierarchy__c =: 'Primary' LIMIT 1];
	        
	        //system.assertEquals(benef.Payor__c, consumer.Payor__c);
	    test.stopTest();
	}
	
	@isTest static void testAfterUpdate(){
	    test.startTest();
	        Account consumer = [SELECT Id, Payor__c FROM Account WHERE RecordType.Name =: 'Consumers' LIMIT 1];
	        Account payor = [SELECT Id, Payor__c FROM Account WHERE RecordType.Name =: 'Payor' LIMIT 1];
	        List<Benefits__c> benefList = [SELECT Id, Payor__c, Account__c FROM Benefits__c WHERE Benefit_Hierarchy__c =: 'Primary' LIMIT 1];
	        List<Benefits__c> toBeUpdated = new List<Benefits__c>();
	        
	        Id recIdPayor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account accPayorNew = TestDataBuilder.getAccountList(1, recIdPayor)[0];
                insert accPayorNew;
            
            for(Benefits__c benefi : benefList){
                benefi.Payor__c = accPayorNew.Id;
                toBeUpdated.add(benefi);
            }
            
            update toBeUpdated;
            
            List<Account> payorNew = [SELECT Id, Payor__c FROM Account WHERE Id =: accPayorNew.Id];
            List<Benefits__c> benef = [SELECT Id, Payor__c, Account__c FROM Benefits__c WHERE Id =: toBeUpdated[0].Id];
	        system.assertEquals(benef[0].Payor__c, payorNew[0].Id);
	    test.stopTest();
	}
	
	@isTest static void testUpdate(){
	    test.startTest();
	        try{
	        Account consumer = [SELECT Id, Payor__c FROM Account WHERE RecordType.Name =: 'Consumers' LIMIT 1];
	        Account payor = [SELECT Id, Payor__c FROM Account WHERE RecordType.Name =: 'Payor' LIMIT 1];
	        List<Benefits__c> benefList = [SELECT Id, Payor__c, Account__c FROM Benefits__c WHERE Benefit_Hierarchy__c =: 'Primary' LIMIT 1];
	        List<Benefits__c> toBeUpdated = new List<Benefits__c>();
	        
	        Id recIdPayor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account accPayorNew = TestDataBuilder.getAccountList(1, recIdPayor)[0];
                insert accPayorNew;
            
            for(Benefits__c benefi : benefList){
                benefi.Payor__c = accPayorNew.Id;
                benefi.Benefit_Hierarchy__c = 'Secondary';
                benefi.Create_New_Benefit_Record__c = true;
                bnf.RID_IC__c = '1';
                bnf.RID_P1__c = '2';
                bnf.RID_P2__c = '3';
                bnf.RID_PA__c = '4';
                toBeUpdated.add(benefi);
            }
            
            update toBeUpdated;
            
            List<Account> payorNew = [SELECT Id, Payor__c FROM Account WHERE Id =: accPayorNew.Id];
            List<Benefits__c> benef = [SELECT Id, Payor__c, Account__c FROM Benefits__c WHERE Id =: toBeUpdated[0].Id];
	        system.assertEquals(benef[0].Payor__c, payorNew[0].Id);
	        system.assertEquals(benef[0].Create_New_Benefit_Record__c, false);
	        system.assertEquals(benef[0].RID_IC__c, null);
	        system.assertEquals(benef[0].RID_P1__c, null);
	        system.assertEquals(benef[0].RID_P2__c, null);
	        system.assertEquals(benef[0].RID_PA__c, null);
	        }catch(Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('There is already a benefit record of that Benefit Hierarchy type') ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);
	        }
	    test.stopTest();
	}
	
	@isTest static void testInsertNotPrimary(){
	    test.startTest();
	        Account consumer = [SELECT Id, Payor__c FROM Account WHERE RecordType.Name =: 'Consumers' LIMIT 1];
	        Account payor = [SELECT Id, Payor__c FROM Account WHERE RecordType.Name =: 'Payor' LIMIT 1];
	        Benefits__c benef = [SELECT Id, Payor__c, Account__c FROM Benefits__c WHERE Benefit_Hierarchy__c =: 'Secondary' LIMIT 1];
	        
	        //system.assertEquals(benef.Payor__c, consumer.Payor__c);
	    test.stopTest();
	}
}