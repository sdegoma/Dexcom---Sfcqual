@isTest
public class ImsLicenseMockMVN implements WebServiceMock {
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

        IMSHealthUACC.GetHCPLicenseDatav2Response_element respElement = 
           new IMSHealthUACC.GetHCPLicenseDatav2Response_element();
        respElement.GetHCPLicenseDatav2Result = 'Mock response';
        response.put('response_x', respElement); 
   }
}