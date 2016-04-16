/**
 * @description : Batch Class that will update the Order header
 * @author      : Noy De Goma@CSHERPAS
 * @date        : 03.24.2016
**/
global with sharing class UpdateOrderHeaderBatch implements Database.Batchable<sObject>{
    set <Id> orderHeaderIds = new set <Id>();
    global UpdateOrderHeaderBatch(set <Id> ohIds){
        orderHeaderIds = ohIds;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Product_Type__c, (SELECT Id, Item_Number__c FROM Order_Item_Details__r) FROM Order_Header__c '+
                        'WHERE Id IN :orderHeaderIds';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Order_Header__c> scope){
        for(Order_Header__c oh : scope){
            list <Order_Item_Detail__c> itemDetailList = oh.Order_Item_Details__r;
            set <String> itemNumFirstThreeChar = new set <String>();
            for (Order_Item_Detail__c oid : itemDetailList){
                if(!String.isEmpty(oid.Item_Number__c) && (oid.Item_Number__c).length() >= 3){
                    itemNumFirstThreeChar.add((oid.Item_Number__c).substring(0,3));
                }
            }
            if(itemNumFirstThreeChar.contains('STK')){
                oh.Product_Type__c = 'System';
            }else if(itemNumFirstThreeChar.contains('STT')){
                oh.Product_Type__c = 'Transmitter';
            }else if(itemNumFirstThreeChar.contains('STS')){
                oh.Product_Type__c = 'Sensor';
            }
        }
        update scope;
        
    }

    global void finish(Database.BatchableContext BC){
        
    }

}