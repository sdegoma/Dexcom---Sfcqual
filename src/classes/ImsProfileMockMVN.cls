@isTest
public class ImsProfileMockMVN implements WebServiceMock {
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

        IMSHealthUACC.GetHCPProfileV2Response_element respElement = 
           new IMSHealthUACC.GetHCPProfileV2Response_element();
        respElement.GetHCPProfileV2Result = 'Mock response';
        response.put('response_x', respElement); 
   }
}