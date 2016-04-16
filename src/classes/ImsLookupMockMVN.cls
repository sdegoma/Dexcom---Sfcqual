@isTest
public class ImsLookupMockMVN implements WebServiceMock {
   public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        IMSHealthUACC.LookupHCPV2Response_element respElement = 
           new IMSHealthUACC.LookupHCPV2Response_element();
        respElement.LookupHCPV2Result = '<?xml version="1.0" encoding="UTF-8"?>'+
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
        response.put('response_x', respElement); 
   }
}