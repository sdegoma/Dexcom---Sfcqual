@isTest
private class GlobalSearchUtilitiesTestsMVN {
    
    @isTest static void test_salesforce_search() {
        Account testAccount = new Account();
        RecordType prescriberRecordType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Prescriber'];
        
        testAccount.RecordTypeId = prescriberRecordType.Id;
        testAccount.FirstName = 'Test';
        testAccount.LastName = 'Account';
        testAccount.NPI_Number__c = '12345';
        testAccount.DEA__pc = '54321';
        testAccount.Professional_Designation__c = 'Medical Doctor';
        testAccount.Contact_Specialty__pc = 'RADIOLOGY';

        insert testAccount;

        Address__c testAddress = new Address__c();

        testAddress.Account__c = testAccount.Id;
        testAddress.Zip_Postal_Code__c = '97212';
        testAddress.City__c = 'Portland';
        testAddress.State__c = 'OR';

        insert testAddress;

        Map<String, String> searchParams = new Map<String, String>();

        searchParams.put('firstName', 'Test');
        searchParams.put('lastName', 'Account');
        searchParams.put('zip5', '97212');
        searchParams.put('city', 'Portland');
        searchParams.put('stateCode', 'OR');
        searchParams.put('npi', '12345');
        searchParams.put('dea', '54321');
        searchParams.put('professionalDesc', 'Medical Doctor');
        searchParams.put('specialtyDesc', 'RADIOLOGY');

        List<SearchResultWrapperMVN> results = GlobalSearchUtilitiesMVN.salesforceSearch(searchParams, 'exact');

        System.assertEquals(1, results.size());
    }
    
    @isTest static void test_lookup_hcp() {
        Test.setMock(WebServiceMock.class, new ImsLookupMockMVN());
        
        // Call the method that invokes a callout
        String output = GlobalSearchUtilitiesMVN.lookupHCP('test');
    }

    @isTest static void test_hcp_profile() {
        Test.setMock(WebServiceMock.class, new ImsProfileMockMVN());
        
        // Call the method that invokes a callout
        String output = GlobalSearchUtilitiesMVN.getHCPProfile('test');
    }

    @isTest static void test_license_data() {
        Test.setMock(WebServiceMock.class, new ImsLicenseMockMVN());
        
        // Call the method that invokes a callout
        String output = GlobalSearchUtilitiesMVN.getLicenseData('test');
    }
    
}