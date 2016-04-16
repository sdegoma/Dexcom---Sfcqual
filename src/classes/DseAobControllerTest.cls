/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DseAobControllerTest {
    @IsTest 
    public static void checkMySeviceIdTest() {
    	
		Test.setMock(HttpCalloutMock.class, new DseDocusignMockClass());
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint('http://demo.docusign.net');
     	req.setMethod('POST');
	    Http h = new Http();
	    HttpResponse res = h.send(req);
	    String contentType = res.getHeader('Content-Type');
	    System.assert(contentType == 'application/json');
	    String actualValue = res.getBody();
	    String expectedValue = '{"foo":"bar"}';
	    System.assertEquals(actualValue, expectedValue);
	    System.assertEquals(201,res.getStatusCode());
	    
	    //Create User and Profile
	    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
      	User u = new User(Alias = 'dseTest', Email='proServTestUser@docusign.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', 
        UserName='proServTestUser@docusign.com');       
      	insert u;

		system.debug('**** User inserted **** ' + u);    
	     
	    // Setup a Record Type
    	RecordType rt = [Select r.Id from RecordType r where r.Name='Consumers'];
    	rt = [Select r.Id from RecordType r where r.Name='Consumers'];
    	System.debug('*****RecordType: ' + rt);
	    System.assertNotEquals(null, rt);
	    
        // Set up the Account record.
    	Account a = new Account(FirstName='Test', LastName='Account',
    		 BillingState='WA', BillingPostalCode='1234',
    		BillingCity='Seattle');
    	a.BillingStreet = '1 street';
    	a.RecordTypeId = rt.Id;
    	a.Territory_Code__c = '01143';
    	a.PersonEmail = 'test@email.com';	
    	insert a;
	        
		// Verify that the initial state is as expected.
	   	a = [Select a.Name, a.Account_Status__c From Account a
	       	WHERE Id = :a.Id];
	    System.assertEquals(null, a.Account_Status__c);
	    System.debug('**** account = ' + a);
	    
	    Territory_Alignment__c t = new Territory_Alignment__c();
	    t.Name = '01143';
	    t.SA__c=u.Id;
	    insert t;
	    
	    t = [SELECT Id, Territory_Name__c FROM Territory_Alignment__c WHERE Id = :t.Id];
	    System.debug('**** Territory_Name__c is *** ' +  t.Territory_Name__c);
	    system.debug('**** Territory_Alignment__c inserted **** ' + t);
		 
		   
	    // Set up the Opportunity record.
	    String opportunityName = 'My Opportunity';
	    Opportunity o = new Opportunity(AccountId=a.Id, Name=opportunityName,
                                    StageName='1. New Opportunity', CloseDate=System.today());
        o.Status__c = '1.2 Online Opportunity';
	    // Cause the Trigger to execute.
	    insert o;
	    System.assertEquals(o.isClosed, false);
	    System.assertEquals(o.Status__c, '1.2 Online Opportunity');
	    System.assertEquals(o.StageName, '1. New Opportunity');
	    
	    System.debug('*** Opportunity inserted ' + o);
	    System.debug('*** o.Territory_Name__c ' + o.Territory_Name__c);
	    
		
	    
	    
	    //Select d.dsfs__UseSendOnBehalfOf__c, d.dsfs__DocuSignBaseURL__c, d.dsfs__DSProSFUsername__c, d.dsfs__DSProSFPassword__c, d.dsfs__AccountId__c From dsfs__DocuSignAccountConfiguration__c
	    
	    dsfs__DocuSignAccountConfiguration__c c = new dsfs__DocuSignAccountConfiguration__c();
	    c.dsfs__DSProSFUsername__c = 'foo@email.com';
		c.dsfs__DSProSFPassword__c = 'foo';
		c.dsfs__UseSendOnBehalfOf__c = true;
		c.dsfs__DocuSignBaseURL__c = 'https://demo.docusign.net';
		c.dsfs__AccountId__c = '12345';
	    insert c;
	    
	   	System.assertNotEquals(DseAobHelper.getDsAccountConfiguration(), null);
	    
	    
	    DseAobController.createEnvelopeFromOpportunity(o.Id);		    
		    
	    
	    
    }
}