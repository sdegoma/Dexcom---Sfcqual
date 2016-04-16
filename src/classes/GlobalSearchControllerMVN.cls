public with sharing class GlobalSearchControllerMVN {

	public String firstName                                 {get;set;}
    public String lastName                                  {get;set;}
    public String city                                      {get;set;}
    public Address__c addressState                          {get;set;}
    public String zip5                                      {get;set;}
    public String npi                                       {get;set;}
    public String dea                                       {get;set;}
    public String professionDesc                            {get;set;}
    public String selectedSpecialty                         {get;set;}
    public String selectedProfessionalDesignation           {get;set;}
    public String selectedHCEID                             {get;set;}
    public String selectedSearchOption                      {get;set;}
    public Boolean accountsFound                            {get;set;}
    public Boolean salesforceAccountsFound                  {get;set;}
    public Boolean searchDone                               {get;set;}
    public List<SearchResultWrapperMVN> searchResults       {get;set;}
    public List<SearchResultWrapperMVN> salesforceResults   {get;set;}

    public GlobalSearchControllerMVN() {
        RecordType personAccountRecordType = [select Id from RecordType where SObjectType='Account' and DeveloperName = 'PersonAccount'];
        accountsFound = false;
        searchDone = false;
        addressState = new Address__c();
    }

    public List<SelectOption> getSearchOptions(){
        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('begins', 'begins with'));
        options.add(new SelectOption('contains', 'contains'));
        options.add(new SelectOption('exact', 'exact'));
        options.add(new SelectOption('sounds', 'soundex'));
        return options;
    }

    public List<SelectOption> getSpecialtyValues(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        List<StaticResource> docs;
        docs = [select id, name, body from StaticResource 
                where name = 'specialtiesPicklist']; 

        if(!docs.isEmpty()){
            String body = docs[0].body.toString();

            for(String value : body.split(',')){
                SelectOption option = new SelectOption(value, value);

                options.add(option);
            }
        }
        return options;
    }

    public List<SelectOption> getProfessionalDesignationValues(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        List<StaticResource> docs;
        docs = [select id, name, body from StaticResource 
                where name = 'professionalDesignationPicklist']; 

        if(!docs.isEmpty()){
            String body = docs[0].body.toString();

            for(String value : body.split(',')){
                SelectOption option = new SelectOption(value, value);

                options.add(option);
            }
        }
        return options;
    }

    public void doSearch(){
        Map<String, String> searchParams = new Map<String, String>();

        if(String.isNotBlank(firstName)){
            searchParams.put('firstName', firstName);
        }
        if(String.isNotBlank(lastName)){
            searchParams.put('lastName', lastName);
        }

        if(String.isNotBlank(zip5)){
            searchParams.put('zip5', zip5);
        }

        if(String.isNotBlank(city)){
            searchParams.put('city', city);
        }

        if(String.isNotBlank(addressState.State__c)){
            searchParams.put('stateCode', addressState.State__c);
        }

        if(String.isNotBlank(npi)){
            searchParams.put('npi', npi);
        }

        if(String.isNotBlank(dea)){
            searchParams.put('dea', dea);
        }

        if(String.isNotBlank(selectedProfessionalDesignation)){
            searchParams.put('professionDesc', selectedProfessionalDesignation);
        }

        if(String.isNotBlank(selectedSpecialty)){
            searchParams.put('specialtyDesc', selectedSpecialty);
        }


        try{
            salesforceResults = GlobalSearchUtilitiesMVN.salesforceSearch(searchParams, selectedSearchOption);
            
            String requestXml = ImsXMLHandlerMVN.generateSearchString(searchParams, selectedSearchOption);
            String responseXml = GlobalSearchUtilitiesMVN.lookupHCP(requestXml);
            System.debug('Response: ' + responseXml);
            if(String.isNotBlank(responseXml)){
                searchResults = ImsXmlHandlerMVN.parseSearchResults(responseXml);
            }
        } catch(ImsSearchException e){
            searchResults = new List<SearchResultWrapperMVN>();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        }

        searchDone = true;

        if(!salesforceResults.isEmpty()){
            salesforceAccountsFound = true;
        } else{
            salesforceAccountsFound = false;
        }

        if(searchResults != null && !searchResults.isEmpty()){
            accountsFound = true;
        } else{
            accountsFound = false;
        }

        System.debug(searchResults);
    }

    public PageReference saveSelectedAccount(){
        System.debug(selectedHCEID);
        
        String selectedZip;
        
        for(SearchResultWrapperMVN result : searchResults){
            if(result.hceId == selectedHCEID){
                selectedZip = result.zip5;
            }
        }

        String getProfileXml = ImsXMLHandlerMVN.generateGetProfileString(selectedHCEID);

        String profileResult = GlobalSearchUtilitiesMVN.getHCPProfile(getProfileXml);

        String licenseResult = getLicenseData();
        System.debug(profileResult);
        Id newAccountId = ImsXMLHandlerMVN.parseProfileResult(profileResult, selectedZip);
        
        if(newAccountId != null){
            ImsXMLHandlerMVN.parseLicenseResult(licenseResult, newAccountId);

            PageReference page = new PageReference('/' + newAccountId);

            page.setRedirect(true);
            System.debug(page.getUrl());
            return page;
        }

        return null;
    }

    public String getLicenseData(){
        String getProfileXml = ImsXMLHandlerMVN.generateGetProfileString(selectedHCEID);

        String licenseResult = GlobalSearchUtilitiesMVN.getLicenseData(getProfileXml);

        return licenseResult;
    }

    public PageReference redirectToNewAccount(){
        RecordType prescriberRecordType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Prescriber'];

        String pageURL = '/001/e?RecordType=' + prescriberRecordType.Id;
        
        if(String.isNotBlank(firstName)){
            pageURL += '&name_firstacc2=' + firstName;
        }

        if(String.isNotBlank(lastName)){
            pageURL += '&name_lastacc2=' + lastName;
        }

        if(String.isNotBlank(npi)){
            pageURL += '&00N40000002eeMv=' + npi;
        }

        if(String.isNotBlank(dea)){
            pageURL += '&00N40000002eeRH=' + dea;
        }

        if(String.isNotBlank(selectedProfessionalDesignation)){
            pageURL += '&00N33000003CJiu=' + selectedProfessionalDesignation;
        }

        PageReference page = new PageReference(pageURL);

        page.setRedirect(true);
        return page;
    }
}