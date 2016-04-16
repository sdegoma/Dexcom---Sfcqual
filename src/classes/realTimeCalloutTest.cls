@isTest
    Global class realTimeCalloutTest implements HttpCalloutMock{
     
     global HTTPResponse respond(HTTPRequest req) {
            system.debug('***req = ' + req.getBody());
            map<String, String> results = (map<String, String>)JSON.deserialize(req.getBody(), map<String, String>.class);
            System.assertEquals('GET', req.getMethod());
            system.debug('*******ENDPOINT************'+req.getEndpoint());
            HttpResponse res = new HttpResponse();
            if(results.get('LastName') == 'Test Account Name0'){
                res.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length',String.valueof(req.getBody().length()));
                res.setBody('{"AccountNumber":"1","PartyId":"1","Message":"OK","ResponseCode":"1"}');
                res.setStatusCode(200);
                res.setStatus('OK');
            }
            else if(results.get('LastName') == 'Test Account Name2'){
                res.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length',String.valueof(req.getBody().length()));
                res.setBody('{"PartyId":"3","AccountNumber":"3","ResponseCode":"0","Message":"OK"}');
                res.setStatusCode(200);
                res.setStatus('OK');
            }
            else if(results.get('LastName') == 'Test Account Name3'){
                res.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length',String.valueof(req.getBody().length()));
                res.setBody('');
                res.setStatusCode(200);
                res.setStatus('OK');
            }
            else if(results.get('LastName') == 'Test Account Name4'){
                res.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length',String.valueof(req.getBody().length()));
                res.setBody('{"PartyId":"","AccountNumber":"","ResponseCode":"0","Message":""}');
                res.setStatusCode(200);
                res.setStatus('ERROR');
            }
            else if(results.get('LastName') == 'Test Account Name5'){
                res.setHeader('Content-Type', 'application/json');
                req.setHeader('Content-Length',String.valueof(req.getBody().length()));
                res.setBody('{"PartyId":"5","AccountNumber":"5","ResponseCode":"0","Message":""}');
                res.setStatusCode(200);
                res.setStatus('ERROR');
            }
            
            return res;
     }
}