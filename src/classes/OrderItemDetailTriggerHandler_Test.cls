@isTest
private class OrderItemDetailTriggerHandler_Test {
	@testSetUp static void createRecords(){
		list <Order_Header__c> orderHeaderList;
		list <Order_Item_Detail__c> oidList = new list <Order_Item_Detail__c>();
		Account acc = new Account(Name = 'Test Acc');
		insert acc;
		Order_Header__c oh1 = new Order_Header__c(Account__c = acc.Id);
		Order_Header__c oh2 = new Order_Header__c(Account__c = acc.Id);
		Order_Header__c oh3 = new Order_Header__c(Account__c = acc.Id);
		
		orderHeaderList = new list <Order_Header__c>{oh1, oh2, oh3};
		insert orderHeaderList;
		
		oidList.add(new Order_Item_Detail__c(Order_Header__c = orderHeaderList[0].Id, Item_Number__c = 'STS'));
		    
		Insert oidList;
	}
	private static testMethod void recalculateOrderHeaderInsert(){
		list<Order_Header__c> ohList = [SELECT Id, Product_Type__c FROM Order_Header__c ORDER BY Name ASC];
		System.assertEquals('Sensor',ohList[0].Product_Type__c);
		System.assertEquals(null,ohList[1].Product_Type__c);
		System.assertEquals(null,ohList[2].Product_Type__c);
		
		Order_Item_Detail__c oid1  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[0].Id);
		Order_Item_Detail__c oid2  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[0].Id);
		Order_Item_Detail__c oid3  = new Order_Item_Detail__c(Item_Number__c = 'STT', Order_Header__c = ohList[0].Id);
		
		Order_Item_Detail__c oid4  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[1].Id);
		Order_Item_Detail__c oid5  = new Order_Item_Detail__c(Item_Number__c = 'STK', Order_Header__c = ohList[1].Id);
		Order_Item_Detail__c oid6  = new Order_Item_Detail__c(Item_Number__c = 'STT', Order_Header__c = ohList[1].Id);
		
		Order_Item_Detail__c oid7  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[2].Id);
		Order_Item_Detail__c oid8  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[2].Id);
		Order_Item_Detail__c oid9  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[2].Id);
		
		test.startTest();
			insert new list <Order_Item_Detail__c>{oid1, oid2, oid3, oid4, oid5, oid6, oid7, oid8, oid9};
		test.stopTest();
		
		
		ohList = [SELECT Id, Product_Type__c FROM Order_Header__c ORDER BY Name ASC];
		System.assertEquals('Transmitter',ohList[0].Product_Type__c);
		System.assertEquals('System',ohList[1].Product_Type__c);
		System.assertEquals('Sensor',ohList[2].Product_Type__c);

	}
	
	private static testMethod void recalculateOrderHeaderUpdate(){
		list<Order_Header__c> ohList = [SELECT Id, Product_Type__c FROM Order_Header__c ORDER BY Name ASC];
		System.assertEquals('Sensor',ohList[0].Product_Type__c);
		System.assertEquals(null,ohList[1].Product_Type__c);
		System.assertEquals(null,ohList[2].Product_Type__c);
		
		Order_Item_Detail__c oid1  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[0].Id);
		Order_Item_Detail__c oid2  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[0].Id);
		Order_Item_Detail__c oid3  = new Order_Item_Detail__c(Item_Number__c = 'STT', Order_Header__c = ohList[0].Id);
		
		Order_Item_Detail__c oid4  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[1].Id);
		Order_Item_Detail__c oid5  = new Order_Item_Detail__c(Item_Number__c = 'STK', Order_Header__c = ohList[1].Id);
		Order_Item_Detail__c oid6  = new Order_Item_Detail__c(Item_Number__c = 'STT', Order_Header__c = ohList[1].Id);
		
		Order_Item_Detail__c oid7  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[2].Id);
		Order_Item_Detail__c oid8  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[2].Id);
		Order_Item_Detail__c oid9  = new Order_Item_Detail__c(Item_Number__c = 'STS', Order_Header__c = ohList[2].Id);
		
		list <Order_Item_Detail__c> oidList = new list <Order_Item_Detail__c>{oid1, oid2, oid3, oid4, oid5, oid6, oid7, oid8, oid9};
		insert oidList;
		oidList[2].Item_Number__c = 'STK';
		oidList[5].Item_Number__c = 'STS';
		oidList[7].Item_Number__c = 'STK';
		test.startTest();
			update oidList;
		test.stopTest();
		
		
		ohList = [SELECT Id, Product_Type__c FROM Order_Header__c ORDER BY Name ASC];
		System.assertEquals('System',ohList[0].Product_Type__c);
		System.assertEquals('System',ohList[1].Product_Type__c);
		System.assertEquals('System',ohList[2].Product_Type__c);

	}
}