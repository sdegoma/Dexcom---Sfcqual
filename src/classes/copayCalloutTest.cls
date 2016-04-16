/****************************************************
 * @author      : Hilario Galindez
 * @date        : Dec 23, 2015
 * @description : Test Class For copayCallOut
****************************************************/

@isTest
    Global class copayCalloutTest implements HttpCalloutMock{
     static String reqBody = '{"AccountNumber":"622179","OrderTotalPrice":"100", "Benefits":{"CopayAmount":"10","IndividualDeductable":"20", "IndividualMet":"30","FamilyDeductable":"40","FamilyMet":"50","Coverage":"30"}}';
     global HTTPResponse respond(HTTPRequest req) {
           //System.assertEquals('http://api.salesforce.com/1/1', req.getEndpoint());
            //System.assertEquals('GET', req.getMethod());
            system.debug('*******ENDPOINT************'+req.getEndpoint());
            HttpResponse res = new HttpResponse();
            if(req.getEndpoint() == 'http://api.salesforce.com/1/1'){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"CopayPrice":1,"ResponseCode":"1","TestCLASS":"OK"}');
                res.setStatusCode(200);
                res.setStatus('OK');
            }else if(req.getEndpoint() == 'http://api.salesforce.com/2/2'){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"CopayPrice":null,"ResponseCode":"1","TestCLASS":"OK"}');
                res.setStatusCode(200);
                res.setStatus('OK');
            }else if(req.getEndpoint() == 'http://api.salesforce.com/3/3'){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"CopayPrice":1,"ResponseCode":"0","TestCLASS":"OK"}');
                res.setStatusCode(200);
                res.setStatus('OK');
            }else if(req.getEndpoint() == 'http://api.salesforce.com/4/4'){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"CopayPrice":1,"ResponseCode":"1","TestCLASS":"OK"}');
                res.setStatusCode(200);
                res.setStatus('ERROR');
            }else if(req.getEndpoint() == 'http://api.salesforce.com/5/5'){
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"CopayPrice":1,"ResponseCode":"1","TestCLASS":"OK"}');
                res.setStatusCode(200);
                res.setStatus('ERROR');
            }else{
                system.debug('***INSIDE ELSE');
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"CopayPrice":1,"ResponseCode":"1","TestCLASS":"OK"}');
                res.setStatusCode(200);
                res.setStatus('OK');
            }
            return res;

        }
        
        Private static testmethod void testCalloutSuccess() {
            Test.setMock(HttpCalloutMock.class, new copayCalloutTest());    
            map<string,string> res = CopayServiceCall.getCalloutResponseContents('http://api.salesforce.com/1/1', reqBody);        
            System.assertEquals(res.get('CopayPrice'),'1');
        }
        
        Private static testmethod  void testCalloutNullCopay() {
            Test.setMock(HttpCalloutMock.class, new copayCalloutTest());    
            map<string,string> res = CopayServiceCall.getCalloutResponseContents('http://api.salesforce.com/2/2', reqBody);        
            System.assertEquals(res.get('ResponseCode'),'1');
        }
        
        Private static testmethod  void testCalloutMsgFail() {
            Test.setMock(HttpCalloutMock.class, new copayCalloutTest());    
            map<string,string> res = CopayServiceCall.getCalloutResponseContents('http://api.salesforce.com/3/3', reqBody);        
            System.assertEquals(res.get('ResponseCode'),'0');
        }
        
        Private static testmethod  void testCalloutStatusError() {
            Test.setMock(HttpCalloutMock.class, new copayCalloutTest());    
            map<string,string> res = CopayServiceCall.getCalloutResponseContents('http://api.salesforce.com/4/4', reqBody);        
            System.assertEquals(res.get('STATUS'),'ERROR');
        }
        Private static testmethod  void testCalloutF4() {
            Test.setMock(HttpCalloutMock.class, new copayCalloutTest());    
            map<string,string> res = CopayServiceCall.getCalloutResponseContents('http://api.salesforce.com/5/5', reqBody);        
            System.assertEquals(res.get('CopayPrice'),null);
        }
    }