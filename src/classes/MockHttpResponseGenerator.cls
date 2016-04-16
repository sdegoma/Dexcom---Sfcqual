global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
    	HttpResponse res = new HttpResponse();
        if(req.getEndpoint() == 'https://dexsfd.dexcom.com/api/orders/cancelorder/ORAC/12345/TEST'){
        	//res.setHeader('Content-Type', 'application/json');
        	res.setHeader('Content-Length', '0');
        	res.setStatus('OK');
        	res.setStatusCode(200);
        	res.setBody('{"ResponseCode":1,"Message":"Success"}');
        }else if(req.getEndpoint() == 'https://dexsfd.dexcom.com/api/orders/cancelorder/ORAC/12346/TEST%20TEST'){
        	//res.setHeader('Content-Type', 'application/json');
        	res.setHeader('Content-Length', '0');
        	res.setStatus('OK');
        	res.setStatusCode(200);
        	res.setBody('{"ResponseCode":0,"Message":"Failed"}');
        }else if(req.getEndpoint() == 'https://dexsfd.dexcom.com/api/orders/cancelorder/ORAC/qwerty/TEST'){
        	//res.setHeader('Content-Type', 'application/json');
        	res.setHeader('Content-Length', '0');
        	res.setStatus('Not Found');
        	res.setStatusCode(404);
        }else if(req.getEndpoint() == 'https://dexsfd.dexcom.com/api/orders/calculatetax/1234/100.00/Test/Test/Test/1'){
        	res.setHeader('Content-Type', 'application/json');
        	res.setStatus('OK');
        	res.setStatusCode(200);
        	res.setBody('{"TaxAmount":24.3685,"ResponseCode":"1","Message":"null"}');
        }else if(req.getEndpoint() == 'https://dexsfd.dexcom.com/api/orders/calculatetax/1234/100.00/Test/Test/Test/2'){
        	res.setHeader('Content-Type', 'application/json');
        	res.setStatus('OK');
        	res.setStatusCode(200);
        	res.setBody('{"TaxAmount":"0.00","ResponseCode":"1","Message":"Failed"}');
        }else if(req.getEndpoint() == 'https://dexsfd.dexcom.com/api/orders/calculatetax/1234/100.00/Test/Test/Test/3'){
        	res.setHeader('Content-Type', 'application/json');
        	res.setStatus('OK');
        	res.setStatusCode(200);
        	res.setBody('{"ResponseCode":"0","Message":"Failed"}');
        }
        else if(req.getEndpoint() == 'https://dexsfd.dexcom.com/api/orders/calculatetax/1234/100.00/Test/Test/Test/4'){
        	res.setHeader('Content-Type', 'application/json');
        	res.setStatus('Not Found');
        	res.setStatusCode(404);
        }else if(req.getEndpoint() == 'https://dexsfd.dexcom.com/api/orders/calculatetax/1234/100.00/Test/Test/Test/5'){
        	res.setHeader('Content-Type', 'application/json');
        	res.setStatus('OK');
        	res.setStatusCode(200);
        	res.setBody('{"TaxAmount":"-1.0","ResponseCode":"1","Message":"Failed"}');
        }
        
        return res;
    }
}