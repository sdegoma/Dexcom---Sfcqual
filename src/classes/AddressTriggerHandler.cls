/*******************************************
 * @author      : Kingsley Tumaneng
 * @date        : SEPT 21 2015
 * @description : Class to update Account
                  Address if the Primary 
                  Address was checked.
*******************************************/
public class AddressTriggerHandler {
    
    /*************************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 21 2015
     * param(s)     : addressList - List of Address
                      to be inserted
     * return(s)    : void
     * description  : Method for updating an Account
                      if the Address Primary_Flag__c
                      was checked. It will copy the 
                      appropriate fields from the
                      and put it on the Account
                      (either Billing Address or
                      Shipping Address).
     * revision(s)  :
    *************************************************/
    public static void afterInsert(List<Address__c> addressList){
        Map<Id, List<Address__c>> mapAccAddress = new Map<Id, List<Address__c>>();
        Set<Id> addressId = new Set<Id>();
        set <id> accsId = new set <id>();
        List<Address__c> listAddress = new List<Address__c>();
        Map<String, Address__c> forPrimary = new Map<String, Address__c>();
        for(Address__c addrs : addressList){
            if(addrs.Primary_Flag__c){
                system.debug('************* address_type__c ******** ' + addrs.Address_Type__c );
                if(addrs.Address_Type__c == 'BILL_TO' && forPrimary.get(addrs.Account__c + 'BILL_TO') == null){
                    forPrimary.put(addrs.Account__c + 'BILL_TO', addrs);
                    addressId.add(addrs.Id);
                    accsId.add(addrs.Account__c);
                }else if(addrs.Address_Type__c == 'SHIP_TO' && forPrimary.get(addrs.Account__c + 'SHIP_TO') == null){
                    forPrimary.put(addrs.Account__c + 'SHIP_TO', addrs);
                    addressId.add(addrs.Id);
                    accsId.add(addrs.Account__c);
                }
            }
        }
        
        if(!forPrimary.isEmpty()){
            ProcessAccount(forPrimary, addressId, addressList, accsId);
        }
    
    }
    
    /*************************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 21 2015
     * param(s)     : addressList - List of Address
                      to be updated
                    : mapAddress - Map of old value
                      of Address
     * return(s)    : void
     * description  : Method for updating an Account
                      if the Address Primary_Flag__c
                      was checked. It will copy the 
                      appropriate fields from the
                      and put it on the Account
                      (either Billing Address or
                      Shipping Address).
     * revision(s)  :
    *************************************************/
    public static void afterUpdate(List<Address__c> addressList, Map<Id, Address__c> mapAddress){
        Map<Id, List<Address__c>> mapAccAddress = new Map<Id, List<Address__c>>();
        Set<Id> addressId = new Set<Id>();
        set <id> accsId = new set <id>();
        List<Address__c> listAddress = new List<Address__c>();
        Map<String, Address__c> forPrimary = new Map<String, Address__c>();
        for(Address__c addrs : addressList){
            if(addrs.Primary_Flag__c){
                if(addrs.Primary_Flag__c != mapAddress.get(addrs.Id).Primary_Flag__c || addrs.Address_Type__c != mapAddress.get(addrs.Id).Address_Type__c){
                    if(addrs.Address_Type__c == 'BILL_TO' && forPrimary.get(addrs.Account__c + 'BILL_TO') == null){
                        forPrimary.put(addrs.Account__c + 'BILL_TO', addrs);
                        addressId.add(addrs.Id);
                        accsId.add(addrs.Account__c);
                    }else if(addrs.Address_Type__c == 'SHIP_TO' && forPrimary.get(addrs.Account__c + 'SHIP_TO') == null){
                        forPrimary.put(addrs.Account__c + 'SHIP_TO', addrs);
                        addressId.add(addrs.Id);
                        accsId.add(addrs.Account__c);
                    }
                    
                    
                }
            }
        }
        
        if(!forPrimary.isEmpty()){
            ProcessAccount(forPrimary, addressId, addressList, accsId);
        }
    }
    
    /*************************************************
     * author       : Kingsley Tumaneng
     * date         : SEPT 21 2015
     * param(s)     : mapIdAddress - Map of Address
     * return(s)    : void
     * description  : Method to process Account
     * revisong(s)  :
    *************************************************/
    public static void ProcessAccount(Map<String, Address__c> mapIdAddress, Set<Id> addrsId, List<Address__c> listAddress, set <id> accsId){
        Set<SObject> toBeUpdated = new Set<SObject>();
        List<SObject> recordsToUpdate = new List<SObject>();
        Map<String, List<Address__c>> mapStringAddrs = new Map<String, List<Address__c>>();
        Set<String> addressType = new Set<String>();
        List<Address__c> tempList = new List<Address__c>();

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
                           FROM Account WHERE Id IN : accsId]){
            
            if(mapIdAddress.containsKey(acc.Id + 'BILL_TO')){
                acc.BillingStreet = mapIdAddress.get(acc.Id + 'BILL_TO').Street_Address_1__c;
                acc.BillingState = mapIdAddress.get(acc.Id + 'BILL_TO').State__c;
                acc.BillingCity = mapIdAddress.get(acc.Id + 'BILL_TO').City__c;
                //acc.BillingCountry = mapIdAddress.get(acc.Id + 'BILL_TO').County__c;
                acc.BillingPostalCode = mapIdAddress.get(acc.Id + 'BILL_TO').Zip_Postal_Code__c;
            
            } 
            if(mapIdAddress.containsKey(acc.Id + 'SHIP_TO')){
                acc.ShippingStreet = mapIdAddress.get(acc.Id + 'SHIP_TO').Street_Address_1__c;
                acc.ShippingState = mapIdAddress.get(acc.Id + 'SHIP_TO').State__c;
                acc.ShippingCity = mapIdAddress.get(acc.Id + 'SHIP_TO').City__c;
                acc.County__c = mapIdAddress.get(acc.Id + 'SHIP_TO').County__c;
                acc.ShippingPostalCode = mapIdAddress.get(acc.Id + 'SHIP_TO').Zip_Postal_Code__c;
            }
            toBeUpdated.add(acc);
        }
        
        map <id, list<Address__c>> addressMap = new map<Id, list<Address__c>>();
                                        
        for(Address__c a : [SELECT Id, 
                                        Primary_Flag__c, 
                                        Address_Type__c,
                                        Account__c
                                        FROM Address__c 
                                        WHERE Id NOT IN: addrsId 
                                        AND Account__c IN : accsId]){
                                            
            if(!addressMap.containsKey(a.Account__c)){
                addressMap.put(a.Account__c, new list <Address__c>{a});
            }else{
                addressMap.get(a.Account__c).add(a);
            }
            
        }
        
            system.debug('****************** mapIdAddress ************* ' + mapIdAddress);
             for(Address__c a : mapIdAddress.values()){
                 if(addressMap.containsKey(a.Account__c)){
                     
                    
                     //for(list<Address__c> addrs : addressMap.values()){
                         //list <Address__c> addList = addrs;
                         for(Address__c add : addressMap.get(a.Account__c)){
                             
                            if(add.address_type__c == 'BILL_TO'){
                                if(!a.Address_Type__c.equalsIgnoreCase('SHIP_TO')){
                                    tempList.add(add);
                                }   
                            }
                            if(add.address_type__c == 'SHIP_TO'){
                                if(!a.Address_Type__c.equalsIgnoreCase('BILL_TO')){
                                    tempList.add(add);
                                } 
                            }
                            
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
        for (SObject s : toBeUpdated){
            System.debug('\n\n*********toBeUpdated duplicates********** ' + s.get('id'));
        }
        recordsToUpdate.addAll(toBeUpdated);
        try{
            if(!toBeUpdated.isEmpty()){
                update recordsToUpdate;
            }
        }catch(Exception e){
            system.debug('***ERROR = ' + e.getMessage());
        }
    }
    
    /**************************************
     * author       : KIngsley Tumaneng
     * date         : SEPT 21 2015
     * param(s)     :
     * return(s)    : Boolean
     * description  : Method to run the 
                      trigger once
     * revision(s)                
    **************************************/
    public static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    /***********************************************
     * author       : KIngsley Tumaneng
     * date         : SEPT 21 2015
     * param(s)     : List of Address to be deleted
     * return(s)    : void
     * description  : Method for delete
     * revision(s)                
    ***********************************************/
    public static void isBeforeDeleted(List<Address__c> addrsList){
        Set<Id> toBeDeleted = new Set<Id>();
        for(Address__c addrs : addrsList){
            if(addrs.Primary_Flag__c){
                toBeDeleted.add(addrs.Id);
            }
        }
        
        for(Address__c addrs : addrsList){
            If(toBeDeleted.contains(addrs.Id)){
                addrs.addError('You cannot delete a Primary Address.');
            }
        }
    }
}