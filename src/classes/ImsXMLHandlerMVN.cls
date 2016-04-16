public with sharing class ImsXMLHandlerMVN {
    
    

    public static String generateSearchString(Map<String, String> params, String searchType){
        Dom.Document doc = new Dom.Document();

        Dom.XmlNode parent = doc.createRootElement('LookupHCPV2', null, null);

        Dom.XmlNode clientCredentials = getClientCredentials(parent.addChildElement('clientInfo', null, null));

        Dom.XmlNode searchCriteria = parent.addChildElement('searchCriteria', null, null);

        Dom.XmlNode ands = searchCriteria.addChildElement('ands', null, null);

        for(String key : params.keySet()){

                String paramValue = params.get(key);

                Dom.XmlNode andNode = ands.addChildElement('and', null, null);
                Dom.XmlNode col = andNode.addChildElement('col', null, null);

                Dom.XmlNode name = col.addChildElement('name', null, null);
                name.addTextNode(key);

                Dom.XmlNode value = col.addChildElement('value', null, null);
                value.addTextNode(paramValue);

                Dom.XmlNode check = col.addChildElement('check', null, null);
                
                if(key.equals('firstName') || key.equals('lastName')){
                    check.addTextNode(searchType);
                } else{
                    check.addTextNode('exact');
                }
        }

        System.debug(doc.toXMLString());

        return doc.toXmlString();
    }

    public static String generateGetProfileString(String hceId){
        Dom.Document doc = new Dom.Document();

        Dom.XmlNode parent = doc.createRootElement('profileHCPRequest', null, null);

        Dom.XmlNode clientCredentials = getClientCredentials(parent.addChildElement('clientInfo', null, null));

        Dom.XmlNode searchCriteria = parent.addChildElement('searchCriteria', null, null);

        Dom.XmlNode hceIdNode = searchCriteria.addChildElement('hceId', null, null);
        hceIdNode.addTextNode(hceId);

        System.debug(doc.toXMLString());

        return doc.toXmlString();
    }
    
    public static Id parseProfileResult(String profileResult, String selectedZip){
        Account newAccount = new Account();

        RecordType prescriberRecordType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Prescriber'];
        System.debug(prescriberRecordType);
        newAccount.RecordTypeId = prescriberRecordType.Id;

        Dom.Document doc = new Dom.Document();
        doc.load(profileResult.replaceAll('&', '&amp;'));

        Dom.XmlNode root = doc.getRootElement();

        checkForErrors(root);

        Dom.XmlNode generalInfo = root.getChildElement('generalInfo', null);

        if(generalInfo != null){
    
            Integer resultCount = Integer.valueOf(root.getChildElement('generalInfo', null).getChildElement('matchResult', null).getText());

            if(resultCount > 0){
                try{
                    Dom.XmlNode hcp = root.getChildElement('hcp', null);

                    newAccount.HCE_ID__c = hcp.getChildElement('hceId', null).getText();
                    newAccount.IMS_ID__pc = hcp.getChildElement('imsId', null).getText();
                    newAccount.FirstName = hcp.getChildElement('firstName', null).getText();
                    newAccount.LastName = hcp.getChildElement('lastName', null).getText();
                    newAccount.Middle_Name__c = hcp.getChildElement('middleName', null).getText();
                    newAccount.Suffix__pc = hcp.getChildElement('suffix', null).getText();
                    newAccount.Gender_Code__c = hcp.getChildElement('genderCode', null).getText();
                    newAccount.Gender__c = hcp.getChildElement('genderDesc', null).getText();
                    newAccount.HCP_Status_Code__c = hcp.getChildElement('hcpStatusCode', null).getText();
                    newAccount.HCP_Status__pc = hcp.getChildElement('hcpStatusDesc', null).getText();
                    newAccount.HCP_Birth_Year__c = hcp.getChildElement('yearOfBirth', null).getText();
                    newAccount.PDRP_Opt_Out__c = hcp.getChildElement('amaPdrpInd', null).getText() == '1' ? true : false;
                    newAccount.PDRP_Effective_Date__c = String.isNotBlank(hcp.getChildElement('amaPdrpEffDate', null).getText()) ? getDate(hcp.getChildElement('amaPdrpEffDate', null).getText()) : null;

                    List<Dom.XmlNode> professions = hcp.getChildElement('professions', null).getChildren();
                    if(professions != null && professions.size() > 0){
                        newAccount.Contact_Specialty__pc = professions[0].getChildElement('specialties', null).getChildren()[0].getChildElement('specialtyDesc', null).getText();
                        newAccount.Speciality_Code__c = professions[0].getChildElement('specialties', null).getChildren()[0].getChildElement('specialtyCode', null).getText();
                        newAccount.Speciality_Rank__c = professions[0].getChildElement('specialties', null).getChildren()[0].getChildElement('specialtyRank', null).getText();
                        newAccount.Professional_Designation__c = professions[0].getChildElement('professionDesc', null).getText();
                    }

                    Dom.XMlNode externalIds = hcp.getChildElement('externalIds', null);

                    for(Dom.XmlNode externalId : externalIds.getChildren()){
                        Dom.XmlNode type = externalId.getChildElement('type', null);

                        if(type.getText().equals('ME')){
                            newAccount.ME_Number__c = externalId.getChildElement('id', null).getText();
                        } else if(type.getText().equals('NPI')){
                            newAccount.NPI_Number__c = externalId.getChildElement('id', null).getText();
                        } else if(type.getText().equals('AOA')){
                            newAccount.AOA_Number__c = externalId.getChildElement('id', null).getText();
                        }
                    }

                    insert newAccount;

                    Dom.XmlNode addresses = hcp.getChildElement('addresses', null);
                    Integer highestValue = 0;
                    
                    Address__c primaryAddress;                    
                    Address__c primaryAddressInZip;

                    List<Address__c> addressRecords = new List<Address__c>(); 
                    for(Dom.XmlNode address : addresses.getChildren()){
                        Address__c newAddress = new Address__c();
                        newAddress.Account__c = newAccount.Id;
                        newAddress.Address_Type__c = 'SHIP_TO';
                        newAddress.Primary_Flag__c = false;
                        newAddress.Street_Address_1__c = address.getChildElement('address1', null).getText();
                        newAddress.Street_Address_2__c = address.getChildElement('address1', null).getText();
                        newAddress.City__c = address.getChildElement('city', null).getText();
                        newAddress.State__c = address.getChildElement('stateCode', null).getText();
                        newAddress.Zip_Postal_Code__c = address.getChildElement('zip5', null).getText();
                        newAddress.Practice_Location_Rank__c = Integer.valueOf(address.getChildElement('pracLocRank', null).getText());
                        newAddress.Location__Latitude__s = Decimal.valueOf(address.getChildElement('latitude', null).getText());
                        newAddress.Location__Longitude__s = Decimal.valueOf(address.getChildElement('longitude', null).getText());
                        newAddress.Location__Longitude__s = Decimal.valueOf(address.getChildElement('longitude', null).getText());

                        Dom.XmlNode comms = address.getChildElement('comms', null);

                        for(Dom.XmlNode comm : comms.getChildren()){
                            if(comm.getChildElement('commTypeDesc', null).getText().equals('Fax') && newAddress.Fax__c == null){
                                newAddress.Fax__c = getPhoneString(comm.getChildElement('commValue', null).getText());
                            } else if(comm.getChildElement('commTypeDesc', null).getText().equals('Phone') && newAddress.Phone_1__c == null){
                                newAddress.Phone_1__c = getPhoneString(comm.getChildElement('commValue', null).getText());
                            } else if(comm.getChildElement('commTypeDesc', null).getText().equals('Phone') && newAddress.Phone_2__c == null){
                                newAddress.Phone_2__c = getPhoneString(comm.getChildElement('commValue', null).getText());
                            }
                        }

                        Dom.XmlNode deas = address.getChildElement('deas', null);

                        if(deas.getChildren() != null){
                            Dom.XmlNode dea = deas.getChildren()[0];

                            newAddress.DEA__c = dea.getChildElement('deaNumber', null).getText();
                            newAddress.DEA_Exp_Date__c = String.isNotBlank(dea.getChildElement('deaExpirationDate', null).getText()) ? getDate(dea.getChildElement('deaExpirationDate', null).getText()) : null;
                            newAddress.DEA_Status_Code__c = dea.getChildElement('deaStatusCode', null).getText();
                            newAddress.DEA_Status_Description__c = dea.getChildElement('deaStatusDesc', null).getText();
                        }
                       
                        if(newAddress.Practice_Location_Rank__c > highestValue){
                            highestValue = newAddress.Practice_Location_Rank__c.intValue();
                            primaryAddress = newAddress;
                        }

                        if(newAddress.Zip_Postal_Code__c == selectedZip && (primaryAddressInZip == null || newAddress.Practice_Location_Rank__c > primaryAddressInZip.Practice_Location_Rank__c)){
                            primaryAddressInZip = newAddress;
                        }

                        addressRecords.add(newAddress);
                    }

                    if(primaryAddressInZip != null){
                        primaryAddressInZip.Primary_Flag__c = true;
                    } else if(primaryAddress != null){
                        primaryAddress.Primary_Flag__c = true;
                    }

                    insert addressRecords;
                    
                } catch(Exception e){
                    System.debug('There was an error parsing the search results: ' + e.getLineNumber() + ': ' + e.getMessage());
                }
            }
        }
        

        return newAccount.Id;
    }

    public static List<SearchResultWrapperMVN> parseSearchResults(String searchResultsString){
        List<SearchResultWrapperMVN> results = new List<SearchResultWrapperMVN>();

        Dom.Document doc = new Dom.Document();
        doc.load(searchResultsString.replaceAll('&', '&amp;'));

        Dom.XmlNode root = doc.getRootElement();

        checkForErrors(root);

        Dom.XmlNode generalInfo = root.getChildElement('generalInfo', null);

        if(generalInfo != null){
    
            Integer resultCount = Integer.valueOf(root.getChildElement('generalInfo', null).getChildElement('matchResult', null).getText());

            if(resultCount > 0){
                try{
                    Dom.XmlNode hcps = root.getChildElement('hcps', null);

                    for(Dom.XmlNode hcp : hcps.getChildElements()){

                        Dom.XmlNode cityZipStates = hcp.getChildElement('cityZipStates', null);
                        for(Dom.XmlNode cityZipState : cityZipStates.getChildren()){
                            SearchResultWrapperMVN result = new SearchResultWrapperMVN();

                            result.city = cityZipState.getChildElement('city', null).getText();
                            result.state = cityZipState.getChildElement('stateCode', null).getText();
                            result.zip5 = cityZipState.getChildElement('zip5', null).getText();

                            result.hceId = hcp.getChildElement('hceId', null).getText();
                            result.firstName = hcp.getChildElement('firstName', null).getText();
                            result.lastName = hcp.getChildElement('lastName', null).getText();
                            result.middleName = hcp.getChildElement('middleName', null).getText();
                            result.suffix = hcp.getChildElement('suffix', null).getText();
                            result.genderCode = hcp.getChildElement('genderCode', null).getText();


                            List<Dom.XmlNode> professions = hcp.getChildElement('professions', null).getChildren();
                            if(professions != null && professions.size() > 0){
                                result.specialty = professions[0].getChildElement('specialties', null).getChildren()[0].getChildElement('specDesc', null).getText();
                                result.professionalDesc = professions[0].getChildElement('profDesc', null).getText();
                            }

                            List<Dom.XmlNode> deas = hcp.getChildElement('deas', null).getChildren();
                            for(Dom.XmlNode dea : deas){
                                //Dom.XmlNode dea = deas[0].getChildElement('dea', null);
                                //if(dea != null){
                                    result.deaNum = dea.getText();
                                //}
                            }

                            List<Dom.XmlNode> externalIds = hcp.getChildElement('externalIds', null).getChildren();
                            for(Dom.XmlNode externalId : externalIds){
                                if(externalId.getChildElement('type', null).getText() == 'NPI'){
                                    result.npiNum = externalId.getChildElement('id', null).getText();
                                }
                            }

                            results.add(result);
                        }
                    }
                } catch(Exception e){
                    System.debug('There was an error parsing the search results: ' + e.getLineNumber() + ': ' + e.getMessage());
                }
            }
        }
        

        return results;
    }

    public static void parseLicenseResult(String searchResultsString, Id accountId){
        Dom.Document doc = new Dom.Document();
        doc.load(searchResultsString.replaceAll('&', '&amp;'));

        Dom.XmlNode root = doc.getRootElement();

        checkForErrors(root);

        Dom.XmlNode generalInfo = root.getChildElement('generalInfo', null);

        if(generalInfo != null){
    
            Integer resultCount = Integer.valueOf(root.getChildElement('generalInfo', null).getChildElement('matchResult', null).getText());

            if(resultCount > 0){
                try{
                    Dom.XmlNode hcpLicenses = root.getChildElement('hcpLicenses', null);

                    List<State_License__c> licensesToInsert = new List<State_License__c>();
                   
                    for(Dom.XmlNode license : hcpLicenses.getChildElements()){
                        State_License__c newLicense = new State_License__c();
                        newLicense.Prescribers__c = accountId;
                        newLicense.Name = license.getChildELement('number', null).getText();
                        newLicense.SLNProfession_Code__c = license.getChildElement('professionCode', null).getText();
                        newLicense.SLN_State__c = license.getChildElement('stateCode', null).getText();
                        newLicense.SLN_Expiration_Date__c = getDate(license.getChildElement('expDate', null).getText());
                        newLicense.SLN_Profession_Description__c = license.getChildElement('certDesc', null).getText();

                        licensesToInsert.add(newLicense);
                    }

                    if(!licensesToInsert.isEmpty()){
                        insert licensesToInsert;
                    }
                } catch(Exception e){
                    System.debug('There was an error parsing the license results: ' + e.getLineNumber() + ': ' + e.getMessage());
                }
            }
        }
    }

    public static void checkForErrors(Dom.XmlNode dom){
        Dom.XmlNode errorMessages = dom.getChildElement('errorMessages', null);

        if(errorMessages != null && !errorMessages.getChildElements().isEmpty()){
            String errorCode = errorMessages.getChildElements()[0].getChildElement('id', null).getText();
            String errorMessage = errorMessages.getChildElements()[0].getChildElement('desc', null).getText();

            throw new ImsSearchException(errorMessage);

        }
    }


    public static Dom.XmlNode getClientCredentials(Dom.XmlNode clientCredentials){
        String orgInstance = '';
        Organization org = [select Id, IsSandbox from Organization limit 1];

        if(org.IsSandbox){
            orgInstance = 'Sandbox';
        } else {
            orgInstance = 'Production';
        }

        IMS_Health_Settings__mdt settings = [select Id, Client_Id__c, App_Id__c, Password__c from IMS_Health_Settings__mdt where DeveloperName = :orgInstance];

        Dom.XmlNode clientId = clientCredentials.addChildElement('clientId', null, null);
        clientId.addTextNode(settings.Client_Id__c);

        Dom.XmlNode appId = clientCredentials.addChildElement('appId', null, null);
        appId.addTextNode(settings.App_Id__c);

        Dom.XmlNode userName = clientCredentials.addChildElement('userName', null, null);
        userName.addTextNode('Dexcom_' + orgInstance);

        Dom.XmlNode password = clientCredentials.addChildElement('password', null, null);
        password.addTextNode(settings.Password__c);

        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));

        Dom.XmlNode clientReqId = clientCredentials.addChildElement('clientReqId', null, null);
        String randomReqId = String.valueOf((Math.random() * 1000).intValue());
        clientReqId.addTextNode(randomReqId);
        System.debug(randomReqId);
        return clientCredentials;
    }

    public static Date getDate(String dateString){
        List<String> dateArray = dateString.split('/');

        if(dateArray.size() == 3){
            return Date.newInstance(Integer.valueOf(dateArray[2]), Integer.valueOf(dateArray[0]), Integer.valueOf(dateArray[1]));
        } else {
            return null;
        }
    }

    public static String getPhoneString(String phone){
        String formattedPhone = phone;
        if(phone.length() == 10){
            formattedPhone = '(' + phone.substring(0, 3) + ') ' + phone.subString(3, 6) + '-' + phone.substring(6);
        }

        return formattedPhone;
    }

}