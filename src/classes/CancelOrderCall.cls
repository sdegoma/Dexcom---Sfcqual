global with sharing class CancelOrderCall{
    webservice static String cancelOrderRequest(String oracleUserId, String orderId, String caseReason) {
        String err = '';
        System.debug('\n\n************Case Reason************** ' + caseReason);
        try{
            String reason = caseReason.substringAfterLast('-');
            //reason = reason.replace('+','%20');
            System.debug('\n\n************orderId************** ' + orderId);
            System.debug('\n\n************reason************** ' + reason);
            cancelOrderUrl__c cancelUrl = cancelOrderUrl__c.getOrgDefaults();
            String url = cancelUrl.URL__c+oracleUserId+'/'+orderId+'/'+reason;
            System.debug('\n\n************URL************** ' + url);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('POST');
            /*req.setBody('{'
                            +'"Reason":"'+reason+
                        '"}');*/
            req.setHeader('Content-Length', '0');
            HttpResponse res = h.send(req);
            map<String, String> results =  new map <String, String>();    
            
            if (res.getStatus() == 'OK'){
                results = (map<String, String>)JSON.deserialize(res.getBody(), map<String, String>.class);
                if(results.get('ResponseCode') == '1'){
                    System.debug('\n\n********** ResponseCode 1 ************ ' + results);
                    list <Opportunity> oppToUpdate = [SELECT Id, Order_NUM__c FROM Opportunity WHERE Order_NUM__c = :orderId];
                    if(!oppToUpdate.isEmpty()){
                        for(Opportunity opp : oppToUpdate){
                            opp.Order_NUM__c = null;
                        }
                        update oppToUpdate;
                    }
                    return results.get('Message');
                }else{
                    System.debug('\n\n********** ResponseCode 0 ************ ' + results);
                    err = 'Error in calling webservice: ' + (results.get('Message') == 'null' ? '' : results.get('Message'));
                }
            }else{
                //if(String.valueOf(res.getStatusCode()) == '404'){
                    results.put('STATUS', res.getStatus());
                    System.debug('\n\n********** StatusCode 404 ************ ' + results);
                    err = 'Error in calling webservice: ' + res.getStatus();
                /*}else if(String.valueOf(res.getStatusCode()) == '400'){
                    results.put('STATUS', res.getStatus());
                    System.debug('\n\n********** StatusCode 400 ************ ' + results);
                    err = 'Error in calling webservice: ' + res.getStatus();
                }*/
            }
        }catch(Exception e){
            err = 'Error in calling webservice.';
            System.debug('ERROR:'+e.getMessage());
        }
        return err;
    }
    
}