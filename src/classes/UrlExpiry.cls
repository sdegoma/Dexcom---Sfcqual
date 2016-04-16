/**********************************************************
 **Description: url Expiry Class. calls the url expiry batch class for it to be scheduled
 **Author:      Louis Augusto Del Rosario, CLOUD SHERPAS
 **Date Created:    JUN.25.2015
**********************************************************/
global class UrlExpiry implements Schedulable {
	global void execute(SchedulableContext sc) {
		//instantiate UrlExpiryBatchJob to be executed
		UrlExpiryBatchJob urlE = new UrlExpiryBatchJob();
		database.executebatch(urlE,10);
	}
}