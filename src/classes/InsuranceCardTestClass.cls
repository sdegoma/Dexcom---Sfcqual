/**********************************
*This is a test class for insurancecard TRIGGER 
*
*
**********************************/
@isTest
public class InsuranceCardTestClass
{
/*
     static testMethod void runPrimaryBenefit()
    {
    
    
    Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;

    Account acc1 = new Account(RecordTypeId = personRecordTypeID, LastName = 'test1: task', Party_ID__c = '99991', Territory_Code__c = '1234');
    Insert acc1; 

    Opportunity opp1 = new Opportunity(CloseDate=date.today(),Name = 'Test Opp',AccountId = acc1.Id,StageName='0. Lead',Status__c = '0.1 New Lead',Type='NEW SYSTEM');
    Insert opp1;

    Id BenRecordTypeID =[select Id from RecordType where (Name='Insurance Card') and (SobjectType='Benefits__c')].Id;
    
    Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
    Account acc = TestDataBuilder.getAccountList(1, recId)[0];
        insert acc;
        
    Benefits__c b = new Benefits__c();
    
    b.Account__c = acc1.Id;
    b.MEMBER_ID__c = '1234567890';
    b.Employer_Group__c = '1259';
    b.Customer_Service_Phone__c = '9849015773';
    b.Claims_Mailing_Address__c = 'Hello This is TEST Address- Go to Work!!!';
    b.Policy_Holder_Name__c = 'Venkat';
    b.Policy_Holder_Date_of_Birth__c = date.today();
    b.RELATIONSHIP_TO_PATIENT__c = 'Test';
    b.Plan_Name__c = 'Test Name';
    b.Plan_Type__c = 'Test Plan';
    b.Relationship_Code__c = 'Primary';   
    b.RecordTypeId = BenRecordTypeID;
    b.Payor__c = acc.Id;
    
    insert b;
    
    }
    
    
    static testMethod void runSecondaryBenefit()
    {
    
    Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;

    Account acc1 = new Account(RecordTypeId = personRecordTypeID, LastName = 'test1: task', Party_ID__c = '99991', Territory_Code__c = '1234');
    Insert acc1; 

    Opportunity opp1 = new Opportunity(CloseDate=date.today(),Name = 'Test Opp',AccountId = acc1.Id,StageName='0. Lead',Status__c = '0.1 New Lead',Type='NEW SYSTEM');
    Insert opp1;
    
    Id BenRecordTypeID =[select Id from RecordType where (Name='Insurance Card') and (SobjectType='Benefits__c')].Id;
    
    Id recId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payor').getRecordTypeId();
    Account acc = TestDataBuilder.getAccountList(1, recId)[0];
        insert acc;
                
    Benefits__c b = new Benefits__c();
    
    b.MEMBER_ID__c = '1234567891259';
    b.Employer_Group__c = '1259';
    b.Customer_Service_Phone__c = '9849011259';
    b.Claims_Mailing_Address__c = 'Hello This is TEST Address- Go to Work!!!';
    b.Policy_Holder_Name__c = 'Venkat k';
    b.Policy_Holder_Date_of_Birth__c = date.today();
    b.RELATIONSHIP_TO_PATIENT__c = 'Test';
    b.Plan_Name__c = 'Test Name';
    b.Plan_Type__c = 'Test Plan';
    b.Relationship_Code__c = 'Secondary';
    b.Account__c = acc1.Id;
    b.RecordTypeId = BenRecordTypeID;
    b.Payor__c = acc.Id;
    
    insert b;
    
    }

*/
}