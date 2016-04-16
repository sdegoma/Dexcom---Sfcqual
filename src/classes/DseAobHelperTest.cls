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
private class DseAobHelperTest {

    static testMethod void getAccountByOpportunityIdTest() {
    	
    	// Setup a Record Type
    	RecordType rt = [Select r.Id from RecordType r where r.Name='Consumers'];
    	rt = [Select r.Id from RecordType r where r.Name='Consumers'];
    	System.debug('*****RecordType: ' + rt);
	    System.assertNotEquals(null, rt);
	    
        // Set up the Account record.
    	Account a = new Account(FirstName='Test', LastName='Account',
    		 BillingState='WA', BillingPostalCode='1234',
    		BillingCity='Seattle', Territory_Code__c = '1234');
    	a.BillingStreet = '1 street';
    	a.RecordTypeId = rt.Id;	
    	a.PersonEmail = 'test@email.com';
    	insert a;
        
		// Verify that the initial state is as expected.
   		a = [Select a.PersonEmail, a.Name, a.Account_Status__c From Account a
         	WHERE Id = :a.Id];
	    System.assertEquals(null, a.Account_Status__c);
	    System.assertEquals(a.PersonEmail,'test@email.com');
	    System.debug('****a.PersonEmail = ' + a.PersonEmail);
	    
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
 		System.assertEquals(DseAobHelper.getAccountByOpportunityId(o.Id).BillingState, 'WA');
 		System.assertEquals(DseAobHelper.getAccountByOpportunityId('-1'), null);
    }
    
    static testMethod void getDsAccountConfigurationTest() {
    	dsfs__DocuSignAccountConfiguration__c c = new dsfs__DocuSignAccountConfiguration__c();
    	c.dsfs__DSProSFUsername__c = 'foo@email.com';
    	c.dsfs__DSProSFPassword__c = 'foo';
    	c.dsfs__UseSendOnBehalfOf__c = true;
    	c.dsfs__DocuSignBaseURL__c = 'https://demo.docusign.net';
    	c.dsfs__AccountId__c = '12345';
    	
    	insert c;
    	dsfs__DocuSignAccountConfiguration__c dsConf = DseAobHelper.getDsAccountConfiguration();
    	System.assertNotEquals(dsConf, null);
    	System.assertEquals(c.dsfs__DSProSFUsername__c,'foo@email.com', 'Wrong dsfs__DSProSFUsername__c');
    	System.assertEquals(c.dsfs__DSProSFPassword__c,'foo', 'Wrong dsfs__DSProSFPassword__c');
    	System.assertEquals(c.dsfs__UseSendOnBehalfOf__c, true, 'Wrong dsfs__UseSendOnBehalfOf__c');
    	System.assertEquals(c.dsfs__DocuSignBaseURL__c, 'https://demo.docusign.net', 'Wrong dsfs__DocuSignBaseURL__c');
    	System.assertEquals(c.dsfs__AccountId__c, '12345', 'Wrong dsfs__AccountId__c');
    	
    }
    
    static testMethod void getUserByTerritoryIdTest() {
    	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
      	User u = new User(Alias = 'dseTest', Email='proServTestUser@docusign.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', 
        UserName='proServTestUser@docusign.com');       
      	insert u;

			
		system.debug('**** User inserted **** ' + u);
		
	    Territory_Alignment__c t = new Territory_Alignment__c();
	    t.Name = '01143';
	    t.SA__c=u.Id;
	    insert t;
	    
	    u = DseAobHelper.getUserByTerritoryId('01143');
	    System.debug('user is ' + u);
	    System.assertNotEquals(u, null);
	    
    }
    
    static testMethod void CreateDocuSignAuthenticationTest(){
    	 dsfs__DocuSignAccountConfiguration__c c = new dsfs__DocuSignAccountConfiguration__c();
	    c.dsfs__DSProSFUsername__c = 'foo@email.com';
		c.dsfs__DSProSFPassword__c = 'foo';
		c.dsfs__UseSendOnBehalfOf__c = true;
		c.dsfs__DocuSignBaseURL__c = 'https://demo.docusign.net';
		c.dsfs__AccountId__c = '12345';
	    insert c;
	    
	    
	    System.assertNotEquals(DseAobHelper.CreateDocuSignAuthentication('test', 'key'), null);
	    
    }
    
}