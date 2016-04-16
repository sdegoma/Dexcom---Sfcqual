public with sharing class EditTaskPageController
{
    public Task T{get;set;}
    public id TID = ApexPages.currentPage().getParameters().get('tskID');
    List<Task> tasks = new List<Task>();
    
    public EditTaskPageController(ApexPages.StandardController controller)
    {    
        If(TID!=NULL)
            tasks = [SELECT ID,Subject,Description,OwnerId FROM Task WHERE Id=: TID];
        T = (Task)controller.getRecord();
     if(tasks.size()>0)
     {
            T.Subject = tasks[0].Subject;
            T.Description = tasks[0].Description;          
            
     } 

     else{
     
            T.Type = 'Tracker';
            T.Status = 'Completed';
            T.ActivityDate = Date.today();
            T.WhatId = ApexPages.currentPage().getParameters().get('OppID');
            T.RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); 
            T.OwnerId = ApexPages.currentPage().getParameters().get('tsk1'); 
            T.Distributor_To_See__c = 'Solara';
            T.Priority = 'Normal';
     }
     T.WhatId = ApexPages.currentPage().getParameters().get('OppID');
   }
        
    Public PageReference CustomSave()
    {
    TID = ApexPages.currentPage().getParameters().get('tskID');
    If(TID!=NULL){
          T.Id = TID;
          update T;
         }
    else{
            insert T;
         }
    PageReference pageref = new PageReference('/'+T.WhatId);
    Pageref.setRedirect(true);
    return Pageref;
    } 
}