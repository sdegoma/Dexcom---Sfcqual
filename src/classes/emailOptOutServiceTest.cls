/**********************************************************
 **Description:  Test Class for the emailOptOUtService Class
 **Author:       CLOUD SHERPAS, August Del Rosario
 **Date Created: JUN.16.2015
**********************************************************/
@isTest
private class emailOptOutServiceTest {
    /**********************************************************
     **Description: Test Method if subject contains unsubscribe
     **Parameters:  None
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.30.2015
    **********************************************************/
	static testMethod void testUnsubscribe() {
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
		
		URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE; 

		Lead_Scoring__c testLs = TestDataBuilder.testLeadScoringVal();
		insert testLs;

		Lead testLead = TestDataBuilder.testLead();
		testLead.HasOptedOutOfEmail = false;
		Insert testLead;

		Contact testContact = TestDataBuilder.TestContact();
		testContact.HasOptedOutOfEmail = false;
		insert testContact;

		email.subject = 'test unsubscribe test';
   		envelope.fromAddress = 'Test@gmail.com';

   		emailOptOutService eoos = new emailOptOutService();
   		eoos.handleInboundEmail(email, envelope);

   		List<Contact> assertTestContact = [SELECT Id,HasOptedOutOfEmail FROM Contact];
   		system.assertEquals(false,assertTestContact[0].HasOptedOutOfEmail);
	}
}