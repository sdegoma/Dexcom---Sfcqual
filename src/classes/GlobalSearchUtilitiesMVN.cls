public with sharing class GlobalSearchUtilitiesMVN {
	public GlobalSearchUtilitiesMVN() {
		
	}

	public static List<SearchResultWrapperMVN> salesforceSearch(Map<String, String> searchParams, String searchOption){
		List<SearchResultWrapperMVN> wrappedResults = new List<SearchResultWrapperMVN>();

		if(!searchParams.isEmpty()){
			RecordType prescriberRecordType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Prescriber'];

			String queryString = 'select Account__c, Account__r.FirstName, Account__r.LastName, Account__r.Gender_Code__c, Account__r.Suffix__pc, Account__r.PersonMailingPostalCode, Account__r.PersonMailingCity, Account__r.PersonMailingState, City__c, Zip_Postal_Code__c, State__c, Account__r.NPI_Number__c, Account__r.DEA__pc, Account__r.Professional_Designation__c, Account__r.Contact_Specialty__pc, Account__r.Party_ID__c from Address__c where Account__r.RecordTypeId = \'' + prescriberRecordType.Id + '\'';

			List<String> whereClause = new List<String>();
			if(searchparams.containsKey('firstName')){
				if(searchOption.equals('begins')){
					whereClause.add('Account__r.FirstName LIKE \'' + searchParams.get('firstName') + '%\''); 
				} else if(searchOption.equals('contains')){
					whereClause.add('Account__r.FirstName LIKE \'%' + searchParams.get('firstName') + '%\'');
				} else if(searchOption.equals('exact') || searchOption.equals('sounds')){ 
					whereClause.add('Account__r.FirstName = \'' + searchParams.get('firstName') + '\''); 
				}
			}

			if(searchparams.containsKey('lastName')){
				if(searchOption.equals('begins')){
					whereClause.add('Account__r.LastName LIKE \'' + searchParams.get('lastName') + '%\''); 
				} else if(searchOption.equals('contains')){
					whereClause.add('Account__r.LastName LIKE \'%' + searchParams.get('lastName') + '%\'');
				} else if(searchOption.equals('exact') || searchOption.equals('sounds')){ 
					whereClause.add('Account__r.LastName = \'' + searchParams.get('lastName') + '\''); 
				}
			}

			if(searchparams.containsKey('zip5')){
				whereClause.add('Zip_Postal_Code__c = \'' + searchParams.get('zip5') + '\''); 
			}

			if(searchparams.containsKey('city')){
				whereClause.add('City__c = \'' + searchParams.get('city') + '\''); 
			}

			if(searchparams.containsKey('stateCode')){
				whereClause.add('State__c = \'' + searchParams.get('stateCode') + '\''); 
			}

			if(searchparams.containsKey('npi')){
				whereClause.add('Account__r.NPI_Number__c = \'' + searchParams.get('npi') + '\''); 
			}

			if(searchparams.containsKey('dea')){
				whereClause.add('Account__r.DEA__pc = \'' + searchParams.get('dea') + '\''); 
			}

			if(searchparams.containsKey('professionalDesc')){
				whereClause.add('Account__r.Professional_Designation__c = \'' + searchParams.get('professionalDesc') + '\''); 
			}

			if(searchparams.containsKey('specialtyDesc')){
				whereClause.add('Account__r.Contact_Specialty__pc = \'' + searchParams.get('specialtyDesc') + '\''); 
			}

			for(String whereCondition : whereClause){
				queryString += ' AND ' + whereCondition;
			}

			queryString += ' LIMIT 50';

			System.debug(queryString);
			List<Address__c> foundAddresses = (List<Address__c>) Database.query(queryString);

			for(Address__C address : foundAddresses){
				SearchResultWrapperMVN result = new SearchResultWrapperMVN();

				result.hceId = address.Account__c;
				result.firstName = address.Account__r.FirstName;
                result.lastName = address.Account__r.LastName;
                result.suffix = address.Account__r.Suffix__pc;
                result.genderCode = address.Account__r.Gender_Code__c;

                result.city = address.City__c;
                result.state = address.State__c;
                result.zip5 = address.Zip_Postal_Code__c;

                result.partyId = address.Account__r.Party_ID__c;
                result.npiNum = address.Account__r.NPI_Number__c;
                result.deaNum = address.Account__r.DEA__pc;
			           
                result.specialty = address.Account__r.Contact_Specialty__pc;
                result.professionalDesc = address.Account__r.Professional_Designation__c;

                wrappedResults.add(result);
			}
		}

		return wrappedResults;
	}

	public static String lookupHCP(String searchParamsXml){
		String result = '';

		String orgInstance = '';
        Organization org = [select Id, IsSandbox from Organization limit 1];

        if(org.IsSandbox){
            orgInstance = 'Sandbox';
        } else {
            orgInstance = 'Production';
        }

        IMS_Health_Settings__mdt settings = [select Id, Webservice_Endpoint__c from IMS_Health_Settings__mdt where DeveloperName = :orgInstance];

		try{
			IMSHealthUACC.ASCS_DaaS_APISoap request = new IMSHealthUACC.ASCS_DaaS_APISoap();
			request.endpoint_x = settings.Webservice_Endpoint__c;
			request.timeout_x = 120000;
			result = request.LookupHCPV2(searchParamsXml);
		} catch(Exception e){
			System.debug('There was an error when calling out to the IMS Health Webservice: ' + e.getLineNumber() + ': ' + e.getMessage());
			throw new ImsSearchException(System.Label.IMS_Search_Error);
		}

		return result;
	}	

	public static String getHCPProfile(String hcpIdXml){
		String result = '';

		String orgInstance = '';
        Organization org = [select Id, IsSandbox from Organization limit 1];

        if(org.IsSandbox){
            orgInstance = 'Sandbox';
        } else {
            orgInstance = 'Production';
        }

        IMS_Health_Settings__mdt settings = [select Id, Webservice_Endpoint__c from IMS_Health_Settings__mdt where DeveloperName = :orgInstance];

		try{
			IMSHealthUACC.ASCS_DaaS_APISoap request = new IMSHealthUACC.ASCS_DaaS_APISoap();
			request.endpoint_x = settings.Webservice_Endpoint__c;
			request.timeout_x = 120000;
			result = request.GetHCPProfileV2(hcpIdXml);
		} catch(Exception e){
			System.debug('There was an error when calling out to the IMS Health Webservice: ' + e.getLineNumber() + ': ' + e.getMessage());
			throw new ImsSearchException(System.Label.IMS_Search_Error);
		}

		return result;
	}	

	public static String getLicenseData(String hcpIdXml){
		String result = '';

		String orgInstance = '';
        Organization org = [select Id, IsSandbox from Organization limit 1];

        if(org.IsSandbox){
            orgInstance = 'Sandbox';
        } else {
            orgInstance = 'Production';
        }

        IMS_Health_Settings__mdt settings = [select Id, Webservice_Endpoint__c from IMS_Health_Settings__mdt where DeveloperName = :orgInstance];

		try{
			IMSHealthUACC.ASCS_DaaS_APISoap request = new IMSHealthUACC.ASCS_DaaS_APISoap();
			request.endpoint_x = settings.Webservice_Endpoint__c;
			request.timeout_x = 120000;
			result = request.GetHCPLicenseDatav2(hcpIdXml);
		} catch(Exception e){
			System.debug('There was an error when calling out to the IMS Health Webservice: ' + e.getLineNumber() + ': ' + e.getMessage());
			throw new ImsSearchException(System.Label.IMS_Search_Error);
		}

		return result;
	}
}