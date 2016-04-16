public with sharing class CreateOrderServiceCall {
    public static map<String, String> getCalloutResponseContents(String endpoint, String reqBody){
        map<String, String> results;   
        try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            system.debug('endpointCreateOrder***' + endpoint);
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setbody(reqBody);
            req.setTimeout(120000);
            req.setHeader('User-Agent', 'Fiddler');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Content-Length',String.valueof(reqBody.length()));
            System.debug('***\n req = ' + req + '\n');
            HttpResponse res = h.send(req);
            System.debug(res.toString());
            System.debug('STATUS:'+res.getStatus());
            System.debug('STATUS_CODE:'+res.getStatusCode()); 
            System.debug('BODY:'+res.getBody()); 
            
            if(res.getStatus() == 'OK'){
                results = (map<String, String>)JSON.deserialize(res.getBody(), map<String, String>.class);
                if(results.get('ResponseCode') == '1'){
                
                }else{
                    System.debug('===========================>>>>>>>>>>>>>>>>>>>>>CreateOrder ' + results.get('Message'));
                }
            }else{
                System.debug('==== No Results Were Found ====');
                results = new map<String, String>();
                results.put('STATUS', res.getStatus());
            }
        }catch(Exception e){
            System.debug('EXCEPTION IN CALLOUT:'+e.getMessage());
        }
        return results;
    }
}