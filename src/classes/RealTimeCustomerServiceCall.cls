public with sharing class RealTimeCustomerServiceCall {
    public static map<String, String> getCalloutResponseContents(String endpoint, String reqBody) {
        map<String, String> results;   
        try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            system.debug('endpoint***' + endpoint);
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setbody(reqBody);
            req.setTimeout(20000);
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
                    if(results.get('PartyId')!=null){
                        System.debug('=========================result==>>>>>>>>>>>>>>>>>>>>> ' + results);
                    }else{
                        System.debug('No Party Id Found.');
                    }
                    
                    if(results.get('AccountNumber')!=null){
                        System.debug('=========================result==>>>>>>>>>>>>>>>>>>>>> ' + results);
                    }else{
                        System.debug('No Account Number Found.');
                    }
                    
                }else{
                    System.debug('===========================>>>>>>>>>>>>>>>>>>>>> ' + results.get('Message'));
                }
            }else{
                System.debug('==== No Results Were Found ====');
                results = new map<String, String>();
                results.put('STATUS', res.getStatus());
            }
        }catch(Exception e){
            System.debug('ERROR:'+e.getMessage());
        }
        return results;
    }
}