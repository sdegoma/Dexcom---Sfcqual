/****************************************************************************************************************************
@Process Owner: Alex Booras
@Author : Venkat Kollimarla

Description:

    This class will provide the functionality to send an email using the email templete required and to create a task on Opportunity in either of cases SUCCESS
    OR FAILURE. 
    
    This is used by the trigger : AutoEmailandTask;
    The customer need to be notified by an EMAIL on the change of STATUS on Opportunity from 1.3 Pharmacy Check TO 6.6 Pending Pharmacy PO    
    The customer is the PersonAccount associated with the Opportunity record.
    Hence, the program fetches the PersonEmail and check for status change then send email and creates task accordingly.

*****************************************************************************************************************************/
    public class AutoEmailHelper{

    public static final Id DEXCOMRecordTypeID = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Dexcom').getRecordTypeId();
    public static boolean firstRun = true; 
    
    //  -------------------------------------------------------------------------
    //  HELPER method: sendTemplatedEmail
    //  -------------------------------------------------------------------------
    
            public static void sendTemplatedEmail(id OWDAddress,id targetID,id OppID,Id templateId)      
                {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();                
                        email.setOrgWideEmailAddressId(OWDAddress);
                        email.setTargetObjectId(targetID);      
                        email.setTemplateId(templateId);
                        email.setSaveAsActivity(false);
                        email.setWhatId(OppID);
                                
                        try{ Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  }        
                        catch (EmailException e) { System.debug('@@@@@ Email Exception From Class' + e.getMessage()); }
        
                }//End of sendEmail method()

    //  -----------------------------------------------------------
    //  HELPER Method: createTaskonOpportunity()
    //  -----------------------------------------------------------

            public static void createTaskonOpportunity(String taskSubject,String taskComments,id OppID,id OppOwnerId)
                {           
                        Task emailTask = new Task();        
                                emailTask.RecordTypeId = DEXCOMRecordTypeID;
                                emailTask.OwnerId      = OppOwnerId; 
                                emailTask.WhatId       = OppID;
                                emailTask.Type         = 'Other';
                                emailTask.ActivityDate = Date.today();
                                emailTask.Subject      = taskSubject;
                                emailTask.Status       = 'Completed';
                                emailTask.Priority     = 'Normal';
                                emailTask.Description  = taskComments; 

                                try {   insert emailTask;    }
                                catch(System.DMLException e) { System.debug(e.getMessage()); }
                } //End of task creation method
 
} //End of Class