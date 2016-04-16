public with sharing class Oppinlinecontroller {
   
Public List<Task> taskList { get;set; }
Public id OppRecId {get; set;}
public List<contact> conIDList;
public Id ConRecId {get;set;}


public List<Opportunity> OppRecords {get;set;}

    public Oppinlinecontroller(ApexPages.StandardController controller) 
    { 
         OppRecords = [select id,AccountId from Opportunity where id =: ApexPages.currentPage().getParameters().get('id')];  
         OppRecId = OppRecords[0].id;  
         conIDList = [select id from Contact where AccountId =: OppRecords[0].AccountId]; 
         ConRecId = conIdList[0].Id; 
         taskList = [SELECT id,Distributor_To_See__c,CreatedDate,CreatedById,Subject FROM Task WHERE WhatId = : OppRecId AND Distributor_To_See__c=: 'Solara' ORDER BY CreatedDate DESC ];
        
    }
    
}