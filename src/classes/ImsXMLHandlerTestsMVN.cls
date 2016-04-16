@isTest
private class ImsXMLHandlerTestsMVN {
    
    @isTest static void test_generate_search_string() {
        Map<String, String> searchParams = new Map<String, String>();

        searchParams.put('firstName', 'Test');
        searchParams.put('lastName', 'Prescriber');
        searchParams.put('zip5', '97212');
        searchParams.put('city', 'Portland');
        searchParams.put('stateCode', 'OR');
        searchParams.put('npi', '12345678');
        searchParams.put('dea', '87654321');
        searchParams.put('professionalDesc', 'Medical Doctor');
        searchParams.put('specialtyDesc', 'Radiology');

        String resultXML = ImsXMLHandlerMVN.generateSearchString(searchParams, 'sounds');

        System.assert(resultXML.contains('<name>firstName</name>'));
    	System.assert(resultXML.contains('<value>Test</value>'));
    }
    
    @isTest static void test_generate_profile_string() {
    	String resultXML = ImsXMLHandlerMVN.generateGetProfileString('12345');

    	System.assert(resultXMl.contains('<hceId>12345</hceId>'));
    }
    
    @isTest static void test_parse_search_results() {
    	String responseXML = '<?xml version="1.0" encoding="UTF-8"?>'+
								'<lookupHCPResult>'+
								   '<clientInfo>'+
								      '<clientId>DEXCOM_UACC</clientId>'+
								      '<appId>40</appId>'+
								      '<userName>MavensTest</userName>'+
								      '<clientReqId>1234</clientReqId>'+
								   '</clientInfo>'+
								   '<generalInfo>'+
								      '<daasId>85447</daasId>'+
								      '<status>true</status>'+
								      '<matchResult>1</matchResult>'+
								  '</generalInfo>'+
								   '<notificationMessages />'+
								   '<errorMessages />'+
								   '<hcps>'+
								      '<hcp>'+
								         '<hceId>2911080</hceId>'+
								         '<hceTypeId>1</hceTypeId>'+
								         '<imsId />'+
								         '<xrefHceId />'+
								         '<firstName>NATHAN</firstName>'+
								         '<lastName>SMITH</lastName>'+
								         '<middleName>CARVER</middleName>'+
								         '<suffix />'+
								         '<genderCode>M</genderCode>'+
								         '<hcpStatusCode>A</hcpStatusCode>'+
								         '<alternateNames />'+
								         '<cityZipStates>'+
								            '<cityZipState>'+
								               '<city>PORTLAND</city>'+
								               '<zip5>97212</zip5>'+
								               '<stateCode>OR</stateCode>'+
								           '</cityZipState>'+
								        '</cityZipStates>'+
								         '<deas />'+
								         '<externalIds>'+
								            '<externalId>'+
								               '<type>NPI</type>'+
								               '<id>1982856662</id>'+
								           '</externalId>'+
								        '</externalIds>'+
								         '<slns />'+
								         '<csrs />'+
								         '<professions>'+
								            '<profession>'+
								               '<profDesc>Other Service Provider</profDesc>'+
								               '<specialties>'+
								                  '<specialty>'+
								                     '<specDesc>HOME HEALTH/PERSONAL CARE</specDesc>'+
								                     '<subSpecialties>'+
								                        '<subSpecialty>'+
								                           '<subSpecDesc />'+
								                       '</subSpecialty>'+
								                    '</subSpecialties>'+
								                 '</specialty>'+
								              '</specialties>'+
								           '</profession>'+
								        '</professions>'+
								         '<stateIds>'+
								            '<stateId>'+
								               '<id />'+
								               '<stateCode />'+
								           '</stateId>'+
								        '</stateIds>'+
								     '</hcp>'+
							         '</hcps>'+
								'</lookupHCPResult>';

		List<SearchResultWrapperMVN> resultWrappers = ImsXMLHandlerMVN.parseSearchResults(responseXMl);

		System.assert(resultWrappers.size() == 1);
		System.assert(resultWrappers[0].firstName.equals('NATHAN'));
		System.assert(resultWrappers[0].lastName.equals('SMITH'));
    }

    @isTest static void test_parse_profile_result(){
    	String resultXML = '<?xml version="1.0" encoding="UTF-8"?><profileHCPResult>'+
							  '<clientInfo>'+
							     '<clientId>DEXCOM_UACC</clientId>'+
							     '<appId>40</appId>'+
							     '<userName>MavensTest</userName>'+
							     '<clientReqId>1234</clientReqId>'+
							  '</clientInfo>'+
							  '<generalInfo>'+
							     '<daasId>85555</daasId>'+
							     '<status>true</status>'+
							     '<matchResult>1</matchResult>'+
							  '</generalInfo>'+
							  '<notificationMessages />'+
							  '<errorMessages />'+
							  '<hcp>'+
							     '<hceId>8101007</hceId>'+
							     '<hceTypeId>1</hceTypeId>'+
							     '<imsId>2305724</imsId>'+
							     '<xrefHceId />'+
							     '<firstName>CHRISTINE</firstName>'+
							     '<lastName>CHEN</lastName>'+
							     '<middleName>SHIN-YI</middleName>'+
							     '<suffix />'+
							     '<genderCode>F</genderCode>'+
							     '<genderDesc>Female</genderDesc>'+
							     '<hcpStatusCode>A</hcpStatusCode>'+
							     '<hcpStatusDesc>Active</hcpStatusDesc>'+
							     '<yearOfBirth>1973</yearOfBirth>'+
							     '<amaPdrpInd>0</amaPdrpInd>'+
							     '<amaPdrpEffDate />'+
							     '<alternateNames>'+
							        '<alternateName>'+
							           '<altNameTypeCode />'+
							           '<altFirstName />'+
							           '<altMiddleName />'+
							           '<altLastName />'+
							           '<altNameVerNum />'+
							        '</alternateName>'+
							     '</alternateNames>'+
							     '<addresses>'+
							        '<address>'+
							           '<addressId>0000116162</addressId>'+
							           '<address1>19500 SE STARK ST</address1>'+
							           '<address2 />'+
							           '<city>PORTLAND</city>'+
							           '<stateCode>OR</stateCode>'+
							           '<zip5>97233</zip5>'+
							           '<zip4>5757</zip4>'+
							           '<msaCBSA>38900</msaCBSA>'+
							           '<settingTypeCode>2</settingTypeCode>'+
							           '<settingTypeDesc>Office</settingTypeDesc>'+
							           '<latitude>45.517825</latitude>'+
							           '<longitude>-122.46194</longitude>'+
							           '<xrefAddrId />'+
							           '<pracLocRank>10</pracLocRank>'+
							           '<pracLocConfInd>P</pracLocConfInd>'+
							           '<addrLocConfDesc>Preferred Rank 10</addrLocConfDesc>'+
							           '<singleAddrInd>Y</singleAddrInd>'+
							           '<comms>'+
							              '<comm>'+
							                 '<commTypeCode>FX</commTypeCode>'+
							                 '<commTypeDesc>Fax</commTypeDesc>'+
							                 '<commValue>5036693968</commValue>'+
							              '</comm>'+
							              '<comm>'+
							                 '<commTypeCode>PH</commTypeCode>'+
							                 '<commTypeDesc>Phone</commTypeDesc>'+
							                 '<commValue>5036693900</commValue>'+
							              '</comm>'+
							              '<comm>'+
							                 '<commTypeCode>PH</commTypeCode>'+
							                 '<commTypeDesc>Phone</commTypeDesc>'+
							                 '<commValue>5036744722</commValue>'+
							              '</comm>'+
							              '<comm>'+
							                 '<commTypeCode>PH</commTypeCode>'+
							                 '<commTypeDesc>Phone</commTypeDesc>'+
							                 '<commValue>5038132000</commValue>'+
							              '</comm>'+
							           '</comms>'+
							           '<deas>'+
							              '<dea>'+
							                 '<deaNumber>BC8899102</deaNumber>'+
							                 '<deaExpirationDate>8/31/2016</deaExpirationDate>'+
							                 '<busActvCode>C</busActvCode>'+
							                 '<busActvDesc>PRACTITIONER</busActvDesc>'+
							                 '<subBusActvCode>0</subBusActvCode>'+
							                 '<subBusActvDesc>PRACTITIONER</subBusActvDesc>'+
							                 '<deaClassCode>22N 33N 4 5</deaClassCode>'+
							                 '<deaStatusCode>A</deaStatusCode>'+
							                 '<deaStatusDesc>Active</deaStatusDesc>'+
							                 '<deaDeactvRsnCode />'+
							                 '<deaDeactvRsnDesc />'+
							              '</dea>'+
							           '</deas>'+
							        '</address>'+
							        '<address>'+
							           '<addressId>0010180357</addressId>'+
							           '<address1>3126 NE 10TH AVE</address1>'+
							           '<address2 />'+
							           '<city>PORTLAND</city>'+
							           '<stateCode>OR</stateCode>'+
							           '<zip5>97212</zip5>'+
							           '<zip4>2229</zip4>'+
							           '<msaCBSA>38900</msaCBSA>'+
							           '<settingTypeCode>1</settingTypeCode>'+
							           '<settingTypeDesc>Home</settingTypeDesc>'+
							           '<latitude>45.545636</latitude>'+
							           '<longitude>-122.65517</longitude>'+
							           '<xrefAddrId />'+
							           '<pracLocRank>7</pracLocRank>'+
							           '<pracLocConfInd>A</pracLocConfInd>'+
							           '<addrLocConfDesc>Active Rank 7</addrLocConfDesc>'+
							           '<singleAddrInd>N</singleAddrInd>'+
							           '<comms>'+
							              '<comm>'+
							                 '<commTypeCode />'+
							                 '<commTypeDesc />'+
							                 '<commValue />'+
							              '</comm>'+
							           '</comms>'+
							           '<deas>'+
							              '<dea>'+
							                 '<deaNumber />'+
							                 '<deaExpirationDate />'+
							                 '<busActvCode />'+
							                 '<busActvDesc />'+
							                 '<subBusActvCode />'+
							                 '<subBusActvDesc />'+
							                 '<deaClassCode />'+
							                 '<deaStatusCode />'+
							                 '<deaStatusDesc />'+
							                 '<deaDeactvRsnCode />'+
							                 '<deaDeactvRsnDesc />'+
							              '</dea>'+
							           '</deas>'+
							        '</address>'+
							     '</addresses>'+
							     '<professions>'+
							        '<profession>'+
							           '<professionCode>01</professionCode>'+
							           '<professionDesc>Medical Doctors</professionDesc>'+
							           '<professionRank>1</professionRank>'+
							           '<specialties>'+
							              '<specialty>'+
							                 '<specialtyCode>PD</specialtyCode>'+
							                 '<specialtyDesc>PEDIATRICS</specialtyDesc>'+
							                 '<specialtyRank>1</specialtyRank>'+
							                 '<subSpecialties>'+
							                    '<subSpecialty>'+
							                       '<subSpecialtyCode />'+
							                       '<subSpecialtyDesc />'+
							                       '<subSpecialtyRank />'+
							                    '</subSpecialty>'+
							                 '</subSpecialties>'+
							              '</specialty>'+
							           '</specialties>'+
							        '</profession>'+
							     '</professions>'+
							     '<externalIds>'+
							        '<externalId>'+
							           '<type>ME</type>'+
							           '<id>0481301081</id>'+
							        '</externalId>'+
							        '<externalId>'+
							           '<type>NPI</type>'+
							           '<id>1639251705</id>'+
							        '</externalId>'+
							     '</externalIds>'+
							     '<slns>'+
							        '<sln>'+
							           '<slnProfessionCode>01</slnProfessionCode>'+
							           '<slnNumber>LL10086</slnNumber>'+
							           '<slnStateCode>OR</slnStateCode>'+
							        '</sln>'+
							        '<sln>'+
							           '<slnProfessionCode>01</slnProfessionCode>'+
							           '<slnNumber>LL11231</slnNumber>'+
							           '<slnStateCode>OR</slnStateCode>'+
							        '</sln>'+
							        '<sln>'+
							           '<slnProfessionCode>01</slnProfessionCode>'+
							           '<slnNumber>LL12117</slnNumber>'+
							           '<slnStateCode>OR</slnStateCode>'+
							        '</sln>'+
							        '<sln>'+
							           '<slnProfessionCode>01</slnProfessionCode>'+
							           '<slnNumber>LL15612</slnNumber>'+
							           '<slnStateCode>OR</slnStateCode>'+
							        '</sln>'+
							        '<sln>'+
							           '<slnProfessionCode>01</slnProfessionCode>'+
							           '<slnNumber>MD26083</slnNumber>'+
							           '<slnStateCode>OR</slnStateCode>'+
							        '</sln>'+
							        '<sln>'+
							           '<slnProfessionCode>01</slnProfessionCode>'+
							           '<slnNumber>MD00043971</slnNumber>'+
							           '<slnStateCode>WA</slnStateCode>'+
							        '</sln>'+
							     '</slns>'+
							     '<csrs />'+
							     '<stateIds>'+
							        '<stateId>'+
							           '<id />'+
							           '<stateCode />'+
							        '</stateId>'+
							     '</stateIds>'+
							  '</hcp></profileHCPResult>';

		Id accountId = ImsXMLHandlerMVN.parseProfileResult(resultXML, '97212');

		Account acct = [select Id, FirstName, LastName from Account where Id = :accountId];

		System.assertEquals(acct.FirstName, 'CHRISTINE');
		System.assertEquals(acct.LastName, 'CHEN');

		Address__c address = [select Id, Zip_Postal_Code__c from Address__c where Account__c = :accountId and Primary_Flag__c = true];

		System.assertEquals(address.Zip_Postal_Code__c, '97212');
    }

    @isTest static void test_parse_license_result() {
    	String resultXML = '<licenseHCPResult><clientInfo><clientId>DEXCOM_UACC</clientId><appId>40</appId><userName>MavensTest</userName><clientReqId>1234</clientReqId></clientInfo><generalInfo><daasId>85776</daasId><status>true</status><matchResult>6</matchResult></generalInfo><notificationMessages></notificationMessages><errorMessages></errorMessages><hceId>8101007</hceId><hcpLicenses><hcpLicense><number>LL10086</number><professionCode>01</professionCode><stateCode>OR</stateCode><boardId>2</boardId><boardName>OREGON MEDICAL BOARD</boardName><typeId>5</typeId><typeName>MD POSTGRADUATE LICENSE</typeName><privilegeId>1</privilegeId><privilegeDesc>UNKNOWN</privilegeDesc><effDate></effDate><expDate>6/30/2002</expDate><statusCode>E</statusCode><statusDesc>Expired</statusDesc><deactvRsnCode>DESRC</deactvRsnCode><deactvRsnDesc>Inactive via Source</deactvRsnDesc><certCode>MD</certCode><certDesc>Medical Doctor</certDesc><privilegeRank>70</privilegeRank></hcpLicense><hcpLicense><number>LL11231</number><professionCode>01</professionCode><stateCode>OR</stateCode><boardId>2</boardId><boardName>OREGON MEDICAL BOARD</boardName><typeId>5</typeId><typeName>MD POSTGRADUATE LICENSE</typeName><privilegeId>1</privilegeId><privilegeDesc>UNKNOWN</privilegeDesc><effDate></effDate><expDate>6/30/2003</expDate><statusCode>E</statusCode><statusDesc>Expired</statusDesc><deactvRsnCode>DESRC</deactvRsnCode><deactvRsnDesc>Inactive via Source</deactvRsnDesc><certCode>MD</certCode><certDesc>Medical Doctor</certDesc><privilegeRank>70</privilegeRank></hcpLicense><hcpLicense><number>LL12117</number><professionCode>01</professionCode><stateCode>OR</stateCode><boardId>2</boardId><boardName>OREGON MEDICAL BOARD</boardName><typeId>5</typeId><typeName>MD POSTGRADUATE LICENSE</typeName><privilegeId>1</privilegeId><privilegeDesc>UNKNOWN</privilegeDesc><effDate>7/1/2003</effDate><expDate>3/30/2010</expDate><statusCode>E</statusCode><statusDesc>Expired</statusDesc><deactvRsnCode>DESRC</deactvRsnCode><deactvRsnDesc>Inactive via Source</deactvRsnDesc><certCode>MD</certCode><certDesc>Medical Doctor</certDesc><privilegeRank>70</privilegeRank></hcpLicense><hcpLicense><number>LL15612</number><professionCode>01</professionCode><stateCode>OR</stateCode><boardId>2</boardId><boardName>OREGON MEDICAL BOARD</boardName><typeId>18</typeId><typeName>MD SPECIAL LICENSE</typeName><privilegeId>1</privilegeId><privilegeDesc>UNKNOWN</privilegeDesc><effDate></effDate><expDate>10/7/2005</expDate><statusCode>E</statusCode><statusDesc>Expired</statusDesc><deactvRsnCode>DESRC</deactvRsnCode><deactvRsnDesc>Inactive via Source</deactvRsnDesc><certCode>MD</certCode><certDesc>Medical Doctor</certDesc><privilegeRank>90</privilegeRank></hcpLicense><hcpLicense><number>MD00043971</number><professionCode>01</professionCode><stateCode>WA</stateCode><boardId>3</boardId><boardName>MEDICAL QUALITY ASSURANCE COMMISSION</boardName><typeId>2</typeId><typeName>PHYSICIAN AND SURGEON LICENSE</typeName><privilegeId>1</privilegeId><privilegeDesc>UNKNOWN</privilegeDesc><effDate>1/6/2013</effDate><expDate>2/1/2017</expDate><statusCode>A</statusCode><statusDesc>Active</statusDesc><deactvRsnCode></deactvRsnCode><deactvRsnDesc></deactvRsnDesc><certCode>MD</certCode><certDesc>Medical Doctor</certDesc><privilegeRank>10</privilegeRank></hcpLicense><hcpLicense><number>MD26083</number><professionCode>01</professionCode><stateCode>OR</stateCode><boardId>2</boardId><boardName>OREGON MEDICAL BOARD</boardName><typeId>1</typeId><typeName>MD LICENSE</typeName><privilegeId>1</privilegeId><privilegeDesc>UNKNOWN</privilegeDesc><effDate></effDate><expDate>12/31/2015</expDate><statusCode>A</statusCode><statusDesc>Active</statusDesc><deactvRsnCode></deactvRsnCode><deactvRsnDesc></deactvRsnDesc><certCode>MD</certCode><certDesc>Medical Doctor</certDesc><privilegeRank>10</privilegeRank></hcpLicense></hcpLicenses></licenseHCPResult>';

    	Account testAccount = new Account();

    	testAccount.Name = 'test account';
    	insert testAccount;

    	ImsXMLHandlerMVN.parseLicenseResult(resultXML, testAccount.Id);

    	List<State_License__c> licenses = [select Id from State_License__c where Prescribers__c = :testAccount.Id];

    	System.assertEquals(6, licenses.size());
    }
}