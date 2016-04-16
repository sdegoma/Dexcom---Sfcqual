@isTest
public with sharing class TaxServiceCall_Test {
	@testSetUp static void createRecords(){
		
		TaxComputationUrl__c co = new TaxComputationUrl__c(
			URL__c = 'https://dexsfd.dexcom.com/api/orders/calculatetax/'
		);
		insert co;
		
		Id recIdConsumer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId();
        Account accConsumer = TestDataBuilder.getAccountListConsumer(1, recIdConsumer)[0];
        accConsumer.Secondary_Plan_Name__c = 'Test';
        accConsumer.ShippingCity = 'Test';
        accConsumer.ShippingState = 'Test';
        accConsumer.County__c = 'Test';
        accConsumer.ShippingPostalCode = '1';
        insert accConsumer;
		
		Id recIdPayor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
        Account accPayor = TestDataBuilder.getAccountList(1, recIdPayor)[0];
        accPayor.Secondary_Plan_Name__c = 'Payor test';
        insert accPayor;
        
        Opportunity opp = TestDataBuilder.getOpportunityList(1, accConsumer.Id, accPayor.Id)[0];
        opp.Name = 'TaxCalc1';
        insert opp;
        
        Id priceBook2Id = test.getStandardPricebookId();
        Pricebook2 pb2 = new Pricebook2(
        	Id = priceBook2Id,
        	Oracle_Id__c = '1234'
        );
        update pb2;
        
        Product2 prod = new Product2();
            prod.Name = 'Test Product';
            prod.IsActive = true;
            prod.Generation__c = 'OP';
        insert prod;
        
        PricebookEntry pbe = new PricebookEntry();
            pbe.UseStandardPrice = false;
            pbe.Pricebook2Id=pb2.Id;
            pbe.Product2Id=prod.id;
            pbe.IsActive=true;
            pbe.UnitPrice=100;
        insert pbe;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.PricebookEntryId = pbe.Id;
            oppLineItem.Quantity = 1;
            oppLineItem.UnitPrice = 100;
            oppLineItem.OpportunityId = opp.Id;
            oppLineItem.Description = 'test decription';
        insert oppLineItem;
        
        
        
        //Product2 prod1 = new Product2();
        
        
	}
	private static testMethod void taxCalculateSuccess(){
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		
		Opportunity opp = [SELECT Id, Pricebook2.Oracle_Id__c, Amount, Account.ShippingCity, Account.County__c, Account.ShippingPostalCode, Account.ShippingState FROM Opportunity WHERE Name = 'TaxCalc1'];
		TaxComputationUrl__c taxurl = TaxComputationUrl__c.getInstance();
		test.startTest();
			System.debug('****URL**** ' + taxurl.URL__c + opp.Pricebook2.Oracle_Id__c +'/' + opp.Amount + '/' + opp.Account.ShippingCity + '/' + opp.Account.ShippingState + '/' +  opp.Account.County__c +'/' + opp.Account.ShippingPostalCode);
			map <String, String> cResult = TaxServiceCall.getCalloutResponseContents(taxurl.URL__c + opp.Pricebook2.Oracle_Id__c +'/' + opp.Amount + '/' + opp.Account.ShippingCity + '/' + opp.Account.ShippingState + '/' +  opp.Account.County__c +'/' + opp.Account.ShippingPostalCode);
		test.stopTest();
		System.debug('\n\n************Result 1 ' + cResult);
	} 
	
	private static testMethod void taxCalculateFailed(){
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		
		Opportunity opp = [SELECT Id, Pricebook2.Oracle_Id__c, Amount, Account.ShippingCity, Account.County__c, Account.ShippingPostalCode, Account.ShippingState FROM Opportunity WHERE Name = 'TaxCalc1'];
		opp.Account.ShippingPostalCode = '2';
		
		update opp.Account;
		
		TaxComputationUrl__c taxurl = TaxComputationUrl__c.getInstance();
		test.startTest();
			System.debug('****URL**** ' + taxurl.URL__c + opp.Pricebook2.Oracle_Id__c +'/' + opp.Amount + '/' + opp.Account.ShippingCity + '/' + opp.Account.ShippingState + '/' +  opp.Account.County__c +'/' + opp.Account.ShippingPostalCode);
			map <String, String> cResult = TaxServiceCall.getCalloutResponseContents(taxurl.URL__c + opp.Pricebook2.Oracle_Id__c +'/' + opp.Amount + '/' + opp.Account.ShippingCity + '/' + opp.Account.ShippingState + '/' +  opp.Account.County__c +'/' + opp.Account.ShippingPostalCode);
		test.stopTest();
		System.debug('\n\n************Result 2 ' + cResult);
	} 
	
	private static testMethod void taxCalculateResponseCode0(){
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		
		Opportunity opp = [SELECT Id, Pricebook2.Oracle_Id__c, Amount, Account.ShippingCity, Account.County__c, Account.ShippingPostalCode, Account.ShippingState FROM Opportunity WHERE Name = 'TaxCalc1'];
		opp.Account.ShippingPostalCode = '3';
		
		update opp.Account;
		
		TaxComputationUrl__c taxurl = TaxComputationUrl__c.getInstance();
		test.startTest();
			System.debug('****URL**** ' + taxurl.URL__c + opp.Pricebook2.Oracle_Id__c +'/' + opp.Amount + '/' + opp.Account.ShippingCity + '/' + opp.Account.ShippingState + '/' +  opp.Account.County__c +'/' + opp.Account.ShippingPostalCode);
			map <String, String> cResult = TaxServiceCall.getCalloutResponseContents(taxurl.URL__c + opp.Pricebook2.Oracle_Id__c +'/' + opp.Amount + '/' + opp.Account.ShippingCity + '/' + opp.Account.ShippingState + '/' +  opp.Account.County__c +'/' + opp.Account.ShippingPostalCode);
		test.stopTest();
		System.debug('\n\n************Result 3 ' + cResult);
	} 
	
	private static testMethod void taxCalculate404(){
		test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		
		Opportunity opp = [SELECT Id, Pricebook2.Oracle_Id__c, Amount, Account.ShippingCity, Account.County__c, Account.ShippingPostalCode, Account.ShippingState FROM Opportunity WHERE Name = 'TaxCalc1'];
		opp.Account.ShippingPostalCode = '4';
		
		update opp.Account;
		
		TaxComputationUrl__c taxurl = TaxComputationUrl__c.getInstance();
		test.startTest();
			System.debug('****URL**** ' + taxurl.URL__c + opp.Pricebook2.Oracle_Id__c +'/' + opp.Amount + '/' + opp.Account.ShippingCity + '/' + opp.Account.ShippingState + '/' +  opp.Account.County__c +'/' + opp.Account.ShippingPostalCode);
			map <String, String> cResult = TaxServiceCall.getCalloutResponseContents(taxurl.URL__c + opp.Pricebook2.Oracle_Id__c +'/' + opp.Amount + '/' + opp.Account.ShippingCity + '/' + opp.Account.ShippingState + '/' +  opp.Account.County__c +'/' + opp.Account.ShippingPostalCode);
		test.stopTest();
		System.debug('\n\n************Result 4 ' + cResult);
	} 
	private static testMethod void taxCalculateCatch(){		
		test.startTest();
			
			map <String, String> cResult = TaxServiceCall.getCalloutResponseContents('');
		test.stopTest();
		System.debug('\n\n************Result 5 ' + cResult);
	} 
}