/***********************************************************************************
Date : 7/6/2014
Author: Venkat Kollimarla (Dexcom)

Requirement: The existing opportunities missing the following field values when (auto) created in salesforce.

1. Medical Facility
2. Payor
3. Prescriber

The following batch program pick the above missing values from the account associated with the opportunity and fills in oportunity.

Instructions to run this program in Production are below:

Use Developer Console and Copy paste this code below;

String query = 'SELECT Id,Name,Payor__c,Medical_Facility__c,Prescriber__c,Account.Id,Account.Payor__r.Id,Account.Medical_Facility__r.Id,
Account.Prescriber__r.Id FROM Opportunity WHERE (IsClosed = FALSE AND ( Payor__c = null OR Medical_Facility__c = null OR Prescriber__c = null ))';
 
id bId = database.executeBatch(new MyBatchOpportunityUpdate(query));

************************************************************************************/

public class MyBatchOpportunityUpdate implements Database.Batchable<sObject>       

{            

    public final String QUERY;  //Making QUERY as CONSTANT
    List <Opportunity> oppList = new list<Opportunity>();      
    public MyBatchOpportunityUpdate(String q)            
      {              
         QUERY = q;   
      }            


    public Database.QueryLocator start(Database.BatchableContext BC)
            {               
        return Database.getQueryLocator(query); 
            }

  
    public void execute(Database.BatchableContext BC,List<sObject> scope) 
           {                 
               for(Sobject s : scope) 
                 {              

                Opportunity o = (Opportunity)s; 
                o.Payor__c = o.Account.Payor__r.Id;
                o.Medical_Facility__c = o.Account.Medical_Facility__r.Id;
                o.Prescriber__c = o.Account.Prescriber__r.Id;
                oppList.add(o);                  
                 }   

             Update oppList;

            }


            public void finish(Database.BatchableContext BC) 
            {  
            
            
                      
               AsyncApexJob a = [SELECT Id,Status,NumberOfErrors,JobItemsProcessed,TotalJobItems,CreatedBy.Email FROM AsyncApexJob WHERE Id =: BC.getJobId()];
                          
               // Send an email to the Apex job's submitter, notifying of job completion. 
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               String[] toAddresses = new String[] {a.CreatedBy.Email};
               mail.setToAddresses(toAddresses);
               mail.setSubject('Opportunity Update Status: ' + a.Status);
               mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
               Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       
           }//End of finish() method 
                        
                    

}