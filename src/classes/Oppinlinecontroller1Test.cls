//Oppinlinecontroller1
@isTest

public class Oppinlinecontroller1Test{


Static testmethod void TestPositiveCase()
    {
    
    Id TaskRecordTypeID = [select Id from RecordType where (Name='Dexcom') and (SobjectType='Task')].Id;
    
            PageReference pageRef = Page.Distributor_Custom_Task_Page;           
            Test.setCurrentPageReference(pageRef);

            //Create Account
            Account ac = new Account (name='XYZ Organization');
            insert ac;

            //Create Opportunity
            Opportunity op = new Opportunity (name='test opportunity');
            op.AccountId = ac.Id;
            op.Type = 'New Users';
            op.StageName = 'Win';
            op.CloseDate = system.today();
            insert op;
            
            //create a contact
            Contact c = new Contact(LastName ='xyz',AccountId=ac.Id);
            insert c;
            
            //Create a Task
            Task T = new Task();
            T.Type = 'TEST';
            T.RecordTypeId = TaskRecordTypeID;
            T.WhatId = op.Id;
            //T.OwnerId = '005f0000001MwMs';
            T.ActivityDate = Date.today();
            T.Subject = 'Test Babu';
            T.Description = 'Just to TEST';
            T.Status = 'Completed';
            T.Priority = 'Normal';  
            T.WhatId = op.Id;
            T.Distributor_To_See__c = 'Solara';          
            insert T;
           
           ApexPages.currentPage().getParameters().put('id', T.Id);
           ApexPages.StandardController sc = new ApexPages.standardController(T);
           
           ApexPages.currentPage().getParameters().put('what_id',op.Id);
           ApexPages.currentPage().getParameters().put('tsk1',T.OwnerId);
           ApexPages.currentPage().getParameters().put('RecordType',T.RecordTypeId);
           
           Oppinlinecontroller1 ic = new Oppinlinecontroller1(sc);
    }
    
    
}