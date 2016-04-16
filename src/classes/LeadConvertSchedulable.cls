/*
	@Author				: Loven Reyes (CloudSherpas)
	@Date Created		: 16-JUL-2005
	@Description		: Class for LeadConvertSchedulable.
*/

global class LeadConvertSchedulable implements Schedulable {
	public static String sched = '0 30 * * * ?'; // sec min hr day mon dweek year

	//method to schedule a batch conversion
	global static String scheduleMe() {
        LeadConvertSchedulable leadSchedule = new LeadConvertSchedulable(); 
        return System.schedule('Dexcom Lead Batch Job', sched, leadSchedule);
    }

    //method to call the batch class
	global void execute(SchedulableContext sc) {
		//MyBatchClass b = new MyBatchClass();
		//database.executebatch(b);
		LeadConvertBatch leadBatch = new LeadConvertBatch();
		Id batchprocessid = database.executebatch(leadBatch,100);
	}
}