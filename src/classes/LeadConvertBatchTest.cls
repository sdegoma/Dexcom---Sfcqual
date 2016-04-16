/*
	@Author				: Loven Reyes (CloudSherpas)
	@Date Created		: 16-JUL-2005
	@Description		: Test class for LeadConvertBatch.
*/

@isTest
private class LeadConvertBatchTest {
	
	//method to test batch lead conversion
	private static testMethod void testLeadBatch(){
		String query = 'SELECT Id, Status, hasAccount__c, Initial_Data_Load__c, isConverted FROM Lead WHERE isConverted = false AND Initial_Data_Load__c = false AND hasAccount__c = false AND Status = \'Qualified\'';

		//insert this to cover URLExpiryBatchJob
		URL_Expiry__c testurlE = TestDataBuilder.testURLExpiryVal();
        insert testurlE;  

        //insert list of Lead for batch test
		List<Lead> myLead = new List<Lead>();
		
		Lead myLead1 = new Lead(
			Firstname = 'TestLead1', Status = 'Open', isConverted=false, Initial_Data_Load__c = false, hasAccount__c = false, Email = 'Test@gmail.com', LastName = 'Test LastName'
		);

		Lead myLead2 = new Lead(
			Firstname = 'TestLead2', Status = 'Open', isConverted=false, Initial_Data_Load__c = false, hasAccount__c = false, Email = 'Test@gmail.com', LastName = 'Test LastName'
		);

		Lead myLead3 = new Lead(
			Firstname = 'TestLead3', Status = 'Open', isConverted=false, Initial_Data_Load__c = false, hasAccount__c = false, Email = 'Test@gmail.com', LastName = 'Test LastName'
		);

		Lead myLead4 = new Lead(
			Firstname = 'TestLead4', Status = 'Open', isConverted=false, Initial_Data_Load__c = false, hasAccount__c = false, Email = 'Test@gmail.com', LastName = 'Test LastName'
		);

		Lead myLead5 = new Lead(
			Firstname = 'TestLead5', Status = 'Open', isConverted=false, Initial_Data_Load__c = false, hasAccount__c = false, Email = 'Test@gmail.com', LastName = 'Test LastName'
		);

		Lead myLead6 = new Lead(
			Firstname = 'TestLead6', Status = 'Open', isConverted=false, Initial_Data_Load__c = false, hasAccount__c = false, Email = 'Test@gmail.com', LastName = 'Test LastName'
		);

		myLead.add(myLead1);
		myLead.add(myLead2);
		myLead.add(myLead3);
		myLead.add(myLead4);
		myLead.add(myLead5);
		myLead.add(myLead6);
		
		insert myLead;

		//update all lead status to 'Qualified' to covert the query
		myLead[0].Status = 'Qualified';
		update myLead[0];
		myLead[1].Status = 'Qualified';
		update myLead[1];
		myLead[2].Status = 'Qualified';
		update myLead[2];
		myLead[3].Status = 'Qualified';
		update myLead[3];
		myLead[4].Status = 'Qualified';
		update myLead[4];
		myLead[5].Status = 'Qualified';
		update myLead[5];

		//test the batch class
		Test.startTest();
			Database.executeBatch(new LeadConvertBatch());
		Test.stopTest();

		//assert if the status changes/updated
		System.assertNotEquals(myLead[0].Status,'Open');
	}
}