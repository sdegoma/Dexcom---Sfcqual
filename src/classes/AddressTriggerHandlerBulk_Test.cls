@isTest
public with sharing class AddressTriggerHandlerBulk_Test {
	@testSetup static void createRecords(){
		list <Account> accList = new list <Account>();
		for (Integer i = 0; i < 100 ; i++){
			Account acc = new Account(Name = 'acc test '+i );
			System.debug('**acc***'+acc);
			accList.add(acc);
			
			
		}
		insert accList;
	}
	
	private static testMethod void addressCheck(){
		list <Account> accList = [SELECT id from Account];
		list <Address__c> addList = new list <Address__c>();
		integer ctr =0;
		for (Account a : accList){
			for(integer ii = 0; ii < 2 ; ii++){
				Address__c addrs = new Address__c();
				
				if(math.mod(ii,2)==0){
					addrs.Account__c = a.id;
	            	addrs.City__c = 'Billing City ' + ctr;
	            	addrs.County__c = 'Billing County ' + ctr;
	            	addrs.State__c = 'Billing State ' + ctr;
	            	addrs.Zip_Postal_Code__c = 'Billing Postal ' + ctr;
	            	addrs.Street_Address_1__c = 'Billing Address ' +ctr;
	            	addrs.Primary_Flag__c = true;
	                addrs.Address_Type__c = 'BILL_TO';       	
				}else{
					addrs.Account__c = a.id;
	            	addrs.City__c = 'Shipping City ' + ctr;
	            	addrs.County__c = 'Shipping County ' + ctr;
	            	addrs.State__c = 'Shipping State ' + ctr;
	            	addrs.Zip_Postal_Code__c = 'Shipping Postal ' + ctr;
	            	addrs.Street_Address_1__c = 'Shipping Address ' +ctr;
	            	addrs.Primary_Flag__c = true;
					addrs.Address_Type__c = 'SHIP_TO';
				}
				
				addList.add(addrs);
			}
			ctr++;
		}
		
		for (Account a : accList){
			for(integer ii = 0; ii < 2 ; ii++){
				Address__c addrs = new Address__c();
				
				if(math.mod(ii,2)==0){
					addrs.Account__c = a.id;
	            	addrs.City__c = 'Billing City ' + ctr;
	            	addrs.County__c = 'Billing County ' + ctr;
	            	addrs.State__c = 'Billing State ' + ctr;
	            	addrs.Zip_Postal_Code__c = 'Billing Postal ' + ctr;
	            	addrs.Street_Address_1__c = 'Billing Address ' +ctr;
	            	addrs.Primary_Flag__c = true;
	                addrs.Address_Type__c = 'BILL_TO';       	
				}else{
					addrs.Account__c = a.id;
	            	addrs.City__c = 'Shipping City ' + ctr;
	            	addrs.County__c = 'Shipping County ' + ctr;
	            	addrs.State__c = 'Shipping State ' + ctr;
	            	addrs.Zip_Postal_Code__c = 'Shipping Postal ' + ctr;
	            	addrs.Street_Address_1__c = 'Shipping Address ' +ctr;
	            	addrs.Primary_Flag__c = true;
					addrs.Address_Type__c = 'SHIP_TO';
				}
				
				addList.add(addrs);
			}
			ctr++;
		}
		
		test.startTest();
		insert addList;
		test.stopTest();
		
		map <Id, Account> accMap = new map <Id, Account>([SELECT id, Name, BillingCity, BillingState, BillingPostalCode, BillingStreet , ShippingCity, ShippingState, ShippingPostalCode, ShippingStreet from Account]);
		for (Account account : accMap.values()){
			system.debug('**** accMap **** ' + account);
		}
		
		//for(Address__c add : [SELECT id, Account__c, City__c, State__c, Primary_Flag__c]){
			
		//}
		
		
		/*system.assertEquals(addrsList[0].City__c,  accList[0].BillingCity);
        //system.assertEquals(addrsList[0].County__c,  accList[0].BillingCountry);
        system.assertEquals(addrsList[0].State__c,  accList[0].BillingState);
        system.assertEquals(addrsList[0].Zip_Postal_Code__c,  accList[0].BillingPostalCode);
        system.assertEquals(addrsList[0].Street_Address_1__c,  accList[0].BillingStreet);
        system.assertEquals(addrsList[0].Primary_Flag__c,  true);
        system.assertEquals(addrsList[0].Address_Type__c,  'BILL_TO');*/
	}
}