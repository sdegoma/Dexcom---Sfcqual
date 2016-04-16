/**
 *@description	: Trigger handler for the orderheadermastertrigger
 *@author		: Noy De Goma@CSHERPAS
 *@date			: 02.17.2016
**/
public with sharing class OrderHeaderTriggerHandler {
	/**
	 *@description	: Contains the filter logic for the trigger
	 *@author		: Noy De Goma@CSHERPAS
	 *@date			: 02.17.2016
	 *@param		: newOrderHeaderList - list of the newly created OrderHeader
	 *@return		: N/A
	**/
	public static void onBeforeInsert(list<Order_Header__c> newOrderHeaderList){
		list <Order_Header__c> orderList = new List <Order_Header__c>();
		set <String> orderIdSet = new set <String>();
		for(Order_Header__c oh : newOrderHeaderList){
			if(!String.isEmpty(oh.Order_Id__c)){
				orderList.add(oh);
				orderIdSet.add(oh.Order_Id__c);
			}	
		}
		if(!orderList.isEmpty()){
			updateOrderOppty(orderIdSet, orderList);
		}
	}
	/**
	 *@description	: This method is responsible for getting the opportunity with the same order_num__c as the order header's
	 				  Order_Id__c and update the orderheader.opportunity with the opportunity's Id
	 *@author		: Noy De Goma@CSHERPAS
	 *@date			: 02.17.2016
	 *@param		: newOrderHeaderMap - map of the newly created OrderHeader
	 *@return		: N/A
	**/
	private static void updateOrderOppty(set <String> orderNumSet, List <Order_Header__c> newOrderHeaderList){
		map <String, Opportunity> oppMap = new map<String, Opportunity>();
		for (Opportunity opp : [SELECT Id, Order_NUM__c FROM Opportunity WHERE Order_NUM__c IN: orderNumSet AND Order_NUM__c != NULL AND isDeleted = false]){
			if(!oppMap.containsKey(opp.Order_NUM__c)){
				oppMap.put(opp.Order_NUM__c, opp);
			}
		}
		
		for (Order_Header__c oh : newOrderHeaderList){
			if(oppMap.get(oh.Order_Id__c) != NULL){
				oh.Opportunity__c = oppMap.get(oh.Order_Id__c).Id;
			}
		}
	}
}