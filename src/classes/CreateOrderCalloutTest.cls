@isTest
Global class CreateOrderCalloutTest implements HttpCalloutMock{
     
     global HTTPResponse respond(HTTPRequest req) {
            system.debug('***req = ' + req.getBody());
            // System.assertEquals('POST', req.getMethod());
            system.debug('*******ENDPOINT************'+req.getEndpoint());
            HttpResponse res = new HttpResponse();
            if(req.getBody() == '{"UserName":"null","AccountNumber":"null","ShippingMethod":"ship to","SignatureRequired":"Y","ScheduledShipDate":"03/17/2016","ShippingAddressId":"1234","ShippingNotes":"null","PriceListId":"null","WaiveShippingCharge":"Y","TaxExempt":"Y","OrderLines":[]}'){
                res.setHeader('Content-Length','0');
                res.setBody('{"HeaderId":"4933373", "Message":"null", "OrderNumber":"1171904", "ResponseCode":"1"}');
                res.setStatusCode(200);
                res.setStatus('OK');
             }else if(req.getBody() == '{"UserName":"","AccountNumber":"","SignatureRequired":"Y","ScheduledShipDate":"03/17/2016","ShippingAddressId":"1234","ShippingNotes":"null","PriceListId":"null","OrderLines":[{"SKU":"Test Product1","Quantity":"1"}]}'){
                res.setHeader('Content-Length','0');
                res.setBody('{ "Message":"Error"}');
                res.setStatusCode(404);
                res.setStatus('ERROR');
             }else{
                res.setHeader('Content-Length','0');
                res.setStatusCode(200);
                res.setStatus('ERROR');
            }
            return res;
     }
}