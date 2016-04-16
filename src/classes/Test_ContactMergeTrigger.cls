@isTest
public class Test_ContactMergeTrigger {
    static testMethod void testContactMerge(){
      //  Id personRecordTypeID=[select Id from RecordType where (Name='Prescriber') and (SobjectType='Account')].Id;
   
        List<Account> ls = new List<Account>{new Account(Firstname='Test1', Lastname = 'Dex', HCP_Party_ID__pc = '12125', Dexcom_Rating__pc = '3-Potential'),
                                                         new Account(Firstname='Test2', Lastname = 'Dex', HCP_Party_ID__pc = '12126', Dexcom_Rating__pc = '2-Lion'),
            											 new Account(Firstname='Test2', Lastname = 'Dex', HCP_Party_ID__pc = '12131', Dexcom_Rating__pc = ' '),
           												 new Account(Firstname='Test2', Lastname = 'Dex', HCP_Party_ID__pc = '12132', Dexcom_Rating__pc = '2-Lion'),
            											 new Account(Lastname = 'Dex', HCP_Party_ID__pc = '12137', Dexcom_Rating__pc = '2-Lion' )};                                                     
        insert ls;
      
        Account mastercnt = [SELECT Id, Name, Dexcom_Rating__pc FROM Account WHERE HCP_Party_ID__pc  ='12125' LIMIT 1];
        Account Losecnt = [SELECT Id, Name, Dexcom_Rating__pc FROM Account WHERE HCP_Party_ID__pc    = '12126' LIMIT 1];
        List<Contact_Merge__c> Cntmerge = new List<Contact_Merge__c>{new Contact_Merge__c(Contact_Merge__c = Losecnt.Id, name = '12125')};
        Account mastercnt2 = [SELECT Id, Name, Dexcom_Rating__pc FROM Account WHERE HCP_Party_ID__pc  ='12131' LIMIT 1];
        Account Losecnt2 = [SELECT Id, Name, Dexcom_Rating__pc FROM Account WHERE HCP_Party_ID__pc    = '12132' LIMIT 1];
        List<Contact_Merge__c> Cntmerge2 = new List<Contact_Merge__c>{new Contact_Merge__c(Contact_Merge__c = Losecnt2.Id, name = '12131')};    
        List<Contact_Merge__c> Cntmerge3 = new List<Contact_Merge__c>{new Contact_Merge__c(Contact_Merge__c = Losecnt2.Id, name = '12132')};    
    
        try{
          Test.startTest();
          update mastercnt;
          insert Cntmerge;      
          update mastercnt2;
          insert Cntmerge2; 
          insert Cntmerge3;      
          System.assertEquals('12132',Cntmerge3[0].name); 
        }catch (Exception e) {
          System.debug('Contact merge failed: ' + e.getMessage());
          }
          Test.stopTest();
    }
}