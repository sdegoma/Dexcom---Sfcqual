@isTest
private class TerritoryTargetingControllerTestMVN {
	
	@isTest static void testController() {
		Territory_Targeting_Metrics_MVN__c metric = new Territory_Targeting_Metrics_MVN__c();

		insert metric;

		List<Territory_Targets__c> targets = new List<Territory_Targets__c>();

		targets.add(TerritoryTargetingControllerTestMVN.createTarget(metric, ''));
		targets.add(TerritoryTargetingControllerTestMVN.createTarget(metric, 'A-3'));
		targets.add(TerritoryTargetingControllerTestMVN.createTarget(metric, 'B-2'));
		targets.add(TerritoryTargetingControllerTestMVN.createTarget(metric, 'C-1'));
		targets.add(TerritoryTargetingControllerTestMVN.createTarget(metric, 'D-0'));
		targets.add(TerritoryTargetingControllerTestMVN.createTarget(metric, ''));
		targets.add(TerritoryTargetingControllerTestMVN.createTarget(metric, ''));
		targets.add(TerritoryTargetingControllerTestMVN.createTarget(metric, ''));
		targets.add(TerritoryTargetingControllerTestMVN.createTarget(metric, ''));

		PageReference pageRef = Page.TerritoryTargetingMVN;
		Test.setCurrentPage(pageRef);

		ApexPages.currentPage().getParameters().put('id', metric.id);

		ApexPages.StandardController stdMetric = new ApexPages.StandardController(metric);

		TerritoryTargetingControllerMVN controller = new TerritoryTargetingControllerMVN(stdMetric);

		String nextPage = controller.submitTargets().getUrl();

		System.assertEquals('/' + metric.Id, nextPage);
		System.assertEquals(1, controller.metric.A_Starting_Tier_Count__c);
		System.assertEquals(1, controller.metric.B_Starting_Tier_Count__c);
		System.assertEquals(1, controller.metric.C_Starting_Tier_Count__c);
		System.assertEquals(1, controller.metric.D_Starting_Tier_Count__c);
		System.assertEquals(0, controller.metric.Calls_Per_Month_Targets__c);

		Integer index = 1;

		for(Territory_Targets__c target : controller.targets){
			if(target.Suggested_Tier__c == 'A-3'){
				target.Selected_Tier__c = '';
			} else if(target.Suggested_Tier__c == 'B-2'){
				target.Selected_Tier__c = 'B-2';
			} else if(target.Suggested_Tier__c == 'C-1'){
				target.Selected_Tier__c = 'C-1';
			} else if(target.Suggested_Tier__c == 'D-0'){
				target.Selected_Tier__c = '';
			} else if(target.Suggested_Tier__c == null && index == 1){
				target.Selected_Tier__c = 'A-3';
				index++;
			} else if(target.Suggested_Tier__c == null && index == 2){
				target.Selected_Tier__c = 'A-3';
				index++;
			} else if(target.Suggested_Tier__c == null && index == 3){
				target.Selected_Tier__c = 'B-2';
				index++;
			} else if(target.Suggested_Tier__c == null && index == 4){
				target.Selected_Tier__c = 'C-1';
				index++;
			} else if(target.Suggested_Tier__c == null && index == 5){
				target.Selected_Tier__c = 'D-0';
				index++;
			}
			System.debug(target);
		}		

		controller.getIsAdmin();

		controller.submitTargets();

		controller = new TerritoryTargetingControllerMVN(stdMetric);

		System.assertEquals(1, controller.metric.A_Deselected__c);
		System.assertEquals(2, controller.metric.A_Selected__c);

		System.assertEquals(0, controller.metric.B_Deselected__c);
		System.assertEquals(1, controller.metric.B_Selected__c);
		System.assertEquals(0, controller.metric.C_Deselected__c);
		System.assertEquals(1, controller.metric.C_Selected__c);
		System.assertEquals(1, controller.metric.D_Deselected__c);
		System.assertEquals(1, controller.metric.D_Selected__c);

		System.assertEquals(12, controller.metric.Calls_Per_Month_Targets__c);
	}

	static Territory_Targets__c createTarget(Territory_Targeting_Metrics_MVN__c metric, String suggestedTier){
		Territory_Targets__c target = new Territory_Targets__c();
		target.Territory_Metrics__c = metric.Id;
		target.Suggested_Tier__c = suggestedTier;
		target.Total_Insulin_TRX__c = 1;
		insert target;

		return target;
	}
	
}