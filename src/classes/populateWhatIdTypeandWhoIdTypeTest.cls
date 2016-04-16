@isTest

private class populateWhatIdTypeandWhoIdTypeTest{
/*    
static testMethod void runPositiveTestCases()
{
Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;

test.starttest(); 

Account acc1 = new Account(RecordTypeId = personRecordTypeID, LastName = 'test1: task', Party_ID__c = '99991');
Insert acc1; 

Account ac=[select PersonContactId from account where id=: acc1.id];

CDE__c cde = new CDE__c();
cde.Name = 'Venkat-CDE';
cde.Last_Name__c = 'LastName: Venkat CDE Insert Test';
cde.First_Name__c = 'FirstName: Venkat CDE Insert Test';
insert cde;

Task tsk1 = new Task(Type ='Call', WhoID = ac.PersonContactId, WhatID = cde.Id, ActivityDate = date.today(), Subject = 'Testtaskmethod1');
//Insert tsk1; 

test.stoptest();
} // End of method


//**********************      Test Methoid for WHOIDType__c     ***************************

static testMethod void runWhoIDType()
{

Id accountRecordTypeID=[ select Id from RecordType where (Name='Medical Facility') and (SobjectType='Account')].Id;

Account acc1 = new Account(RecordTypeId = accountRecordTypeID, Name = 'test1: task', Party_ID__c = '99991');
Insert acc1; 

test.starttest(); 

contact con = new Contact();
con.LastName = 'Venkat-con';
con.AccountId = acc1.Id;
insert con;

Task tsk12 = new Task(Type ='Call', WhoId = con.Id, ActivityDate = date.today(), Subject = 'Testtaskmethod1');
//Insert tsk12;

Task tsk1 = new Task(Type ='Call', WhatID = acc1.Id, ActivityDate = date.today(), Subject = 'Testtaskmethod1');
//Insert tsk1; 

test.stoptest(); 

}   // End of method

// Test method to make WhoID null on WhatID is CDE
static testMethod void makeWhoIDnullon_WhatIDCDE()
{

Id personRecordTypeID=[select Id from RecordType where (Name='Consumers') and (SobjectType='Account')].Id;

Account acc1 = new Account(RecordTypeId = personRecordTypeID, LastName = 'test1: task', Party_ID__c = '99991');
Insert acc1; 

Account ac=[select PersonContactId from account where id=: acc1.id];
    
Task tsk1 = new Task(Type ='Call',WhoID=ac.PersonContactId,ActivityDate = date.today(), Subject = 'Testtaskmethod1',WhatIDType__c = 'CDE',WhoIDType__c = 'Venkat');
//Insert tsk1;     
    
} 
*/
}