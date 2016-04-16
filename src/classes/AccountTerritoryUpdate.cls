/********************************************************************************
@author Abhishek Parghi
@date 11/18/2015
@description: Apex class for account territory update & Benefits party id update.
*******************************************************************************/
public class AccountTerritoryUpdate {
     public static void PrescribersTerritoryBeforeUpdate(List<Account> accountsNew){
      set<string> Zipcodes = new set<string>();  
      set<ID> Accset = new Set<ID>(); 
      Id CnRecordTypeId3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prescriber').getRecordTypeId(); 
      for (Account A: accountsNew) {
           if(A.ShippingPostalCode != null && A.RecordTypeId == CnRecordTypeId3 ){    
             if(A.ShippingPostalCode.length() >= 5){
              Zipcodes.add(A.ShippingPostalCode.substring(0,5));
             }
           }
      } 
     //query the zip_Ter object to get the zipcode (Name) and zone from the zip ter object  
      map<string,string> territoryMap=new map<string,string>();  
       for(Zip_Territory__c z : [Select name, Territory_Code__c from Zip_Territory__c WHERE name IN :Zipcodes]) {
          territoryMap.put (z.name, z.Territory_Code__c);
       }

     for(Account Acc: accountsNew) {
        if(Acc.Territory_Code__c == null){ 
         if(Acc.ShippingPostalCode != null){
              if(!territoryMap.isEmpty() && Acc.ShippingPostalCode.length() >= 5){
                 String territory = territoryMap.get(Acc.ShippingPostalCode.substring(0,5));
                  if(territory != null) {
                   Acc.Territory_Code__c = territory;
                  }
              }
         }
        }  
       }
    }     
    public static void PrescribersOwnerupdate(List<Account> accountsNew){
        List<String> terCodes = new List<String>();  
        Set<ID> Accset = new Set<ID>();    
        Id CnRecordTypeId4 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prescriber').getRecordTypeId(); 
        for (Account A: accountsNew) {
          if(A.Territory_Code__c != null && A.RecordTypeId == CnRecordTypeId4 ) {
            terCodes.add(a.Territory_Code__c);
          }
        }
        map<string,ID> territoryalignmentmap =  new map<string,ID>();  
             for(Territory_Alignment__c Tz: [Select id,name,RSD__c,Territory_Rep__c from Territory_Alignment__c WHERE Name IN :terCodes]) {
                territoryalignmentmap.put (Tz.name, Tz.Territory_Rep__c);
             }
        for (Account Acc: accountsNew) {
            if(Acc.Territory_Code__c != null){
               if(!territoryalignmentmap.isEmpty() &&   Acc.Territory_Code__c !=null){
                   ID   territory1  = territoryalignmentmap.get(Acc.Territory_Code__c);
                     if(territory1  != null) {
                     Acc.OwnerID = territory1;
                 }
              }  
            }      
         }
  }    

     public static void ConsumersTerritoryBeforeUpdate(List<Account> accountsNew){
     set<string> Zipcodes = new set<string>();  
     set<ID> Accset = new Set<ID>(); 
      Id CnRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId(); 
      for (Account A: accountsNew) {
          if(A.ShippingPostalCode != null && A.Prescriber__c == null && A.RecordTypeId == CnRecordTypeId2 ){
            if(A.ShippingPostalCode.length() >= 5){
              Zipcodes.add(A.ShippingPostalCode.substring(0,5));
            }
          }
      }
     //query the zip_Ter object to get the zipcode (Name) and zone from the zip ter object  
     map<string,string> territoryMap=new map<string,string>();  
       for(Zip_Territory__c z : [Select name, Territory_Code__c from Zip_Territory__c WHERE name IN :Zipcodes]) {
          territoryMap.put (z.name, z.Territory_Code__c);
       }

    for (Account Acc: accountsNew) {
        if(Acc.Territory_Code__c == null){
            if(Acc.Prescriber__c ==null && Acc.ShippingPostalCode != null){
              if(!territoryMap.isEmpty() && Acc.ShippingPostalCode.length() >= 5){
                 String territory = territoryMap.get(Acc.ShippingPostalCode.substring(0,5)); 
                 if(territory != null) {
                    Acc.Territory_Code__c = territory;
                 }
              }    
          }
         }  
       }
    }         
     
   public static void ConsumersOwnerupdate(List<Account> accountsNew){
        List<String> terCodes = new List<String>();  
        Set<ID> Accset = new Set<ID>();    
        Id CnRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId(); 
        for (Account A: accountsNew) {
          if(A.Territory_Code__c != null && A.RecordTypeId == CnRecordTypeId1 ) {
            terCodes.add(a.Territory_Code__c);
          }
      }
        map<string,ID> territoryalignmentmap =  new map<string,ID>();  
             for(Territory_Alignment__c Tz: [Select id,name,RSD__c,Territory_Rep__c from Territory_Alignment__c WHERE Name IN :terCodes]) {
                territoryalignmentmap.put (Tz.name, Tz.Territory_Rep__c);
             }
        for (Account Acc: accountsNew) {
            if(Acc.Territory_Code__c != null){
               if(!territoryalignmentmap.isEmpty() &&   Acc.Territory_Code__c !=null){
                   ID   territory1  = territoryalignmentmap.get(Acc.Territory_Code__c);
                     if(territory1  != null) {
                     Acc.OwnerID = territory1;
                 }
              }    
          
            }      
         }
  }
    Public static void AccountPartyIDUpdate (List<Account> accountsNew3){
       //--- 01.09.2016 Cloud Sherpas ---//
       Set<id> setOfAccountId = new Set<Id>();
       Id CnRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumers').getRecordTypeId();
       List<Benefits__c> toBeUpdated = new List<Benefits__c>();
       
       //create list of account ids (only active and consumer record type)
       for(Account acc : accountsNew3){
           if(acc.Inactive__c == false && acc.RecordTypeId == CnRecordTypeId){ 
               setOfAccountId.add(acc.id);
           }     
       }
       //get benefit records for set of accounts
       List<Benefits__c> bennies = [SELECT Id, Party_ID__c, Account__r.id, Account__r.Party_ID__c
                                    FROM Benefits__c WHERE Account__r.id IN: setOfAccountId];
       
       //set the party id on the benefit from the account value
       for(Benefits__c b : bennies) {
           if(b.Account__r.Party_ID__c != null){
               b.Party_ID__c = b.Account__r.Party_ID__c;
               b.Check__c = true;
               toBeUpdated.add(b);
           }
       }
       
       //update the benefit records    
       if(!toBeUpdated.isEmpty()){
           //update toBeUpdated;  //pushing party id down to benefits temporarily disabled for 1-way benefit integration. 01.14.2016 Cloud Sherpas
       }
   }
    
 
}