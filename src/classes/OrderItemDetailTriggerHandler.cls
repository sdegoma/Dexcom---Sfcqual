/**
 * @description	: Trigger handler for the OrderItemDetailMasterTrigger
 * @author		: Noy De Goma@CSHERPAS
 * @date		: 03.24.2016
**/
public with sharing class OrderItemDetailTriggerHandler {
	public static void onAfterInsert(list <Order_Item_Detail__c> orderItemDetailList){
		recalculateOrderHeader(orderItemDetailList);
	}
	public static void onAfterUpdate(list <Order_Item_Detail__c> orderItemDetailList){
		recalculateOrderHeader(orderItemDetailList);
	}
	
	private static void recalculateOrderHeader(list <Order_Item_Detail__c> orderItemDetailList){
		set <Id> orderHeaderId = new set <Id>();
		for(Order_Item_Detail__c oid : orderItemDetailList){
			if(!orderHeaderId.contains(oid.Order_Header__c)){
				orderHeaderId.add(oid.Order_Header__c);
			}
		}
		Database.executeBatch(new UpdateOrderHeaderBatch(orderHeaderId), 2000);
	}
}