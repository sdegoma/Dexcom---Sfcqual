/***********************************************************************************
Date : 10/17/2014
Author: Venkat Kollimarla (Dexcom)

Requirement: The existing Benefits need to be updated for Test_Update_TrashField__c.

The following batch program pick the above missing values from the account associated with the Benefits__c and fills in Benefits__c.

Instructions to run this program in Production are below:

Use Developer Console and Copy paste this code below;

String query = 'SELECT Id,Test_Update_TrashField__c FROM Benefits__c;
 
id bId = database.executeBatch(new AllBenefitsUpdate(query));

************************************************************************************/

public class AllBenefitsUpdate implements Database.Batchable<sObject>       

{            

    public final String QUERY;  //Making QUERY as CONSTANT
    List <Benefits__c> benefitsList = new list<Benefits__c>();
    
    public AllBenefitsUpdate(String q)            
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
                        Benefits__c b = (Benefits__c)s; 
                        //b.Test_Update_TrashField__c = 'Testing Trigger';
                        
                        benefitsList.add(b);                    
                 }   

             Update benefitsList;

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