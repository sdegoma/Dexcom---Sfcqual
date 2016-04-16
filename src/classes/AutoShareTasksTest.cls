@isTest(SeeAllData=true ) 

public class AutoShareTasksTest
{
/*
    static testMethod void  FindDSCOpptyTest()
    {
    
    Id networkId = ConnectionHelper.getConnectionId('Diabetes Specialty Center');
    
    //Create Account
    Account acc = new Account();
    acc.name = 'TEST AC';
    insert acc;
    
    //Create an opportunity
    Opportunity opp = new Opportunity();
    opp.name = 'TEST OPP';
    opp.StageName = 'something';
    opp.accountId = acc.Id;
    opp.CloseDate= Date.today();
    opp.Type = 'NEW SYSTEM';
    insert opp;

     List<PartnerNetworkRecordConnection> recordConns = new List<PartnerNetworkRecordConnection>();
     recordConns = [select Id, Status, ConnectionId, LocalRecordId from PartnerNetworkRecordConnection where LocalRecordId =: opp.Id ];   
    
    List<PartnerNetworkConnection> connMap = new List<PartnerNetworkConnection>([SELECT Id,ConnectionStatus, ConnectionName,CreatedDate, PrimaryContactId, ResponseDate 
        FROM PartnerNetworkConnection WHERE ConnectionStatus = 'Accepted' and ConnectionName = 'Diabetes Specialty Center']); 

    List<PartnerNetworkRecordConnection> lstShareRecords= new List<PartnerNetworkRecordConnection>(); 

    for(PartnerNetworkConnection network : connMap) 
    { 

        PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
        newrecord.ConnectionId = network.Id; 
        newrecord.LocalRecordId = opp.Id; 
        newrecord.SendClosedTasks = true; 
        newrecord.SendOpenTasks = true; 
        newrecord.SendEmails = false; 

        lstShareRecords.add(newrecord); 
     } 

    
    //insert lstshareRecords; 

}


static testMethod void  AutoShareTasksTest()
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
            
            insert op;
            
            //create a contact
            Contact c = new Contact(LastName ='xyz',AccountId=ac.Id);
            insert c;
            
            
            //Create a Task
            Task T = new Task();
            T.Type = 'TEST';
            T.RecordTypeId = TaskRecordTypeID;
            T.WhatId = op.Id;
            T.ActivityDate = Date.today();
            T.Subject = 'Test Babu';
            T.Description = 'Just to TEST';
            T.Status = 'Completed';
            T.Priority = 'Normal';  
            T.WhatId = op.Id;
            T.Distributor_To_See__c = 'DSC';  

            insert T;
            
            
            
    }
  */  
}