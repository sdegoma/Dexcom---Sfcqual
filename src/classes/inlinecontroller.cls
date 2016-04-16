public with sharing class inlinecontroller {
   
Public contact conRec { get;set; }
Public List<Opportunity> opplist { get;set; }
Public id conRecId;


    public inlinecontroller(ApexPages.StandardController controller) 
    { 
         conRecId = [select id from contact where id =: ApexPages.currentPage().getParameters().get('id')].id;     
         opplist  = [select id,Name,StageName,Status__c,CloseDate,AccountId,Account.Name,Payor__r.Name,Payor__r.Id from Opportunity where Prescriber__c = : conRecId and IsClosed = FALSE];
    }
    
}