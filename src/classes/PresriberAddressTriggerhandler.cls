public class PresriberAddressTriggerhandler {
    
    public static void afterInsert(List<Address__c> addressList){
        Map<Id, Address__c> mapAccAddress = new Map<Id, Address__c>();
        Set<Id> addressId = new Set<Id>();
        
        for(Address__c addrs : addressList){
            if(addrs.Primary_Flag__c){
                mapAccAddress.put(addrs.Account__c, addrs);
                addressId.add(addrs.Id);
            }
        }
        if(!mapAccAddress.isEmpty()){
            ProcessAccount(mapAccAddress, addressId, addressList);
        }
    }
    
    
    public static void afterUpdate(List<Address__c> addressList, Map<Id, Address__c> mapAddress){
        Map<Id, Address__c> mapAccAddress = new Map<Id, Address__c>();
        Set<Id> addressId = new Set<Id>();
        
        for(Address__c addrs : addressList){
            if(addrs.Primary_Flag__c){
                if(addrs.Primary_Flag__c != mapAddress.get(addrs.Id).Primary_Flag__c || addrs.Address_Type__c != mapAddress.get(addrs.Id).Address_Type__c){
                    mapAccAddress.put(addrs.Account__c, addrs);
                    addressId.add(addrs.Id);
                }
            }
        }
        
        if(!mapAccAddress.isEmpty()){
            ProcessAccount(mapAccAddress, addressId, addressList);
        }
    }
    public static void ProcessAccount(Map<Id, Address__c> mapIdAddress, Set<Id> addrsId, List<Address__c> listAddress){
        List<SObject> toBeUpdated = new List<SObject>();
        Map<String, List<Address__c>> mapStringAddrs = new Map<String, List<Address__c>>();
        Set<String> addressType = new Set<String>();
        List<Address__c> tempList = new List<Address__c>();
        
            
       
        for(Account acc : [SELECT Id, 
                               PersonMailingStreet,
                               PersonMailingState,
                               PersonMailingCountry,
                               PersonMailingCity,
                               PersonMailingPostalCode,New_Address_ID__c
                               FROM Account WHERE Account_Record_Type__c = 'Prescriber'AND Id IN : mapIdAddress.keySet()]){    
            if(mapIdAddress.get(acc.Id).Street_Address_1__c != null){
                acc.PersonMailingStreet = mapIdAddress.get(acc.Id).Street_Address_1__c;
                acc.PersonMailingState  = mapIdAddress.get(acc.Id).State__c;
                acc.PersonMailingCity = mapIdAddress.get(acc.Id).City__c;
                acc.PersonMailingCountry = mapIdAddress.get(acc.Id).County__c;
                acc.PersonMailingPostalCode = mapIdAddress.get(acc.Id).Zip_Postal_Code__c;
                acc.New_Address_ID__c = mapIdAddress.get(acc.Id).ID;
            }
                toBeUpdated.add(acc);
        }
        List<Address__c> addressList = [SELECT Id, 
                                        Primary_Flag__c, 
                                        Address_Type__c,
                                        Account__c
                                        FROM Address__c 
                                        WHERE Id NOT IN: addrsId 
                                        AND Account__c IN : mapIdAddress.keySet()];
                                        
   
            
            for(Address__c addrs : addressList){
                System.debug('\n\n**********Address_Type__c************ ' +addrs.Address_Type__c);
                if(mapIdAddress.get(addrs.Account__c).Address_Type__c.equalsIgnoreCase('BILL_TO')){
                    System.debug('\n\n**********Address_Type__c 2************ ' +addrs.Address_Type__c);
                    //if(mapIdAddress.get(addrs.Account__c).Address_Type__c.equalsIgnoreCase(addrs.Address_Type__c)){
                        System.debug('\n\n**********Address_Type__c 3************ ' +addrs.Address_Type__c);
                        if(!addrs.Address_Type__c.equalsIgnoreCase('SHIP_TO')){
                            tempList.add(addrs);
                        }
                    //}
                }else if (mapIdAddress.get(addrs.Account__c).Address_Type__c.equalsIgnoreCase('SHIP_TO')){
                    //if(mapIdAddress.get(addrs.Account__c).Address_Type__c.equalsIgnoreCase(addrs.Address_Type__c)){
                        if(!addrs.Address_Type__c.equalsIgnoreCase('BILL_TO')){
                            tempList.add(addrs);
                        }
                        
                    //}
                }
            }

        for(Address__c addrssMap : tempList){
            System.debug('\n\n*********addrssMap********** ' + addrssMap);
            addrssMap.Primary_Flag__c = false;
            toBeUpdated.add(addrssMap);
        }

        
        System.debug('\n\n*********toBeUpdated********** ' + toBeUpdated);
        
        try{
            if(!toBeUpdated.isEmpty()){
                update toBeUpdated;
            }
        }catch(Exception e){
            system.debug('***ERROR = ' + e.getMessage());
        }
    }
      
    public static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}