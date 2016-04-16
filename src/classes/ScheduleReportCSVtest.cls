/********************************************************************************
@author Abhishek Parghi
@date 3/30/2016
@description: Test Class for ScheduleReportCSV.
********************************************************************************/	
@isTest
private class ScheduleReportCSVtest  {
	 
	   public static String CRON_EXP = '0 0 0 15 3 ? 2022';
	   static testmethod void test() {
          Report__c e	= new Report__c();
  			e.Name = 'Test Exporter Record';
            e.Report_ID__c = '00O3300000492wQ';
            e.Attachment__c = 'Test Attachment Name';
            e.Email_Subject__c = 'Test Email Subject';
            e.Email__c = 'Test Email Body';
            e.Email_Recipients__c = 'abc@abc.com';
          Insert(e);
     
	      Test.startTest();
	      // Schedule the test job
	      String jobId = System.schedule('ScheduleReportCSVT',CRON_EXP,new ScheduleReportCSV());
	      // Get the information from the API object
	      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
	      // Verify the expressions are the same
	      System.assertEquals(CRON_EXP,
	         ct.CronExpression);
	      // Verify the job has not run
	      System.assertEquals(0, ct.TimesTriggered);
	      // Verify the next time the job will run
	      System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));
	      Test.stopTest();
	   }
	}