/**********************************************************
 **Description:  Process the contents, headers, and attachments of inbound email and update opt out flag.
 **Author:       CLOUD SHERPAS, August Del Rosario, sobryan
 **Date Created: JUN.16.2015
**********************************************************/
global class emailOptOutService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        
        // Create an inboundEmailResult object for returning the result of the Apex Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        //get From, Subject, and Body as text
        String eFrom    = email.fromAddress;
        String eSubject = email.subject;
        String eBody    = email.plainTextBody;
        
        List<Lead> listLead = new List <lead>();

        //check if subject contains "unsubscribe"
        String mySubject = email.subject.toLowerCase();
        String s = 'unsubscribe';
        Boolean unsubMe;
        unsubMe = mySubject.contains(s);

        //if (unsubMe == true){  //no longer require subject to contain unsubscribe", just do it
            try {
                // Look up all leads matching the email address.
                for (Lead l : [SELECT Id, Name, Email, HasOptedOutOfEmail
                         FROM Lead
                         WHERE Email = :envelope.fromAddress
                         AND isConverted = false
                         AND hasOptedOutOfEmail = false
                         LIMIT 100]) {
                    // Add all the leads to the list.       
                    l.hasOptedOutOfEmail = true;
                    listLead.add(l);
                       
                    System.debug('Lead Object: ' + l);   
                } 
                // Update all lead records in the query.
                update listLead;
            }
            
            catch (System.QueryException e) {
                System.debug('Lead Query Issue: ' + e);
            }
        //}

        //Populating result.message causes an email response to be sent to the sender (from noreply@salesforce.com)
        //result.message = 'Thanks for sending an email to sobdev';
        //True will confirm it is complete and no bounced email should be send the sender of the unsubscribe request.
        result.success = true;
        return result;
    }
}