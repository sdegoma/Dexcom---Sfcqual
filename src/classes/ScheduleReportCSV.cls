/********************************************************************************
@author Abhishek Parghi
@date 3/30/2016
@description: Apex class to schedule report in csv format.
********************************************************************************/
global class ScheduleReportCSV implements System.Schedulable {
    global void execute(SchedulableContext sc) {
     	List<Report__c> exportList = new List<Report__c>{}; 
        Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
        Date d = Date.today();
        Date firstDate = d.toStartOfMonth();
        Date lastDay = firstDate.addDays(Date.daysInMonth(d.year(), d.month())-1);
        
        system.debug('First Day: ' + firstDate);
        system.debug('Last Day: ' + lastDay);
            
        exportList = [Select Id, Name, Report_ID__c, Attachment__c, Email_Subject__c, Email__c, Email_Recipients__c, Frequency__c, WeeklyDays__c, Monthly_Day__c from report__C];
        
        for(Report__c e : exportList){
            //Determine if Report record is scheduled to run today.
            Boolean process = Test.isRunningTest() ? true : false;
            
            //Test for Weekly frequency.
            process = e.Frequency__c == 'Weekly' && e.WeeklyDays__c.contains(dt.format('EEEE')) ? true : process;
            
        	//Test for Monthly frequency.
        	process = e.Frequency__c == 'Monthly' && (e.Monthly_Day__c == String.valueOf(d.day()) || e.Monthly_Day__c == 'last' && d == lastDay || lastDay.day() <= Integer.valueOf(e.Monthly_Day__c)) ? true : process;
                       
            //Run process if scheduled.
            if(process){
                System.debug('Starting message processing for: ' + e.Name);
                ApexPages.PageReference report = new ApexPages.PageReference('/' + e.Report_ID__c + '?csv=1');
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName(e.Attachment__c);
                Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : report.getContent();
                attachment.setBody(content);
                attachment.setContentType('text/csv');
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
                message.setSubject(e.Email_Subject__c);
                message.setPlainTextBody(e.Email__c);
                String[] emailRecipients = e.Email_Recipients__c.split(',');
                message.setToAddresses(emailRecipients);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
                System.debug('Completed message processing for: ' + e.Name);
            }
        }
    }
}