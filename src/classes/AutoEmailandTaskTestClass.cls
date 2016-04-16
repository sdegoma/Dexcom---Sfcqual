/***************************************************************************
@Author: Venkat Kollimarla
This is to test the trigger AutoEmailandTask's code coverage.
@Method : TestPositiveCase
@Method : TestNegativeCase
******************************************************************************
Updated BY AP on 3/28/2016
****************************************************************************/
@isTest
public class AutoEmailandTaskTestClass{

Static testmethod void TestPositiveCase(){
    //Create an account of Person Account
    System.debug('Entered Psitive Test Case');
    Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;
    Account acct3 = new Account(RecordTypeId = personRecordTypeID, PersonEmail = 'venkat.dexcom@gmail.com', LastName = 'AutoEMailTest', Party_ID__c = '99991', Territory_Code__c = '1234');
    try{ Insert acct3; 
    System.debug('Account Created'); 
    //Create an account of Person Opportunity
    Opportunity Opp = new Opportunity();
    Opp.Name = 'AutoEMailOppty';
    Opp.AccountId = acct3.Id;
    Opp.CloseDate = Date.today();
    Opp.Type = 'NEW SYSTEM';
    Opp.StageName = '2.Verification';
     Opp.Status__c = '2.1C Eligibility Pending';
    
    insert Opp;
    System.debug('Oppty Created');
    
    Opportunity Oppt1= [select id,stagename,status__C from Opportunity where id = :Opp.id];
    
    Oppt1.StageName = '6. Quote Pending';
    Oppt1.Status__c =  '6.2 Insurance Quote Pending';
    Opportunity Oppt2= [select id,stagename,status__C from Opportunity where id = :Opp.id];
    Oppt2.Status__c =  '1.3 Pharmacy Check';
    Opportunity Oppt3= [select id,stagename,status__C from Opportunity where id = :Opp.id];
    Oppt3.Status__c =  '5.1 Auth Submitted to Payor - MCS';
        
    test.startTest();  
    update oppt1; 
    update Oppt2;  
    update Oppt3;    
    test.stopTest();    
    }

    catch (System.DmlException e) {
    for (Integer i = 0; i < e.getNumDml(); i++) {
        // Process exception here
        System.debug(e.getDmlMessage(i)); 
    }
}
}


// ****************************************************//
//For Negative Case

//*****************************************************//
/*
Static testmethod void TestNegativeCase()
{
    //Create an account of Person Account
    Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;
    test.starttest(); 

    Account acct4 = new Account(RecordTypeId = personRecordTypeID,LastName = 'AutoEMailTest', Party_ID__c = '99991', Territory_Code__c = '1234');
    Insert acct4; 
    
    //Create a contact using the above created account
    //contact con = new Contact();
    //con.LastName = 'Venkat-con-AutoEmail';
    //con.AccountId = acc1.Id;
    //con.Email = acc1.PersonEmail;
    //insert con;
    
    //Create an opportunity with 1 and 1.3 stage and status respectively
    
    Opportunity Opp = new Opportunity();
    Opp.Name = 'AutoEMailOppty';
    Opp.AccountId = acct4.Id;
    Opp.CloseDate = Date.today();
    Opp.Type = 'NEW SYSTEM';
    Opp.StageName = '1. New Opportunity';
    Opp.Status__c = '1.3 Pharmacy Check';
    
    insert Opp;
    
    //Now - update the above created oppty with stage and status as 6 , 6.6 respectively.
    Opportunity Acs= [select id,stagename,status__C from Opportunity where id = :Opp.id];
    Acs.StageName = '6. Quote Pending';
    Acs.Status__c = '6.6 Pending Pharmacy PO';
    test.startTest();
    update Acs;
    test.stopTest();    
    }
    
*/
}