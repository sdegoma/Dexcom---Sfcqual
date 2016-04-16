@isTest
private class CancelOrderCall_Test {
	@testSetUp static void createRecords(){
		
		Id recId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' And DeveloperName = 'Consumers'].Id;
		
		Account con = TestDataBuilder.getAccountListConsumer(1, recId)[0];
		insert con;
		
		
		
		list <Order_Header__c> ohList = new list <Order_Header__c>();
		cancelOrderUrl__c co = new cancelOrderUrl__c(
			URL__c = 'https://dexsfd.dexcom.com/api/orders/cancelorder/'
		);
		insert co;
		
		User u = TestDataBuilder.getUser('System Administrator', 'dexcomTestUser1');
		u.Oracle_User_Name__c = 'ORAC';
		
		insert u;
		id rTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Business_Account'].id;
		Account acc = TestDataBuilder.getAccountList(1,rTypeId)[0];
		insert acc;
		
		
		Opportunity opp =  TestDataBuilder.getOpportunityList(1, con.Id, null)[0];
		opp.Order_NUM__c = '12345';
		insert opp;
		
		Order_Header__c oh =  new Order_Header__c(
			Account__c = acc.Id,
			Order_Id__c = '12345'
		);
		

		
		Order_Header__c oh2 =  new Order_Header__c(
			Account__c = acc.Id,
			Order_Id__c = '12346'
		);
		

		
		Order_Header__c oh3 =  new Order_Header__c(
			Account__c = acc.Id,
			Order_Id__c = 'qwerty'
		);
		
		ohList = new list <Order_Header__c>{oh, oh2, oh3};
		
		insert ohList;
		
	}
	private static testMethod void CancelOrderSuccess(){
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		Order_Header__c oh = [SELECT Id, Order_Id__c FROM Order_Header__c WHERE Order_Id__c = '12345' limit 1];
		User u = [SELECT Id, Oracle_User_Name__c FROM User WHERE username like '%dexcomTestUser1%'];
		String message = '';
		test.startTest();
			
			message = CancelOrderCall.cancelOrderRequest(u.Oracle_User_Name__c, oh.Order_Id__c, 'ERROR -TEST');
			
		test.stopTest();
		
		System.assertEquals('Success', message);
	}
	private static testMethod void CancelOrderFailed(){
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		Order_Header__c oh = [SELECT Id, Order_Id__c FROM Order_Header__c WHERE Order_Id__c = '12346' limit 1];
		User u = [SELECT Id, Oracle_User_Name__c FROM User WHERE username like '%dexcomTestUser1%'];
		String message = '';
		test.startTest();
			
			message = CancelOrderCall.cancelOrderRequest(u.Oracle_User_Name__c, oh.Order_Id__c, 'ERROR -TEST%20TEST');
			
		test.stopTest();
		
		System.assertEquals('Error in calling webservice: Failed', message);
	}
	private static testMethod void CancelOrder404(){
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		Order_Header__c oh = [SELECT Id, Order_Id__c FROM Order_Header__c WHERE Order_Id__c = 'qwerty' limit 1];
		User u = [SELECT Id, Oracle_User_Name__c FROM User WHERE username like '%dexcomTestUser1%'];
		String message = '';
		test.startTest();
			
			message = CancelOrderCall.cancelOrderRequest(u.Oracle_User_Name__c, oh.Order_Id__c, 'ERROR -TEST');
			
		test.stopTest();
		
		System.assertEquals('Error in calling webservice: Not Found', message);
	}
	private static testMethod void CancelOrderNegative(){
		//Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		//Order_Header__c oh = [SELECT Id, Order_Id__c FROM Order_Header__c WHERE Order_Id__c = 'qwerty' limit 1];
		//User u = [SELECT Id, Oracle_User_Name__c FROM User WHERE username like '%dexcomTestUser1%'];
		cancelOrderUrl__c cancelUrl = cancelOrderUrl__c.getOrgDefaults();
		delete cancelUrl;
		String message = '';
		test.startTest();
			
			message = CancelOrderCall.cancelOrderRequest('ORAC', '00000', 'ERROR -TEST');
			
		test.stopTest();
		
		System.assertEquals('Error in calling webservice.', message);
	}
}