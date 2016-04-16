/**
 *@description	: Test Class for ScheduledShipmentsTriggerHandler
 *@author 		: Noy De Goma@CSHERPAS
 *@date 		: 01.06.2015
**/
@isTest
private class ScheduledShipmentsTriggerHandler_Test {
	public static list <Product2> getProductList(integer recLimit, String ProductCode){
    	list <Product2> prodList =  new list <Product2>();
    	for(Integer i = 0 ; i < recLimit ; i++){
    		Product2 prod = new Product2(
    			Name = ProductCode + i,
    			ProductCode = ProductCode + i,
    			Oracle_Product_Id__c = (i+1) + '44995'
    		);
    		prodList.add(prod);
    	}
    	return prodList;
    }
    
    public static  Asset getAsset(String name, Id prodId, Id accId){
    	Asset ass = new Asset(
    		Name = name,
    		Product2Id = prodId,
    		AccountId = accId
    	);
    	return ass;
    }
	
	@testSetup static void testData() {
		G5_Product_Code__c g5ProdCodeCS = new G5_Product_Code__c(
			Product_Code__c = 'BUN-GF-003'
		);
		insert g5ProdCodeCS;
		
		list <G5_Transmitter_Oracle_Prod_Id__c> G5Transmitter = new list <G5_Transmitter_Oracle_Prod_Id__c>();
		for(Integer i = 0; i < 5 ; i++){
			G5_Transmitter_Oracle_Prod_Id__c g5 = new G5_Transmitter_Oracle_Prod_Id__c(
				Name = 'G5'+i
			);
			G5Transmitter.add(g5);
		}
		G5Transmitter[0].Name = '144995';
		insert G5Transmitter;
		
		Id rTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumers' AND SObjectType = 'Account'].Id;
		list <Account> testAccList = TestDataBuilder.getAccountListConsumer(10, rTypeId);
		for (Account a: testAccList){
			a.Default_Price_Book__c = test.getstandardpricebookid();
		}
		insert testAccList;
		
		list <Product2> testProdList = getProductList(10, 'G5');
		testProdList[0].Name = 'BUN-GF-003';
    	testProdList[0].ProductCode = 'BUN-GF-003';
		insert testProdList;
		
		list <Asset> testAssetList = new list<Asset>();
		for(integer i = 0; i < 10 ; i ++){
			Asset ass = getAsset('Asset'+1, testProdList[i].Id, testAccList[0].Id);
			testAssetList.add(ass);
		}
		insert testAssetList;
	}

    static testMethod void scheduleShipmentsValidation_Scenario1() {
        Account acc = [SELECT Id FROM Account WHERE LastName = 'Test Account Name0' limit 1];
        Product2 p = [SELECT id FROM Product2  WHERE Oracle_Product_Id__c = '144995' limit 1];
        
        Scheduled_Shipments__c ss =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	Product_Item__c = p.Id
        );
        insert ss;
        
        Scheduled_Shipments__c ss2 =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	Product_Item__c = p.Id
        );
        
        String err;
        test.startTest();
        	try{
        		insert ss2;
        	}catch(Exception ex){
        		err = ex.getMessage();
        	}
        test.stopTest();
        
        System.assert(err.contains('There is already an active shipment for this product on the account'));
    }
    
    static testMethod void scheduleShipmentsValidation_Scenario2() {
        Account acc = [SELECT Id FROM Account WHERE LastName != 'Test Account Name0' limit 1];
        Product2 p = [SELECT id FROM Product2  WHERE Oracle_Product_Id__c = '144995' limit 1];
        
        Scheduled_Shipments__c ss =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	Product_Item__c = p.Id
        );

        
        String err;
        test.startTest();
        	try{
        		insert ss;
        	}catch(Exception ex){
        		err = ex.getMessage();
        	}
        test.stopTest();
        System.debug('********************************************** ' + err);
        
        System.assert(err.contains('Scheduled Shipments are only available for customers with a G5 transmitter'));
    }
    
    static testMethod void scheduleShipmentsValidation_Scenario3() {
        Account acc = [SELECT Id FROM Account WHERE LastName != 'Test Account Name0' limit 1];
        Product2 p = [SELECT id FROM Product2  WHERE Oracle_Product_Id__c = '244995' limit 1];
        p.Oracle_Product_Id__c = '48877';
        update p;
        
        
        Scheduled_Shipments__c ss =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	Product_Item__c = p.Id
        );
        insert ss;
        
        Scheduled_Shipments__c ss2 =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	Product_Item__c = p.Id
        );
        
        String err;
        test.startTest();
        	try{
        		insert ss2;
        	}catch(Exception ex){
        		err = ex.getMessage();
        	}
        test.stopTest();
        
        System.assert(err.contains('There is already an active shipment for this product on the account'));
    }
    
    static testMethod void scheduleShipmentsValidation_Scenario4() {
        Account acc = [SELECT Id FROM Account WHERE LastName = 'Test Account Name0' limit 1];
        Product2 p = [SELECT id FROM Product2  WHERE Oracle_Product_Id__c = '144995' limit 1];
        
        Scheduled_Shipments__c ss =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	Product_Item__c = p.Id
        );
        insert ss;
        
        Scheduled_Shipments__c ss2 =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	End_date__c = Date.today(),
        	Product_Item__c = p.Id
        );
        
        insert ss2;
        ss2.End_date__c = null;
        String err;
        test.startTest();
        	try{
        		update ss2;
        	}catch(Exception ex){
        		err = ex.getMessage();
        	}
        test.stopTest();
        
        System.assert(err.contains('There is already an active shipment for this product on the account'));
    }

    static testMethod void scheduleShipmentsValidation_Scenario5() {
        Account acc = [SELECT Id FROM Account WHERE LastName != 'Test Account Name0' limit 1];
        Product2 p = [SELECT id FROM Product2  WHERE Oracle_Product_Id__c = '244995' limit 1];
        p.Oracle_Product_Id__c = '48877';
        update p;
        
        
        Scheduled_Shipments__c ss =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	Product_Item__c = p.Id
        );
        insert ss;
        
        Scheduled_Shipments__c ss2 =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	End_date__c = Date.today(),
        	Product_Item__c = p.Id
        );
        insert ss2;
        ss2.End_date__c = null;
        String err;
        test.startTest();
        	try{
        		update ss2;
        	}catch(Exception ex){
        		err = ex.getMessage();
        	}
        test.stopTest();
        
        System.assert(err.contains('There is already an active shipment for this product on the account'));
    }
    
    static testMethod void scheduleShipmentsValidation_Scenario6() {
        Account acc = [SELECT Id, Default_Price_Book__c FROM Account WHERE LastName = 'Test Account Name0' limit 1];
        acc.Default_Price_Book__c = null;
        update acc;
        Product2 p = [SELECT id FROM Product2  WHERE Oracle_Product_Id__c = '144995' limit 1];
        
        Scheduled_Shipments__c ss =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	Product_Item__c = p.Id
        );
        
        String err;
       	test.startTest();
        	try{
        		insert ss;
        	}catch(Exception ex){
        		err = ex.getMessage();
        	}
        test.stopTest();
        
        System.assert(err.contains('Scheduled shipments require a default pricebook on the Account'));
    }
    
    static testMethod void scheduleShipmentsValidation_Scenario7() {
        Account acc = [SELECT Id FROM Account WHERE LastName = 'Test Account Name0' limit 1];
        Product2 p = [SELECT id FROM Product2  WHERE Oracle_Product_Id__c = '144995' limit 1];
        
        Scheduled_Shipments__c ss =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	Product_Item__c = p.Id
        );
        insert ss;
        

        acc.Default_Price_Book__c = null;
        update acc;
        String err;
        test.startTest();
        	try{
        		update ss;
        	}catch(Exception ex){
        		err = ex.getMessage();
        	}
        test.stopTest();
        
        System.assert(err.contains('Scheduled shipments require a default pricebook on the Account'));
    }
    
    static testMethod void scheduleShipmentsValidation_Scenario8() {
    	list <Scheduled_Shipments__c> ssListToUpdate = new list <Scheduled_Shipments__c>();
        Account acc = [SELECT Id FROM Account WHERE LastName != 'Test Account Name0' limit 1];
        Product2 p = [SELECT id FROM Product2  WHERE Oracle_Product_Id__c = '244995' limit 1];
        p.Oracle_Product_Id__c = '48877';
        update p;
        
        
        Scheduled_Shipments__c ss =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	End_date__c = Date.today(),
        	Product_Item__c = p.Id
        );
        insert ss;
        
        Scheduled_Shipments__c ss2 =  new Scheduled_Shipments__c(
        	Name = 'SS 1',
        	Account__c = acc.Id,
        	End_date__c = Date.today(),
        	Product_Item__c = p.Id
        );
        insert ss2;
        ss2.End_date__c = null;
        ssListToUpdate.add(ss2);
        ss.End_date__c = null;
        ssListToUpdate.add(ss);
        String err;
        test.startTest();
        	try{
        		update ssListToUpdate;
        	}catch(Exception ex){
        		err = ex.getMessage();
        	}
        test.stopTest();
        
        //System.assert(err.contains('There is already an active shipment for this product on the account'));
    }
 
}