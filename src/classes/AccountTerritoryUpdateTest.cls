/********************************************************************************
@author Abhishek Parghi
@date 10/08/2015
@description: Test class for PCS Call List.
*******************************************************************************/
@istest
public class AccountTerritoryUpdateTest{
    Static testmethod void AccountTerritoryUpdate_test(){ 
      
       User Ap = TestDataBuilder.testUser();
       insert AP;  
       User u1 = [Select id, lastname from USer where lastname= 'TUser' ];
        
       Territory_Alignment__c z4 = new Territory_Alignment__c ();
       z4.name = '05442';
       z4.Territory_Rep__c= u1.id;
       insert z4;  
     
       Territory_Alignment__c Tz = [Select id,name,RSD__c,Territory_Rep__c from Territory_Alignment__c WHERE Name =: '05442'];
     
       Zip_Territory__c z3 = new Zip_Territory__c ();
       z3.name = '95112';
       z3.Territory_Code__c ='05442' ;
       insert z3;        
       map<string,string> territoryMap1=new map<string,string>();  
       for(Zip_Territory__c z : [Select name, Territory_Code__c from Zip_Territory__c WHERE name =: '95112']) {
          territoryMap1.put (z.name, z.Territory_Code__c);
       }
                  
       Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;
       Account acc5 = new Account();
       acc5.RecordTypeId = personRecordTypeID;
       acc5.FirstName = 'APTestfirstname';
       acc5.LastName = 'APTestlastname';
       acc5.PersonEmail = 'APTestAP@gmail.com';
       acc5.Phone = '12345678900';
       acc5.BillingState = 'APTest State';
       acc5.BillingCity = 'APTest City';
       acc5.BillingStreet = 'APTest Street';
       acc5.ShippingPostalCode =  '95112';
       acc5.BillingCountry = 'United States';
       Acc5.Prescriber__c = null;
       insert acc5;
   
       Account acc6 = new Account();
       acc6 .RecordTypeId = personRecordTypeID;
       acc6 .FirstName = 'APTestfirstname';
       acc6 .LastName = 'APTestlastname';
       acc6.territory_code__C = '05442';
       Acc6.Prescriber__c = null;
       
       insert acc6 ;
       test.startTest();
       update acc5;
       update acc6 ;
       System.assertEquals(acc5.ShippingPostalCode , z3.name);  
       test.stopTest();
          
      }
}