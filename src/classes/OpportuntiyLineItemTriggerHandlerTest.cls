@isTest
private class OpportuntiyLineItemTriggerHandlerTest {
    
    @isTest static void beforeInsertTest(){
        test.startTest();
        try{
            Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            
            Opportunity opp = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
                insert opp;
            
            OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItem('1', 1, opp.Id);
                insert oppLineItem;
                
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('The product you are trying to add is of a different Generation than products already on the Opportunity') ? true : false;
            System.AssertEquals(expectedExceptionThrown, false);
        }
        test.stopTest();
    }
    
    @isTest static void exisitingLineItemTest(){
        test.startTest();
        try{
            Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            
            Opportunity opp = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
                insert opp;
            
            OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItem('1', 1, opp.Id);
                insert oppLineItem;
                
            OpportunityLineItem oppLineItem2 = TestDataBuilder.getOpportunityLineItem('2', 2, opp.Id);
                insert oppLineItem2;
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('The product you are trying to add is of a different Generation than products already on the Opportunity') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }    
        test.stopTest();
    }
    
    @isTest static void sameLineItemTest(){
        test.startTest();
        try{
            Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
            Account acc = TestDataBuilder.getAccountList(1, recId)[0];
                insert acc;
            
            Opportunity opp = TestDataBuilder.getOpportunityList(1, acc.Id, acc.Id)[0];
                insert opp;
            
            OpportunityLineItem oppLineItem = TestDataBuilder.getOpportunityLineItem('1', 1, opp.Id);
                insert oppLineItem;
                
            OpportunityLineItem oppLineItem3 = TestDataBuilder.getOpportunityLineItem('1', 3, opp.Id);
                insert oppLineItem3;
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('The product you are trying to add is of a different Generation than products already on the Opportunity') ? true : false;
            System.AssertEquals(expectedExceptionThrown, false);
        }
        test.stopTest();
    }
}