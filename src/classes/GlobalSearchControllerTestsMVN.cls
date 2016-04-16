@isTest
private class GlobalSearchControllerTestsMVN {
	
	@isTest(SeeAllData=true) static void test_picklists() {
		GlobalSearchControllerMVN controller = new GlobalSearchControllerMVN();
		System.assert(!controller.getSpecialtyValues().isEmpty());
		System.assert(!controller.getProfessionalDesignationValues().isEmpty());
	}
	
	@isTest static void test_redirect_to_create_new_account() {
		GlobalSearchControllerMVN controller = new GlobalSearchControllerMVN();

		controller.firstName = 'test';
		controller.lastName = 'account';
		controller.npi = '12345';
		controller.dea = '54321';
		controller.selectedProfessionalDesignation = 'Medical Doctor';
		controller.selectedSearchOption = 'exact';

		String newAccountPage = controller.redirectToNewAccount().getUrl();
		System.debug(newAccountPage);
		System.assert(newAccountPage.contains('test'));
		System.assert(newAccountPage.contains('account'));
		System.assert(newAccountPage.contains('12345'));
		System.assert(newAccountPage.contains('54321'));
		System.assert(newAccountPage.contains('Medical+Doctor'));
	}

	@isTest static void test_search() {
		GlobalSearchControllerMVN controller = new GlobalSearchControllerMVN();

		controller.firstName = 'test';
		controller.lastName = 'account';
		controller.npi = '12345';
		controller.dea = '54321';
		controller.selectedProfessionalDesignation = 'Medical Doctor';
		controller.selectedSearchOption = 'exact';

		Test.setMock(WebServiceMock.class, new ImsLookupMockMVN());

		controller.doSearch();

		System.assert(!controller.searchResults.isEmpty());
	}
	
}