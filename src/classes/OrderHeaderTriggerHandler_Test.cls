@isTest
public with sharing class OrderHeaderTriggerHandler_Test {
	@testSetup static void createRecords(){
		id recId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumers'].Id;
		id payorRecId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Payor'].Id;
		Account consumer = TestDataBuilder.getAccountListConsumer(1, recId)[0];

		
		Account acc = TestDataBuilder.getAccountList(1,payorRecId)[0];
		
		insert new list <Account>{consumer, acc};
		
		list <Opportunity> oppList = TestDataBuilder.getOpportunityList(5, consumer.Id, acc.Id);
		integer ctr = 0;
		for(Opportunity o : oppList){
			o.Order_NUM__c = '1234'+(ctr++);
		}
		insert oppList;
	}
	private static testMethod void updateOrderOpptySingleTest(){
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Order_NUM__c = '12340'];
		Account acc = [SELECT Id FROM Account limit 1];
		
		Order_Header__c orderHeader = new Order_Header__c(
			Account__c = acc.Id,
			Order_Id__c = '12340'
		);
		
		test.startTest();
			insert orderHeader;
		test.stopTest();
		
		Order_Header__c orderHeaderNew = [SELECT Id, Opportunity__c FROM Order_Header__c WHERE Id = : orderHeader.Id];
		
		System.assertEquals(opp.Id, orderHeaderNew.Opportunity__c);
	}
	
	private static testMethod void updateOrderOpptyBulkTest(){
		map <String, Opportunity> oppMap = new map <String, Opportunity>();
		for(Opportunity opp : [SELECT Id, Order_NUM__c FROM Opportunity  ORDER BY Order_NUM__c ASC]){
			oppMap.put(opp.Order_NUM__c, opp);
		}
		
		Account acc = [SELECT Id FROM Account limit 1];
		
		list <Order_Header__c> orderHeaderList = new list <Order_Header__c>();
		for(integer i = 0; i < 5; i++){
			Order_Header__c orderHeader = new Order_Header__c(
				Account__c = acc.Id,
				Order_Id__c = '1234'+i
			);
			orderHeaderList.add(orderHeader);
		}
		
		
		test.startTest();
			insert orderHeaderList;
		test.stopTest();
				
		for(Order_Header__c oh : [SELECT Id, Opportunity__c, Order_Id__c FROM Order_Header__c]){
			System.assertEquals(oppMap.get(oh.Order_Id__c).id, oh.Opportunity__c);
		}
	}
}