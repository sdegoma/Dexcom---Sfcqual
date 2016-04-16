/***************************************
 * @author      : Noy De Goma
 * @date        : FEB 08, 2015
 * @description : Class to invoke webservice that calculates tax amount
***************************************/
public class TaxServiceCall {
    public static map<String, String> getCalloutResponseContents(String url) {
        try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            //req.setTimeout(2000);
            HttpResponse res = h.send(req);
            System.debug(res.toString());
            System.debug('STATUS:'+res.getStatus());
            System.debug('STATUS_CODE:'+res.getStatusCode()); 
            System.debug('BODY:'+res.getBody());  
            map<String, String> results;    
            if (res.getStatus() == 'OK'){
                results = (map<String, String>)JSON.deserialize(res.getBody(), map<String, String>.class);
                if(results.get('ResponseCode') == '1'){
                    if(results.get('TaxAmount')!=null){
                        System.debug('=========================result==>>>>>>>>>>>>>>>>>>>>> ' + results);
                        return results;
                    }else{
                        System.debug('No TaxAmount Found.');
                        return results;
                    }
                }else{
                    System.debug('===========================>>>>>>>>>>>>>>>>>>>>> ' + results.get('Message'));
                    return results;
                }
            }else{
                System.debug('==== No Results Were Found ====');
                results = new map<String, String>();
                results.put('STATUS', res.getStatus());
                return results;
            }
        }catch(Exception e){
            System.debug('ERROR:'+e.getMessage());
        }
        return null;
    }
}