/*
	@Author				: Loven Reyes (CloudSherpas)
	@Date Created		: 16-JUL-2005
	@Description		: Test class for LeadConvertSchedulable.
*/

@isTest
private class LeadConvertSchedulableTest {
	
	//method to test the scheduled batch
	private static testMethod void testSchedule(){
		LeadConvertSchedulable.scheduleMe();
		Test.startTest();
			String sched = '0 30 * * * ?'; //runs once every hour
			LeadConvertSchedulable lcs = new LeadConvertSchedulable();
			System.schedule('Lead Batch Job', sched, lcs);
		Test.stopTest();
	}
}