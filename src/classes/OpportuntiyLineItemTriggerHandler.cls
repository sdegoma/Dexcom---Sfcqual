/********************************************************
 * @author      : Kingsley Tumaneng
 * @date        : OCT 22, 2015
 * @description : Trigger handler for OpportunityLineItem
*********************************************************/
public class OpportuntiyLineItemTriggerHandler {
    public static void beforeInsert(List<OpportunityLineItem> oppLineItemList){
        Map<Id, OpportunityLineItem> mapOppLineItem = new Map<Id, OpportunityLineItem>();
        Map<Id, List<OpportunityLineItem>> mapExistingOpptyLineItem = new Map<Id, List<OpportunityLineItem>>();
        Set<Id> productId = new Set<Id>();
        Map<Id, Product2> mapProduct = new Map<Id, Product2>();
        Boolean isError = false;
        List<Product2> prodList = new List<Product2>();
        
        system.debug('***oppLineItemList = ' + oppLineItemList);
        for(OpportunityLineItem oppLineItem : oppLineItemList){
            productId.add(oppLineItem.Product2Id);
            mapOppLineItem.put(oppLineItem.OpportunityId, oppLineItem);
        }
        
        for(Product2 prod : [SELECT Id, Generation__c FROM Product2 WHERE Id IN : productId]){
            system.debug('***prod.Product2.Generation__c = ' + prod.Generation__c);
            if(prod.Generation__c != null){
                mapProduct.put(prod.Id, prod);
                prodList.add(prod);
            }
            system.debug('***mapProduct.get(newOppLineItem.Product2Id) = ' + mapProduct);
        }
        
        system.debug('***INSIDE IF');
        for(OpportunityLineItem existingOpportunityLineItem : [SELECT Id, OpportunityId, Product2.Generation__c FROM OpportunityLineItem WHERE OpportunityId IN : mapOppLineItem.keySet()]){    
            if(!mapExistingOpptyLineItem.containsKey(existingOpportunityLineItem.OpportunityId)){
                mapExistingOpptyLineItem.put(existingOpportunityLineItem.OpportunityId, new List<OpportunityLineItem>{existingOpportunityLineItem});
            }else{
                mapExistingOpptyLineItem.get(existingOpportunityLineItem.OpportunityId).add(existingOpportunityLineItem);
            }
        }
        
        for(OpportunityLineItem newOppLineItem : oppLineItemList){
            if(mapProduct.get(newOppLineItem.Product2Id)  != null){
                if(!mapExistingOpptyLineItem.isEmpty()){
                    for(OpportunityLineItem mapOpptyLine : mapExistingOpptyLineItem.get(newOppLineItem.OpportunityId)){
                        if(mapOpptyLine.Product2.Generation__c != mapProduct.get(newOppLineItem.Product2Id).Generation__c){
                            newOppLineItem.addError('The product you are trying to add is of a different Generation than products already on the Opportunity');
                        }
                    }
                }else{
                    system.debug('***INSIDE ELSE');
                    if(oppLineItemList.size() > 1){
                        system.debug('***mapProduct.get(newOppLineItem.Product2Id) = ' + mapProduct.get(newOppLineItem.Product2Id));
                        system.debug('***prodList = ' + prodList);
                        system.debug('***prodListsize() = ' + prodList.size());
                        for(integer i = 0; i < prodList.size() - 1; i++){
                            system.debug('***i = ' + i);
                            if(prodList[i].Generation__c != prodList[i + 1].Generation__c){
                                newOppLineItem.addError('The product you are trying to add is of a different Generation');
                            }
                        }
                    }
                }
            }
        }
    }
}