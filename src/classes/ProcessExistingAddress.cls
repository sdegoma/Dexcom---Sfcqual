/*****************************************************
 * @author          : Kingsley Tumaneng
 * @date            : SEPT 14 2015
 * @description     : Batch apex to process existing
 *                    Address
*****************************************************/
global class ProcessExistingAddress implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('***START');
        return DataBase.getQueryLocator([SELECT Id, 
                                         PARTY_NAME__c, 
                                         Primary_Flag__c, 
                                         Address_Type__c, 
                                         Account__c,
                                         Street_Address_1__c,
                                         State__c,
                                         City__c,
                                         County__c,
                                         Zip_Postal_Code__c,
                                         CreatedDate
                                         FROM Address__c
                                         WHERE Account__c != null 
                                         AND Account__c != ''
                                         AND Primary_Flag__c = True
                                         ORDER BY CreatedDate ASC]);
	}
    
    global void execute(Database.BatchableContext BC, List<Address__c> scope) {
        Map<Id, List<Address__c>> mapAccId_Address = new Map<Id, List<Address__c>>();
        Map<Id, Account> toBeUpdated = new Map<Id, Account>();
        system.debug('***scope = ' + scope);
        for(Address__c addrs : scope){
            system.debug('***Account = ' + addrs.Account__c);
            if(!mapAccId_Address.containsKey(addrs.Account__c)){
                mapAccId_Address.put(addrs.Account__c, new List<Address__c>{addrs});
            }else{
                mapAccId_Address.get(addrs.Account__c).add(addrs);
            }
        }
        
        for(Account acc : [SELECT Id, 
                          BillingStreet, 
                          BillingState, 
                          BillingCity, 
                          BillingCountry, 
                          BillingPostalCode,
                          ShippingStreet, 
                          ShippingState, 
                          ShippingCity, 
                          ShippingCountry, 
                          ShippingPostalCode
                          FROM Account WHERE Id IN : mapAccId_Address.keySet()]){
            system.debug('***OUTER LOOP');
            DateTime billDate = DateTime.valueOfGmt('1997-01-01 00:00:00');
            DateTime shipDate = DateTime.valueOfGmt('1997-01-01 00:00:00');
                for(Address__c addr : mapAccId_Address.get(acc.Id)){ 
                    system.debug('***INNER LOOP');
                    if(mapAccId_Address.containsKey(addr.Account__c)){
                        system.debug('***Address = ' + mapAccId_Address.get(acc.Id));
                        if(addr.Address_Type__c == 'BILL_TO' && addr.Primary_Flag__c == TRUE){
                            if(addr.CreatedDate >= billDate && billDate != null){
                                system.debug('***BILLING');
                                acc.BillingStreet = addr.Street_Address_1__c;
                                acc.BillingState = addr.State__c;
                                acc.BillingCity = addr.City__c;
                                acc.BillingCountry = addr.County__c;
                                acc.BillingPostalCode = addr.Zip_Postal_Code__c;
                            }
                            billDate = addr.CreatedDate;
                        }
                        if(addr.Address_Type__c == 'SHIP_TO' &&addr.Primary_Flag__c == TRUE){
                            if(addr.CreatedDate >= shipDate && shipDate != null){
                                system.debug('***SHIPPING');
                                acc.ShippingStreet = addr.Street_Address_1__c;
                                acc.ShippingState = addr.State__c;
                                acc.ShippingCity = addr.City__c;
                                acc.ShippingCountry = addr.County__c;
                                acc.ShippingPostalCode = addr.Zip_Postal_Code__c;
                            }
                            shipDate = addr.CreatedDate;
                        }
            
                    
                } toBeUpdated.put(acc.Id, acc);
            }     
           
        }
        
        system.debug('***toBeUpdated = ' + toBeUpdated);
        update toBeUpdated.values();
        system.debug('***ACCOUNT HAS BEEN UPDATED');
        system.debug('***toBeUpdated = ' + toBeUpdated);
    }
    
    global void finish(Database.BatchableContext BC){}

}