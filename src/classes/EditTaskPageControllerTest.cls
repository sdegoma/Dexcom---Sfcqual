//EditTaskPageController
@isTest

public class EditTaskPageControllerTest{

Static testmethod void TestPositiveCase()

    {
    
    Id TaskRecordTypeID = [select Id from RecordType where (Name='Dexcom') and (SobjectType='Task')].Id;
    
            //Create Account
            Account ac = new Account (name='XYZ Organization');
            insert ac;

            //Create Opportunity
            Opportunity op = new Opportunity (name='test opportunity');
            op.AccountId = ac.Id;
            op.Type = 'New Users';
            op.StageName = 'Win';
            op.CloseDate = system.today();
            //op.OwnerId = '005f0000001MwMs';
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
            
           
           PageReference pageRef = Page.EditTaskPage;
           Test.setCurrentPageReference(pageRef);
           
           ApexPages.currentPage().getParameters().put('tskID',T.Id);
           ApexPages.currentPage().getParameters().put('OppID',op.Id);
           ApexPages.currentPage().getParameters().put('RecordType',T.RecordTypeId);
           ApexPages.currentPage().getParameters().put('tsk1',T.OwnerId);           
           
           ApexPages.StandardController sc = new ApexPages.standardController(T);                 
           EditTaskPageController ETP = new EditTaskPageController(sc);
           ETP.CustomSave();
           
           PageReference pageRef1 = Page.EditTaskPage;
           Test.setCurrentPageReference(pageRef1);
           ApexPages.currentPage().getParameters().put('OppID',op.Id);
           ApexPages.currentPage().getParameters().put('RecordType',T.RecordTypeId);
           ApexPages.currentPage().getParameters().put('tsk1',T.OwnerId); 
                      
           //ApexPages.currentPage().getParameters().put('tskID',NULL); //Pass tskID = NULL to TEST Else block of Controller            
           EditTaskPageController ETP1 = new EditTaskPageController(sc);
           
           
    }
    

}