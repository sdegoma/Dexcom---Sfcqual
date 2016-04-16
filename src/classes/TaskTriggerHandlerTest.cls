@istest
public class TaskTriggerHandlerTest {
/********************************************************************************
@author Abhishek Parghi
@date 1/29/2016
@description: Test class for TaskTriggerHandler.
*******************************************************************************/
    Static testmethod void TaskTriggerHandler_Test(){ 
 
       Id personRecordTypeID=[select Id from RecordType where (Name='Prescriber') and (SobjectType='Account')].Id;
        List<Account> acc = new List<Account>{new Account(
        RecordTypeId = personRecordTypeID,
        FirstName = 'APTestfirstname',
        LastName = 'APTestlastname',
        Middle_Name__c = 'Test',
        PersonEmail = 'APTestAP@gmail.com',
        Phone = 'Call: 1234567890012345678900',
        BillingState = 'APTest State',
        BillingCity = 'APTest City',
        BillingStreet = 'APTest Street',
        ShippingPostalCode =  '95112',
        BillingCountry = 'United States',
        Prescriber__c = null,
        IMS_ID__pc = '109',
        Party_ID__c = '111',
        CCV_ID__c = '222'  )}; 
        insert Acc;
        
        List<Task> T = new List<Task>{ new Task(WhatID = Acc[0].id)};
 
        Insert t;
        List<task> taskstoupdate = New List<task>{ [select id from task where id in :t]};
        for(task tOK:taskstoupdate)
           tOK.Party_ID__c = 'Completed';
           Update taskstoupdate;
        Account[] Acs = [select id,Party_ID__c,FirstName from Account where id in :Acc];
        System.assertEquals('APTestfirstname',Acs[0].firstname);

    }  
}