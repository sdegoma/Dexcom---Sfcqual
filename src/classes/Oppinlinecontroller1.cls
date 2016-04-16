public with sharing class Oppinlinecontroller1 {

    public Oppinlinecontroller1(ApexPages.StandardController controller) {

            Task T = (Task)controller.getRecord();
            T.Type = 'Tracker';
            T.Status = 'Completed';
            T.ActivityDate = Date.today();
            T.WhatId = ApexPages.currentPage().getParameters().get('what_id'); 
            T.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); 
            T.OwnerId = ApexPages.currentPage().getParameters().get('tsk1');
            T.Distributor_To_See__c = 'Solara';
            T.Priority = 'Normal';
            
           

    }

}