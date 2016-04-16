/**
 *@description 	: Trigger Handler for the ScheduledShipmentsMasterTrigger
 *@author 		: Noy De Goma@CSHERPAS
 *@date 		: 01.05.2016
**/
public with sharing class ScheduledShipmentsTriggerHandler {
	/**
	 *@description	: contains the filter logic for the trigger
	 *@author 		: Noy De Goma@CSHERPAS
	 *@date 		: 01.05.2016
	 *@param 		: newSchedShipmentsList - list Scheduled_Shipments__c
	 *@return 		: N/A
	**/
	public static void onBeforeInsert(list <Scheduled_Shipments__c> newSchedShipmentsList){
		scheduledShipmentsValidationOnInsert(newSchedShipmentsList);
	}
	
	/**
	 *@description 	: contains the filter logic for the trigger
	 *@author 		: Noy De Goma@CSHERPAS
	 *@date 		: 01.07.2016
	 *@param 		: newSchedShipmentsList - list Scheduled_Shipments__c
	 *@return 		: N/A
	**/
	public static void onBeforeUpdate(map <Id, Scheduled_Shipments__c> newSchedShipmentsMap){
		scheduledShipmentsValidationOnUpdate(newSchedShipmentsMap);
	}
	/**
	 *@description 	: contains the logic for validating the creation of Scheduled_Shipments__c
	 *@author 		: Noy De Goma@CSHERPAS
	 *@date 		: 01.05.2016
	 *@param 		: schedShipmentsList - list Scheduled_Shipments__c
	 *@return 		: N/A
	**/
	public static void scheduledShipmentsValidationOnInsert(list<Scheduled_Shipments__c> schedShipmentsList){
		set<id> parentAccountIdSet = new set <Id>();
		set <Id> productIdSet = new set <Id>();
		set <id> accountIdWithNoPriceBook = new set <Id>();
		set <Id> accountWithG5IdSet = new set <Id>();
		set <String> accountProductWithActiveShipment = new set <String>();
		map <String, G5_Transmitter_Oracle_Prod_Id__c> g5TransmitterOrcaleId;
		map <Id, Product2> productIdMap;
		G5_Product_Code__c g5ProdCode = G5_Product_Code__c.getOrgDefaults();
		for (Scheduled_Shipments__c ss : schedShipmentsList){
			//check if the parent account is not null
			if(ss.Account__c != null){
				//add the parent account id to !parentAccountIdSet
				parentAccountIdSet.add(ss.Account__c);
			}
			
			if(ss.Product_Item__c != null){
				if (!productIdSet.contains(ss.Product_Item__c)){
					productIdSet.add(ss.Product_Item__c);
				}			
			}
		}
		
		
		productIdMap = new map <Id, Product2>([SELECT Id, ProductCode FROM Product2 WHERE Id IN: productIdSet]);
		/*for (Asset a : [SELECT Id, AccountId FROM Asset WHERE Name = 'G5 Transmiter Test' AND AccountId IN: parentAccountIdSet]){
			accountWithG5IdSet.add(a.AccountId);
		}
		for (Scheduled_Shipments__c ss: [SELECT Id, Product_Item__c, Account__c FROM Scheduled_Shipments__c WHERE End_Date__c = null AND Account__c IN: parentAccountIdSet]){
			accountProductWithActiveShipment.add(ss.Account__c+'-'+ss.Product_Item__c);
		}*/
		
		// get all the active Scheduled Shipments and G5 Asset for an account
		g5TransmitterOrcaleId = G5_Transmitter_Oracle_Prod_Id__c.getall();
		/*('144995','144979','144938','143970','137904','145947')*/
		for (Account a : [SELECT Id, Default_Price_Book__c, (SELECT Id, Product_Item__c FROM Scheduled_Shipments__r WHERE End_Date__c = null), (SELECT Product2.Oracle_Product_Id__c, Product2Id, Order_Number__c, Name, Description, AccountId
							From Assets where Product2.Oracle_Product_Id__c IN: g5TransmitterOrcaleId.keySet())  FROM Account WHERE Id IN: parentAccountIdSet]){
			// check if the list of G5 for the Account's asset is not empty
			if(!a.Assets.isEmpty()){
				accountWithG5IdSet.add(a.Id);
			}
			
			// check if the account has a default price book
			if (String.isEmpty(a.Default_Price_Book__c)){
				accountIdWithNoPriceBook.add(a.Id);
			}
			
			// iterate the active Scheduled Shipments for the account
			for(Scheduled_Shipments__c ss : a.Scheduled_Shipments__r){
				// concatinate the Parent Account Id and the Prouct item id and add it to !accountProductWithActiveShipment
				accountProductWithActiveShipment.add(a.Id+'-'+ss.Product_Item__c);
			}
			
		}
		
		for (Scheduled_Shipments__c ss: schedShipmentsList){
			if(!accountIdWithNoPriceBook.contains(ss.Account__c)){
				if (productIdMap.get(ss.Product_Item__c) != null){
					if (productIdMap.get(ss.Product_Item__c).ProductCode == g5ProdCode.Product_Code__c){
						// check if the account already has a G5 Transmitter Asset
						if (accountWithG5IdSet.contains(ss.Account__c)){
							// check if the account already has an active scheduled shipments with the same product item
							if(accountProductWithActiveShipment.contains(ss.Account__c + '-' + ss.Product_Item__c) && ss.End_Date__c == null){
								ss.addError('There is already an active shipment for this product on the account.');
							}else{
								accountProductWithActiveShipment.add(ss.Account__c + '-' + ss.Product_Item__c);
							}
						}else{
							ss.addError('Scheduled Shipments are only available for customers with a G5 transmitter.');
						}
					}else{
						if(accountProductWithActiveShipment.contains(ss.Account__c + '-' + ss.Product_Item__c) && ss.End_Date__c == null){
							ss.addError('There is already an active shipment for this product on the account.');
						}else{
							accountProductWithActiveShipment.add(ss.Account__c + '-' + ss.Product_Item__c);
						}
					}
				}
			}else{
				ss.addError('Scheduled shipments require a default pricebook on the Account.');			
			}
		}
	}
	
	
	/**
	 *@description 	: contains the logic for validating the creation of Scheduled_Shipments__c
	 *@author 		: Noy De Goma@CSHERPAS
	 *@date 		: 01.07.2016
	 *@param 		: schedShipmentsList - list Scheduled_Shipments__c
	 *@return 		: N/A
	**/
	public static void scheduledShipmentsValidationOnUpdate(map <Id, Scheduled_Shipments__c> schedShipmentsMap){
		set<id> parentAccountIdSet = new set <Id>();
		set <Id> productIdSet = new set <Id>();
		set <id> accountIdWithNoPriceBook = new set <Id>();
		set <Id> accountWithG5IdSet = new set <Id>();
		set <String> accountProductWithActiveShipment = new set <String>();
		map <String, G5_Transmitter_Oracle_Prod_Id__c> g5TransmitterOrcaleId;
		map <Id, Product2> productIdMap;
		G5_Product_Code__c g5ProdCode = G5_Product_Code__c.getOrgDefaults();
		for (Scheduled_Shipments__c ss : schedShipmentsMap.values()){
			//check if the parent account is not null
			if(ss.Account__c != null){
				//add the parent account id to !parentAccountIdSet
				parentAccountIdSet.add(ss.Account__c);
			}
			
			if(ss.Product_Item__c != null){
				if (!productIdSet.contains(ss.Product_Item__c)){
					productIdSet.add(ss.Product_Item__c);
				}			
			}
		}
		
		
		productIdMap = new map <Id, Product2>([SELECT Id, ProductCode FROM Product2 WHERE Id IN: productIdSet]);
		// get all the active Scheduled Shipments and G5 Asset for an account
		g5TransmitterOrcaleId = G5_Transmitter_Oracle_Prod_Id__c.getall();
		/*('144995','144979','144938','143970','137904','145947')*/
		for (Account a : [SELECT Id, Default_Price_Book__c, (SELECT Id, Product_Item__c FROM Scheduled_Shipments__r WHERE End_Date__c = null AND Id NOT IN: schedShipmentsMap.keySet()), (SELECT Product2.Oracle_Product_Id__c, Product2Id, Order_Number__c, Name, Description, AccountId
							From Assets where Product2.Oracle_Product_Id__c IN: g5TransmitterOrcaleId.keySet())  FROM Account WHERE Id IN: parentAccountIdSet]){
			// check if the list of G5 for the Account's asset is not empty
			if(!a.Assets.isEmpty()){
				accountWithG5IdSet.add(a.Id);
			}
			
			// check if the account has a default price book
			if (String.isEmpty(a.Default_Price_Book__c)){
				accountIdWithNoPriceBook.add(a.Id);
			}
			
			// iterate the active Scheduled Shipments for the account
			for(Scheduled_Shipments__c ss : a.Scheduled_Shipments__r){
				// concatinate the Parent Account Id and the Prouct item id and add it to !accountProductWithActiveShipment
				accountProductWithActiveShipment.add(a.Id+'-'+ss.Product_Item__c);
			}
			
		}
		
		for (Scheduled_Shipments__c ss: schedShipmentsMap.values()){
			if(!accountIdWithNoPriceBook.contains(ss.Account__c)){
				if (productIdMap.get(ss.Product_Item__c) != null){
					if (productIdMap.get(ss.Product_Item__c).ProductCode == g5ProdCode.Product_Code__c){
						// check if the account already has a G5 Transmitter Asset
						if (accountWithG5IdSet.contains(ss.Account__c)){
							// check if the account already has an active scheduled shipments with the same product item
							if(accountProductWithActiveShipment.contains(ss.Account__c + '-' + ss.Product_Item__c) && ss.End_Date__c == null){
								ss.addError('There is already an active shipment for this product on the account.');
							}else{
								accountProductWithActiveShipment.add(ss.Account__c + '-' + ss.Product_Item__c);
							}
						}else{
							ss.addError('Scheduled Shipments are only available for customers with a G5 transmitter.');
						}
					}else{
						if(accountProductWithActiveShipment.contains(ss.Account__c + '-' + ss.Product_Item__c) && ss.End_Date__c == null){
							ss.addError('There is already an active shipment for this product on the account.');
						}else{
							accountProductWithActiveShipment.add(ss.Account__c + '-' + ss.Product_Item__c);
						}
					}
				}
			}else{
				ss.addError('Scheduled shipments require a default pricebook on the Account.');			
			}
		}
	}
}